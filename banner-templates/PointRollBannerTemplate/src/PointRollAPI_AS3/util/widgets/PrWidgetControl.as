package PointRollAPI_AS3.util.widgets 
{
	import PointRollAPI_AS3.ActivityController;
	import PointRollAPI_AS3.PointRoll;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.events.widget.PrWidgetEvent;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @see PrWidgetControl#loadLibrary()
	 * @eventType PointRollAPI_AS3.events.widget.PrWidgetEvent.LIBRARY_LOADED
	 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_loadLibrary.txt -noswf
	 */
	[Event(name = "libraryLoaded", type = "PointRollAPI_AS3.events.widget.PrWidgetEvent")]
	/**
	 * @see PrWidgetControl#showMenu()
	 * @eventType PointRollAPI_AS3.events.widget.PrWidgetEvent.MENU_SHOWN
	 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
	 */
	[Event(name = "menuShown", type = "PointRollAPI_AS3.events.widget.PrWidgetEvent")]
	/**
	 * @see PrWidgetControl#hideMenu()
	 * @eventType PointRollAPI_AS3.events.widget.PrWidgetEvent.MENU_CLOSED
	 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
	 */
	[Event(name = "menuClosed", type = "PointRollAPI_AS3.events.widget.PrWidgetEvent")]
	/**
	 * @see PrWidgetControl#showMenu()
	 * @see PrWidgetControl#loadLibrary()
	 * @eventType PointRollAPI_AS3.events.widget.PrWidgetEvent.FAILURE
	 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_timeOut_failure.txt -noswf
	 */
	[Event(name = "failure", type = "PointRollAPI_AS3.events.widget.PrWidgetEvent")]
	
	
	/**
	* Provides access to widget sharing services from various 3rd party vendors.
	* @author Chris Deely - PointRoll
	*/
	public class PrWidgetControl extends EventDispatcher implements IWidgetControl 
	{
		/** Constant value used in Constructor to indicate use of Clearspring as the widget distribution provider */
		public static const CLEARSPRING:String = "clearspring";
		/** @private
		 * @internal marked as private as Gigya support is not yet included
		 * Constant value used in Constructor to indicate use of Gigya as the widget distribution provider */
		public static const GIGYA:String = "gigya";
		/** Time to allow for loading the code library, in milliseconds. 
		 * @see #event:failure
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_timeOut_failure.txt -noswf
		 */
		public var timeOut:int = 10000;
		
		/**
		 * List of ClearSpring's blacklisted sites, from this file: http://widgetstudio.clearspring.com/xml/blackList.xml 
		 */
		public var blacklist:Array = new Array("friendster", "myspace", "xanga", "orkut");
		
		private var m_oActivityController:ActivityController;
		private var m_oMenuControl:IWidgetControl;
		private var m_bLoadSuccess:Boolean = false;
		private var m_Timer:Timer;
		
		private var m_bForceAlert:Boolean = false;
		
		private const WIDGET_GRAB_ATTEMPT:Number=8850;
		private const WIDGET_CANCEL_GRAB_ATTEMPT:Number = 8851;
		
		private var container:Sprite;
		private var widgetOverlay:Sprite;
		private var bubbleContainer:Sprite;
		private var goBackButton:Sprite;
		private var whyButton:Sprite;
		private var alertMsg:TextField;
		private var goBackText:TextField;
		private var whyText:TextField;
		private var closeButton:Sprite;
		private var dropShadow:GlowFilter;
		private var shadowArr:Array;
		private var msgFormat:TextFormat;
		private var btnFormat:TextFormat;
		
		/**
		 * Creates a new widget control object.
		 * @param	target A DisplayObjectContainer into which the sharing menu will be loaded
		 * @param	provider One of the widget distributors available within the PointRoll API
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		public function PrWidgetControl(target:DisplayObjectContainer, provider:String = PrWidgetControl.CLEARSPRING) 
		{
			
			m_oActivityController = ActivityController.getInstance( target );
			switch( provider )
			{
				case CLEARSPRING:
					m_oMenuControl = new ClearSpringMenu(target);
					break;
				case GIGYA:
					m_oMenuControl = new Gigya(target);
					break;
				default:
					throw( new PrError(PrError.UNKNOWN_PROVIDER));
			}
			m_oMenuControl.addEventListener(PrWidgetEvent.FAILURE, _eventBubbler, false,0,true);
			m_oMenuControl.addEventListener(PrWidgetEvent.LIBRARY_LOADED, _eventBubbler, false,0,true);
			m_oMenuControl.addEventListener(PrWidgetEvent.MENU_CLOSED, _eventBubbler, false,0,true);
			m_oMenuControl.addEventListener(PrWidgetEvent.MENU_SHOWN, _eventBubbler, false,0,true);
			
			StateManager.addEventListener(StateManager.KILL, _killCommandHandler, false, 0, true);
		}
			
		/**
		 * @see PrWidgetControl#libraryObject
		 * @see #event:libraryLoaded
		 * @see #event:failure
		 * @inheritDoc
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_loadLibrary.txt -noswf
		 */
		public function loadLibrary(autoDisplay:Boolean = false):void
		{
			if (! m_bLoadSuccess ) 
			{
				_startTimer()
			}
			m_oMenuControl.loadLibrary(autoDisplay);
		}
		
		/**
		 * @see #event:menuShown
		 * @see #event:failure
		 * @inheritDoc
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		public function showMenu():void
		{
			if (! m_bLoadSuccess ) 
			{
				_startTimer()
			}
			m_oMenuControl.showMenu();
		}
		/**
		 * @see #event:menuClosed
		 * @inheritDoc
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		public function hideMenu():void
		{
			m_oMenuControl.hideMenu();
		}
		
		/** @inheritDoc */
		public function get menuX():Number
		{
			return m_oMenuControl.menuX;
		}
		public function set menuX(x:Number):void
		{
			m_oMenuControl.menuX = x;
		}
		
		/** @inheritDoc */
		public function get menuY():Number
		{
			return m_oMenuControl.menuY;
		}
		public function set menuY(y:Number):void
		{
			m_oMenuControl.menuY = y;
		}
		
		/**
		 * @see PrWidgetControl#loadLibrary
		 * @see http://www.clearspring.com/docs/tech/apis/in-widget Clearspring AS3 Reference
		 * @inheritDoc
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_loadLibrary.txt -noswf
		 */
		public function get libraryObject():Object
		{
			return m_oMenuControl.libraryObject;
		}
		
		public function get inTheWild():Boolean
		{
			return m_oMenuControl.inTheWild;
		}
		
		/** 
		 * @inheritDoc 
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_addParameter.txt -noswf
		 */
		public function addParameter(name:String, value:String):void
		{
			m_oMenuControl.addParameter(name, value);
		}
		/** 
		 * @inheritDoc 
		 */
		public function unloadMenu():void
		{
			m_oMenuControl.removeEventListener(PrWidgetEvent.FAILURE, _eventBubbler);
			m_oMenuControl.removeEventListener(PrWidgetEvent.LIBRARY_LOADED, _eventBubbler);
			m_oMenuControl.removeEventListener(PrWidgetEvent.MENU_CLOSED, _eventBubbler);
			m_oMenuControl.removeEventListener(PrWidgetEvent.MENU_SHOWN, _eventBubbler);
			
			hideMenu();
			m_oMenuControl.unloadMenu();
			m_oMenuControl = null;
		}
		
		/** Creates & Starts time out timer */
		private function _startTimer():void{
			m_Timer = new Timer(timeOut);
			m_Timer.addEventListener(TimerEvent.TIMER, _failure, false, 0, true);
			m_Timer.start();
		}
		/** Signals timeout failure */
		private function _failure(e:TimerEvent):void {
			_stopTimer()
			PrDebug.PrTrace("Widget Menu Failed to Load", 1, "PrWidgetControl");
			dispatchEvent(new PrWidgetEvent(PrWidgetEvent.FAILURE));
		}
		/** Stops and destroys the Timer when the menu successfully loads */
		private function _stopTimer():void{
			m_Timer.stop();
			m_Timer.removeEventListener(TimerEvent.TIMER, _failure);
			m_Timer = null;
			m_bLoadSuccess = true;
		}
		
		/**
		 * Allows the designer to force this property to true for testing the alert.
		 */
		public function set clickThruRestricted(b:Boolean):void	
		{
			m_bForceAlert = b;
		}
		
		/**
		 * Checks to see if the current domain is blacklisted. 
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_clickThruRestricted.txt -noswf
		 */
		public function get clickThruRestricted():Boolean
		{
			if (inTheWild)
			{
				var currentDomain:String = libraryObject.context.DOMAIN;
				for (var i:int = 0; i < blacklist.length; i++)
				{
					if (currentDomain.indexOf(blacklist[i]) != -1)
					{
						return true;
					}
				}
			}
			return m_bForceAlert;
		}
		
		/**
		 * If click-thrus are restricted, an alert pop-up with an explanation of the restriction is drawn over the content--graying it out and 
		 * preventing interaction--and copying the URL to the user's clipboard.
		 * @param	url The URL to be processed, (typically a clicktag, i.e. myPR.parameters.clickTag1)
		 * @param	prObj A PointRoll object on which to call launchURL, if the domain is not restricted.
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		public function processURL(url:String, prObj:PointRoll):void
		{
			if (!clickThruRestricted)
			{
				trace("Site is not restricted. Launching URL....");
				try 
				{
					prObj.launchURL(url);
				} catch(e:Error){}
			} else
			{
				trace("Site restricts click-thrus.");
				try
				{
					_generateBubble(url);
				} catch(e:Error){}
			}
		}
		/*******************************************************************************************
		 * @private
		 * Draws the default alert pop-up over widget, and copies the URL to the user's clipboard.
		 * @param	urlRef Reference to url parameter in processURL()
		 */
		private function _generateBubble(urlRef:String):void
		{
			dropShadow = new GlowFilter(0x000000, .27, 4, 4, 2, 3, false, false);
			shadowArr = new Array();
			shadowArr.push(dropShadow);
			
			msgFormat = new TextFormat();
			with (msgFormat)
			{
				font = "Verdana";
				bold = true;
				size = 11;
				color = 0x000000;
				blockIndent = 2;
			}
			
			btnFormat = new TextFormat();
			with (btnFormat)
			{
				font = "Verdana";
				bold = true;
				size = 10;
				color = 0xFFCC00;
				blockIndent = 1;
			}
			
			System.setClipboard(urlRef);
			
			if (!container)
			{
				container = new Sprite();
			}
			
			if (!widgetOverlay)
			{
				widgetOverlay = new Sprite();
				_drawRect(widgetOverlay, 0, 0, StateManager.root.stage.stageWidth, StateManager.root.stage.stageHeight, 0xFFFFFF, .75);
				container.addChild(widgetOverlay);
			}
			
			if (!bubbleContainer)
			{
				bubbleContainer = new Sprite();
				var bubbleX:Number = (StateManager.root.stage.stageWidth / 2) - 112;
				var bubbleY:Number = (StateManager.root.stage.stageHeight / 2) - 50;
				
				bubbleContainer.graphics.lineStyle(1, 0x555555, 1, false, "none", "none", "miter");
				_drawRect(bubbleContainer, bubbleX, bubbleY, 225, 100, 0x777777, .75);
				bubbleContainer.filters = shadowArr;
				container.addChild(bubbleContainer);
			}
			
			if (!closeButton)
			{
				closeButton = new Sprite();
				var closeX:Number = bubbleX + 207;
				var closeY:Number = bubbleY + 4;
				
				_drawRect(closeButton, closeX, closeY, 15, 15, 0x000000, 1);
				with (closeButton.graphics) 
				{
					moveTo((closeX + 3), (closeY + 3));
					beginFill(0xFFCC00);
					lineStyle(2, 0xFFCC00, 1, false, "none", "round", "miter");
					lineTo((closeX + 12), (closeY + 12));
					endFill();
					moveTo((closeX + 3), (closeY + 12));
					beginFill(0xFFCC00);
					lineStyle(2, 0xFFCC00, 1, false, "none", "round", "miter");
					lineTo((closeX + 12), (closeY + 3));
					endFill();
				}
				bubbleContainer.addChild(closeButton);
			}
			
			if (!alertMsg)
			{
				alertMsg = new TextField();
				with (alertMsg)
				{
					alertMsg.multiline = true;
					wordWrap = true;
					selectable = false;
					text = "The link has been copied to your clipboard. Paste it into your browser to continue to your destination.";
					setTextFormat(msgFormat);
					x = bubbleX + 10;
					y = bubbleY + 20;
					width = 200;
					height = 60;
				}
				container.addChild(alertMsg);
			}
			
			if (!whyText)
			{
				whyText = new TextField();
				var whyX:Number = bubbleX + 155;
				var whyY:Number = bubbleY + 78;
				
				with (whyText)
				{
					selectable = false;
					text = "Why?";
					setTextFormat(btnFormat);
					x = whyX;
					y = whyY;
					width = 36;
					height = 16;
				}
				container.addChild(whyText);
			}
			
			if (!whyButton)
			{
				whyButton = new Sprite();
				_drawRect(whyButton, whyX, whyY, 37, 17, 0x000000, 0);
				container.addChild(whyButton);
			}
			
			if (!goBackText)
			{
				goBackText = new TextField();
				var goBackX:Number = bubbleX + 15;
				var goBackY:Number= bubbleY + 80;
				
				with (goBackText)
				{
					selectable = false;
					text = "« Go back";
					setTextFormat(btnFormat);
					x = goBackX;
					y = goBackY;
					width = 60;
					height = 16;
					visible = false;
				}
				container.addChild(goBackText);
			}
			
			if (!goBackButton)
			{
				goBackButton = new Sprite();
				_drawRect(goBackButton, goBackX, goBackY, 60, 17, 0x000000, 0);
				goBackButton.mouseEnabled = false;
				container.addChild(goBackButton);
			}
			
			DisplayObjectContainer(StateManager.root).addChild(container);
			
			whyButton.addEventListener(MouseEvent.MOUSE_UP, _whyBtnHandler);
			closeButton.addEventListener(MouseEvent.MOUSE_UP, _closeBtnHandler);
			goBackButton.addEventListener(MouseEvent.MOUSE_UP, _backBtnHandler);
		}
		
		private function _whyBtnHandler(e:MouseEvent):void
		{
			alertMsg.text = "This site prevents linking out from Flash.";
			alertMsg.selectable = false;
			alertMsg.setTextFormat(msgFormat);
			whyText.visible = false;
			whyButton.mouseEnabled = false;
			goBackButton.mouseEnabled = true;
			goBackText.visible = true;
		}
		
		private function _backBtnHandler(e:MouseEvent):void
		{
			alertMsg.text = "The link has been copied to your clipboard. Paste it into your browser to continue to your destination.";
			alertMsg.setTextFormat(msgFormat);
			goBackButton.mouseEnabled = false;
			goBackText.visible = false;
			whyButton.mouseEnabled = true;
			whyText.visible = true;
		}
		
		private function _closeBtnHandler(e:MouseEvent):void
		{
			DisplayObjectContainer(StateManager.root).removeChild(container);
			
			removeEventListener(MouseEvent.MOUSE_UP, _whyBtnHandler);
			removeEventListener(MouseEvent.MOUSE_UP, _backBtnHandler);
			removeEventListener(MouseEvent.MOUSE_UP, _closeBtnHandler);
		}
		
		private function _drawRect(sp:Sprite, x:Number, y:Number, w:Number, h:Number, bg:Number, a:Number):void
		{
			sp.graphics.beginFill(bg, a);
			sp.graphics.drawRect(x, y, w, h);
			sp.graphics.endFill();
		}
		
		/*****************************************************************************************/
		
		private function _eventBubbler(e:Event):void
		{
			switch(e.type)
			{
				case PrWidgetEvent.MENU_SHOWN:
					if (!m_bLoadSuccess)
					{
						_stopTimer();
					}
					m_oActivityController.activity(WIDGET_GRAB_ATTEMPT);
					break;
				case PrWidgetEvent.MENU_CLOSED:
					m_oActivityController.activity(WIDGET_CANCEL_GRAB_ATTEMPT);
					break;
				case PrWidgetEvent.LIBRARY_LOADED:
					_stopTimer();
					break;
			}
			dispatchEvent(new PrWidgetEvent(e.type));
		}
		
		private function _killCommandHandler(e:Event):void 
		{
			try {unloadMenu(); } catch (e:Error) {}
		}
		
	}
	
}