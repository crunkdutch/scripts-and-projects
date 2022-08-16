package PointRollAPI_AS3.media 
{
	import PointRollAPI_AS3.events.media.PrMediaEvent;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.*;
	import flash.utils.Timer;

	/**
	 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FADE_COMPLETE
	 * @see SoundController#fadeVolume()
	 */
	[Event(name = "fadeComplete", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FADE_STEP
	 * @see SoundController#fadeVolume()
	 */
	[Event(name = "fadeStep", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
	
	/**
	* The SoundController class manages volume levels, fading and other sound transformations for media 
	* playback classes.  This class is used internally and there should be little need to implement it directly.
	* @author Chris Deely - PointRoll
	*/
	public class SoundController extends EventDispatcher {
		/** The number of "steps" or intervals over which to perform the fading operation. */
		public var fadeSteps:uint = 50;
		/** Indicates that the volume is being faded out. */
		public static const FADE_OUT:String = "FadeOut";
		/** Indicates that the volume is being faded in. */
		public static const FADE_IN:String = "FadeIn";

		private var m_oSoundTransform:SoundTransform;
		
		/*Fade Settings*/
		private var m_oTimer:Timer;
		private var m_sFadeDirection:String;
		private var m_nFadeIncrement:Number;
		/** Creates a new SoundController Object */
		public function SoundController() {	}
		/**
		 * Sets the volume level and returns a reference to the SoundTransform object
		 * @param	n Desired volume level (range 0-1)
		 * @return A SoundTransform object with the appropriate volume level set.
		 * @internal the undocumented 2nd parameter allows the designer to kill a fade by explicitly setting
		 * the volume.  This is only set to true by the fading logic, and should never be used outside of this 
		 * class.
		 */
		public function setVolume(n:Number,fading:Boolean=false):SoundTransform
		{
			var origVol:Number;
			if (!fading)
			{
				_killFade(); //user has explicitly set the volume, stop any running fades
			}
			try
			{
				origVol = getVolume();
			}catch (e:Error)
			{ }
			
			n = _normalizeVolume(n);
			
			if ( m_oSoundTransform == null )
			{
				m_oSoundTransform = new SoundTransform(n);
				return m_oSoundTransform;
			}
			m_oSoundTransform.volume = n;
			
			if( n == 0 && origVol > 0){
				dispatchEvent( new PrMediaEvent(PrMediaEvent.MUTE) );
			} else	if( n  > 0 && origVol == 0){
				dispatchEvent( new PrMediaEvent(PrMediaEvent.UNMUTE) );
			}
			
			return m_oSoundTransform;
		}
		
		/**
		 * Sets the SoundTransform object to be used.
		 * @param	st SoundTransform object
		 */
		public function setSoundTransform(st:SoundTransform):void
		{
			m_oSoundTransform = st;
			setVolume(st.volume);
		}
		
		/**
		 * Returns the current volume level
		 * @return Current Volume
		 */
		public function getVolume():Number
		{
			return m_oSoundTransform.volume;
		}
		/**
		 * Returns a reference to the SoundTransform object
		 * @return
		 */
		public function getSoundTransform():SoundTransform
		{
			return m_oSoundTransform;
		}
		/**
		 * While the volume is being faded, this method will tell the designer the direction in which the volume 
		 * is being faded.  The value will be either SoundController.FADE_IN or SoundController.FADE_OUT.
		 * @return Current fade direction
		 * @see SoundController#fadeVolume()
		 * @see SoundController#FADE_IN
		 * @see SoundController#FADE_OUT
		 */
		public function getFadeDirection():String
		{
			return m_sFadeDirection;
		}
		/**
		 * Fades the volume from its current level to the desired end point. 
		 * @param	newVolume The desired volume level (range 0-1)
		 * @param	seconds The number of seconds over which to fade the volume level
		 * @see #event:fadeStep
		 * @see #event:fadeComplete
		 */
		public function fadeVolume( newVolume:Number, seconds:Number ):void
		{
			
			_killFade(); //kill any existing fade
			var interval:Number = (seconds * 1000) / fadeSteps;
			var fadeDistance:Number = getVolume() - _normalizeVolume(newVolume);
			m_sFadeDirection = FADE_OUT;
	
			if ( fadeDistance < 0 )
			{
				fadeDistance = fadeDistance * -1;
				m_sFadeDirection = FADE_IN;
			}
			
			m_nFadeIncrement = Number( Number(fadeDistance / fadeSteps));
			m_oTimer = new Timer(interval, fadeSteps);
			m_oTimer.addEventListener(TimerEvent.TIMER, _doFade, false, 0, true);
			m_oTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _fadeComplete, false, 0, true);
			m_oTimer.start();
		}
		
		private function _killFade():void
		{
			try {
				//stop any existing fade timer
				m_oTimer.stop();
				m_oTimer = null;
			}catch (e:Error) {
				//timer not created yet
			}
		}
		
		private function _doFade(e:TimerEvent):void {
			var newVolume:Number;
			
			switch ( m_sFadeDirection )
			{
				case FADE_OUT:
					newVolume = getVolume() - m_nFadeIncrement;
					break;
				case FADE_IN:
					newVolume = getVolume() + m_nFadeIncrement;
					break;
				default:
					throw(new Error("Invalid Fade Direction"));
			}
			
			//normalize
			if (newVolume > 1){newVolume = 1 }

			setVolume(newVolume,true);
			dispatchEvent(new PrMediaEvent(PrMediaEvent.FADE_STEP) );
		}
		
		private function _fadeComplete(e:TimerEvent):void {
			_killFade();
			dispatchEvent( new PrMediaEvent(PrMediaEvent.FADE_COMPLETE) );
		}
		private function _normalizeVolume( n:Number ):Number{
			//accomodates using the old-style volume levels of 0-100 as well as the new 0-1
			if( n <= 0 ){
				return 0
			}else if( n > 0 && n <= 1){
				return n
			}else if(n <= 100){
				return (n / 100)
			}
			return 1
		}
	}
	
}