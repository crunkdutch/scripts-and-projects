package com
{
	import com.banners.Border;
	import com.banners.ObjectStates;
	import com.banners.TweenWrap;
	import com.greensock.TweenNano;
	import com.pointrollHelper.PointRollBanner;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class PointRollBanner_300x250 extends PointRollBanner
	{
		private static const BANNER_WIDTH : int = 300;
		private static const BANNER_HEIGHT : int = 250;
		private static const WHITE : uint = 0xffffff;
		private static const BLACK : uint = 0x00000;
		public var clickArea : Sprite;
		public var btnCta : *;
		public var btnReplay : Sprite;
		private var objectStates : ObjectStates;
		private var border : Border;
		private var curtain : Sprite;
		

		public function PointRollBanner_300x250()
		{
			// set the tween type
			TweenWrap.setTween(TweenNano);
			/*
			 * make the entire banner clickable - code is less k weight than the IDE :)
			 */
			clickArea = new Sprite();
			clickArea.graphics.beginFill(WHITE, 0);
			clickArea.graphics.drawRect(0, 0, BANNER_WIDTH, BANNER_HEIGHT);
			clickArea.graphics.endFill();

			addChildAt(clickArea, this.numChildren - 2);
			// the only things on top of the click area should be the replay button and the cta

			/*
			 * weird shit in chrome happens so we make an all white 'curtain' that fades out to start the banner
			 * this prevents all the objects on the stage from an inital flicker----- 
			 */

			curtain = new Sprite();
			curtain.graphics.beginFill(WHITE, 1);
			curtain.graphics.drawRect(0, 0, BANNER_WIDTH, BANNER_HEIGHT);
			curtain.graphics.endFill();
			addChild(curtain);

			btnCta.addEventListener(MouseEvent.CLICK, onbtnCtaClick, false, 0, true);
			clickArea.addEventListener(MouseEvent.CLICK, onbtnCtaClick);
			clickArea.buttonMode = true;

			border = new Border(BANNER_WIDTH, BANNER_HEIGHT, BLACK);
			addChild(border);

			// save everything's state.
			objectStates = new ObjectStates;
			objectStates.saveAllObjStatesOf(this, true);

			startAnimation();
		}

		private function startAnimation() : void
		{
			TweenWrap.to(curtain, 0.5, 
				{
					alpha : 0, 
					onComplete : function():void 
					{
						curtain.visible = false;
						first();
					}
				}
			);

		}

		private function first() : void
		{
			var d : Number = 0;
			
			//some kinda animation IN >>>>>>>>>>
			//TweenWrap.to(blah, 0.5, {x : 10, ease : Strong, delay : d });
			//d += 0.5;
			//TweenWrap.to(blah, 0.5, {x : 10, ease : Strong, delay : d });
			//d += 0.5;
			//TweenWrap.to(blah, 0.5, {x : 10, ease : Strong, delay : d });
			//d += 0.5;
			//now make a delayed call to transition this bullshit out
			TweenWrap.delayedCall(d, firstOut);
		}
		
		private function firstOut() : void
		{
			var d : Number = 0;
			
			//some kinda animation OUT <<<<<<<<<<<
			//TweenWrap.to(blah, 0.5, {x : 10, ease : Strong, delay : d });
			//d += 0.5;
			//TweenWrap.to(blah, 0.5, {x : 10, ease : Strong, delay : d });
			//d += 0.5;	
			//see the pattern ??? bring shit in - remove it - in separate functions
			TweenWrap.delayedCall(d, resolve);
		}
		
		private function resolve() : void
		{
			/*
			 * final frame of animation -
			 * handle all listers; adding, removing, whatever
			 * 
			 */
			
			 btnReplay.addEventListener(MouseEvent.CLICK, doReplay);
			
		}
		

		private function doReplay(event : MouseEvent) : void
		{
			curtain.visible = true;
			TweenWrap.to(curtain, 0.3, {alpha:1});
			TweenWrap.delayedCall(0.3, finishReplay);
		}

		private function finishReplay() : void
		{
			TweenWrap.killAllTweens(true);
			objectStates.resetAllObjStatesOf(this, null, true);

			startAnimation();
		}

		private function onbtnCtaClick(event : MouseEvent) : void
		{
			//TweenWrap.killAllTweens(true);
			openPanel(1);
		}
	}
}
