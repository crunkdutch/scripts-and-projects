

package PointRollAPI_AS3.media 
{
	import flash.events.IEventDispatcher;

	/**
	 * @private
* @author Chris Deely - PointRoll
*/
	public interface IProgressTrackable extends IEventDispatcher{
		function get currentTime():Number
		function get totalTime():Number
		function get bytesLoaded():uint
		function get bytesTotal():uint
	}
	
}
