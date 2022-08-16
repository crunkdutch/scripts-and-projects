package PointRollAPI_AS3.util.debug{
	/**
	* Debuging class - controls display of trace statements based on the current <code>debugLevel</code>.  
	* PrDebug is a static class, meaning that there is no need to create an instance of PrDebug.  Rather, the 
	* designer may simply execute the functions of the class directly.
	* @author Chris Deely
	* @version 1.0
	*/
	public class PrDebug
	{
		/**
		 * The current level of verbosity, ranging from 1-5, with 5 being the most verbose.  
		 * Adjusting this value will increase or decrease the amount of trace statements displayed by the API.
		 * @includeExample ../../../examples/PrDebug/PrDebug_debugLevel.txt -noswf
		 */
		static public var debugLevel:uint = 3;
		
		/**
		 * If a TextArea has been targeted for debug output, this setting determines whether or not the text is automatically
		 *  scrolled to show the most recent trace statement.
		 */
		static public var autoScroll:Boolean = true;
		
		/**
		 * The filter string will reduce trace statements to ones that contain the provided String value.
		 */
		static public var filter:String ="";
		
		static private var _textArea:Object;
		/** Static function to execute trace statements based on the current verbosity level
		*  @param s String to display in the Output panel
		*  @param verbosity Minimum verbosity level at which to display the statement ( 1..5 )
		*  @param traceName Optional identifier to aid in locating the source of the statement when debugging
		* @includeExample ../../../examples/PrDebug/PrDebug_PrTrace.txt -noswf
		*/
		static public function PrTrace(s:String,verbosity:uint=1,traceName:String="PR"):void{
			var output:String = traceName + ":> " + s;
			if( debugLevel >= verbosity){
				if (filter.length > 0)
				{
					if ( output.indexOf(filter) == -1 )
					{
						return;
					}
				}
				trace(output);
				if (_textArea)
				{
					_textArea.text += "\n" + output;
					if ( autoScroll )
					{
						//wrap the auto scrolling in a try/catch in case they're using something other than a TextArea
						try
						{
							_textArea.verticalScrollPosition = _textArea.maxVerticalScrollPosition;
						}catch(e:Error){}
					}
				}
			}
		}
		
		
		/**
		 * Sets a reference to a TextArea where trace statements will be output.  The object passed here must at 
		 * minimum have a "text" property that can be set to a String value.
		 */
		static public function set targetTextArea(target:Object):void
		{
			try
			{
				target.text += "PrDebug Initialized";
			}catch (e:Error)
			{
				throw(new ArgumentError("targetTextArea must be set to a TextArea instance, or other object with a public 'text' property."));
			}
			_textArea = target;
		}
	}
}