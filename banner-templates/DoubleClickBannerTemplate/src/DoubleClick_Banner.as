package
{
	import flash.display.*
	import flash.events.*;

	import com.google.ads.studio.ProxyEnabler;
	import com.google.ads.studio.events.StudioEvent;
	import com.google.ads.studio.utils.StudioClassAccessor;
		
	import com.banners.*;
	import com.greensock.*;
	import com.greensock.easing.*;

	public dynamic class DoubleClick_Banner extends MovieClip
	{	
		private static const BANNER_WIDTH : int = 300;
		private static const BANNER_HEIGHT : int = 250;
		private static const WHITE : uint = 0xffffff;
		private static const BLACK : uint = 0x00000;

		public var enablerCollapsed : ProxyEnabler = ProxyEnabler.getInstance();
		public var expanding : Object = StudioClassAccessor.getClass(StudioClassAccessor.CLASS_EXPANDING)["getInstance"]();

		public var clickArea : Sprite;
		public var btnCta : *;
		public var btnReplay : Sprite;
		private var objectStates : ObjectStates;
		private var border : Border;
		private var curtain : Sprite;
		
		public function DoubleClick_Banner()
		{	
			expanding.addEventListener(StudioEvent.COLLAPSE_BEGIN, collapseBeginHandler);
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

			btnCta.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			clickArea.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
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
			TweenWrap.delayedCall(d, showResolve);
		}

		private function showResolve() : void
		{
			var d : Number = 0;
			/*
			 * final frame of animation -
			 * handle all listers; adding, removing, whatever
			 * 
			 */
			
			if (!btnReplay.hasEventListener(MouseEvent.CLICK))
			{
				btnReplay.addEventListener(MouseEvent.CLICK, doReplay);	
			}
		}

		private function finishReplay() : void
		{
			TweenWrap.killAllTweens(true);
			objectStates.resetAllObjStatesOf(this, null, true);
			startAnimation();
		}

		////////////////////////
		////EVENT HANDLERS//////	
		////////////////////////

		private function collapseBeginHandler(event : StudioEvent) : void
		{	
			showResolve();
		}

		private function onMouseClick(event : MouseEvent) : void
		{
			switch (event.currentTarget.name)
			{
				case 'btnCta' :
					expanding.expand();
					break;

				case 'clickArea' :
					enablerCollapsed.exit("collapsed_clickArea_exit");
					break;
			}			
		}

		private function doReplay(event : MouseEvent) : void
		{
			curtain.visible = true;
			TweenWrap.to(curtain, 0.3, {alpha:1});
			TweenWrap.delayedCall(0.3, finishReplay);
		}
	}
}