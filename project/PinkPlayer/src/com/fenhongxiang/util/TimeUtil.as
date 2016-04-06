//------------------------------------------------------------------------------
//
//   Copyright 2016 R2Games 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.util
{
	public final class TimeUtil
	{
		
		public static function getTimeString(value:Number):String
		{
			//把时间后面的毫秒数去掉，如59.885秒变为59秒
			var time:Number = Math.floor(value);
			
			if (time < 3600)
			{
				var min1:int = Math.floor(time / 60);
				var sec1:int = Math.floor(time % 60);
				
				return (min1 < 10 ? "0" + min1 : min1) + ":" + (sec1 < 10 ? "0" + sec1 : sec1);
			}
			else
			{
				var hour:int = Math.floor(time / 3600);
				var min:int = Math.floor((time - hour * 3600) / 60);
				var sec:int = Math.floor((time - hour * 3600) % 60);
				
				return (hour < 10 ? ("0" + hour) : hour) + ":" + (min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec);
			}
		}

		public function TimeUtil()
		{
		}
	}
}
