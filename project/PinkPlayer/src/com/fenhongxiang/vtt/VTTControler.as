//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.vtt
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class VTTControler
	{
		
		
		public function VTTControler(url:String):void
		{
			load(url);
		}

		private var _imageData:BitmapData;
		private var _path:String;
		private var _vttData:Vector.<VTTModel>;
		private var ldr:ImageLoader;
		private var vttLoader:VTTLoader;

		public function load(path:String):void
		{
			if (vttLoader == null)
			{
				vttLoader = new VTTLoader();
				vttLoader.addEventListener(VTTLoaderEvent.LOADED, onVTTFileLoaded, false, 0, true);
			}

			vttLoader.load(path);
		}

		/**
		 *
		 * @param time
		 * @param img
		 *
		 */
		public function renderImage(time:Number, img:BitmapData):void
		{
			if (img)
			{
				img.fillRect(img.rect, 0x00FFFFFF);
			}

			if (_imageData)
			{
				var range:Rectangle = getImageRangeByTime(time);
				if (range)
				{
					try
					{
						img.copyPixels(this._imageData, range, new Point(0, 0));
					}
					catch (error:Error)
					{
						//do things here...
					}
				}
			}
		}

		/**
		 *
		 * get image position by time
		 *
		 * */
		private function getImageRangeByTime(time:Number):Rectangle
		{
			var imageRange:Rectangle = null;

			if (_vttData && _vttData.length)
			{
				for each (var obj:VTTModel in _vttData)
				{
					imageRange = obj.getImageRange(time);

					if (imageRange)
					{
						return imageRange;
					}
				}
			}

			return imageRange;
		}

		//---------------------------------- setters and getters ----------------------------------//
		private function set imageData(value:*):void
		{
			if (_imageData != null)
			{
				_imageData.dispose();
			}

			_imageData = value;
		}

		private function set imagePath(path:String):void
		{
			if (path && _path != path)
			{
				_path = path;

				ldr = new ImageLoader();
				ldr.addEventListener(ImageLoaderEvent.LOADED, onThumbLoadedHandler);
				ldr.load(path);
			}
		}
		
		//---------------------------------- event handlers ----------------------------------//
		private function onThumbLoadedHandler(e:ImageLoaderEvent):void
		{
			if (e.data)
			{
				_imageData = e.data.clone();
				e.data.dispose();
			}
			else
			{
				_imageData = null;
			}
		}

		private function onVTTFileLoaded(e:VTTLoaderEvent):void
		{
			this.vttData = e.data;
		}
		
		private function set vttData(value:Vector.<VTTModel>):void
		{
			_vttData = value;
			
			if (_vttData && _vttData.length)
			{
				imagePath = VTTLoader.imageURL + '/' + _vttData[0].path;
			}
		}
	}
}
