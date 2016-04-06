//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.util
{
	import flash.display.Stage;
	public final class ObjectUtil
	{
		
		public static function available(obj:Object, ... args):Boolean
		{
			if (obj == null)
			{
				return false;
			}
			else
			{
				for each (var prop:* in args)
				{
					if (!obj.hasOwnProperty(prop) || obj[prop] == null)
					{
						return false;
						break;
					}
				}
				
				return true;
			}
		}
		
		public static function getSWFParameter(name:String, stage:Stage):String
		{
			if (stage != null && name)
			{
				return stage.loaderInfo.parameters[name];
			}
			else
			{
				return "";
			}
		}
		
		public static function parseBoolean(value:*):Boolean
		{
			if (value is String)
			{
				return (value == "true") ? true : false;
			}
			else
			{
				return Boolean(value);
			}
		}

		public function ObjectUtil()
		{
		}
	}
}
