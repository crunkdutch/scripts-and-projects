package com.banners
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author crunkdutch
	 */
	public class TabCta extends MovieClip
	{
		public var bg : MovieClip;
		public var wording : MovieClip;
		protected var origBG : Object;
		protected var origWording : Object;

		public function TabCta()
		{
			origBG = {};
			origWording = {};
			origBG.x = bg.x;
			origBG.y = bg.y;
			origBG.scaleX = bg.scaleX;
			origBG.scaleY = bg.scaleY;
			origBG.width = bg.width;
			origBG.height = bg.height;
			origWording.scaleY = wording.scaleY;
			origWording.scaleX = wording.scaleX;
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.ROLL_OVER, doRollOver);
			addEventListener(MouseEvent.ROLL_OUT, doRollOut);
		}

		public function doRollOver(e : Event = null) : void
		{
			TweenWrap.to(bg, .5, {width:origBG.width + 2, height:origBG.height + 8});
			TweenWrap.to(wording, .5, {scaleY:origWording.scaleY * 1.1, scaleX:origWording.scaleX * 1.1});
		}

		public function doRollOut(e : Event = null) : void
		{
			TweenWrap.to(bg, .5, {width:origBG.width, height:origBG.height});
			TweenWrap.to(wording, .5, {scaleY:origWording.scaleY, scaleX:origWording.scaleX});
		}
	}
}
