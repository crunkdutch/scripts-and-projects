package PointRollAPI_AS3.panel
{
	import PointRollAPI_AS3.IPanelControl;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.controllers.*;

	import flash.display.DisplayObject;

	/**
	 * @private
	* PanelControl class controls interactions with the ad platform for the display of panel swfs
	* @author Chris Deely - PointRoll
	* @version 0.1
	*/
	public class PanelController{
		
		private static var m_oInstance:IPanelControl;
		
		//public function PanelController(s:SingletonEnforcer) {	}
		
		public static function getInstance(myRoot:DisplayObject):IPanelControl{
			if(m_oInstance == null){
				StateManager.setRoot(myRoot);
				switch( StateManager.getPlatformState() ){
					case StateManager.JSPLATFORM:
						m_oInstance = JSPlatform.getInstance();
						break;
					case StateManager.FLASHONLY:
						m_oInstance = null;
						break;
					case StateManager.POPUP:
						m_oInstance = PopUp.getInstance();
						break;
					case StateManager.TESTING:
						m_oInstance = TestingPlatform.getInstance();
						break;
					default:
						throw(new Error("Unknown Platform State"));
				}
			}
			return m_oInstance;
		}
	}
}
class SingletonEnforcer{}