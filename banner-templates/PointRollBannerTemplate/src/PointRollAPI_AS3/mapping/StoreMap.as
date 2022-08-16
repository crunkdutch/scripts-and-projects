package PointRollAPI_AS3.mapping 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.*;
	import PointRollAPI_AS3.events.mapping.PrMapEvent;
	import PointRollAPI_AS3.mapping.*;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.util.StringUtil;
	import PointRollAPI_AS3.data.DataStorage;
	
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
	* The StoreMap is a specially formatted version of the PrMap class which automatically generates a 
	* map of retail store locations based upon ShopLocal data.  This class should only be used in conjunction
	* with a PaperBoy ad unit.
	* <p>To use the class, you must provide an advertiser name for the current client, as well as a
	* campaign ID.  Both of these will be used to pull in a list of local store locations from the ShopLocal 
	* database and plot the points on a map.</p>
	* <p>This class also makes use of an <code>infoWindowRenderer</code>, which is a special MovieClip designed to
	* display store information when a store's marker is clicked. Since instantiation of StoreMap will automatically plot the locations based 
	* on the provided data, specifying linkage IDs for the map markers and info windows is required.</p>
	* @author Chris Deely - PointRoll
	*/
	public class StoreMap extends MovieClip
	{	
		/** The linkage ID of the MovieClip being used to represent map Markers.
		 * See the <code>PrMarker</code> class for details.
		 * @see PointRollAPI_AS3.mapping.PrMarker
		 * @includeExample ../../examples/mapping/StoreMap.txt -noswf
		 */
		public var markerIconClass:Class;
		
		/** The linkage ID of the MovieClip being used to represent map InfoWindows. 
		 * See the <code>PrMap</code> class for details.
		 * @see PointRollAPI_AS3.mapping.PrMap
		 * @includeExample ../../examples/mapping/StoreMap.txt -noswf
		 */
		public var infoWindowClass:Class;
		
		/** 
		 * Enables or disables the Position (Pan) Map Control 
		 * @includeExample ../../examples/mapping/controls.txt -noswf 
		 */
		public var positionControlEnabled:Boolean = true;
		/** 
		 * Enables or disables the Zoom Map Control 
		 * @includeExample ../../examples/mapping/controls.txt -noswf 
		 */
		public var zoomControlEnabled:Boolean = true;
		/** 
		 * Enables or disables the ability to use a mouse scroll wheel to change the map's zoom.
		 * @includeExample ../../examples/mapping/scrollWheelZoom.txt -noswf
		 */
		public var scrollWheelZoom:Boolean = true;
		/** The URL used to request store listings from ShopLocal.  This URL should appear in the format: 
		 * "http://[ADVERTISER].shoplocal.com/[ADVERTISER]/api.aspx?format=xmlsm&amp;ver=v2"
		 * */
		public var baseURL:String = "http://{0}.shoplocal.com/{0}/api.aspx?format=xmlsm&ver=v2&campaignid={1}&rpc=getstorelist&citystatezip=";
		
		private var _map:PrMap;
		private var _userZip:String;
		private var _xmlLoader:URLLoader;
		private var _mapLoaded:Boolean = false;
		private var _dataLoaded:Boolean = false;
		private var _storeXML:XML;
		private var _selectedStore:String;
		
		/**
		 * Constructor for the StoreMap object, requiring a target sprite, advertiser name, and campaign ID to be provided.
		 * @param	target Sprite or MovieClip in which to create the StoreMap.
		 * @param	advertiser The name of the advertiser for this campaign, as recognized by ShopLocal.
		 * @param	campaignID An advertiser campaign ID provided by ShopLocal.
		 * @includeExample ../../examples/mapping/StoreMap.txt -noswf
		 */
		public function StoreMap(target:Sprite, advertiser:String, campaignID:String) 
		{
			baseURL = StringUtil.insertion(baseURL,advertiser, campaignID);
			_map = new PrMap(target);
			_map.addEventListener(PrMapEvent.MAP_READY, _mapReady, false, 0, true);
			_map.addEventListener(PrMapEvent.MARKER_CLICK, _handleMarkerClick, false, 0, true);
		}

		/**
		 * A reference to the user's zip code, which can be set after markerIconClass and infoWindowRenderer are specified. This must be a valid 
		 * US zip code in any of the following formats: 19428-2307, 194282307, 19428.
		 * @includeExample ../../examples/mapping/StoreMap.txt -noswf
		 */
		public function get userZip():String
		{
			return _userZip;
		}
		public function set userZip( zip:String ):void
		{
			var re:RegExp = / ^\d{5}-\d{4}$ | ^(\d{9})$ | ^(\d{5})$ /x
			if ( !re.test( zip ) )
			{
				throw(new ArgumentError("Invalid Zipcode"));
				return
			}
			if ( !markerIconClass || !infoWindowClass )
			{
				throw(new Error("You must specify markerIcon and infoWindowRenderer Classes prior to setting the userZip propery."))
				return
			}
			_map.infoWindowRenderer = infoWindowClass;
			if (_userZip != zip)
			{
				_userZip = zip;
				_loadXML();
			}else
			{
				_map.fitAllMarkers();
				_map.centerOnMarker( _map.markerArray[0] );
			}
			
		}
		
		/**
		 * Returns the user's selected store location, referenced by the store ID number.
		 * @includeExample ../../examples/mapping/saveUserSelection.txt -noswf
		 */
		public function get selectedStore():String
		{
			return _selectedStore;
		}
		
		/**
		 * A reference to the PrMap object used by this class.
		 * @includeExample ../../examples/mapping/mapGetter.txt -noswf
		 */
		public function get map():PrMap
		{
			return _map;
		}
		
		/**
		 * This function uses the PointRoll <code>DataStorage</code> class to store the user's zip code 
		 * and selected store location.  This function should be called prior to opening a second ad panel 
		 * which displays store-specific items and specials.  The PaperBoy panel should make use of the 
		 * <code>PaperBoyModel.retrieveUserSelection()</code> function to load the appropriate store's data.
		 * @includeExample ../../examples/mapping/saveUserSelection.txt -noswf
		 */
		public function saveUserSelection():void
		{
			DataStorage.setVariable("storeID", selectedStore);
			DataStorage.setVariable("userZip", userZip);
		}
		
		private function _loadXML():void
		{
			var finalURL:String = baseURL + _userZip;
			_dataLoaded = false;
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, _xmlLoaded, false, 0, true);
			_xmlLoader.load(new URLRequest( finalURL ));
		}
		private function _xmlLoaded(e:Event):void 
		{
			_dataLoaded = true;
			_storeXML = XML(e.target.data);
			if (_mapLoaded)
			{
				_plotMarkers();
			}
		}
		
		private function _plotMarkers():void
		{
			_map.removeAllMarkers();
			var entry:XML;
			for each(entry in _storeXML.collection.data)
			{
				var lat:Number = entry.@latituderadians * 180 / Math.PI;
				var lng:Number = entry.@longituderadians * 180 / Math.PI;
				var dataObj:Object = { };
				var attrib:XML;
				for each(attrib in entry.attributes())
				{
					dataObj[ attrib.name().toString() ] = attrib.toString();
				}
				dataObj.userZip = _userZip;
				_map.createMarkerAt(lat, lng, new markerIconClass(), dataObj);
			}
			
			_map.fitAllMarkers();
			_map.centerOnMarker( _map.markerArray[0] );
		}
		
		private function _mapReady(e:PrMapEvent):void 
		{
			_mapLoaded = true;
			_map.zoomControlEnabled = zoomControlEnabled;
			_map.positionControlEnabled = positionControlEnabled;
			_attachListeners();
			if (_dataLoaded)
			{
				_plotMarkers() 
			}
		}
		
		private function _attachListeners():void
		{
			_map.addEventListener(PrMapEvent.GEOCODING_SUCCESS, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.GEOCODING_FAILURE, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.MAP_READY, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.MARKER_OVER, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.MARKER_CLICK, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.MARKER_OUT, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.PROGRESS, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.FAILURE, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.ZOOM_IN, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.ZOOM_OUT, _eventBubbler, false, 0, true);
			_map.addEventListener(PrMapEvent.MAP_MOVE, _eventBubbler, false, 0, true);
		}
		
		private function _handleMarkerClick(e:PrMapEvent):void 
		{
			var m:PrMarker = e.feature as PrMarker;
			_selectedStore = m.dataObject.storeid;
			trace("Saving user store selection: " + _selectedStore);
			saveUserSelection();
			_map.displayInfoWindow(m);
		}
		private function _eventBubbler(e:Event):void
		{
			dispatchEvent(e);
		}
	}
	
}
