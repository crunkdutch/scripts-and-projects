package PointRollAPI_AS3.util {
	/**
	 * Contains several helpful utilities for dealing with numbers and numerical calculations.  NumberUtil is a static class, 
	 * meaning that there is no need to create an instance of the class before using its methods.
	 */
	public class NumberUtil {
		/**
		 * Returns the provided number with no more than the maximum number of decimal places requested.
		 * <br/><br/>NOTE: This function does NOT round the number, it only truncates extra decimal places
		 * @param	n The number to process
		 * @param	m The maximum nuber of decimal places for the returned value
		 * @return The number provided, formatted to the maximum number of decimal places or less
		 * @includeExample ../../examples/NumberUtil/NumberUtil_maxDecimals.txt -noswf
		 */
		static public function maxDecimals(n:Number, m:Number):Number{
			
			var n_str:String = String(n);
			var point:Number = n_str.indexOf(".");
			if(point > -1){
				if(m <=0){
					//strip all decimals
					return(int(n_str));
				}else{
					var tmp:String = n_str.substring(point+1);
					if(tmp.length > m){
						tmp = tmp.substr(0,m);
					}
					n_str = n_str.substring(0,point+1) + tmp;
				}
			}
			return Number(n_str); 
		}
		/**
		 * Returns a String representatation of the provided number with the desired number of decimal places.  
		 * This function must return as a String because it may append trailing zeros to the end of the number.  
		 * As such, the results of this function should be used to format numbers for display purposes, not for 
		 * making mathematical calculations.
		 * @param	n The number to process
		 * @param	m The desired number of decimal places
		 * @return A String representation of the number with exactly <code>m</code> decimal places
		 * @includeExample ../../examples/NumberUtil/NumberUtil_setDecimals.txt -noswf
		 */
		static public function setDecimals(n:Number, m:Number):String{
			if(m == 0){ return String(int(n)); }
			
			var n_str:String = String(n);
			var point:Number = n_str.indexOf(".");
			
			if(point > -1){
				var tmp:String = n_str.substring(point+1);
				if(tmp.length > m){
					tmp = tmp.substr(0,m);
				}
				while(tmp.length < m){
					tmp += "0";
				}
				n_str = n_str.substring(0,point+1) + tmp;
			}else{
				//no decimal places present, add (m) 0's
				if(m > 0){
					n_str += ".";
					for(var i:Number = 0; i<m; i++){
						n_str += "0";
					} 
				}
			}
			return n_str
		}
		/**
		 * Tells you if a given number falls within a provided range.
		 * @param	n The number to process
		 * @param	low The low end of the range to test for
		 * @param	high The high end of the range to test for
		 * @return <code>true</code> if the number is within the provided range (inclusive)
		 * @includeExample ../../examples/NumberUtil/NumberUtil_isBetween.txt -noswf
		 */
		static public function isBetween(n:Number,low:Number, high:Number):Boolean{
			if(low > high){ //numbers are swapped
				var tmp:Number = low;
				low = high;
				high = tmp;
			}
			
			if((n >= low) && (n <= high)){
				return true
			}else{
				return false
			}
		}
		/**
		 * Generates a random number between a specified range
		 * @param	low The low number of the range
		 * @param	high The high number of the range
		 * @return A random number between <code>low</code> and <code>high</code>
		 * @includeExample ../../examples/NumberUtil/NumberUtil_randRange.txt -noswf
		 */
		static public function randRange(low:Number, high:Number):Number{
			if(low > high){
				var tmp:Number = low;
				low = high;
				high = tmp;
			}
			var randomNum:Number = int(Math.random() * (high - low + 1)) + low;
			return randomNum;
		}
	}
}