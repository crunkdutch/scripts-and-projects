/**
 * PointRoll Video Control Play/Pause Toggle
 * 
 * Plays or Pauses a video
 * 
 * @class 		PRVCPlayPause
 * @package		PointRollAPI.components.video.controls
 * @author		PointRoll
 */

package PointRollAPI_AS3.components.video.controls  
{
	import PointRollAPI_AS3.events.media.PrMediaEvent;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	/** @private **/
	public class PRVCPlayPause extends PointRollAPI_AS3.components.video.controls.PRVCUIToggle {
		
		//internal use, needed for component structure
		public static var symbolName:String = "PRVCPlayPause";
   		public static var symbolOwner:Object = PointRollAPI_AS3.components.video.controls.PRVCPlayPause;
	
		private var driving:Boolean = false;
	
		function PRVCPlayPause() {
			super();
			linkHitArea = 	"PRHitArea";
			statusHandler		 = 	[
										 	{	labelNormal: 	"up_play",
												labelOver:		"over_play",
												labelRelease:	"down_play",
												labelDisabled:	"disabled_play"
												},
										 	{	labelNormal: 	"up_pause",
												labelOver:		"over_pause",
												labelRelease:	"down_pause",
												labelDisabled:	"disabled_pause"
												}
										 ];
			init();
		}
	
		protected override function initialize(event:TimerEvent):void {
			timerNotify.stop();
			timerNotify = null;
			addListeners();
		}
	
		protected override function addListeners():void {
			prVideoDisplay = getVideoDisplayInstance();
			if(prVideoDisplay) {
				prVideoDisplay.addEventListener(PrMediaEvent.START, onStart);
				prVideoDisplay.addEventListener(PrMediaEvent.STOP, onStop);
				prVideoDisplay.addEventListener(PrMediaEvent.PAUSE, onPause);
				prVideoDisplay.addEventListener(PrMediaEvent.COMPLETE, onComplete);
				prVideoDisplay.addEventListener(PrMediaEvent.PLAY, onPlay);
				prVideoDisplay.addEventListener(PrMediaEvent.REPLAY, onReplay);
			}
		}
	
		protected override function release(event:MouseEvent):void {
			super.release(event);
			driving = true;
			if(actualMode == 0) {
				if(prVideoDisplay.isPaused()) {
					prVideoDisplay.play();
				}else{
					prVideoDisplay.startVideo();
				}
			}else if(actualMode == 1){
				prVideoDisplay.pause();
			}
			
		}
	
		/**
		*	Events fired by VDC
		*/
	
		private function onStart(e:PrMediaEvent):void {
			toggleMode(1);
		}
		
		private function onStop(e:PrMediaEvent):void {
			toggleMode(0);
		}
		
		private function onReplay(e:PrMediaEvent):void {
			toggleMode(0);
		}
		
		private function onPause(e:PrMediaEvent):void {
			toggleMode(0);
		}
		
		private function onComplete(e:PrMediaEvent):void {
			toggleMode(0);
		}
		
		private function onPlay(e:PrMediaEvent):void {
			toggleMode(1);
		}
	
	}
	
}