package
{
	import flash.display.*;
	import flash.events.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import com.google.ads.studio.ProxyEnabler;
	import com.google.ads.studio.events.StudioEvent;
	import com.google.ads.studio.events.StudioVideoEvent;
	import com.google.ads.studio.utils.StudioClassAccessor;

	public dynamic class DoubleClick_Panel extends MovieClip
	{
		private const BANNER_WIDTH : int = 600;
		private const BANNER_HEIGHT : int = 250;
		private var masker : Sprite = new Sprite();

		public var enabler : ProxyEnabler = ProxyEnabler.getInstance();
		public var expanding : Object = StudioClassAccessor.getClass(StudioClassAccessor.CLASS_EXPANDING)["getInstance"]();
		

		public function DoubleClick_Panel()
		{
			masker.graphics.beginFill(0,0);
			masker.graphics.drawRect(0,0,BANNER_WIDTH, BANNER_HEIGHT);
			masker.graphics.endFill();
			masker.x = BANNER_WIDTH;
			this.mask = masker;
			addChild(masker);
			TweenNano.to(mask, 1, {x : 0, ease : Strong.easeOut});
			
			clickArea.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			btnCta.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			btnCollapse.addEventListener(MouseEvent.CLICK, onCollapseButtonClick, false, 0, true);	
			clickArea.buttonMode = btnCollapse.buttonMode = true;
		}

		private function onCollapseButtonClick(event : MouseEvent) : void
		{
			expanding.collapse();
			enabler.reportManualClose(); 
		}

		private function onMouseClick(event : MouseEvent) : void
		{
			switch (event.currentTarget.name)
			{
				case 'btnCta' :
					enablerCollapsed.exit("expanded_clickArea_exit");
					break;

				case 'clickArea' :
					enablerCollapsed.exit("expanded_clickArea_exit");
					break;
			}

			expanding.collapse();			
		}
	}
}