package PointRollAPI_AS3.data 
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.events.data.PrDataEvent;
	import PointRollAPI_AS3.util.*;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @eventType PointRollAPI_AS3.events.data.PrDataEvent.SUBMIT
	 * @see PrForm#submitForm()
	 */
	[Event(name = "submit", type = "PointRollAPI_AS3.events.data.PrDataEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.data.PrDataEvent.RETURN
	 * @see PrForm#returnedData
	 */
	[Event(name = "return", type = "PointRollAPI_AS3.events.data.PrDataEvent")]
		
	/**
	* The PrForm class is used to collect user information and submit the data to a PointRoll DataCollect or a 3rd party collection server.
	* The class includes built-in validation of the submitted data.
	* @author Chris Deely - PointRoll
	* @includeExample ../../examples/PrForm/PrForm_overview.txt -noswf
	*/
	public class PrForm extends EventDispatcher {
		/** Constant used to identify a form element as a String */
		public static const STRING:String = "STRING";
		/** Constant used to identify a form element as a Boolean */
		public static const BOOLEAN:String = "BOOLEAN";
		/** Constant used to identify a form element as a Number */
		public static const NUMBER:String = "NUMBER";
		/** Constant used to identify a form element as a TextArea*/
		public static const TEXTAREA:String = "TEXTAREA";
		/** Constant used to identify a form element as a Date */
		public static const DATE:String = "DATE";
		/** Constant used to identify a form element as a Phone Number */
		public static const PHONE:String = "PHONE";
		/** Constant used to identify a form element as a US Zip Code */
		public static const ZIP:String = "ZIP";
		/** Constant used to identify a form element as a US Zip+ Code */
		public static const ZIPPLUS:String = "ZIPPLUS";
		/** Constant used to identify a form element as an Email address */
		public static const EMAIL:String = "EMAIL";
		//Phone Formats
		/** Constant used to set the <code>phoneFormat</code> property to a US number, preceded by a 1: 1-267-558-1300 
		 * @see PrForm#phoneFormat
		 */
		public static const PHONE_US1:String = "1-{0}-{1}-{2}";
		/** Constant used to set the <code>phoneFormat</code> property to a US number, with the area code in parenthesis: (267) 558-1300 
		 * @see PrForm#phoneFormat
		 */
		public static const PHONE_US:String = "({0}) {1}-{2}";
		/** Constant used to set the <code>phoneFormat</code> property to a US number, separated by periods: 267.558.1300 
		 * @see PrForm#phoneFormat
		 */
		public static const PHONE_USDOT:String = "{0}.{1}.{2}";
		/** Constant used to set the <code>phoneFormat</code> property to a US number, separated by dashes: 267-558-1300 
		 * @see PrForm#phoneFormat
		 */
		public static const PHONE_USDASH:String = "{0}-{1}-{2}";
		/** Constant used to set the <code>phoneFormat</code> property to a US number, with no additional formatting: 2675581300 
		 * @see PrForm#phoneFormat
		 */
		public static const PHONE_NONE:String = "{0}{1}{2}";
		//date formats
		/** Date format "mm/dd/yy"
		 * @see PrForm#dateFormat
		 */
		public static const DATE_US2:String = "mm/dd/yy";
		/** Date format "mm/dd/yyyy".  This is the default value of the dateFormat property
		 * @see PrForm#dateFormat
		 */
		public static const DATE_US4:String = "mm/dd/yyyy";
		/** Date format "dd/mm/yy"
		 * @see PrForm#dateFormat
		 */
		public static const DATE_EU2:String = "dd/mm/yy";
		/** Date format "dd/mm/yyyy"
		 * @see PrForm#dateFormat
		 */
		public static const DATE_EU4:String = "dd/mm/yyyy";
		
		/**
		 * A collection of default error messages which may be displayed when a field fails validation.  These messages may be overwritten as needed.
		 * The default values are:<br/>
		 * <br/>
		 * STRING:"Invalid Entry"<br/>
		 *	BOOLEAN:"No selection has been made"<br/>
		 *	NUMBER: "Please enter a valid number"<br/>
		 *	TEXTAREA:"Please enter text"<br/>
		 *	DATE:"Invalid Date"<br/>
		 *	PHONE:"Invalid Phone Number"<br/>
		 *	ZIP:"Invalid Zip"<br/>
		 *	ZIPPLUS:"Invalid Zip"<br/>
		 *	EMAIL:"Invalid Email"
		 * @see PrForm#validate()
		 */
		public var failureMessages:Object =
		{
			STRING:"Invalid Entry",
			BOOLEAN:"No selection has been made",
			NUMBER: "Please enter a valid number",
			TEXTAREA:"Please enter text",
			DATE:"Invalid Date",
			PHONE:"Invalid Phone Number",
			ZIP:"Invalid Zip",
			ZIPPLUS:"Invalid Zip",
			EMAIL:"Invalid Email"
		}
		/**
		 * The desired format for data submitted as a phone number.  This property can be set to any of the predefined formats:
		 * <code>PHONE_US1</code>, <code>PHONE_US</code>, <code>PHONE_USDOT</code>, <code>PHONE_USDASH</code>, or <code>PHONE_NONE</code>.
		 * <p>If the user supplied number is not properly formatted, the form will fail validation.</p>
		 * <p>The default is the <code>PHONE_USDASH</code> format.</p>
		 * @see PrForm#PHONE_USDASH
		 * @see PrForm#PHONE_US
		 * @see PrForm#PHONE_US1
		 * @see PrForm#PHONE_USDOT
		 * @see PrForm#PHONE_NONE
		 */
		public var phoneFormat:String = PHONE_USDASH;
		/**
		 * The PointRoll DataCollect ID.  You may obtain this value from AdPortal.
		 */
		public var collectionID:String;
		/**
		 * The desired format for date fields.  Acceptable values are:
		 * <code>PrForm.DATE_US2</code>, <code>PrForm.DATE_US4</code>, <code>PrForm.DATE_EU2</code>, and <code>PrForm.DATE_EU4</code>
		 * @see #DATE_US2
		 * @see #DATE_US4
		 * @see #DATE_EU2
		 * @see #DATE_EU4
		 */
		public var dateFormat:String = DATE_US4;
		/**
		 * The URL of the data collection script.  The default value is PointRoll's generic collection script.
		 */
		public var baseURL:String = "http://submit.pointroll.com/content/datacollect/collect.asp";
		/**
		 * The format used for data returned from the server-side script.  This property follows the settings of the <code>URLLoader</code> Class's <code>dataFormat</code> 
		 * property.
		 * 
		 * <p>If the value of the dataFormat property is <code>URLLoaderDataFormat.TEXT</code>, the received data is a string containing the text of the loaded file.</p>
		 * <p>If the value of the dataFormat property is <code>URLLoaderDataFormat.BINARY</code>, the received data is a <code>ByteArray</code> object containing the raw binary data.</p>
		 * <p>If the value of the dataFormat property is <code>URLLoaderDataFormat.VARIABLES</code>, the received data is a <code>URLVariables</code> object containing the URL-encoded variables.</p>
		 * <p>The default value is <code>URLLoaderDataFormat.TEXT</code>.</p>
		 * @see flash.net.URLLoader#dataFormat
		 */
		public var dataFormat:String = "text"
		/** The method for submitting form data, either <code>"GET"</code> or <code>"POST"</code> */
		public var submissionMethod:String = "POST"
		/**
		 * Data returned from the server-side script.  The format of this data is based on the value of the <code>dataFormat</code> property.
		 * @see PrForm#dataFormat
		 */
		public var returnedData:*;
		private var m_aFailedArray:Array;
		private var m_oScope:DisplayObject;
		private var m_oFormData:FormData;
		private var m_sCreativeID:String;
		private var m_sPlacementID:String;
		
		/**
		 * Constructs a new PrForm instance
		 * @param	scope A reference to a DisplayObject which contains all variables to be registered to this form.  
		 * 				Most often the value <code>this</code> will be supplied, refering to the main timeline where the PrForm object is being created.
		 * @param	dataCollectID [optional] If provided this value will be used as the PointRoll DataCollect ID.  You may obtain this value from AdPortal.
		 * 
		 * @includeExample ../../examples/PrForm/PrForm_PrForm.txt -noswf
		 */
		public function PrForm(scope:DisplayObject, dataCollectID:String=null) {
			if (!StateManager.root)
			{
				StateManager.setRoot(scope);
			}
			m_oScope = scope;
			collectionID = dataCollectID;
		}
		/**
			 * Registers a new field to be submitted with the form data
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
			 * @param allowOriginalValue Setting this 
			 * 			flag to false will cause validation to fail if the user does not replace the "default" text of a field
			 * @param minimumLength You may set this value
			 * 			to the minimum length of the data field.  This setting only applies to STRING, NUMBER and TEXTAREA dataTypes
			 * @return <code>true</code> if the field was successfully registered, false if the <b>fieldName</b> value is already in use or <b>pathToValue</b> does not 
			 * 			evaluate properly within the scope provided to the PrForm constructor
			 * @see #PrForm() 
			 * @see #unregisterField()
			 * @see #validate()
			 * @throws PointRollAPI_AS3.errors.PrError If <code>pathToValue</code> does not evaluate within the scope provided to the PrForm constructor, 
			 * or a duplicate field has been registered.
			 * @includeExample ../../examples/PrForm/PrForm_registerField.txt -noswf
			 * @includeExample ../../examples/PrForm/PrForm_registerField_duplicate.txt -noswf
			 * @includeExample ../../examples/PrForm/PrForm_register_textfield.txt -noswf
		*/
		public function registerField( fieldName:String, pathToValue:String, dataType:String, allowOriginalValue:Boolean=true, minimumLength:uint=0 ):Boolean
		{
			var originalValue:String;
			if ( m_oFormData == null )
			{
				m_oFormData = new FormData();
			}
			try{
				originalValue = _getValue(pathToValue);
			}catch (e:Error) {
				throw(new PrError( PrError.VAR_NOT_FOUND ));
			}
			
			var success:Boolean = m_oFormData.addNewItem(fieldName, pathToValue, dataType, originalValue, allowOriginalValue, minimumLength, failureMessages[dataType]);
			if (success) {
				PrDebug.PrTrace("Registering field " + fieldName + " with an original value of " + originalValue, 3, "PrForm");
				return true
			}else {
				throw( new PrError( PrError.DUPLICATE_FIELD ));
				return false
			}
		}
		
		
		
		/**
		 * Removes a field from the data set to be submitted
		 * @param	fieldName The name of the parameter as defined by the script receiving the data on the server.  
		 * 				For PointRoll DataCollects, the names follow the format "F1", "F2"... "Fn"
		 * @return	true if the field was found in the current data set and removed, false otherwise
		 * @includeExample ../../examples/PrForm/PrForm_unregisterField.txt -noswf
		 */
		public function unregisterField( fieldName:String ):Boolean
		{
			return m_oFormData.removeItem( fieldName );
		}
		
		/**
		 * Returns an Array of FormElement objects currently registered to the PrForm object.
		 * @return an Array of FormElement objects
		 * @see #getFormData()
		 * @see FormElement
		 */
		public function getFields():Array
		{
			return m_oFormData.getElementArray();
		}
		
		/**
		 * Returns a FormData object containing all fields currently registered to the PrForm
		 * @return a FormData object
		 * @see PointRollAPI_AS3.data.FormData FormData Class
		 * @includeExample ../../examples/PrForm/FormData_FormElement.txt -noswf
		 */
		public function getFormData():PointRollAPI_AS3.data.FormData
		{
			return m_oFormData;
		}
		/**
		 * Performs input validation on all data fields registered to the PrForm object.
		 * <p>Validation is a crucial step in the form submission process and ensures that the user has provided accurate, usable data. 
		 * It is best practice to always call the validate method prior to the <code>submitForm()</code> method.</p>
		 * <p>The table below illustrates how each type of data field will be evaluated:</p>
		 * <table border="1" cellpadding="4" cellspacing="1" bordercolor="#666666" width="100%">
		 *   <tr>
		 *     <td width="116" class="tableHead">Field Type</td>
		 *     <td width="231" class="tableHead">Validation Details</td>
		 *   </tr>
		 *   <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>Boolean</code></td>
		 *     <td bgcolor="#FFFFFF" class="content"><p>Variable must be of type <code>Boolean</code> and evaluate to <code>true</code> or <code>false</code></p></td>
		 *   </tr>
		 *   <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>String</code></td>
		 *     <td bgcolor="#FFFFFF" class="content">Variable must be of type <code>String</code>, and have a length greater than 0</td>
		 *   </tr>
		 *   <tr>    
		 * <td valign="top" bgcolor="#FFFFFF"><code>Number</code></td>
		 *     <td bgcolor="#FFFFFF" class="content">Variable must be of type <code>Number</code> or evaluate as a number (i.e. 123 and &quot;123&quot; are both valid)</td>
		 * </tr>
		 *   <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>Date</code></td>
		 *     <td bgcolor="#FFFFFF" class="content">Must adhere to the <code>dateFormat</code> property. Valid seperators are &quot;-&quot; &quot;.&quot; and &quot;/&quot; (i.e. 10-15.07 is valid)</td>
		 *   </tr>
		 *   <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>Phone</code></td>
		 *     <td bgcolor="#FFFFFF" class="content">Valid US phone number, must consist of 10 digits (plus an optional starting &quot;1&quot;). Must adhere to the selected <code>phoneFormat</code> property.</td>
		 *   </tr>
		 *   <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>Email</code></td>
		 *     <td bgcolor="#FFFFFF" class="content">Email addresses are only tested for formatting purposes, they are not guaranteed to be &quot;real.&quot; Standard email address syntax is used.</td>
		 *   </tr>
		 * <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>Zip</code></td>
		 *     <td bgcolor="#FFFFFF" class="content">5 digits are required</td>
		 * </tr>
		 *   <tr>
		 *     <td valign="top" bgcolor="#FFFFFF"><code>Zip+</code></td>
		 *     <td bgcolor="#FFFFFF" class="content"><p>Accepts three formats:</p>
		 *     <ul><li>5 digits (19448)</li><li>9 digits (194481234)</li><li>5 digits-4 digits (19448-1234)</li></ul>
		 *     <p>The zip code is not guaranteed to be valid.</p></td>
		 *   </tr>
		 *   <tr>
		 * <td valign="top" bgcolor="#FFFFFF"><code>Regular Expression</code></td>
		 * <td bgcolor="#FFFFFF" class="content">The data supplied must match the provided custom regular expression.</td>
		 *  </tr>
		 * </table>
		 * @return <code>true</code> if all fields passed validation, <code>false</code> if one or more fields failed.
		 * @see PrForm#failedArray
		 * @includeExample ../../examples/PrForm/PrForm_validate_submit.txt -noswf
		 */
		public function validate():Boolean
		{
			m_aFailedArray = new Array();
			m_aFailedArray = m_oFormData.getElementArray().filter(_isInvalid);
			if (m_aFailedArray.length > 0)
			{
				return false;
			}
			return true;
		}
		/**
		 * The submitForm method reads all registered fields of the PrForm object and sends them to the processing script defined by the 
		 * baseURL property.  It is highly recommended that the <code>validate()</code> method is called before the <code>submitForm()</code> method to 
		 * ensure that all collected data adheres to the proper formatting rules.  
		 * <br/>The best practice is to only call the <code>submitForm()</code> method after a successful validation.
		 * 
		 * @see PrForm#validate()
		 * @see #event:submit
		 * @see #event:return
		 * @includeExample ../../examples/PrForm/PrForm_validate_submit.txt -noswf
		 */
		public function submitForm():void
		{
			_preparePRFields();
			
			var request:URLRequest = new URLRequest( baseURL );
			var loader:URLLoader = new URLLoader();
			request.data = m_oFormData.getURLVars();
			request.method = submissionMethod;
			loader.dataFormat = dataFormat;
			loader.addEventListener(Event.COMPLETE, _loadComplete);
			loader.load( request );
			dispatchEvent(new PrDataEvent(PrDataEvent.SUBMIT));
		}
		/**
		 * An array containing all FormElements that have failed validation.  This property returns null if 
		 * <br/><code>validate()</code> has not been called.
		 * @see PrForm#validate()
		 */
		public function get failedArray():Array { return m_aFailedArray; }
		/**
		 * A reference to the DisplayObject where the PrForm has been built.  Ususally this value will refer to the main Timeline of your movie.
		 */
		public function get scope():DisplayObject { return m_oScope; }
		
		public function set scope(value:DisplayObject):void {
			m_oScope = value;
		}
		
		/**
		 * @copy PointRollAPI_AS3.data.FormData#numItems
		 */
		public function get numItems():uint
		{
			return m_oFormData.numItems;
		}
		
		/**
		 * @private
		 * @param	e Event.Complete
		 */
		private function _loadComplete(e:Event):void {
			PrDebug.PrTrace("Submission Complete",3,"PrForm");
			var event:Event = new Event(e.type);
			returnedData = e.target.data;
			dispatchEvent(new PrDataEvent(PrDataEvent.RETURN));
		}
		/**
		 * @private
		 * Essentially a replacement for the eval function that was removed in AS3
		 * @param	pathToValue A String representation of a fully qualified variable name (i.e. "myMovie.textField.text")
		 * @return  A String representation of the value of the provided variable
		 */
		private function _getValue( pathToValue:String ):String{
			var pieces:Array = pathToValue.split(".");
			/**
			 * @internal use the reserved flag to register properties of the PrForm object
			 */
			if (pieces[0] == '_prRESERVED')
			{
				return String( this[ pieces[1] ] )
			}
			var tmp:* = m_oScope[pieces.shift()];
			while ( pieces.length > 0 )
			{
				tmp = tmp[ pieces.shift() ];
			}
			return String( tmp );
		}
		/**
		 * @private 
		 * Determines the validity of a FormElement based on its current value and dataType.
		 * Implemented as a 'filter' function of an Array
		 * This implementation is a little backwards, as we're identifying items as INVALID, 
		 * but it takes advantage of the Array's built-in 'filter' method - Deely
		 * @param item Current FormElement
		 * @param index Element's index in the FormData array
		 * @param array Reference to the full array
		 * @return true if the FormElement fails validation, false otherwise
		 */
		private function _isInvalid( item:FormElement, index:int, array:Array):Boolean
		{
			var currentValue:String;
			var re:RegExp;
			var result:Object;
			
			//do not attempt to validate PR reserved variables
			if (item.pathToValue.indexOf("_prRESERVED") > -1)
			{
				return false;
			}
			try {
				currentValue = _getValue(item.pathToValue);
				item.currentValue = currentValue;
			}catch (e:Error) {
				//value cannot be found, and therefore is invalid
				item.failureMessage = "Variable Path is invalid";
				return true;
			}
			
			if ( !item.allowOriginalValue && item.currentValue == item.originalValue )
			{
				item.failureMessage = "Original value is not permitted";
				return true;
			}
			
			switch( item.dataType )
			{
				case STRING:
				case TEXTAREA:
					if( item.currentValue.length < item.minimumLength ){
						return true;
					}else {
						return false;
					}
					break
				case BOOLEAN:
					return !( item.currentValue == "true" || item.currentValue == "false" )
					break
				case NUMBER:
					if ( item.currentValue.length < item.minimumLength) {
						return true;
					}
					return isNaN(Number( item.currentValue ));
					break
				case ZIP:
					re = /^\d{5}$/
					return !re.test(item.currentValue);
					break
				case ZIPPLUS:
					re = / ^\d{5}-\d{4}$ | ^(\d{9})$ | ^(\d{5})$ /x
					return !re.test(item.currentValue);
					break
				case EMAIL:
					re = / ^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$ /ix
					return !re.test(item.currentValue);
					break
				case PHONE:
					/**
					 * @internal Verifying a phone number consists of the following steps:
					 * 1) Strip all recognized special characters
					 * 2) A valid phone number will have only 10 digits left (plus an optional 1) - if not, return invalid
					 * 3) Separate the digits into 3 sections and inject into selected phoneFormat template
					 * 4) If the resulting string matches the original, then the number is valid AND in the correct format
					 */
					var tmpStr:String = StringUtil.strip(item.currentValue," ",".","(",")","-");
					re = /^1?(\d{10})$/
					result = re.exec(tmpStr);
					if (result == null)
					{
						return true;
					}
					tmpStr = result[1]; //lose the "1" if it's there
					PrDebug.PrTrace("Temp Phone String: "+tmpStr,5,"PrForm");

					var formatted:String = StringUtil.insertion(phoneFormat,tmpStr.substr(0,3),tmpStr.substr(3,3),tmpStr.substr(6,4));
					PrDebug.PrTrace("Formatted Phone Number: "+formatted,5,"PrForm");
					
					if(formatted == item.currentValue){
						return false;
					}else{
						item.suggestionMessage = formatted;
						return true;
					}
					break
				case DATE:
					//accepts ".", "/", and "-" as seperators. Takes 1 or 2 digits for month & day, and 2 or 4 for year
					re = /^ (\d{1,2}) [-.\/] (\d{1,2}) [-.\/] (\d{4}|\d{2}) $/x
					result = re.exec(item.currentValue);
					
					if ( result == null ) {
						return true;
					}
					//grab the individual date pieces
					var part1:Number = Number(result[1]);
					var part2:Number = Number(result[2]);
					var part3:Number = Number(result[3]);
					var monthMax:Array = new Array(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31); //maximum day for each month
					if( (part1 > 12 && part2 > 12) || (part1 > 31 || part2 > 31) || part1 <= 0 || part2 <= 0 || part3 <= 0){
						return true;
					}
					switch(dateFormat){
						case DATE_US2:
							if( NumberUtil.isBetween(part1,1,12) && NumberUtil.isBetween(part2,1,monthMax[part1-1]) && NumberUtil.isBetween(part3,0,99)){
								return false;
							}
						break
						case DATE_US4:
							if( NumberUtil.isBetween(part1,1,12) && NumberUtil.isBetween(part2,1,monthMax[part1-1]) && NumberUtil.isBetween(part3,1900,2100)){
								return false;
							}
						break
						case DATE_EU2:
							if( NumberUtil.isBetween(part1,1,monthMax[part2-1]) && NumberUtil.isBetween(part2,1,12) && NumberUtil.isBetween(part3,0,99) ){
								return false;
							}
						break
						case DATE_EU4:
							if( NumberUtil.isBetween(part1,1,monthMax[part2-1]) && NumberUtil.isBetween(part2,1,12) && NumberUtil.isBetween(part3,1900,2100)){
								return false;
							}
						break
						default:
							PrDebug.PrTrace("Unrecognized Date Format",3,"PrForm");
							return false;
					}
					//item.suggestionMessage = "The proper date format is: " + dateFormat;
					return true;
					
				default:
					//user supplied custom RegExp
					re = new RegExp(item.dataType);
					return !re.test(item.currentValue)
			}
		}
		
		private function _preparePRFields():void{
		//add PR specific data collection fields
			if(baseURL.indexOf("submit.pointroll.com") > -1 && collectionID != null){
				m_sCreativeID = StateManager.URLParameters.PRCID;
				m_sPlacementID =  StateManager.URLParameters.PRPID;
				if ( StateManager.getPlatformState() == StateManager.TESTING )
				{
					PrDebug.PrTrace("Using DEMO ad/placement",1,"PrForm");
					m_sCreativeID = m_sPlacementID = "1111"
				}
				
				PrDebug.PrTrace("Ad/Placement: "+m_sCreativeID+" / "+m_sPlacementID, 5,"PrForm");
				if(!m_oFormData.itemExists("CollectID")){ registerField("CollectID","_prRESERVED.collectionID","String") }
				if(!m_oFormData.itemExists("plcmt")){ registerField("plcmt","_prRESERVED.m_sPlacementID","String") }
				if (!m_oFormData.itemExists("ad")) { registerField("ad", "_prRESERVED.m_sCreativeID", "String") }
				
				m_oFormData.getItemByName("CollectID").currentValue = String(collectionID);
				m_oFormData.getItemByName("plcmt").currentValue = String(m_sPlacementID);
				m_oFormData.getItemByName("ad").currentValue = String(m_sCreativeID);
				
			}
		}
		
		
	}
	
}