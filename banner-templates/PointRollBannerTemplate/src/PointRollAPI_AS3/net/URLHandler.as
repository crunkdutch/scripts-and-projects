

package PointRollAPI_AS3.net 
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.panel.PanelController;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.external.ExternalInterface;
	import flash.net.*;

	/**
	* Handles various URL functions such as executing beacons and click thrus.  This object is used by the PointRoll and PrTickerBoy 
	* objects, and should not need to be implemented directly.  It is listed here for completeness.
	* @author Chris Deely - PointRoll
	* @version 1.0
	*/
	public class URLHandler {
		/** Creates a new URLHandler object */
		public function URLHandler(){}
		/**
		 * If you want to put a tracking pixel within your flash movie you will need the beacon method. 
		 * There are only certain cases you would want to do this. Most of the time you can give your third party tracking to PointRoll to implement for you. 
		 * @param	url The URL of the beacon image
		 * @includeExample ../../examples/URLHandler/URLHandler_beacon.txt -noswf
		 */
		public function beacon(u:String):void
		{
			switch(StateManager.getPlatformState())
			{
				case StateManager.POPUP:
					var m_oLC:LocalConnection = new LocalConnection();
					m_oLC.send("pr_lc_popUp","pr_popControl","prBeacon",u);
					m_oLC = null;
					break;
				case StateManager.JSPLATFORM:
					ExternalInterface.call("prBeacon",u);
					break;
				case StateManager.FLASHONLY:
					var beaconLoader:URLLoader = new URLLoader();
					beaconLoader.load( new URLRequest(u) );
					break;
				case StateManager.TESTING:
					break;
				default:
					throw( new PrError(PrError.NOT_ALLOWED_FROM_STATE));
			}
			PrDebug.PrTrace("Hit Beacon: "+u,1,"URLHandler");
		}
		/**
		 * Opens a URL in a browser window
		 * @param	url	The destination URL
		 * @param	window Set to false if you wish to open the new URL inside the current window/tab.
		 * @param sNoun When a campaign makes use of dynamic data, the noun parameter may be set to identify the source of a particular clickthru. 
		 * For instance, if displaying a number of products from a catalog you can pass the name of each item as it is clicked by the user. 
		 * @includeExample ../../examples/URLHandler/URLHandler_launchURL.txt -noswf
		 */
		public function launchURL(url:String,window:Boolean=true,sNoun:String=null):void
		{
			/*Atlas click tracking
				prInteract(q,o,prz,c)
					q = activity type (bc  = banner click; pc = panel click)
					o = 1 (value not important, just needs to be a positive integer)
					prz = Imp ID
					c = 1 (should be a positive integer)
			*/
			try{
				ExternalInterface.call("prInteract", (StateManager.getDisplayState() == StateManager.PANEL) ? "pc":"bc", 1, StateManager.URLParameters.PRImpID, 1);
			}catch(e:Error)
			{
				PrDebug.PrTrace("Failed to track click thru: "+e.toString(),4,"URLHandler");
			}
			
			if( StateManager.URLParameters.prOOBCT != null ){
				var oob:URLLoader = new URLLoader();
				oob.load( new URLRequest(  _replace( StateManager.URLParameters.prOOBCT,"$RANDOM$", String( Math.random()) ) ) );
			}
			if( StateManager.URLParameters.PRRetargExp != null ){
				var retarg:URLLoader = new URLLoader();
				retarg.load( new URLRequest( "http://ads.pointroll.com/Retarget/?campid="+StateManager.URLParameters.PRCampID+"&evtid=4&exp="+StateManager.URLParameters.PRRetargExp+"&r="+Math.random()) );
			}
			if(url != null && url != ""){
				if (sNoun != null) 
				{
					url = _replace(url,"$NOUN$",escape(sNoun));
				}
				var request:URLRequest = new URLRequest(url);
				PrDebug.PrTrace("Launch URL: "+url,1,"URLHandler");
				if(window)
				{
					var ea:Boolean = false;
					var strUserAgent:String;
					
					//ExternalInterface.available seems to throw an undocumented error when requestor is from a different domain and the 
					// main swf is embedded with allowScriptAccess=sameDomain
					try{
						ea = ExternalInterface.available;
						strUserAgent = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
					}catch(e:Error){}
					
					if (!ea || !strUserAgent) {
						trace("external interface unavailable.");
						navigateToURL(request, "_blank");
					} else {
						
						trace("User Agent: " + strUserAgent);
						if (strUserAgent.indexOf("firefox") != -1 || strUserAgent.indexOf("msie") != -1) {
							trace("Call using JS");
							ExternalInterface.call("window.open", request.url, "_blank");
						} else {
							trace("Navigate to URL");
							navigateToURL(request, "_blank");
						}
					}
				}
				else
				{
					navigateToURL(request, "_self");
				}
				if(StateManager.getPlatformState() == StateManager.POPUP)
				{
					PanelController.getInstance(StateManager.root).close();
				}
			}else {
				var output:String = "Click Tag Undefined";
				if (sNoun != null)
				{
					output += ", Noun: " + sNoun;
				}
				PrDebug.PrTrace(output,1,"URLHandler");
			}
		}
		
		private function _replace(string:String,pattern:String,replace:String):String{
			return string.split(pattern).join(replace);
		}
	}
	
}
