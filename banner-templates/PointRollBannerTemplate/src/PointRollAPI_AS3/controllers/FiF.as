package PointRollAPI_AS3.controllers
{
	import PointRollAPI_AS3.IActivityRecorder;
	import PointRollAPI_AS3.ISingleton;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @private
 */	
	public class  FiF implements IActivityRecorder, ISingleton{
		
		private static var m_oInstance:FiF;
		public function FiF(s:SingletonEnforcer){}
		
		public static function getInstance():FiF{
			if(m_oInstance == null){
				m_oInstance = new FiF(new SingletonEnforcer());
			}
			return m_oInstance;
		}
		
		public function activity(a:Number, panel:String, banner:String, impID:String, noun:String):void
		{
			/* Executes activity calls via a Loader for non-JS environments*/
			var tracking:Loader = new Loader();
			PrDebug.PrTrace("Flash Activity called with arguments: "+arguments,3);
			var q:String = panel=="0"? "ba":"pa";
			var trackURL:String = "http://t.pointroll.com/pointroll/track/?q="+q+"&o=1";
			if(q=="pa"){ trackURL += "&u="+panel; }
			if( noun != null ){ trackURL += "&n="+escape(noun); }
			//prepare guid
			var guid:String = impID.substr(0,8)+'-'+impID.substr(8,4)+'-'+impID.substr(12,4)+'-'+impID.substr(16,4)+'-'+impID.substr(20,12);
			
			trackURL += "&i=" + guid + "&c=" + a + "&r=" + Math.random();
			tracking.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioHandler);
			try {
				tracking.load(new URLRequest(trackURL));
			}catch (e:Error) {
				//do nothing
			}
		}
		
		private function _ioHandler(e:IOErrorEvent):void {
			//this error is most likely because the download type is unknown... we dont care
		}
	}
	
}
class SingletonEnforcer{}