/**
 * PointRoll Video Control Stop
 * 
 * Stops a list of video ads provided by user
 * 
 * @class 		PRVCStop
 * @package		PointRollAPI.components.video.controls
 * @author		PointRoll
 */

package PointRollAPI_AS3.components.video.controls  
{
	import PointRollAPI_AS3.events.components.PrComponentEvent;
	import PointRollAPI_AS3.events.media.PrMediaEvent;

	import flash.events.MouseEvent;

	/** @private **/
	public class PRVCStop extends PointRollAPI_AS3.components.video.controls.PRVCUIButton {
		
		//internal use, needed for component structure
		public static var symbolName:String = "PRVCStop";
   		public static var symbolOwner:Object = PointRollAPI_AS3.components.video.controls.PRVCStop;
	
		function PRVCStop() {
			super();
			linkHitArea = 	"PRHitArea";
			labelUp = 		"up";
			labelOver = 	"over";
			labelDown = 	"down";
			labelDisabled = "disabled";
			init();
		}
	
		protected override function addListeners():void {
			prVideoDisplay = getVideoDisplayInstance();
			if(prVideoDisplay) {
				prVideoDisplay.addEventListener(PrComponentEvent.INIT, onInit);
				prVideoDisplay.addEventListener(PrMediaEvent.START, onStart);
				prVideoDisplay.addEventListener(PrMediaEvent.STOP, onStop);
				prVideoDisplay.addEventListener(PrMediaEvent.COMPLETE, onComplete);
				prVideoDisplay.addEventListener(PrMediaEvent.PLAY, onPlay);
				prVideoDisplay.addEventListener(PrMediaEvent.PAUSE, onPause);
				prVideoDisplay.addEventListener(PrComponentEvent.PLAYLISTFINISHED, onPlaylistFinished);
			}
		}
	
		protected override function release(event:MouseEvent):void {
			super.release(event);
			prVideoDisplay.stop();
		}
	
		/**
		*	Events fired by VDC
		*/
		private function onInit(e:PrComponentEvent):void { 
			activate(false);
		}
		
		private function onStart(e:PrMediaEvent):void {
			activate(true);
		}
		
		private function onStop(e:PrMediaEvent):void {
			activate(false);
		}
		
		private function onPause(e:PrMediaEvent):void {
			activate(false);
		}
		
		private function onPlaylistFinished(e:PrMediaEvent):void {
			activate(false);
		}
		
		private function onComplete(e:PrMediaEvent):void {
			activate(false);
		}
		private function onPlay(e:PrMediaEvent):void {
			activate(true);
		}
	
	}
	
}