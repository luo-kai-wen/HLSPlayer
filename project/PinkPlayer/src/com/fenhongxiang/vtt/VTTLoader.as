//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.vtt
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class VTTLoader extends EventDispatcher
	{

		public function VTTLoader()
		{
		}

		private var _loader:URLLoader;
		public static var imageURL:String;
		
		public function load(url:String):void
		{
			imageURL = url;
			
			if (imageURL)
			{
				imageURL = imageURL.substr(0, imageURL.lastIndexOf("/"));
			}
			
			_loader = getLoaderInstance();

			try
			{
				_loader.load(new URLRequest(url));
			}
			catch (e:*)
			{
				errorHandler();
			}
		}
		//----------------------------event handlers-------------------------------------------------//
		
		private function errorHandler(e:* = null):void
		{
			removeListeners();
			dispatchEvent(new VTTLoaderEvent(VTTLoaderEvent.ERROR, null, true));
		}
		
		private function loadedHandler(e:Event):void
		{
			var vttStr:String = e.target.data;
			var vttData:Vector.<VTTModel> = parseVTT(vttStr);

			if (vttData)
			{
				removeListeners();
				dispatchEvent(new VTTLoaderEvent(VTTLoaderEvent.LOADED, vttData, true));
			}
			else
			{
				errorHandler();
			}
		}

		//----------------------------tool function-------------------------------------------------//
		private function removeListeners():void
		{
			if (_loader != null)
			{
				_loader.removeEventListener(Event.COMPLETE, loadedHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			}
		}
		
		private function getLoaderInstance():URLLoader
		{
			if (_loader == null)
			{
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, loadedHandler, false, 0, true);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			}
			else
			{
				try
				{
					_loader.close();
				}
				catch (e:*)
				{
					
				}
			}
			
			return _loader;
		}
		
		private function parseVTT(src:String):Vector.<VTTModel>
		{
			if (src && src != "")
			{
				var vttArr:Array = src.replace(/\r/g, '').split("\n").filter(vttFilter);
				
				if (vttArr != null && vttArr.length > 0)
				{
					var vttDataArr:Vector.<VTTModel> = new Vector.<VTTModel>();
					
					var len:int = vttArr.length;
					
					for (var i:int = 0; i < len; i += 2)
					{
						vttDataArr.push(new VTTModel(vttArr[i], vttArr[i + 1]));
					}
					
					return vttDataArr;
				}
				
				return null;
			}
			else
			{
				return null;
			}
		}

		private function vttFilter(item:*, index:int, array:Array):Boolean
		{
			return item != "WEBVTT" && item != "";
		}
	}
}
