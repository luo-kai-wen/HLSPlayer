/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */
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
		public function ImageLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private  var _loader:Loader;
		public  function load(url:String):void 
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
		   catch(e:*)
		   {
			   //
		   }
		   
		   try
		   {
			   _loader.load(new URLRequest(url));
		   }
		   catch(e:*)
		   {
			   onLoadErrorHandler();
		   }
		}
		
		private  function onLoadedHandler(e:Event):void
		{
			var bitMap:Bitmap = e.target.content as Bitmap;
			
			if (bitMap)
			{
				var imgData:BitmapData = bitMap.bitmapData.clone();;
					bitMap.bitmapData.dispose();
					
				dispatchEvent(new ImageEvent(ImageEvent.LOADED, imgData, true));
				removeListeners();
			}
			else
			{
				//加载的数据不是位图，则也视为加载失败
				onLoadErrorHandler();
			}
		}
		
		private  function onLoadErrorHandler(e:*=null):void
		{
			dispatchEvent(new ImageEvent(ImageEvent.ERROR, null, true));
			removeListeners();
		}
		
		private function removeListeners():void
		{
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadedHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler);
			}
		}
	}
}