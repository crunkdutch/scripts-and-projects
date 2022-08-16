package PointRollAPI_AS3.util.domain
{
	import PointRollAPI_AS3.StateManager;

	/**
	 * Provides access to information about the ad's current domain.
	* @author Chris Deely - PointRoll
	* @version 1.0
	*/
	public class Domain {
		/** @private */
		public function Domain() {	}
		/**
		 * The absolute path of the creative SWF.  This property is used to properly load sub-SWFs from the current AdPortal panel space.
		 * @includeExample ../../../examples/Domain/Domain_absolutePath.txt -noswf
		 */
		static public function get absolutePath():String
		{
			//Check for presence of URLParameters.prAbsPath
			if(typeof(StateManager.URLParameters.prAbsPath) != "undefined")
			{
				return StateManager.URLParameters.prAbsPath;
			}
			else
			{
				var url:String = StateManager.root.loaderInfo.url;
				var prPath:String = url.substr(0, (url.indexOf(".swf") + 4));
				var prPathEnd:Number = prPath.lastIndexOf("/")+1;
				var prAbsURL:String = prPath.substr(0, prPathEnd);
				//In AS3 the ad's url get added to the end of the 'wrapper' swf url, this code strips the wrapper url
				if ( prAbsURL.indexOf("[[IMPORT]]/") > -1)
				{
					var pieces:Array = prAbsURL.split("[[IMPORT]]/");
					prAbsURL = "http://" + pieces[1];
				}
				return prAbsURL;
			}
		}
		/**
		 * The domain of the current SWF, in the format "http://speed.pointroll.com"
		 * @see #absolutePath
		 */
		static public function get domain():String
		{
			//Get Full Path
			var url:String = Domain.absolutePath;
			var slashCount:uint = 0;
			var curIndex:uint = 0;
			while(slashCount < 3)
			{
				curIndex = url.indexOf("/",curIndex+1);
				slashCount++;
			}
			return url.substring(0,curIndex);
		}
		
	}
}