/**
* @private
* @author Default
* @version 0.1
*/

package PointRollAPI_AS3.events 
{
	import flash.events.Event;

	/** @private */
	public class PointRollEvent extends Event{
		
		public var infoObj:Object;
		
		public function PointRollEvent(type:String, data:Object=null){
			super(type);
			infoObj = data;
		}
		public override function clone():Event{
			return new PointRollEvent(type, infoObj);
		}
		
		public override function toString():String{
			return formatToString("PointRollEvent","type","bubbles","cancelable", "eventPhase", "infoObj");
		}
	}
	
}
