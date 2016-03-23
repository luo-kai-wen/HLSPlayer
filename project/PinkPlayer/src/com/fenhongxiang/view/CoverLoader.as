//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.view
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class CoverLoader extends Sprite
	{

		public function CoverLoader(w:Number, h:Number)
		{
			drawBackground(w, h);
		}

		private var _h:Number=0;
		private var _w:Number=0;
		private var ldr:Loader;

		public function load(path:String):void
		{
			if (ldr == null)
			{
				ldr = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onCoverLoadedHandler, false, 0, true);
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onCoverLoadErrorHandler, false, 0, true);
			}

			ldr.load(new URLRequest(path));
		}

		private function drawBackground(w:Number, h:Number):void
		{
			_w = w;
			_h = h;
			
			this.graphics.clear();
			this.graphics.beginFill(0x1F272A, 1);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}

		private function onCoverLoadErrorHandler(e:IOErrorEvent):void
		{

		}

		private function onCoverLoadedHandler(e:Event):void
		{
			ldr.width = _w;
			ldr.height = _h;
			
			if (!this.contains(ldr))
			{
				this.addChild(ldr);
			}
		}
	}
}
