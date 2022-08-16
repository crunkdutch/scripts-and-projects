package PointRollAPI_AS3.media 
{
	import PointRollAPI_AS3.ActivityController;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.events.media.*;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.*;
	import flash.net.URLRequest;

	/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.START
		 * @see PrAudio#startVideo()
		 * @includeExample ../../examples/media/events/start_PrAudio.txt -noswf
		 */
		[Event(name = "start", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/** 
		 * Event dispatched when ID3 information is found on the MP3 being loaded.
		 * @eventType flash.events.Event.ID3
		 * @see PrAudio#id3
		 */
		[Event(name = "id3", type = "flash.events.Event")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.COMPLETE
		 * @includeExample ../../examples/media/events/complete_PrAudio.txt -noswf
		 */
		[Event(name = "complete", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.ONKILL
		 * @see PrAudio#killAudio()
		 * @includeExample ../../examples/media/PrAudio_killSound.txt -noswf
		 */
		[Event(name = "onKill", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.PLAY
		 * @see PrAudio#play()
		 */
		[Event(name = "play", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.PAUSE
		 * @see PrAudio#pause()
		 */
		[Event(name = "pause", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.STOP
		 * @see PrAudio#stop()
		 */
		[Event(name = "stop", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.REPLAY
		 * @see PrAudio#replay()
		 */
		[Event(name = "replay", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.RESTART
		 * @see PrAudio#restart()
		 */
		[Event(name = "restart", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FAILURE
		 */
		[Event(name = "failure", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.PROGRESS
		 */
		[Event(name = "progress", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.OPTIONAL_MILESTONE
		 * @see PrAudio#optionalMilestones
		 * @see PrAudio#resetOptionalMilestones()
		 * @includeExample ../../examples/media/PrAudio_optionalMilestones.txt -noswf
		 */
		[Event(name = "onOptionalMilestone", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.MUTE
		 * @see PrAudio#volume
		 * @see PrAudio#fadeVolume()
		 * @includeExample ../../examples/media/events/fade_volume_PrAudio.txt -noswf
		 */
		[Event(name = "mute", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.UNMUTE
		 * @see PrAudio#fadeVolume()
		 * @see PrAudio#volume
		 * @includeExample ../../examples/media/events/fade_volume_PrAudio.txt -noswf
		 */
		[Event(name = "unmute", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FADE_COMPLETE
		 * @see PrAudio#fadeVolume()
		 * @includeExample ../../examples/media/events/fade_volume_PrAudio.txt -noswf
		 */
		[Event(name = "fadeComplete", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FADE_STEP
		 * @see PrAudio#fadeVolume()
		 * @includeExample ../../examples/media/events/fade_volume_PrAudio.txt -noswf
		 */
		[Event(name = "fadeStep", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
	
	/**
	* The PrAudio class controls MP3 playback through ad units.  This class provides automatic progress tracking as well as 
	* recording of user-initiated events such as play, pause, restart and volume control.
	* @author Chris Deely - PointRoll
	*/
	public class PrAudio extends EventDispatcher implements IMediaController, IProgressTrackable {
		/** This property may be set to <code>false</code> if you do not wish to track user activities for this video object.  
		 * The user activities include play, pause, stop, restart, replay, mute and unmute. 
		 * 
		 * If, instead, you wish to limit the amount of tracking used for video playback percentages, use the <code>trackProgress</code> property.
		 * @see PrVideo#trackProgress
		 * @includeExample ../../examples/media/PrAudio_trackEvents.txt -noswf
		 * */
		public var trackEvents:Boolean = true;
		/** Sets the frequency, in milliseconds, at which the <code>progress</code> event will be fired. It is not recommended to set this value lower than 100.
		 * @see #event:progress */
		public var progressFrequency:Number = 250;
		
		
		private var m_oSoundController:SoundController;
		private var m_aActivities:Object = { play:1101, pause:1102, stop:1106, restart:1103, replay:1107, unmute:1105, mute:1104 };
		private var m_oActivityControl:ActivityController;
		private var m_ProgressTracker:ProgressTracker;
		private var m_FileName:String;
		private var m_Instance:int;
		private var m_oSound:Sound;
		private var m_oSoundTransform:SoundTransform;
		private var m_oSoundChannel:SoundChannel;
		private var m_nPausePosition:Number = 0;
		private var m_nTotalTime:Number;
		private var m_nCompleteAt:Number = 0.05;
		private var m_nVolume:Number;
		
		/**
		 * Constructor for the PrAudio object that requires all parameters. Establishes creation of the object and allows for access 
		 * to the properties, handlers and methods of the object. You must have this line of code along with the import statement in 
		 * order to use any of the other functions. 
		 * <p>This only creates the object. It does not initiate playback of the audio. See the <code>startAudio()</code> method for more information.</p>
		 * <p>Please note: Audio files that are brought into flash will be downloaded into the user's cache. See Flash Sound Object help file for more information. The PrAudio object will "stream" the file (buffer and play the file while it is downloading). This is different from video streaming in that nothing is downloaded to the user's cache when streaming an flv. To avoid caching the audio would have to streamed as an flv which means it would be tracked as video and would need to use the PrVideo class. Contact your PointRoll representative for more information on options for audio streaming.</p>
		 * @param	fileName Path to file you wish to stream, for example: http://speed.pointroll.com/panel/myMP3.mp3 
		 * <br/>This parameter often uses the PointRoll.absolutePath property to dynamically populate the appropriate path.
		 * @param	initVolume The initial volume level to be used (range 0-1)
		 * @param	instanceNum Intstance number of the particular audio object. If you have multiple audio objects, you should enumerate this upwards, i.e. 1, 2, 3, 4 . If set to 0, this will disable all tracking for the audio object. 
		 * @param	duration Total length in seconds of the audio file. Do not round this number down or up, but be as accurate as possible.  
		 * @param	scope A reference to the containing DisplayObject.  Generally, the keyword <code>this</code> should be used.
		 * @see PointRollAOI_AS3.PointRoll#absolutePath
		 */
		public function PrAudio(fileName:String,initVolume:Number, instanceNum:Number, duration:Number, scope:DisplayObject) {
			
			m_nVolume = initVolume;
			m_nTotalTime = duration;
			m_oActivityControl = ActivityController.getInstance(scope);
			
			//init progress tracker
			m_ProgressTracker = new ProgressTracker(this, progressFrequency);
			m_ProgressTracker.addEventListener(PrProgressEvent.PROGRESS,_onProgress,false,0,true)
			this.addEventListener(PrMediaEvent.START,_onStart,false,0,true)			
			
			//Check for Full or Absolute Path
			if(fileName.indexOf("http:") > -1){
				//Full path provided
				PrDebug.PrTrace("Absolute Path Provided: " + fileName,2,"PrAudio");
			}else if(StateManager.getPlatformState() == StateManager.TESTING){
				//Loacal Viewing
				if(fileName.indexOf("/") == 0){
					//Local Viewing with Web Folder Paths
					fileName = "http://media.pointroll.com"+fileName;
				}
			}
			m_FileName = fileName;
			
			if ( instanceNum == 0)
			{
				trackEvents = false;
				trackProgress = 0;
			}
			m_Instance = (instanceNum - 1) + 10;
			
			//Listen for kill command and perform cleanup as needed
			StateManager.addEventListener(StateManager.KILL, _killCommandHandler, false, 0, true);
			
			//init sound controller
			_initSound(m_nVolume);
		}
		
		
		/**
		 * Once the PrAudio object is created(instantiated), the audio does not begin playback immediately. 
		 * In order to begin playback, you must invoke the startAudio method.
		 * @param	startTime You may optionally set a point in the file to begin at (in seconds)
		 * @param	loops Number of times to loop the audio
		 * @see #event:start
		 * @includeExample ../../examples/media/events/start_PrAudio.txt -noswf
		 */
		public function startAudio(startTime:Number=0, loops:int=0):void
		{
			startTime = startTime * 1000;
			m_oSoundChannel = m_oSound.play(startTime, loops, m_oSoundTransform);
			m_ProgressTracker.resetOptionalMilestones();
			m_ProgressTracker.resetStandardMilestones();
			//_trackProgressActivity("-1"+m_nInstanceActivity+"6",1); //activity for start audio
			m_ProgressTracker.start();
		}
		/**
		 * @see #event:play
		 * @inheritDoc
		 */
		public function play():void{
			if ( !isPlaying )
			{
				m_oSoundChannel = m_oSound.play( m_nPausePosition, 0, m_oSoundTransform);
				_trackEventActivity("play"); 
				dispatchEvent(new PrMediaEvent(PrMediaEvent.PLAY));
			}
		}
		/**
		 * @see #event:pause
		 * @inheritDoc
		 */
		public function pause():void{
			if ( isPlaying )
			{
				m_nPausePosition = m_oSoundChannel.position;
				m_oSoundChannel.stop();
				_trackEventActivity("pause"); 
				dispatchEvent(new PrMediaEvent(PrMediaEvent.PAUSE));
			}
		}
		/**
		 * @see #event:stop
		 * @inheritDoc
		 */
		public function stop():void{
			if ( isPlaying )
			{
				m_nPausePosition = 0;
				m_oSoundChannel.stop();
				_trackEventActivity("stop"); 
				dispatchEvent(new PrMediaEvent(PrMediaEvent.STOP));
			}
		}
		/**
		 * @throws PointRollAPI_AS3.errors.PrError When attempting to seek beyond the limits of the file
		 * @inheritDoc
		 */
		public function seek( seekTo:Number ):void
		{
			
			if ( seekTo >= 0 && seekTo <= totalTime)
			{
				seekTo = seekTo * 1000;
				m_oSoundChannel.stop();
				m_oSoundChannel = m_oSound.play(seekTo, 0, m_oSoundTransform);
			}else {
				throw(new PrError(PrError.SEEK_ERROR));
			}
		}
		/**
		 * @see #event:replay
		 * @inheritDoc
		 */
		public function replay():void{
			m_nPausePosition = 0;
			try
			{
				m_oSoundChannel.stop();
			}catch (e:Error)
			{
				//sound objects have been killed, reinitialize
				_initSound(m_nVolume);
			}
			_trackEventActivity("replay"); 
			
			startAudio();
			dispatchEvent(new PrMediaEvent(PrMediaEvent.REPLAY));
		}
		/**
		 * @see #event:restart
		 * @inheritDoc
		 */
		public function restart(withSound:Boolean = false):void{
			
			seek(0);
			_trackEventActivity("restart"); 
			dispatchEvent(new PrMediaEvent(PrMediaEvent.RESTART));
		}
		/**
		 * @see #event:fadeStep
		 * @see #event:fadeComplete
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/fade_volume_PrAudio.txt -noswf
		 */
		public function fadeVolume(newVolume:Number, seconds:Number):void
		{
			m_oSoundController.fadeVolume(newVolume, seconds);
		}
		/**
		 * Stops the audio playback and closes the Sound object.  You must create a new PrAudio object if you wish to play any audio files after calling this method.
		 * @see #event:onKill
		 * @includeExample ../../examples/media/PrAudio_killSound.txt -noswf
		 */
		public function killSound():void
		{
			try{
				m_oSoundChannel.stop();
				m_oSound.close();
			}catch (e:Error) {
				//prevent errors if object doesnt exist
			}
			m_oSoundController = null;
			
			StateManager.removeEventListener(StateManager.KILL, _killCommandHandler);
			dispatchEvent(new PrMediaEvent(PrMediaEvent.ONKILL));
		}
		/**
		 * Returns a reference to the Sound object used by the PrAudio instance. Some advanced implementations may need to access the Sound Object directly.
		 * @return a reference to the Sound object used by the PrAudio instance
		 */
		public function getSoundObject():Sound
		{
			return m_oSound;
		}
		/**
		 * This method returns a reference to the SoundChannel object used by the PrAudio object. This can be used to access the SoundChannel's soundTransform 
		 * property for advanced audio manipulation to create a more interactive audio experience in an ad unit, such as panning between left and right channels and advanced volume control.
		 * @return a reference to the SoundChannel object used by the PrAudio instance
		 * @see PrAudio#getSoundTransform()
		 * @includeExample ../../examples/media/PrAudio_soundChannel.txt -noswf
		 */
		public function getSoundChannel():SoundChannel
		{
			return m_oSoundChannel;
		}
		/**
		 * This method returns a reference to the SoundTransform object used by the PrAudio object, providing access to all 
		 * methods and properties of the SoundTransform object for advanced audio manipulation to create a more interactive audio experience 
		 * in an ad unit, such as panning between left and right channels and advanced volume control.
		 * @return a reference to the SoundTransform object used by the PrAudio instance
		 * @see PrAudio#getSoundChannel()
		 * @includeExample ../../examples/media/PrAudio_soundChannel.txt -noswf
		 */
		public function getSoundTransform():SoundTransform
		{
			return m_oSoundTransform;
		}
		/**
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/complete_PrAudio.txt -noswf
		 */
		public function get currentTime():Number
		{
			if ( isPlaying )
			{
				return (m_oSoundChannel.position / 1000);
			}else {
				return 0;
			}
		}
		/**
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/complete_PrAudio.txt -noswf
		 */
		public function get totalTime():Number
		{
			if ( isNaN(m_nTotalTime) )
			{
				m_nTotalTime = (m_oSound.length / 1000);
			}
			return m_nTotalTime - m_nCompleteAt;
		}
		/**
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrAudio_bytesLoaded.txt -noswf
		 */
		public function get bytesLoaded():uint
		{
			var bytes:uint;
			try {
				bytes = m_oSound.bytesLoaded;
			}catch (e:Error) {
				bytes = 0;
			}
			return bytes
		}
		/**
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrAudio_bytesLoaded.txt -noswf
		 */
		public function get bytesTotal():uint
		{
			var bytes:uint;
			try {
				bytes = m_oSound.bytesTotal;
			}catch (e:Error) {
				bytes = 1;
			}
			return bytes
		}
		/**
		 * @see #event:unmute
		 * @see #event:mute
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/fade_volume_PrAudio.txt -noswf
		 */
		public function get volume():Number
		{
			return m_oSoundController.getVolume();
		}
		public function set volume(volume:Number):void
		{
			m_nVolume = volume;
			m_oSoundTransform = m_oSoundController.setVolume(volume);
			m_oSoundChannel.soundTransform = m_oSoundTransform;
		}
		////// End IMediaController ////////////
		/**
		 * @see #event:onOptionalMilestone
		 * @see PrAudio#optionalMilestones
		 * @inheritDoc
		 */
		public function resetOptionalMilestones():void{
			m_ProgressTracker.resetOptionalMilestones();
		}
		/** 
		 * Returns <code>true</code> if the audio is currently playing, <code>false</code> otherwise.
		 * @includeExample ../../examples/media/PrAudio_isPlaying.txt -noswf
		 */
		public function get isPlaying():Boolean
		{
			return m_ProgressTracker.isTracking
		}
		/**
		 * @see #event:onOptionalMilestone
		 * @see PrAudio#resetOptionalMilestones
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrAudio_optionalMilestones.txt -noswf
		 */
		public function get optionalMilestones( ):Array		{
			return m_ProgressTracker.optionalMilestones
		}
		public function set optionalMilestones( a:Array ):void
		{
			m_ProgressTracker.optionalMilestones = a;
		}
		/**
		 * The number of seconds before the end of the audio file at which to fire the <code>complete</code> event.
		 * 
		 * You may set this property to more accurately control when the onComplete event is fired.  If this value is set,
		 * <code>complete</code> will be triggered when the <code>currentTime</code> property is within the provided number 
		 * of seconds of <code>totalTime</code>.
		 * 
		 * <p>If you have a 10 second audio clip, but you wish the <code>complete</code> event to fire at 9 seconds, you 
		 * would set the <code>completeAt</code> property to 1. (10 - 9 = 1)</p>
		 * 
		 * The default value is 0.05 seconds.
		 * 
		 * <b>Note:</b> Setting this value only controls the time at which the <code>complete</code> event is fired, it will NOT cause 
		 * the playback to stop if there is more content to be played.
		 * 
		 * @see PrAudio#currentTime
		 * @see PrAudio#totalTime
		 * @see #event:complete
		 * @throws PointRollAPI_AS3.errors.PrError If the completeAt value is greater than the length of the video
		 * @includeExample ../../examples/media/events/complete_PrAudio.txt -noswf
		 */
		public function set completeAt(n:Number):void
		{
			if ( n >= m_nTotalTime )
			{
				throw(new PrError(PrError.COMPLETE_AT));
			}
			m_nCompleteAt = n;
		}
		/**
		 * Controls the level of progress tracking employed for this audio file.
		 * 
		 * A key metric related to audio is the tracking of playback progress. PointRoll by default reports back on 
		 * 0%, 25%, 50%, 75% and 100% playback. In some situations however, these metrics may not be of 
		 * paramount importance, or you may wish to only track a subset of them. In these cases, you can leverage the 
		 * <code>trackProgress</code> property to customize the particular milestones that you wish to monitor. 
		 * <code>trackProgress</code> has 5 particular settings (see below) that provide significant flexibility as to how you apply this functionality. 
		 * 
		 * <ol start="0">
		 * <li>No progress tracking</li>
		 * <li>Start Only</li>
		 * <li>Start and End</li>
		 * <li>Start, Middle and End</li>
		 * <li>All Milestones</li>
		 * </ol>
		 * @includeExample ../../examples/media/PrAudio_trackProgress.txt -noswf
		 */
		public function set trackProgress( level:uint ):void
		{
			m_ProgressTracker.trackProgress = level;
		}
		/** Provides access to the ID3 information for this MP3 file, if available. 
		 * @includeExample ../../examples/media/PrAudio_id3.txt -noswf
		 */
		public function get id3():ID3Info
		{
			return m_oSound.id3;
		}
		
		
		/*PRIVATE*/
		private function _trackEventActivity( name:String ):void
		{
			if ( trackEvents )
			{
				PrDebug.PrTrace("Track Media Event: "+name,1);
				m_oActivityControl.activity(m_aActivities[name]);
			}
		}
		private function _onStart(e:PrMediaEvent):void {
			m_oActivityControl.activity( Number("-1" + m_Instance + "6") )
		}
		private function _onProgress(e:PrProgressEvent):void
		{
			if (e.milestone > -1 )
			{
				//we have reached a playback milestone
				m_oActivityControl.activity( Number("-"+m_Instance+ (e.milestone/25)) )
			}
			dispatchEvent(e);			
		}
		private function _initSound(initVolume:Number):void{
			m_oSoundController = new SoundController();
			m_oSoundTransform = m_oSoundController.setVolume(initVolume);
			m_oSound = new Sound( new URLRequest(m_FileName) );
			
			m_oSoundController.addEventListener(PrMediaEvent.MUTE, _eventBubbler, false, 0, true);
			m_oSoundController.addEventListener(PrMediaEvent.UNMUTE, _eventBubbler, false, 0, true);
			m_oSoundController.addEventListener(PrMediaEvent.FADE_COMPLETE, _eventBubbler, false, 0, true);
			m_oSoundController.addEventListener(PrMediaEvent.FADE_STEP, _fadeStep, false, 0, true);
			
			m_oSound.addEventListener(Event.ID3, _eventBubbler, false, 0, true);
		}
		private function _fadeStep(e:PrMediaEvent):void {
			m_oSoundTransform = m_oSoundController.getSoundTransform();
			m_oSoundChannel.soundTransform = m_oSoundTransform;
			dispatchEvent( e );
		}
		
		private function _eventBubbler(e:Event):void {
			switch (e.type)
			{
				case PrMediaEvent.MUTE:
				case PrMediaEvent.UNMUTE:
					_trackEventActivity( e.type.toLowerCase() );
					break;
				case Event.ID3:
					//prevent from dispatching twice (ID3 v1.0 is at the end of the file)
					Sound(e.target).removeEventListener(Event.ID3, _eventBubbler);
					break;
			}
			PrDebug.PrTrace(e.type,3,"PrAudio");
			dispatchEvent( e );
		}
		private function _killCommandHandler(e:Event):void 
		{
			killSound();
		}
	}
	
}