package com.fenhongxiang.util
{
	import flash.display.Stage;

	public final class ObjectUtil
	{
		public function ObjectUtil()
		{
		}
		
		public static function available(obj:Object, ...args):Boolean
		{
			if(obj == null) return false;
			
			for each(var prop:* in args)
			{
				if (!obj.hasOwnProperty(prop) || obj[prop] == null )
				{
					return false;
					break;
				}
			}
			
			return true;
		}
		
		public static function parseBoolean(value:*):Boolean
		{
			var result:Boolean=false;
			
			if (value is String)
			{
				result=(value == "true") ? true : false;
			}
			else
			{
				result=Boolean(value);
			}
			
			return result;
		}
		
		public static function getSWFParameter(name:String, stage:Stage):String
		{
			var paramValue:* = "";
			
			if (stage && name)
			{
				paramValue = stage.loaderInfo.parameters[name];
			}
			
			return paramValue;
		}
	}
}