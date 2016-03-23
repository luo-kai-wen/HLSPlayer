package com.fenhongxiang.util
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public final class HtmlUtil
	{
		public function HtmlUtil()
		{
			
		}
		
		public static function browser():String 
		{
			if (ExternalInterface.available) 
			{
				var broswer:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}") as String;
				return broswer;
			}			
			return "";
		}
		
		public static function gotoURL(url:String, window:String = "_blank"):void 
		{
			var broswer:String = browser();
			
			if (broswer && (broswer.indexOf("Firefox") != -1 || broswer.indexOf("MSIE") != -1)) 
			{
				navigateToURL(new URLRequest(url), window);
			}
			else
			{
				var eval:String = "function openNewHtml(){window.open('"+url+"')}";
				ExternalInterface.call("eval", eval);
				ExternalInterface.call("openNewHtml");
			}
		}
		
		public static function pageRefresh(url:String):void
		{			
			var eval:String = "function refresh(){window.location.href = '"+url+"'}";
			ExternalInterface.call("eval", eval);
			ExternalInterface.call("refresh");
		}
	}
}