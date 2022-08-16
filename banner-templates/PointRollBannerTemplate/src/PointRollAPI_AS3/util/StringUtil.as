package PointRollAPI_AS3.util {
	/**
	 * Contains several helpful utilities for dealing with strings.  StringUtil is a static class, 
	 * meaning that there is no need to create an instance of the class before using its methods.
	 */
	public class StringUtil {
		/**
		 * Changes all instances of a specified pattern in a String to a desired replacement pattern.
		 * @param	string The String to be modified
		 * @param	pattern The character or group of characters to replace
		 * @param	replace The character or group of characters to insert in place of the pattern
		 * @return The modified string
		 * @includeExample ../../examples/StringUtil/StringUtil_replace.txt -noswf
		 */
		static public function replace(string:String,pattern:String,replace:String):String{
			return string.split(pattern).join(replace);
		}
		/**
		 * Removes all instances of the given patterns from a provided string.
		 * @param	string The String to be modified
		 * @param	...rest A comma separated list of Strings to be removed from the target String.
		 * @return The modified String
		 * @includeExample ../../examples/StringUtil/StringUtil_strip.txt -noswf
		 */
		public static function strip(string:String, ...rest):String{
			//strips all occurances of each additional argument passed from the original string
			for(var i:int=0;i<rest.length;i++){
				string = replace(string,rest[i],"");
			}
			return string;
		}
		/**
		 * Searches a string for a set of search criteria.
		 * @param	the_string The String to be searched
		 * @param	...rest A comma separated list of Strings to search for
		 * @return <code>true</code> only if ALL search strings are found, <code>false</code> otherwise.
		 * @includeExample ../../examples/StringUtil/StringUtil_contains.txt -noswf
		 */
		public static function contains(the_string : String, ...rest) : Boolean
		{
			// how many different strings are we checking for...
			var strings : Number = rest.length;
			
			// loop through how many we are checking for, and 
			for (var i:int=0; i<strings; i++)
			{
				if (the_string.indexOf(rest[i]) == -1)
				{
					// if the string does not contain what we asked for.
					return false;
				}
			}
			// if we get this far, then the string did contain everything we asked for...
			return true;
		}
		/**
		 * Determines if a string begins with the provided search term.
		 * @param	string The string to be searched
		 * @param	searchTerm The substring for which to search
		 * @return  <code>true</code> if the string begins with the search term, <code>false</code> otherwise.
		 */
		public static function startsWith(string:String, searchTerm:String):Boolean
		{
			return (string.indexOf(searchTerm) == 0);
		}
		/**
		 * Determines if a string ends with the provided search term.
		 * @param	string The string to be searched
		 * @param	searchTerm The substring for which to search
		 * @return  <code>true</code> if the string ends with the search term, <code>false</code> otherwise.
		 */
		public static function endsWith(string:String, searchTerm:String):Boolean
		{
			return (string.lastIndexOf(searchTerm) == string.length-searchTerm.length);
		}
		/**
		 * Inserts strings into a template.  Templates must be Strings consisting of one or more insertion fields, 
		 * denoted by "{}".  The insertion fields must contain a number, which will act as the field's index.
		 * <p>For each value provided, the insertion function will look for an insertion field to fill in.  
		 * If you supply too few arguments, the unused insertion fields will be left in place.</p>
		 * @param	original The template string to be filled in.
		 * @param	...rest A comma separated list of values to be inserted into the template.
		 * @return The template string with all applicable fields filled in.
		 * @includeExample ../../examples/StringUtil/StringUtil_insertion.txt -noswf
		 */
		public static function insertion (original : String, ...rest ) : String
		{
			//Deely method... the previous one was way too complex!
			//get a copy of the template to allow the original to be reused
			var filled:String = original.concat();
			for(var i:int=0; i< rest.length;i++){
				var test:String = "{" + i + "}";
				if ( rest[i] == null )
				{
					rest[i] = "";
				}
				filled = replace(filled,test,rest[i]);
			}
			return filled; 
		}
	}
	
}
