//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------
package com.fenhongxiang.srt
{
	import flash.events.Event;
	public class SRTLoaderEvent extends Event
	{
		public static  const ERROR:String = "字幕加载失败";
		public static  const LOADED:String = "字幕加载完成";
		
		public function SRTLoaderEvent(type:String, data:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		private var _data:*;
		
		public function get data():*
		{
			return _data;
		}
	}
}
