package PointRollAPI_AS3.tickerboy{
/**
 * The interface implemented by all TickerBoy classes.
* @author Chris Deely - PointRoll
* @version 0.1
*/	
public interface IPrTickerBoy  {
		/**
		 * The tickerExpand method causes the TickerBoy ad unit to grow from the initial banner state to the expanded panel state.
		 */
		function tickerExpand():void;
		/** The tickerCollapse method causes the TickerBoy ad unit to display the initial banner state.*/
		function tickerCollapse():void;
		/**
		 * The tickerHide method causes the TickerBoy ad unit to placed into a "hidden" state.  This could be triggered by the user clicking a 
		 * close button or based on a maximum display time permitted by the publisher or client. 
		 * <br/> <br/> Generally, there is a small "leave-behind" graphic or text within this state that allows the user to 
		 * re-launch the ad unit if desired.
		 */
		function tickerHide():void;
	}
}