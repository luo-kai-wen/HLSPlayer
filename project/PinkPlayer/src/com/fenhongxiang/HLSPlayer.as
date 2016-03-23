//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package com.fenhongxiang
{
	import com.fenhongxiang.hls.HLS;
	import com.fenhongxiang.hls.HLSSettings;
	import com.fenhongxiang.hls.constant.HLSPlayStates;
	import com.fenhongxiang.hls.event.HLSEvent;
	import com.fenhongxiang.hls.stream.HLSNetStream;
	import com.fenhongxiang.util.ObjectUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;

	public class HLSPlayer extends Sprite
	{

		public function HLSPlayer()
		{
			HLSSettings.maxBufferLength = 30;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler, false, 0, true);
		}

		private var _autoPlay:Boolean = false;
		private var _backgroundColor:uint = 0x000000;
		private var _duration:Number = 0;
		private var _fileLoaded:Boolean = false;
		private var _forcePlay:Boolean = false;
		private var _height:Number = 300;
		private var _hls:HLS;
		private var _isBuffering:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _loadedPercent:Number = 0.0;
		private var _onPlayEnd:Function = null;
		private var _onPlayError:Function = null;
		private var _onPlayStart:Function = null;
		private var _onPlayStateChange:Function = null;
		private var _preload:Boolean = false;
		private var _stoped:Boolean = false;
		private var _time:Number = 0;
		private var _url:String;
		private var _video:Video;
		private var _viewDirty:Boolean = true;
		private var _vol:Number = 0.6;
		private var _width:Number = 300;
		private var _videoRatio:Number = 1.78;//默认宽高比 16：9

		public function set autoPlay(auto:Boolean):void
		{
			_autoPlay = auto;
		}

		public function set backgroundColor(color:uint):void
		{
			if (_backgroundColor != color)
			{
				_backgroundColor = color;
				invalidateDisplaylist();
			}
		}

		public function get duration():Number
		{
			return _duration;
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
				invalidateDisplaylist();
			}
		}

		public function get isBuffering():Boolean
		{
			return _isBuffering;
		}

		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		public function get loadedPercent():Number
		{
			return _loadedPercent > 1 ? 1 : _loadedPercent;
		}

		//---------------------------------------------callback methods-----------------------------------------------------------//
		public function set onPlayEnd(func:Function):void
		{
			_onPlayEnd = func;
		}

		public function set onPlayError(func:Function):void
		{
			_onPlayError = func;
		}

		public function set onPlayStart(func:Function):void
		{
			_onPlayStart = func;
		}

		public function set onPlayStateChange(value:Function):void
		{
			_onPlayStateChange = value;
		}

		//----------------------------------------------interface methods---------------------------------------------------------//
		public function pause():Number
		{
			if (ObjectUtil.available(_hls, ['stream']))
			{
				_hls.stream.pause();

				return _hls.stream.time;
			}

			return 0.0;
		}

		public function play(pos:Number = -1):void
		{
			if (_fileLoaded)
			{
				if (_onPlayStart)
				{
					_onPlayStart();
				}
				_isPlaying = true;
				_stoped = false;

				_hls.stream.play(null, pos);
			}
			else if (url)
			{
				_forcePlay = true;
				load(url);
			}
		}

		public function get playedPercent():Number
		{
			var per:Number = _hls.position / _duration;

			if (isNaN(per))
			{
				per = 0.0;
			}

			return per > 1 ? 1 : per;
		}

		public function set preload(value:Boolean):void
		{
			_preload = value;
		}

		public function resize(w:Number, h:Number):void
		{
			var needUpdate:Boolean = false;

			if (_width != w || _height != h)
			{
				needUpdate = true;
			}
			
			_width = w;
			_height = h;

			if (needUpdate)
			{
				invalidateDisplaylist();
			}
		}

		public function seek(pos:Number, autoPlay:Boolean = false):void
		{
			if (ObjectUtil.available(_hls, ['stream']))
			{
				_hls.stream.seek(pos * _duration);
				_hls.stream.pause();
				
				_isPlaying = false;
				_stoped = false;
				
				if (autoPlay)
				{
					_isPlaying = true;
					_hls.stream.resume();
				}
			}
		}

		public function step(size:Number):void
		{
			var newPos:Number = _hls.position + size;

			if (newPos < 0)
			{
				newPos = 0;
			}
			else if (newPos >= duration)
			{
				newPos = duration - 1.0;
			}

			seek(newPos / duration, true);
		}

		public function get stoped():Boolean
		{
			return _stoped;
		}

		/**
		 * return the current playhead position
		 * */
		public function get time():Number
		{
			return _hls.position < 0 ? 0 : _hls.position;
		}

		public function togglePause():void
		{
			if (ObjectUtil.available(_hls, ['stream']))
			{
				_isPlaying = !_isPlaying;

				//这里有一个缓存问题，flashplayer的视图有可能不会更新
				HLSNetStream(_hls.stream).togglePause();
			}
		}

		//-------------------------------------getters and setters-------------------------------------------------------------//
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			if (_url != value)
			{
				_url = value;
				_fileLoaded = false;

				if (_preload && _url)
				{
					load(_url);
				}
			}
		}

		public function get volume():Number
		{
			return _vol;
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

			if (_vol != vol)
			{
				_vol = vol;

				if (ObjectUtil.available(_hls, ['stream']))
				{
					SoundMixer.soundTransform = new SoundTransform(_vol);
				}
			}
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
				invalidateDisplaylist();
			}
		}

		//---------------------------------------------help method---------------------------------------------------------------//
		protected function invalidateDisplaylist():void
		{
			_viewDirty = true;

			if (this.stage)
			{
				this.stage.invalidate();
			}
		}

		//-----------------------------------------------------------------------------------------------------------------------//

		private function load(url:String):void
		{
			if (_hls == null)
			{
				_hls = new HLS();
				_hls.addEventListener(HLSEvent.ERROR, onHLSErrorHandler, false, 0, true);
				_hls.addEventListener(HLSEvent.MANIFEST_LOADED, onPlayListLoadedHandler, false, 0, true);
			}

			_hls.load(url);
		}

		private function onAddToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			this.addEventListener(Event.RENDER, onRenderHandler, false, 0, true);

			_hls = new HLS();
			_hls.stage = this.stage;
			_hls.addEventListener(HLSEvent.ERROR, onHLSErrorHandler, false, 0, true);
			_hls.addEventListener(HLSEvent.MANIFEST_LOADED, onPlayListLoadedHandler, false, 0, true);
			_hls.addEventListener(HLSEvent.LEVEL_SWITCH, onPlayLevelSwitchHandler, false, 0, true);


			_video = new Video(_width, _height);
			_video.smoothing = true;
			_video.attachNetStream(_hls.stream);
			this.addChild(_video);

			if (_preload && _url)
			{
				load(_url);
			}

			invalidateDisplaylist();
		}
		
		private function onPlayLevelSwitchHandler(e:HLSEvent):void
		{
			_videoRatio = _hls.levels[_hls.currentLevel].width/_hls.levels[_hls.currentLevel].height;
		}

		private function onHLSErrorHandler(e:HLSEvent):void
		{
			if (_onPlayError != null)
			{
				_onPlayError(e.error.msg);
			}
		}

		private function onMediaTimeChangeHandler(e:HLSEvent):void
		{
			//data: { mediatime : HLSMediatime}
			_time = Number(e.mediatime.position.toFixed(4));
			_loadedPercent = Number(((e.mediatime.position + e.mediatime.buffer) / e.mediatime.duration).toFixed(4));
		}

		private function onPlayBackStop(e:HLSEvent):void
		{
			//_hls.removeEventListener(HLSEvent.PLAYBACK_COMPLETE, onPlayBackStop);
			//stop();
			_isPlaying = false;
			_stoped = true;

			if (_onPlayEnd != null)
			{
				_onPlayEnd.call();
			}
		}

		/**
		 * 视频m3u8列表文件加载完成
		 * */
		private function onPlayListLoadedHandler(event:HLSEvent):void
		{
			_hls.removeEventListener(HLSEvent.MANIFEST_LOADED, onPlayListLoadedHandler);
			_fileLoaded = true;

			//计算总时间
			_duration = event.levels[_hls.startLevel].duration;
			_videoRatio = _hls.levels[_hls.startLevel].width/_hls.levels[_hls.startLevel].height;

			if (_autoPlay || _forcePlay)
			{
				_forcePlay = false;
				play();
			}
			else
			{
				stop();
			}
			
			_hls.addEventListener(HLSEvent.PLAYBACK_COMPLETE, onPlayBackStop, false, 0, true);
			_hls.addEventListener(HLSEvent.MEDIA_TIME, onMediaTimeChangeHandler, false, 0, true); //triggered when media position gets updated
			_hls.addEventListener(HLSEvent.PLAYBACK_STATE, onStreamPlayBackStateChange, false, 0, true);
		}

		//--------------------------------------------event handlers------------------------------------------------------------//

		private function onRenderHandler(e:Event):void
		{
			if (_viewDirty)
			{
				this.graphics.clear();
				this.graphics.beginFill(_backgroundColor, 1);
				this.graphics.drawRect(0, 0, _width, _height);
				this.graphics.endFill();
				
				var currentRatio:Number = _width / _height;
				
				if (currentRatio == _videoRatio)
				{
					_video.height = _height;
					_video.width = _width;
					_video.x = 0;
					_video.y = 0;
				}
				else if (currentRatio > _videoRatio)
				{
					_video.height = _height;
					
					_video.width = _height * _videoRatio;
					
					_video.x = (_width - _video.width)/2;
					_video.y = 0;
				}
				else
				{
					_video.width = _width;
					_video.height = _width / _videoRatio;
					_video.x = 0;
					_video.y = (_height - _video.height)/2;
				}

				_viewDirty = false;
			}
		}

		//IDLE/PLAYING/PAUSED/PLAYING_BUFFERING/PAUSED_BUFFERING
		private function onStreamPlayBackStateChange(e:HLSEvent):void
		{
			switch (e.state)
			{
				case HLSPlayStates.PAUSED_BUFFERING:
				case HLSPlayStates.PLAYING_BUFFERING:
				{
					_isBuffering = true;
					break;
				}

				case HLSPlayStates.PAUSED:
				case HLSPlayStates.PLAYING:
				{
					_isBuffering = false;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function stop():void
		{
			if (ObjectUtil.available(_hls, ['stream']))
			{
				_isPlaying = false;
				//这里有一个缓存问题，flashplayer的视图有可能不会更新
				HLSNetStream(_hls.stream).stop();
			}
		}
	}
}
