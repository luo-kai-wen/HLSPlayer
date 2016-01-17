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
	import flash.events.Event;
	public class SRTEvent extends Event
	{
		static public  const ERROR:String = "字幕加载失败";
		static public  const LOADED:String = "字幕加载完成";
		
		public function SRTEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
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