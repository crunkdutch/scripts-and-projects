package PointRollAPI_AS3.events.data
{
	import flash.events.Event;

	/**
	* Events dispatched by the AdControl class. Used particularly when loading XML data.
	* @author Maggy Maffia - PointRoll
	*/
	public class AdControlEvent extends Event
	{
		/** Event dispatched when the XML data fails to load.
		 * @eventType onLoadFail
		 * @includeExample ../../../examples/AdControl/AdControlEvent.txt -noswf
		 */
		public static const LOAD_FAIL:String = "onLoadFail";
		
		/** Event dispatched continually as the XML data loads.
		 * @eventType onProgress
		 * @includeExample ../../../examples/AdControl/AdControlEvent.txt -noswf
		 */
		public static const PROGRESS:String = "onProgress";
		
		/** Event dispatched when the XML data has successfully loaded.
		 * @eventType onComplete
		 * @includeExample ../../../examples/AdControl/AdControlEvent.txt -noswf
		 */
		public static const LOAD_COMPLETE:String = "onComplete";
		
		/**
		 * Event dispatched by the AdControl.changeZip() method when data pertaining to the new specified zipcode has successfully loaded.
		 * @eventType zipChanged
		 * @includeExample ../../../examples/AdControl/changeZip.txt -noswf
		 */
		public static const ZIP_CHANGED:String = "zipChanged";
		
		/** @private */
		public function AdControlEvent(type:String)
		{
			super(type);
		}
		/** @private */
		public override function clone():Event
		{
			return new AdControlEvent(type);
		}
		/** @private */
		public override function toString():String
		{
			return formatToString("PrDataEvent","type","bubbles","cancelable", "eventPhase");
		}
	}
	
}