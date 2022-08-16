package PointRollAPI_AS3
{
	import PointRollAPI_AS3.controllers.*;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.DisplayObject;

	/**
	 * @private
	* The ActivityController Class manages the recording of all advertisement activities.  This includes user generated actions as well as
	* media playback metrics
	
	* @author Chris Deely - PointRoll
	* @version 0.1
	*/
	public class ActivityController {
		
		private static var m_oInstance:ActivityController;
		private var m_oActivityObj:IActivityRecorder;
		private var m_firedActivities:Array;
		private var m_sPanel:String = "0";
		private var m_sBanner:String = "0"


		public function ActivityController( myRoot:DisplayObject, s:SingletonEnforcer) {
			StateManager.setRoot( myRoot );	
			m_firedActivities = new Array();
			
			switch(StateManager.getDisplayState()){
				case StateManager.BANNER:
					m_sBanner = "1";
					break;
				case StateManager.PANEL:
					m_sPanel = StateManager.URLParameters.PRPanel;
					break;
				case StateManager.TESTING:
					break;
				default:
					//default to banner display state
					m_sBanner = "1";
					break;
			}
			
			switch( StateManager.getPlatformState() ){
				case StateManager.JSPLATFORM:
					m_oActivityObj = JSPlatform.getInstance();
					break;
				case StateManager.FLASHONLY:
					m_oActivityObj = FiF.getInstance();
					break;
				case StateManager.POPUP:
					m_oActivityObj = PopUp.getInstance();
					break;
				case StateManager.TESTING:
					m_oActivityObj = TestingPlatform.getInstance();
					break;
				default:
					throw(new Error("Unknown Platform State"));
			}
		}
		
		public static function getInstance(myRoot:DisplayObject):ActivityController{
			if( m_oInstance == null ){
				m_oInstance = new ActivityController(myRoot, new SingletonEnforcer());
			}
			return m_oInstance
		}
		public function activity(a:Number,unique:Boolean=false,noun:String=null):void
		{
			
			//check for valid activity
			a = Number(a);
			if( isNaN(a) ){
				throw(new Error("Activity Must Be A Number"));
				return
			}
			if( !unique || (unique && !checkForExisting(a)) )
			{
				m_firedActivities.push(a);
				m_oActivityObj.activity(a, m_sPanel, m_sBanner, StateManager.URLParameters.PRImpID, noun);
			}else{
				PrDebug.PrTrace("Unique activity "+a+" has already been fired",1,"Activity");
			}
		}
		
		//*** Check for existing activity in array
		public function checkForExisting(a:Number):Boolean
		{
			var length:Number = m_firedActivities.length;
			for(var i:uint = 0;i<length;i++)
			{
				//Check for existing
				if(m_firedActivities[i] == a)
				{
					return true;
				}
			}
			return false;
		}
	}
}
class SingletonEnforcer{}