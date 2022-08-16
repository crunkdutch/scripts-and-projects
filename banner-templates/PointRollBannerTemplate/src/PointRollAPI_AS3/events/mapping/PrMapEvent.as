package PointRollAPI_AS3.events.mapping 
{
	import flash.events.Event;

	/**
	 * Events related to interactive map functionality, broadcast by the PrMap and PrMarker classes.
	* @author Chris Deely, Maggy Maffia - PointRoll
	* @see PointRollAPI_AS3.mapping.PrMap
	* @see PointRollAPI_AS3.mapping.PrMarker
	*/
	public class PrMapEvent extends Event
	{
		/**
		 * Event dispatched when the map has completed initialization, which makes accessible the map's zoom level and center coordinates.
		 * @eventType mapready
		 * @includeExample ../../../examples/mapping/events/progress.txt -noswf
		 */
		public static const	MAP_READY : String = "mapready";
		/**
		 * Event dispatched when the mouse is moved over a marker.
		 * @eventType markerover
		 * @includeExample ../../../examples/mapping/events/markerOverOut.txt -noswf
		 */
		public static const	MARKER_OVER : String = "markerover";
		/**
		 * Event dispatched when a marker is clicked upon.
		 * @eventType markerclick
		 * @includeExample ../../../examples/mapping/events/progress.txt -noswf
		 */
		public static const	MARKER_CLICK : String = "markerclick";
		/**
		 * Event dispatched when the mouse's focus moves off of a marker.
		 * @eventType markerout
		 * @includeExample ../../../examples/mapping/events/markerOverOut.txt -noswf
		 */
		public static const MARKER_OUT : String = "markerout";
		/**
		 * Event dispatched when geocoding of a zip code completes successfully.
		 * @eventType geocodingsuccess
		 * @see PrMap#centerOnZip()
		 * @includeExample ../../../examples/mapping/centerOnZip.txt -noswf
		 */
		public static const GEOCODING_SUCCESS : String = "geocodingsuccess";
		/**
		 * Event dispatched when geocoding of a zip code has failed.
		 * @eventType geocodingfailure
		 * @see PrMap#centerOnZip()
		 * @includeExample ../../../examples/mapping/centerOnZip.txt -noswf
		 */
		public static const GEOCODING_FAILURE : String = "geocodingfailure";
		/**
		 * Event dispatched continually as the Google Map API is being loaded.
		 * @eventType loadprogress
		 * @includeExample ../../../examples/mapping/events/progress.txt -noswf
		 */
		public static const PROGRESS : String = "loadprogress";
		/**
		 * Event dispatched if the Google Map API fails to load after a specified timeOut.
		 * @eventType loadfailure
		 * @includeExample ../../../examples/mapping/events/progress.txt -noswf
		 */
		public static const FAILURE : String = "loadfailure";
		/**
		 * Event dispatched when the map has been zoomed in.
		 * @eventType zoomin
		 * @includeExample ../../../examples/mapping/events/zoom.txt -noswf
		 */
		public static const ZOOM_IN : String = "zoomin";
		/**
		 * Event dispatched when the map has been zoomed out.
		 * @eventType zoomout
		 * @includeExample ../../../examples/mapping/events/zoom.txt -noswf
		 */
		public static const ZOOM_OUT : String = "zoomout";
		/**
		 * Event dispatched each time the map position is changed
		 * @eventType mapmove
		 * @includeExample ../../../examples/mapping/events/mapMove.txt -noswf
		 */
		public static const MAP_MOVE : String = "mapmove";
		
		/**
		 * Event dispatched each time the user clicks on the map; the <code>feature</code> property of 
		 * this event is an object containing <code>lat</code> and <code>lng</code> properties representing 
		 * the location the user clicked on.
		 * @eventType mapclick
		 * @see PrMapEvent#feature
		 * @includeExample ../../../examples/mapping/events/mapClick.txt -noswf
		 */
		public static const MAP_CLICK : String = "mapclick";
		/**
		 * Event dispatched each time the user double-clicks on the map; the <code>feature</code> property of 
		 * this event is an object containing <code>lat</code> and <code>lng</code> properties representing 
		 * the location the user clicked on.
		 * @eventType mapdoubleclick
		 * @see PrMapEvent#feature
		 * @includeExample ../../../examples/mapping/events/mapClick.txt -noswf
		 */
		public static const MAP_DOUBLE_CLICK : String = "mapdoubleclick";
		
		/**
		 * Refers to the event's target. This property is useful when a PrMapEvent must target a specific item. When handling marker interaction 
		 * events, a marker instance must be set as the <code>feature</code> of the event, as seen in the first example.
		 * <br />When handling a <code>MAP_CLICK</code> or <code>MAP_DOUBLE_CLICK</code> event, this property is an object containing <code>lat</code> and <code>lng</code> properties representing 
		 * the coordinates of the clicked location, as seen in the second example.
		 * @includeExample ../../../examples/mapping/events/feature.txt -noswf
		 * @includeExample ../../../examples/mapping/events/mapClick.txt -noswf
		 */
		public var feature:*;
		
		/** @private */
		public function PrMapEvent(type:String, feature:*=null) 
		{
			super(type);
			this.feature = feature;
		}
		/** @private */
		public override function clone():Event{
			return new PrMapEvent(type, feature);
		}
		/** @private */
		public override function toString():String{
			return formatToString("PrMapEvent","type","bubbles","cancelable", "eventPhase", "feature");
		}
	}
	
}