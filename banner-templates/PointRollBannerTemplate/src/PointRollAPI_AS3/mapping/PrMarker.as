package PointRollAPI_AS3.mapping 
{
	import PointRollAPI_AS3.events.mapping.PrMapEvent;

	import com.google.maps.overlays.Marker;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	* The PrMarker class is used to create and customize markers. Markers are visual representations of specific points on an interactive map and can 
	* be associated with data specific to the locations they represent. 
	* <p>The MovieClip you create to be used as a marker will be, in most cases, a small logo or other store-specific image. This MovieClip can be 
	* referenced using the PrMarker object's <code>icon</code> property. Since a store lookup 
	* could generate any number of markers, you will need to assign a linkage identifier to your MovieClip in the library. This can be done in the 
	* following steps: </p>
	* <ol><li>Create your marker and convert it to a MovieClip symbol. When designing a marker, keep in mind that the MovieClip's registration point is what effects 
	* its alignment on the map. For example, the registration point of an arrow-shaped marker would most likely be at its tip.</li>
	* <li>Right-click the symbol in the library and select "Linkage..." from the menu;</li>
	* <li>Check the box next to "Export for ActionScript";</li>
	* <li>Enter an appropriate name in the "Class" field, such as "StoreMarker";</li>
	* <li>Make sure the base class is set to flash.display.MovieClip;</li></ol>
	* When a PrMarker is instantiated, it is added to <code>markerArray</code>--an array accessible by the PrMap object. This array will always contain 
	* all marker instances currently on the map. 
	* <p>All marker functionality and interaction is controlled using the various PrMap methods. A PrMap instance must be created and initialized (see 
	* <code>MAP_READY</code> event) before markers can be added. This is also important since PrMarker instances will often be created from 
	* the <code>feature</code> of a PrMapEvent (see the following example).</p>
	* @author Chris Deely, Maggy Maffia - PointRoll
	* @see PrMap#markerArray
	* @see PrMap#addMarker
	* @see PrMap#createMarkerAt
	* @see PrMap#removeMarker
	* @see PrMap#removeMarkerNum
	*/
	public class PrMarker extends com.google.maps.overlays.Marker
	{
		/**
		 * An object (most often will be an XML object) containing any additional data to associate with a marker, such as store ID, street address, 
		 * or other store-specific data. Such data will often be displayed in an info window.
		 * @see PrMap#infoWindowRenderer
		 * @includeExample ../../examples/mapping/dataObject.txt -noswf
		 */
		public var dataObject:Object;
		
		/**
		 * Set by PrMap when a marker is added or removed from the map, this property provides a reference to the index of a marker.
		 * @see PrMap#markerArray
		 * @includeExample ../../examples/mapping/markerArray.txt -noswf
		 */
		public var index:uint;
		
		/**
		 * A reference to the map on which this marker is currently displayed.  If the marker is not on a map, this property will return <code>null</code>.
		 * @see PrMap
		 * 
		 */
		public var map:PrMap;
		
		/**
		 * Constructor for the PrMarker object, requiring coordinates and a display object to be specified.
		 * @param	lat Value of latitude coordinate
		 * @param	lng Value of longitude coordinate
		 * @param	markerIcon Display object to represent the location. This can be referenced using the <code>icon</code> property.
		 * @param	dataObject Object containing any additional data to associate with the marker's location, such as address, store ID, etc.
		 * @param	options You may add further customization and functionality to the marker by providing an object containing these options.
		 * @includeExample ../../examples/mapping/addMarker.txt -noswf
		 */
		public function PrMarker(lat:Number, lng:Number, markerIcon:DisplayObject, dataObject:Object=null, options:Object=null) 
		{
			var markerOptions:MarkerOptions = new MarkerOptions(options);
			markerOptions.icon = markerIcon;
			this.dataObject = dataObject;
			super(new LatLng(lat, lng), markerOptions);
			
			addEventListener(MouseEvent.CLICK, _markerClick, false,0,true);
			addEventListener(MouseEvent.MOUSE_OVER, _markerOver, false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, _markerOut, false,0,true);
		}
		
		/**
		 * Returns <code>true</code> if the marker is set to have a shadow, <code>false</code> otherwise.
		 * @includeExample ../../examples/mapping/hasShadow.txt -noswf
		 */
		public function get hasShadow():Boolean
		{
			return getOption("hasShadow");
		}
		public function set hasShadow(s:Boolean):void
		{
			setOption("hasShadow", s);
		}
		
		/**
		 * A reference to the DisplayOjbect used as the marker's icon. Any property applicable to a DisplayObject (filters, mask, scale, 
		 * alpha, etc.) can be applied to a marker icon, as seen in the following example.
		 * <p>This property can also be used to directly control what is displayed as the icon of a particular marker when instantiating a new 
		 * marker is not necessary.</p>
		 * <p><b>Note:</b> The registration point of the MovieClip used as the marker is what effects the marker's alignment on the map. For example, 
		 * if your marker resembled an arrow, you would want to set the registration point at the tip of the arrow.</p>
		 * @includeExample ../../examples/mapping/events/markerOverOut.txt -noswf
		 */
		public function get icon():DisplayObject
		{
			return getOption("icon");
		}
		public function set icon(s:DisplayObject):void
		{
			setOption("icon", s);
		}
		/**
		 * A reference to the value of the marker's latitude coordinate.
		 * @includeExample ../../examples/mapping/latLng.txt -noswf
		 */
		public function get lat():Number
		{
			var l:Number = Number (getLatLng().lat());
			return l;
		}
		public function set lat(l:Number):void
		{
			setLatLng(new LatLng(l, this.lng));
		}
		/**
		 * A reference to the value of the marker's longitude coordinate.
		 * @includeExample ../../examples/mapping/latLng.txt -noswf
		 */
		public function get lng():Number
		{
			var l:Number = Number (getLatLng().lng());
			return l;
		}
		public function set lng(l:Number):void
		{
			setLatLng(new LatLng(this.lat, l));
		}
		
		/**
		 * Sets a specific option to the marker. Please reference Google Maps' <a href="http://code.google.com/apis/maps/documentation/flash/reference.html#MarkerOptions" target="_blank">MarkerOptions</a> class for 
		 * the options you can set using this function.
		 * @param	name Name of the property
		 * @param	value Value of the property
		 * @includeExample ../../examples/mapping/hasShadow.txt -noswf
		 */
		public function setOption(name:String, value:*):void
		{
			var o:MarkerOptions = getOptions();
			o[name] = value;
			setOptions(o);
		}
		/**
		 * Retrieves the value of a specific option as it applies to the marker. Please reference Google Maps' <a href="http://code.google.com/apis/maps/documentation/flash/reference.html#MarkerOptions" target="_blank">MarkerOptions</a> class for 
		 * the set of options applicable here.
		 * @param	name Name of the property
		 * @return The option's value
		 * @includeExample ../../examples/mapping/hasShadow.txt -noswf
		 */
		public function getOption(name:String):*
		{
			var o:MarkerOptions = getOptions();
			var val:*;
			try
			{
				val = o[name];
			}catch (e:Error)
			{
				val = null;
			}
			return val;
		}
		
		// Private
		private function _markerClick(e:MouseEvent):void
		{
			dispatchEvent(new PrMapEvent(PrMapEvent.MARKER_CLICK));
		}
		
		private function _markerOver(e:MouseEvent):void
		{
			dispatchEvent(new PrMapEvent(PrMapEvent.MARKER_OVER));
		}
		
		private function _markerOut(e:MouseEvent):void
		{
			dispatchEvent(new PrMapEvent(PrMapEvent.MARKER_OUT));
		}
		
	}
	
}