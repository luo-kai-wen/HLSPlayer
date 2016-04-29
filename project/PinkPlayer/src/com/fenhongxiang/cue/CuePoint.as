//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.cue
{
	import com.fenhongxiang.event.FResizeEvent;
	import com.fenhongxiang.view.FSprite;
	
	import flash.events.MouseEvent;

	public class CuePoint extends FSprite
	{
		public function CuePoint()
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			
			border = false;
			backgroudColor = 0xffb81d;
			resize(3, 10);
			addEventListeners();
		}
		
		private var _container:FSprite;
		private var _data:CueData;
		
		public function get data():CueData
		{
			return _data;
		}

		public function set toogleTip(value:Function):void
		{
			_toogleTip = value;
		}

		private var _toogleTip:Function;
		
		public function set container(value:FSprite):void
		{
			_container = value;
			
			if (_container != null)
			{
				_container.addEventListener(FResizeEvent.SIZE_CHANGE, onContainerResize, false, 0, true);
				
				this.x = (_data == null ? 0 : _data.pos * _container.width) + _container.x;
				this.y = 0;
				this.height = _container.height;
				
				_container.addChild(this);
			}
		}
		
		private function onContainerResize(e:FResizeEvent):void
		{
			this.x = (_data == null ? 0 : _data.pos * _container.width) + _container.x;
			this.y = 0;
			this.height = _container.height;
		}
		
		public function set data(value:CueData):void
		{
			_data = value;
		}
		
		private function addEventListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_OUT, hideTip, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, showTip, false, 0, true);
		}
		
		private function hideTip(e:MouseEvent):void
		{
			backgroudColor = 0xffb81d;
			
			if(_toogleTip != null)
			{
				_toogleTip(null);
			}
		}
		
		private function showTip(e:MouseEvent):void
		{
			backgroudColor = 0xffaf00;
			
			if(_toogleTip != null)
			{
				_toogleTip(this);
			}
		}
	}
}
