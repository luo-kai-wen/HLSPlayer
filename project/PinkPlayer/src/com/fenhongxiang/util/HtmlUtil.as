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
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	public final class HtmlUtil
	{
		
		// AS3 Regular expression pattern match for URLs that start with http:// and https:// plus your domain name. 
		public static function checkProtocol(flashVarURL:String):Boolean
		{
			// Get the domain name for the SWF if it is not known at compile time. 
			// If the domain is known at compile time, then the following two lines can be replaced with a hard coded string. 
			var my_lc:LocalConnection = new LocalConnection();
			var domainName:String = my_lc.domain;
			
			if (ExternalInterface.available)
			{
				ExternalInterface.call('console.log', domainName);
			}
			// Build the RegEx to test the URL. 
			// This RegEx assumes that there is at least one "/" after the // domain. http://www.mysite.com will not match. 
			var pattern:RegExp = new RegExp("ˆhttp[s]?\:\\/\\/([ˆ\\/]+)\\/");
			var result:Object = pattern.exec(flashVarURL);
			
			if (result == null || result[1] != domainName || flashVarURL.length >= 4096)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public static function getBrowserString():String
		{
			if (ExternalInterface.available)
			{
				var broswerStr:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}") as String;
				return broswerStr;
			}
			else
			{
				return "";
			}
		}
		
		public static function gotoURL(url:String, window:String = "_blank"):void
		{
			var broswer:String = getBrowserString();
			
			if (broswer && (broswer.indexOf("Firefox") != -1 || broswer.indexOf("MSIE") != -1))
			{
				navigateToURL(new URLRequest(url), window);
			}
			else
			{
				var eval:String = "function openNewHtml(){window.open('" + url + "')}";
				ExternalInterface.call("eval", eval);
				ExternalInterface.call("openNewHtml");
			}
		}
		
		public static function pageRefresh(url:String):void
		{
			var eval:String = "function refresh(){window.location.href = '" + url + "'}";
			ExternalInterface.call("eval", eval);
			ExternalInterface.call("refresh");
		}

		public function HtmlUtil()
		{
		
		}
	}
}
