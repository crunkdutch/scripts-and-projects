/**
* @private
* @author Default
* @version 0.1
*/

package PointRollAPI_AS3.media.delivery 
{
	import flash.events.IEventDispatcher;

	/** @private */
	public interface IVideoDelivery extends IEventDispatcher{
		function init():void
		function cleanUp():void
	}
	
}
