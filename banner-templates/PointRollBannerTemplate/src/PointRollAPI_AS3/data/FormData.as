package PointRollAPI_AS3.data 
{
	import flash.net.URLVariables;

	/**
	 * 
	* The FormData Class is used by the PrForm class to store user-supplied data for submission to a server-side script.  
	* This class should not be implemented directly, but is listed for completeness.
	* @author Chris Deely - PointRoll
	*/
	public class FormData {
		private var m_aItemArray:Array = new Array();
		private var m_oLookupByName:Object = new Object();
		/**
		 * Creates a new FormData collection.
		 * @includeExample ../../examples/PrForm/FormData_FormElement.txt -noswf
		 */
		public function FormData() {}
		/**
		 * The number of data fields currently stored in the FormData Object
		 */
		public function get numItems():uint
		{
			return m_aItemArray.length;
		}
		/**
		 * Returns a FormElement object based on a numerical field index
		 * @param	n The index number of the field to be retrieved
		 * @return The appropriate FormElement object
		 * @see FormElement
		 */
		public function getItemByIndex( n:uint ):FormElement
		{
			return m_aItemArray[n];
		}
		/**
		 * Returns a FormElement object based on the name used to register the field
		 * @param	name The name of the field to be retrieved
		 * @return The appropriate FormElement object
		 * @see FormElement
		 * @includeExample ../../examples/PrForm/FormData_FormElement.txt -noswf
		 */
		public function getItemByName( name:String ):FormElement
		{
			return m_aItemArray[ m_oLookupByName[ name ] ]
		}
		/**
		 * Returns an Array containing all FormElements currently registered to the FormData object
		 * @return
		 */
		public function getElementArray():Array
		{
			return m_aItemArray;
		}
		/**
		 * Returns all FormElements in the form of a URLVariables object
		 * @return a URLVariables object which may be used to submit the data to a server-side script
		 * @see flash.net.URLVariables
		 */
		public function getURLVars():URLVariables
		{
			var u:URLVariables = new URLVariables();
			for (var i:uint = 0; i < numItems; i++)
			{
				var tmp:FormElement = getItemByIndex(i);
				u[ tmp.fieldName ] = tmp.currentValue;
			}
			return u
		}
		/**
		 * Adds a new field to the FormData object
		 * @param	fieldName The name used to identify this field to the server-side script
		 * @param	pathToValue The fully qualified path to the variable to store
		 * @param	dataType The data type of this field
		 * @param	originalValue The value of this field at the time of registration
		 * @param	allowOriginalValue If set to false, validation will fail if the current value matches the original value
		 * @param	minimumLength The minimum number of characters allowed in this field
		 * @return true if the field is successfully registered, false if the same fieldName is already in use
		 * @see PrForm#registerField()
		 */
		public function addNewItem( fieldName:String, pathToValue:String, dataType:String, originalValue:String, allowOriginalValue:Boolean = true, minimumLength:uint = 0, failureMessage:String="Invalid Data"):Boolean
		{
			if ( itemExists( fieldName ) )
			{
				return false
			}else {
				var element:FormElement = new FormElement(fieldName, pathToValue, dataType, originalValue, allowOriginalValue, minimumLength, failureMessage);
				m_aItemArray.push(element);
				//store the index value for lookup by name
				m_oLookupByName[ fieldName ] = m_aItemArray.length - 1;
				return true
			}
		}
		/**
		 * Removes an item from the FormData object
		 * @param	name The name of the item to be removed
		 * @return true if the field was removed, false if the fieldName was not found
		 */
		public function removeItem( name:String ):Boolean
		{
			if ( !itemExists(name) )
			{
				return false
			}else {
				m_aItemArray[ m_oLookupByName[name] ] = null;
				m_aItemArray.splice( m_oLookupByName[name], 1 );
				m_oLookupByName[name] = null;
				delete m_oLookupByName[name];
				return true;
			}
		}
		/**
		 * Verifies that a field exists in the FormData object
		 * @param	name The name of the field to search for
		 * @return true if the field exists, false otherwise
		 */
		public function itemExists( name:String ):Boolean
		{
			if ( m_oLookupByName[ name ] == null)
			{
				return false
			}else {
				return true
			}
		}
	}
	
}