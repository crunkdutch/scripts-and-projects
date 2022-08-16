package PointRollAPI_AS3.controllers 
{
	import PointRollAPI_AS3.IActivityRecorder;
	import PointRollAPI_AS3.IPanelControl;
	import PointRollAPI_AS3.ISingleton;
	import PointRollAPI_AS3.util.debug.PrDebug;

	/**
	* @private
	* @author Default
	*/
	public class TestingPlatform implements IActivityRecorder, IPanelControl, ISingleton{
		private static var m_oInstance:TestingPlatform;
		
		public function TestingPlatform(s:SingletonEnforcer) {}
		public static function getInstance():TestingPlatform
		{
			if(m_oInstance == null){
				m_oInstance = new TestingPlatform(new SingletonEnforcer());
			}
			return m_oInstance;
		}
		
		public function activity(a:Number, panel:String, banner:String, impID:String, noun:String):void{
			var s:String = "Activity " + a + " has been fired";
			if (noun)
			{
				s += " with a noun value of " + noun;
			}
			PrDebug.PrTrace(s);
		}
		
		public function close():void{
			PrDebug.PrTrace("Close Panel");
		}
		
		public function openPanel(n:int):void{
			PrDebug.PrTrace("Open Panel "+n);
		}
		
		public function goPanel(n:int, auto:Object = undefined):void{
			PrDebug.PrTrace("Go to Panel "+n);
		}
		
		public function pin():void{
			PrDebug.PrTrace("Pin Panel");
		}
		
		public function unPin():void{
			PrDebug.PrTrace("UnPin Panel");
		}
		
		public function delayedPin(a:int = undefined):void{
			PrDebug.PrTrace("Delayed Pin: activity = "+a);
		}
		
		public function pushDown(t:Number, y:Number):void{
			PrDebug.PrTrace("Pushdown: "+t+", "+y);
		}
		
		public function reveal(w:Number, h:Number, x:Number=0, y:Number=0, track:Number=1):void{
			PrDebug.PrTrace("Reveal: "+arguments.toString());
		}
		
		public function unReveal(w:Number, h:Number, x:Number=0, y:Number=0, track:Number=0):void{
			PrDebug.PrTrace("UnReveal: "+arguments.toString());
		}
		
	}
	
}
class SingletonEnforcer{}