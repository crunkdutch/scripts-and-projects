

package PointRollAPI_AS3.media 
{
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.START
	 * @see PrVideo#startVideo()
	 */
	[Event(name = "start", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.COMPLETE
	 */
	[Event(name = "complete", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.PROGRESS
	 */
	[Event(name = "progress", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
	/**
	 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.OPTIONAL_MILESTONE
	 * @see PrVideo#optionalMilestones
	 * @see PrVideo#resetOptionalMilestones()
	 */
	[Event(name = "onOptionalMilestone", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
	
	/**
	* The ProgressTracker Class assists with tracking media playback and recording milestone metrics.
	* @author Chris Deely - PointRoll
	* @private 
	* @version 1.0
	* @see PointRollAPI_AS3.media.PrVideo
	* @see PointRollAPI_AS3.media.PrAudio
	*/
	public class ProgressTracker extends EventDispatcher {
		public var optionalMilestones:Array;
		public var trackProgress:uint = 4;

		
		private var m_oTarget:IProgressTrackable;
		private var m_oTimer:Timer;
		private var m_aStandardMilestones:Array;
		private var m_iCurOptMile:int = 0;
		
		public function ProgressTracker( target:IProgressTrackable, frequency:Number )
		{
			
			m_oTarget = target;
			//establish listeners
			m_oTarget.addEventListener(PrMediaEvent.PLAY, start,false,0,true)
			m_oTarget.addEventListener(PrMediaEvent.RESTART, start,false,0,true)
			
			m_oTarget.addEventListener(PrMediaEvent.PAUSE, stop,false,0,true)
			m_oTarget.addEventListener(PrMediaEvent.STOP, stop,false,0,true)
			m_oTarget.addEventListener(PrMediaEvent.COMPLETE, stop,false,0,true)
			m_oTarget.addEventListener(PrMediaEvent.ONKILL,stop,false,0,true)
			
			m_oTimer = new Timer(frequency);
			m_oTimer.addEventListener(TimerEvent.TIMER, _dispatch,false,0,true);
			
			resetStandardMilestones();
		}
		
		public function start(...rest):void
		{
			//using ...rest allows this function to be fired by any type of event, or manually
			m_oTimer.start();
		}
		
		public function stop(...rest):void
		{
			//using ...rest allows this function to be fired by any type of event, or manually
			m_oTimer.stop();
		}
		
		public function set frequency( n:Number ):void
		{
			m_oTimer.delay = n;
		}
		
		public function get isTracking():Boolean
		{
			return m_oTimer.running
		}
		
		public function resetStandardMilestones():void{
			m_aStandardMilestones = new Array(5);
		}
		public function resetOptionalMilestones():void{
			m_iCurOptMile = 0;
		}
		private function _dispatch( e:TimerEvent ):void
		{
			var event:PrProgressEvent = new PrProgressEvent(PrProgressEvent.PROGRESS);
			//pull IProgressTrackable properties
			event.setTarget(m_oTarget);
			var optionalMilestone:Number = _fireOptionalMilestone(event.currentTime);

			
			
			event.milestone = _trackStandardMilestone( event.percentPlayed );
			//Dispatch progress event
			dispatchEvent( event );
			//dispatch optional milestone event as needed
			if ( optionalMilestone > -1 )
			{
				var optionalEvent:PrProgressEvent = new PrProgressEvent( PrProgressEvent.OPTIONAL_MILESTONE );
				optionalEvent.optionalMilestone = optionalMilestone;
				optionalEvent.setTarget(m_oTarget);
				m_oTarget.dispatchEvent( optionalEvent );
			}
			if( m_oTarget.currentTime >= m_oTarget.totalTime )
			{
				m_oTarget.dispatchEvent( new PrMediaEvent(PrMediaEvent.COMPLETE) );
			}
		}
		
		private function _fireOptionalMilestone(time:Number):Number{
			var currentMilestone:Number;
			try {
				if ( time >= optionalMilestones[ m_iCurOptMile ] )
				{
					PrDebug.PrTrace("Optional Milestone "+optionalMilestones[ m_iCurOptMile ],1);
					currentMilestone = optionalMilestones[ m_iCurOptMile ];
					m_iCurOptMile++;
					return currentMilestone;
				}
			}catch(e:Error) {
				//PrDebug.PrTrace("No Optional Milestone to Fire",5);
			}
			return -1;
		}
		
		private function _trackStandardMilestone( n:Number ):int
		{
			//Tracks the standard media playback metrics (25,50,75,100) based on the user defined level of trackProgress
			//Returns 1-4 for milestone level, or -1 if we are not currently at a milestone
			n = n * 100;
			var minTrackLevel:Array = new Array(1,4,3,4,2); //minimum value of trackProgress required to track corresponding activity
			var percentRange:Number = Math.floor( n / 25); //whole number ranging 0-4. 0: 0-24%, 1: 25-49%, 2: 50-74%, 3: 75-95%, 4: 96%+
			if( n >= 96){ percentRange = 4; } //force to "complete"
			
			if ( !m_aStandardMilestones[ percentRange ]) {
				m_aStandardMilestones[ percentRange ] = true;
				//this progress level has not been tracked yet
				if( percentRange == 0 )
				{
					PrDebug.PrTrace("Media Playback Start",3);
					m_oTarget.dispatchEvent( new PrMediaEvent(PrMediaEvent.START) );
				}
				else if( trackProgress >= minTrackLevel[percentRange] )
				{
					//trackProgress is high enough to allow for this metric
					PrDebug.PrTrace(percentRange*25+"% Percent Complete",3);
					return percentRange * 25;
				}
			}
			return -1
		}
		
		
	}
	
}
