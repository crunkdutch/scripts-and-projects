package PointRollAPI_AS3
{
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;

	/**
	 * The StateManager class retrieves configuration data from the url string and/or FlashVars and uses them to determine 
	* the "state" of the ad unit.  <b>The StateManager class is automatically employed by various classes in the PointRoll API, and should not 
	* need to be used directly within your creative.</b>
	* @author Chris Deely - PointRoll
	* @version 0.1
	* 
	*/

	public class StateManager{		
		//States
		private static var m_sDisplayState:String = "BANNER";
		private static var m_sPlatformState:String = "JSPLATFORM";
		//activity states
		/** Denotes that the ad is in a Banner state*/
		public static const BANNER:String = "BANNER";
		/** Denotes that the ad is in a Panel state*/
		public static const PANEL:String = "PANEL";
		/** Denotes that the ad is in a testing state*/
		public static const TESTING:String = "TESTING";
		//platform states
		/** Denotes that the ad is deployed using the JavaScript platform*/
		public static const JSPLATFORM:String = "JSPLATFORM";
		/** Denotes that the ad is deployed as Flash-only*/
		public static const FLASHONLY:String = "FLASHONLY";
		/** Denotes that the ad is deployed as an Instant Messanger Popup unit*/
		public static const POPUP:String = "POPUP";
		/** Name of the event broadcast when a publisher removes a Flash-in-Flash PointRoll Ad from their page.
		 *  Listening for this event will give you an opportunity to cleanup your ad unit by stopping sounds, unloading movie clips, etc. */
		public static const KILL:String = "prKillAdUnit";
		
		/**A shortcut property to obtain any FlashVars and/or URL parameters for the current SWF*/
		public static var URLParameters:Object = {};
		
		/** A reference to the active Stage, as determined by the scope object provided by the designer*/
		public static var stage:Stage;
		/** A reference to the root as determined by the scope object provided by the designer*/
        public static var root:DisplayObject;
		/** The major Flash Player version on the user's system */
		public static var flashVersion:Number;
		/** The complete Flash Player version string. Equivilent to flash.system.Capabilities.version 
		 * @see flash.system.Capabilities#version
		 * */
		public static var fullFlashVersion:String;
		/** The PointRoll API version in use on the designer's system at publish time*/
		public static var APIVersion:String = "MXP Version: AS3_6.4.0.35";
		/** Indicates if the user's Flash Player is capable of displaying HD Video content.  The minimum Flash Player version 
		 * required is 9,0,115,0.  The build version (115) DOES matter, as earlier builds of Flash Player 9 do not support the H264 codec.
		 * @see PointRollAPI.media.PrVideo#startVideo()
		 * @see PointRollAPI.media.PrVideo#HDCapable
		 * @see PointRollAPI.media.HDDelivery
		 * */
		public static var HDEnabled:Boolean = false;
		
		/** @private */
		public function StateManager(s:SingletonEnforcer){}
		  
		 /**
		  * Initializes the StateManager using the supplied DisplayObject to obtain access to the <code>stage</code> and <code>root</code>.
		  * <br/>This class is used by various elements of the PointRoll API, and should not normally be referenced directly.
		  * @param	myRoot A reference to the scope of the ad unit.  Generally will be the keyword <code>this</code>
		 * @throws PointRollAPI_AS3.errors.PrError If the configuration state is not recognized
		  */
		public static function setRoot(myRoot:DisplayObject):void
		{
			PrDebug.PrTrace("PointRoll API AS3 "+APIVersion,3,"StateManager");
			PrDebug.PrTrace("Initializing StateManager "+myRoot,5,"StateManager");
			root = myRoot.root;
			stage = myRoot.stage;
			URLParameters = root.loaderInfo.parameters;
			_setState(URLParameters);
			_checkVersion();
		}
		/**
		 * Returns the current platform state
		 * @return One of the predefined states: TESTING, JSPLATFORM, FLASHONLY or POPUP
		 */
		public static function getPlatformState():String
		{
			return m_sPlatformState;
		}
		/**
		 * Returns the current display state
		 * @return One of the predefined states: TESTING, BANNER or PANEL
		 */
		public static function getDisplayState():String
		{
			return m_sDisplayState;
		}
		
		/**
		 * @private
		 * Broadcasts the 'kill' command to all registered objects.  This allows our API classes to perform cleanup when removed from 
		 * a publisher's page.
		 */
		public static function broadcastKill():void
		{
			dispatchEvent(new Event(StateManager.KILL));
			stage = null;
			root = null;
		}
		/** @private */
		protected static var disp:EventDispatcher;
		
		/**
		 * Permits you to listen for events from the StateManager class.  The usage is exactly the same as the EventDispatcher class.
		 * @see flash.events.EventDispatcher
		 */
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
			if (disp == null) { disp = new EventDispatcher(); }
			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		/**
		 * Permits you to remove event listeners from the StateManager class.  The usage is exactly the same as the EventDispatcher class.
		 * @see flash.events.EventDispatcher
		 */
		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
			if (disp == null) { return; }
			disp.removeEventListener(p_type, p_listener, p_useCapture);
		}
		/**
		 * Permits you to dispatch events from the StateManager class.  The usage is exactly the same as the EventDispatcher class.
		 * @see flash.events.EventDispatcher
		 */
		public static function dispatchEvent(p_event:Event):void {
			if (disp == null) { return; }
			disp.dispatchEvent(p_event);
		}

		
		
		private static function _setState(params:Object):void
		{
			
			//Debug level
			if ( uint( params.prDebugLevel ) > 0 )
			{
				PrDebug.debugLevel = uint( params.prDebugLevel );
			}
			
			//Use Testing control to avoid errors inside Flash IDE
			if (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone" || uint(params.prTestingPlatform)==1)
			{
				enableTestingMode();
				return;
			}
			
			//Platform
			if ( params.prSwfOnly == 1 )
			{
				m_sPlatformState = FLASHONLY;
			}else if ( params.prPopUp == 1 )
			{
				m_sPlatformState = POPUP;
			}else{
				m_sPlatformState = JSPLATFORM;
			}
			
			//Display
			if ( params.PRAd != null )
			{
				m_sDisplayState = BANNER;
			}else if (params.PRPanel != null)
			{
				m_sDisplayState = PANEL;
			}else {
				PrDebug.PrTrace("Unrecognized Environment",3,"StateManager.as");
				enableTestingMode();			
			}
			
		}
		
		/** @private
		 * Undocumented, as this should be handled automatically*/
		public static function enableTestingMode():void
		{
			PrDebug.PrTrace("Ad Testing Mode Enabled", 3, "StateManager");
			m_sDisplayState = TESTING;
			m_sPlatformState = TESTING;
		}
		//*** Get version of player
		private static function _checkVersion():void
		{
			fullFlashVersion = Capabilities.version;
			var p:Array = fullFlashVersion.split(" ")[1].split(",");
			flashVersion = Number(p[0]);
			if (flashVersion > 8)
			{
				if(flashVersion > 9)
				{
					HDEnabled = true;
				}else
				{
					//look for specific build of Flash Player 9: 9,0,115,0 or higher
					if (Number(p[1]) > 0)
					{
						HDEnabled = true;
					}else if ( Number(p[2]) >= 115)
					{
						HDEnabled = true;
					}
				}
				
			}
		}
	}
}
class SingletonEnforcer{}