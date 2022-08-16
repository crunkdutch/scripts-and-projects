package PointRollAPI_AS3.data
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.events.data.AdControlEvent;
	import PointRollAPI_AS3.util.StringUtil;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @eventType PointRollAPI_AS3.events.data.AdControlEvent.LOAD_FAIL
	 * @see AdControl#load()
	 * @includeExample ../../examples/AdControl/AdControlEvent.txt -noswf
	 */
	[Event(name = "onLoadFail", type = "PointRollAPI_AS3.events.data.AdControlEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.data.AdControlEvent.PROGRESS
	 * @see AdControl#load()
	 * @includeExample ../../examples/AdControl/AdControlEvent.txt -noswf
	 */
	[Event(name = "onProgress", type = "PointRollAPI_AS3.events.data.AdControlEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.data.AdControlEvent.LOAD_COMPLETE
	 * @see AdControl#load()
	 * @includeExample ../../examples/AdControl/AdControlEvent.txt -noswf
	 */
	[Event(name = "onComplete", type = "PointRollAPI_AS3.events.data.AdControlEvent")]
	
	/**
	 * @eventType PointRollAPI_AS3.events.data.AdControlEvent.ZIP_CHANGED
	 * @see AdControl#changeZip()
	 * @includeExample ../../examples/AdControl/changeZip.txt -noswf
	 */
	[Event(name = "zipChanged", type = "PointRollAPI_AS3.events.data.AdControlEvent")]
	
	/**
	* The AdControl system simplifies the process of generating an ad unit driven by dynamic content. This class provides functionality for loading dynamic data.
	* <p>The Flash API's AdControl class handles communication between the PointRoll servers and the ad unit, providing the designer easy access to the returned XML data.</p>
	* <p>A typical AdControl scenario would be as follows:</p>
	* <ol><li>Instantiate AdControl</li>
	* <li>Set any custom inputs</li>
	* <li>Call <code>load()</code></li>
	* <li>Listen for <code>LOAD_COMPLETE</code> event, and take any additional needed steps.</li></ol>
	* @author Maggy Maffia - PointRoll
	* @includeExample ../../examples/AdControl/xmlExample.txt -noswf
	* @includeExample ../../examples/AdControl/AdControl.txt -noswf
	*/
	public class AdControl extends EventDispatcher
	{
		/**
		 * One of ten optional custom inputs to set before calling <code>load()</code>.
		 * <p>See main class description for code sample and further details on this property's use.</p>
		 * @see AdControl
		 */
		public var Custom1:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom2:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom3:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom4:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom5:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom6:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom7:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom8:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom9:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom10:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom11:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom12:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom13:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom14:String;
		/**
		 * @copy AdControl#Custom1
		 * @see AdControl
		 */
		public var Custom15:String;
		
		/**
		 * The BTData object holds behavioral targeting data provided by the publisher or 3rd party sources. You should not need to directly modify this property. 
		 * The data should be populated via the AdControl Server-to-Server system.
		 */
		public var BTData:Object = { };
		/**
		 * By setting this property to a local XML file, you may test the behavior of your creative without 
		 * calling the AdControl server.  This property will be ignored when the ad is uploaded into AdPortal.
		 */
		public var localTestFile:String;
		
		/** The ID associated with the AdControl interface which will be used to load dynamic content.  
		* This value must be set prior to calling the <code>load()</code> method. 
		* @includeExample ../../examples/AdControl/AdControl.txt -noswf
		*/
		public var interfaceID:String;
		
		/** When set to <code>true</code> any Server-to-Server data will be cleared after the first time it is read.  If set to <code>false</code> each time <code>load()</code> is called, the same STS data will be returned.
		 * You may manually clear the STS data at any time by calling <code>clearSTSData()</code>
		 **/
		public var clearSTSonLoad:Boolean = true;
		
		private var _xmlData:XML;
		private var xmlLoader:URLLoader;
		
		private var baseURL:String = "http://control.ads.pointroll.com/AdControl/?";
		private var params:Object;
		private var xmlRequest:URLRequest;
		private var finalURL:String;
		
		private var _newZip:String;
		private var _autoLoad:Boolean;
		
		//parameters to pass through to server request
		private const queryParams:Object = 
		{
			campid: "PRCampID",
			pub: "PRPubID",
			pid: "PRPID",
			cid: "PRCID",
			imp: "PRImpID",
			creativesz: "PRAdSize",
			dispfmt: "PRFormat",
			countryid: "PRGeoCountryID",
			regionid: "PRGeoRegionID",
			metroid: "PRGeoMetroID",
			dayofweek: "PRDOWID",
			date: "PRUserTime",
			custgeo01:"CustomGeo1",
			custgeo02:"CustomGeo2", 
			custgeo03:"CustomGeo3"
		};
		
		/**
		 * The constructor for the AdControl class, requiring a scope to be specified. Provides access to the <code>load()</code> and <code>getXMLData()</code> methods.
		 * @param	scope A reference to the scope of the ad.
		 * @includeExample ../../examples/AdControl/xmlExample.txt -noswf
		 * @includeExample ../../examples/AdControl/AdControl.txt -noswf
		 */
		public function AdControl(scope:DisplayObject)
		{	
			xmlLoader = new URLLoader();
			if (!StateManager.root)
			{
				StateManager.setRoot(scope);
			}
			
			params = StateManager.URLParameters;
			
			if (params.PRUserTime == null)
			{
				params.PRUserTime = new Date().getTime();
			}
			
			//by default, use the interface id passed in by the AdControl preview page
			interfaceID = params.PRInterfaceID;
		}
		
		/** @private */
		private function getMonthString(month:Number):String
		{
			var monthNamesArr:Array = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
			return monthNamesArr[month];
		}
		
		/**
		 * Loads the AdControl data from PointRoll's servers along with any set custom inputs.
		 * @includeExample ../../examples/AdControl/load.txt -noswf
		 */
		public function load():void
		{
			_xmlData = null;
			if(!interfaceID)
			{
				throw(new Error("You must specify an AdControl interface ID prior to calling load()"));
				return
			}
			var dataStorageValue:String = checkDataStorage("AC" + interfaceID);
			PrDebug.PrTrace("Retrieved AC data from DS: " + dataStorageValue + " isValid? "+validateDSString(dataStorageValue),5,"AdControl");
			
			//use the DS data only if it is valid AND we are not on the AC test page
			if (validateDSString(dataStorageValue) && !params["PRACTest"+interfaceID])
			{
				PrDebug.PrTrace("Using DS Value",5,"AdControl");
				
				trace("Checking for BT data");
				var bt:String = checkDataStorage("BT" + interfaceID.toUpperCase());
				if (validateDSString(bt))
				{
					trace("valid BT Data: " + bt);
					processBT(bt);
				}
				
				_xmlData = new XML(dataStorageValue);
				
				if(clearSTSonLoad) 
					clearSTSData("AC" + interfaceID);
				
				dispatchEvent(new AdControlEvent(AdControlEvent.LOAD_COMPLETE));
			}
			else
			{
				PrDebug.PrTrace("Loading from server",5,"AdControl");
				xmlLoader.addEventListener(Event.COMPLETE, _loadedHandler);
				xmlLoader.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, _failHandler);
				
				if ( localTestFile && StateManager.getPlatformState() == StateManager.TESTING )
				{
					xmlLoader.load(new URLRequest(localTestFile));
					return;
				}
				
				//prepare URL
				finalURL = baseURL;
				
				//if on the AdPortal preview page, grab the appropriate testing url
				if (params["PRACTest" + interfaceID])
				{
					finalURL = params["PRACTest"+interfaceID];
				}
				
				for (var s:String in queryParams)
				{
					addParameterToURL(s, params[ queryParams[s] ]);
				}
				
				for (var b:String in BTData)
				{
					addParameterToURL(b, BTData[b]);
				}
			
				addParameterToURL("ifid", interfaceID);
				
				//maximum of 10 custom parameters
				var i:uint = 1;
				while (i <= 15)
				{
					//the AdControl script looks for the parameters in the format: cust01, etc
					var pname:String = "cust";
					pname += (i < 10) ? String("0" + i):String(i);
					
					//if we're on the AdPortal demo page, some custom parameters may have already been added to the url
					if (StringUtil.contains(finalURL, pname))
					{
						break;
					}
					addParameterToURL(pname, this["Custom" + i]);
					i++;
				}
				
				PrDebug.PrTrace("AdControl URL: "+encodeURI(finalURL),5,"AdControl");
				xmlLoader.load(new URLRequest(finalURL));
			}
		}
		
		/** @private */
		private function checkDataStorage(name:String):String
		{
			trace("check ds: "+name.toUpperCase());
			return unescape(DataStorage.getVariable(name.toUpperCase()));
		}
		
		/** 
		 * Clears the Server-to-Server response for the given AdControl interface. This method is called automatically if <code>clearSTSonLoad</code> is set to <code>true</code>.
		 * @param name The name of the DataStorage variable to clear, in the form "AC"+ AdControl Interface ID
		 **/
		public function clearSTSData(name:String):void 
		{
			DataStorage.setVariable(name.toUpperCase(), "");
		}
		
		private function validateDSString( dataStorageValue:String ):Boolean
		{
			//ridiculously long list of conditions must be met
			return (dataStorageValue != "undefined" && dataStorageValue != null && dataStorageValue != "null" && dataStorageValue != "")
		}
		
		private function processBT(bt:String):void
		{
			//the BT data is passed in as a comma-delimited string - we need to manually associate the values with the AC properties
			var b:Array = bt.split(",");
			BTData = { };
			BTData.sex_pref = b[0];
			BTData.edu_level = b[1];
			BTData.gender = b[2];
			BTData.year_of_birth = b[3];
			BTData.under_18 = b[4];
			BTData.age_range = b[5];
			BTData.marital_stat = b[6];
			BTData.num_children = b[7];
			BTData.h_income = b[8];
			BTData.neighborhood = b[9];
			BTData.pub_category = b[10];
			BTData.ven_category = b[11];
		}
		
		/**
		 * This function will return the XML object obtained from PointRoll's servers when the AdControl request is complete. It will return <code>null</code> until the <code>LOAD_COMPLETE</code> event has been fired.
		 * @includeExample ../../examples/AdControl/getXMLData.txt -noswf
		 */
		public function getXMLData():XML
		{
			return _xmlData;
		}
		
		/**
		 * This function will change the zipcode for which to load the AdControl data, and will dispatch the ZIP_CHANGED event. By setting the <code>autoLoad</code> parameter to false, you may choose to 
		 * not automatically (re)load the data. 
		 * @param	newZip The new zipcode to set.
		 * @param	autoLoad Specifies whether or not to load the AdControl data after changing the zip code. By default, this is set to <code>true</code>.
		 * @see #event:zipChanged
		 * @includeExample ../../examples/AdControl/changeZip.txt -noswf
		 */
		public function changeZip(newZip:String, autoLoad:Boolean=true):void
		{
			_newZip = newZip;
			_autoLoad = autoLoad;
			var _geoLocation:String = "http://ads.pointroll.com/portalserve/?postal&code="+_newZip+"&pid="+params.PRPID;
			
			var geoLoader:URLLoader = new URLLoader();
			geoLoader.addEventListener(Event.COMPLETE, _geoDataLoaded);
			geoLoader.addEventListener(IOErrorEvent.IO_ERROR, _failHandler);
			geoLoader.load(new URLRequest(_geoLocation));
		}
		
		
		/** @private */
		private function addParameterToURL(name:String, value:String):void
		{
			if (value != null && value != "")
			{
				//encode only Custom inputs, *NOT* CustomGeo
				if (name.indexOf("cust") > -1 && name.indexOf("geo") == -1)
				{
					value = escape(value);
				}
				if (!StringUtil.endsWith(finalURL, "?"))
				{
					finalURL += "&";
				}
				finalURL += name + "=" + value;
			}
		}
		
		/**
		 * @private
		 */
		public function get destURL():String
		{
			return finalURL;
		}
		
		/** @private */
		private function _failHandler(e:IOErrorEvent):void
		{
			dispatchEvent(new AdControlEvent(AdControlEvent.LOAD_FAIL));
			xmlLoader.removeEventListener(Event.COMPLETE, _loadedHandler);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _failHandler);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
		}
		
		/** @private */
		private function _progressHandler(e:ProgressEvent):void
		{
			dispatchEvent(new AdControlEvent(AdControlEvent.PROGRESS));
		}
		
		/** @private */
		private function _loadedHandler(e:Event):void
		{
			_xmlData = new XML(e.target.data);
			xmlLoader.removeEventListener(Event.COMPLETE, _loadedHandler);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _failHandler);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			dispatchEvent(new AdControlEvent(AdControlEvent.LOAD_COMPLETE));
		}
		
		/** @private */
		private function _geoDataLoaded(e:Event):void
		{
			var _geoData:XML = new XML(e.target.data);
			
			for each (var p:XML in _geoData.elements())
			{
				params[p.name()] = p.toString();
			}
			
			dispatchEvent(new AdControlEvent(AdControlEvent.ZIP_CHANGED));
			
			if (_autoLoad) load();
			
		}
		
	}
	
}