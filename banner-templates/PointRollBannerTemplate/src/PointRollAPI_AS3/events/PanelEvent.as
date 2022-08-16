package PointRollAPI_AS3.events
{
	import flash.events.Event;

	/**
	* Events broadcast by the PointRoll class related to panel control.
	* @author Maggy Maffia - PointRoll
	* @see PointRollAPI_AS3.PointRoll
	*/
	public class PanelEvent extends Event
	{
		/**
		 * Event dispatched when a panel is closed. This event should be listened for only from within a banner to detect when a panel has been closed. 
		 * In order for the banner to reliably detect the closing of a panel, the banner MUST be set to show panels upon Flash Action.
		 * @eventType panelClosed
		 * @includeExample ../../examples/PointRoll/events/PanelEvent.txt -noswf
		 */
		public static const PANEL_CLOSED:String = "panel closed";
		
		/** @private */
		public function PanelEvent(type:String)
		{
			super(type);
		}
		/** @private */
		public override function clone():Event
		{
			return new PanelEvent(type);
		}
		/** @private */
		public override function toString():String
		{
			return formatToString("PanelEvent","type","bubbles","cancelable", "eventPhase");
		}
	}
	
}