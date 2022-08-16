package PointRollAPI_AS3.errors {
	
	/**
	* Class representing all errors thrown by all objects in the PointRoll API
	* @author Chris Deely - PointRoll
	*/
	public class PrError extends Error {
		
		/** Thrown when attempting to register an undefined or null value to a PrForm 
		 * @see PointRollAPI_AS3.data.PrForm#registerField()
		 */
		public static const VAR_NOT_FOUND:String = "variable cannot be located in the scope provided"
		/** Thrown when attempting to register a duplicate field name to a PrForm
		 * @see PointRollAPI_AS3.data.PrForm#registerField()
		 */
		public static const DUPLICATE_FIELD:String = "Duplicate Field will not be registered."
		
		/** Thrown when attempting to seek beyond the limits of a media file 
		 * @see PointRollAPI_AS3.media.PrAudio#seek()
		 */
		public static const SEEK_ERROR:String = "Cannot seek beyond limits of file"
		/** Thrown when completeAt property is beyond the limits of a media file 
		 * @see PointRollAPI_AS3.media.PrVideo#completeAt
		 * @see PointRollAPI_AS3.media.PrAudio#completeAt
		 */
		public static const COMPLETE_AT:String = "completeAt property may not be larger than the total time"
		/** Thrown when an invalid delivery type is used in the PrVideo Class 
		 * @see PointRollAPI_AS3.media.PrVideo#startVideo()
		 */
		public static const INVALID_DELIVERY:String = "Invalid Video Delivery Type"
		
		/** Thrown when a function call is not permitted from the current platform state 
		 * @see PointRollAPI_AS3.net.URLHandler#beacon()
		 */
		public static const NOT_ALLOWED_FROM_STATE:String = "This function is not permitted this platform state"
		/** Thrown when a designer attempts to directly instantiate a singleton object 
		 * @see PointRollAPI_AS3.PointRoll#getInstance()
		 */
		public static const SINGLETON:String = "You may not create this object using the 'new' keyword.  Please use the getInstance() method"
		
		/** Thrown when the ad environment is not recognized */
		public static const BAD_CONFIGURATION:String = "Missing activity configuration data"
		
		/** Thrown when a service provider is not recognized */
		public static const UNKNOWN_PROVIDER:String = "service provider is not recognized"
		
		
		/**
		 * @private
		 * @param	type The String describing this error
		 */
		public function PrError(type:String) 
		{
			super(type)
		}
		
	}
	
}