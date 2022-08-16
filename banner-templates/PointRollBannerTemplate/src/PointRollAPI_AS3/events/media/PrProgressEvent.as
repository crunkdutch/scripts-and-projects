package PointRollAPI_AS3.events.media 
{
	import PointRollAPI_AS3.media.IProgressTrackable;

	import flash.events.Event;

	/**
	 * Events related to media playback progress.  These events can be easily used to generate progress bars or other design elements 
	 * that respond to media progress.
	 * @author Chris Deely - PointRoll
	 */
	public class PrProgressEvent extends Event {
		/**Event dispatched as CuePoints are encountered during FLV playback
		 * @eventType onCuePoint
		 */
		public static const ONCUEPOINT:String = "onCuePoint";
		/**Event dispatched continually to update the creative on the status of the media playback
		 * @eventType progress
		 * @includeExample ../../../examples/media/events/progress.txt -noswf
		 */
		public static const PROGRESS:String = "Progress";
		/**Event dispatched as optional milestones are reached during media playback
		 * @eventType onOptionalMilestone
		 * @includeExample ../../../examples/media/PrVideo_optionalMilestones.txt -noswf
		 */
		public static const OPTIONAL_MILESTONE:String = "OPTIONAL_MILESTONE";
		
		/** @copy PointRollAPI_AS3.media.IMediaController#currentTime */
		public var currentTime:Number;
		/** @copy PointRollAPI_AS3.media.IMediaController#totalTime */
		public var totalTime:Number;
		/** What percentage of the media has been played thus far (scale of 0-1).
		 * @includeExample ../../../examples/media/events/progress.txt -noswf
		 * */
		public var percentPlayed:Number;
		/** @copy PointRollAPI_AS3.media.IMediaController#bytesLoaded */
		public var bytesLoaded:Number;
		/** @copy PointRollAPI_AS3.media.IMediaController#bytesTotal */
		public var bytesTotal:Number;
		/** What percentage of the media has been downloaded thus far (scale of 0-1).*/
		public var percentLoaded:Number;
		/** Contains data related to the current video cuepoint.  This object contains the following properties: <br/>
		 * <table><th><td>Property</td><td>Description</td></th>
		 * <tr><td>name</td><td>The name given to the cue point when it was embedded in the video file.</td></tr>
		 * <tr><td>parameters</td><td>A associative array of name/value pair strings specified for this cue point. Any valid string can be used for the parameter name or value. </td></tr>
		 * <tr><td>time</td><td>The time in seconds at which the cue point occurred in the video file during playback. </td></tr>
		 * <tr><td>type</td><td>The type of cue point that was reached, either navigation or event. </td></tr>
		 * </table>
		 * @includeExample ../../../examples/media/events/onCuePoint.txt -noswf
		 * */
		public var cuePoint:Object;
		/**
		 * The value of the current standard playback milestone: 25, 50, 75 or 100 percent complete.
		 */
		public var milestone:Number;
		/**
		 * The value, in seconds, of the current optionalMilestone.  This value will be -1 if an optional milestone has not been reached.
		 * @includeExample ../../../examples/media/PrVideo_optionalMilestones.txt -noswf
		 */
		public var optionalMilestone:Number;
		
		private var myTarget:IProgressTrackable;
		
		/** @private */
		public function PrProgressEvent(type:String) 
		{
			super(type);
		}
		/** @private */
		public function setTarget( target:IProgressTrackable ):void
		{
			myTarget = target;
			currentTime = target.currentTime;
			totalTime =  target.totalTime;
			percentPlayed =  target.currentTime / target.totalTime;
			bytesLoaded =  target.bytesLoaded;
			bytesTotal =  target.bytesTotal;
			percentLoaded =  target.bytesLoaded / target.bytesTotal;
		}
		/** @private */
		public override function clone():Event
		{
			var e:PrProgressEvent = new PrProgressEvent(type);
			e.setTarget(myTarget);
			e.milestone = this.milestone;
			e.cuePoint = this.cuePoint;
			e.optionalMilestone = this.optionalMilestone;
			return e;
		}
		/** @private */
		public override function toString():String{
			return formatToString("PrProgressEvent", "type", "bubbles", "cancelable", "eventPhase", "currentTime", "totalTime", "percentPlayed", "bytesLoaded", "bytesTotal", "percentLoaded","milestone", "cuePoint", "optionalMilestone");
		}
		
	}
	
}