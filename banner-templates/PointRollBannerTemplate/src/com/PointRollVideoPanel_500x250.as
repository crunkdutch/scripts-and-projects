package com
{
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;
	import PointRollAPI_AS3.media.PrVideo;

	import com.banners.Border;
	import com.banners.ObjectStates;
	import com.banners.TweenWrap;
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	import com.pointrollHelper.PointRollVideoPanel;
	import com.pointrollHelper.PrVideoData;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.text.TextField;

	/**
	 * @author crunkdutch
	 */
	public class PointRollVideoPanel_500x250 extends PointRollVideoPanel
	{
		private static const BANNER_WIDTH : int = 500;
		private static const BANNER_HEIGHT : int = 250;
		private static const GREEN : uint = 0x00ff00;
		private var border : Border;
		private var videoData : PrVideoData;
		private var isSound : Boolean;
		private var isPlaying : Boolean;
		private var first : Boolean = true;
		private var videoHasFinished : Boolean;
		private var objectStates : ObjectStates;
		private var videoArray : Array = [];
		private var delay : Number = 0;
		
		public var soccerBall : MovieClip;
		public var bg : Sprite;
		public var cta : *;
		public var ctaVideo : *;
		public var btnClose : Sprite;
		public var clickArea : Sprite;
		public var frame01 : MovieClip;
		public var frame02 : MovieClip;
		public var resolveFrame : MovieClip;
		public var masker : Sprite;
		public var videoTime : TextField;
		public var progressBar : Sprite;
		public var controls : Sprite;
		public var btnPausePlay : MovieClip;
		public var btnAudio : MovieClip;
		public var videoPlayer : MovieClip;
		public var btnReplay : MovieClip;
		public var videoButtons : Sprite;
		public var holder : Sprite;

		public function PointRollVideoPanel_500x250()
		{
			// set the tween type
			TweenWrap.setTween(TweenNano);
			pr.pin();
			masker.scaleX = 0;
			border = new Border(BANNER_WIDTH, BANNER_HEIGHT, GREEN);
			addChild(border);

			holder = videoPlayer.getChildByName('videoHolder') as Sprite;
			controls = videoPlayer.getChildByName('controls') as Sprite;
			videoTime = controls.getChildByName('videoTime') as TextField;
			progressBar = controls.getChildByName('progressBar') as Sprite;
			videoButtons = videoPlayer.getChildByName('videoButtons') as Sprite;
			soccerBall = frame01.getChildByName('soccerBall') as MovieClip;
 			
			//set copy for secondary cta button
			ctaVideo.buttonCopy.copyChild.copyChildText.text = 'WATCH VIDEO';
			
			bg.mouseEnabled = ctaVideo.visible = cta.visible = false;
			resolveFrame.visible = frame02.visible = frame01.visible = false;
			ctaVideo.alpha = cta.alpha = videoPlayer.alpha = 0;
			bg.alpha = progressBar.scaleX = 0;
			btnClose.buttonMode = clickArea.buttonMode = true;
			clickArea.addEventListener(MouseEvent.CLICK, onClickAreaClick);
			btnClose.addEventListener(MouseEvent.CLICK, closePanel);
			objectStates = new ObjectStates();
			objectStates.saveAllObjStatesOf(this, true);

			TweenWrap.to(masker, 1, {scaleX:1, ease:Sine.easeOut, onComplete:handleVideo, onCompleteParams:[false]});

			/*
			 *  this is assuming we have a click to expand/auto play video banner
			 *  if not - the onCompleteParm of the masker Tween would be false, and 
			 *  we do some other animation instead. 
			 *
			 */
		}

		/*
		 * THIS SECTION IS THE ANIMATION SEQUENCES - MAKE CHANGES TO YOUR BANNERS
		 * ANIMATION BEHAVIOR IN THESE SET OF FUNCTIONS
		 */


		private function startAnimation() : void
		{
			frame01.visible = true;
			TweenWrap.to(bg, 0.3, {alpha:1, ease:Strong.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.from(frame01.t1, 0.3, {x:-300, ease:Sine.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.from(frame01.t2, 0.3, {x:-300, ease:Sine.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.from(frame01.t3, 0.3, {x:-300, ease:Sine.easeOut, delay:delay});
			delay += 0.5;
			TweenWrap.from(soccerBall, 0.5, {y:250, scaleX:0, scaleY:0, ease:Back.easeOut, delay:delay});
			delay += 1.5;
			TweenWrap.delayedCall(delay, frame01b);
		}

		private function frame01b() : void
		{
			delay = 0;
			TweenWrap.to(frame01, 0.5, {x:500, ease:Sine.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.delayedCall(delay, frame02a);
		}

		private function frame02a() : void
		{
			delay = 0;
			frame02.visible = true;
			TweenWrap.from(frame02.t4, 0.5, {scaleX:0, scaleY:0, ease:Back.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.from(frame02.thumbsUp, 0.25, {y:200, rotation:30, ease:Sine.easeOut, delay:delay});
			delay += 1.5;
			TweenWrap.delayedCall(delay, frame02b);
		}

		private function frame02b() : void
		{
			delay = 0;
			TweenWrap.to(frame02, 0.5, {x:500, ease : Sine.easeOut, delay : delay});
			delay += 0.25;
			TweenWrap.to(bg, 0.5, {alpha:0, ease : Strong.easeOut, delay : delay});
			delay += 0.25;
			TweenWrap.to(videoPlayer, 0.5, 
				{
					alpha:1, 
					ease:Strong.easeOut,
					delay : delay, 
					onComplete : function():void 
					{
						bg.visible = false;
						//set click area to be size of video frame only leaving controls and side buttons clickable
						clickArea.scaleX = .81;
						clickArea.scaleY = .87;
						if (videoArray.length > 1)
						{
							slideVideoButtons();
						}	
					}
				}
			);
		}
		
		private function goResolve() : void
		{
			delay = 0;
			clickArea.scaleX = clickArea.scaleY = 1;
			ctaVideo.visible = cta.visible =resolveFrame.visible = true;
			TweenWrap.to(videoPlayer, 0.5, {alpha : 0, ease : Strong.easeOut, delay : delay});
			delay += 0.25;
			TweenWrap.from(resolveFrame.t5, 0.3, {x:-300, ease:Sine.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.from(resolveFrame.t6, 0.3, {x:-300, ease:Sine.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.from(resolveFrame.finalImage, 0.3, {x:550, ease:Sine.easeOut, delay:delay});
			delay += 0.25;
			TweenWrap.to(cta, 0.3, {alpha:1, ease : Strong.easeOut, delay : delay});
			delay += 0.25;
			TweenWrap.to(ctaVideo, 0.3, {alpha:1, ease : Strong.easeOut, delay : delay, onComplete : ctaListeners});
		}
		
		private function ctaListeners() : void
		{
			trace('YO WTF');
			if (!cta.hasEventListener(MouseEvent.CLICK))
			{
				trace('YO WTF cta');
				cta.addEventListener(MouseEvent.CLICK, onCtaClick);
			}
			
			if (!ctaVideo.hasEventListener(MouseEvent.CLICK))
			{
				trace('YO WTF ctaVideo');
				ctaVideo.addEventListener(MouseEvent.CLICK, onCtaClick);
			}
		}
		
		private function goReplayVideo() : void
		{
			cta.visible = ctaVideo.visible = resolveFrame.visible = false;
			cta.alpha = ctaVideo.alpha = 0;
			TweenWrap.to(videoPlayer, 0.5, 
				{
					alpha:1, 
					ease:Strong.easeOut,
					delay : delay, 
					onComplete : function():void 
					{
						bg.visible = false;
						//set click area to be size of video frame only leaving controls and side buttons clickable
						clickArea.scaleX = .81;
						clickArea.scaleY = .87;
						prVideo.replay();
						btnPausePlay.mcPlay.visible = false;
						btnPausePlay.mcPause.visible = true;
						if (videoArray.length > 1)
						{
							slideVideoButtons();
						}	
					}
				}
			);
		}
		
		/*
		 * --------------------------------
		 * ANIMATION FUNCTIONS END---------
		 * --------------------------------
		 * VIDEO PLAYER FUNCTIONS BEGIN----
		 * --------------------------------
		 */

		private function handleVideo(autoPlay : Boolean) : void
		{
			// in this order
			prVideoAdFolder = "VH-1";
			// default value is for reference only.
			prVideoFilePath = "/PointRoll/media/videos/VH-1/";
			// default value is for reference only.
			prVideoTarget = new Video(404, 228);
			// default value is for reference only.
			holder.addChild(prVideoTarget);
			videoArray = ['VHOC-0330_PrSunday', 'VHOC-0332_PrTonight', 'VHOC-0331_PrTomorrow'];
			videoData = new PrVideoData(videoArray[0], 1, 30);

			if (autoPlay)
			{	
				initPrVideo(videoData);
				prVideo.startVideo(PrVideo.STREAMING);
				if (videoArray.length > 1)
				{
					slideVideoButtons();
				}
				first = false;
				isPlaying = true;
				isSound = true;
				clickArea.scaleX = .81;
				clickArea.scaleY = .87;
				TweenWrap.to(videoPlayer, 0.5, {alpha:1, ease:Strong.easeOut});
			}
			else
			{
				startAnimation();
			}

			initControls();
		}

		private function slideVideoButtons() : void
		{
			trace('slideVideoButtons');
			TweenWrap.to(videoButtons, 0.25, {x:405, ease:Sine.easeOut, onComplete:addVideoButttonListeners});
		}

		private function addVideoButttonListeners() : void
		{
			trace(videoButtons.getChildAt(0).name);
			for (var i : int = 0; i < videoButtons.numChildren; i++)
			{
				var b : Sprite = videoButtons.getChildAt(i) as Sprite;

				// 0 is the shape bg - it dont need no listener
				if (i > 0)
				{
					if (!b.hasEventListener(MouseEvent.CLICK))
					{
						b.addEventListener(MouseEvent.CLICK, onVideoButtonClick);
					}

					b.buttonMode = true;
				}
			}
		}

		private function initControls() : void
		{
			btnPausePlay = controls.getChildByName('btnPausePlay') as MovieClip;
			btnAudio = controls.getChildByName('btnAudio') as MovieClip;
			btnAudio.buttonMode = btnPausePlay.buttonMode = true;

			if (isPlaying)
			{
				btnPausePlay.mcPlay.visible = false;
				btnPausePlay.mcPause.visible = true;
			}
			else
			{
				btnPausePlay.mcPlay.visible = true;
				btnPausePlay.mcPause.visible = false;
			}

			controlListeners();
		}

		private function controlListeners() : void
		{
			if (!btnAudio.hasEventListener(MouseEvent.CLICK))
			{
				btnAudio.addEventListener(MouseEvent.CLICK, onBtnAudioClick, false, 0, true);
			}
			if (!btnPausePlay.hasEventListener(MouseEvent.CLICK))
			{
				btnPausePlay.addEventListener(MouseEvent.CLICK, onBtnPausePlayClick, false, 0, true);
			}
		}

		private function videoOver() : void
		{
			isPlaying = false;
			videoHasFinished = true;
			prVideo.addEventListener(PrMediaEvent.START, onPrVideoStart);
			btnPausePlay.mcPlay.visible = true;
			btnPausePlay.mcPause.visible = false;
			
			// fade out player and show final frame animation / screen
			goResolve();
		}

		private function formatTime(t : int) : String
		{
			var s : int = Math.round(t);
			var m : int = 0;
			if (s > 0)
			{
				while (s > 59)
				{
					m++;
					s -= 60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			}
			else
			{
				return "00:00";
			}
		}
		
		private function closePanel(event : MouseEvent) : void
		{
			TweenWrap.to(masker,1, {scaleX : 0, ease : Sine.easeOut, onComplete : pr.close});
		}
		
		private function onClickAreaClick(event : MouseEvent) : void
		{
			trace('CLICK TAG CLICK TAG CLICK TAG');
		}
		
		private function onCtaClick(event : MouseEvent) : void
		{	
			trace(event.currentTarget.name);
			switch (event.currentTarget.name)
			{
				case 'cta' : 
					trace('CLICKTAG CLICKTAG CLICKTAG');
					break;
					
				case 'ctaVideo' : 
					goReplayVideo();
					break;
			}
		}

		private function onVideoButtonClick(event : MouseEvent) : void
		{
			switch (event.currentTarget.name)
			{
				case 'btnVideo1' :
					videoData = new PrVideoData(videoArray[0], 1, 30);
					break;
				case 'btnVideo2' :
					videoData = new PrVideoData(videoArray[1], 1, 30);
					break;
				case 'btnVideo3' :
					videoData = new PrVideoData(videoArray[2], 1, 30);
					break;
			}

			initPrVideo(videoData);
			prVideo.startVideo(PrVideo.STREAMING);
			btnPausePlay.mcPlay.visible = false;
			btnPausePlay.mcPause.visible = true;
		}

		override protected function onPrVideoStart(event : PrMediaEvent) : void
		{
			super.onPrVideoStart(event);
			isPlaying = true;
			videoHasFinished = false;

			prVideo.removeEventListener(PrMediaEvent.START, onPrVideoStart);
			prVideo.addEventListener(PrMediaEvent.COMPLETE, onPrVideoComplete);

			if (!prVideo.hasEventListener(PrProgressEvent.PROGRESS))
			{
				prVideo.addEventListener(PrProgressEvent.PROGRESS, onPrVideoProgress);
			}
		}

		private function onPrVideoProgress(event : PrProgressEvent) : void
		{
			videoTime.text = formatTime(prVideo.totalTime - prVideo.currentTime);
			progressBar.scaleX = event.percentPlayed;
		}

		override protected function onPrVideoComplete(event : PrMediaEvent) : void
		{
			prVideo.removeEventListener(PrMediaEvent.COMPLETE, onPrVideoComplete);
			videoOver();
		}
		
		private function onBtnPausePlayClick(event : MouseEvent) : void
		{
			if (isPlaying)
			{
				prVideo.pause();
				btnPausePlay.mcPlay.visible = true;
				btnPausePlay.mcPause.visible = false;
			}
			else
			{
				if (first)
				{
					initPrVideo(videoData);
					prVideo.startVideo(PrVideo.STREAMING);
					btnPausePlay.mcPlay.visible = false;
					btnPausePlay.mcPause.visible = true;
					first = false;
					isSound = true;
				}
				else
				{
					if (videoHasFinished)
					{
						prVideo.replay();
						btnPausePlay.mcPlay.visible = false;
						btnPausePlay.mcPause.visible = true;
					}
					else
					{
						prVideo.play();
						btnPausePlay.mcPlay.visible = false;
						btnPausePlay.mcPause.visible = true;
					}
				}
			}

			isPlaying = (!isPlaying);
		}

		private function onBtnAudioClick(event : MouseEvent) : void
		{
			if (isSound)
			{
				prVideo.volume = 0;
			}
			else
			{
				prVideo.volume = 1;
			}

			btnAudio.soundOn.visible = (!isSound);
			isSound = (!isSound);
		}
	}
}