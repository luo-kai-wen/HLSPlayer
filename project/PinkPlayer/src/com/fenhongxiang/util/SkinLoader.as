//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.util
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	public class SkinLoader extends EventDispatcher
	{

		private static var instance:SkinLoader;

		public static function getInstance():SkinLoader
		{
			if (SkinLoader.instance == null)
			{
				SkinLoader.instance = new SkinLoader(new Enforcer());
			}

			return SkinLoader.instance;
		}

		public function SkinLoader(e:Enforcer)
		{
			if (e == null)
			{
				throw new Error("SkinLoader是一个单例对象");
			}
		}

		private var _callBackFunction:Function;
		private var _loader:Loader;
		private var _skinContent:MovieClip;

		public function getSkinPart(name:String, prop:String = null):*
		{
			if (_skinContent != null && _skinContent.hasOwnProperty(name))
			{
				if (prop)
				{
					return _skinContent[name][prop];
				}
				else
				{
					return _skinContent[name];
				}
			}
			else
			{
				return null;
			}
		}

		public function load(url:String, callBack:Function):void
		{
			_callBackFunction = callBack;

			if (_loader == null)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedHandler, false, 0, true);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler, false, 0, true);
				_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler, false, 0, true);
			}

			try
			{
				_loader.close();
			}
			catch (e:*)
			{
				//
			}

			try
			{
				_loader.load(new URLRequest(url));
			}
			catch (e:*)
			{
				onLoadErrorHandler();
			}
		}

		public function get skinContent():MovieClip
		{
			return _skinContent;
		}

		private function onLoadErrorHandler(e:* = null):void
		{
			_skinContent = null;

			if (_callBackFunction != null)
			{
				_callBackFunction(null);
			}

			dispose();
		}

		private function onLoadedHandler(e:Event):void
		{

			_skinContent = e.target.content;

			if (_callBackFunction != null)
			{
				_callBackFunction(_skinContent);
			}

			dispose();
		}

		private function dispose():void
		{
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadedHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler);
				_loader = null;
			}

			_callBackFunction = null;
		}
	}
}

class Enforcer
{
}
