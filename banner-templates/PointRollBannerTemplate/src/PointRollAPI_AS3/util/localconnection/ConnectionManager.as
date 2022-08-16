package PointRollAPI_AS3.util.localconnection 
{
	import PointRollAPI_AS3.events.net.PrLocalConnectEvent;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.events.*;
	import flash.net.LocalConnection;
	import flash.utils.Timer;

	/**
	 * @private
	* Manages 'handshakes' for the PrLocalConnect class.  The ConnectionManager employs channel rendomization to prevent collisions between LCs
	* using the same channel name.
	* @author Chris Deely - PointRoll
	*/
	internal class ConnectionManager extends EventDispatcher{
		// Event MetaData
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.CALL_RECEIVED
		 */
		[Event(name = "callReceived", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.HANDSHAKE_COMPLETE
		 */
		[Event(name = "handshakeComplete", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.SUCCESS
		 */
		[Event(name = "success", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.FAILURE
		 */
		[Event(name = "failure", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.DISCONNECTED
		 */
		[Event(name = "disconnected", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
		
		public var timeOut:Number = 5000;
		public var retryInterval:Number = 250;
		
		/** @copyDoc PointRollAPI_AS3.util.localconnection.PrLocalConnect#useRandomization **/
		public var useRandomization:Boolean = true;
		
		private var m_sLocalChannel:String;
		private var m_sRemoteChannel:String;
		private var m_nRemoteToken:Number;
		private var m_nLocalToken:Number;
		private var m_LC:LocalConnection;
	
		private var m_RetryTimer:Timer;
		private var m_bSendReady:Boolean=false;
		private var m_bReceiveReady:Boolean = false;
		private var m_oClientProxy:ClientProxy;
		private var m_aPendingArgs:Array;
		private var m_DelayDispatch:Timer;
		
		//private var m_keepAliveLC:LocalConnection;
		//public var keepAlive:Number = 5000;
		//private var m_KeepAliveTimer:Timer;
		
		public function ConnectionManager() { }
		
		/**
		 * Initializes, or re-initializes, an exclusive LC connection.
		 * @param	local Name of the local receiving channel
		 * @param	remote Name of the remote LC
		 * @param	client The client to receive all function calls
		 */
		public function initConnection( local:String, remote:String, client:*):void
		{
			//the underscores ensure that we don't have to address the LC by using the domain name
			m_sRemoteChannel = "_"+remote;
			m_sLocalChannel = "_" + local;
			
			if (useRandomization)
			{
				m_nRemoteToken = Math.random();
			}else {
				m_nRemoteToken = 0;
			}
			
			//the client proxy captures incoming LC calls in order to dispatch an event
			m_oClientProxy = new ClientProxy(client);
			m_oClientProxy.addEventListener(PrLocalConnectEvent.CALL_RECEIVED, _eventBubbler,false,0,true);
			
			try {
				m_LC.close();
				m_LC.removeEventListener(StatusEvent.STATUS, _handshakeStatus);
				m_LC.removeEventListener(StatusEvent.STATUS, _onStatus);
				m_LC = null;
			}catch (e:Error) {}
			m_LC = new LocalConnection();
			m_LC.allowDomain("*");
			m_LC.addEventListener(StatusEvent.STATUS, _handshakeStatus,false,0,true);
			m_LC.client = this;
			
			//setup the retry timer - if we reach the timeOut point, the communication has failed
			m_RetryTimer = new Timer( retryInterval, Math.floor(timeOut/retryInterval) );
			m_RetryTimer.addEventListener(TimerEvent.TIMER, _sendHandshake,false,0,true);
			m_RetryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _failure,false,0,true);
			m_RetryTimer.start();
			
			PrDebug.PrTrace("Initiate Handshake from "+m_sLocalChannel+" to "+m_sRemoteChannel,3,"ConnectionManager");
			m_LC.connect( m_sLocalChannel );
			_sendHandshake();
			
		}
		
		public function getLC():LocalConnection
		{
			return m_LC;
		}
		public function send( methodName:String, ...params):void
		{
			//prepare an argument array for the LC send command: Connection Name, Method to call, ...optional arguments
			var args:Array = new Array();
			m_aPendingArgs = new Array();
			args.push( String(m_sRemoteChannel + m_nRemoteToken));
			args.push(methodName);
			m_aPendingArgs.push( methodName );
			for (var i:uint = 0; i < params.length; i++)
			{
				args.push(params[i]);
				m_aPendingArgs.push( params[i] );
			}
			m_RetryTimer.reset();
			m_RetryTimer.start();
			m_LC.send.apply(this, args);
		}
		
		public function close():void
		{
			try
			{ 
				m_LC.close();	
				m_LC = null;
			}catch (e:Error){ }
			try
			{
				m_RetryTimer.stop();
				m_RetryTimer = null;
			}catch (e:Error){ }
			try
			{
				m_DelayDispatch.stop();
				m_DelayDispatch = null;
			}catch (e:Error){ }
			
			m_oClientProxy = null;
		}
		
		private function _failure(e:TimerEvent):void 
		{
			m_RetryTimer.reset();
			PrDebug.PrTrace("LocalConnection Communication Failure",3,"ConnectionManager");
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.FAILURE));
		}
		
		private function _handshakeStatus(e:StatusEvent):void
		{
			if( e.level == 'status' )
			{
				m_LC.removeEventListener(StatusEvent.STATUS, _handshakeStatus);
				m_RetryTimer.removeEventListener(TimerEvent.TIMER, _sendHandshake);
				PrDebug.PrTrace("Handshake with " + m_sRemoteChannel + " was successful", 3, "ConnectionManager");
				
				m_RetryTimer.reset();
				//establish new handler
				m_RetryTimer.addEventListener(TimerEvent.TIMER, _retrySend, false, 0, true);

				_updateStatus('send');
			}
		}
		
		private function _retrySend(e:TimerEvent):void 
		{
			//a send command has timed out, attempt to send it again
			send.apply(this, m_aPendingArgs);
		}
		
		private function _onStatus(e:StatusEvent):void 
		{
			if ( e.level == 'status' )
			{
				try { 
					m_RetryTimer.reset();
				}catch (e:Error) {
					//no retry
				}
				dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.SUCCESS));
			}
		}
		
		/**
		 * As there are 2 sides of the communication, sending and receiving, this function allows us to monitor each seperately.
		 * When both sides are ready, signal Handshake complete
		 * @param	status
		 * @see #event:handshakeComplete
		 */
		private function _updateStatus( status:String ):void{
			if (status == 'send') {
				m_bSendReady = true;
			}else {
				m_bReceiveReady = true;
			}
			
			if (m_bSendReady && m_bReceiveReady)
			{
				m_LC = new LocalConnection();
				m_LC.allowDomain("*");
				m_LC.client = m_oClientProxy;
				m_LC.connect( String(m_sLocalChannel + m_nLocalToken));
				m_LC.addEventListener(StatusEvent.STATUS, _onStatus, false, 0, true);
				
				//A delay is necessary here because the sending LC gets notification of success before the receiving end
				m_DelayDispatch = new Timer(100);
				m_DelayDispatch.addEventListener(TimerEvent.TIMER, _delayDispatch, false, 0, true);
				m_DelayDispatch.start();

			}
		}
		
		private function _delayDispatch(e:TimerEvent):void 
		{
			m_DelayDispatch.removeEventListener(TimerEvent.TIMER, _delayDispatch);
			m_DelayDispatch.stop();
			m_DelayDispatch = null;
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.HANDSHAKE_COMPLETE));
		}
		
		private function _eventBubbler(e:Event):void {
			dispatchEvent(e);
		}
		private function _sendHandshake(...rest):void {
			
			PrDebug.PrTrace(m_sLocalChannel+" sending Handshake to "+m_sRemoteChannel,4,"ConnectionManager");
			m_LC.send(m_sRemoteChannel, "_prLCInitHandler", m_nRemoteToken);
		}
		
		public function _prLCInitHandler( localToken:String ):void
		{
			PrDebug.PrTrace(m_sLocalChannel+" received token "+localToken,5,"ConnectionManager");
			m_LC.close();
			m_nLocalToken = Number(localToken);
			_updateStatus('receive');
			
		}
	}
	
}