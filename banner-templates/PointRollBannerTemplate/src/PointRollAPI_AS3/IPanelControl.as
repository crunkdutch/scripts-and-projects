/**
* ...
* @author Chris Deely - PointRoll
* @version 0.1
*/

package PointRollAPI_AS3{
/**
 * @private
 */
	public interface IPanelControl  {
		function close():void
		function openPanel(n:int):void
		function goPanel(n:int, auto:Object=undefined):void
		function pin():void
		function unPin():void
		function delayedPin(a:int=undefined):void
		function pushDown(t:Number,y:Number):void
		function reveal(w:Number,h:Number,x:Number=0,y:Number=0,track:Number=1):void
		function unReveal(w:Number,h:Number,x:Number=0,y:Number=0,track:Number=0):void
	}
	
}