/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package com.fenhongxiang
{
	import com.fenhongxiang.util.HtmlUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * 广告播放器
	 * 
	 * @author luojianghong
	 * 
	 */	
	public final class ADPlayer extends Sprite
	{
		/**
		 * 广告视频URL地址 
		 */		
		private var _src:String;
		
		/**
		 * 广告持续时间
		 */		
		private var _adDuration:int;
		private var _onADComplete:Function;
		private var _adStream:NetStream;//F4V、MP4、M4A、MOV、MP4V、3GP 和 3G2
		private var _adConnection:NetConnection;
		private var _vidLength:Number;
		private var _adTimer:Timer;
		private var _viewDirty:Boolean = false;
		private var _width:Number;
		private var _height:Number;
		private var _volume:Number = 0.6;
		private var _backgroundColor:uint = 0x000000;
		private var _video:Video;
		private var _adLb:TextField;
		private var _jumpURL:String = "";

		
		/**
		 *广告播放完成时的回调函数 
		 */		
		public var onEnd:Function;
		
		/**
		 *广告播放时的回调函数 
		 */		
		public var onPlaying:Function;
		
		/**
		 *广告播放失败回调函数 
		 */		
		public var onError:Function;
		
		
		/**
		 * 
		 * @param url 广告视频地址
		 * @param duration 持续时间（秒为单位）
		 * 
		 */		
		public function ADPlayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler, false, 0, true);
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			this.addEventListener(Event.RENDER, onRenderHandler, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, onADPLayerClickHandler, false, 0, true);
			
			this.useHandCursor = true;
			this.buttonMode = true;
			
			//add label
			_adLb = new TextField();
			_adLb.width = 103;
			_adLb.x = this.width - _adLb.width - 30;
			_adLb.y = 10;
			_adLb.mouseEnabled = false;
			
			this.addChild(_adLb);
		}
		
		private function onADPLayerClickHandler(e:MouseEvent):void
		{
			if (_jumpURL)
			{
				HtmlUtil.gotoURL(_jumpURL);
			}
		}
		
		private function onRenderHandler(e:Event):void
		{
			if (_viewDirty)
			{
				this.graphics.clear();
				this.graphics.beginFill(0, 1);
				this.graphics.drawRect(0, 0, _width, _height);
				this.graphics.endFill();
				
				if (_video)
				{
					_video.width = _width;
					_video.height = _height;	
				}
				
				if (_adLb)
				{
					_adLb.x = _width - _adLb.width - 30;
					_adLb.y = 10;
				}
				
				_viewDirty = false;
			}
		}
		
		//-----------------------------------------------------setters and getters-----------------------------------------------------------------//
		override public  function set width(value:Number):void
		{
			_width = value;
			_viewDirty = true;
			invalidateDisplaylist();
		}
		
		override public  function get width():Number
		{
			return _width;
		}
		
		override public  function set height(value:Number):void
		{
			_height = value;
			_viewDirty = true;
			invalidateDisplaylist();
		}
		
		override public  function get height():Number
		{
			return _height;
		}
		
		public function resize(w:Number, h:Number):void
		{
			if (_width != w)
			{
				_width = w;
				_viewDirty = true;
			}
			
			if (_height != h)
			{
				_height = h;
				_viewDirty = true;
			}
			
			invalidateDisplaylist();
		}
		
		public function set backgroundColor(color:uint):void
		{
			_backgroundColor = color;
		}
		
		public function set volume(vol:Number):void
		{
			if (vol > 1)
			{
				vol = 1.0;
			}
			else if (vol < 0)
			{
				vol = 0.0;
			}
			
			_volume = vol ;
			
			if (_adStream != null)
			{
				_adStream.soundTransform = new SoundTransform(vol);
			}
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		
		protected function invalidateDisplaylist():void
		{
			if (this.stage)
			{
				this.stage.invalidate();
			}
		}
		
		public function play(url:String=null, duration:int=0):void
		{
			_src = url;
			_adDuration = duration;
			
			if (_adConnection == null)
			{
				_adConnection = new NetConnection();
				_adConnection.addEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler, false, 0, true);
			}
			
			_adConnection.connect(null);
		}
		
		protected function dispose():void
		{
			if (_adTimer != null)
			{
				_adTimer.stop();
				_adTimer.removeEventListener(TimerEvent.TIMER, onAdPlayTimerHandler);
				_adTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onAdPlayTimerComplete);
				_adTimer = null;
			}
			
			if (_adStream != null)
			{
				_adStream.dispose();
				_adStream.removeEventListener(NetStatusEvent.NET_STATUS, streamStatusHandler);
			}
			
			if (_adConnection != null)
			{
				_adConnection.removeEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
			}
		}

		
		private function connectionStatusHandler(e:NetStatusEvent):void
		{
			if (e.info.code == "NetConnection.Connect.Success")
			{
				if (_adStream == null)
				{
					_adStream = new NetStream(_adConnection);
					_adStream.client = this;
					_adStream.useHardwareDecoder = true;
					_adStream.receiveAudio(true);
					_adStream.receiveVideo(true);
					_adStream.soundTransform = new SoundTransform(_volume);
					_adStream.addEventListener(NetStatusEvent.NET_STATUS, streamStatusHandler, false, 0, true);
				}
				
				if (_video == null)
				{
					_video = new Video(_width, _height);
					_video.x = 0;
					_video.y = 0;
					_video.smoothing = true;
					_video.attachNetStream(_adStream);
				}
				
				try
				{
					_adStream.play(_src);
					this.addChildAt(_video, 0);
				}
				catch(e:SecurityError)
				{
					//trace("Play SecurityError");
				}
			}
		}
		
		private function  streamStatusHandler(e:NetStatusEvent):void
		{
			if (e.info.level == "status")
			{
				switch(e.info.code)
				{
					case "NetStream.Play.Start"://播放已开始
					{
						startAdTimer();
						break;
					}
					case "NetStream.Play.Stop"://播放已结束
					{
						fadeOut();
						break;
					}
						
					default:
					{
						break;
					}
				}
			}
			else//由于某种原因，无法播放广告
			{
				if (onError != null)
				{
					onError();
				}
			}
		}
		
		//---------------------------------------------timer handlers--------------------------------------------------------------------//
		private function startAdTimer():void
		{
			//广告时间不合法不启动定时器
			if (_adDuration < 0)
			{
				this.dispose();
				
				if (onEnd != null)
				{
					onEnd();
				}
			}
			else
			{
				if (_adTimer == null)
				{
					_adTimer = new Timer(1000, 1);
					_adTimer.addEventListener(TimerEvent.TIMER, onAdPlayTimerHandler, false, 0, true);
					_adTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAdPlayTimerComplete, false, 0, true);
				}
				
				_adTimer.repeatCount = _adDuration;
				_adTimer.start();
			}
		}
		
		private function onAdPlayTimerHandler(e:TimerEvent):void
		{
			var leftCount:int = 0;
			
			if (_adDuration <= 0)
			{
				leftCount = _vidLength - _adTimer.currentCount
			}
			else
			{
				leftCount = _adTimer.repeatCount - _adTimer.currentCount;
			}
			
			if (_adLb)
			{
				_adLb.htmlText = "<font size='14'>广告剩余<font color='#FF0000' size='18'>" + leftCount +"</font>秒</font>";
			}
			
			if (onPlaying != null)
			{
				onPlaying(leftCount);
			}
		}
		
		private function onAdPlayTimerComplete(e:TimerEvent):void
		{
			fadeOut();
		}
		
		private function fadeOut():void
		{
			this.addEventListener(Event.ENTER_FRAME, fadeOutHandler, false, 0, true);
		}
		
		private function fadeOutHandler(e:Event):void
		{
			if (this.alpha > 0)
			{
				this.alpha -= 0.1;
				this.volume -= _volume/10;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, fadeOutHandler);
				this.dispose();
				
				if (onEnd != null)
				{
					onEnd();
				}
			}
		}
		
		//------------------------------------------------netstream events---------------------------------------------//
		public function onPlayStatus(info:Object):void
		{
			
		}
		
		public function onMetaData(data:Object):void
		{
			if (data != null)
			{
				_vidLength = data['duration'];
			}
		}

		public function set jumpURL(value:String):void
		{
			_jumpURL = value;
		}

	}
}