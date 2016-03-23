//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.vtt
{
	import flash.geom.Rectangle;
	
	public class VTTModel
	{

		/**
		 *
		 * @param timeString 时间格式为 00:00:20.000 --> 00:00:25.000的字符串
		 * @param data 时间区间对应的内容，格式为：/assets/306560850.mp4.jpg#xywh=6,71,100,60
		 *
		 * */
		public function VTTModel(time:String, data:String)
		{
			timeRange = time;
			imageRange = data;
		}

		private var _imageRect:Rectangle = new Rectangle(0, 0, 0, 0);
		private var _path:String;
		private var _timeRange:Rectangle = new Rectangle(0, 0, 0, 1);

		public function getImageRange(time:Number):Rectangle
		{
			if (time > _timeRange.x && _timeRange.contains(time, 0))
			{
				return _imageRect;
			}

			return null;
		}

		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			_path = value;
		}

		/**
		 * 时间点的秒数形式
		 *
		 * @param value  格式为:00:00:20.000
		 *
		 * */
		private function getTotalSeconds(value:String):Number
		{
			if (value)
			{
				var timeArr:Array = value.split(':');
				return timeArr[0] * 3600 + timeArr[1] * 60 + timeArr[2] * 1;
			}

			return 0;
		}

		/**
		 * 包含缩略图文件信息的字符串，格式为：<b>/assets/306560850.mp4.jpg#xywh=6,71,100,60</b>
		 *
		 * */
		private function set imageRange(str:String):void
		{
			if (str != null && str != "")
			{
				var thumbArr:Array = str.split("#");

				if (thumbArr != null && thumbArr.length == 2)
				{
					path = thumbArr[0];

					//xywh=\d.\d{1,},\d{1,},\d{1,}
					var thumbPos:String = thumbArr[1]; //xywh=6,71,100,60
					var thumbData:Array = String(thumbPos.split("=")[1]).split(",");

					if (thumbData && thumbData.length == 4)
					{
						_imageRect.x = thumbData[0];
						_imageRect.y = thumbData[1];
						_imageRect.width = thumbData[2];
						_imageRect.height = thumbData[3];
					}
				}
			}
		}

		/**
		 * 	时间格式为 00:00:20.000 --> 00:00:25.000的字符串
		 *
		 * */
		private function set timeRange(str:String):void
		{
			var reg:RegExp = new RegExp('[0-9][0-9]:[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9] --> [0-9][0-9]:[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]', 'i')

			if (str != null && str != "")
			{
				var timeArray:Array = str.match(reg);
				var timeStr:String;

				if (timeArray != null && timeArray.length > 0)
				{
					timeStr = timeArray[0];
					timeArray = str.split('-->');

					_timeRange.x = getTotalSeconds(timeArray[0]);

					_timeRange.width = getTotalSeconds(timeArray[1]) - _timeRange.x;
				}
			}
		}
	}
}
