

package PointRollAPI_AS3.media {
/**
* Interface implemented by all PointRoll Media Playback Objects
* @author Chris Deely - PointRoll
*/
	public interface IMediaController {
		/**
		 * Resumes the media from a paused or stopped position
		 */
		function play():void
		/**
		 * Pauses media playback
		 */
		function pause():void
		/**
		 * Pauses media playback and returns the playhead to 0
		 */
		function stop():void
		/**
		 * Seeks the media playhead to the specified location within the file
		 * @param	n Playback position to seek to, in seconds
		 * @includeExample ../../examples/media/PrVideo_seek.txt -noswf
		 */
		function seek(n:Number):void
		/**
		 * Replays the media from the beginning after it has been played completely. 
		 * Using this method will register as a new viewing in the metrics.  All playback milestones will be recorded 
		 * again as the video progresses.
		 * 
		 * This method will also create a new server connection and recheck the user's bandwidth as necessary.
		 */
		function replay():void
		/**
		 * Restarts the media from the beginning, without registering it as a new playback.  This method is analagous to a "rewind" action.  
		 * Restarting the media is counted as part of the same viewing, so any playback milestones that have already been passed, will be ignored the 
		 * second time through.
		 * @param	withSound Set this value to <code>true</code> to restart the media with the volume turned on.
		 */
		function restart(withSound:Boolean = false):void
		/**
		 * Resets optional milestones such that they will be triggered again as they are passed.  
		 * This is useful if optional milestones need to be triggered after <code>restart()</code> calls.  As a restart is treated as part 
		 * of the same playback, optional milestones are usually not fired again the second time around.
		 * 
		 * In order to cause the standard video progress activities fire again, you must use the <code>replay()</code> function.
		 */
		function resetOptionalMilestones():void
		/**
		 * Fades the volume to the specified level over a period of time
		 * @param	newVolume  The desired volume to reach
		 * @param	seconds The number of seconds over which to fade the volume
		 */
		function fadeVolume(newVolume:Number, seconds:Number):void;
		/**
		 * Returns the current playback position of the media being played
		 * @includeExample ../../examples/media/events/complete.txt -noswf
		 */
		function get currentTime():Number
		/**
		 * Returns the total time of the media
		 * @includeExample ../../examples/media/events/complete.txt -noswf
		 */
		function get totalTime():Number
		/**
		 * Returns the number of bytes that have been downloaded thus far.
		 * @includeExample ../../examples/media/PrAudio_bytesLoaded.txt -noswf
		 */
		function get bytesLoaded():uint
		/**
		 * Returns the total number of bytes in the media file. This value will initially return 0, until the download initiates.
		 * @includeExample ../../examples/media/PrAudio_bytesLoaded.txt -noswf
		 */
		function get bytesTotal():uint
		/**
		 * Sets the volume level (range 0-1)
		 */
		function get volume():Number;
		function set volume(volume:Number):void;
		/**
		 * An array of playback points at which to dispatch an onOptionalMilestone event.
		 * 
		 * Often times when developing an application or creative piece, you will want to tie specific animation, 
		 * sounds or both to particular time points within media playback. While this can be achieved utilizing cuePoints, 
		 * we have provided an accurate code based solution as well. 
		 * 
		 * The <code>optionalMilestones</code> property allows for the developer/creative designer to pass in an array of 
		 * "time events" they wish to listen for. This proves extremely useful as you begin to tie animation to synced events 
		 * within the media, as well as to create complex interactive video executions such as relational hot spotting or choose your own adventure. 
		 * @includeExample ../../examples/media/PrVideo_optionalMilestones.txt -noswf
		 */
		function get optionalMilestones():Array
		function set optionalMilestones( a:Array ):void
	}
	
}
