package com.fenhongxiang.util
{
	public final class TimeUtil
	{
		public function TimeUtil()
		{
		}
		
		public static function getTimeString(time:Number):String
		{
			//把时间后面的毫秒数去掉，如59.885秒变为59秒
			time = Math.floor(time);
			
			var timeStr:String;
			var min:int;
			var sec:int;
			var hour:int;
			
			if(time < 3600){
				min = Math.floor(time / 60);
				sec = Math.floor(time % 60);			
				timeStr = (min < 10 ? "0"+min : min) + ":" + (sec < 10 ? "0"+sec : sec);
			}else{
				hour = Math.floor(time / 3600);
				min = Math.floor((time - hour * 3600) / 60);
				sec = Math.floor((time - hour * 3600) % 60);			
				timeStr = (hour < 10 ? "0"+hour : hour) + ":" + (min < 10 ? "0"+min : min) + ":" + (sec < 10 ? "0"+sec : sec);					
			}
			return timeStr;
		}	
	}
}