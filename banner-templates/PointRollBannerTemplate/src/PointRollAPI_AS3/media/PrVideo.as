package PointRollAPI_AS3.media 
{
	import PointRollAPI_AS3.ActivityController;
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.errors.PrError;
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;
	import PointRollAPI_AS3.events.net.PrNetEvent;
	import PointRollAPI_AS3.media.delivery.*;
	import PointRollAPI_AS3.util.StringUtil;
	import PointRollAPI_AS3.util.debug.PrDebug;

	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	/**
	 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.START
		 * @see PrVideo#startVideo()
		 * @includeExample ../../examples/media/events/start.txt -noswf
		 */
		[Event(name = "start", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.COMPLETE
		 * @includeExample ../../examples/media/events/complete.txt -noswf
		 */
		[Event(name = "complete", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.ONKILL
		 * @see PrVideo#killVideo()
		 * @includeExample ../../examples/media/PrVideo_killVideo.txt -noswf
		 */
		[Event(name = "onKill", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.PLAY
		 * @see PrVideo#play()
		 * @includeExample ../../examples/media/events/play_pause.txt -noswf
		 */
		[Event(name = "play", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.PAUSE
		 * @see PrVideo#pause()
		 * @includeExample ../../examples/media/events/play_pause.txt -noswf
		 */
		[Event(name = "pause", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.STOP
		 * @see PrVideo#stop()
		 */
		[Event(name = "stop", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.REPLAY
		 * @see PrVideo#replay()
		 * @includeExample ../../examples/media/events/replay.txt -noswf
		 */
		[Event(name = "replay", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.RESTART
		 * @see PrVideo#restart()
		 * @includeExample ../../examples/media/events/stop_restart.txt -noswf
		 */
		[Event(name = "restart", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.ONMETADATA
		 * @includeExample ../../examples/media/PrVideo_metaData.txt -noswf
		 */
		[Event(name = "metaData", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]

		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.ONXMPDATA
		 */
		[Event(name = "xmpData", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]

		/**
		 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.ONCUEPOINT
		 * @includeExample ../../examples/media/events/onCuePoint.txt -noswf
		 */
		[Event(name = "onCuePoint", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.BUFFER_EMPTY
		 * @includeExample ../../examples/media/events/bufferFull_bufferEmpty.txt -noswf
		 */
		[Event(name = "bufferEmpty", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.BUFFER_FULL
		 * @includeExample ../../examples/media/events/bufferFull_bufferEmpty.txt -noswf
		 */
		[Event(name = "bufferFull", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FAILURE
		 * @includeExample ../../examples/media/PrVideo_timeOutDuration.txt -noswf
		 */
		[Event(name = "failure", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.PROGRESS
		 * @includeExample ../../examples/media/events/progress.txt -noswf
		 */
		[Event(name = "progress", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrProgressEvent.OPTIONAL_MILESTONE
		 * @see PrVideo#optionalMilestones
		 * @see PrVideo#resetOptionalMilestones()
		 * @includeExample ../../examples/media/PrVideo_optionalMilestones.txt -noswf
		 */
		[Event(name = "onOptionalMilestone", type = "PointRollAPI_AS3.events.media.PrProgressEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.MUTE
		 * @see PrVideo#volume
		 * @see PrVideo#fadeVolume()
		 * @includeExample ../../examples/media/events/fade_volume.txt -noswf
		 */
		[Event(name = "mute", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.UNMUTE
		 * @see PrVideo#fadeVolume()
		 * @see PrVideo#volume
		 * @includeExample ../../examples/media/events/fade_volume.txt -noswf
		 */
		[Event(name = "unmute", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FADE_COMPLETE
		 * @see PrVideo#fadeVolume()
		 * @includeExample ../../examples/media/events/fade_volume.txt -noswf
		 */
		[Event(name = "fadeComplete", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.FADE_STEP
		 * @see PrVideo#fadeVolume()
		 * @includeExample ../../examples/media/events/fade_volume.txt -noswf
		 */
		[Event(name = "fadeStep", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		/**
		 * @eventType PointRollAPI_AS3.events.media.PrMediaEvent.LOW_BANDWIDTH
		 * @includeExample ../../examples/media/events/lowBandwidth.txt -noswf
		 */
		[Event(name = "lowBandwidth", type = "PointRollAPI_AS3.events.media.PrMediaEvent")]
		
		/**
		 * @eventType PointRollAPI_AS3.events.net.PrNetEvent.ONBWDONE
		 */
		[Event(name = "onBWDone", type = "PointRollAPI_AS3.events.net.PrNetEvent")]
	
		/**
		 * The PrVideo object to deliver both Progressive and Streaming versions of video within your Rich Media ad unit. 
		 * Through the constructor, you will pass in all the arguments necessary for both versions. Note, that simply creating the object 
		 * doesn't start playback; it sets up the object with the appropriate parameters so that you can begin playback at a later point, 
		 * choosing the appropriate method of delivery.
		 * 
		 * Choosing between streaming or progressive is very simple and is accomplished through the <code>startVideo()</code> method:
		 * <code>myVideo.startVideo(nVideoType:Number)</code>
		 * 
		 * Your argument will specify which version you wish to use, it is recommended that you use the provided constants:
		 * <code>PrVideo.STREAMING
		 * PrVideo.PROGRESSIVE</code>
		 * 
		 * The call will default to delivering streaming, as this is what is accepted on the majority of sites.
		 * 
		 * <h1>Replay vs. Restart</h1>
		 * <i>Restart</i>
		 * Restart is essentially a behavior that sends the play head back to the beginning of the movie while it is playing. 
		 * It should only be used during playback of the movie, as it will not fire any milestones that have already been reached. 
		 * Restart is used when we want to mimic a "rewind" type of execution.
		 * 
		 * <code>myVideo.restart();</code>
		 * 
		 * <i>Replay</i>
		 * Replay is executed only after the video has completed fully, and the user wishes to watch the video again.
		 * This action will be tracked as a second independant viewing of the video.
		 * 
		 * <code>myVideo.restart()</code>
		 * @see PrVideo#startVideo()
		 * @see PrVideo#replay()
		 * @see PrVideo#restart()
		 * @see PrVideo#STREAMING
		 * @see PrVideo#PROGRESSIVE
		 */
	public class PrVideo extends EventDispatcher implements IMediaController, IProgressTrackable {
		/** Constant representing streaming video delivery 
		 * @see PrVideo#startVideo()*/
		public static const STREAMING:Number = 1;
		/**Constant representing progressive video delivery 
		 * @see PrVideo#startVideo()*/
		public static const PROGRESSIVE:Number = 2;
		/**@private */
		public static const FORCESTREAMING:Number = 3;
		/**@private */
		public static const FORCEPROGRESSIVE:Number = 4;
		
		/** The bandwidth level detected for this user.  This value is only available when using Streaming video delivery, 
		 * and then, only after the START or LOW_BANDWIDTH events have been broadcast.
		 * @see #event:start
		 * @see #event:lowBandwidth
		 * @includeExample ../../examples/media/PrVideo_userBandwidth.txt -noswf
		 * */
		public var userBandwidth:Number;
		/** When set to <code>true</code> the PrVideo object will automatically fallback to progressive delivery if the streaming connection fails.
		 * @includeExample ../../examples/media/events/lowBandwidth.txt -noswf
		 * */
		public var autoFail:Boolean = true;
		/** The minimum bandwidth required for the user to see the video content. If the user's connection is below this level, 
		 * the <code>lowBandwidth</code> event will be fired and the video will be killed.
		 * @see #event:lowBandwidth
		 * @includeExample ../../examples/media/events/lowBandwidth.txt -noswf
		 * */
		public var minimumBandwidth:Number = 0;
		
		private var _progressFrequency:Number = 250;
		/** Sets the frequency, in milliseconds, at which the <code>progress</code> event will be fired. It is not recommended to set this value lower than 100. Default = 250
		 * @see #event:progress */
		public function get progressFrequency():Number
		{
			return _progressFrequency;
		}
		public function set progressFrequency(n:Number):void
		{
			_progressFrequency = n;
			try{ m_oProgress.frequency = n }catch(e:Error){}
		}
		/** The time, in seconds, to wait before signaling a video connection failure.
		 * @see #event:failure 
		 * @includeExample ../../examples/media/PrVideo_timeOutDuration.txt -noswf
		 * */
		public var timeOutDuration:int = 10;
		/** This property may be set to <code>false</code> if you do not wish to track user activities for this video object.  
		 * The user activities include play, pause, stop, restart, replay, mute and unmute. 
		 * 
		 * If, instead, you wish to limit the amount of tracking used for video playback percentages, use the <code>trackProgress</code> property.
		 * @see PrVideo#trackProgress
		 * @includeExample ../../examples/media/PrVideo_trackEvents.txt -noswf
		 * */
		public var trackEvents:Boolean = true;
		/** Contains any MetaData encoded on the video file.  This property will return <code>null</code> until the <code>metaData</code> 
		 * event has been broadcast.
		 * @see #event:metaData 
		 * @includeExample ../../examples/media/PrVideo_metaData.txt -noswf
		 * */
		public var metaData:Object;
		
		/** Contains any XMPData encoded on the video file.  This property is equivilant to the <code>infoObj.data</code> property 
		 * of the <code>onXMPData</code> callback. This property will return <code>null</code> until the <code>xmpData</code> 
		 * event has been broadcast.  This is a new feature included in preparation for Flash Player 10.
		 * @see #event:xmpData 
		 * */
		public var XMPData:XML;
		
		/** Tells the video to automatically call <code>killVideo()</code> after the <code>onComplete</code> event is fired. 
		 *	@see #event:complete
		 *  @see PrVideo#killVideo()
		 **/
		public var autoKill:Boolean = true;
		private var _autoKillTimer:Timer;
		
		private var m_oActivityControl:ActivityController;
		private var m_aActivities:Object = {play:1001,pause:1002,stop:1006,restart:1003,replay:1007,unmute:1005,mute:1004};
		private var m_oProgress:ProgressTracker;
		private var m_oConfig:Object;
		private var m_oNetStream:NetStream;
		private var m_oNetConnection:NetConnection;
		private var delivery:IVideoDelivery;
		private var m_bForceBuffer:Boolean = false;
		private var m_nTotalTime:Number = 0;
		private var m_nCompleteAt:Number = 0.05;
		private var m_oSoundController:SoundController;

		private var m_nStoredBuffer:Number;
		private var m_TimeOutTimer:Timer;
		private var m_bIsHD:Boolean = false;
		private var m_uHDPreference:uint = HDDelivery.NEVER;
		private var m_bStopInProgress:Boolean = false;
		
		/**
		 * The constructor for the PrVideo object that requires all parameters for both Progressive and Streaming delivery, 
		 * ultimately allowing you to switch between the two depending on publisher, client or creative needs.
		 * @param	sAdvertiserFolder Folder on the streaming server where the streaming content lives. The path will be 
		 * sent to you once your video file is done converting. Generally the same name as the advertiser, (Target, Walmart, etc.)
		 * @param	sBaseProgFilePath The path to your progressive video.  If the video was pushed through AdPortal, this string should be set to: 
		 * <code>/PointRoll/media/videos/[Advertiser]/[Video Name]</code>
		 * The video name referenced above should NOT include the versioning or bitrate ("_8_700k.flv"), as these are added by the API.
		 * If this value is set to <code>null</code>, the default path and <code>sBaseStreamName</code> parameter will be used.
		 * @param	sBaseStreamName The name of the streaming video file
		 * @param	nVideoLenInSecs The length in seconds of the progressive video.  Streaming delivery does not use this value, 
		 * as it is already provided by our servers.  If set to <code>null</code>, the API will use the length provided by the FLV MetaData.
		 * @param	oVideoObject A reference to a <code>Video</code> object on the stage.
		 * @param	nInitVolumeLevel The initial volume of the video (range 0-1)
		 * @param	nVideoInstanceNum The instance number of this video.  If displaying multiple videos within a creative, provide a 
		 * different instance number for each, starting at 1 and progressing upwards.
		 * <b>Note:</b> If you set the instance number to 0, all tracking (user events and progress) will be turned off for this video.  This is useful for videos that play automatically, or on a loop.
		 * @param	nServerIndex If instructed by PointRoll, you may set this value to a specific streaming server index.
		 * @includeExample ../../examples/media/PrVideo_constr.txt -noswf
		 */
		public function PrVideo(sAdvertiserFolder:String,sBaseProgFilePath:String,sBaseStreamName:String,nVideoLenInSecs:Number,oVideoObject:DisplayObject,nInitVolumeLevel:Number,nVideoInstanceNum:Number=1,nServerIndex:Number=0)
		{
			//init activity controller and statemanager
			if( oVideoObject.stage != null){
				m_oActivityControl = ActivityController.getInstance(oVideoObject);
			}else{
				oVideoObject.addEventListener(Event.ADDED_TO_STAGE, _initActivityObject, false,0,true)
				oVideoObject.addEventListener(Event.ADDED, _initActivityObject, false,0,true)
			}
			
			//record configuration data
			m_oConfig = {
				advertiser:sAdvertiserFolder,
				progressiveFile: sBaseProgFilePath != null ? sBaseProgFilePath : sBaseStreamName,
				progressiveLength: nVideoLenInSecs,
				streamingFile: sBaseStreamName,
				videoObj: oVideoObject,
				volume: nInitVolumeLevel,
				instanceNum: (nVideoInstanceNum - 1) + 20,
				server: StateManager.URLParameters.prVidIndex == undefined ? nServerIndex : StateManager.URLParameters.prVidIndex 
			};
			
			m_nTotalTime = nVideoLenInSecs;
			//init sound control
			_initSound();
			
			//prepare ProgressTracker
			m_oProgress = new ProgressTracker(this, progressFrequency);
			m_oProgress.addEventListener(PrProgressEvent.PROGRESS, _onProgress, false,0,true);
			
			if ( nVideoInstanceNum == 0 )
			{
				trackEvents = false;
				trackProgress = 0;
			}
			
			//Listen for kill command and perform cleanup as needed
			StateManager.addEventListener(StateManager.KILL, _killCommandHandler, false, 0, true);
			
		}
		
		/**
		 * Initiates video playback.
		 * @param	deliveryType The desired delivery method, either <code>PrVideo.STREAMING</code> or <code>PrVideo.PROGRESSIVE</code>
		 * @param	useHD This optional parameter allows you to sepcify your HD delivery preference.  The default value is "never" which will 
		 * only deliver standard definition video.  For complete details on the available settings, see the HDDelivery class.  
		 * @see PrVideo#STREAMING
		 * @see PrVideo#PROGRESSIVE
		 * @see PointRollAPI.media.HDDelivery
		 * @see #event:start
		 * @throws PointRollAPI_AS3.errors.PrError If an invalid delivery type is specified
		 * @includeExample ../../examples/media/events/start.txt -noswf
		 */
		public function startVideo( deliveryType:Number=STREAMING, useHD:uint=HDDelivery.NEVER):void
		{
			if ( StateManager.URLParameters.prVidMethod != undefined && deliveryType < 3)
			{
				deliveryType = StateManager.URLParameters.prVidMethod;
			}
			if ( StateManager.URLParameters.prAutoFail != undefined)
			{
				autoFail = StateManager.URLParameters.prAutoFail == 1? true:false;
			}
			if ( StateManager.URLParameters.prVidHD != undefined && useHD != HDDelivery.FAIL )
			{
				useHD = StateManager.URLParameters.prVidHD as uint;
			}
			
			if ( deliveryType > 1 )
			{
				//special case: HD Progressive can fail to standard progressive, so dont modify the autoFail preference
				if ( !( useHD == HDDelivery.IF_AVAILABLE && (deliveryType == PROGRESSIVE || deliveryType == FORCEPROGRESSIVE)))
				{
					autoFail = false;
				}				
			}
			//record current delivery type
			m_oConfig.deliveryType = deliveryType; 
			m_uHDPreference = useHD;
			if ( StateManager.HDEnabled && useHD != HDDelivery.NEVER && useHD != HDDelivery.FAIL)
			{
				m_bIsHD = true;
			}
			
			//fail if HD=always and user cannot support it
			if ( m_uHDPreference == HDDelivery.ALWAYS && !StateManager.HDEnabled)
			{
				PrDebug.PrTrace("Flash Player version does not support HD",3,"PrVideo");
				dispatchEvent(new PrMediaEvent(PrMediaEvent.FAILURE));
				return;
			}
			
			switch( deliveryType )
			{
				case STREAMING:
				case FORCESTREAMING:
					PrDebug.PrTrace("Streaming Delivery", 1, "PrVideo")
					if (m_bIsHD && minimumBandwidth == 0)
					{
						//set the min BW to the HD level
						minimumBandwidth = HDDelivery.MINBANDWIDTH;
					}
					delivery = new StreamingVideo( m_oConfig.advertiser, m_oConfig.streamingFile, m_oConfig.server, minimumBandwidth, m_bIsHD );
					//begin time out countdown
					if ( StateManager.URLParameters.prTimeOut != undefined )
					{
						timeOutDuration = StateManager.URLParameters.prTimeOut;
					}
					m_TimeOutTimer = new Timer( timeOutDuration * 1000);
					m_TimeOutTimer.addEventListener(TimerEvent.TIMER, _failOver, false,0,true);
					m_TimeOutTimer.start();
					break;
				case PROGRESSIVE:
				case FORCEPROGRESSIVE:
					PrDebug.PrTrace("Progressive Delivery",1,"PrVideo");
					delivery = new ProgressiveVideo( m_oConfig.advertiser, m_oConfig.progressiveFile, m_bIsHD );
					break;
				default:
					throw( new PrError(PrError.INVALID_DELIVERY) );
			}
			//delivery.addEventListener(PrNetEvent.ONBWDONE, _recordConnectionActivity);
			delivery.addEventListener(PrNetEvent.NCFAIL, _failOver, false,0,true);
			delivery.addEventListener(PrNetEvent.NSREADY, _playVideo, false,0,true);
			delivery.addEventListener(PrNetEvent.ONBWDONE, _bandwidthDone, false,0,true);
			//delivery.addEventListener(PrMediaEvent.LOW_BANDWIDTH, _lowBandwidth, false,0,true);
			delivery.init();	
		}
		/**
		 * Closes the NetStream and NetConnection objects associated with this video. Calling this function should be 
		 * standard practice when video playback is complete, unless the creative needs dictate otherwise.
		 * @see #event:onKill
		 * @includeExample ../../examples/media/PrVideo_killVideo.txt -noswf
		 */
		public function killVideo():void
		{
			try{
				m_oNetStream.close();
				m_oNetStream = null;
			}catch(e:Error) {	}
			try{
				m_oNetConnection.close();
				m_oNetConnection = null;
			}catch(e:Error) {	}
			try{
				m_TimeOutTimer.stop();
				m_TimeOutTimer.removeEventListener(TimerEvent.TIMER, _failOver);
				m_TimeOutTimer = null;
			}catch (e:Error) { }
			try
			{
				delivery.cleanUp();
				delivery = null;
			}catch (e:Error){}
			m_bIsHD = false;
			
			StateManager.removeEventListener(StateManager.KILL, _killCommandHandler);
			dispatchEvent(new PrMediaEvent(PrMediaEvent.ONKILL));
		}
		
		//IMediaController Interface
		
		/**
		 * @see #event:play
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/play_pause.txt -noswf
		 */
		public function play():void
		{
			if(!isPlaying)
			{		
				_trackEventActivity("play"); 
				buffer = 0.10; //short buffer to allow for quick-resume
				m_oNetStream.resume();
				dispatchEvent(new PrMediaEvent(PrMediaEvent.PLAY));
			}
		}
		/**
		 * @see #event:pause
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/play_pause.txt -noswf
		 */
		public function pause():void{
			if(isPlaying)
			{
				m_oNetStream.pause();
				_trackEventActivity("pause");
				dispatchEvent(new PrMediaEvent(PrMediaEvent.PAUSE));
			}
		}
		/**
		 * @see #event:stop
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/stop_restart.txt -noswf
		 */
		public function stop():void{
			if(isPlaying)
			{
				//performing a seek(0) inadvertantly fires a Netstream.Play event, which turns play tracking back on. This flag prevents that behavior.
				m_bStopInProgress = true;
				m_oNetStream.pause(); 
				m_oNetStream.seek(0);
				_trackEventActivity("stop");
				dispatchEvent(new PrMediaEvent(PrMediaEvent.STOP));
			}
		}
		/**
		 * @see #event:restart
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/stop_restart.txt -noswf
		 */
		public function restart(withSound:Boolean=false) :void{
			if(_autoKillTimer) _preventAutoKill();
			if(isPlaying){
				m_oNetStream.seek(0);
			}else{
				m_oNetStream.resume();
				m_oNetStream.seek(0);
			}
			if( withSound ){
				m_oConfig.volume = 1;
				m_oNetStream.soundTransform = m_oSoundController.setVolume(1);
			}
			_trackEventActivity("restart");
			dispatchEvent(new PrMediaEvent(PrMediaEvent.RESTART));
		}
		/**
		 * @see #event:replay
		 * @inheritDoc
		 */
		public function replay():void {
			if(_autoKillTimer) _preventAutoKill();
			_trackEventActivity("replay");
			killVideo();
			resetOptionalMilestones();
			m_oProgress.resetStandardMilestones();
			startVideo(m_oConfig.deliveryType, m_uHDPreference);
			dispatchEvent(new PrMediaEvent(PrMediaEvent.REPLAY));
		}
		/**
		 * @see #event:onOptionalMilestone
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrVideo_resetOptionalMilestones.txt -noswf
		 */
		public function resetOptionalMilestones():void{
			m_oProgress.resetOptionalMilestones();
		}
		/**
		 * @see #event:fadeStep
		 * @see #event:fadeComplete
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/fade_volume.txt -noswf
		 */
		public function fadeVolume( newVolume:Number, seconds:Number ):void
		{
			PrDebug.PrTrace("Fade Vol", 5, "PrVideo.as");
			m_oSoundController.addEventListener(PrMediaEvent.FADE_COMPLETE, _eventBubbler, false, 0, true);
			m_oSoundController.addEventListener(PrMediaEvent.FADE_STEP, _fadeStep, false, 0, true);
			m_oSoundController.fadeVolume(newVolume, seconds);
		}
		/**
		 * @copy SoundController#getFadeDirection()
		 * @return
		 */
		public function getFadeDirection():String
		{
			return m_oSoundController.getFadeDirection();
		}
		
		/**
		 * This method is used to set a custom SoundTransform object to be used by the PrVideo object for advanced audio manipulation to create a more 
		 * interactive audio experience in an ad unit, such as panning between left and right channels and advanced volume control. The <code>getSoundTransform()</code> method can 
		 * be used to access the PrVideo object's SoundTransform object, providing access to all methods and properties of the SoundTransform object.
		 * @param	st A designer-specified SoundTransform object.
		 * @see PrVideo#getSoundTransform()
		 * @includeExample ../../examples/media/PrVideo_soundTransform.txt -noswf
		 */
		public function setSoundTransform(st:SoundTransform):void
		{
			m_oSoundController.setSoundTransform(st);
			m_oNetStream.soundTransform = m_oSoundController.getSoundTransform();
		}
		
		/**
		 * This method returns a reference to the SoundTransform object used by the PrVideo object, providing access to all 
		 * methods and properties of the SoundTransform object for advanced audio manipulation to create a more interactive audio experience 
		 * in an ad unit.
		 * @return a reference to the SoundTransform object used by the PrVideo instance
		 * @see PrVideo#setSoundTransform()
		 * @includeExample ../../examples/media/PrVideo_soundTransform.txt -noswf
		 */
		public function getSoundTransform():SoundTransform
		{
			return m_oSoundController.getSoundTransform();
		}
		
		/**
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrVideo_seek.txt -noswf
		 */
		public function seek(n:Number):void
		{
			if(_autoKillTimer) _preventAutoKill();
			try
			{
				m_oNetStream.seek(n);
			}catch (e:Error)
			{
				PrDebug.PrTrace("Unable to seek.  Call startVideo() first", 1, "PrVideo");
			}
		}
		/**
		 * This function allows you to attach or detach the video stream from your Video object.  This helps to address a problematic 
		 * security issue when attempting to capture BitmapData from a streaming video.  Certain versions of Flash Media Server require 
		 * server-side security allowances before granting a SWF access to the BitmapData of a video stream.  In the situations where that 
		 * allowance is not available, the BitmapData can be accessed from the Video object only after detaching the video stream.
		 * <p>By toggling the video stream on and off rapidly, you can capture the BitmapData you need from the Video object, without affecting 
		 * the video playback or throwing security errors.  This is especially useful when attempting to use PaperVision with video streams.</p>
		 * <p>For more details, review the example below.</p>
		 * @param	on Set to <code>true</code> to attach the video stream, and <code>false</code> to detatch it.
		 */
		public function toggleStream(on:Boolean):void
		{
			on ? m_oConfig.videoObj.attachNetStream(m_oNetStream):m_oConfig.videoObj.attachNetStream(null);
		}
		/**
		 * @see PrVideo#totalTime
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/complete.txt -noswf
		 */
		public function get currentTime():Number
		{ 
			var t:Number = 0;
			try
			{
				t = m_oNetStream.time;
			}catch (e:Error)
			{
				PrDebug.PrTrace("Unable to get currentTime.  Call startVideo() first", 1, "PrVideo");
			}
			return t;
		}
		/**
		 * @see PrVideo#currentTime
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrVideo_totalTime.txt -noswf
		 */
		public function get totalTime():Number
		{
			return m_nTotalTime - m_nCompleteAt;
		}
		/**
		 * @see PrVideo#bytesTotal
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrVideo_bytesLoaded.txt -noswf
		 */
		public function get bytesLoaded():uint
		{
			var b:uint = 0;
			try
			{
				b = m_oNetStream.bytesLoaded;
			}catch (e:Error)
			{
				PrDebug.PrTrace("Unable to get bytesLoaded.  Call startVideo() first", 1, "PrVideo");
			}
			return b;
		}
		/**
		 * @see PrVideo#bytesLoaded
		 * @inheritDoc
		 * @includeExample ../../examples/media/PrVideo_bytesLoaded.txt -noswf
		 */
		public function get bytesTotal():uint
		{
			var b:uint = 1;
			try
			{
				b = m_oNetStream.bytesTotal;
			}catch (e:Error)
			{
				PrDebug.PrTrace("Unable to get bytesTotal.  Call startVideo() first", 1, "PrVideo");
			}
			return b;
		}
		
		public function set volume( n:Number ):void {
			var s:SoundTransform = m_oSoundController.setVolume(n);
			m_oConfig.volume = n;
			try
			{
				m_oNetStream.soundTransform = s;
			}catch (e:Error)
			{
				//no trace needed
			}
		}
		/**
		 * @see #event:mute
		 * @see #event:unmute
		 * @inheritDoc
		 * @includeExample ../../examples/media/events/fade_volume.txt -noswf
		 */
		public function get volume():Number{
			return m_oSoundController.getVolume();
		}
		public function set optionalMilestones( a:Array ):void
		{
			//makes a copy of the array
			m_oProgress.optionalMilestones = a.slice();
		}
		/**
		 * @see #event:onOptionalMilestone
		 * @includeExample ../../examples/media/PrVideo_optionalMilestones.txt -noswf
		 * @inheritDoc
		 */
		public function get optionalMilestones():Array
		{
			return m_oProgress.optionalMilestones
		}
		///////// End IMediaController /////////////
		
		
		/**
		 * Controls the level of progress tracking employed for this video.
		 * 
		 * A key metric related to video is the tracking of playback progress. PointRoll by default reports back on 
		 * the viewing of: 0%, 25%, 50%, 75% and 100% playback. In some situations however, these metrics may not be of 
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
		 * @includeExample ../../examples/media/PrVideo_trackProgress.txt -noswf
		 */
		public function set trackProgress( level:uint ):void
		{
			m_oProgress.trackProgress = level;
		}
		
		/**
		 * The number of seconds before the end of the video at which to fire the <code>complete</code> event.
		 * 
		 * You may set this property to more accurately control when the onComplete event is fired.  If this value is set,
		 * <code>complete</code> will be triggered when the <code>currentTime</code> property is within the provided number 
		 * of seconds of <code>totalTime</code>.
		 * 
		 * If you have a 10 second video clip, but you wish the <code>complete</code> event to fire at 9 seconds, you 
		 * would set the <code>completeAt</code> property to 1. (10 - 9 = 1)
		 * 
		 * The default value is 0.05 seconds.
		 * 
		 * <b>Note:</b> Setting this value only controls the time at which the <code>complete</code> event is fired, it will NOT cause 
		 * the playback to stop if there is more content to be played.
		 * 
		 * @see PrVideo#currentTime
		 * @see PrVideo#totalTime
		 * @see PrVideo#complete
		 * @throws PointRollAPI_AS3.errors.PrError If the completeAt value is greater than the length of the video
		 * @includeExample ../../examples/media/events/complete.txt -noswf
		 */
		public function set completeAt(n:Number):void
		{
			if ( n >= m_nTotalTime )
			{
				throw(new PrError(PrError.COMPLETE_AT));
				return;
			}
			m_nCompleteAt = n;
		}
		/**
		 * Number of seconds-worth of video content to download before initiating playback.
		 * You may set this property to force the video to delay playback until the buffer has 
		 * enough data to play the specified number of seconds without interruption.
		 * <br/>
		 * This property is useful if you wish the user to see the first few seconds of the video without any stuttering.  
		 * However, the user may have to wait for the video to download, depending on connection speed.
		 * <br/>This property may be automatically overridden depending on the user's bandwidth.  To prevent the API
		 * from changing this value, use <code>forceBuffer</code> instead.
		 * @see PrVideo#forceBuffer
		 * @includeExample ../../examples/media/PrVideo_buffer.txt -noswf
		 */
		public function set buffer( seconds:Number ):void
		{
			if ( isNaN(seconds) ) {
				seconds = 0.10;
			}
			if(!m_bForceBuffer){
				
				try {
					m_oNetStream.bufferTime = seconds;
					PrDebug.PrTrace("Buffer is set at: "+seconds+" seconds",3,"PrVideo");
				}catch (e:Error) {
					//If this property is set before the NS is ready, store it for later
					PrDebug.PrTrace("NetStream unavailable for buffering - store value", 5, "PrVideo");
					m_nStoredBuffer = seconds; 
				}
			}else{
				PrDebug.PrTrace("Cannot set buffer - has been forced",3,"PrVideo");
			}
		}
		/**
		 * Forces the video buffer to the specified size.  Once set, this value can only be changed by 
		 * the designer (the API will not adjust it based on bandwidth detection).
		 * @see PrVideo#buffer
		 * @includeExample ../../examples/media/PrVideo_forceBuffer.txt -noswf
		 */
		public function set forceBuffer( n:Number ):void
		{
			buffer = n;
			m_bForceBuffer = true;
		}
		/** 
		 * Returns <code>true</code> if the video is currently playing, <code>false</code> otherwise.
		 * @includeExample ../../examples/media/PrVideo_isPlaying.txt -noswf
		 */
		public function get isPlaying():Boolean
		{
			return m_oProgress.isTracking
		}
		
		/**
		 * Returns <code>true</code> if the currently playing video is in High Definition.
		 */
		public function get isHD():Boolean
		{
			return m_bIsHD;
		}
		
		/**
		 * Returns <code>true</code> if the user's Flash Player is capable of delivering High Definition video. 
		 * <p>The minimum Flash Player version required is 9,0,115,0. The build version (115) <i>does</i> matter, as earlier builds of Flash Player 9 do not support the H264 codec.</p>
		 * @see HDDelivery
		 */
		public function get HDCapable():Boolean
		{
			return StateManager.HDEnabled;
		}
		////////////////////////////////
		//  NetStream Callbacks      //
		
		/** @private */
		public function onCuePoint(infoObj:Object):void
		{
			var event:PrProgressEvent = new PrProgressEvent(PrProgressEvent.ONCUEPOINT);
			event.setTarget(this);
			event.cuePoint = infoObj;
			PrDebug.PrTrace("CuePoint Reached: " + infoObj.time, 3, "PrVideo");
			
			dispatchEvent(event)
		}
		/** @private */
		public function onXMP(infoObj:Object):void
		{
			PrDebug.PrTrace("onXMPData", 4, "PrVideo");
			XMPData = new XML(infoObj.data);
			dispatchEvent( new PrMediaEvent(PrMediaEvent.ONXMPDATA) );
		}
		/** @private */
		public function onXMPData(infoObj:Object):void
		{
			PrDebug.PrTrace("onXMPData", 4, "PrVideo");
			XMPData = new XML(infoObj.data);
			dispatchEvent( new PrMediaEvent(PrMediaEvent.ONXMPDATA) );
		}
		/** @private */
		public function onMetaData(infoObj:Object):void
		{
			PrDebug.PrTrace("onMetaData",4,"PrVideo");
			metaData = infoObj;
			//if we have an invalid total time, use the MetaData value
			if( isNaN(m_nTotalTime) || m_nTotalTime <= 0){
				m_nTotalTime = infoObj.duration;
				PrDebug.PrTrace("Using MetaData duration: "+m_nTotalTime,4,"PrVideo");
			}
			dispatchEvent( new PrMediaEvent(PrMediaEvent.ONMETADATA) );
			
		}
		/** @private */
		public function onPlayStatus(e:Object):void
		{
			switch (e.code)
			{
				case "NetStream.Play.Complete":
					PrDebug.PrTrace("Video Playback Complete");
					break;
				case "NetStream.Play.Switch":
					PrDebug.PrTrace("Video Playlist Switch");
					break;
				default:
					PrDebug.PrTrace("Unknown Video Play Status");
			}
		}
		/********************************/
		
		//// PRIVATE ///
		/*
		 * Called once the NSREADY event is broadcast from the  IVideoDelivery instance.  Only occurs for a new connection
		 * - Fires start activity - based on bandwidth profile when using streaming delivery
		 * @param e PrMediaEvent.NSREADY dispatched from an instance of IVideoDelivery
		 * */
		private function _playVideo( e:PrNetEvent ):void
		{
			
			
			m_oNetStream = e.infoObj.NS as NetStream;
			m_oNetConnection = e.infoObj.NC as NetConnection;
			
			
			if ( m_oConfig.deliveryType == STREAMING || m_oConfig.deliveryType == FORCESTREAMING)
			{
				//set total time as value from FMS
				m_nTotalTime = e.infoObj.totalTime;
				m_TimeOutTimer.stop();
				m_TimeOutTimer.removeEventListener(TimerEvent.TIMER, _failOver);
				m_TimeOutTimer = null;
			}
			

			//track starting activity
			var startActivity:Number = Number( "-1" + m_oConfig.instanceNum + "6");
			if ( isHD )
			{
				startActivity = Number( "-1" + m_oConfig.instanceNum + "7");
			}
			if(m_oConfig.deliveryType == STREAMING)
			{
				//the streaming start activity varies by bandwidth profile
				startActivity = Number( StringUtil.insertion( e.infoObj.profile.activity, m_oConfig.instanceNum ) ); 
			}
			if(m_oProgress.trackProgress > 0) m_oActivityControl.activity(startActivity);
		
			//prepare listeners and callback client
			m_oNetStream.addEventListener(NetStatusEvent.NET_STATUS, _netStreamStatus, false,0,true);
			m_oNetStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler, false,0,true);
			m_oNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _errorHandler, false,0,true);
			m_oNetStream.addEventListener(IOErrorEvent.IO_ERROR, _errorHandler, false, 0, true);
			m_oNetStream.client = this;
			
			m_oNetConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler, false,0,true);
			m_oNetConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _errorHandler, false,0,true);
			
			try { 
				m_oNetStream.bufferTime = m_nStoredBuffer;
				PrDebug.PrTrace("Apply Stored Buffer Value: "+m_oNetStream.bufferTime,5,"PrVideo");
				}catch(e:Error){/*No stored buffer value*/}
			
			//prepare sound
			PrDebug.PrTrace("Set VOL: " + m_oConfig.volume,3,"PrVideo");
			m_oNetStream.soundTransform = m_oSoundController.setVolume( m_oConfig.volume );
			
			//attach stream and play
			m_oConfig.videoObj.attachNetStream(m_oNetStream);
			m_oNetStream.play(e.infoObj.file);
			
			if (autoKill)
			{
				this.addEventListener(PrMediaEvent.COMPLETE, _autoKillHandler);
			}
		}
		
		private function _errorHandler(e:Event):void 
		{
			PrDebug.PrTrace("NetStream"
			+ "Error: " + e.toString(), 5, "PrVideo");
			_eventBubbler(e);
		}
		
		private function _netStreamStatus(e:NetStatusEvent):void{
			var statusCode:String = e.info.code;
			switch( statusCode ){
				case "NetStream.Play.Start":
					if (m_bStopInProgress)
					{
						m_bStopInProgress = false;
					}else{
						//Begin Progress Monitoring Only If Video Starts
						m_oProgress.start();
					}
					break
				case "NetStream.Buffer.Empty":
					//Buffer Empty
					PrDebug.PrTrace("Buffer Empty", 3, "PrVideo");
					if(m_oNetStream.bufferTime > 5){
						PrDebug.PrTrace("Fix Buffer", 3, "PrVideo");
						buffer = 1;
					}
					dispatchEvent( new PrMediaEvent( PrMediaEvent.BUFFER_EMPTY) );
					break;
				case "NetStream.Buffer.Full":
					//Buffer Full
					PrDebug.PrTrace("Buffer Full", 3, "PrVideo");
					//Check if user is over 300k, and then set buffer up:
					if(userBandwidth >= 300){
						PrDebug.PrTrace("Dynamic Buffering", 3, "PrVideo");
						if(userBandwidth >= 1500){
							PrDebug.PrTrace("3rd Level Buffer", 3, "PrVideo"); 
							buffer = 5;
						}else{
							PrDebug.PrTrace("2nd Level Buffer", 3, "PrVideo");
							buffer = Math.floor(m_nTotalTime * .25);
						}
						
					}
					dispatchEvent( new PrMediaEvent( PrMediaEvent.BUFFER_FULL) );
					break;
				case "NetStream.Play.StreamNotFound":
					//Failed
					PrDebug.PrTrace("Stream Not Found", 3, "PrVideo");
					_failOver(e);
					break;
				case "NetStream.Play.Failed":
					//Failed
					PrDebug.PrTrace("Stream Play Failed: "+e.info.description, 3, "PrVideo");
					_failOver(e);
					break;
				default:
					PrDebug.PrTrace(statusCode,5,"PrVideo")
			}
		}//end _netStreamStatus
		
		 private function _securityErrorHandler(event:SecurityErrorEvent):void {
            PrDebug.PrTrace("*** NetStream Security Error: " + event);
        }
		
		private function _initActivityObject(e:Event):void{
			//the video has been added to the stage after creation of the PrVideo object, establish the ad state
			m_oActivityControl = ActivityController.getInstance(e.target as DisplayObject);
			e.target.removeEventListener(Event.ADDED_TO_STAGE, _initActivityObject)
			e.target.removeEventListener(Event.ADDED, _initActivityObject)
		}
		
		
		private function _onProgress(e:PrProgressEvent):void
		{
			if (e.milestone > -1 )
			{
				//we have reached a playback milestone
				m_oActivityControl.activity( Number("-"+m_oConfig.instanceNum + (e.milestone/25)) )
			}
			dispatchEvent(e);		
		}
		
		
		private function _trackEventActivity( name:String ):void
		{
			if ( trackEvents )
			{
				PrDebug.PrTrace("Track Media Event: "+name,1,"PrVideo");
				m_oActivityControl.activity(m_aActivities[name]);
			}
		}
		
		private function _failOver(e:Event):void
		{
			try {
				m_TimeOutTimer.stop();
				m_TimeOutTimer.removeEventListener(TimerEvent.TIMER, _failOver);
			}catch (e:Error) { }
			if ( autoFail )
			{
				if ( isHD )
				{
					_HDFailPath();
				}else
				{
					PrDebug.PrTrace("Streaming Connection Failed - Try Progressive", 3, "PrVideo");
					killVideo();
					startVideo(FORCEPROGRESSIVE);
				}
			}else {
				PrDebug.PrTrace("Video Failure",3,"PrVideo");
				dispatchEvent(new PrMediaEvent(PrMediaEvent.FAILURE));
			}
		}
		
		private function _HDFailPath():void
		{
			if (m_oConfig.deliveryType == STREAMING || m_oConfig.deliveryType == FORCESTREAMING)
			{
				//HD preference allows us to kick to standard streaming
				if (m_uHDPreference == HDDelivery.IF_AVAILABLE)
				{
					PrDebug.PrTrace("HD Streaming Connection Failed - Try SD Streaming Connect", 3, "PrVideo");
					m_bIsHD = false;
					killVideo();
					startVideo(STREAMING, HDDelivery.FAIL);
				}else
				{
					//HD preference forces delivery of HD Progressive as failover
					PrDebug.PrTrace("HD Streaming Connection Failed - Try HD Progressive", 3, "PrVideo");
					killVideo();
					startVideo(PROGRESSIVE, HDDelivery.ALWAYS);
				}
			}else
			{
				if (m_uHDPreference == HDDelivery.IF_AVAILABLE)
				{
					//HD preference allows delivery of Standard Progressive as failover
					PrDebug.PrTrace("HD Progressive Failed - Try Standard Progressive", 3, "PrVideo");
					killVideo();
					startVideo(PROGRESSIVE, HDDelivery.FAIL);
				}else
				{
					PrDebug.PrTrace("Video Failure: HD Progressive File Missing",3,"PrVideo");
					dispatchEvent(new PrMediaEvent(PrMediaEvent.FAILURE));
				}
			}
		}
		
		private function _bandwidthDone(e:PrNetEvent):void
		{
			delivery.removeEventListener(PrNetEvent.ONBWDONE, _bandwidthDone);
			userBandwidth = e.infoObj as Number;
			_eventBubbler(e); 
			
			if (userBandwidth < minimumBandwidth)
			{
				PrDebug.PrTrace("Low Bandwidth", 4, "PrVideo");
				if ( isHD )
				{
					if(minimumBandwidth == HDDelivery.MINBANDWIDTH) minimumBandwidth = 0;
					_HDFailPath();
				}else
				{
					killVideo();
					dispatchEvent(new PrMediaEvent(PrMediaEvent.LOW_BANDWIDTH));
				}
			}
		}
		
		private function _eventBubbler(e:Event):void {
			switch (e.type)
			{
				case PrMediaEvent.MUTE:
				case PrMediaEvent.UNMUTE:
					_trackEventActivity( e.type.toLowerCase() );
					break;
				case PrMediaEvent.FADE_COMPLETE:
					volume = m_oSoundController.getVolume();
					break;
				case PrMediaEvent.FADE_COMPLETE:
					m_oSoundController.removeEventListener(PrMediaEvent.FADE_COMPLETE, _eventBubbler);
					m_oSoundController.removeEventListener(PrMediaEvent.FADE_STEP, _fadeStep);
					break;
			}
			dispatchEvent( e );
		}
		
		private function _initSound():void{
			m_oSoundController = new SoundController();
			m_oSoundController.addEventListener(PrMediaEvent.MUTE, _eventBubbler, false, 0, true);
			m_oSoundController.addEventListener(PrMediaEvent.UNMUTE, _eventBubbler, false, 0, true);
		}
		
		private function _fadeStep(e:PrMediaEvent):void {
			try
			{
				m_oNetStream.soundTransform = m_oSoundController.getSoundTransform();
			}catch (e:Error)
			{
				PrDebug.PrTrace("Cannot fade volume.  Call startVideo() first", 1, "PrVideo");
			}
			_eventBubbler(e);
		}
		
		private function _killCommandHandler(e:Event):void 
		{
			if (e.target is Timer)
			{
				Timer(e.target).stop();
				Timer(e.target).removeEventListener(TimerEvent.TIMER, _killCommandHandler);
				e = null;
			}
			killVideo();
		}
		
		private function _autoKillHandler(e:Event):void
		{
			this.removeEventListener(PrMediaEvent.COMPLETE, _autoKillHandler);
			_autoKillTimer = new Timer(5000, 1);
			_autoKillTimer.addEventListener(TimerEvent.TIMER, _killCommandHandler);
			_autoKillTimer.start();
		}
		
		/** In the event of a 'replay' or 'restart' following the complete event, this function prevents the autoKill from taking place **/
		private function _preventAutoKill():void
		{
			if(_autoKillTimer)
			{
				try{
					_autoKillTimer.addEventListener(TimerEvent.TIMER, _killCommandHandler);
					_autoKillTimer.stop();
					_autoKillTimer = null;					
				}catch(e:Error){}
			}
		}
	}
	
}
