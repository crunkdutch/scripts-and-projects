package PointRollAPI_AS3.events.widget 
{
	import flash.events.Event;

	/**
	* Events related to widget sharing menus.
	* @see PointRollAPI_AS3.util.widgets.PrWidgetControl PrWidgetControl Class
	* @author Chris Deely - PointRoll
	*/
	public class PrWidgetEvent extends Event {
		/**Event dispatched when the provider's code library has been loaded
		 * @eventType libraryLoaded
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_loadLibrary.txt -noswf
		 */
		public static const LIBRARY_LOADED:String = "libraryLoaded";
		/**Event dispatched when the sharing menu is visible on the screen
		 * @eventType menuShown
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		public static const MENU_SHOWN:String = "menuShown";
		/**Event dispatched when the sharing menu has been closed
		 * @eventType menuClosed
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		public static const MENU_CLOSED:String = "menuClosed";
		/**Event dispatched when the loading of the provider's code library fails
		 * @eventType failure
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_timeOut_failure.txt -noswf
		 */
		public static const FAILURE:String = "failure";
		
		/** @private */
		public function PrWidgetEvent( type:String )
		{
			super(type);
		}
		
	}
	
}