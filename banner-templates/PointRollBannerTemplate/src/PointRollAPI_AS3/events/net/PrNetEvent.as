/**
* Events related to PrVideo's use of the NetConnection object
* @author Chris Deely - PointRoll
* @version 1.0
* @private 
*/

package PointRollAPI_AS3.events.net 
{
	import flash.events.Event;

	/** Events related to PointRoll network functions*/
	public class PrNetEvent extends Event {
		/** Event dispatched when the Bandwidth check has been completed
		 * @eventType onBWDone
		 * */
		public static const ONBWDONE:String = "onBWDone";
		/** Event dispatched when the NetConnection Object has been initialized
		 * @eventType netConnectionReady
		 * @private */
		public static const NCREADY:String = "ONNCREADY";
		/** Event dispatched if the NetConnection cannot be initialized
		 * @eventType netConnectionFailed
		 * @private */
		public static const NCFAIL:String = "ONNCFAIL";
		/**Event dispatched when the NetStream object is initialized
		 * @eventType netStreamReady
		 * @private 
		 */
		public static const NSREADY:String = "NetStream Ready";
		/** @private  */
		public var infoObj:Object;
		/** @private  */
		public function PrNetEvent(type:String, data:Object=null){
			super(type);
			infoObj = data;
		}
		/** @private */
		public override function clone():Event{
			return new PrNetEvent(type, infoObj);
		}
		/** @private */
		public override function toString():String{
			return formatToString("PrNetEvent","type","bubbles","cancelable", "eventPhase", "infoObj");
		}
	}
	
}
