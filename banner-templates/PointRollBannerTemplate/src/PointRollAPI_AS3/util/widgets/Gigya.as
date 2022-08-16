package PointRollAPI_AS3.util.widgets 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	/**
	 * Provides Widget distribution via Gigya
	* @author Chris Deely - PointRoll
	* @private 
	* Accessed via the PrWidgetControl class
	*/
	internal class Gigya extends EventDispatcher implements IWidgetControl {
		
		public function Gigya(target:DisplayObjectContainer) {
			
		}		
		/* INTERFACE PointRollAPI_AS3.util.widgets.IWidgetControl */
		/** @inheritDoc */
		public function loadLibrary(autoDisplay:Boolean = false):void{
			
		}
		/** @inheritDoc */
		public function showMenu():void{
			
		}
		/** @inheritDoc */
		public function hideMenu():void{
			
		}
		
		/** @inheritDoc */
		public function addParameter(name:String, value:String):void
		{
			
		}
		/** @inheritDoc */
		public function get menuX():Number
		{
			return 0;
		}
		public function set menuX(x:Number):void
		{
			
		}
		
		/** @inheritDoc */
		public function get menuY():Number
		{
			return 0;
		}
		public function set menuY(y:Number):void
		{
		
		}
		/** @inheritDoc */
		public function get libraryObject():Object
		{
			return new Object();
		}
		
		/* Needed for clickThruRestricted() in PrWidgetControl */
		public function get inTheWild():Boolean
		{
			return false;
		}
		
		/** 
		 * @inheritDoc 
		 */
		public function unloadMenu():void
		{
			
		}
		
	}
	
}