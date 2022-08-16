package PointRollAPI_AS3.media 
{
	
	/**
	* Constants representing HD Video Delivery options.  There are 3 possible delivery options: Never, If Available, and Always.  
	* The default setting is Never, as most campaigns do not include HD video.  In situations where HD video is desired, the "If Available" 
	* setting should be used.<br/>The "If Available" setting will test the user's bandwidth to see if they meet the required minimum to deliver 
	* streaming HD video.  If the user's connection is too slow, they will automatically be downgraded to standard definition video streaming.
	* <p>The final setting, "Always", will force the delivery of progressive HD video in the cases where the user's connection does not support 
	* HD streaming.</p>
	* @author Chris Deely - PointRoll
	*/
	public class HDDelivery 
	{
		/**
		 * HD Video is not available for this creative; the default setting.
		 */
		public static const NEVER:uint = 0;
		/**
		 * An HD Video is available for streaming and/or progressive delivery; only deliver HD Video if the user has an 
		 * acceptable internet connection.
		 */
		public static const IF_AVAILABLE:uint = 1;
		/**
		 * This setting will force HD Video to be delivered even if the user does not meet the internet connection bandwidth requirements.
		 * This setting is NOT recommended unless the user explicitly requests an HD video, usually via a "Watch in HD" button.
		 */
		public static const ALWAYS:uint = 2;
		
		/** @private Used to indicate a fail over, and override prVidHD. */
		public static const FAIL:uint = 3;
		/** @private Minimum bandwidth for Streaming HD */
		public static const MINBANDWIDTH:uint = 2500;
	}
	
}