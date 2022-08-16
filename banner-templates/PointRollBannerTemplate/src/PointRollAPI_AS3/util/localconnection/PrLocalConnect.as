package PointRollAPI_AS3.util.localconnection 
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.events.net.PrLocalConnectEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

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
	* The PrLocalConnect class helps to manage local connections used to create synched ads.  Objects created with this class automatically 
	* employ channel randomization to prevent cross-browser and cross-tab communication.
	* @author Chris Deely - PointRoll
	*/
	public dynamic class PrLocalConnect extends EventDispatcher {
		
		
		
		/**
		 * Time in milliseconds to wait before signaling a failure when a send command does not succeed.
		 * @see #send()
		 * @see #retryInterval
		 */
		public var timeOut:Number = 10000;
		/** Number of milliseconds to wait before retrying a failed send command
		 * @see #send()
		 * @see #event:failure
		 */
		public var retryInterval:Number = 250;
		/**
		 * Determines whether the connection should use channel name randomization. By default, the PrLocalConnect class appends a 
		 * random number to all LocalConnection channel names.  This prevents unintended communication between two ads 
		 * running on different pages.
		 * 
		 * <p>Many users now view web content using multiple browser windows or tabs. This causes issues for synched ads 
		 * as they could inadvertantly communicate with the same ad running in a different tab.  The PrLocalConnect class 
		 * solves this issue by automatically randomizing the name of each channel.</p>
		 * 
		 * <p>In some situations, you may want to forgo this randomization and leave the channel names as defined by the designer. 
		 * This can be accomplished by setting the <code>useRandomization</code> property to <code>false</code>.</p>
		 * 
		 * <p><strong>Important Note:</strong> This setting must be the same on both PrLocalConnect objects in order for communication 
		 * to be successfull.</p>
		 */
		public var useRandomization:Boolean = true;
		/**
		 * Indicates the object on which callback methods are invoked. The default object is the PrLocalConnect being created. 
		 * If left as the default, you must create all callback functions as methods of this object.
		 * You can set the client property to another object, and callback methods are invoked on that other object. 
		 */
		public var client:Object;
		
		private var m_nKeepAlive:Number = 5000;
		/** The name of this object's receiving channel */
		public var localChannel:String;
		/** The name of the remote LocalConnection you wish to contact */
		public var remoteChannel:String;
		
		private var m_oConnectionManager:ConnectionManager;
		private var m_bHandshakeComplete:Boolean = false;
		private var m_oPendingSend:Object;
		
		/**
		 * Creates a new PrLocalConnect object
		 * @param localChannel The name of this object's receiving channel
		 * @param remoteChannel The name of the remote LocalConnection you wish to contact
		 */
		public function PrLocalConnect( localChannel:String, remoteChannel:String) {
			this.localChannel = localChannel;
			this.remoteChannel = remoteChannel;
			client = this;
			if ( StateManager.root )
			{
				StateManager.addEventListener(StateManager.KILL, _killCommandHandler, false, 0, true);
			}
		}
		/**
		 * The initialize method creates a connection between two PrLocalConnect objects.  This method must be called before any commands can 
		 * be sent or received.
		 */		
		public function initialize():void
		{
			m_bHandshakeComplete = false;
			try{m_oConnectionManager = null;}catch(e:Error){}
			m_oConnectionManager = new ConnectionManager();
			m_oConnectionManager.useRandomization = useRandomization;
			m_oConnectionManager.timeOut = timeOut;
			_setListeners();
			m_oConnectionManager.initConnection( localChannel, remoteChannel, client );
		}
		
		/**
		 * Sends a command to a remote SWF.  If the connection has not yet been initialized, this method will call <code>initialize()</code> before proceeding.
		 * @param	methodName The name of the remote function to call
		 * @param	...params Optional parameters to pass to the remote function, separated by commas
		 */
		public function send( methodName:String, ...params):void
		{
			var args:Array = new Array();
			args.push(methodName);
			for (var i:uint = 0; i < params.length; i++)
			{
				args.push(params[i]);
			}
			if ( !handshakeComplete )
			{
				m_oPendingSend = args;
				initialize()
			}else {
				//send communication
				m_oConnectionManager.send.apply(this, args) 
			}
		}
		/**
		 * Indicates whether or not the connection has been initialized
		 * @see #event:handshakeComplete
		 */
		public function get handshakeComplete():Boolean
		{
			return m_bHandshakeComplete;
		}
		
		/**
		 * Closes the current LocalConnection.  After this command is issued, you must call the <code>initialize()</code> method again if you wish 
		 * to execute or receive any more LocalConnection calls.
		 */
		public function close():void
		{
			StateManager.removeEventListener(StateManager.KILL, _killCommandHandler);
			m_oConnectionManager.close();
			m_oConnectionManager = null;
			m_bHandshakeComplete = false;
			m_oPendingSend = null;
		}
		
		private function _killCommandHandler(e:Event):void
		{
			close();
			if(client != this) {client = null;}
		}
		
		/** Time in milliseconds between "keep alive" pings.  If this value is greater than zero, the object will periodically send a 
		 * request to the remote SWF to ensure that both sides of the connection are still active.  If the communication fails, the DISCONNECTED event
		 * is fired.
		 * <p>This is most useful when performing communication between a banner and panel of a single ad unit.  Because the banner is persistent after the
		 * panel is closed by a user, you should listen for the DISCONNECTED event and reset the banner's connection using the <code>initialize()</code> method.
		 * @see #event:disconnected
		 * @see #initialize()
		 * 
		public function get keepAlive():Number { return m_nKeepAlive; }
		
		public function set keepAlive(value:Number):void {
			m_nKeepAlive = value;
			m_oConnectionManager.keepAlive = value;
		}
		*/
		
		/**
		 * Event handler for the HANDSHAKE_COMPLETE event
		 * @param	e
		 */
		private function _initialized(e:Event):void
		{
			m_bHandshakeComplete = true;
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.HANDSHAKE_COMPLETE));
			if ( m_oPendingSend )
			{
				send.apply(this, m_oPendingSend);
				m_oPendingSend = null;
			}
		}
		/**
		 * Establishes all listeners for the CommunicationManager
		 */
		private function _setListeners():void{
			m_oConnectionManager.addEventListener(PrLocalConnectEvent.HANDSHAKE_COMPLETE, _initialized, false,0,true);
			m_oConnectionManager.addEventListener(PrLocalConnectEvent.SUCCESS, _eventBubbler, false,0,true);
			m_oConnectionManager.addEventListener(PrLocalConnectEvent.FAILURE, _eventBubbler, false,0,true);
			m_oConnectionManager.addEventListener(PrLocalConnectEvent.CALL_RECEIVED, _eventBubbler, false,0,true);
		}
		/** Bubbles events up from this object */
		private function _eventBubbler(e:Event):void {
			dispatchEvent(e);
		}
	}
	
}