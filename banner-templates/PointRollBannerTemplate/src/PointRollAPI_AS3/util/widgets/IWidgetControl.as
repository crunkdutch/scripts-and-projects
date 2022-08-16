package PointRollAPI_AS3.util.widgets 
{
	import flash.events.IEventDispatcher;

	/**
	* Interface implemented by all widget control menus.
	* @author Chris Deely - PointRoll
	*/
	public interface IWidgetControl extends IEventDispatcher {
		/**
		 * Loads the code library used to display the widget sharing menu.  
		 * This method is helpful if you need to execute advanced commands with the library before displaying the sharing menu.
		 * @param	autoDisplay If set to <code>true</code> the menu will be automatically displayed as soon as the menu is loaded.
		 * @see #libraryObject
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_loadLibrary.txt -noswf
		 */
		function loadLibrary( autoDisplay:Boolean = false ):void
		/**
		 * Displays the widget sharing menu.  If the library has not yet been loaded, this method will load it prior to displaying the menu.
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		function showMenu():void
		/**
		 * Closes the sharing menu, if it is currently open.
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_PrWidgetControl.txt -noswf
		 */
		function hideMenu():void
		/**
		 * Returns a reference to the widget provider's code library.  This is useful if you need to execute advanced commands using the 
		 * provider's platform or access specific properties of the library.
		 * <p>For full details, see the service provider's website</p>
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_loadLibrary.txt -noswf
		 */
		function get libraryObject():Object		
		/**
		 * Adds a configuration parameter to modify the look or behavior of the new widget placement.
		 * @param	name Name of the parameter (variable) to set
		 * @param	value Data to be set for this parameter
		 * @includeExample ../../../examples/PrWidgetControl/PrWidgetControl_addParameter.txt -noswf
		 */
		function addParameter( name:String, value:String ):void
		
		/**
		 * Unloads the widget library and associated content.
		 */
		function unloadMenu():void
		
		/**
		 * Determines whether or not the 
		 */
		function get inTheWild():Boolean
		
		/** The x position of the widget menu */
		function get menuX():Number
		function set menuX(x:Number):void
		
		/** The y position of the widget menu */
		function get menuY():Number
		function set menuY(y:Number):void
	}
	
}