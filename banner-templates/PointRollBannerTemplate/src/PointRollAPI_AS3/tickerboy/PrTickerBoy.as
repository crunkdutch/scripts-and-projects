package PointRollAPI_AS3.tickerboy
{
	import PointRollAPI_AS3.ActivityController;
	import PointRollAPI_AS3.ISingleton;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent;
	import PointRollAPI_AS3.net.URLHandler;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	/**
	 * @eventType PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent.EXPAND
	 * @see PrTickerBoy#tickerExpand()
	 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
	 */
	[Event(name = "onExpand", type = "PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent.COLLAPSE
	 * @see PrTickerBoy#tickerCollapse()
	 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
	 */
	[Event(name = "onCollapse", type = "PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent.HIDE
	 * @see PrTickerBoy#tickerHide()
	 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
	 */
	[Event(name = "onHide", type = "PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent.CLICKTHRU
	 * @see PrTickerBoy#launchURL()
	 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_events.txt -noswf
	 */
	[Event(name = "onClickThru", type = "PointRollAPI_AS3.events.tickerboy.PrTickerBoyEvent")]

	/**The PrTickerBoy class provides access to functions specific to the "TickerBoy" product line.  
	 * Implementing this class will allow you to control the expansion state of the creative, launch URL calls and track TickerBoy activities. 
	 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_cleanUp.txt -noswf
	 */
	public class PrTickerBoy extends EventDispatcher implements IPrTickerBoy, ISingleton
	{
		private var TICKER_EXPAND:Number = 8990;
		private var TICKER_SHOW:Number = 8991;
		
		static private var m_oInstance:PrTickerBoy;
		private var m_bIsFlash:Boolean = false;
		private var m_sState:String = "collapsed";
		private var m_oActivityControl:ActivityController;
		
		private var m_aEventArray:Array = new Array("onHide", "onExpand", "onCollapse");
		private var m_oURLHandler:URLHandler;
		/** @private */
		public function PrTickerBoy( myRoot:DisplayObject, s:SingletonEnforcer=null){
			if (!s)
			{ 
				throw(new PrError(PrError.SINGLETON));
			}
			m_oActivityControl = ActivityController.getInstance(myRoot);
			Security.allowDomain( StateManager.root.loaderInfo.loaderURL );
			if( (StateManager.getPlatformState() == StateManager.FLASHONLY) || (StateManager.getPlatformState() == StateManager.TESTING)){
				m_bIsFlash = true;
			}
			m_oURLHandler = new URLHandler();
		}
		/**
		 * Creates and returns a PrTickerBoy object for use within your creative.
		 * @param	myRoot scope A reference to the main timeline of your creative.  Generally you will pass the keyword 'this' as the parameter.
		 * @return a PrTickerBoy object
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_getInstance.txt -noswf
		 */
		public static function getInstance(myRoot:DisplayObject):PointRollAPI_AS3.tickerboy.PrTickerBoy{
			//Reset the root if it does not match the current one. In FiF situations, the same Singleton could possibly be reused
			if (m_oInstance == null || ( myRoot != null && StateManager.root != myRoot.root) )
			{
				m_oInstance = new PrTickerBoy(myRoot, new SingletonEnforcer());
			}
			return m_oInstance;
		}
		
		
		/**
		 * Records a user activity
		 * @param	a The activity number, a positive integer.
		 * @param	unique Set this value to true if you wish the activity to only be recorded once per viewing of the creative
		 * @param	noun When a campaign makes use of dynamic data, the noun parameter may be set to identify the source of a particular activity.  
		 * 				For instance, if displaying a number of products from a catalog you can pass the name of each item as it is clicked by the user.
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_activity.txt -noswf
		 */
		public function activity(a:Number,unique:Boolean=false,noun:String=null):void
		{
			m_oActivityControl.activity(a,unique,noun);
		}
		
		/**
		 * @see #event:onExpand
		 * @inheritDoc 
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_tickerExpand.txt -noswf
		 */
		public function tickerExpand():void
		{
			PrDebug.PrTrace("TB Expand",1,"TickerBoy");
			m_sState = "expanded";
			if(m_bIsFlash){
				activity(TICKER_EXPAND);
			}else{
				ExternalInterface.call("ticker.prTickerExpand();");
			}
			dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.EXPAND)); 
//			StateManager.root.dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.EXPAND)); 
		}
		
		/**
		 * @see #event:onCollapse
		 * @inheritDoc 
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_tickerCollapse.txt -noswf
		 */
		public function tickerCollapse():void
		{
			PrDebug.PrTrace("TB Collapse",1,"TickerBoy");
			
			if(m_bIsFlash){
				if(m_sState=="hidden"){
					activity(TICKER_SHOW);
				}
			}else{
				ExternalInterface.call("ticker.prTickerShow();");
			}
			m_sState = "collapsed";
			dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.COLLAPSE)); 
//			StateManager.root.dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.COLLAPSE)); 
		}
		/**
		 * @see #event:onHide
		 * @inheritDoc 
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_tickerHide.txt -noswf
		 */
		public function tickerHide():void
		{
			PrDebug.PrTrace("TB Hide",1,"TickerBoy");
			m_sState = "hidden";
			if(!m_bIsFlash){
				ExternalInterface.call("ticker.prTickerHide();");
			}
			dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.HIDE)); 
//			StateManager.root.dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.HIDE)); 
		}
		/**
		 * @copy PointRollAPI_AS3.net.URLHandler#launchURL()
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_launchURL.txt -noswf
		 */
		public function launchURL(url:String, window:Boolean=true,noun:String=null):void{
			m_oURLHandler.launchURL(url, window, noun);
			dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.CLICKTHRU)); 
//			StateManager.root.dispatchEvent(new PrTickerBoyEvent(PrTickerBoyEvent.CLICKTHRU)); 
		}
		/**
		 * @copy PointRollAPI_AS3.net.URLHandler#beacon()
		 * @includeExample ../../examples/PrTickerBoy/PrTickerBoy_beacon.txt -noswf
		 */
		public function beacon(url:String):void{
			m_oURLHandler.beacon(url);
		}
		/**
		 * @private
		 * Initiates the kill procedure of the StateManager
		 */
		public function kill():void
		{
			StateManager.broadcastKill();
			m_oInstance = null;
		}
		/**
		 * @private
		 * Currently undocumented functionality.  This function returns the currently recognized list of events for this object.  
		 * The intended usage is to expose events to publishers using our Flash-in-Flash delivery.
		 * @return
		 */
		public function eventArray():Array{
			PrDebug.PrTrace("Called Event Array: "+m_aEventArray,1,"TickerBoy");
			return m_aEventArray.slice();
		}
		/**
		 * @private
		 * Currently undocumented functionality.  This function allows the designer to add a new event type for this object.  
		 * The intended usage is to expose events to publishers using our Flash-in-Flash delivery.
		 * @param	s
		 */
		public function addEventType(s:String):void{
			m_aEventArray.push(s);
			PrDebug.PrTrace("Event added: "+s,1,"TickerBoy");
		}
	}
}
class SingletonEnforcer{}