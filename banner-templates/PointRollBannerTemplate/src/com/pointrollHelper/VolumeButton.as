﻿package com.pointrollHelper {	import flash.geom.ColorTransform;		import flash.media.SoundTransform;		import flash.media.SoundMixer;		import flash.display.LineScaleMode;		import flash.display.JointStyle;		import flash.display.CapsStyle;		import flash.display.Shape;		import flash.display.Sprite;		import flash.events.MouseEvent;			/**	 * @author cwise	 */	public class VolumeButton extends Sprite{		protected var reduceOnClick:Boolean;		protected var volumePercent:Number = 1;		protected var volumeLevel:int;		protected var steps:int;		protected var _mouseOver:Boolean = false;		private var speakerIcon:Shape;		private var waves:Array = [];		private var hit:Sprite = new Sprite();		/**		 * VolumeButton constructor		 * @param speakerWidth - the width of the speaker icon, in pixels. renders best with width:height at about 5:9 ratio.		 * @param speakerHeight - the ehight of the speaker icon, in pixels. renders best with width:height at about 5:9 ratio.		 * @param steps - the number of different levels the volume will toggle through. also affects the number of waves drawn.		 * @param fill - whether or not to fill the volume icon when drawing it.		 * @param speakerStroke - the line thickness (in pixels) of the speaker icon, used when drawing.		 * @param waveStroke - the line thickness (in pixels) of the waves, used when drawing.		 * @param speakerFillColor - the color to fill the speaker icon with, used when drawing.		 * @param speakerStrokeColor - the color of the speaker icon's outline, used when drawing.		 * @param waveStrokeColor - the color of the waves, used when drawing.		 * @param reduceOnClick - sets the behavior of the toggling action. either clicking increases (false) or decreases (true) volume.		 * @param defaultVolume - sets the default volume level to use. valid values 0.0 - 1.0		 */				public function VolumeButton(speakerWidth:Number = 10, speakerHeight:Number = 18, steps:int = 2, fill:Boolean = true, speakerStroke:Number = 2, waveStroke:Number = 2, speakerFillColor:uint = 0xFFFFFF, speakerStrokeColor:uint = 0x000000, waveStrokeColor:uint = 0x000000, reduceOnClick:Boolean = true, defaultVolume:Number = 1) {			this.steps = steps;			//draw the speaker.			speakerIcon = new Shape();			speakerIcon.graphics.lineStyle(speakerStroke,speakerStrokeColor,1,true,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND);			if(fill){				speakerIcon.graphics.beginFill(speakerFillColor);			}			speakerIcon.graphics.moveTo(speakerWidth, 0);			speakerIcon.graphics.lineTo(speakerWidth, speakerHeight);			speakerIcon.graphics.lineTo(speakerWidth/2, speakerHeight * .75);			speakerIcon.graphics.lineTo(0, speakerHeight * 11/16);			speakerIcon.graphics.lineTo(0, speakerHeight * 5/16);			speakerIcon.graphics.lineTo(speakerWidth/2,speakerHeight * .25);			speakerIcon.graphics.lineTo(speakerWidth, 0);			if(fill){				speakerIcon.graphics.endFill();			}			addChild(speakerIcon);			//make our waves. minimum of two. one looks silly.			var numWaves:int = Math.max(2,steps);			var newWave:Shape;			for(var i:int = 0; i<numWaves; i++){				newWave = drawWave(speakerHeight, speakerWidth,waveStroke,waveStrokeColor);				waves.push(newWave);				trace(waves.length+ 'waves');				newWave.x = speakerWidth + ((i * waveStroke) + (i+1) * speakerWidth/4);				//smallest wave is half the height of the speaker. biggest is height of the speaker.				newWave.scaleX = newWave.scaleY = 0.25 + (((i+1)/numWaves) * 0.75);				newWave.y = speakerHeight/2 - newWave.height/2 + waveStroke/2;				addChild(newWave);			}						//hit area.			hit.graphics.beginFill(0xFF00FF, 0);			hit.graphics.drawRect(0,0,this.width,this.height);			hit.graphics.endFill();			addChild(hit);			trace('hit area: '+hit.width+"x"+hit.height);			this.hitArea = hit;			//behavior			this.reduceOnClick = reduceOnClick;			//volume & wave display default			this.volumeLevel = Math.floor(this.steps * Math.min(1,defaultVolume));			updateWaveDisplay(this.volumeLevel);			this.volumePercent = this.volumeLevel/this.steps;			SoundMixer.soundTransform = new SoundTransform(volumePercent);			//add listeners			this.addEventListener(MouseEvent.CLICK, toggleVolume);			this.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);			this.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);			this.buttonMode = true;		}		private function drawWave(speakerHeight:Number, speakerWidth:Number,stroke:Number,strokeColor:uint):Shape{			var newWave:Shape = new Shape();			newWave.graphics.lineStyle(stroke,strokeColor,1,false,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND);			newWave.graphics.moveTo(0,0);			newWave.graphics.curveTo(speakerWidth,speakerHeight/2,0,speakerHeight);			return newWave;		}		protected function onBtnOver(evt:MouseEvent):void{			if(!evt){				//null was passed as the event. make sure we start with our resting case, with alpha's all == 1;				for each(var wave:Shape in waves){				wave.alpha = 1;				}			}			_mouseOver = true;			var nextVolumeLevel:int;			if(reduceOnClick){				nextVolumeLevel = volumeLevel-1;				if(nextVolumeLevel == -1){					nextVolumeLevel = steps;					for each(var wave1:Shape in waves){						wave1.alpha = 0.5;						wave1.visible = true;					}				}else{					waves[nextVolumeLevel].alpha = 0.5;					}			}else{				nextVolumeLevel = volumeLevel+1;				if(nextVolumeLevel > steps){					nextVolumeLevel = 0;					for each(var wave2:Shape in waves){						wave2.alpha = 0.5;						wave2.visible = true;					}				}else{					waves[nextVolumeLevel-1].alpha = 0.5;					}							}		}		protected function onBtnOut(evt:MouseEvent):void{			_mouseOver = false;			for each(var wave:Shape in waves){				wave.alpha = 1;			}			updateWaveDisplay(volumeLevel);		}		private function toggleVolume(evt:MouseEvent):void{			if(reduceOnClick){				volumeLevel--;				if(volumeLevel == -1){					volumeLevel = steps;				}			}else{				volumeLevel++;				if(volumeLevel > steps){					volumeLevel = 0;				}			}			updateWaveDisplay(volumeLevel);			if(_mouseOver){				onBtnOver(null);			}			volumePercent = volumeLevel/steps;			trace("toggleVolume: "+volumePercent);			dispatchEvent(new VolumeButtonEvent(VolumeButtonEvent.VOLUME_CHANGE, volumePercent));			//SoundMixer.soundTransform = new SoundTransform(volumePercent);		}		private function updateWaveDisplay(level:int):void{			for (var i:int = 0; i<waves.length; i++){				if(i+1>level){					waves[i].visible = false;				}else{					waves[i].visible = true;				}			}		}		public function set color(value:uint):void{			var ct:ColorTransform = new ColorTransform();			ct.color= value;			this.transform.colorTransform = ct;		}	}}