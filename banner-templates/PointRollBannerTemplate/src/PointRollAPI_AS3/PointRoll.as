package PointRollAPI_AS3
{
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.events.PanelEvent;
	import PointRollAPI_AS3.net.URLHandler;
	import PointRollAPI_AS3.panel.PanelController;
	import PointRollAPI_AS3.util.debug.PrDebug;
	import PointRollAPI_AS3.util.domain.Domain;

	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Timer;

	/**
	 * @eventType PointRollAPI_AS3.events.PanelEvent.PANEL_CLOSED
	 * @includeExample ../examples/PointRoll/events/PanelEvent.txt -noswf
	 */
	[Event(name = "panel closed", type = "PointRollAPI_AS3.events.PanelEvent")]
	
	/**
	 * Provides simple and straight forward access to all core panel and activity functionality that is currently available through 
	 * the PointRoll system. The PointRoll object will be used in virtually all Rich Media ad executions.
	 * <p>The PointRoll object provides designers with the ability to record user activities, execute click thrus and control the display 
	 * of ad panels.</p>
	 * <p>In the AS3 API, PointRoll objects are created via a call to <code>PointRoll.getInstance( this )</code>.  
	 * This change allows for the re-use of a single PointRoll object throughout your creative, which makes your ad unit 
	 * lighter and more responsive.</p>
	 * @see PointRoll#getInstance() getInstance()
	 */
	public class PointRoll extends EventDispatcher implements IPanelControl, ISingleton{
		private static var m_oInstance:PointRoll;
		//Added for API 5.0 - Flash-in-Flash
		private var m_aEventArray:Array = new Array();
		/////////////////////////////////////		
		private var m_oPanelControl:IPanelControl;
		private var m_oActivityControl:ActivityController;
		private var m_oURLHandler:URLHandler;
		private var checkPnlTimer:Timer;
		
	//***     Public Functions
		/**
		 * @private 
		 * Constructor is a Singleton - use PointRoll.getInstance()
		 * @param	scope
		 * @param	s
		 * @throws PointRollAPI_AS3.errors.PrError 
		 */
		public function PointRoll( scope:DisplayObject, s:SingletonEnforcer)
		{
			if (!s) { throw(new PrError(PrError.SINGLETON)); }
			m_oPanelControl = PanelController.getInstance(scope);
			m_oActivityControl = ActivityController.getInstance(scope);
			PrDebug.PrTrace("Version string is: "+StateManager.fullFlashVersion+" API: "+StateManager.APIVersion);
			m_oURLHandler = new URLHandler();
			Security.allowDomain( StateManager.root.loaderInfo.loaderURL );
		}
		/**
		 * Creates and returns a PointRoll object for use within your creative.
		 * @param	scope A reference to the main timeline of your creative.  Generally you will pass the keyword 'this' as the parameter.
		 * @return  Returns a PointRoll instance for use within your creative
		 * @includeExample ../examples/PointRoll/PointRoll_getInstance.txt -noswf
		 */
		public static function getInstance( scope:DisplayObject ):PointRoll{
			if(m_oInstance == null){
				m_oInstance = new PointRoll(scope, new SingletonEnforcer());
			}
			return m_oInstance;
		}
		/**
		 * Records a user activity
		 * @param	a The activity number, a positive integer.
		 * @param	unique Set this value to true if you wish the activity to only be recorded once per viewing of the creative
		 * @param	noun When a campaign makes use of dynamic data, the noun parameter may be set to identify the source of a particular activity.  
		 * 				For instance, if displaying a number of products from a catalog you can pass the name of each item as it is clicked by the user.
		 * @includeExample ../examples/PointRoll/PointRoll_activity.txt -noswf
		 * @includeExample ../examples/PointRoll/PointRoll_GameActivity.txt -noswf
		 */
		public function activity(a:Number,unique:Boolean=false,noun:String=null):void
		{
			m_oActivityControl.activity(a,unique,noun);
		}
		/**
		 * Closes the currently open panel.
		 * @includeExample ../examples/PointRoll/PointRoll_close.txt -noswf
		 */
		public function close():void{
			m_oPanelControl.close();
		}
		/**
		 * Opens the appropriate panel. This method is available only within a banner; to move from one panel to another, see <code>goPanel()</code>.
		 * @param	n The ID number of the panel to be displayed.  Panel numbers start at 1 and move upward.
		 * @see PointRoll#goPanel() goPanel()
		 * @includeExample ../examples/PointRoll/PointRoll_openPanel.txt -noswf
		 */
		public function openPanel(n:int):void
		{
			if (hasEventListener(PanelEvent.PANEL_CLOSED))
			{
				checkPnlTimer = new Timer(50);
				checkPnlTimer.addEventListener(TimerEvent.TIMER, _onCheckPnl, false, 0, true);
				checkPnlTimer.start();
			}
			m_oPanelControl.openPanel(n);
		}
		
		/**
		 * Closes the currently open panel and displays the requested panel. 
		 * This method is available only within a panel; to move from a banner to a panel, see <code>openPanel()</code>.
		 * @param	n The ID number of the panel to be displayed.  Panel numbers start at 1 and move upward.
		 * @param	auto This parameter has two possible uses:
		 * <ul>
		 * 	<li>when set to <code>true</code>, PointRoll will not record the panel display activity. This is used to avoid extraneous metrics for auto-display panels.</li>
		 *	<li>when set to a number, a corresponding activity will be recorded after the panel is displayed.</li>
		 * </ul>
		 * @see PointRoll#openPanel()
		 * @includeExample ../examples/PointRoll/PointRoll_goPanel.txt -noswf
		 */
		public function goPanel(n:int, auto:Object=undefined):void{
			m_oPanelControl.goPanel(n,auto);
		}
		/**
		 * Forces a panel to remain open until a <code>close()</code> or <code>unPin()</code> command is called.
		 * @see PointRoll#close() close()
		 * @see PointRoll#unPin() unPin()
		 * @includeExample ../examples/PointRoll/PointRoll_pin.txt -noswf
		 */
		public function pin():void{
			m_oPanelControl.pin();
		}
		/**
		 * Revokes a previous <code>pin()</code> command and permits the panel to close when the user moves their mouse off of the creative
		 * @see PointRoll#pin() pin()
		 * @includeExample ../examples/PointRoll/PointRoll_pin.txt -noswf
		 */
		public function unPin():void{
			m_oPanelControl.unPin();
		}
		/**
		 * The delayedPin method will pin the panel open and then fire an activity such that the two events do not cancel each other out,
		 * as the handling of JavaScript in Flash is at times unreliable when firing multiple JavaScript functions simultaneously.
		 * @param	a The activity number to record after the panel has been pinned
		 * @see PointRoll#pin()
		 * @includeExample ../examples/PointRoll/PointRoll_delayedPin.txt -noswf
		 */
		public function delayedPin(a:int=undefined):void{
			m_oPanelControl.delayedPin(a);
		}
		/**
		 * A Push-Down unit is a unit that not only expands upon rollover, but it pushes or slides the content down, 
		 * as opposed to a standard FatBoy which overlays the content. While we provide this functionality openly, 
		 * it is only available on publishers that allow for this type of unit.
		 * @param	t The time, in seconds, over which the push-down should occur
		 * @param	y The distance, in pixels, the push-down should cover
		 * @includeExample ../examples/PointRoll/PointRoll_pushDown.txt -noswf
		 */
		public function pushDown(t:Number,y:Number):void{
			m_oPanelControl.pushDown(t,y);
		}
		/**
		 * The reveal method is most useful when you're trying to maintain the fidelity of the starting animation piece, 
		 * after the panel expansion has taken place. Previously this was difficult, as it was only available in I.E. 
		 * and it rendered all rollover functionality below the creative stage inactive. 
		 * The reveal method now makes it possible to have incredibly seamless expansions, as well as maintain user data and 
		 * states even after the user rolls off the panel. 
		 * <p>A common usage of the reveal function is when you have an Expandable Video ad that need to be built all as one flash file. 
		 * This would essetially be a TomBoy that breaks the barriers of the ad unit. In this case you can reveal and unreveal the transparent area as needed. </p>
		 * 
		 * <p>There are only certain cases you would want to use this technique. You will lose several reporting metrics using this 
		 * method therefore whenever possible your expanding ads should be built as FatBoys.</p>
		 * <p>The reveal method expands the panel to a specified height and width, with a x and y offset for use with expandable video. 
		 * You need to determine the pixel size of the space you want exposed (width and height). These are passed in as the w and h parameters.
		 * You need to determine the offset from the top-left corner of the panel where the "exposed" area starts. 
		 * These are passed in as the x and y parameters. The x and y parameters are optional. </p>
		 * 
		 * <p>If the exposure window starts in the upper left (at 0,0) of the panel space, then you don’t need to bother passing the parameters at all.
		 * So if you want only a 300x250 space to be exposed and that 300x250 block is 200 pixels from the far left edge of the panel and 100 
		 * pixels down from the top edge of the panel, then the parameters would be like this... <code>reveal(300,250,200,100)</code>.</p>
		 * <p>You would use the <code>unReveal()</code> method to hide the transparent area until the user interacts to expand that out. 
		 * You would then reveal that area. Afterwards when the user causes it to retract then you can invoke unReveal again to hide the area. </p>

		 * @param	w  width of what you'd like to expand or hide the panel to
		 * @param	h  height of what you'd like to expand or hide the panel to
		 * @param	x	x offset
		 * @param	y	y offset
		 * @param	track	By default, the <code>reveal</code> method tracks an activity when called. You may optionally set the <code>track</code> 
		 * 					parameter to <code>0</code> if you do not wish to track the activity.
		 * @see PointRoll#unReveal() unReveal()
		 */
		public function reveal(w:Number,h:Number,x:Number=0,y:Number=0,track:Number=1):void
		{
			m_oPanelControl.reveal(w,h,x,y,track);
		}
		/**
		 * The unReveal method is most useful when you're trying to maintain the fidelity of the starting animation piece, after the panel 
		 * expansion has taken place. Previously this was difficult, as it was only available in I.E. and it rendered all rollover functionality 
		 * below the creative stage inactive. The unReveal method now makes it possible to have incredibly seamless expansions, as well as maintain 
		 * user data and states even after the user rolls off the panel. A common usage of the unReveal function is when you have an Expandable Video 
		 * ad that need to be built all as one flash file. This would essetially be a TomBoy that breaks the barriers of the ad unit. 
		 * 
		 * In this case you can reveal and unreveal the transparent area as needed.
		 * 
		 * <p>The unReveal method sets the collapsed display parameters for the ad - essentially "hiding" anything outside of that area.  You need to 
		 * determine the pixel size of the space you want exposed (width and height). These are passed in as the w and h parameters.</p>
		 * 
		 * <p>You need to determine the offset from the top-left corner of the panel where the "exposed" area starts. These are passed in as the x and y 
		 * parameters. The x and y parameters are optional. If the exposure window starts in the upper left (at 0,0) of the panel space, then you don’t
		 * need to bother passing the parameters at all.</p>
		 * 
		 * <p>General use of this feature will be likely be to initially call the function for an "unReveal" at the very beginning (like frame 1) to set 
		 * the initial display window, like unReveal(728,90) for example. </p>
		 * 
		 * <p>Then when the user does whatever that causes you to need the additional transparent space, you call a reveal for the full space, 
		 * like <code>reveal(728,300)</code> for example. </p>
		 * 
		 * <p> And finally when the user is done interacting, if your design contracts back to original size, recall the <code>unReveal</code> again to 
		 * put things back the way they were: <code>unReveal(728,90)</code>.</p>
		 * @param	w  width of what you'd like to expand or hide the panel to
		 * @param	h  height of what you'd like to expand or hide the panel to
		 * @param	x	x offset
		 * @param	y	y offset
		 * @param	track	You may optionally set the <code>track</code> parameter to <code>1</code> if you wish to track an 
		 * 					activity when the <code>unReveal</code> call is made.
		 * @see PointRoll#reveal() reveal()
		 */
		public function unReveal(w:Number,h:Number,x:Number=0,y:Number=0,track:Number=0):void
		{
			m_oPanelControl.unReveal(w,h,x,y,track);
		}
		/**
		 * @includeExample ../examples/PointRoll/PointRoll_launchURL.txt -noswf
		 * @copy PointRollAPI_AS3.net.URLHandler#launchURL()
		 */
		public function launchURL(url:String, window:Boolean=true, noun:String = null):void{
			m_oURLHandler.launchURL(url, window, noun);
		}
		/**
		 * @includeExample ../examples/PointRoll/PointRoll_beacon.txt -noswf
		 * @copy PointRollAPI_AS3.net.URLHandler#beacon()
		 */
		public function beacon(url:String):void{
			m_oURLHandler.beacon(url);
		}
		/**
		 * @private
		 * Currently undocumented functionality.  This function returns the currently recognized list of events for this object.  
		 * The intended usage is to expose events to publishers using our Flash-in-Flash delivery.
		 * @return
		 */
		public function eventArray():Array{
			PrDebug.PrTrace("Called Event Array: "+m_aEventArray);
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
			//addEventListener(s,this);
			PrDebug.PrTrace("Event added: "+s);
		}
	
	//**** Getters --------------------------------------------------------------------------------------------

		/**
		 * @includeExample ../examples/PointRoll/PointRoll_playerVersion.txt -noswf
		 * @copy PointRollAPI_AS3.StateManager#flashVersion
		 * @see PointRoll#fullFlashVersion
		 */
		public function get playerVersion():Number
		{
			return StateManager.flashVersion;
		}
		/**
		 * @includeExample ../examples/PointRoll/PointRoll_playerVersion.txt -noswf
		 * @copy PointRollAPI_AS3.StateManager#fullFlashVersion
		 * @see PointRoll#playerVersion
		 */
		public function get fullFlashVersion():String
		{
			return StateManager.fullFlashVersion;
		}
		/**
		 * @includeExample ../examples/PointRoll/PointRoll_launchURL.txt -noswf
		 * @copy PointRollAPI_AS3.StateManager#URLParameters
		 */
		public function get parameters():Object
		{
			return StateManager.URLParameters;
		}
		/**
		 * @copy PointRollAPI_AS3.StateManager#APIVersion
		 */
		public function get APIVersion():String
		{
			return StateManager.APIVersion;
		}
		/**
		 * @includeExample ../examples/PointRoll/PointRoll_absolutePath.txt -noswf
		 * @copy PointRollAPI_AS3.util.domain.Domain#absolutePath
		 * @see PointRoll#domain domain
		 */
		public function get absolutePath():String{
			return Domain.absolutePath;
		}
		/**
		 * @copy PointRollAPI_AS3.util.domain.Domain#domain
		 * @see PointRoll#absolutePath absolutePath
		 */
		public function get domain():String{
			return Domain.domain;
		}
		/**
		 * Returns a reference to the scope object passed to the <code>getInstance</code> method. This is helpful especially in a Flash-in-Flash situation
		 * to provide access back to the main timeline of your creative.
		 * @see PointRoll#getInstance() getInstance()
		 */
		public static function get prRoot():DisplayObject
		{
			return StateManager.root
		}
		
		/**
		 * @private
		 * Called continually to check the value of the platform variable "prsw." When any panels are open, this variable's value is 1; when all 
		 * panels are closed, this variable's value will be 0 and the PANEL_CLOSED event will be dispatched.
		 */
		private function _onCheckPnl(e:TimerEvent):void
		{
			var pnlOpened:Number;
			pnlOpened = Number(ExternalInterface.call("function(){ return prsw; }"));
			
			PrDebug.PrTrace("Panel state: " + pnlOpened);
			
			if (pnlOpened == 0)
			{
				checkPnlTimer.stop();
				checkPnlTimer.removeEventListener(TimerEvent.TIMER, _onCheckPnl);
				trace("Check panel timer stopped.");
				dispatchEvent(new PanelEvent(PanelEvent.PANEL_CLOSED));
			}
		}
		
	}
}
class SingletonEnforcer{}