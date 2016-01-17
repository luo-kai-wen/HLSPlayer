/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */
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
		private var _loader:URLLoader;
		
		public function VTTLoader()
		{
		}
		
		public function load(url:String):void 
		{
			if (_loader == null)
			{
				_loader = new URLLoader();
			}
			else
			{
				try
				{
					_loader.close();
				}
				catch(e:*)
				{
					
				}
			}
			
			_loader.addEventListener(Event.COMPLETE, loadedHandler, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			
			try
			{
				_loader.load(new URLRequest(url));
			}
			catch(e:*)
			{
				errorHandler();
			}
		}
		
		//----------------------------event handlers-------------------------------------------------//
		private function loadedHandler(e:Event):void 
		{
			var vttStr:String = e.target.data;
			var vttData:Vector.<VTTModel> = parseVTT(vttStr);
			
			if (vttData)
			{
				removeListeners();				
				dispatchEvent(new VTTEvent(VTTEvent.LOADED, vttData, true));
			}
			else
			{
				errorHandler();
			}
		}
		
		private function errorHandler(e:*=null):void 
		{
			removeListeners();		
			dispatchEvent(new VTTEvent(VTTEvent.ERROR, null, true));
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
		
		private function  parseVTT(src:String):Vector.<VTTModel>
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
						vttDataArr.push(new VTTModel(vttArr[i], vttArr[i+1]));
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