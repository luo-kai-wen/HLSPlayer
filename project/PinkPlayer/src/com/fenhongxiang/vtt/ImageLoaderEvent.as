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
	import flash.events.Event;
	public class ImageLoaderEvent extends Event
	{
		public static const ERROR:String = "图像加载失败";
		public static const LOADED:String = "图像加载完成";

		public function ImageLoaderEvent(type:String, data:BitmapData, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		private var _data:BitmapData;

		public function get data():BitmapData
		{
			return _data;
		}
	}
}
