/**
 * PointRoll Base UI Control
 * 
 * Holds a list of basic UI functions
 * 
 * @class 		PRVCBase
 * @package		PointRollAPI.components.video.controls
 * @author		PointRoll
 */

package PointRollAPI_AS3.components.video.controls  
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	//Basic
	
	//VD
	
	/** @private **/
	public class PRVCUIButton extends PointRollAPI_AS3.components.video.controls.PRVCBase {
		
		/* linkage IDs for the library */
		protected var linkHitArea:String = 	"";
		protected var labelUp:String = 		"";
		protected var labelOver:String = 		"";
		protected var labelDown:String = 		"";
		protected var labelDisabled:String = 	"";
	
		/* internal, assets movieclips */
		private var hittArea:Sprite = null;
	
		protected var isActive:Boolean = true;
		protected var timerNotify:Timer;			//Delayed init, to wait until the VDC creates its handlers
		
		function PRVCUIButton() {
			super();
		}
	
		protected override function init():void {
			super.init();
			timerNotify = new Timer(300);
			timerNotify.addEventListener("timer", initialize);  
            timerNotify.start();  
		}
	
		protected function initialize(event:TimerEvent):void {
			timerNotify.stop();
			timerNotify = null;
			addListeners();
		}
	
		protected function addListeners():void {}
	
		/**
		 * Executes on start, adds children assets
		 */
		protected override function createChildren():void {
			
			super.createChildren();
			
			hittArea = new Sprite();
			hittArea.buttonMode = true;
			hittArea.useHandCursor = true;
			drawRectangle(hittArea);
			addChild(hittArea);
			
			rollOut(new MouseEvent(MouseEvent.ROLL_OUT));
			setHandlers();
		}
	
		
		protected function setHandlers():void {
			hittArea.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			hittArea.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			hittArea.addEventListener(MouseEvent.CLICK, release);
		}
		
		protected function rollOver(event:MouseEvent):void {
			if(event.target == hittArea) {
				if(isActive) gotoAndStop(labelOver);
			}
		}
		
		protected function rollOut(event:MouseEvent):void {
			if(event.target == hittArea) {
				if(isActive) gotoAndStop(labelUp);
			}
		}
		
		protected function release(event:MouseEvent):void {
			if(event.target == hittArea) {
				gotoAndStop(labelUp);
			}
		}
		
		public override function disable():void {
			gotoAndStop(labelDisabled);
			hittArea.useHandCursor = false;
			hittArea.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			hittArea.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			hittArea.removeEventListener(MouseEvent.CLICK, release);
		}
		
		
		public function activate(what:Boolean):void {
			if(what) {
				hittArea.visible = true;
				gotoAndStop(labelUp);
				isActive = true;
			}else{
				hittArea.visible = false;
				gotoAndStop(labelDisabled);
				isActive = false;
			}
	
		}
		
		private function drawRectangle(mc:Sprite):void {
			var g:Graphics = Graphics(mc.graphics);
			var r:Rectangle = DisplayObject(this).getBounds(this);
			g.beginFill(0x0,0);
			g.drawRect(r.x,r.y,r.width,r.height);
			g.endFill();
		}
		
		
	}
	
}