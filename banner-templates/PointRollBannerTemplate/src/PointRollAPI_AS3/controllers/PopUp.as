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

	import flash.net.LocalConnection;

	/**
	 * @private
 */
	public class  PopUp implements IActivityRecorder, IPanelControl, ISingleton{
		private static var m_oInstance:PopUp;
		private var m_oLC:LocalConnection;
		
		public function PopUp(s:SingletonEnforcer){
			m_oLC = new LocalConnection();
		}
		
		public static function getInstance():PopUp{
			if(m_oInstance == null){
				m_oInstance = new PopUp(new SingletonEnforcer());
			}
			return m_oInstance;
		}
		
		public function activity(a:Number, panel:String, banner:String, impID:String, noun:String):void
		{
			/* Executes activity calls via a LocalConnection object for AIM and MSN Messenger creatives - Function.apply() method used to simplify use of noun parameter*/
			
			var argArray:Array = new Array("pr_lc_popUp","pr_popControl","prTrackActivity",a, impID, panel, banner );
			if(noun != null) argArray.push(escape(noun));
			PrDebug.PrTrace("PopUp activity: "+argArray.toString(),3,"PopUp");
			m_oLC.send.apply(this, argArray);
		}
		
		/// Panel Controls ///
		public function close():void{
			PrDebug.PrTrace("Close Panel",3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prClose");
		}
		public function pin():void
		{
			PrDebug.PrTrace("Pin Panel",3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prPin");
		}
		public function delayedPin(a:int=undefined):void
		{
			PrDebug.PrTrace("delayedPin "+a,3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prDelayedPin",a);
		}
		public function goPanel(p:int,auto:Object=undefined):void
		{
			PrDebug.PrTrace("goPanel "+p,3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prGoPanel",p,auto);
		}
		public function openPanel(p:int):void
		{
			if(StateManager.getDisplayState() == StateManager.BANNER)
			{
				PrDebug.PrTrace("openPanel "+p,3,"PopUp");
				m_oLC = new LocalConnection();
				m_oLC.send("pr_lc_popUp","pr_popControl","prOpenPanel",p);
			}else{
				throw(new PrError(PrError.NOT_ALLOWED_FROM_STATE));
			}
		}
		public function unPin():void
		{
			PrDebug.PrTrace("UnPin Panel",3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prUnPin");
		}
		public function pushDown(t:Number,y:Number):void
		{
			PrDebug.PrTrace("Push Down over "+t+" seconds, and "+y+" pixels",3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prPush",t,y);
		}
		public function reveal(w:Number,h:Number,x:Number=0,y:Number=0,track:Number=1):void
		{
			PrDebug.PrTrace("Reveal: 1,"+w+","+h+","+x+","+y+","+track,3,"PopUp");	
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prReveal",1,w,h,x,y);
		}
		public function unReveal(w:Number,h:Number,x:Number=0,y:Number=0,track:Number=0):void
		{
			PrDebug.PrTrace("UnReveal: 0,"+w+","+h+","+x+","+y+","+track,3,"PopUp");
			m_oLC = new LocalConnection();
			m_oLC.send("pr_lc_popUp","pr_popControl","prReveal",0,w,h,x,y);
		}
	}
	
}
class SingletonEnforcer{}