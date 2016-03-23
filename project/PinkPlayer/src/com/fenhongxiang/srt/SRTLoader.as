//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.srt
{
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	public class SRTLoader extends EventDispatcher
	{
		public function SRTLoader()
		{
		}

		private var _loader:URLStream;

		public function load(url:String):void
		{
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
			dispatchEvent(new SRTLoaderEvent(SRTLoaderEvent.ERROR, null, true));
		}
		
		private function loadedHandler(e:Event):void
		{
			var srtStr:String;

			//防止中文乱码
			try
			{
				srtStr = _loader.readMultiByte(_loader.bytesAvailable, "utf-8");
			}
			catch (e:EOFError)
			{

			}

			var srtData:Vector.<SRTModel> = parseSRT(srtStr);

			if (srtData)
			{
				removeListeners();
				dispatchEvent(new SRTLoaderEvent(SRTLoaderEvent.LOADED, srtData, true));
			}
			else
			{
				errorHandler();
			}
		}

		//----------------------------tool function-------------------------------------------------//
		
		private function parseSRT(src:String):Vector.<SRTModel>
		{
			var srtDataArr:Vector.<SRTModel> = new Vector.<SRTModel>();
			
			if (src && src != "")
			{
				var srtArr:Array = src.replace(/\r/g, '').split("\n");
				
				if (srtArr != null)
				{
					var len:int = srtArr.length;
					
					var currentData:SRTModel = new SRTModel("00", "");
					var tagFound:Boolean = false;
					var currentLineStr:String;
					
					for (var i:int = 0; i < len; i++)
					{
						currentLineStr = srtArr[i];
						
						if (currentLineStr.match(SRTModel.TIME_PATTERN))
						{
							tagFound = true;
							currentData = new SRTModel(srtArr[i], null);
						}
						else
						{
							//空行是下一个字幕的开始
							if (currentLineStr == "")
							{
								tagFound = false;
								srtDataArr.push(currentData);
							}
							else
							{
								if (tagFound)
									currentData.appendContent(currentLineStr);
							}
						}
					}
				}
			}
			
			return srtDataArr;
		}

		private function removeListeners():void
		{
			if (_loader != null)
			{
				_loader.removeEventListener(Event.COMPLETE, loadedHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			}
		}
		
		private function getLoaderInstance():URLStream
		{
			if (_loader == null)
			{
				_loader = new URLStream();
				_loader.addEventListener(Event.COMPLETE, loadedHandler, false, 0, true);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			}
			
			try
			{
				_loader.close()
			}
			catch(e:Error)
			{
				
			}
			
			return _loader;
		}
	}
}
