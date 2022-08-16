package PointRollAPI_AS3.mapping 
{
	import PointRollAPI_AS3.ActivityController;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.activities.MapActivities;
	import PointRollAPI_AS3.events.mapping.PrMapEvent;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import com.google.maps.Map;

	import mx.rpc.soap.types.MapType;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.sampler.getSize;
	import flash.utils.Timer;

	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.GEOCODING_SUCCESS
	 * @see PrMap#centerOnZip()
	 * @includeExample ../../examples/mapping/centerOnZip.txt -noswf
	 */
	[Event(name = "geocodingsuccess", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.GEOCODING_FAILURE
	 * @see PrMap#centerOnZip()
	 * @includeExample ../../examples/mapping/centerOnZip.txt -noswf
	 */
	[Event(name = "geocodingfailure", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MAP_READY
	 * @includeExample ../../examples/mapping/events/progress.txt -noswf
	 */
	[Event(name = "mapready", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MARKER_OVER
	 * @includeExample ../../examples/mapping/events/markerOverOut.txt -noswf
	 */
	[Event(name = "markerover", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MARKER_CLICK
	 * @includeExample ../../examples/mapping/events/markerClick.txt -noswf
	 */
	[Event(name = "markerclick", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MARKER_OUT
	 * @includeExample ../../examples/mapping/events/markerOverOut.txt -noswf
	 */
	[Event(name = "markerout", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.PROGRESS
	 * @includeExample ../../examples/mapping/events/progress.txt -noswf
	 */
	[Event(name = "loadprogress", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.FAILURE
	 * @see PrMap#timeOut
	 * @includeExample ../../examples/mapping/events/progress.txt -noswf
	 */
	[Event(name = "loadfailure", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.ZOOM_IN
	 * @includeExample ../../examples/mapping/events/zoom.txt -noswf
	 */
	[Event(name = "zoomin", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.ZOOM_OUT
	 * @includeExample ../../examples/mapping/events/zoom.txt -noswf
	 */
	[Event(name = "zoomout", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MAP_MOVE
	 * @includeExample ../../examples/mapping/events/mapMove.txt -noswf
	 */
	[Event(name = "mapmove", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MAP_CLICK
	 * @includeExample ../../examples/mapping/events/mapClick.txt -noswf
	 */
	[Event(name = "mapclick", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.mapping.PrMapEvent.MAP_DOUBLE_CLICK
	 * @includeExample ../../examples/mapping/events/mapClick.txt -noswf
	 */
	[Event(name = "mapdoubleclick", type = "PointRollAPI_AS3.events.mapping.PrMapEvent")]
	
	/**
	* PointRoll's mapping API contains the tools needed to create, customize and manipulate interactive maps in ad units. With the use of 
	* interactive maps, an ad panel can display store locations using Google mapping data, and can feature user-specific store lookups. These tools 
	* are accessible via the PrMap class, which is the base for creation of an interactive map. 
	* <p>A typical mapping execution will consist of the following: 
	* <ol><li>Create a MovieClip to be used as a container for the map;</li>
	* <li>If needed, set amount of time to wait for the mapping API to load, using <code>PrMap.timeOut</code>;</li>
	* <li>Create a new PrMap instance, passing in the instance name of your container MovieClip as its target, as well as the map's 
	* starting coordinates and zoom level if needed;</li>
	* <li>Listen for <code>MAP_READY</code> event;</li>
	* <li>Upon successful initialization, perform necessary actions such as setting center coordinates, zoom level and control settings, 
	* and adding markers and info windows as needed.</li></ol></p>
	* 
	* @author Chris Deely, Maggy Maffia - PointRoll
	*/
	public class PrMap extends com.google.maps.Map
	{
		private var _defaultKey:String = "ABQIAAAAE6Ngm2F2O1xAr39BDc73SxRezEjKGUJ-yNWJ3JzqDR08zbj7hxTuCOx8cY0L4I8O1dy6-9AuveX3JA";
		private var _initialCenter:LatLng = new LatLng(39.32510255411885, -96.5798238789673);
		private var _initialZoom:Number = 3;
		private var _markerArray:Array;
		private var _target:Sprite;
		private var _geocoder:ClientGeocoder;
		private var _loadTimer:Timer;
		
		//Map Controls
		private var _controls:Object = {};

		/**
		 * This property allows you to specify a MovieClip to be used as an "info window" connected to your map markers. 
		 * In most cases, you will provide a "linkage identifier" which is tied to a MovieClip in your library.  
		 * To create an appropriate linkage, follow these steps:
		 * <ol>
		 * <li>Create a MovieClip to be used as the info window</li>
		 * <li>Turn the MovieClip into a Symbol to be stored in your FLA library</li>
		 * <li>Right-click on the symbol in your library and select "Linkage..."</li>
		 * <li>Enter a descriptive name for the "Class" field, such as "InfoBubble"</li>
		 * <li>The "Base Class" field MUST be set to "PointRollAPI_AS3.mapping.PrInfoWindow"</li>
		 * <li>Use the name you created for the "Class" field as the setting for the <code>infoWindowRenderer</code> property</li>
		 * </ol>
		 * 
		 * By following these steps, you will be able to display the chosen MovieClip any time a marker on your map is 
		 * clicked.  Within the timeline of your MovieClip you will have access to the <code>dataObject</code> associated 
		 * with the marker the user has clicked on.
		 * @see PrInfoWindow
		 * @see PrMap#displayInfoWindow()
		 * @see PrMarker#dataObject
		 * @includeExample ../../examples/mapping/dataObject.txt -noswf
		 */
		public var infoWindowRenderer:Class;
		
		/**
		 * The amount of time, in milliseconds, to wait for the mapping API to load.  After this amount 
		 * of time has elapsed, a failure event will be broadcast if the API has not loaded.  This property 
		 * must be set prior to creating a new PrMap instance.
		 * @see #event:loadfailure
		 * @includeExample ../../examples/mapping/events/progress.txt -noswf
		 */
		public static var timeOut:Number = 10000;
		
		/**
		 * Determines if the PrMap class will automatically track move and zoom activities.
		 * @includeExample ../../examples/mapping/trackActivities.txt -noswf
		 */ 
		public var trackActivities:Boolean = true;
		private var _mouseOverMap:Boolean = false;
		/** Used to determine whether zoom and/or map move activities should be tracked. We want to track
		 * marker clicks over the subsequent 'move' */
		private var _markerWasClicked:Boolean = false;

		
		/**
		 * Constructor for the PrMap object, requiring a target sprite to be specified. Creating an instance of PrMap provides access to all methods, 
		 * properties and events used to customize and control an interactive map. Note that scaling and resizing of the target sprite's instance within Flash 
		 * will also effect its contained map. In order to prevent the map from appearing stretched or blurry, make sure to keep these dimensions consistent. 
		 * <p>Prior to creating a new PrMap, you may set <code>PrMap.timeOut</code> to an amount of time to allow the mapping API to load, and 
		 * handle the <code>FAILURE</code> event dispatched after this time has elapsed as needed.</p>
		 * <p>A new PrMap instance should listen for the <code>MAP_READY</code> event, which is fired upon successful initialization of the map. 
		 * Initialization is successful once the map's zoom, type, and position have initialized. All manipulation of an interactive map must take 
		 * place after this event has fired.</p>
		 * @param	target Sprite or MovieClip in which to create the map.
		 * @param	centerLat Starting latitude coordinate.
		 * @param	centerLng Starting longitude coordinate.
		 * @param	startZoom Starting zoom level (a whole number between 1-19).
		 * @param	mapKey Used to override default map key. This will typically only need to be set if the ad unit is to be used on a non-PointRoll 
		 * domain.
		 * @see #event:mapready
		 * @includeExample ../../examples/mapping/events/mapready.txt -noswf
		 */
		public function PrMap(target:Sprite, centerLat:Number=NaN, centerLng:Number=NaN, startZoom:Number=NaN, mapKey:String=null) 
		{
			
			_loadTimer = new Timer( (timeOut/100),100);
			_loadTimer.addEventListener(TimerEvent.TIMER, _onProgress, false, 0, true);
			_loadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onLoadFail, false, 0, true);
			_loadTimer.start();
			super();
			key = _defaultKey;
			if (!target)
			{
				throw(new Error("You must provide a valid target to the PrMap constructor."));
				return
			}
			_target = target;
			if (mapKey)
			{
				this.key = mapKey;
			}
			if (!isNaN(centerLat) && !isNaN(centerLng))
			{
				_initialCenter = new LatLng(centerLat,centerLng);
			}
			if ( !isNaN(startZoom) )
			{
				_initialZoom = startZoom;
			}
			var w:Number = Number(_target.width);
			var h:Number = Number(_target.height);
			if ( w == 0 || h == 0 )
			{
				PrDebug.PrTrace("Warning: The map dimensions provided are invalid. Make sure the width and height of your target MovieClip are greater than 0.", 2, "PrMap");
			}
			setSize(new Point(w, h));
			
			_markerArray = new Array();
			
			if (!StateManager.root)
			{
				StateManager.setRoot(target);
			}
			StateManager.addEventListener(StateManager.KILL, _handleKillCommand);
			addEventListener(MapEvent.MAP_READY, _onMapReady, false, 0, true);
			addEventListener(MapEvent.CONTROL_ADDED, _applyDefaultPositioning, false, 0, true);
			addEventListener(MapEvent.CONTROL_REMOVED, _applyDefaultPositioning, false, 0, true);
			addEventListener(MapMouseEvent.ROLL_OVER, _toggleMouseOver, false, 0, true);
			addEventListener(MapMouseEvent.ROLL_OUT, _toggleMouseOver, false, 0, true);
			addEventListener(MapMouseEvent.CLICK, _bubbleClicks, false, 0, true);
			addEventListener(MapMouseEvent.DOUBLE_CLICK, _bubbleClicks, false, 0, true);
			
			//default controls
			zoomControlEnabled = true;
			positionControlEnabled = true;
			
			
			_target.addChild(this);
		}
	
		/**
		 * Sets the map's center on the provided PrMarker instance.
		 * <p><b>Note:</b> This method does not affect the map's zoom level.</p>
		 * @param	marker PrMarker instance on which to set the map's center
		 * @see PrMarker
		 * @includeExample ../../examples/mapping/events/markerClick.txt -noswf
		 */
		public function centerOnMarker( marker:PrMarker ):void
		{
			setCenter(marker.getLatLng());
			savePosition();
		}
		
		/**
		 * Sets the map's center on a marker specified by its <code>markerArray</code> index. The current index of any marker can be referenced 
		 * using the <code>PrMarker.index</code> property. 
		 * <p><b>Note:</b> This method does not affect the map's zoom level.</p>
		 * @param	markerNum Index of marker in <code>markerArray</code>
		 * @see PrMarker#index
		 * @includeExample ../../examples/mapping/markerArray.txt -noswf
		 */
		public function centerOnMarkerNum( markerNum:uint ):void
		{
			try
			{
				setCenter(_markerArray[markerNum].getLatLng());
				savePosition();
			}catch (e:Error)
			{
				throw(new Error("There is no marker numbered " + markerNum));
			}
			
		}
		
		/**
		 * Centers the map based on provided latitude and longitude coordinates.
		 * <p><b>Note:</b> This method does not affect the map's zoom level.</p>
		 * @param	lat Latitude value
		 * @param	lng Longitude value
		 * @includeExample ../../examples/mapping/addMarker.txt -noswf
		 */
		public function centerOnLatLng(lat:Number, lng:Number):void
		{
			setCenter(new LatLng(lat, lng));
			savePosition();
		}
		
		/**
		 * Centers the map on coordinates geocoded from a specified zip code. This method can also accept any search string, such as a location's 
		 * full address. When successfully completing a geocoding request on the provided string, this method will fire a 
		 * <code>GEOCODING_SUCCESS</code> event. This event and <code>GEOCODING_FAILURE</code> should be listened for when calling this function 
		 * and handled accordingly.
		 * <p><b>Note:</b> This method does not affect the map's zoom level.</p>
		 * @param	zip Address or zip code on which to center the map.
		 * @see #event:geocodingsuccess
		 * @see #event:geocodingfailure
		 * @includeExample ../../examples/mapping/centerOnZip.txt -noswf
		 */
		public function centerOnZip(zip:String):void
		{
			_geocoder = new ClientGeocoder();
			_geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, _geocodeSuccess, false, 0, true);
			_geocoder.addEventListener(GeocodingEvent.GEOCODING_FAILURE, _geocodeFail, false, 0, true);
			
			_geocoder.geocode(zip);
		}
		
		/**
		 * Adds a provided marker instance to <code>markerArray</code> and returns a reference to its index. 
		 * Using this method would be useful in a case in which you have added specific markers instances to the array but require more control 
		 * over how each is added to the map, as opposed to calling <code>createMarkerAt</code> which both instantiates a marker and adds it to the map.
		 * <p>This is also useful when working with marker instances requiring different icons, as seen in the following example.</p>
		 * @param	marker PrMarker object to add.
		 * @return Returns Index of added marker in <code>markerArray</code>.
		 * @see PrMap#markerArray
		 * @see PrMap#createMarkerAt()
		 * @see PrMarker
		 * @includeExample ../../examples/mapping/addMarker.txt -noswf
		 */
		public function addMarker( marker:PrMarker ):uint
		{
			addOverlay( marker );
			marker.index = _markerArray.length;
			marker.map = this;
			_markerArray.push(marker);
			
			marker.addEventListener(MapMouseEvent.CLICK, _markerClick, false, 0, true);
			marker.addEventListener(MapMouseEvent.ROLL_OVER, _markerOver, false, 0, true);
			marker.addEventListener(MapMouseEvent.ROLL_OUT, _markerOut, false, 0, true);
			return (marker.index);
		}
		
		/**
		 * Removes provided PrMarker instance from the map and from <code>markerArray</code>. 
		 * To remove a marker by its index in <code>markerArray</code>, use <code>removeMarkerNum()</code>.
		 * @param	marker PrMarker instance to remove from the map.
		 * @see PrMap#removeMarkerNum
		 * @see PrMarker
		 */
		public function removeMarker(marker:PrMarker):void
		{
			removeMarkerNum(marker.index);
		}
		
		/**
		 * Removes a PrMarker from the map based on its <code>markerArray</code> index and updates the array accordingly.
		 * @param	markerNum Index of PrMarker to be removed.
		 * @see PrMarker#index
		 * @includeExample ../../examples/mapping/markerArray.txt -noswf
		 */
		public function removeMarkerNum(markerNum:uint):void
		{
			var m:PrMarker = _markerArray[markerNum];
			removeOverlay(m);
			
			m.index = NaN;
			_markerArray = _markerArray.splice(markerNum, 1);
			
			for (var i:Number = 0; i < _markerArray.length; i++);
			{
				m.index = _markerArray[i];
			}
		}
		
		public function removeAllMarkers():void
		{
			markerArray = [];
		}
		/**
		 * Creates a new PrMarker based on the provided coordinates and icon, and adds it to the map. You may optionally specify a dataObject parameter in 
		 * which to store additional data related to the location, such as address, store information, etc.
		 * @param	lat Latitude value
		 * @param	lng Longitude value
		 * @param	markerIcon Display object to use as the marker's icon
		 * @param	dataObject Optional data object containing any additional data relevant to the marker's location
		 * @return  Created PrMarker
		 * @see PrMarker
		 * @includeExample ../../examples/mapping/createMarkerAt.txt -noswf
		 */
		public function createMarkerAt(lat:Number, lng:Number, markerIcon:DisplayObject, dataObject:Object = null):PrMarker
		{
			var m:PrMarker = new PrMarker(lat, lng, markerIcon, dataObject);
			addMarker(m);
			return m;
		}
		
		/**
		 * Creates a new PrInfoWindow for the provided PrMarker instance.
		 * @param	marker PrMarker for which to display the info window
		 * @see PrMap#infoWindowRenderer
		 * @see PrMap#hideInfoWindow()
		 * @includeExample ../../examples/mapping/dataObject.txt -noswf
		 */
		public function displayInfoWindow(marker:PrMarker):void
		{
			var display:PrInfoWindow = new infoWindowRenderer();
			display.dataObject = marker.dataObject;
			display.marker = marker;
			var options:InfoWindowOptions = new InfoWindowOptions( { customContent:display } );
			marker.openInfoWindow(options);
		}
		/**
		 * Closes the currently displayed info window.
		 * @see PrMap#infoWindowRenderer
		 * @see PrMap#displayInfoWindow()
		 */
		public function hideInfoWindow():void
		{
			closeInfoWindow();
		}
		
		/**
		 * Sets the zoom level and center of the map such that all markers current markers are visible.
		 * <p>Since the center and zoom level set by this method reflect the contents of <code>markerArray</code>, any changes 
		 * made the the array after calling this function will not affect the map's zoom or center.</p>
		 * @includeExample ../../examples/mapping/fitAllMarkers.txt -noswf
		 */
		public function fitAllMarkers():void
		{
			if ( _markerArray.length < 1 )
			{
				return;
			}
			//create a LatLngBounds object based on the markers currently in the markerArray
			var neLat:Number = _markerArray[0].lat;
			var neLng:Number = _markerArray[0].lng;
			var swLat:Number = _markerArray[0].lat;
			var swLng:Number = _markerArray[0].lng;
			var bounds:LatLngBounds;
			
			for (var i:uint = 1; i < _markerArray.length; i++)
			{
				var m:PrMarker = _markerArray[i];
				neLat = (m.lat > neLat)? m.lat : neLat;
				neLng = (m.lng > neLng)? m.lng : neLng;
				swLat = (m.lat < swLat)? m.lat : swLat;
				swLng = (m.lng < swLng)? m.lng : swLng;
			}
			bounds = new LatLngBounds( new LatLng(swLat, swLng), new LatLng(neLat, neLng) );
			
			setCenter(bounds.getCenter());
			zoom = getBoundsZoomLevel(bounds);
			savePosition();
		}
		
		/**
		 * Removes any and all assets related to the PrMap object. Calling this function is essential in freeing up memory being used by the map.
		 * @includeExample ../../examples/mapping/destroyMap.txt -noswf
		 */
		public function destroyMap():void
		{	_killLoadTimer();
			for (var i:uint = 0; i < _markerArray.length; i++)
			{
				removeMarkerNum(i);
			}
			_markerArray = null;
			_geocoder = null;
			infoWindowRenderer = null;
			_initialCenter = null;
			_target.removeChild(this);
			_target = null;
		}
		
		
		/**
		 * Contains all PrMarker instances present on the map. This array is updated every time a marker is added or removed, allowing you to 
		 * reference a marker by its index. This array allows for easier organization of the markers generated by a store lookup, which could amount 
		 * to a large number.
		 * @see PrMap#centerOnMarkerNum()
		 * @see PrMap#removeMarkerNum()
		 * @see PrMarker#index
		 * @includeExample ../../examples/mapping/markerArray.txt -noswf
		 */
		public function get markerArray():Array
		{
			return _markerArray;
		}
		public function set markerArray( array:Array ):void
		{
			while ( _markerArray.length > 0 )
			{
				var m:PrMarker = _markerArray.pop();
				removeOverlay(m);
				m = null;
			}
			for ( var i:uint = 0; i < array.length; i++ )
			{
				if ( array[i] is PrMarker )
				{
					addMarker( array[i] );
				}
			}
		}
		
		/**
		 * The map's current zoom level (a number between 1 and 19).
		 * @see event:zoomin
		 * @see event:zoomout
		 * @includeExample ../../examples/mapping/events/markerClick.txt -noswf
		 */
		public function get zoom():Number
		{
			return getZoom();
		}
		public function set zoom(newZoom:Number):void
		{
			setZoom(newZoom);
		}
		
		/**
		 * Value of the latitude coordinate of the map's current center.  This value is read-only; 
		 * to change the center of the map coordinates, use <code>centerOnLatLng()</code>.
		 * @see PrMap#centerOnLatLng()
		 * @includeExample ../../examples/mapping/centerOnZip.txt -noswf
		 */
		public function get centerLat():Number
		{
			return getCenter().lat();
		}
		/**
		 * Value of the longitude coordinate of the map's current center.  This value is read-only; 
		 * to change the center of the map coordinates, use <code>centerOnLatLng()</code>.
		 * @see PrMap#centerOnLatLng()
		 * @includeExample ../../examples/mapping/centerOnZip.txt -noswf
		 */
		public function get centerLng():Number
		{
			return getCenter().lng();
		}
		
		/**
		 * Can be set to true (default) or false to enable or disable the map's zoom buttons and slider.
		 * @includeExample ../../examples/mapping/controls.txt -noswf
		 */
		public function get zoomControlEnabled():Boolean
		{
			return Boolean(_controls.zoom != null)
		}
		public function set zoomControlEnabled(enabled:Boolean):void
		{
			_toggleControl("zoom", enabled);
		}
		
		/**
		 * Can be set to true (default) or false to enable or disable the map's panning buttons.
		 * @includeExample ../../examples/mapping/controls.txt -noswf
		 */
		public function get positionControlEnabled():Boolean
		{
			return Boolean(_controls.position != null)
		}
		public function set positionControlEnabled(enabled:Boolean):void
		{
			_toggleControl("position", enabled);
			
		}
		
		/**
		 * Can be set to true or false (default) to enable or disable the buttons for switching the map's type (Map, Satellite, Hybrid, Terrain). 
		 * The default type is Map.
		 * @includeExample ../../examples/mapping/controls.txt -noswf
		 */
		public function get mapTypeControlEnabled():Boolean
		{
			return Boolean(_controls.mapType != null)
		}
		public function set mapTypeControlEnabled(enabled:Boolean):void
		{
			_toggleControl("mapType", enabled);
		}
		
		/**
		 * Can be set to true or false (default) to enable or disable the control displaying the map's scale.
		 * @includeExample ../../examples/mapping/controls.txt -noswf
		 */
		public function get scaleControlEnabled():Boolean
		{
			return Boolean(_controls.scale != null)
		}
		public function set scaleControlEnabled(enabled:Boolean):void
		{
			_toggleControl("scale", enabled);
		}
		
		// Private
		private function _toggleControl(name:String, enabled:Boolean):void
		{
			if ( enabled )
			{
				switch(name)
				{
					case "zoom":
						_controls[name] = new ZoomControl();
						break;
					case "position":
						_controls[name] = new PositionControl();
						break;
					case "mapType":
						_controls[name] = new MapTypeControl();
						break;
					case "scale":
						_controls[name] = new ScaleControl();
						break;
				}
				addControl(_controls[name]);
			}else
			{
				removeControl(_controls[name]);
				_controls[name] = null;
			}
		}
		
		private function _applyDefaultPositioning(e:MapEvent):void
		{
			// Somehow the height of the zoomcontrol is under-reported here...
			//var sprite:Sprite = Sprite( IControl(e.feature).getDisplayObject() );
			//sprite.graphics.beginFill(0xff0000, .6);
			//sprite.graphics.drawRect(0,0,sprite.width,sprite.height);
			
			if ( zoomControlEnabled)
			{
				var zc:ZoomControl = ZoomControl(_controls.zoom);
				//Google's zoom control doesn't count the zoom out button in its height calculation! 
				// add 20px padding as well as the offset
				var testHeight:Number = zc.getSize().y + 17;
				if ( positionControlEnabled )
				{
					testHeight += PositionControl(_controls.position).getSize().y;
				}
				if (testHeight > height)
				{
					//too big with the zoomcontrol
					if ( positionControlEnabled )
					{
						_collapseZoomScrollTrack();
					}else
					{
						if ( !_alignToTop(zc) )
						{
							_collapseZoomScrollTrack();
						}
					}
				}
			}
		}
		private function _collapseZoomScrollTrack():void
		{
			removeControl(ZoomControl(_controls.zoom));
			_controls.zoom = new ZoomControl( new ZoomControlOptions( { hasScrollTrack:false } ) );
			addControl(_controls.zoom);
		}
		private function _alignToTop(control:IControl):Boolean
		{
			//collapse the empty space
			var yOffset:Number = control.getControlPosition().getOffsetY();
			var controlTrueHeight:Number = control.getSize().y + 17;
			while ( control.getControlPosition().getOffsetY() >= 0 )
			{
				control.setControlPosition( new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 31, yOffset) );
				
				if (controlTrueHeight + yOffset < height)
				{
					//got it to fit
					return true;
				}
				yOffset--;
			}
			return false;
		}
		private function _markerOver(e:MapMouseEvent):void 
		{
			dispatchEvent(new PrMapEvent(PrMapEvent.MARKER_OVER, e.target as PrMarker));
		}
		
		private function _markerClick(e:MapMouseEvent):void 
		{
			_markerWasClicked = true;
			ActivityController.getInstance(this).activity( MapActivities.MARKER_CLICK );
			dispatchEvent(new PrMapEvent(PrMapEvent.MARKER_CLICK, e.target as PrMarker));
		}
		
		private function _markerOut(e:MapMouseEvent):void
		{
			dispatchEvent(new PrMapEvent(PrMapEvent.MARKER_OUT, e.target as PrMarker));
		}
		
		private function _onMapReady(event:Event):void {
			_killLoadTimer();			
			setCenter(_initialCenter, _initialZoom, MapType.NORMAL_MAP_TYPE);
			addEventListener(MapZoomEvent.ZOOM_CHANGED, _handleZoomChange, false, 0, true);
			addEventListener(MapMoveEvent.MOVE_START, _handleMoveEvent, false, 0, true);
			dispatchEvent(new PrMapEvent(PrMapEvent.MAP_READY));
		}
		
		private function _geocodeSuccess(e:GeocodingEvent):void
		{
			var _gcPlacemarks:Array = e.response.placemarks as Array;
			_geocoder.removeEventListener(GeocodingEvent.GEOCODING_SUCCESS, _geocodeSuccess);
			_geocoder.removeEventListener(GeocodingEvent.GEOCODING_FAILURE, _geocodeFail);
			_geocoder = null; 
			
			if (_gcPlacemarks.length > 0)
			{
				setCenter(_gcPlacemarks[0].point);
				savePosition();
			}else
			{
				//no placemarks indicates a failure
				dispatchEvent(new PrMapEvent(PrMapEvent.GEOCODING_FAILURE));
				return;
			}
			
			dispatchEvent(new PrMapEvent(PrMapEvent.GEOCODING_SUCCESS));
		}
		
		private function _geocodeFail(e:GeocodingEvent):void
		{
			_geocoder.removeEventListener(GeocodingEvent.GEOCODING_SUCCESS, _geocodeSuccess);
			_geocoder.removeEventListener(GeocodingEvent.GEOCODING_FAILURE, _geocodeFail);
			_geocoder = null;
			PrDebug.PrTrace("Geocoding failed - could not center on zip.", 5, "PrMap");
			dispatchEvent(new PrMapEvent(PrMapEvent.GEOCODING_FAILURE));
		}
		private function _onLoadFail(e:TimerEvent):void 
		{
			PrDebug.PrTrace("Failed to load the Mapping API", 5, "PrMap");
			_killLoadTimer();
			dispatchEvent(new PrMapEvent(PrMapEvent.FAILURE));
		}
		
		private function _onProgress(e:TimerEvent):void 
		{
			dispatchEvent(new PrMapEvent(PrMapEvent.PROGRESS));
		}
		private function _killLoadTimer():void
		{
			try
			{
				_loadTimer.stop();
				_loadTimer.removeEventListener(TimerEvent.TIMER, _onProgress);
				_loadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onLoadFail);
				_loadTimer = null;
			}catch(e:Error){}
			
		}
		private function _bubbleClicks(e:MapMouseEvent):void 
		{
			switch(e.type)
			{
				case MapMouseEvent.CLICK:
					dispatchEvent(new PrMapEvent(PrMapEvent.MAP_CLICK, { lat:e.latLng.lat(), lng:e.latLng.lng() } ));
					break;
				case MapMouseEvent.DOUBLE_CLICK:
					dispatchEvent(new PrMapEvent(PrMapEvent.MAP_DOUBLE_CLICK, { lat:e.latLng.lat(), lng:e.latLng.lng() } ));
					break;
			}
		}
		private function _handleZoomChange(e:MapZoomEvent):void 
		{
			if ( e.zoomLevel == zoom )
			{
				return
			}
			//determing the zoom direction
			var zoomType:String = (e.zoomLevel < zoom) ? "ZOOM_IN" : "ZOOM_OUT";
			//update initial zoom
			//zoom = e.zoomLevel;
			if (trackActivities)
			{
				_trackUniqueActivity(zoomType);
			}
			dispatchEvent(new PrMapEvent( PrMapEvent[ zoomType ] ) );
		}
		
		private function _handleMoveEvent(e:MapMoveEvent):void 
		{
			if (!_markerWasClicked)
			{
				if (trackActivities)
				{
					_trackUniqueActivity("MAP_MOVE");
				}
			}else
			{
				_markerWasClicked = false;
			}
			
			dispatchEvent(new PrMapEvent( PrMapEvent.MAP_MOVE ));
		}
		
		
		private function _toggleMouseOver(e:MapMouseEvent):void
		{
			if (e.type == MapMouseEvent.ROLL_OVER)
			{
				_mouseOverMap = true;
			}else
			{
				_mouseOverMap = false;
			}
		}
		private function _trackUniqueActivity(interaction:String):void
		{
			var activity:Number = MapActivities[ interaction ];
			var ac:ActivityController = ActivityController.getInstance(this);
			//only track when the mouse is over the map
			if ( _mouseOverMap && !ac.checkForExisting(activity) )
			{
				ac.activity(activity, true);
			}
		}
		
		private function _handleKillCommand(e:Event):void 
		{
			StateManager.removeEventListener(StateManager.KILL, _handleKillCommand);
			destroyMap();
		}
	}
	
}
