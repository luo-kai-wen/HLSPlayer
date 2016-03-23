//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.srt
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	public final class SRTController
	{
		public function SRTController(url:String)
		{
			load(url);
		}

		private var _srtData:Vector.<SRTModel>;
		private var currentIndex:int = 0;
		private var currentTime:Rectangle = new Rectangle(0, 0, 0, 0);
		private var srtLoader:SRTLoader;

		public function load(path:String):void
		{
			if (srtLoader == null)
			{
				srtLoader = new SRTLoader();
				srtLoader.addEventListener(SRTLoaderEvent.LOADED, onSRTFileLoaded, false, 0, true);
			}

			srtLoader.load(path);
		}

		/**
		 *
		 * @param time 时间点
		 * @param txt  TextField对象引用
		 * @param txtColor 文本颜色（只支持十六进制颜色 (#FFFFFF) 值）
		 * @param fontSize 字体大小 。您可以使用绝对像素大小（如 16 或 18），也可以使用相对点值（如 +2 或 -4）
		 *
		 */
		public function renderSRT(time:Number, txt:TextField, txtColor:String = "#FFFFFF", fontSize:int = 12):void
		{
			if (txt)
			{
				if (!currentTime || !currentTime.contains(time, 0))
				{
					txt.htmlText = "<p align='center'><font color='" + txtColor + "' size='" + fontSize + "' face='微软雅黑'>" + getContentByTime(time) + "</font></p>";
				}
			}
		}
		
		private function onSRTFileLoaded(e:SRTLoaderEvent):void
		{
			this._srtData = e.data;
		}

		private function getContentByTime(time:Number):String
		{
			var str:String = "";

			if (_srtData && _srtData.length > 0)
			{

				if (time >= currentTime.x)
				{
					//先顺着上次找到的位置往下找
					var len:int = _srtData.length;
					for (var i:int = currentIndex; i < len; i++)
					{
						if (_srtData[i].contains(time))
						{
							currentIndex = i;
							currentTime = _srtData[i].time;
							str = _srtData[i].data;
							break;
						}
					}
				}
				else
				{
					//顺着index往前找，直到数组开始位置
					if (!str)
					{
						for (var j:int = currentIndex; j >= 0; j--)
						{
							if (_srtData[j].contains(time))
							{
								currentIndex = j;
								currentTime = _srtData[j].time;
								str = _srtData[j].data;
								break;
							}
						}
					}
				}
			}

			return str;
		}
	}
}
