package PointRollAPI_AS3.events.tickerboy 
{
	import flash.events.Event;

	/**
	* Events related to the TickerBoy ad unit.
	* @includeExample ../../../examples/PrTickerBoy/PrTickerBoy_cleanUp.txt -noswf
	* @see PointRollAPI_AS3.tickerboy.PrTickerBoy PrTickerBoy Class
	* @author Chris Deely - PointRoll
	*/
	public class PrTickerBoyEvent extends Event{
		/** Event dispatched when the TickerBoy unit is expanded by the user
		 * @eventType onExpand
		 * @includeExample ../../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
		 * */
		public static const EXPAND:String = "onTickerExpand";
		/** Event dispatched when the TickerBoy unit is collapsed by the user
		 * @eventType onCollapse
		 * @includeExample ../../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
		 * */
		public static const COLLAPSE:String = "onTickerCollapse";
		/** Event dispatched if the TickerBoy unit is hidden by the user
		 * @eventType onHide
		 * @includeExample ../../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
		 * */
		public static const HIDE:String = "onTickerHide";
		
		/** Event dispatched when the user clicks thru to a landing page.
		 * @eventType onClickThru
		 * @includeExample ../../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
		 * */
		public static const CLICKTHRU:String = "onTickerClickThru";
		
		/** @private */
		public function PrTickerBoyEvent( type:String ) 
		{
			super(type, true);
			
		}
		
	}
	
}