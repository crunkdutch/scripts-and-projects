package PointRollAPI_AS3.mapping 
{
	import flash.display.*;

	/**
	* When creating a linkage identifier for a movie clip to use as an info window, the Base Class must be set to this class ("PointRollAPI_AS3.mapping.PrInfoWindow"). 
	* For more information on the use of info windows, refer to the <code>PrMap.infoWindowRenderer</code> property.
	* @author Chris Deely - PointRoll
	* @see PrMap#infoWindowRenderer
	*/
	public class PrInfoWindow extends MovieClip
	{
		public var dataObject:Object;
		public var marker:PrMarker;
		public function PrInfoWindow(data:Object=null) 
		{
			dataObject = data;
		}
		
		/**
		 * @see PrMap#hideInfoWindow()
		 */
		public function hideInfoWindow():void
		{
			marker.closeInfoWindow();
		}
	}
	
}