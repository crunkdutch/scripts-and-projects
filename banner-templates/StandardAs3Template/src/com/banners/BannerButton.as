package com.banners
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author crunkdutch
	 */
	public class BannerButton extends MovieClip
	{
		public var background : MovieClip;
		public var buttonCopy : MovieClip;
		
		
		public function BannerButton()
		{
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		public function kill() : void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}

		public function addListeners() : void
		{
			if (!this.hasEventListener(MouseEvent.ROLL_OVER))
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
			}
			if (!this.hasEventListener(MouseEvent.ROLL_OUT))
			{
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
			}
		}

		protected function onMouseUp(event : MouseEvent) : void
		{
			trace('onMouseUp(event : MouseEvent)');
			this.buttonCopy.gotoAndPlay('UP');
			this.background.gotoAndPlay('UP');
		}

		protected function onMouseDown(event : MouseEvent) : void
		{
			trace('onMouseDown(event : MouseEvent)');
			this.buttonCopy.gotoAndPlay('DOWN');
			this.background.gotoAndPlay('DOWN');
		}

		protected function onRollOut(event : MouseEvent) : void
		{
			trace('onRollOut(event : MouseEvent)');
			this.buttonCopy.gotoAndPlay('OUT');
			this.background.gotoAndPlay('OUT');
		}

		protected function onRollOver(event : MouseEvent) : void
		{
			trace('onRollOver(event : MouseEvent)');
			this.buttonCopy.gotoAndPlay('OVER');
			this.background.gotoAndPlay('OVER');
		}
	}
}
