/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package com.fenhongxiang.vtt
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class ImageEvent extends Event
	{
		public static const LOADED:String = "图像加载完成";
		public static const ERROR:String  = "图像加载失败";
		private var _data:BitmapData;
		public function ImageEvent(type:String, data:BitmapData, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data():BitmapData
		{
			return _data;
		}
	}
}