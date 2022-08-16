package PointRollAPI_AS3.util.widgets 
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.events.widget.PrWidgetEvent;
	import PointRollAPI_AS3.util.StringUtil;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.*;

	/**
	 * Provides Widget distribution via Clearspring
	* @author Chris Deely - PointRoll
	* @private 
	*/
	internal class ClearSpringMenu extends EventDispatcher implements IWidgetControl {
		
		/** @private Hidden property to set additional flags on the url */
		public var __urlFlags:String;
		/** @private Hidden property to set query string params */
		public var __queryString:String;		
		private var m_bInContainer:Boolean = false;
		private var m_oCSKernel:Object;
		private var m_bMenuLoaded:Boolean = false;
		private const m_sBaseURL:String = "http://widgets.clearspring.com/o/{0}/-/-/-/{1}-CTU/*/-TRK/1/lib.as3.swf?{2}";
		private var m_sWID:String;
		private var m_sPID:String;
		private var m_oParameters:Object;
		private var m_oTarget:DisplayObjectContainer;
		private var m_bAutoDisplay:Boolean = false;
		private var csKernelLoader:Loader;
		private var _menuX:Number = 1;
		private var _menuY:Number = 1;
		
		
		
		public function ClearSpringMenu(target:DisplayObjectContainer) {
			//set security allowances
			Security.allowDomain("test.ads.pointroll.com");	
			Security.allowDomain("ads.pointroll.com");	
			Security.allowDomain("demo.pointroll.net");	
			Security.allowDomain("bin.clearspring.com");
			Security.allowDomain("widgets.clearspring.com");
			Security.allowDomain("widgets.testspring.com");
			m_oTarget = target;
			
			target.root.loaderInfo.addEventListener(Event.COMPLETE, _initialize, false, 0, true);
			
		}
		
		public function loadLibrary( autoDisplay:Boolean = false):void
		{
			
			if ( !m_bMenuLoaded )
			{
				if ( m_bInContainer )
				{
					m_bMenuLoaded = true;
					dispatchEvent(new PrWidgetEvent(PrWidgetEvent.LIBRARY_LOADED));
					if ( autoDisplay )
					{
						showMenu();
					}
				}else {
					m_bAutoDisplay = autoDisplay;
					csKernelLoader = new Loader();
					var request:URLRequest = new URLRequest( StringUtil.insertion(m_sBaseURL, m_sWID, __urlFlags, __queryString) );
					m_oTarget.addChild(csKernelLoader);
					csKernelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _libraryLoaded, false, 0, true);
					// Load Clearspring kernel into our security domain
					var loaderContext:LoaderContext
					if ( StateManager.getPlatformState() == StateManager.TESTING )
					{
						loaderContext = new LoaderContext();
					}else {
						loaderContext  = new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
					}
					csKernelLoader.load(request, loaderContext);
				}
			}
		}
		
		/** Event handler for loading of CS library */
		private function _libraryLoaded(e:Event):void {
			try {
				m_oCSKernel = e.target.loader.content;
			}catch (e:Error)
			{
				dispatchEvent(new PrWidgetEvent(PrWidgetEvent.FAILURE));
			}
			m_bMenuLoaded = true;
			_setListeners();
			dispatchEvent(new PrWidgetEvent(PrWidgetEvent.LIBRARY_LOADED));
			if ( m_bAutoDisplay )
			{
				showMenu();
			}
		}
		/** @inheritDoc */
		public function showMenu():void{
			if ( !m_bMenuLoaded )
			{
				loadLibrary( true );
			}else {
				m_oCSKernel.menu.configure( m_oParameters );
				m_oCSKernel.menu.show(null,{x: menuX, y: menuY});
			}
			
		}
		/** @inheritDoc */
		public function hideMenu():void{
			try
			{
				m_oCSKernel.menu.hide();
			} catch (e:Error) {}
		}
		
		public function addParameter(name:String, value:String):void{
			if ( !m_oParameters )
			{
				m_oParameters = new Object()
			}
			m_oParameters[name] = value;
			PrDebug.PrTrace("Parameter added "+name+"="+value,2,"ClearSpringMenu");
		}
		public function unloadMenu():void
		{
			try{m_oTarget.removeChild( csKernelLoader ); } catch (e:Error){}
			try{m_oCSKernel.stop(); } catch (e:Error){ }
			try {_removeListeners(); } catch (e:Error) {}
			m_oCSKernel = null;
			csKernelLoader.unload();
			csKernelLoader = null;
			m_oTarget = null;
		}
		
		/** @inheritDoc */
		public function get menuX():Number
		{
			return _menuX;
		}
		public function set menuX(x:Number):void
		{
			_menuX = x;
		}
		
		/** @inheritDoc */
		public function get menuY():Number
		{
			return _menuY;
		}
		public function set menuY(y:Number):void
		{
			_menuY = y;
		}
		
		/** @inheritDoc */
		public function get libraryObject():Object
		{
			return m_oCSKernel;
		}
		
		/** Needed for clickThruRestricted() in PrWidgetControl */
		public function get inTheWild():Boolean
		{
			return m_bInContainer;
		}
		
		private function _setListeners():void {	
			m_oCSKernel.menu.addEventListener( m_oCSKernel.menu.event.OPEN,  _openHandler, false,0,true);
			m_oCSKernel.menu.addEventListener( m_oCSKernel.menu.event.CLOSE, _closeHandler, false,0,true);	
		}
		private function _removeListeners():void {	
			m_oCSKernel.menu.removeEventListener( m_oCSKernel.menu.event.OPEN,  _openHandler);
			m_oCSKernel.menu.removeEventListener( m_oCSKernel.menu.event.CLOSE, _closeHandler);	
		}
		private function _openHandler(e:Event):void {
		
			dispatchEvent( new PrWidgetEvent(PrWidgetEvent.MENU_SHOWN));
		}
		private function _closeHandler(e:Event):void {
		
			dispatchEvent( new PrWidgetEvent(PrWidgetEvent.MENU_CLOSED));
		}
		
		
		private function _initialize(e:Event):void
		{
			m_oTarget.root.loaderInfo.removeEventListener(Event.COMPLETE, _initialize);
			if ( !StateManager.root ) 
			{
				StateManager.setRoot(m_oTarget);
			}
			try{
				if ( StateManager.root.loaderInfo.loader.root.loaderInfo.loader.root["context"] )
				{
					m_bInContainer = true;
					m_oCSKernel = StateManager.root.loaderInfo.loader.root.loaderInfo.loader.root;
					_setListeners();
				}
			}catch (e:Error) {
				trace("*********************************" + e.toString())
				m_bInContainer = false;
			}
			m_sWID = StateManager.URLParameters.prWID;
			
			if ( !m_sWID )
			{
				if ( StateManager.getDisplayState() == StateManager.TESTING )
				{
					PrDebug.PrTrace("Using Testing WID", 1, "ClearSpringMenu");
					m_sWID = "47332a701ae231a3";
				}else{
					PrDebug.PrTrace("Widget ID is not set - Menu will not load", 1, "ClearSpringMenu");
				}
			}
			
			if ( StateManager.URLParameters.prWIDPID )
			{
				m_sPID = StateManager.URLParameters.prWIDPID;
				addParameter("pid", m_sPID);
				if (!inTheWild)
				{
					addParameter("_cs_PRP", m_sPID + ":" + StateManager.URLParameters.PRPID + ":" + StateManager.URLParameters.PRCID + ":" + StateManager.URLParameters.PRPanel);
				}
			}
		}
	}
	
}