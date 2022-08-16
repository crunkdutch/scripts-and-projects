/**
 * PointRoll Video Display Component
 * 
 * Plays a list of video ads provided by user
 * 
 * @class 		PRVideoDisplay
 * @package		PointRollAPI.components.video
 * @author		PointRoll
 */
 
 
 /**
 *	List of exposed properties 
 *	--------------------------
 *	sourceString				Implemented for UX
 *	adFolderName				Name of the folder from PointRoll
 *	initialVolume				InitialVolume of playback. A valid value from 0 to 100. Default is 0
 *	trackPlaybackProgress		Tells PointRoll Class to track playback activity
 *	trackUserControls			Tells PointRoll Class to track control activity
 *	videoFileNames				List of Video file names
 *	videoWidths					List of Video widths
 *	videoHeights				List of Video heights
 *	videoLengths				List of Video lengths
 *	videoInstanceNumbers		List of Video instance numbers
 *	videoTypes					List of Video delivery types. Streaming (0), Progressive (1)
 *	videoHDs					List of Video qualities. Server (0), Use HD (1)
 *	
 *
 *
 */

  /**
 *	List of exposed properties via AS
 *	---------------------------------
 *	autoFail
 *	bandwidth
 *	borderBottom
 *	borderLeft
 *	borderRight
 *	borderTop  
 *	borderThickness
 *	bytesLoaded
 *	bytesTotal
 *	completeAt
 *	currentTime
 *	forceBuffer
 *	HDCapable
 *	isHD
 *	isPlaying
 *	killBorder
 *	minimumBandwidth
 *	optionalMilestones
 *	percentLoaded
 *	percentPlayed
 *	smooth
 *	timeOutDuration
 *	totalTime
 *	trackEvents
 *	trackProgress
 *	volume
 *
 *
 */
  
 /**
 *	List of exposed methods 
 *	--------------------------
 *	
 *	setAdFolderName
 *	getAdFolderName
 *	setInitialVolume
 *	getInitialVolume
 *	setTrackPlaybackProgress
 *	getTrackPlaybackProgress
 *	setTrackUserControls
 *	getTrackUserControls
 *	setVideoFileNames
 *	getVideoFileNames
 *	setVideoWidths
 *	getVideoWidths
 *	setVideoHeights
 *	getVideoHeights
 *	setVideoLengths
 *	getVideoLengths
 *	getLength
 *	setVideoInstanceNumbers
 *	getVideoInstanceNumbers
 *	setVideoTypes
 *	getVideoTypes
 *	setVideoHDs
 *	getVideoHDs
 *	setBufferTime
 *	addVideo
 *	pushVideo
 *	play
 *	startVideo
 *	startVideoById
 *	stop
 *	kill
 *	pause
 *	setVolume
 *	getVolume
 *	mute
 *	unmute
 *	fastForward
 *	rewind
 *	replay
 *	isPaused
 *	seek
 *	clearForceBuffer
 *	fadeInSound
 *	fadeOutSound
 *	resetMilestones
 *	restart
 *
 */
 
package PointRollAPI_AS3.components.video 
{
	import PointRollAPI_AS3.PointRoll;
	import PointRollAPI_AS3.events.components.PrComponentEvent;
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;
	import PointRollAPI_AS3.media.HDDelivery;
	import PointRollAPI_AS3.media.PrVideo;

	import String;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;

	//PointRoll imports

	[InspectableList("sourceString")]
	/** @private **/
	public class PRVideoDisplay extends MovieClip {
		
		//internal use, needed for component structure
		public static var symbolName:String = "PRVideoDisplay";
    	public static var symbolOwner:Object = PointRollAPI_AS3.components.video.PRVideoDisplay;
	
		public static var SOURCE_STRING_CHAR_0:String = "^";

		//error handling
		private var initErrors:Boolean = false;
		private var epr:String = "VDC > ";
	
		//exclusive for the component
		private var depth:uint = 0;
		private var bufferTime:int = 5;
		private var actualVideo:uint = 0;
		private var actualVolume:Number = 0;
		private var oldVolume:Number = 0;
		private var timerNotify:Timer;
		private var bufferProperties:BufferProperties;
		private var _isStreaming:Number = 0;
	
		//internal references for video resizing
		private var __width:Number = 0; 
		private var __height:Number = 0;
		private var __playing:Boolean = false;
		private var __paused:Boolean = false;
		private var __fading:Boolean = false;

	
		//PointRoll vars
		private var pointRollVideo:PrVideo;
		private var pointRoll:PointRoll;

		private var videoDisplay:MovieClip;
		private var __sourceString:String = "";
	
		[Inspectable(name = "sourceString", variable="sourceString", category = "General",defaultValue = "",type=String)]
		private var _sourceString:			String = "";
		public function set sourceString(sourceString:String):void {
			_sourceString = sourceString;
		}
		public function get sourceString():String { return _sourceString; }
		
		//exposed to IDE, common
		
		private var adFolderName:			String = "";
		private var initialVolume:			Number = 0;
		private var trackPlaybackProgress:	Number = 4;
		private var trackUserControls:		Boolean = true;
		private var allowResize:			Boolean = true;
		private var autoPlay:				Boolean = false;
		
		//exposed to IDE, for each video
		
		private var videoFileNames:			Array = [];
		private var videoWidths:			Array = [];
		private var videoHeights:			Array = [];
		private var videoLengths:			Array = [];
		private var videoInstanceNumbers:	Array = [];
		private var videoTypes:				Array = [];
		private var videoHDs:				Array = [];
		private var videoServerTypes:		Array = [];
		
		public var lpWidth:Number;
		public var lpHeight:Number;
		public var deliveryFormat:String;
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* API Properties */

		public function initializeBuffer():void {
			bufferProperties.autoFail = !bufferProperties.autoFailInit && pointRollVideo ? pointRollVideo.autoFail : bufferProperties.autoFail;
			bufferProperties.buffer = !bufferProperties.buffer && pointRollVideo ? null : bufferProperties.buffer;
			bufferProperties.completeAt = !bufferProperties.completeAt && pointRollVideo ? null : bufferProperties.completeAt;
			bufferProperties.forceBuffer = !bufferProperties.forceBuffer && pointRollVideo ? null : bufferProperties.forceBuffer;
			bufferProperties.minimumBandwidth = !bufferProperties.minimumBandwidth && pointRollVideo ? pointRollVideo.minimumBandwidth : bufferProperties.minimumBandwidth;
			bufferProperties.optionalMilestones = !bufferProperties.optionalMilestones && pointRollVideo ? pointRollVideo.optionalMilestones : bufferProperties.optionalMilestones;
			bufferProperties.progressFrequency = !bufferProperties.progressFrequency && pointRollVideo ? pointRollVideo.progressFrequency : bufferProperties.progressFrequency;
			bufferProperties.timeOutDuration = !bufferProperties.timeOutDuration && pointRollVideo ? pointRollVideo.timeOutDuration : bufferProperties.timeOutDuration;
			bufferProperties.trackEvents = !bufferProperties.trackEventsInit && pointRollVideo ? pointRollVideo.trackEvents : bufferProperties.trackEvents;
			bufferProperties.trackProgress = !bufferProperties.trackProgress && pointRollVideo ? null : bufferProperties.trackProgress;
			bufferProperties.volume = !bufferProperties.volume ? actualVolume : bufferProperties.volume;
			bufferProperties.init();
		}
		
		public function set autoFail(autoFail:Boolean):void { if(pointRollVideo) {pointRollVideo.autoFail = autoFail;} bufferProperties.autoFail = autoFail; }
		public function get autoFail():Boolean { return pointRollVideo ? pointRollVideo.autoFail : new Boolean(); }
		public function set buffer(buffer:Number):void { if(pointRollVideo) {pointRollVideo.buffer = buffer;} bufferProperties.buffer = buffer; }
		public function get bytesLoaded():Number { return pointRollVideo ? pointRollVideo.bytesLoaded : new Number(); }
		public function get bytesTotal():Number { return pointRollVideo ? pointRollVideo.bytesTotal : new Number(); }
		public function set completeAt(completeAt:Number):void { if(pointRollVideo) {pointRollVideo.completeAt = completeAt;} bufferProperties.completeAt = completeAt; }
		public function get currentTime():Number { return pointRollVideo ? pointRollVideo.currentTime : new Number(); }
		public function set forceBuffer(forceBuffer:Number):void { if(pointRollVideo) {pointRollVideo.forceBuffer = forceBuffer;} bufferProperties.forceBuffer = forceBuffer; }
		public function get HDCapable():Boolean { return pointRollVideo ? pointRollVideo.HDCapable : new Boolean(); }
		public function get isHD():Boolean { return pointRollVideo ? pointRollVideo.isHD : new Boolean(); }
		public function get isPlaying():Boolean { return pointRollVideo ? pointRollVideo.isPlaying : new Boolean(); }
		public function get metaData():Object { return pointRollVideo ? pointRollVideo.metaData : null; }
		public function set minimumBandwidth(minimumBandwidth:Number):void { if(pointRollVideo) {pointRollVideo.minimumBandwidth = minimumBandwidth;} bufferProperties.minimumBandwidth = minimumBandwidth; }
		public function set optionalMilestones(optionalMilestones:Array):void { if(pointRollVideo) {pointRollVideo.optionalMilestones = optionalMilestones;} bufferProperties.optionalMilestones = optionalMilestones; }
		public function get optionalMilestones():Array { return pointRollVideo ? pointRollVideo.optionalMilestones : null; }
		public function set progressFrequency(progressFrequency:Number):void { if(pointRollVideo) {pointRollVideo.progressFrequency = progressFrequency; } bufferProperties.progressFrequency = progressFrequency;}
		public function get progressFrequency():Number {return pointRollVideo ? pointRollVideo.progressFrequency : new Number(); }
		public function set timeOutDuration(timeOutDuration:int):void { if(pointRollVideo) {pointRollVideo.timeOutDuration = timeOutDuration;} bufferProperties.timeOutDuration = timeOutDuration; }
		public function get totalTime():Number { return pointRollVideo ? pointRollVideo.totalTime : new Number(); }
		public function set trackEvents(trackEvents:Boolean):void { if(pointRollVideo) {pointRollVideo.trackEvents = trackEvents;} bufferProperties.trackEvents = trackEvents; }
		public function get trackEvents():Boolean { return pointRollVideo ? pointRollVideo.trackEvents : new Boolean(); }
		public function set trackProgress(trackProgress:Number):void { if(pointRollVideo) {pointRollVideo.trackProgress = trackProgress;} bufferProperties.trackProgress = trackProgress; }
		public function get userBandwidth():Number { return pointRollVideo ? pointRollVideo.userBandwidth : new Number(); }
		public function get XMPData():XML { return pointRollVideo ? pointRollVideo.XMPData : null; }
		public function set volume(volume:Number):void { 
			__fading = false;
			if(pointRollVideo) pointRollVideo.volume = volume; 
			if(bufferProperties.initialized) dispatchEvent(new PrComponentEvent(PrComponentEvent.VOLUME_CHANGE));
			bufferProperties.volume = volume; 
		}
		public function get volume():Number { return !pointRollVideo ? actualVolume : pointRollVideo.volume; }
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* Setters and Getters */
	
		/**
		 * Sets the Ad Folder Name
		 * @param	adFolderName:String
		 */
		public function setAdFolderName(adFolderName:String):void { 
			this.adFolderName = adFolderName;
			invalidate();
		}
		
		/**
		 * Gets the Ad Folder Name
		 * returns String
		 */
		public function getAdFolderName():String { return this.adFolderName; }
		
		/**
		 * Sets the Initial Volume - Default is 0
		 * @param	initialVolume:Number
		 */
		public function setInitialVolume(initialVolume:Number):void { 
			//Limit the amount to be a valid number 0-100
			this.initialVolume = initialVolume > 100 ? 100 : (initialVolume < 0 ? 0 : initialVolume);
			invalidate();
		}
		
		/**
		 * Gets the Initial Volume
		 * returns Number
		 */
		public function getInitialVolume():Number { return this.initialVolume; }
		
		/**
		 * Tells the component if PayRoll must track the progress
		 * @param	trackPlaybackProgress:Boolean
		 */
		public function setTrackPlaybackProgress(trackPlaybackProgress:Number):void {
			this.trackPlaybackProgress = trackPlaybackProgress;
			invalidate();
		}
		
		/**
		 * Gets the Track Playback Progeess status
		 * returns Boolean
		 */
		public function getTrackPlaybackProgress():Number { return this.trackPlaybackProgress; }
		
		/**
		 * Tells the component if PayRoll must track user's actions
		 * @param	trackUserControls:Boolean
		 */
		public function setTrackUserControls(trackUserControls:Boolean):void {
			this.trackUserControls = trackUserControls; 
		}
		
		/**
		 * Gets the Track User Controls status
		 * returns Boolean
		 */
		public function getTrackUserControls():Boolean { return this.trackUserControls; }
		
		/**
		 * Tells the component if the component should resize the video
		 * @param	allowResize:Boolean
		 */
		public function setAllowResize(allowResize:Boolean):void {
			this.allowResize = allowResize; 
		}
		
		/**
		 * Gets the Track User Controls status
		 * returns Boolean
		 */
		public function getAllowResize():Boolean { return this.allowResize; }
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets a list of Video File Names
		 * @param	videoFileNames:Array
		 */
		public function setVideoFileNames(videoFileNames:Array):void {
			this.videoFileNames = videoFileNames;
			invalidate();
		}
		
		/**
		 * Gets list of Video Names
		 * returns Array
		 */
		public function getVideoFileNames():Array { return this.videoFileNames; }
		
		/**
		 * Sets a list of Video Lengths
		 * @param	videoLengths:Array
		 */
		public function setVideoLengths(videoLengths:Array):void {
			this.videoLengths = videoLengths;
			invalidate();
		}
		
		/**
		 * Gets a list of Video Lengths
		 * returns Array
		 */
		public function getVideoLengths():Array { return this.videoLengths; } 
		
		/**
		 * Sets a list of Video Instance Numbers
		 * @param	videoInstanceNumbers
		 */
		public function setVideoInstanceNumbers(videoInstanceNumbers:Array):void {
			this.videoInstanceNumbers = videoInstanceNumbers;
			invalidate();
		}
		public function getVideoInstanceNumbers():Array { return this.videoInstanceNumbers; }
		
		/**
		 * Sets a list of Video Delivery Types (0 - Streaming, 1 - Progressive)
		 * @param	videoTypes:Array
		 */
		public function setVideoTypes(videoTypes:Array):void {
			this.videoTypes = videoTypes;
			invalidate();
		}
		
		/**
		 * Gets a list of Video Delivery Types
		 * returns Array
		 */
		public function getVideoTypes():Array { return this.videoTypes; }
		
		/**
		 * Sets a list of Video Qualities (0 - Not HD, 1 - HD)
		 * @param	videoHDs:Array
		 */
		public function setVideoHDs(videoHDs:Array):void {
			this.videoHDs = videoHDs;
			invalidate();
		}
		
		/**
		 * Gets a list of Video Qualities
		 * returns Array
		 */
		public function getVideoHDs():Array { return this.videoHDs; }
		
		/**
		 * Sets a list of Video Widths
		 * @param	videoWidths:Array
		 */
		public function setVideoWidths(videoWidths:Array):void {
			this.videoWidths = videoWidths;
			invalidate();
		}
		
		/**
		 * Gets a list of Video Widths
		 * returns Array
		 */
		public function getVideoWidths():Array { return this.videoWidths; }
		
		
		/**
		 * Sets a list of Video Heights
		 * @param	videoHeights:Array
		 */
		public function setVideoHeights(videoHeights:Array):void {
			this.videoHeights = videoHeights;
			invalidate();
		}
		
		/**
		 * Gets a list of Video Widths
		 * returns Array
		 */
		public function getVideoHeights():Array { return this.videoHeights; }
		
		
		
		/**
		 * Sets the number of seconds for the buffer
		 * @param	seconds
		 */
		public function setBufferTime(seconds:Number):void {
			bufferTime = seconds;
		}
		
		
		public function getVideoIndex():Number {
			return actualVideo;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		//Constructor
		function PRVideoDisplay() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* GENERAL METHODS, INHERITED FROM UIComponent */
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Executes on start, initializes properties
		 */
		private function init(event:Event):void {
			
			videoDisplay = MovieClip(getChildByName("videoDisplayOnStage"));
			
			bufferProperties = new BufferProperties();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			__width = videoDisplay.width; 
			__height = videoDisplay.height; 
			lpWidth = videoDisplay.width;
			lpHeight = videoDisplay.height;
			
			addEventListener(Event.ENTER_FRAME, getDataFromCustomUI);
			createChildren();
		}
		
		
		/**
		 * Needs to read a frame before sourceString gets populated
		 */
		private function getDataFromCustomUI(event:Event):void {
			
			removeEventListener(Event.ENTER_FRAME, getDataFromCustomUI);
			
			parseData();
			verifyProperties();
			
			
			actualVolume = initialVolume;
		}
		
		/**
		 * Executes on start, adds children assets
		 */
		private function createChildren():void {
			
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0xCCCCCC;
			videoDisplay.backgroundDisplay.transform.colorTransform = ct;
			
			if(!initErrors) {
				initPointRoll();
				timerNotify = new Timer(500);
				timerNotify.addEventListener("timer", notifyListeners);  
            	timerNotify.start();  
				
				//intervalNotify = setInterval(Delegate.create(this, notifyListeners), 500);
			}
			
			draw();
			//initVideo();
		}
	
		
		/**
		 * Executes on start, then it is called through invalidate
		 */
		private function draw():void {
			videoDisplay.width = __width;
			videoDisplay.height = __height;
		}
	
		public function invalidate():void {
			draw();
		}
		
		
		private function initVideo():void {
			
				
				if(videoFileNames.length == 0 || videoFileNames[0] == undefined) {
					throw(epr + " Source error"); return;
				}
				
				var fileName:String = videoFileNames[actualVideo];
				var videoLen:Number = videoLengths[actualVideo];
				var instanceNumber:Number = videoInstanceNumbers[actualVideo];
				
				var hostType:String = videoServerTypes[actualVideo];
				
						
				invalidate();
							
					
				actualVolume = bufferProperties.volume ? bufferProperties.volume : (bufferProperties.initialized ? bufferProperties.volume : initialVolume);
				
				try {
					
					if(hostType == "pointroll") {			
														////Streaming------------
						
						pointRollVideo = new PrVideo(
														 adFolderName,				
														 null,
														 fileName,
														 videoLen,
														 videoDisplay.videoPlayer,
														 actualVolume,				
														 instanceNumber,
														 1);
					}else if(hostType == "url" || hostType == "local"){
						pointRollVideo = new PrVideo(								////Progressive------------
														 adFolderName,				
														 fileName,
														 null,
														 videoLen,
														 videoDisplay.videoPlayer,
														 actualVolume,				
														 instanceNumber,
														 1);
					}
					
					
					
					pointRollVideo.trackEvents = trackUserControls;
					pointRollVideo.trackProgress = trackPlaybackProgress;
					
					
					if(!bufferProperties.initialized) {
						initializeBuffer();
					}
					
					clearEventHandlers();
					setHandlers();
					

						/////////
						
						if(bufferProperties.autoFailInit) {pointRollVideo.autoFail = bufferProperties.autoFail}; 
						if(bufferProperties.buffer) {pointRollVideo.buffer = bufferProperties.buffer;}; 
						if(bufferProperties.completeAt) {pointRollVideo.completeAt = bufferProperties.completeAt};
						if(bufferProperties.forceBuffer) {pointRollVideo.forceBuffer = bufferProperties.forceBuffer; };
						if(bufferProperties.minimumBandwidth) {pointRollVideo.minimumBandwidth = bufferProperties.minimumBandwidth};
						if(bufferProperties.optionalMilestones) {pointRollVideo.optionalMilestones = bufferProperties.optionalMilestones};
						if(bufferProperties.progressFrequency) {pointRollVideo.progressFrequency = bufferProperties.progressFrequency;}
						if(bufferProperties.timeOutDuration) {pointRollVideo.timeOutDuration = bufferProperties.timeOutDuration; };
						if(bufferProperties.trackEventsInit) {pointRollVideo.trackEvents = bufferProperties.trackEvents};
						if(bufferProperties.trackProgress) {pointRollVideo.trackProgress = bufferProperties.trackProgress};
						if(bufferProperties.volume) {pointRollVideo.volume = bufferProperties.volume};
						/////////

						
					
				} catch (errorObject:Object) {
					throw(epr + " Error:" + errorObject);
				}
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * starts the video, different from play for tracking purposes
		 */
		public function startVideo(fDeliveryType:Number = -1, fHDPreference:Number = -1):void {
			
			var forcedDeliveryType:Number = fDeliveryType;
			var forcedHDPreference:Number = fHDPreference;
				
			if(!pointRollVideo) initVideo();
			
			if(!__playing) {
				
				var deliveryType:Number = videoTypes[actualVideo];
				var playHD:Number = videoHDs[actualVideo];
				
				var fdt:Number = forcedDeliveryType!=-1?forcedDeliveryType:deliveryType;
				_isStreaming = fdt;
				
				pointRollVideo.startVideo(fdt, forcedHDPreference!=-1?forcedHDPreference:playHD);
				
				checkFirstLast();
				
				__playing = true;
				
			}
			
		}
		
		public function isStreaming():Boolean {
			return _isStreaming == 1 || _isStreaming == 3 ? true : false;
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function evBufferEmpty(event:PrMediaEvent):void 			{ dispatchEvent(event); }
		private function evBufferFull(event:PrMediaEvent):void 				{ dispatchEvent(event); }
		private function evComplete(event:PrMediaEvent):void 				{ 
			__playing = false;
			dispatchEvent(event); 
		}
		private function evFadeComplete(event:PrMediaEvent):void 			{ 
			__fading = false;
			actualVolume = pointRollVideo.volume;
			bufferProperties.volume = pointRollVideo.volume;
			dispatchEvent(event); 
		}
		private function evFadeStep(event:PrMediaEvent):void 				{ dispatchEvent(event); }
		private function evFailure(event:PrMediaEvent):void 				{ dispatchEvent(event); }
		private function evLowBandwidth(event:PrMediaEvent):void 			{ dispatchEvent(event); }
		private function evMetaData(event:PrMediaEvent):void 				{ dispatchEvent(event); }
		private function evMute(event:PrMediaEvent):void 					{ dispatchEvent(event); }
		private function evOnCuePoint(event:PrProgressEvent):void 			{ 
			var pe:PrProgressEvent = new PrProgressEvent(PrProgressEvent.ONCUEPOINT);
			pe.bytesLoaded = event.bytesLoaded;
			pe.bytesTotal = event.bytesTotal;
			pe.cuePoint = event.cuePoint;
			pe.currentTime = event.currentTime;
			pe.milestone = event.milestone;
			pe.optionalMilestone = event.optionalMilestone;
			pe.percentLoaded = event.percentLoaded;
			pe.percentPlayed = event.percentPlayed;
			pe.totalTime = event.totalTime;
			dispatchEvent(pe); 
		}
		private function evOnKill(event:PrMediaEvent):void 					{ dispatchEvent(event); }
		private function evOnOptionalMilestone(event:PrProgressEvent):void 	{ 
			var pe:PrProgressEvent = new PrProgressEvent(PrProgressEvent.OPTIONAL_MILESTONE);
			pe.bytesLoaded = event.bytesLoaded;
			pe.bytesTotal = event.bytesTotal;
			pe.cuePoint = event.cuePoint;
			pe.currentTime = event.currentTime;
			pe.milestone = event.milestone;
			pe.optionalMilestone = event.optionalMilestone;
			pe.percentLoaded = event.percentLoaded;
			pe.percentPlayed = event.percentPlayed;
			pe.totalTime = event.totalTime;
			dispatchEvent(pe); 
		}
		private function evPause(event:PrMediaEvent):void 					{ dispatchEvent(event); }
		private function evPlay(event:PrMediaEvent):void 					{ __playing = true; dispatchEvent(event); }
		private function evProgress(event:PrProgressEvent):void 			{ 
			var pe:PrProgressEvent = new PrProgressEvent(PrProgressEvent.PROGRESS);
			pe.bytesLoaded = event.bytesLoaded;
			pe.bytesTotal = event.bytesTotal;
			pe.cuePoint = event.cuePoint;
			pe.currentTime = event.currentTime;
			pe.milestone = event.milestone;
			pe.optionalMilestone = event.optionalMilestone;
			pe.percentLoaded = event.percentLoaded;
			pe.percentPlayed = event.percentPlayed;
			pe.totalTime = event.totalTime;
			dispatchEvent(pe); 
		}
		private function evReplay(event:PrMediaEvent):void 					{ dispatchEvent(event); }
		private function evRestart(event:PrMediaEvent):void 				{ dispatchEvent(event); }
		private function evStart(event:PrMediaEvent):void 					{ __playing = true; dispatchEvent(event); }
		private function evStop(event:PrMediaEvent):void 					{ __playing = false; dispatchEvent(event); }
		private function evUnmute(event:PrMediaEvent):void 					{ dispatchEvent(event); }
		private function evXmpData(event:PrMediaEvent):void 				{ dispatchEvent(event); }
		
		private function setHandlers():void {
			pointRollVideo.addEventListener(PrMediaEvent.BUFFER_EMPTY, evBufferEmpty);
			pointRollVideo.addEventListener(PrMediaEvent.BUFFER_FULL, evBufferFull);
			pointRollVideo.addEventListener(PrMediaEvent.COMPLETE, evComplete);
			pointRollVideo.addEventListener(PrMediaEvent.FADE_COMPLETE, evFadeComplete);
			pointRollVideo.addEventListener(PrMediaEvent.FADE_STEP, evFadeStep);
			pointRollVideo.addEventListener(PrMediaEvent.FAILURE, evFailure);
			pointRollVideo.addEventListener(PrMediaEvent.LOW_BANDWIDTH, evLowBandwidth);
			pointRollVideo.addEventListener(PrMediaEvent.ONMETADATA, evMetaData);
			pointRollVideo.addEventListener(PrMediaEvent.MUTE, evMute);
			pointRollVideo.addEventListener(PrProgressEvent.ONCUEPOINT, evOnCuePoint);
			pointRollVideo.addEventListener(PrMediaEvent.ONKILL, evOnKill);
			pointRollVideo.addEventListener(PrProgressEvent.OPTIONAL_MILESTONE, evOnOptionalMilestone);
			pointRollVideo.addEventListener(PrMediaEvent.PAUSE, evPause);
			pointRollVideo.addEventListener(PrMediaEvent.PLAY, evPlay);
			pointRollVideo.addEventListener(PrProgressEvent.PROGRESS, evProgress);
			pointRollVideo.addEventListener(PrMediaEvent.REPLAY, evReplay);
			pointRollVideo.addEventListener(PrMediaEvent.RESTART, evRestart);
			pointRollVideo.addEventListener(PrMediaEvent.START, evStart);
			pointRollVideo.addEventListener(PrMediaEvent.STOP, evStop);
			pointRollVideo.addEventListener(PrMediaEvent.UNMUTE, evUnmute);
			pointRollVideo.addEventListener(PrMediaEvent.ONXMPDATA, evXmpData);
		}
		
		private function clearEventHandlers():void {
			pointRollVideo.removeEventListener(PrMediaEvent.BUFFER_EMPTY, evBufferEmpty);
			pointRollVideo.removeEventListener(PrMediaEvent.BUFFER_FULL, evBufferFull);
			pointRollVideo.removeEventListener(PrMediaEvent.COMPLETE, evComplete);
			pointRollVideo.removeEventListener(PrMediaEvent.FADE_COMPLETE, evFadeComplete);
			pointRollVideo.removeEventListener(PrMediaEvent.FADE_STEP, evFadeStep);
			pointRollVideo.removeEventListener(PrMediaEvent.FAILURE, evFailure);
			pointRollVideo.removeEventListener(PrMediaEvent.LOW_BANDWIDTH, evLowBandwidth);
			pointRollVideo.removeEventListener(PrMediaEvent.ONMETADATA, evMetaData);
			pointRollVideo.removeEventListener(PrMediaEvent.MUTE, evMute);
			pointRollVideo.removeEventListener(PrProgressEvent.ONCUEPOINT, evOnCuePoint);
			pointRollVideo.removeEventListener(PrMediaEvent.ONKILL, evOnKill);
			pointRollVideo.removeEventListener(PrProgressEvent.OPTIONAL_MILESTONE, evOnOptionalMilestone);
			pointRollVideo.removeEventListener(PrMediaEvent.PAUSE, evPause);
			pointRollVideo.removeEventListener(PrMediaEvent.PLAY, evPlay);
			pointRollVideo.removeEventListener(PrProgressEvent.PROGRESS, evProgress);
			pointRollVideo.removeEventListener(PrMediaEvent.REPLAY, evReplay);
			pointRollVideo.removeEventListener(PrMediaEvent.RESTART, evRestart);
			pointRollVideo.removeEventListener(PrMediaEvent.START, evStart);
			pointRollVideo.removeEventListener(PrMediaEvent.STOP, evStop);
			pointRollVideo.removeEventListener(PrMediaEvent.UNMUTE, evUnmute);
			pointRollVideo.removeEventListener(PrMediaEvent.ONXMPDATA, evXmpData);
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* API METHODS */
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function fadeVolume(newVolume:Number, seconds:Number):void	{ 
			__fading = true;
			pointRollVideo.fadeVolume(newVolume, seconds); 
		}
		public function getFadeDirection():String	{ return pointRollVideo.getFadeDirection(); }
		public function resetOptionalMilestones():void	{ 
			pointRollVideo.resetOptionalMilestones(); 
			bufferProperties.optionalMilestones = pointRollVideo.optionalMilestones;
		}
		public function toggleStream(on:Boolean):void	{ pointRollVideo.toggleStream(on); }
		public function restart(withSound:Boolean = false):void { pointRollVideo.restart(withSound); }
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* EXPOSED METHODS TO CONTROL THE VIDEOS */
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * starts the video, from a specific position in the playlist
		 */
		public function startVideoById(videoID:Number = 0, deliveryType:Number = -1, HDPreference:Number = -1):void {
			dispatchEvent(new PrComponentEvent(PrComponentEvent.PLAYBACK_START));
			if (isPlaying && videoID == actualVideo) {
				pointRollVideo.restart();
			}else {
				stop();
				killVideo()
				actualVideo = videoID;
				if(actualVideo > videoFileNames.length-1) actualVideo = videoFileNames.length-1;
				if(actualVideo < 0) actualVideo = 0;
				startVideo(deliveryType, HDPreference);
			}
		}
		
		/**
			Plays the Video
		*/
		
		public override function play():void {
			if (__paused) {
				__paused = false;
				pointRollVideo.play();
				checkFirstLast();
			}else{
				startVideo(-1,-1);
			}
			dispatchEvent(new PrComponentEvent(PrComponentEvent.PLAYBACK_START));
		}
		
		/**
		*	Pauses the current video
		*/
		public function pause():void {
			__paused = true;
			pointRollVideo.pause();
		}
		
		/**
		*	Stops the Video
		*/
		public override function stop():void {
			if(__playing)
			{
				__playing = false;
				__paused = true;
				if(pointRollVideo!=null) {
					pointRollVideo.stop();
				}
			}
		}
		
		private function _stopAfterResume(e:Event):void
		{
			pointRollVideo.removeEventListener(PrMediaEvent.PLAY, _stopAfterResume);
			
		}
		
		/**
		*	Kills the Video
		*/
		public function killVideo():void {
			pointRollVideo.killVideo();
			pointRollVideo = null;
		}
		
		/**
		*	Forwards the current video
		*/
		public function fastForward():void {
			loadVideo(true);
		}
		
		/**
		*	Rewinds the current video
		*/
		public function rewind():void {
			loadVideo(false);
		}
		
		/**
		*	Replays the current video
		*/
		public function replay():void {
			pointRollVideo.replay();
		}
	
		/**
		*	Mutes the current video
		*/
		public function mute():void {
			oldVolume = actualVolume;
			setVolume(0);
		}
		
		/**
		*	Unmutes the current video
		*/
		public function unmute():void {
			if(oldVolume == 0) 
				setVolume(1);
			else
				setVolume(oldVolume);
			
			dispatchEvent(new PrComponentEvent(PrComponentEvent.UNMUTE));
		}
		
		/**
		*	Sets the volume of the video
		*/
		public function setVolume(vol:Number):void {
			__fading = false;
			actualVolume = vol;
			bufferProperties.volume = actualVolume;
			pointRollVideo.volume = actualVolume;
			dispatchEvent(new PrComponentEvent(PrComponentEvent.VOLUME_CHANGE));
			if(bufferProperties.initialized) dispatchEvent(new PrComponentEvent(PrComponentEvent.VOLUME_CHANGE));
		}
		
		/**
		*	Gets the volume of the video
		*/
		public function getVolume():Number {
			return this.volume;
		}
		
		/**
		*	Tells the controls if the video is paused. 
		*	This is used because video must be started in
		*	different way than if just starts
		*/
		public function isPaused():Boolean {
			return __paused;
		}
		
		/**
		*	Seeks a video to a position
		*/
		public function seek(position:Number):void {
			if(pointRollVideo) pointRollVideo.seek(position);
		}
		
		/**
		*	Returns the length of the video playing
		*/
		public function getLength():Number {
			return videoLengths[actualVideo];
		}
		
			
		/**
		*	Tells the controls if the audio is fading.
		*/
		public function isFading():Boolean {
			return __fading;
		}
		
		public function stopFading():void {
			__fading = false;
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* INTERNAL METHODS */
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		*	Handles the playlist
		*	@dir	Boolean		True moves forward, False, moves backwards
		*/
		private function loadVideo(dir:Boolean):void {
			stop();
			__playing = false;
			killVideo();
			if(dir) {
				actualVideo++;
				if(actualVideo >= videoFileNames.length) {
					actualVideo = 0;
					dispatchEvent(new PrComponentEvent(PrComponentEvent.PLAYLISTFINISHED));
					clearEventHandlers();
				}else{
					startVideo(-1,-1);
				}
			}else{
				actualVideo--;
				if(actualVideo < 0) {
					actualVideo = 0;
				}else{
					startVideo(-1,-1);
				}
			}
			
		}
		
		public function isFirstVideo():Boolean {
			if(actualVideo == 0) return true; else return false;
		}
		
		public function isLastVideo():Boolean {
			if(actualVideo == videoFileNames.length-1) return true; else return false;
		}
		/**
		*
		*/
		private function checkFirstLast():void {
			
			if(actualVideo == videoFileNames.length-1) dispatchEvent(new PrComponentEvent(PrComponentEvent.PLAYLISTLAST));
			if(actualVideo == 0) dispatchEvent(new PrComponentEvent(PrComponentEvent.PLAYLISTFIRST));
		}
		
		/**
		 * Initializes PointRollAPI
		 */
		private function initPointRoll():void {
			pointRoll = PointRoll.getInstance(this);
		}
		
		
		/**
		* Sends a notification to all the objects listening to onVDCInit event
		*/
		private function notifyListeners(event:TimerEvent):void {
			timerNotify.stop();
			timerNotify = null;
			initVideo();
			dispatchEvent(new PrComponentEvent(PrComponentEvent.INIT));
			
			if(autoPlay) startVideo();
		}
		
		public function getPrVideo():PrVideo
		{
			return pointRollVideo
		}
		
		/**
		*	Receives a connection string from UX
		*	@private
		*/
		public function parseData():void {
			var conn:String = sourceString;
			
			if(conn == "") return;
			
			var tmp:Array = conn.split("||");
			var tmpMainVars:String = tmp[0];
			
			var mainVars:Array = tmpMainVars.split(PRVideoDisplay.SOURCE_STRING_CHAR_0);
			
				adFolderName = String(mainVars[0]);
				//hostMode = String(mainVars[1]);
				initialVolume = Number(mainVars[2]);
				trackPlaybackProgress = Number(mainVars[3]);
				trackUserControls = mainVars[4] == "true" ? true : false;
				autoPlay = mainVars[5] == "true" ? true : false;
				
				initialVolume = initialVolume < 0 ? 0 : (initialVolume > 100 ? 100 : initialVolume);
				initialVolume = initialVolume / 100;
			
			var tmpVideos:String = tmp[1];
			var tmpVideosVars:Array = tmpVideos.split("|");
			
			
			
			for(var i:Number = 0; i<tmpVideosVars.length; i++) {
				var videosVars:Array = tmpVideosVars[i].split(PRVideoDisplay.SOURCE_STRING_CHAR_0);
				
				
				videoFileNames[i] = videosVars[2];
				videoInstanceNumbers[i] = videosVars[8],
				videoServerTypes[i] = videosVars[1],
				videoLengths[i] = videosVars[5];
				videoWidths[i] = videosVars[3];
				videoHeights[i] = videosVars[4];
				
				
				
				var dt:Number;
				switch(videosVars[6].toLowerCase()) {
					case "streaming": 			dt = 1; break;
					case "progressive": 		dt = 2; break;
					case "forcedstreaming":		dt = 3; break;
					case "forcedprogressive":	dt = 4; break;
				}
				
				var hd:Number;
				switch(videosVars[7].toLowerCase()) {
					case "never": 				hd = HDDelivery.NEVER; break;
					case "always": 				hd = HDDelivery.ALWAYS; break;
					case "if_available":		hd = HDDelivery.IF_AVAILABLE; break;
				}
				
				videoTypes[i] = dt; 
				videoHDs[i] = hd; 
				
			}
		}
	
	
	
		/**
		 * Verifies if properties are set ok
		 */
		private function verifyProperties():void {
			
			var errors:Array = new Array();
			
			if(!adFolderName || !initialVolume) return;
			
			if (adFolderName == "") errors.push("adFolderName empty");
			if (initialVolume < 0 || initialVolume > 100) errors.push ("initalVolume not valid");
			
				
			if (errors.length) {
				throw(epr + errors.join("\n"));
				initErrors = true;
			}
			
		}
		
		
	}
	
}