package PointRollAPI_AS3.data
{
	import flash.external.ExternalInterface;

	/**
	* The DataStorage class provides getter and setter methods which allow the designer to store and retrieve data that can be shared between 
	* ad panels of the same ad or of different ads.
	* <p>This class has a variety of uses. There are many cases in which this can eliminate the need for local connections when only a 
	* temporary setting is needed. For example, controlling the volume of videos in multiple panels could make use of this class.</p>
	* @author Maggy Maffia - PointRoll
	* @includeExample ../../examples/DataStorage/DataStorage.txt -noswf
	*/
	public class DataStorage
	{
		static private var _watchedVars:Object;
		
		/**
		 * <code>true</code> if DataStorage is available in the current environment, false otherwise.
		 */
		static public function get available():Boolean
		{
			try {
				if (ExternalInterface.available)
				{
					var f:Object =  ExternalInterface.call("function() {return typeof(prGet);}");
					trace("prGet is "+f);
					return f == "function";
				}
			}catch (e:Error) 
			{ 
				return false;
			}
			return false;
		}
		
		/**
		 * Sets the value of the specified variable.
		 * @param	name The name of the variable.
		 * @param	value The value given to the variable.
		 * @includeExample ../../examples/DataStorage/DataStorage.txt -noswf
		 */
		static public function setVariable(name:String, value:String):void
		{
			if(available)
				ExternalInterface.call("prSet", name, value);
		}
		
		/**
		 * Returns the current value of the variable.
		 * @param	name The name of the variable. Must match the <code>name</code> parameter used in the <code>setVariable()</code> method.
		 * @return Returns the value of the variable.
		 */
		static public function getVariable(name:String):String
		{
			if (!available)
			{
				return null;
			}
			return String(ExternalInterface.call("prGet", name));
		}
		
		/**
		 * This function tells the DataStorage class to repeatedly check the value of the specified variable, and alerts the creative when the value 
		 * changes.
		 * @param	name The name of the variable to watch.
		 * @param	frequency How often, in milliseconds, the value should be checked.
		 * @param	functionToCall A reference to the function to be called when the value changes.  
		 * 			This function must accept two parameters: the variable's name and value.
		 * @return	The value of the variable
		 * @includeExample ../../examples/DataStorage/alertOnChange.txt -noswf
		 */
		static public function alertOnChange(name:String, frequency:Number, functionToCall:Function):String
		{
			if ( !_watchedVars)
			{ 
				_watchedVars = { }; 
			}
			stopAlert(name);
			var watched:WatchedVar = new WatchedVar(name, frequency, functionToCall, true);
			_watchedVars[ name ] = watched;
			
			return getVariable(name);
		}
		
		/**
		 * Checks the value of the specified variable and alerts the creative with the value on an interval. This function differs from <code>alertOnChange()</code> 
		 * in that <code>alertOnChange()</code> will call the specified function only when the variable's value has changed, whereas <code>checkOnInterval()</code> 
		 * will call it on each check regardless of whether or not the value has changed.
		 * @param	name The name of the variable to watch.
		 * @param	frequency How often, in milliseconds, the value should be checked.
		 * @param	callFunction A reference to the function to be called on the interval.  
		 * 			This function must accept two parameters: the variable's name and value.
		 * @return The value of the variable
		 * @includeExample ../../examples/DataStorage/checkOnInterval.txt -noswf
		 */
		static public function checkOnInterval(name:String, frequency:Number, callFunction:Function):String
		{
			if (!_watchedVars)
			{ 
				_watchedVars = { }; 
			}
			
			stopAlert(name);
			
			var watched:WatchedVar = new WatchedVar(name, frequency, callFunction, false);
			_watchedVars[name] = watched;
			
			return getVariable(name);
		}
		
		/**
		 * Stops watching for changes to the specified variable
		 * @param	name The name of the variable to stop watching
		 * @includeExample ../../examples/DataStorage/stopAlert.txt -noswf
		 */
		static public function stopAlert(name:String):void
		{
			if ( _watchedVars[ name ])
			{
				var w:WatchedVar = _watchedVars[ name ] as WatchedVar;
				w.destroy();
				w = _watchedVars[ name ] = null;
			}
		}
	}
}

import PointRollAPI_AS3.data.DataStorage;

import flash.events.TimerEvent;
import flash.utils.Timer;

class WatchedVar{
	private var _timer:Timer;
	public var value:String;
	public var name:String;
	public var func:Function;
	public var onlyOnChange:Boolean;
	
	public function WatchedVar(name:String, frequency:Number, alertFunction:Function, onlyOnChange:Boolean = false)
	{
		this.name = name;
		value = DataStorage.getVariable(name);
		func = alertFunction;
		this.onlyOnChange = onlyOnChange;
		_timer = new Timer(frequency);
		_timer.addEventListener(TimerEvent.TIMER, checkForValue, false, 0, true);
		_timer.start();
	}
	
	private function checkForValue(e:TimerEvent):void
	{
		var newVal:String = DataStorage.getVariable(name);
		if ( !onlyOnChange || newVal != value )
		{
			value = newVal;
			func(name, value);
		}
	}
	
	public function destroy():void
	{
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER, checkForValue);
		_timer = null;
		value = null;
		name = null;
	}
}