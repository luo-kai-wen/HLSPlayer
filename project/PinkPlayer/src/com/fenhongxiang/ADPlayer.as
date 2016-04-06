//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------
package com.fenhongxiang
{
	import com.fenhongxiang.util.HtmlUtil;
	import com.fenhongxiang.view.FSprite;
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
	 */
	public final class ADPlayer extends FSprite
	{
		
		public function ADPlayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler, false, 0, true);
		}

		public var onEnd:Function; //广告播放完成时的回调函数 
		public var onError:Function; //广告播放失败回调函数 
		public var onPlaying:Function; //广告播放时的回调函数 
		
		private var _adConnection:NetConnection;
		private var _adDuration:int; //广告持续时间
		private var _adLb:TextField;
		private var _adStream:NetStream; //F4V、MP4、M4A、MOV、MP4V、3GP 和 3G2
		private var _adTimer:Timer;
		private var _jumpURL:String = "";
		private var _src:String; //广告视频URL地址 
		private var _vidLength:Number;
		private var _video:Video;
		private var _volume:Number = 0.6;
		
		public function set jumpURL(value:String):void
		{
			_jumpURL = value;
		}
		
		public function onMetaData(data:Object):void
		{
			if (data != null)
			{
				_vidLength = data['duration'];
			}
		}
		
		//------------------------------------------------netstream events---------------------------------------------//
		public function onPlayStatus(info:Object):void
		{
		
		}
		
		override public function onRenderHandler(e:Event):void
		{
			super.onRenderHandler(e);
			
			if (_video)
			{
				_video.width = width;
				_video.height = height;
			}
			
			if (_adLb)
			{
				_adLb.x = width - _adLb.width - 30;
				_adLb.y = 10;
			}
		}
		
		public function play(url:String = null, duration:int = 0):void
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
		
		
		public function get volume():Number
		{
			return _volume;
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
			
			_volume = vol;
			
			if (_adStream != null)
			{
				_adStream.soundTransform = new SoundTransform(vol);
			}
		}
		
		//-----------------------------------------------------setters and getters-----------------------------------------------------------------//
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
					
					//对于 RTMFP 多播流或当使用 NetStream.appendBytes() 方法时，此方法不起作用。
					_adStream.receiveAudio(true);
					_adStream.receiveVideo(true);
					
					_adStream.soundTransform = new SoundTransform(_volume);
					_adStream.addEventListener(NetStatusEvent.NET_STATUS, streamStatusHandler, false, 0, true);
				}
				
				if (_video == null)
				{
					_video = new Video(width, height);
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
				catch (e:SecurityError)
				{
					//trace("Play SecurityError");
				}
			}
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
				this.volume -= _volume / 10;
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
		
		/**
		 * 链接跳转
		 */
		private function onADPLayerClickHandler(e:MouseEvent):void
		{
			if (_jumpURL)
			{
				HtmlUtil.gotoURL(_jumpURL);
			}
		}
		
		//-----------------------------------Timer事件处理函数 -------------------------------------//
		private function onAdPlayTimerComplete(e:TimerEvent):void
		{
			fadeOut();
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
				_adLb.htmlText = "<font size='14' color='#FFFFFF'>广告剩余 <font color='#FF0000' size='16'>" + leftCount + "</font> 秒</font>";
			}
			
			if (onPlaying != null)
			{
				onPlaying(leftCount);
			}
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			
			this.addEventListener(MouseEvent.CLICK, onADPLayerClickHandler, false, 0, true);
			
			this.stage.addEventListener(Event.RESIZE, onSWFResizeHandler, false, 0, true);
			
			this.resize(this.stage.stageWidth, this.stage.stageHeight);
			
			this.useHandCursor = true;
			this.buttonMode = true;
			
			//显示广告时间的文本框
			_adLb = new TextField();
			_adLb.width = 110;
			_adLb.x = this.width - _adLb.width - 30;
			_adLb.y = 10;
			_adLb.mouseEnabled = false;
			
			this.addChild(_adLb);
		}
		
		private function onSWFResizeHandler(e:Event):void
		{
			if (this.stage)
			{
				resize(this.stage.stageWidth, this.stage.stageHeight);
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
		
		private function streamStatusHandler(e:NetStatusEvent):void
		{
			if (e.info.level == "status")
			{
				switch (e.info.code)
				{
					case "NetStream.Play.Start": //播放已开始
					{
						startAdTimer();
						break;
					}
					case "NetStream.Play.Stop": //播放已结束
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
			else //由于某种原因，无法播放广告
			{
				if (onError != null)
				{
					onError();
				}
			}
		}
	}
}
