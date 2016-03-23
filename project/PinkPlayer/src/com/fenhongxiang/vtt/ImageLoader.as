//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.vtt
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	internal class ImageLoader extends EventDispatcher
	{
		public function ImageLoader(target:IEventDispatcher = null)
		{
			super(target);
		}

		private var _loader:Loader;

		public function load(url:String):void
		{
			_loader = getLoaderInstance();
			
			try
			{
				_loader.load(new URLRequest(url));
			}
			catch (e:*)
			{
				onLoadErrorHandler();
			}
		}

		private function onLoadErrorHandler(e:* = null):void
		{
			dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.ERROR, null, true));
			removeListeners();
		}

		private function onLoadedHandler(e:Event):void
		{
			var bitMap:Bitmap = e.target.content as Bitmap;

			if (bitMap != null)
			{
				var imgData:BitmapData = bitMap.bitmapData.clone();
				bitMap.bitmapData.dispose();

				dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.LOADED, imgData, true));
				removeListeners();
			}
			else
			{
				//加载的数据不是位图，则也视为加载失败
				onLoadErrorHandler();
			}
		}
		
		private function getLoaderInstance():Loader
		{
			if (_loader == null)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedHandler, false, 0, true);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler, false, 0, true);
				_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler, false, 0, true);
			}
			
			try
			{
				_loader.close();
			}
			catch (e:*)
			{
				//
			}
			
			return _loader;
		}

		private function removeListeners():void
		{
			if (_loader != null)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadedHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler);
			}
		}
	}
}
