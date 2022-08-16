﻿package com.banners{	import flash.display.*;	import flash.geom.*;	public class CopySlicer	{		public static function createSlicedCopy(aSprite : DisplayObject, sliceColor : Number = 0xFF000000) : MovieClip		{			var copyReference : DisplayObject = aSprite;			var width : Number = (aSprite.getBounds(aSprite).left + aSprite.getBounds(aSprite).right);			var height : Number = (aSprite.getBounds(aSprite).top + aSprite.getBounds(aSprite).bottom);			var bmpd : BitmapData = new BitmapData(width, height, true, 0x00000000);			bmpd.draw(copyReference, null, null, null, null, true);			if (aSprite.stage != null)			{				aSprite.parent.removeChild(aSprite);			}			var returnBitmap : Bitmap = new Bitmap();			var returnSprite : Sprite = new Sprite();			var pixelValue : uint;			var alphaValue : uint;			var alphaFlag : Boolean = true;			var spanArray : Array = [];			var evaluatePixels = CopySlicer.evaluatePixels;			if (sliceColor == 0xFF000000)			{				evaluatePixels = CopySlicer.evaluatePixelsAlpha;			}			for (var i = 0;i < height;i++)			{				var hasContent = false;				for (var j = 0; j < width;j++)				{					if (evaluatePixels(j, i, sliceColor, bmpd))					{						hasContent = true;					}				}				if (!hasContent && !alphaFlag)				{					alphaFlag = true;					if (span)					{						span.end = i;						spanArray.push(span);					}				}				else if (hasContent && alphaFlag)				{					var span = {begin:i};					alphaFlag = false;				}			}			return (CopySlicer.createSpriteWithSpanArray(spanArray, bmpd, aSprite));		}		private static function evaluatePixelsAlpha(j : int, i : int, sliceColor : uint, bmpd)		{			var pixelValue = bmpd.getPixel32(j, i);			var alphaValue = pixelValue >> 24 & 0xFF;			return alphaValue > 0;		}		private static function evaluatePixels(j, i, sliceColor, bmpd)		{			return bmpd.getPixel(j, i) != sliceColor;		}		private static function createSpriteWithSpanArray(arr : Array, bmpd, originalSprite : DisplayObject) : MovieClip		{			var returnSprite : MovieClip = new MovieClip;			returnSprite.blendMode = originalSprite.blendMode;			returnSprite.transform.matrix = originalSprite.transform.matrix;			trace(originalSprite.width);			for (var i : int = 0;i < arr.length;i++)			{				var span = arr[i];				var spriteHeight = span.end - span.begin;				var bd = new BitmapData(bmpd.width, spriteHeight, true, 0x00000000);				bd.copyPixels(bmpd, new Rectangle(0, span.begin, bmpd.width, spriteHeight), new Point(0, 0));				var mc = new Bitmap(bd);				mc.y = span.begin;				mc.x = 0;				returnSprite.addChild(mc);			}			return returnSprite;		}	}}