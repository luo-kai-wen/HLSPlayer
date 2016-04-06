//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.view
{
	import com.fenhongxiang.cue.CueData;
	import com.fenhongxiang.event.FResizeEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	public class FSprite extends Sprite
	{
		public function FSprite()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler, false, 0, true);
			this.addEventListener(Event.RENDER, onRenderHandler, false, 0, true);
		}
		
		private var _backgroudColor:uint = 0xffffff;
		private var _backgroundAlpha:Number = 1.0;
		private var _border:Boolean = false;
		private var _borderColor:uint = 0;
		private var _data:CueData;
		private var _height:Number = 300;
		private var _viewDirty:Boolean = false;
		private var _width:Number = 300;
		
		public function get backgroudColor():uint
		{
			return _backgroudColor;
		}
		
		public function set backgroudColor(value:uint):void
		{
			if (_backgroudColor != value)
			{
				_backgroudColor = value;
				_viewDirty = true;
				invalidateDisplaylist();
			}
		}
		
		public function set backgroundAlpha(value:Number):void
		{
			if (_backgroundAlpha != value)
			{
				_backgroundAlpha = value;
				_viewDirty = true;
				invalidateDisplaylist();
			}
		}
		
		public function get border():Boolean
		{
			return _border;
		}
		
		public function set border(value:Boolean):void
		{
			if (_border != value)
			{
				_border = value;
				_viewDirty = true;
				invalidateDisplaylist();
			}
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				_viewDirty = true;
				invalidateDisplaylist();
				this.dispatchEvent(new FResizeEvent(FResizeEvent.SIZE_CHANGE));
			}
		}
		
		public function onRenderHandler(e:Event):void
		{
			if (_viewDirty)
			{
				this.graphics.clear();
				
				if (_border)
				{
					this.graphics.lineStyle(1, _borderColor);
				}
				
				this.graphics.beginFill(_backgroudColor, _backgroundAlpha);
				this.graphics.drawRect(0, 0, _width, _height);
				this.graphics.endFill();
				
				_viewDirty = false;
			}
		}
		
		public function resize(w:Number, h:Number):void
		{
			width = w;
			height = h;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				_viewDirty = true;
				invalidateDisplaylist();
				this.dispatchEvent(new FResizeEvent(FResizeEvent.SIZE_CHANGE));
			}
		}
		
		protected function invalidateDisplaylist():void
		{
			if (this.stage)
			{
				this.stage.invalidate();
			}
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			
			_viewDirty = true;
			invalidateDisplaylist();
		}
	}
}
