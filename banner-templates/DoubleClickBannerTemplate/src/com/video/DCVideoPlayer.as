package com.video
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

	import com.banners.*;

	import com.google.ads.studio.video.EnhancedVideoController;
	import com.google.ads.studio.video.VideoPlayerAdvanced;
	import com.google.ads.studio.video.Playlist;
	import com.google.ads.studio.events.StudioVideoEvent;

	public dynamic class DCVideoPlayer extends MovieClip
	{
		public var videoButtons : MovieClip;
		public var controls : MovieClip;
		public var videoPlayer : VideoPlayerAdvanced;
		public var videoTime : TextField;
		public var progressBar : Sprite;
		public var btnPausePlay : MovieClip;
		public var btnAudio : MovieClip;
		public var playlist : Playlist;
		public var videoHasFinished : Boolean;
		public var first : Boolean = false;
		public var isSound : Boolean = true;
		public var isPlaying : Boolean = true;
		
		private var videoButtonArray : Array = [];
		private var justFired : Boolean = false;
		private var minute : Number = 0;
		private var second : Number = 0;

		public function DCVideoPlayer() 
		{
			controls = this.getChildByName('controls') as MovieClip;
			videoPlayer = this.getChildByName('videoPlayer') as VideoPlayerAdvanced;
			videoButtons = this.getChildByName('videoButtons') as MovieClip;
			initControls();
			initVideoButtons();
			initVideo();
		}

		private function initControls() : void
		{
			btnPausePlay = controls.getChildByName('btnPausePlay') as MovieClip;
			btnAudio = controls.getChildByName('btnAudio') as MovieClip;
			progressBar = controls.getChildByName('progressBar') as Sprite;
			videoTime = controls.getChildByName('videoTime') as TextField;
			
			progressBar.scaleX = 0;
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

		private function initVideoButtons() : void
		{
			for (var i : int = 0; i < videoButtons.numChildren; i++)
			{
				var b = videoButtons.getChildAt(i);
				if (b.name != 'vbBg')
				{
					b.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);
					b.buttonCopy.buttonChild.buttonText.text = 'VIDEO ' + i;
					videoButtonArray.push(b);
				}

				if (b.name == 'btnVideo1')
				{
					b.background.gotoAndStop(7);
					b.kill();
					/*
					var description:XML = describeType(b);
            		trace(description);
            		*/
				}
			}
		}

		private function initVideo() : void
		{
			playlist = videoPlayer.getPlaylist();
			playlist.setAutoAdvanceVideoOnComplete(false);
			playlist.addEventListener(StudioVideoEvent.COMPLETE, completePlay, false, 0, true);
			videoPlayer.addEventListener(StudioVideoEvent.PLAYHEAD_MOVE, onPlayHeadMove, false, 0, true);
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
			btnPausePlay.mcPlay.visible = true;
			btnPausePlay.mcPause.visible = false;
		}

		private function resetVideoTime() : void
		{
			minute = 0;
			second = 0;
			progressBar.scaleX = 0;
			videoTime.text = '0:00';
		}

		private function toggleButtons(array : Array, btnName : String) : void
		{
			for (var i : int = 0; i < array.length; i++)
			{
				var tmp : BannerButton = array[i] as BannerButton;

				if (tmp.name == btnName)
				{	
					tmp.background.gotoAndStop(7);
					tmp.kill();
				}
				else
				{
					tmp.background.gotoAndStop(0);
					tmp.buttonCopy.gotoAndStop(0);
					tmp.addListeners();
				}	
			}
		}

		////////////////////////
		////EVENT HANDLERS//////	
		////////////////////////

		private function onPlayHeadMove(event : StudioVideoEvent) : void
		{
			//trace(justFired + ' justFired');
			var scale : Number = (videoPlayer.getElapsedSeconds() / videoPlayer.getTotalSeconds());
			var actualSeconds : Number = Math.floor(videoPlayer.getElapsedSeconds());
			//up to 4 minutes of video max 
			if (actualSeconds == 60 && !justFired || actualSeconds == 120 && !justFired || actualSeconds == 180 && !justFired)
			{
				justFired = true;
				minute += 1;
				second = 0;
			}

			//wait a few then reset it to false - the issue is hte event fires multiple times per second
			if (second > 10 && justFired)
			{
				justFired = false;
			}

			second = actualSeconds % 60;
			var doubleSecond = second < 10 ? "0" + second : second;	
			videoTime.text = String(minute) + ':' + String(doubleSecond);
			progressBar.scaleX = scale;	
		}

		private function completePlay(event : StudioVideoEvent) : void
		{
			videoOver();
		}
		
		private function onVideoButtonClick(event : MouseEvent) : void
		{
			event.currentTarget.removeEventListener(MouseEvent.CLICK, onVideoButtonClick);
			
			toggleButtons(videoButtonArray, event.currentTarget.name);
			switch (event.currentTarget.name)
			{
				case 'btnVideo1' : 
					if (!videoButtons.btnVideo2.hasEventListener(MouseEvent.CLICK))
					{
						videoButtons.btnVideo2.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);	
					}
					if (!videoButtons.btnVideo3.hasEventListener(MouseEvent.CLICK))
					{
						videoButtons.btnVideo3.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);	
					}
					playlist.skipTo(0);
					break;

				case 'btnVideo2' :
					if (!videoButtons.btnVideo1.hasEventListener(MouseEvent.CLICK))
					{
						videoButtons.btnVideo1.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);	
					}
					if (!videoButtons.btnVideo3.hasEventListener(MouseEvent.CLICK))
					{
						videoButtons.btnVideo3.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);	
					}
					playlist.skipTo(1);
					break;

				case 'btnVideo3' : 
					if (!videoButtons.btnVideo1.hasEventListener(MouseEvent.CLICK))
					{
						videoButtons.btnVideo1.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);	
					}
					if (!videoButtons.btnVideo2.hasEventListener(MouseEvent.CLICK))
					{
						videoButtons.btnVideo2.addEventListener(MouseEvent.CLICK, onVideoButtonClick, false, 0, true);	
					}
					playlist.skipTo(2);
					break;
			}

			resetVideoTime();
		}

		private function onBtnAudioClick(event : MouseEvent) : void
		{
			if (isSound)
			{
				videoPlayer.mute();
			}
			else
			{
				videoPlayer.unmute();	
			}

			btnAudio.soundOn.visible = (!isSound);
			isSound = (!isSound);
		}
		
		private function onBtnPausePlayClick(event : MouseEvent) : void
		{
			if (isPlaying)
			{
				btnPausePlay.mcPlay.visible = true;
				btnPausePlay.mcPause.visible = false;
				videoPlayer.pause();
			}
			else
			{
				if (first) //this is FOR NON AUTO PLAY
				{
					btnPausePlay.mcPlay.visible = false;
					btnPausePlay.mcPause.visible = true;
					first = false;
					isSound = true;
					videoPlayer.play();
				}
				else
				{
					if (videoHasFinished)
					{
						resetVideoTime();
						videoPlayer.play();
						btnPausePlay.mcPlay.visible = false;
						btnPausePlay.mcPause.visible = true;
					}
					else
					{
						videoPlayer.pause();
						btnPausePlay.mcPlay.visible = false;
						btnPausePlay.mcPause.visible = true;
					}
				}
			}

			isPlaying = (!isPlaying);
		}
	}
}