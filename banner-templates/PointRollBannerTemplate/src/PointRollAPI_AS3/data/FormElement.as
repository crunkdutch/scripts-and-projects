package PointRollAPI_AS3.data {
	
	/**
	 * 
	* The FormElement class stores data for an individual element in a FormData collection
	* @author Chris Deely - PointRoll
	*/
	public class FormElement {
		import PointRollAPI_AS3.data.PrForm;
		/**
		 * The name used to identify this field to the server-side script
		 */
		public var fieldName:String;
		/**
		 * The fully qualified path to the variable which supplies this value
		 */
		public var pathToValue:String;
		/**
		 * The data type of this field.  Acceptable types are dictated by the PrForm class
		 */
		public var dataType:String;
		/**
		 * If set to false, validation will fail if the current value matches the original value
		 */
		public var allowOriginalValue:Boolean;
		/**
		 * The minimum number of characters allowed in this field
		 */
		public var minimumLength:uint;
		/**
		 * The value of this field at the time of registration
		 */
		public var originalValue:String;
		/**
		 * The current value of the variable referenced by <code>pathToValue</code>.  Usually set by a call to <code>PrForm.validate()</code>
		 * @see PrForm#validate()
		 */
		public var currentValue:String;
		/**
		 * Set to <code>true</code> by <code>PrForm.validate()</code> when the validation criteria are met for this field.
		 * @see PrForm#validate()
		 */
		public var isValid:Boolean = false;
		/**
		 * A message to be displayed to the user when the field data is invalid
		 */
		public var failureMessage:String;
		
		private var m_hasSuggestion:Boolean = false;
		private var m_suggestionMessage:String;
		
		/**
		 * Creates a new FormElement object.
		 * @param fieldName The name of the parameter as defined by the script receiving the data on the server.  
		 * 			For PointRoll DataCollects, the names follow the format "F1", "F2"... "Fn"
		 * @param pathToValue A string representation of the variable name you wish to register.  This variable name will be searched for within
		 * 			the "scope" parameter you provide in the PrForm constructor.
		 * @param dataType The type of data to be submitted in this field.  The acceptable types are:
		 * <ul>			
		 * <li>	PrForm.STRING</li>
		 * <li>	PrForm.BOOLEAN</li>
		 * 	<li>PrForm.NUMBER</li>
		 * 	<li>PrForm.TEXTAREA</li>
		 * 	<li>PrForm.DATE</li>
		 * 	<li>PrForm.PHONE</li>
		 * 	<li>PrForm.ZIP</li>
		 * 	<li>PrForm.ZIPPLUS</li>
		 * 	<li>PrForm.EMAIL</li>
		 * 	<li>[a custom regular expression]</li>
		 * </ul>
		 * @param originalValue The value of this field at the time it is registered
		 * @param allowOriginalValue Setting this 
		 * 			flag to false will cause validation to fail if the user does not replace the "default" text of a field
		 * @param minimumLength You may set this value
		 * 			to the minimum length of the data field.  This setting only applies to STRING, NUMBER and TEXTAREA dataTypes
		 * @param failureMessage A message to be displayed in the event that this field fails validation
		 * @includeExample ../../examples/PrForm/FormData_FormElement.txt -noswf
		 */
		public function FormElement(fieldName:String, pathToValue:String, dataType:String, originalValue:String, allowOriginalValue:Boolean = true, minimumLength:uint = 0, failureMessage:String="Invalid Data") 
		{
			this.fieldName = fieldName;
			this.pathToValue = pathToValue;
			this.dataType = dataType;
			this.originalValue = originalValue;
			this.allowOriginalValue = allowOriginalValue;
			this.minimumLength = minimumLength;
			this.failureMessage = failureMessage;
		}
		/**
		 * <code>true</code> if a suggestion message is available for this element, <code>false</code> otherwise.
		 * @see #suggestionMessage
		 */
		public function get hasSuggestion():Boolean { return m_hasSuggestion; }
		
		/**
		 * Clears any existing suggestion message
		 * @see #suggestionMessage
		 */
		public function clearSuggestion():void
		{
			m_suggestionMessage = "";
			m_hasSuggestion = false;
		}
		/**
		 * Certain data types provide guidance for the user when the field has failed validation. If a suggestion is available for this element,
		 * the value of hasSuggestion will be true, and this property will contain the message.
		 * @see #hasSuggestion
		 */
		public function get suggestionMessage():String { return m_suggestionMessage; }
		
		public function set suggestionMessage(value:String):void {
			m_suggestionMessage = value;
			m_hasSuggestion = true;
		}
	}
	
}