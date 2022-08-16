package PointRollAPI_AS3.events.media 
{
	import flash.events.Event;

	/**
	 * Events related to media playback.  These events are broadcast by classes in the "media" package to provide the designer with notification 
	* about user actions (pause, play, restart) as well as media status (buffer empty, buffer full, complete)
	* @author Chris Deely - PointRoll
	* @version 1.0
	* @see PointRollAPI_AS3.media.PrVideo
	* @see PointRollAPI_AS3.media.PrAudio
	*/
	public class PrMediaEvent extends Event{
		
		/** Event dispatched when media playback starts
		 * @eventType start
		 * @includeExample ../../../examples/media/events/start.txt -noswf
		 */
		public static const START:String = "Start";
		/**Event dispatched when the play command is issued
		 * @eventType play
		 * @includeExample ../../../examples/media/events/play_pause.txt -noswf
		 */
		public static const PLAY:String = "PLAY";
		/**Event dispatched when the pause command is issued
		 * @eventType pause
		 * @includeExample ../../../examples/media/events/play_pause.txt -noswf
		 */
		public static const PAUSE:String = "PAUSE";
		/**Event dispatched when the stop command is issued
		 * @eventType stop
		 * @includeExample ../../../examples/media/events/stop_restart.txt -noswf
		 */
		public static const STOP:String = "STOP";
		/**Event dispatched when the media is replayed
		 * @eventType replay
		 */
		public static const REPLAY:String = "REPLAY";
		/**Event dispatched when the media is restarted
		 * @eventType restart
		 * @includeExample ../../../examples/media/events/stop_restart.txt -noswf
		 */
		public static const RESTART:String = "RESTART";
		/**Event dispatched when the volume is turned on
		 * @eventType unmute
		 * @includeExample ../../../examples/media/events/fade_volume.txt -noswf
		 */
		public static const UNMUTE:String = "UNMUTE";
		/**Event dispatched when the volume is turned off
		 * @eventType mute
		 * @includeExample ../../../examples/media/events/fade_volume.txt -noswf
		 */
		public static const MUTE:String = "MUTE";
		/**Event dispatched when the volume has been completely faded in or out.
		 * @eventType fadeComplete
		 * @includeExample ../../../examples/media/events/fade_volume.txt -noswf
		 */
		public static const FADE_COMPLETE:String = "FADE COMPLETE";
		/**Event dispatched each time the volume is incrementally faded.
		 * @eventType fadeStep
		 * @includeExample ../../../examples/media/events/fade_volume.txt -noswf
		 */
		public static const FADE_STEP:String = "FADE_STEP";
		/**Event dispatched when the media buffer is empty
		 * @eventType bufferEmpty
		 * @includeExample ../../../examples/media/events/bufferFull_bufferEmpty.txt -noswf
		 */
		public static const BUFFER_EMPTY:String = "BUFFER_EMPTY";
		/**Event dispatched when the media buffer is filled
		 * @eventType bufferFull
		 * @includeExample ../../../examples/media/events/bufferFull_bufferEmpty.txt -noswf
		 */
		public static const BUFFER_FULL:String = "BUFFER_FULL";
		/**Event dispatched when the media object is killed
		 * @eventType onKill
		 * @includeExample ../../../examples/media/PrVideo_killVideo.txt -noswf
		 */
		public static const ONKILL:String = "onKill";
		/**Event dispatched when the playback is complete
		 * @eventType complete
		 * @includeExample ../../../examples/media/events/complete.txt -noswf
		 */
		public static const COMPLETE:String = "Complete";
		/**Event dispatched when media playback fails
		 * @eventType failure
		 * @includeExample ../../../examples/media/PrVideo_timeOutDuration.txt -noswf
		 */
		public static const FAILURE:String = "FAILURE";
		/**Event dispatched when the playback is cancelled due to low bandwidth on the user's connection
		 * @eventType lowBandwidth
		 * @includeExample ../../../examples/media/events/lowBandwidth.txt -noswf
		 */
		public static const LOW_BANDWIDTH:String = "onLowBandwidth";
		
		/**Event dispatched as MetaData is read from an FLV
		 * @eventType metaData
		 * @includeExample ../../../examples/media/PrVideo_metaData.txt -noswf
		 */
		public static const ONMETADATA:String = "ONMETADATA";
		
		/**Event dispatched as XMPData is read from an FLV.  This functionality is new in Flash Player 10.
		 * @eventType xmpData
		 */
		public static const ONXMPDATA:String = "ONXMPDATA";
		
		/** @private */
		public function PrMediaEvent(type:String){
			super(type);
		}
		/** @private */
		public override function clone():Event{
			return new PrMediaEvent(type);
		}
		/** @private */
		public override function toString():String{
			return formatToString("PrMediaEvent","type","bubbles","cancelable", "eventPhase");
		}
	}
	
}
