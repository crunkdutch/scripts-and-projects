package PointRollAPI_AS3.events.net 
{
	import flash.events.Event;

	/**
	 * Events dispatched by the HostLC and ClientLC classes.
	 * @see PointRollAPI_AS3.util.localconnection.HostLC
	 * @see PointRollAPI_AS3.util.localconnection.ClientLC
	 * @includeExample ../../../examples/PrLocalConnect/HostLC.txt -noswf
	 * @includeExample ../../../examples/PrLocalConnect/ClientLC.txt -noswf
	 */
	public class PrLocalConnectEvent extends Event{
		/**
		 * Event dispatched by the HostLC class when a connection has been established with the ClientLC object. Only the HostLC object can listen 
		 * for this event.
		 * @eventType handshakeComplete
		 * */
		public static const HANDSHAKE_COMPLETE:String = "handshake complete";
		/**
		 * Event dispatched by either LocalConnection object (HostLC, ClientLC) when the client fails to connect to the host.
		 * @eventType handshakeFailed
		 */
		public static const HANDSHAKE_FAILED:String = "handshake failed";
		/** Event dispatched when a <code>send()</code> call is successful.
		 * @eventType sendSuccess
		 * */
		public static const SEND_SUCCESS:String = "communication successful";
		/** Event dispatched when a <code>send()</code> call fails.
		 * @eventType sendFailure
		 * */
		public static const SEND_FAILURE:String = "communication failed";
		/** @private
		 * @eventType callReceived
		 */
		public static const CALL_RECEIVED:String = "remote call received";
		/** @private
		 * Event dispatched when a send command is successful
		 * @eventType success
		 * */
		public static const SUCCESS:String = "communication successful";
		/** @private
		 * Event dispatched when a handshake or send command fails
		 * @eventType failure
		 * */
		public static const FAILURE:String = "communication failed";
		
		/**
		 * This property is used as the target of the <code>SEND_SUCCESS</code> and <code>SEND_FAILURE</code> events, and will target the 
		 * sending function.
		 */
		public var calledFunction:String;
		
		/** @private */
		public function PrLocalConnectEvent(type:String, evtTarget:String=null){
			super(type);
			this.calledFunction = evtTarget;
		}
		/**
		 * @private 
		 * */
		public override function clone():Event{
			return new PrLocalConnectEvent(type, calledFunction);
		}
		/**
		 * @private 
		 * */
		public override function toString():String{
			return formatToString("PrLocalConnectEvent","type","bubbles","cancelable", "eventPhase", "calledFunction");
		}
	}
	
}
