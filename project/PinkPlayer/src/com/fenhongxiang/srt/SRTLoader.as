/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Copyright © 2015 FenHongXiang                                              */
/* 深圳粉红象科技有限公司                                                                										  */
/* www.fenhongxiang.com                                                       */
/* All rights reserved.                                                       */
/*                                                                            */
/*----------------------------------------------------------------------------*/
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
			if (_loader == null)
			{
				_loader = new URLStream();
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
		
		private function errorHandler(e:*=null):void 
		{
			removeListeners();		
			dispatchEvent(new SRTEvent(SRTEvent.ERROR, null, true));
		}
		
		//----------------------------event handlers-------------------------------------------------//
		private function loadedHandler(e:Event):void 
		{
			var srtStr:String;
			
			//防止中文乱码
			try
			{
				srtStr = _loader.readMultiByte ( _loader.bytesAvailable , "utf-8");
			}
			catch(e:EOFError)
			{
				
			}
			
			var srtData:Vector.<SRTData> = parseSRT(srtStr);
			
			if (srtData)
			{
				removeListeners();				
				dispatchEvent(new SRTEvent(SRTEvent.LOADED, srtData, true));
			}
			else
			{
				errorHandler();
			}
		}
		
		private function  parseSRT(src:String):Vector.<SRTData>
		{
			var srtDataArr:Vector.<SRTData> = new Vector.<SRTData>();

			if (src && src != "")
			{
				var srtArr:Array = src.replace(/\r/g, '').split("\n");
				
				if (srtArr != null)
				{
					var len:int = srtArr.length;
					
					var currentData:SRTData = new SRTData("00", "");
					var tagFound:Boolean = false;
					var currentLineStr:String;
					
					for (var i:int = 0; i < len; i++) 
					{
						currentLineStr = srtArr[i];
						
						if (currentLineStr.match(SRTData.TIME_PATTERN))
						{
							tagFound = true;
							currentData = new SRTData(srtArr[i], null);
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
	}
}