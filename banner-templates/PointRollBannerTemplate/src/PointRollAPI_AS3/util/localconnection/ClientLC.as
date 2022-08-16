package PointRollAPI_AS3.util.localconnection 
{
	import PointRollAPI_AS3.events.net.PrLocalConnectEvent;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;

	/**
	 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.HANDSHAKE_FAILED
	 */
	[Event(name = "handshakeFailed", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.SEND_SUCCESS
	 */
	[Event(name = "sendSuccess", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.SEND_FAILURE
	 */
	[Event(name = "sendFailure", type = "PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
	
	/**
	* Local connections used in creating synched ads are now managed using the HostLC and ClientLC classes. This new host/client approach improves 
	* performance by reducing the failure rate of communication between SWFs after establishing a connection. A HostLC object is instantiated in one of the two communicating files, and the ClientLC in the other. Both objects must reference 
	* the same connection name. The HostLC will attempt to establish a connection with the ClientLC. If this connection is established within the time 
	* specified (10 seconds by default), the HostLC will broadcast a <code>HANDSHAKE_COMPLETE</code> event, enabling both the host and client to 
	* send and receive data.
	* A local connection between two SWFs is created by doing the following:
	* <ol><li>Instantiate a HostLC object in one file, and a ClientLC object in the other, passing in the connection name (must be the same in both objects). </li>
	* <li>Listen for the <code>HANDSHAKE_COMPLETE</code> event on the HostLC object.</li>
	* <li>Declare any necessary functions to be called remotely.</li>
	* <li>Perform remote function calls between the two files using the <code>send()</code> method.</li></ol>
	* @author Chris Deely - PointRoll
	* @see HostLC
	* @includeExample ../../../examples/PrLocalConnect/HostLC.txt -noswf
	* @includeExample ../../../examples/PrLocalConnect/ClientLC.txt -noswf
	*/
	public class ClientLC extends EventDispatcher
	{
		private var _initLC:LocalConnection;
		private var _productionLC:LocalConnection;
		private var _hostToken:String;
		private var _slaveToken:String;
		private var _currentFunction:String;
		private var _handshakeTimer:Timer;
		
		/**
		 * Constructor for the ClientLC class. Upon receiving the remote call from the HostLC object, the ClientLC object will alert the HostLC, which will 
		 * fire the <code>HANDSHAKE_COMPLETE</code> event, enabling both objects to send and receive data.
		 * @param	initialName Name to give the connection. The HostLC object must reference this same connection.
		 * @param	scope The object on which callback functions are invoked. By default, it is set to <code>this</code>--the ClientLC instance being 
		 * created--but can be set to another object on which to invoke callback methods.
		 * @param	timeOut Time in milliseconds to wait before firing the <code>HANDSHAKE_FAILED</code> event when a connection with the ClientLC object is 
		 * not established by the HostLC object. This is set to 10000 by default.
		 */
		public function ClientLC( initialName:String, scope:Object, timeOut:Number=10000) 
		{
			_handshakeTimer = new Timer(timeOut);
			_handshakeTimer.addEventListener(TimerEvent.TIMER, _signalHandshakeFailure, false, 0, true);
			_handshakeTimer.start();
			
			_initLC = new LocalConnection();
			_initLC.allowDomain("*");
			_initLC.client = this;
			
			_productionLC = new LocalConnection();
			_productionLC.allowDomain("*");
			_productionLC.client = scope;
			
			try{
				_initLC.connect("_" + initialName);
			}catch(e:Error){
				dispatchEvent(new Event("connectError"));
			}
		}
		
		/**
		 * Sends a command to a remote SWF.  This remote function can only be called after the HostLC establishes a connection with the ClientLC and 
		 * fires the <code>HANDSHAKE_COMPLETE</code> event. If the remote SWF receives the command, a <code>SEND_SUCCESS</code> will be fired; if the 
		 * command fails to send, a <code>SEND_FAILURE</code> event will be fired.
		 * @param	methodName The name of the remote function to call.
		 * @param	...rest Optional parameters to pass to the remote function, separated by commas.
		 * @see event:handshakeComplete
		 * @see event:sendFailure
		 * @see event:sendSuccess
		 */
		public function send( functionName:String, ...rest):void
		{
			_currentFunction = functionName;
			rest.unshift(functionName);
			rest.unshift(_hostToken);
			_productionLC.send.apply(_productionLC, rest);
		}
		
		/**
		 * Closes the current LocalConnection.  After this command is issued, you must create new HostLC and ClientLC objects if you wish 
		 * to execute or receive any more LocalConnection calls.
		 */
		public function close():void
		{
			try
			{
				_productionLC.close();
			}catch (e:Error)
			{
				PrDebug.PrTrace("Cannot close LC; it has not been opened.", 4, "ClientLC");
			}
		}
		
		/**
		 * Fired after a timeout of the handshake
		 */
		private function _signalHandshakeFailure(e:TimerEvent):void 
		{
			_killTimer();
			
			_initLC.removeEventListener(StatusEvent.STATUS, _initStatus);
			_initLC.addEventListener(StatusEvent.STATUS, _discardStatus, false, 0, true);
			_initLC = null;
			
			_productionLC.removeEventListener(StatusEvent.STATUS, _prodStatus);
			_productionLC = null;
			
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.HANDSHAKE_FAILED));
		}
		/**
		 * Destroys the handshake timer
		 */
		private function _killTimer():void
		{
			_handshakeTimer.removeEventListener(TimerEvent.TIMER, _signalHandshakeFailure);
			_handshakeTimer.stop();
			_handshakeTimer = null;
		}		

		/**
		 * @private
		 * Remote call executed by the host to set the tokens for this session
		 * @param	host HostLC's token
		 * @param	client ClientLC's token
		 */
		public function _receiveTokens( host:String, client:String ):void
		{
			PrDebug.PrTrace("Client received tokens: " + arguments, 5, "ClientLC");
			_killTimer();
			_initLC.close();
			_hostToken = host;
			_slaveToken = client;
			
			try{
				_productionLC.connect(_slaveToken);
			}catch(e:Error){
				dispatchEvent(new Event("connectError"));
			}
			
			_initLC.addEventListener(StatusEvent.STATUS, _initStatus, false, 0, true);
			_initLC.send(_hostToken, "_clientIsReady");
		}
		/** Status handler for the initialization LC */
		private function _initStatus(e:StatusEvent):void 
		{
			if ( e.level != 'status')
			{
				PrDebug.PrTrace("Client is ready: "+_hostToken+", "+_slaveToken,5,"ClientLC");
				_initLC.send( _hostToken, "_clientIsReady");
			}else
			{
				_initLC.removeEventListener(StatusEvent.STATUS, _initStatus);
				_productionLC.addEventListener(StatusEvent.STATUS, _prodStatus, false, 0, true);
			}
		}
		
		/**
		 * Because of the asynchronous nature of the status event, we may get one or two extraneous responses. 
		 * This handles those, preventing errors.
		 */
		private function _discardStatus(e:StatusEvent):void 
		{
			PrDebug.PrTrace("discard status event",5,"ClientLC");
		}
		
		/** Status handler for the production LC */
		private function _prodStatus(e:StatusEvent):void 
		{
			if ( e.level == 'status' )
			{
				dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.SEND_SUCCESS, _currentFunction));
			}else
			{
				dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.SEND_FAILURE, _currentFunction));
			}
		}
	}
	
}