/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package com.fenhongxiang.vtt
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class VTTControler
	{
		public function VTTControler(url:String)
		{
			load(url);
		}
		
		private  var _vttData:Vector.<VTTModel>;
		private  var _imageData:BitmapData;
		private  var _path:String;
		
		/**
		 * 
		 * image file path
		 * 
		 * */
		private var ldr:ImageLoader;
		private  function set imagePath(path:String):void
		{
			if (path && _path != path)
			{
				_path = path;
				
				ldr = new ImageLoader();
					ldr.addEventListener(ImageEvent.LOADED, onThumbLoadedHandler);
					ldr.load(path);
			}
		}
		
		private  function onThumbLoadedHandler(e:ImageEvent):void
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

		private  function set imageData(value:*):void
		{
			if (_imageData != null)
			{
				_imageData.dispose();
			}
			
			_imageData = value;
		}
		
		private var vttLoader:VTTLoader;
		public function load(path:String):void
		{
			if (vttLoader == null)
			{
				vttLoader = new VTTLoader();
			}
			
			vttLoader.addEventListener(VTTEvent.LOADED, onVTTFileLoaded);
			vttLoader.load(path);
		}
		
		private  function onVTTFileLoaded(e:VTTEvent):void
		{
			this.vttData = e.data;
		}
		
		/**
		 * 
		 * @param time 
		 * @param img
		 * 
		 */		
		public  function renderImage(time:Number, img:BitmapData):void
		{
			if (img)
			{
				img.fillRect(img.rect,  0x00FFFFFF);
			}
			
			if (_imageData)
			{
				var range:Rectangle = getImageRangeByTime(time);
				if (range)
				{
					try
					{
						img.copyPixels(this._imageData, range, new Point(0,0));
					} 
					catch(error:Error) 
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
		private  function getImageRangeByTime(time:Number):Rectangle
		{
			var imageRange:Rectangle = null;
			
			if (_vttData && _vttData.length)
			{
				for each(var obj:VTTModel in _vttData)
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

		private  function set vttData(value:Vector.<VTTModel>):void
		{
			_vttData = value;
			
			if (_vttData && _vttData.length)
			{
				imagePath = '.'+_vttData[0].path;
			}
		}
	}
}