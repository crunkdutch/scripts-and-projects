package  PointRollAPI_AS3.media.delivery
{
	import PointRollAPI_AS3.events.net.*;
	import PointRollAPI_AS3.net.PrNetConnection;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.events.EventDispatcher;
	import flash.net.*;

	/**
* Handles the preparation of streaming video connections
* @author Chris Deely - PointRoll
* @version 1.0
* @private
*/

	public class StreamingVideo extends EventDispatcher implements IVideoDelivery{
		// Event MetaData
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.NSREADY
		 */
		[Event(name = "netStreamReady", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.LOW_BANDWIDTH
		 */
		[Event(name = "lowBandwidth", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrNetEvent.ON_bwDone
		 */
		[Event(name = "onBandwidthDone", type = "PointRollAPI_AS3.events.net.PrNetEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrNetEvent.NCFAIL
		 */
		[Event(name = "onNetConnectionFail", type = "PointRollAPI_AS3.events.net.PrNetEvent")]
		
		
		private var m_aActivities:Object = {play:1001,pause:1002,stop:1006,restart:1003,replay:1007,unmute:1005,mute:1004};
		
		
		private var m_objNetConnection:PrNetConnection;

		private var m_sAdvertiser:String;
		private var m_sStream:String;
		private var m_nServerIndex:Number;
		private var m_nUserBandwidth:Number;
		private var m_nMinimumBandwidth:Number;
		private var m_nTotalTime:Number;

		private var m_bStreamConnected:Boolean = false;
		private var m_bUseHD:Boolean = false;
		private var m_oNetStream:NetStream;

		public function StreamingVideo( advertiser:String, stream:String, server:Number=0, minimumBandwidth:Number=0, useHD:Boolean=false)
		{
			m_sAdvertiser = advertiser;
			m_sStream = stream;
			m_nServerIndex = server;
			m_nMinimumBandwidth = minimumBandwidth;
			
			m_bUseHD = useHD;
			
			m_sStream = m_sStream + "_8_";
		}
		
		public function init():void
		{
			PrDebug.PrTrace("Init Streaming Video from server "+m_nServerIndex,3,"StreamingVideo");
			m_objNetConnection = new PrNetConnection(m_sAdvertiser, m_sStream, m_nServerIndex, m_bUseHD);
			m_objNetConnection.addEventListener(PrNetEvent.NCREADY, _netConnectionReady, false,0,true);
			m_objNetConnection.addEventListener(PrNetEvent.ONBWDONE, _bwDone, false,0,true);
			m_objNetConnection.addEventListener(PrNetEvent.NCFAIL, _failure, false,0,true);
			m_objNetConnection.connect();	
		}
		
		/**
		 * In the event of a connection timeout, this function should kill off any existing connections
		 */
		public function cleanUp():void
		{
			try{
			m_objNetConnection.close();
			m_objNetConnection.removeEventListener(PrNetEvent.NCREADY, _netConnectionReady);
			m_objNetConnection.removeEventListener(PrNetEvent.ONBWDONE, _bwDone);
			m_objNetConnection.removeEventListener(PrNetEvent.NCFAIL, _failure);
			m_objNetConnection = null;
			}catch (e:Error)
			{PrDebug.PrTrace("Cleanup NC: "+e.toString(), 4, "StreamingVideo"); }
			try
			{
				m_oNetStream.close();
				m_oNetStream = null;
			}catch (e:Error)
			{
				PrDebug.PrTrace("Cleanup NS: "+e.toString(), 4, "StreamingVideo");
			}
		}
		
		private function _netConnectionReady(e:PrNetEvent):void
		{
			PrDebug.PrTrace("Streaming NC Ready",3,"StreamingVideo");
			var tmp:Object = e.infoObj;
			m_oNetStream = new NetStream(tmp.NC);
			tmp.NS = m_oNetStream;
			dispatchEvent( new PrNetEvent(PrNetEvent.NSREADY, tmp) )
		}
		
		private function _bwDone(e:PrNetEvent):void
		{
			m_nUserBandwidth = Number(e.infoObj);
			if (m_nUserBandwidth >= m_nMinimumBandwidth)
			{
				m_objNetConnection.getStreamLength();
			}
			dispatchEvent( new PrNetEvent(PrNetEvent.ONBWDONE, m_nUserBandwidth) );
		}
		
		private function _failure(e:PrNetEvent):void
		{
			PrDebug.PrTrace("NetConnection failed", 3, "StreamingVideo");
			dispatchEvent( new PrNetEvent(PrNetEvent.NCFAIL) );
		}
	}
}