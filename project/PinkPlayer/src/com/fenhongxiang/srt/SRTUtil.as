//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.srt
{
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.Dictionary;
	
	public final class SRTUtil
	{
		public function SRTUtil()
		{

		}

		private var urlCallBack:Function;
		private var urlDic:Dictionary = new Dictionary();
		private var urlList:Array = [];
		private var urlReq:URLRequest;
		private var urlStream:URLStream;

		/**
		 *
		 * @param urls 包含测试连接的数组。如：['www.a.com/a.srt','www.b.com/b.srt']
		 * @param callBack 测试完成后，结果回调函数。格式为
		 * function a(data:Dictionary):void
		 * {
		 * 		//判断测试的地址是否可用
		 * 		//访问 data[测试地址](ture或者false)
		 * }
		 *
		 */
		public function testURLs(urls:Array, callBack:Function):void
		{
			urlList = urls;

			if (urlList)
			{
				for each (var url:* in urls)
				{
					urlDic[url] = false;
				}

				testURL(urlList.shift());
			}
			else
			{
				if (urlCallBack)
				{
					urlCallBack(null);
				}
			}
		}

		private function onErrorHandler(e:*):void
		{
			urlDic[urlReq.url] = false;
			testURL(urlList.shift());
		}

		//-----------------------------事件处理函数------------------------------------------//
		private function onProgressHandler(e:ProgressEvent):void
		{
			if (e.bytesLoaded > 0)
			{
				urlDic[urlReq.url] = true;
				urlStream.close();
				testURL(urlList.shift());
			}
		}

		private function testURL(url:String):void
		{
			if (url)
			{
				urlReq = new URLRequest(url);

				urlStream = new URLStream();
				urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				urlStream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
				urlStream.load(urlReq);
			}
			else
			{
				if (urlList.length == 0 && urlCallBack)
				{
					urlCallBack(urlDic);
				}
			}
		}
	}
}
