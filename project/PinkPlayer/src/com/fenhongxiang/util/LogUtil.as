//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------
package com.fenhongxiang.util
{
	import flash.external.ExternalInterface;
	public final class LogUtil
	{
		private static const LEVEL_DEBUG:String = "DEBUG:";
		private static const LEVEL_ERROR:String = "ERROR:";
		
		private static const LEVEL_INFO:String = "INFO:";
		private static const LEVEL_WARN:String = "WARN:";
		
		public static function debug(message:*):void
		{
			outputlog(LEVEL_DEBUG, String(message));
		}
		
		public static function debug2(message:*):void
		{
			outputlog(LEVEL_DEBUG, String(message));
		}
		
		public static function error(message:*):void
		{
			outputlog(LEVEL_ERROR, String(message));
		}
		
		public static function info(message:*):void
		{
			outputlog(LEVEL_INFO, String(message));
		}
		
		public static function warn(message:*):void
		{
			outputlog(LEVEL_WARN, String(message));
		}
		
		private static function outputlog(level:String, message:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call('console.log', level + message);
			}
			else
			{
				trace(level + message);
			}
		}

		public function LogUtil()
		{
		}
	}
}
