/**
 * @private
* Wrapper for NetConnection class - provides PR specific functionality such as server settings and bandwidth profiles.
* @author Chris Deely - PointRoll
* @version 1.0
*/

package PointRollAPI_AS3.net 
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.events.net.*;
	import PointRollAPI_AS3.media.HDDelivery;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.events.*;
	import flash.net.*;

	/** @private */
	public class PrNetConnection extends EventDispatcher{
		
		
		private var m_aBandwidthProfiles:Array = [
													{bandwidth: HDDelivery.MINBANDWIDTH, streamQuality: "hd", activity:"-1{0}7", buffer: 6   },											
													{bandwidth: 901, streamQuality: "700k", activity:"-1{0}6", buffer: 1    },
													{bandwidth: 900, streamQuality: "575k", activity:"-1{0}5", buffer: 1.5 },
													{bandwidth: 700, streamQuality: "450k", activity:"-1{0}4", buffer: 2    },
													{bandwidth: 500, streamQuality: "325k", activity:"-1{0}3", buffer: 2    },
													{bandwidth: 375, streamQuality: "200k", activity:"-1{0}2", buffer: 2.5 },
													{bandwidth: 250, streamQuality: "56k",   activity:"-1{0}1", buffer: 3     }
												];
		
		private var m_objNetConnection1:NetConnection;
		private var m_objNetConnection2:NetConnection;
		private var m_objNetConnection3:NetConnection;
		private var m_NCestablished:Boolean = false;
		private var m_bCheckBW:Boolean    = true;
		private var m_connectCount:uint = 0;
		private var m_bRedirected:Boolean = false;
		
		private var m_oConnectionDetails:Object;
		private var m_bCleanUpInProgress:Boolean = false;
		
		private var m_FMS:FMSServer;
	
		private const m_aQueryParams:Object = {creative:"PRCID",placement:"PRPID",campaign:"PRCampID"};
		public function PrNetConnection(advertiser:String, streamName:String, serverIndex:Number=0, useHD:Boolean=false){
			
			if (!useHD)
			{
				//remove the HD profile
				m_aBandwidthProfiles.shift();
			}
			//Correct issues with AS3 and FMS2 by setting to AMF0
			NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF3;
			if(serverIndex == 0){
				serverIndex = FMSServer.DEFAULT;
			}
			
			m_FMS = new FMSServer(serverIndex);
			m_oConnectionDetails = {
				advertiser: advertiser,
				streamName: streamName
			}
		}
		
		public function connect(folder:String=""):void{
			if ( m_bCleanUpInProgress )
			{
				return;
			}
			if(m_FMS.ipLookup && !m_FMS.ipLookupComplete){
				//Kick over to IP Lookup
				_getIP( m_FMS.uri );
				return;
			}
			
			// Create NetConnection objects
			m_objNetConnection1 = _initNC(); 
			m_objNetConnection2 = _initNC();
			m_objNetConnection3 = _initNC(); 
			
			if (m_FMS.pathOnConnect){
				m_FMS.basePath += "/" + folder;
			}
			// Establish Connections
			PrDebug.PrTrace("Connecting to: rtmp://" +m_FMS.uri+":1935"+m_FMS.basePath+ m_FMS.fcs,4,"PrNetConnection");
			m_objNetConnection1.connect("rtmp://" + m_FMS.uri +":1935"+m_FMS.basePath+ m_FMS.fcs, m_bCheckBW);
			m_objNetConnection2.connect("rtmp://" + m_FMS.uri +":80"  +m_FMS.basePath+ m_FMS.fcs, m_bCheckBW);
			m_objNetConnection3.connect("rtmpt://"+ m_FMS.uri +":80"  +m_FMS.basePath+ m_FMS.fcs, m_bCheckBW);
		}
		/**
		 * Forces the NetConnections to shut down. Used in the event of a timeout before the connection is established.
		 */
		public function close():void
		{
			m_bCleanUpInProgress = true;
			//close out all NCs
			try { _destroyNC( m_objNetConnection1 ); m_objNetConnection1 = null; } catch (e:Error){ }
			try { _destroyNC( m_objNetConnection2 ); m_objNetConnection2 = null; } catch (e:Error){ }
			try { _destroyNC( m_objNetConnection3 ); m_objNetConnection3 = null; } catch (e:Error){ }
		}
		private function _getIP(server:String):void{
			var req:URLRequest = new URLRequest( "http://"+ server + "/fcs/ident/" );
			var loader:URLLoader = new URLLoader(  );
			loader.addEventListener(Event.COMPLETE, _getIPComplete, false, 0 ,true);
			loader.load(req);
			
		}
		private function _getIPComplete(e:Event):void{ 
			var xml:XML = new XML( e.target.data );
			m_FMS.uri = xml.ip; 
			m_FMS.ipLookupComplete = true;
			connect();
		}
		public function getStreamLength():void
		{
			//establish file name
			m_oConnectionDetails.file = m_oConnectionDetails.advertiser + "/" + m_oConnectionDetails.streamName + m_oConnectionDetails.profile.streamQuality;
			if ( !m_FMS.pathOnConnect ){
				m_oConnectionDetails.file = m_FMS.fixedFolderPath + m_oConnectionDetails.file;
			}
			
			//Append bandwidth allocation parameters
			m_oConnectionDetails.file += _appendQueryString();
			
			PrDebug.PrTrace("Full stream name: "+m_oConnectionDetails.file,3,"PrNetConnection");
			
			//establish responder and call for length
			var ncResponder:Responder = new Responder(responderResult, responderStatus);
			m_oConnectionDetails.NC.call("getStreamLength", ncResponder, m_oConnectionDetails.file);
		}
		
		public function onBWCheck (nPayLoad:Number) :Number{
			return ++nPayLoad;
		};
	
		public function onBWDone(nBandwidth:Number, ...rest):void{
			PrDebug.PrTrace("Bandwidth is: "+nBandwidth,4,"PrNetConnection");
			try {
				m_oConnectionDetails.profile = _determineBWProfile( nBandwidth );
			}catch (e:Error) {
				dispatchEvent(new PrNetEvent(PrNetEvent.ONBWDONE, -1));
			}
			m_oConnectionDetails.userBandwidth = nBandwidth;
			dispatchEvent(new PrNetEvent(PrNetEvent.ONBWDONE, nBandwidth));
		}
		private function _determineBWProfile( nBandwidth:Number ):Object
		{
			for( var i:int = 0; i < m_aBandwidthProfiles.length; i++)
			{
				if( nBandwidth > m_aBandwidthProfiles[i].bandwidth )
				{
					return m_aBandwidthProfiles[i];
				}
			}
			//userbandwidth is very low, return the loest quality profile
			return m_aBandwidthProfiles[m_aBandwidthProfiles.length-1];
		}
		private function onAsyncHandler(e:AsyncErrorEvent):void{
			PrDebug.PrTrace("Handle ASYNC_ERROR: "+e.error,5,"PrNetConnection");
		}
		/**
		 * Appends specific parameters to the streaming video connection path. This allows Akamai to 
		 * report on our bandwidth usage by specific campaigns
		 */
		private function _appendQueryString():String
		{
			var s:String = "";
			for (var i:String in m_aQueryParams)
			{
				PrDebug.PrTrace("Append: " + i + "=" + StateManager.URLParameters[ m_aQueryParams[i] ],5,"PrNetConnection");
				if (StateManager.URLParameters[ m_aQueryParams[i] ])
				{
					s = (s.length > 0) ? s + "&" : "?";
					s += i + "=" + String(StateManager.URLParameters[ m_aQueryParams[i] ]);
				}
			}
			return s;
		}
		private function initStatusHandler(e:NetStatusEvent):void{
			var tmp:NetConnection = e.target as NetConnection;
			tmp.removeEventListener(NetStatusEvent.NET_STATUS, initStatusHandler);
			tmp.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncHandler);
			if( !m_NCestablished){
				var statusCode:String = e.info.code;
				PrDebug.PrTrace("Connection Status: "+statusCode,5,"PrNetConnection");
				if (statusCode == "NetConnection.Connect.Success") {
					m_NCestablished = true;
					m_oConnectionDetails.NC = tmp;	
					m_oConnectionDetails.NC.addEventListener(NetStatusEvent.NET_STATUS, onStatusHandler, false, 0, true);
					m_oConnectionDetails.NC.client = this;
				}else 
				{
					//Failed Connect
					tmp.close();
					tmp = null;
					m_connectCount++;
					if( m_connectCount == 3){
						dispatchEvent(new PrNetEvent(PrNetEvent.NCFAIL) );
					}
				}
			}else{
				PrDebug.PrTrace("Close other stream",5,"PrNetConnection");
				tmp.close();
				tmp = null;
			}
		}
		private function onStatusHandler(e:NetStatusEvent):void {
			PrDebug.PrTrace(e.info.code, 5, "PrNetConnection");
			if ( e.info.code == "NetConnection.Connect.Closed" )
			{
				this.close();
			}
		}
		private function _initNC():NetConnection{
			/*Helper function to prep NCs*/
			var nc:NetConnection = new NetConnection();
			nc.client = new Object();
			//nc.objectEncoding = NetConnection.defaultObjectEncoding;
			nc.addEventListener(NetStatusEvent.NET_STATUS, initStatusHandler,false,0,true);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncHandler, false,0,true);
			return nc
		}
		private function _destroyNC(nc:NetConnection):void{
			nc.removeEventListener(NetStatusEvent.NET_STATUS, initStatusHandler);
			nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncHandler);
			nc.removeEventListener(NetStatusEvent.NET_STATUS, onStatusHandler);
			nc.close();
			nc = null;
		}
		private function responderResult(nStreamLen:Number):void{
			PrDebug.PrTrace("Stream length is: "+nStreamLen,3,"PrNetConnection");
			if (nStreamLen > 0) {
				m_oConnectionDetails.totalTime = nStreamLen;
				dispatchEvent( new PrNetEvent(PrNetEvent.NCREADY,m_oConnectionDetails) );
			} else {
				PrDebug.PrTrace("Streaming File is missing", 3, "PrNetConnection");
				close();
				dispatchEvent(new PrNetEvent(PrNetEvent.NCFAIL) );
			}
		}
		
		private function responderStatus():void{
			PrDebug.PrTrace("Responder Status function called", 5, "PrNetConnection");
		}
	}
	
}
