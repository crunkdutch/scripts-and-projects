/**
* Controls delivery of Progressive video
* @author Chris Deely - PointRoll
* @version 1.0
*/

package PointRollAPI_AS3.media.delivery 
{
	import PointRollAPI_AS3.events.net.*;
	import PointRollAPI_AS3.util.debug.PrDebug;
	import PointRollAPI_AS3.util.domain.Domain;

	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/** @private */
	public class ProgressiveVideo extends EventDispatcher implements IVideoDelivery{
		// Event MetaData
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.NSREADY
		 */
		[Event(name = "netStreamReady", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		
		private var m_oNC:NetConnection;
		private var m_oNS:NetStream;
		private var m_sFilePath:String;
		private var m_sBaseURL:String;
		private var m_sBasePath:String = "/PointRoll/media/videos/";
		/**
		 * Determines the progressive video path based on the advertiser and file names and prepares the NetConnection and NetStream objects.
		 * @param	advertiser Name of the advertiser
		 * @param	progressiveFile Name of the video file to play
		 */
		public function ProgressiveVideo( advertiser:String, progressiveFile:String, useHD:Boolean = false ){
			m_oNC = new NetConnection();
			m_oNC.connect(null);
			m_oNS = new NetStream(m_oNC);
			
			var Advertiser:String = advertiser;
			var File:String = progressiveFile;
			var reg:RegExp = /(\.\w{3,4})$/;
			//pull videos from the current ad domain, unless the unit is being tested locally
			m_sBaseURL = (Domain.domain.indexOf("file:") > -1) ? "http://media.pointroll.com" : Domain.domain;
			
			if( reg.test(File) )
			{
				//absolute path to file
				PrDebug.PrTrace("Full Video URL provided: "+File,3,"ProgressiveVideo");
				m_sFilePath = File;
				return
			}else if ( File.indexOf("/") == 0 ) {
				//relative path off of media domain
				m_sFilePath = m_sBaseURL + File+"_8";
			}else{
				m_sFilePath = m_sBaseURL + m_sBasePath + Advertiser+"/"+File+"_8";
			}
			//should we use an HD file?
			if ( useHD )
			{
				m_sFilePath += "_hd.flv";
			}else
			{
				m_sFilePath += "_700k.flv";
			}
			PrDebug.PrTrace("Video URL: "+m_sFilePath,3,"ProgressiveVideo");
		}
		/**
		 * Initializes the progressive video connection.
		 * @see #event:netStreamReady
		 */
		public function init():void
		{
			var dataObj:Object = {
				NC: m_oNC,
				NS: m_oNS,
				file: m_sFilePath
			}
			dispatchEvent( new PrNetEvent(PrNetEvent.NSREADY, dataObj) );
		}
		public function cleanUp():void
		{
			try
			{
				m_oNS.close();
				m_oNS = null;
			}catch(e:Error){}
			try
			{
				m_oNC.close();
				m_oNC = null;
			}catch(e:Error){}
		}
	}
	
}
