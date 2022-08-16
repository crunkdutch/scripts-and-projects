/**
* ...
* @author Default
* @version 0.1
*/

package PointRollAPI_AS3.controllers
{
	import PointRollAPI_AS3.IActivityRecorder;
	import PointRollAPI_AS3.IPanelControl;
	import PointRollAPI_AS3.ISingleton;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.external.ExternalInterface;

	/**
	 * @private
 */
	public class JSPlatform implements IActivityRecorder, IPanelControl, ISingleton{
		
		private static var m_oInstance:JSPlatform;
		
		public function JSPlatform(s:SingletonEnforcer){}
		
		public static function getInstance():JSPlatform{
			if(m_oInstance == null){
				m_oInstance = new JSPlatform(new SingletonEnforcer());
			}
			return m_oInstance;
		}
		
		public function activity(a:Number, panel:String, banner:String, impID:String, noun:String):void
		{
			/*Executes EI calls to the JS Platform -- Function.apply() method used to simplify use of noun parameter*/
			var argArray:Array = new Array("prTrackActivity",a, impID, panel, banner );
			if(noun != null) argArray.push(escape(noun));
			PrDebug.PrTrace("Activity: "+argArray.toString(),3,"JSPlatform");
			ExternalInterface.call.apply(this, argArray);
		}
		
		//Panel Controls//
		public function close():void{
			PrDebug.PrTrace("Close Panel",3,"JSPlatform");
			ExternalInterface.call("prClose");
		}
		
		
		
		public function pin():void
		{
			PrDebug.PrTrace("Pin Panel",3,"JSPlatform");	
			ExternalInterface.call("prPin");
		}
		
		
		
		public function delayedPin(a:int=undefined):void
		{
			PrDebug.PrTrace("Delayed Pin Panel",3,"JSPlatform");
			var args:Array = ["prDelayedPin"];
			if(!isNaN(a))
			{
				args.push(a);
			}
			ExternalInterface.call.apply(this,args);
		}

		
		
		
		public function goPanel(p:int,auto:Object=undefined):void
		{
			if( (auto is Boolean) && auto ){
				PrDebug.PrTrace("Go Panel "+p+" - Auto display true",3,"JSPlatform");
				ExternalInterface.call("prGoPanel",p,-1); //auto panel, do not track activity
				return
			}else{
				if(!isNaN(Number(auto)) && auto > 0){
					PrDebug.PrTrace("Go Panel "+p+" - Activity:"+auto,3,"JSPlatform");
					ExternalInterface.call("prGoPanel",p,auto); //auto is an activity number
					return
				}
			}
			
			//default behavior
			PrDebug.PrTrace("Go Panel "+p,3,"JSPlatform");
			ExternalInterface.call("prGoPanel",p); 
		}

		
		
		public function openPanel(p:int):void
		{
			PrDebug.PrTrace("Open panel "+p,3,"JSPlatform");
			if(StateManager.getDisplayState() == StateManager.BANNER)
			{
				ExternalInterface.call("prOpenPanel",p,StateManager.URLParameters.PRAd);
			}else{
				throw(new PrError(PrError.NOT_ALLOWED_FROM_STATE));
			}
		}
		
		
		
		public function unPin():void
		{
			PrDebug.PrTrace("UnPin Panel",3,"JSPlatform");
			ExternalInterface.call("prUnPin");
		}
	
		
		
		public function pushDown(t:Number,y:Number):void
		{
			PrDebug.PrTrace("Push Down over "+t+" seconds, and "+y+" pixels",3,"JSPlatform");
			ExternalInterface.call("prPush",t,y);
		}
		
		
				
		public function reveal(w:Number,h:Number,x:Number=0,y:Number=0, track:Number=1):void
		{
			PrDebug.PrTrace("Reveal: 1,"+w+","+h+","+x+","+y+","+track,3,"JSPlatform");
			ExternalInterface.call("prReveal",1,w,h,x,y,track);
		}
			
		
		public function unReveal(w:Number,h:Number,x:Number=0,y:Number=0, track:Number=0):void
		{
			PrDebug.PrTrace("UnReveal: 0,"+w+","+h+","+x+","+y+","+track,3,"JSPlatform");
			ExternalInterface.call("prReveal",0,w,h,x,y,track);
		}
	}
	
}
class SingletonEnforcer{}