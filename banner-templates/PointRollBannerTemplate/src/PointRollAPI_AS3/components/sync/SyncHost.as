/**
 * PointRoll Sync Host/Client
 * 
 * * 
 * @class 		SyncHost
 * @package		PointRollAPI.components.sync
 * @author		PointRoll
 */
 
 
 /**
 *	List of exposed methods 
 *	--------------------------
 *	
 *	
 *
 */

package PointRollAPI_AS3.components.sync 
{
	import PointRollAPI_AS3.events.net.PrLocalConnectEvent;
	import PointRollAPI_AS3.util.localconnection.HostLC;

	import String;
	import flash.events.Event;

	//PointRoll API specific class imports
	
	//Base classes
	
	/** @private **/
	public class SyncHost extends SyncBase {
		
		[Inspectable(name="Time out (milliseconds)", type=String, defaultValue="10000")]
		public var timeOut:String = "10000";
		
		function SyncHost() {
			trace("PR Component Used:> Sync Host");
			addEventListener(Event.ENTER_FRAME, init);
		}
		
		override protected function init(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, init);
			_connection	= new HostLC(_connectionName, this.parent, Number(timeOut));
			super.init(e);
			_connection.addEventListener(PrLocalConnectEvent.HANDSHAKE_COMPLETE, handshakeComplete, false, 0, true);
			_connection.addEventListener(PrLocalConnectEvent.HANDSHAKE_FAILED, handshakeFailed, false, 0, true);
		}
		
		public function handshakeComplete(e:PrLocalConnectEvent):void {
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.HANDSHAKE_COMPLETE));
		}
		
		public function handshakeFailed(e:PrLocalConnectEvent):void{
			dispatchEvent(new PrLocalConnectEvent(PrLocalConnectEvent.HANDSHAKE_FAILED));
		}
	
		public function close():void {
			_connection.close();
		}
	}
	
}