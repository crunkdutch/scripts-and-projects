package com.pointrollHelper
{
	import PointRollAPI_AS3.media.PrVideo;	
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import com.pointrollHelper.PrVideoData;	
	import com.pointrollHelper.PointRollPanel;
	import flash.media.Video;
	/**
	 * @author jdutcher
	 */
	public class PointRollVideoPanel extends PointRollPanel 
	{
		protected var prVideo : PrVideo;
		protected var prVideoTarget : Video; //video object that will house the pointroll video. must be instantiated...
		//...(& added to the display) before calling initPrVideo();
		//properties used by the PrVideo constructor - these are unique to the pointroll campaign, not to individual banners.
		protected var prVideoAdFolder : String = "Hallmark"; //default value is for reference only.
		protected var prVideoFilePath : String = "/PointRoll/media/videos/Hallmark/"; //default value is for reference only.
		//default volume level. makes for easily nerfing or enhancing the volume level for the pr video playback.
		protected var volumeDefault : Number = 1;
		protected var currentPrVideoData : PrVideoData;

		public function PointRollVideoPanel () 
		{
			super( );
		}

		/**
		 * (re)inits the pointroll video class.
		 * @param prVideoData - the PrVideoData object that contains the unique props of the video we want to play. 
		 */
		protected function initPrVideo (prVideoData : PrVideoData) : void 
		{
			trace( "::initPrVideo:" + prVideoData.baseName + "::" );
			currentPrVideoData = prVideoData;
			if (prVideo != null) 
			{
				prVideo.killVideo( );
				prVideo = null;
			}
			
			prVideo = new PrVideo( prVideoAdFolder, prVideoFilePath + prVideoData.baseName, prVideoData.baseName, prVideoData.duration, prVideoTarget, volumeDefault, prVideoData.instanceNumber, 0 );
			
			prVideo.trackProgress = 4;//4 will track optional milestones, start, 25/50/75% completion, and complete.
			prVideo.addEventListener( PrMediaEvent.START, onPrVideoStart );
		}

		/**
		 * event handler for the PrMediaEvent.START event dispatched by our PrVideo object.
		 * removes the triggering PrMediaEvent.START listener.
		 * adds the PrMediaEvent.COMPLETE and (if uncommented) PrProgressEvent.OPTIONAL_MILESTONE listener(s)
		 */
		protected function onPrVideoStart (evt : PrMediaEvent) : void 
		{
			trace( "::onPrVideoStart::" );
			prVideo.removeEventListener( PrMediaEvent.START, onPrVideoStart );
			prVideo.addEventListener( PrMediaEvent.COMPLETE, onPrVideoComplete );
//			//commented out to save precious bytes!
//			prVideo.addEventListener(PrProgressEvent.OPTIONAL_MILESTONE, onPrVideoMilestone);
//			prVideo.optionalMilestones = [5, 10];
		}

		///**
		// * event handler for the PrProgressEvent.OPTIONAL_MILESTONE event(s) dispatched by our PrVideo object.
		// * should remove the triggering PrProgressEvent.OPTIONAL_MILESTONE listener on the last milestone.
		// */
		//		//commented out to save precious bytes!
		//		protected function onPrVideoMilestone(evt:PrProgressEvent):void{
		//			trace("::onPrVideoMilestone:"+evt.optionalMilestone+"::");
		//			switch(evt.optionalMilestone){
		//				//milestone(s)
		//				case [time in seconds]: //pseudo code!
		//				//actions for milestone 1
		//				break;
		//				default:
		//				//last milesetone	
		//				prVideo.removeEventListener(PrProgressEvent.OPTIONAL_MILESTONE, onPrVideoMilestone);
		//			}
		//		}
		/**
		 * event handler for the PrMediaEvent.COMPLETE event dispatched by our PrVideo object.
		 * removes the triggering PrMediaEvent.COMPLETE listener.
		 */
		protected function onPrVideoComplete (evt : PrMediaEvent) : void 
		{
			trace( "::introComplete::" );
			prVideo.removeEventListener( PrMediaEvent.COMPLETE, onPrVideoComplete );
		}

		/**
		 * kills the panel. If we have an instantiated prVideo object, we call its killVideo method first.
		 */
		override protected function killPanel () : void 
		{
			trace( "::killPanel::" );
			//we need to always kill the video object before closing the panel.
			//this helps to prevent browser hangs when closing the panel, esp. in FF2 & IE.
			if(prVideo) 
			{
				prVideo.killVideo( );
			}
			pr.close( );
		}
	}
}
