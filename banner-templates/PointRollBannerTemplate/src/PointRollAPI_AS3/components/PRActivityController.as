/**
 * PointRoll Activity Tracker Component
 * 
 * Tracks ads activity
 * 
 * @class 		PRActivityTracker
 * @package		PointRollAPI.components
 * @author		PointRoll
 */
 
 
 /**
 *	List of exposed methods 
 *	--------------------------
 *	
 *	activity
 *	checkForExisting
 *
 */

package PointRollAPI_AS3.components 
{
	import PointRollAPI_AS3.ActivityController;

	import flash.display.MovieClip;

	//PointRoll API specific class imports
	
	//Base classes
	
	/** @private **/
	public class PRActivityController extends MovieClip {
		
		//internal use, needed for component structure
		static public var symbolName:String = "PRActivityController";
    	static public var symbolOwner:Object = PointRollAPI_AS3.components.PRActivityController;
	
		//internal
		private var activityController:ActivityController;
		
		//Constructor
		function PRActivityController() {
			trace("PR Component Used:> Activity Tracker");
			init();
		}
	
		private function init():void {
			hideBoundingBox();
			activityController = ActivityController.getInstance(this);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* Specific set of ActivityController Methods */
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Hides bounding box
		 */
		private function hideBoundingBox():void {
			this.visible = false;
			/*
			boundingBox.visible = false;
			boundingBox.width = 0;
			boundingBox.height = 0;
			*/
		}
	
		public function activity(...args)		:void 	{
			activityController.activity.apply(activityController, args);
		}
		
		public function checkForExisting(...args) 							: Boolean	{
			return activityController.checkForExisting.apply(activityController,args);
		}
		
	}
	
}