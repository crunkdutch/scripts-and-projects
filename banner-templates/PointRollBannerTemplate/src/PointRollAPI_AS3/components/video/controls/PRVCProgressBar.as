/**
 * PointRoll Video Control Video Progress Bar
 * 
 * Shows a progress bar for the playback
 * 
 * @class 		PRVCProgressBar
 * @package		PointRollAPI.components.video.controls
 * @author		PointRoll
 */
 
 package PointRollAPI_AS3.components.video.controls  
{
	import PointRollAPI_AS3.PointRoll;
	import PointRollAPI_AS3.events.components.PrComponentEvent;
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;

	import String;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;

	/** @private **/
	public class PRVCProgressBar extends PointRollAPI_AS3.components.video.controls.PRVCUIProgress {
		
		//internal use, needed for component structure
		static var symbolName:String = "PRVCProgressBar";
    	static var symbolOwner:Object = PointRollAPI_AS3.components.video.controls.PRVCProgressBar;
		
		
		[Inspectable(name = "Show Scrubber",category = "General",defaultValue = "true",type=String,enumeration="true,false")]
		public var scrubberVisibility:String = "true";

		private var showScrubber:Boolean = true;
		private var maxWidthScrubber:Number = 0;
		
		private var trackBar:MovieClip;
		private var progressBar:MovieClip;
		private var scrubberBar:MovieClip;
		
		private var dragDriver:Boolean;
		
		function PRVCProgressBar() {
			super();
			dragDriver = false;
			addEventListener(Event.ADDED_TO_STAGE, getChildren);
		}
		
		private function getChildren(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, getChildren);
			trackBar = MovieClip(getChildByName("trackBarOnStage"));
			progressBar = MovieClip(getChildByName("progressBarOnStage"));
			scrubberBar = MovieClip(getChildByName("scrubberBarOnStage"));
			init();
		}
		
		
		protected override function verifyProperties(event:Event):void {
			super.verifyProperties(event);
			showScrubber = scrubberVisibility == "true" ? true : false;
		}
		
		protected override function init():void {
			super.init();
			maxWidth = trackBar.width;
			
		}
		
		protected override function initialize(event:TimerEvent):void {
			timerNotify.stop();
			timerNotify = null;
			addListeners();
			
			
			if (showScrubber) {
				initScrubber();
			}else {
				scrubberBar.visible = false;
			}
			
			
			
			reset();
			
		}
		
		protected override function addListeners():void {
			prVideoDisplay = getVideoDisplayInstance();
			if(prVideoDisplay) {
				prVideoDisplay.addEventListener(PrComponentEvent.INIT, onInit);
				prVideoDisplay.addEventListener(PrMediaEvent.STOP, onStop);
				prVideoDisplay.addEventListener(PrProgressEvent.PROGRESS, onProgress);
			}
		}
		
		
		private function initScrubber():void {
			maxWidthScrubber = maxWidth - scrubberBar.width;
			scrubberBar.buttonMode = true;
			scrubberBar.useHandCursor = true;
			scrubberBar.addEventListener(MouseEvent.MOUSE_DOWN, dragHead);
			progressBar.mouseEnabled = false;
			trackBar.useHandCursor = false;
			trackBar.addEventListener(MouseEvent.CLICK, updateVideoPosition);
			//scrubberBar.addEventListener(MouseEvent.MOUSE_UP, undragHead);
		}
		
		private function dragHead(event:MouseEvent):void {
			dragDriver = true;
			prVideoDisplay.removeEventListener(PrProgressEvent.PROGRESS, onProgress);
			scrubberBar.startDrag(false, new Rectangle(0,0,maxWidthScrubber,0));
			stage.addEventListener(MouseEvent.MOUSE_UP, undragHead);
		}
		
		private function undragHead(event:MouseEvent):void {
			if(dragDriver) {
				var pos:Number = scrubberBar.x / maxWidthScrubber;
				prVideoDisplay.seek(prVideoDisplay.getLength()*pos);
				scrubberBar.stopDrag();
				dragDriver = false;
				stage.removeEventListener(MouseEvent.MOUSE_UP, undragHead);
				prVideoDisplay.addEventListener(PrProgressEvent.PROGRESS, onProgress);
				PointRoll.getInstance(this).activity(1008);
			}
		}
		
		private function updateVideoPosition(event:MouseEvent):void {
			var p:Number = trackBar.mouseX / trackBar.width;
			prVideoDisplay.seek(prVideoDisplay.getLength()*p);
			PointRoll.getInstance(this).activity(1008);
		}
		
		public function moveHead(amount:Number):void {
			if(amount>0) scrubberBar.x = trackBar.x + (maxWidthScrubber * amount);
		}
		
		/**
		*	Shows the progress, receives a number between 0-100
		*/
		protected override function showProgress(progress:Number):void {
			if(progress>0) progressBar.width = maxWidth * progress;
		}
		
		
		/**
		*	Sets the width of the progress bar
		*/
		protected override function setSize(width:Number):void {
			progressBar.width = width;
			trackBar.width = width;
		}
	
		
		/**
		*	Hides the track bar
		*/
		protected override function hideTrack():void {
			progressBar.visible = false;
		}
		
		public override function reset():void {
			showProgress(.01);
			moveHead(.01);
		}
		
		/**
		*	Events fired by VDC
		*/
		
		private function onInit(e:PrComponentEvent):void {
			reset();
		}
		
		private function onStop(e:PrMediaEvent):void {
			reset();
		}
			
		private function onProgress(e:PrProgressEvent):void {
			moveHead(e.percentPlayed);
			showProgress(e.percentPlayed);
		}
		
	}
	
 }