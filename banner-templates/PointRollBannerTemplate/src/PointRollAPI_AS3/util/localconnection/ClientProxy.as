package PointRollAPI_AS3.util.localconnection 
{
	import PointRollAPI_AS3.events.net.PrLocalConnectEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	* @private
	* The ClientProxy class is used in the ConnectionManager class to proxy LocalConnection calls.
	* This allows us to dispatch an event every time a call is received
	* @author Default
	*/
	dynamic internal class ClientProxy extends Proxy implements IEventDispatcher{
		/**
		 * Event broadcast when a function call is received
		 * @eventType PointRollAPI_AS3.events.net.PrLocalConnectEvent.CALL_RECEIVED
		 */
		[Event(name="callReceived", type="PointRollAPI_AS3.events.net.PrLocalConnectEvent")]
		public var client:*;
		private var m_oEventDispatcher:EventDispatcher;
		public function ClientProxy(myClient:*) {
			client = myClient;
			m_oEventDispatcher = new EventDispatcher();
		}
		
		flash_proxy override function callProperty(name:*, ...rest):* {
			rest.unshift(name);
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.CALL_RECEIVED));
			return client.callProperty.apply(client, rest);
		}
		
		flash_proxy override function getProperty(name:*):* {
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.CALL_RECEIVED));
			return client[ name ];
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			m_oEventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean{
			return m_oEventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean{
			return m_oEventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			m_oEventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean{
			return m_oEventDispatcher.willTrigger(type);
		}
	}
	
}