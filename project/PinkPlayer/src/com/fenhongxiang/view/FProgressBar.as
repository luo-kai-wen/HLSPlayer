package com.fenhongxiang.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FProgressBar extends FSprite
	{
		public function FProgressBar()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, onProgressBarClickHandler, false, 0, true);
		}
		
		private var _viewDirty:Boolean = false;
		private var _loadedPer:Number = 0.0;
		private var _playedPer:Number = 0.0;
		private var _seekPer:Number = 0.0;
		
		public function updateView(loadedPer:Number, playedPer:Number):void
		{
			_viewDirty = true;
			_loadedPer = loadedPer;
			_playedPer = playedPer;
			
			invalidateDisplaylist();
		}
		
		private function onProgressBarClickHandler(e:MouseEvent):void
		{
			_seekPer = e.localX / this.width;
			
			updateView(_loadedPer, _seekPer);
		}
		
		override public function onRenderHandler(e:Event):void
		{
			if (_viewDirty)
			{
				this.graphics.clear();
				
				var radius:Number = 0;

				
				//background
				this.graphics.beginFill(0xFFFFFF, this.backgroundAlpha);
				this.graphics.drawRoundRect(0, 0, this.width, this.height, radius, radius);
				this.graphics.endFill();
				
				
				//loaded
				this.graphics.beginFill(0xd0e4f5, 1.0);
				
				if (_loadedPer <= (1 - radius/this.width))
				{
					this.graphics.drawRoundRectComplex(0, 0, this.width*_loadedPer, this.height, radius, 0.0, radius, 0.0);
				}
				else
				{
					this.graphics.drawRoundRectComplex(0, 0, this.width*_loadedPer, this.height, radius, radius, radius, radius);
				}
				this.graphics.endFill();
				
				//played
				this.graphics.beginFill(0x64b5f6, 1.0);
				
				if (_playedPer <= (1 - 10/this.width))
				{
					this.graphics.drawRoundRectComplex(0, 0, this.width*_playedPer, this.height, radius, 0.0, radius, 0.0);
				}
				else
				{
					this.graphics.drawRoundRectComplex(0, 0, this.width*_playedPer, this.height, radius, radius, radius, radius);
				}
				
				this.graphics.endFill();
				
				_viewDirty = false;
			}
		}
	}
}