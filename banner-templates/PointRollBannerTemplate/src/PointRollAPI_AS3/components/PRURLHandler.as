/**
 * PointRoll URL Handler Component
 * 
 * It is used for 3rd party tracking passing a URL to a 1×1 image url
 * 
 * @class 		PRURLHandler
 * @package		PointRollAPI.components
 * @author		PointRoll
 */
 
 
 /**
 *	List of exposed methods 
 *	--------------------------
 *	
 *	beacon
 *
 */

package PointRollAPI_AS3.components 
{
	import PointRollAPI_AS3.net.URLHandler;

	import flash.display.MovieClip;

	//PointRoll API specific class imports
	
	//Base classes
	
	/** @private **/
	public class PRURLHandler extends MovieClip {
		
		//internal use, needed for component structure
		public static var symbolName:String = "PRURLHandler";
    	public static var symbolOwner:Object = PointRollAPI_AS3.components.PRURLHandler;
	
		private var urlHandler:URLHandler;
		
		//Constructor
		function PRURLHandler() {
			trace("PR Component Used:> URL Handler");
			init();
		}
	
		private function init():void {
			hideBoundingBox();
			urlHandler = new URLHandler();
		}
	

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
	
		
		public function beacon(...args)		:void {
			urlHandler.beacon.apply(urlHandler, args);
		}
		
		public function launchURL(...args)		:void {
			urlHandler.launchURL.apply(urlHandler, args);
		}
		
	}
	
}