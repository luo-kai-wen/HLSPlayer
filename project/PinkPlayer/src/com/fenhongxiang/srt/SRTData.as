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
	import flash.geom.Rectangle;
	public class SRTData
	{
		static public  const TIME_PATTERN:RegExp = new RegExp('[0-9][0-9]:[0-9][0-9].[0-9][0-9],[0-9][0-9][0-9] --> [0-9][0-9]:[0-9][0-9].[0-9][0-9],[0-9][0-9][0-9]', 'i');
		
		/**
		 * 
		 * @param timeString 时间格式为 00:00:00,000 --> 00:00:12,700的字符串
		 * @param data 字幕文本内容
		 * 
		 * */
		public function SRTData(time:String=null, data:String=null)
		{
			_time = time;
			_data = data;
		}

		private var _data:String;
		private var _time:String;
		private var _timeRange:Rectangle = null;
		
		public function appendContent(str:String):void
		{
			_data = "<p>"+(_data == null ? "":_data) + str + "</p>";
//			_data = (_data == null ? "":_data) + str;
		}
		
		public function contains(time:Number):Boolean
		{
			//还未初始化
			if (_timeRange == null)
			{
				timeRange = _time;
			}
			
			return _timeRange != null && _timeRange.contains(time, 0);
		}
		
		public function get data():String
		{
			return _data;
		}
		
		public function get time():Rectangle
		{
			//还未初始化
			if (_timeRange == null)
			{
				timeRange = _time;
			}
			
			return _timeRange;
		}
		
		/**
		 * 时间点的秒数形式
		 * 
		 * @param value  格式为:00:00:20,000
		 * 
		 * */
		private function getTotalSeconds(value:String):Number
		{
			if (value)
			{
				var timeArr:Array = value.split(':');
				var secPart:Array = String(timeArr[2]).split(",");
				
				return parseFloat(timeArr[0])*3600 + parseFloat(timeArr[1])*60 + parseFloat(secPart[0]) + parseFloat(secPart[1])/1000;
			}
			
			return 0;
		}
		
		/**
		 * 	时间格式为 00:00:20.000 --> 00:00:25.000的字符串 
		 * 
		 * */
		private function set timeRange(str:String):void
		{
			_timeRange = new Rectangle(0, 0, 0, 1);
			
			if (str != null && str != "")
			{
				var timeArray:Array = str.match(TIME_PATTERN);
				var timeStr:String;
				
				if (timeArray != null && timeArray.length > 0)
				{
					timeStr =timeArray[0];
					timeArray = str.split('-->');
					
					_timeRange.x = getTotalSeconds(timeArray[0]);
					_timeRange.width = getTotalSeconds(timeArray[1]) - _timeRange.x;
				}
			}
		}
	}
}