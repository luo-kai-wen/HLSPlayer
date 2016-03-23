/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package com.fenhongxiang.vtt
{
	import flash.events.Event;
	
	public class VTTLoaderEvent extends Event
	{
		public static const LOADED:String = "加载完成";
		public static const ERROR:String = "加载失败";
		
		private var _data:*;
		
		public function VTTLoaderEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		public function get data():*
		{
			return _data;
		}
	}
}