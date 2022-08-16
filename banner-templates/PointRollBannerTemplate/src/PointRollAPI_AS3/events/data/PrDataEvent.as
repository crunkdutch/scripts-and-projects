package PointRollAPI_AS3.events.data 
{
	import flash.events.Event;

	/**
	 * A collection of events dispatched during data collection.  Primarily used by the PrForm class.
	 * @see PointRollAPI_AS3.data.PrForm
	 */
	public class PrDataEvent extends Event{
		/**
		 * Event dispatched when user data is submitted to a server script.
		 * @eventType submit
		 */
		public static const SUBMIT:String = "onSubmit";
		/**
		 * Event dispatched when data is returned from a server-side processing script, generally indicating that the transmission was 
		 * successful.
		 * @eventType return
		 */
		public static const RETURN:String = "onReturn";		
		
		/** @private */
		public function PrDataEvent(type:String){
			super(type);
		}
		/** @private */
		public override function clone():Event{
			return new PrDataEvent(type);
		}
		/** @private */
		public override function toString():String{
			return formatToString("PrDataEvent","type","bubbles","cancelable", "eventPhase");
		}
	}
	
}
