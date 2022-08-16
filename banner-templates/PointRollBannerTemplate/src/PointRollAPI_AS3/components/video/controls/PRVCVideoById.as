/**
 * PointRoll Video Control Start Video By Id
 * 
 * Shows an active state if the video playing has that id
 * 
 * @class PRVCVideoById
 * @packagePointRollAPI.components.video.controls
 * @authorPointRoll
 */

package PointRollAPI_AS3.components.video.controls
{
	import Number;
	import PointRollAPI_AS3.events.components.PrComponentEvent;
	import PointRollAPI_AS3.events.media.PrMediaEvent;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	/** @private **/
	public class PRVCVideoById extends PointRollAPI_AS3.components.video.controls.PRVCUIButton {


		[Inspectable(name="Video Index Number",category="General",defaultValue="",type=Number)]
		public var prVideoIndexNumber:Number;

		//internal use, needed for component structure
		public static var symbolName:String="PRVCVideoById";
		public static var symbolOwner:Object=PointRollAPI_AS3.components.video.controls.PRVCVideoById;

		private var labelActive:String;
		private var initialized:Boolean;

		function PRVCVideoById() {
			super();
			linkHitArea = "PRHitArea";
			labelUp = "up";
			labelOver = "over";
			labelDown = "down";
			labelDisabled = labelActive = "active";
			initialized=false;
			init();
		}


		protected override function initialize(event:TimerEvent):void {
			super.initialize(event);
			initialized=true;
		}

		protected override function addListeners():void {
			prVideoDisplay=getVideoDisplayInstance();
			if (prVideoDisplay) {
				prVideoDisplay.addEventListener(PrMediaEvent.START, onStart);
				prVideoDisplay.addEventListener(PrMediaEvent.STOP, onStop);
				prVideoDisplay.addEventListener(PrMediaEvent.PAUSE, onPause);
				prVideoDisplay.addEventListener(PrMediaEvent.COMPLETE, onComplete);
				prVideoDisplay.addEventListener(PrMediaEvent.PLAY, onPlay);
				prVideoDisplay.addEventListener(PrComponentEvent.PLAYLISTFINISHED, onPlaylistFinished);
			}
		}

		protected override function rollOver(event:MouseEvent):void {
			
				if (isActive && initialized) {
					if (prVideoDisplay.getVideoIndex()==prVideoIndexNumber && prVideoDisplay.isPlaying) {
						gotoAndStop(labelActive);
					} else {
						gotoAndStop(labelOver);
					}
				}
			
		}
		protected override function rollOut(event:MouseEvent):void {
			if (isActive&&initialized) {
				if (prVideoDisplay.getVideoIndex()==prVideoIndexNumber&&prVideoDisplay.isPlaying) {
					gotoAndStop(labelActive);
				} else {
					gotoAndStop(labelUp);
				}
			}
		}

		protected override function release(event:MouseEvent):void {
			super.release(event);
			prVideoDisplay.startVideoById(prVideoIndexNumber, -1, -1);
		}

		/**
		*Events fired by VDC
		*/
		private function onStart(e:PrMediaEvent):void {
			if (prVideoDisplay.getVideoIndex()==prVideoIndexNumber) {
				gotoAndStop(labelActive);
				activate(false);
			}else{
				activate(true)
			}
		}

		private function onStop(e:PrMediaEvent):void {
			activate(true)
		}

		private function onPause(e:PrMediaEvent):void {
			activate(true)
		}

		private function onPlaylistFinished(e:PrMediaEvent):void {
			activate(true)
		}

		private function onComplete(e:PrMediaEvent):void {
			activate(true)
		}
		private function onPlay(e:PrMediaEvent):void {
			if (prVideoDisplay.getVideoIndex()==prVideoIndexNumber) {
				gotoAndStop(labelActive);
				activate(false);
			}else{
				activate(true)
			}
		}

	}

}