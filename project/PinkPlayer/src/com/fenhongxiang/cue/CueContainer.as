//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang.cue
{
	import com.fenhongxiang.view.FSprite;
	import flash.text.TextField;
	public class CueContainer extends FSprite
	{
		public function CueContainer()
		{
			super();
			
			init();
		}
		
		private var _cueData:Vector.<CueData>;
		
		private var _infoText:TextField;
		
		public function set data(value:Vector.<CueData>):void
		{
			_cueData = sortPointsByTime(value);
			
			arrangePoints();
		}
		
		public function get tipVisible():Boolean
		{
			return _infoText != null && _infoText.visible;
		}
		
		private function arrangePoints():void
		{
			removeAllCuePoints();
			
			if (_cueData != null)
			{
				for (var i:int = 0; i < _cueData.length; i++)
				{
					var cuePoint:CuePoint = new CuePoint();
					
					cuePoint.data = _cueData[i];
					cuePoint.container = this;
					cuePoint.toogleTip = showCuePointTips;
				}
			}
		}
		
		private function init():void
		{
			border = false;
			backgroundAlpha = 0;
			mouseEnabled = false;
			
			_infoText = new TextField();
			_infoText.background = true;
			_infoText.backgroundColor = 0;
			_infoText.y = -30;
			_infoText.wordWrap = true;
			_infoText.textColor = 0xFFFFFF;
			_infoText.visible = false;
			
			this.addChild(_infoText);
		}
		
		private function removeAllCuePoints():void
		{
			for (var i:int = this.numChildren - 1; i >= 0; i--)
			{
				if (this.getChildAt(i) is CuePoint)
				{
					this.removeChildAt(i);
				}
			}
		}
		
		private function showCuePointTips(cue:CuePoint):void
		{
			if (cue != null && cue.data != null)
			{
				var text:String = cue.data.text;
				
				if (text.length > 130)
				{
					_infoText.htmlText = "<font size='12'><p align='center'>" + text.substr(0, 27) + "...</p></font>";
				}
				else
				{
					_infoText.htmlText = "<font size='12'><p align='center'>" + text + "</p></font>";
				}
				
				_infoText.x = cue.x - _infoText.width / 2;
				_infoText.height = _infoText.numLines * 20;
				
				_infoText.y = -_infoText.height;
				_infoText.visible = true;
			}
			else
			{
				_infoText.text = '';
				_infoText.visible = false;
			}
		}
		
		private function sortPointsByTime(points:Vector.<CueData>):Vector.<CueData>
		{
			if (points != null)
			{
				var result:Vector.<CueData> = points.sort(function compare(x:CueData, y:CueData):Number
				{
					return x.pos - y.pos;
				});
				
				return result;
			}
			else
			{
				return null;
			}
		}
	}
}
