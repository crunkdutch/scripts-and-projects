/**
 * PointRoll Sync Host/Client
 * 
 * * 
 * @class 		SyncClient
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
	import PointRollAPI_AS3.util.localconnection.ClientLC;

	import flash.events.Event;

	//PointRoll API specific class imports
	
	//Base classes
	
	
	/** @private **/
	public class SyncClient extends SyncBase {
		
		function SyncClient() {
			trace("PR Component Used:> Sync Client");
			addEventListener(Event.ENTER_FRAME, init);
		}
	
		override protected function init(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, init);
			_connection	= new ClientLC(_connectionName, this.parent);
			super.init(e);
		}
	
		public function close():void {
			_connection.close();
		}
	}
	
}