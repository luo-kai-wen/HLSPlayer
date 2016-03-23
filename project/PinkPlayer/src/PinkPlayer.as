//------------------------------------------------------------------------------
//
//   Copyright 2016 www.fenhongxiang.com 
//   All rights reserved. 
//   By :ljh 
//
//------------------------------------------------------------------------------

package
{
	import com.fenhongxiang.ADPlayer;
	import com.fenhongxiang.HLSPlayer;
	import com.fenhongxiang.hls.HLSSettings;
	import com.fenhongxiang.hls.constant.HLSSeekMode;
	import com.fenhongxiang.srt.SRTController;
	import com.fenhongxiang.util.ObjectUtil;
	import com.fenhongxiang.util.SkinLoader;
	import com.fenhongxiang.view.ViewController;
	import com.fenhongxiang.vtt.VTTControler;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(width="720", height="408", frameRate="60")]
	public class PinkPlayer extends Sprite
	{
		private var adPlayer:ADPlayer;
		private var autoPlay:Boolean=false;
		private var coverURL:String;
		private var hlsPlayer:HLSPlayer;
		private var hlsURL:String;
		private var pauseADClickURL:String;
		private var pauseADImageURL:String;
		private var prerollClickURL:String;
		private var prerollURL:String;
		private var skinURL:String;
		private var srtURL:String;
		private var thumbURL:String;

		public function PinkPlayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onPlayerdAddedToStageHandler, false, 0, true);
		}
		
		private function onPlayerdAddedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onPlayerdAddedToStageHandler);

			stage.align 	= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//-----------------------------------右键菜单 --------------------------------//
			var customeMenu:ContextMenu = new ContextMenu();
			customeMenu.hideBuiltInItems();
			
			var verItem:ContextMenuItem = new ContextMenuItem("www.fenhongxiang.com", false, false);
			customeMenu.customItems.push(verItem);
			this.contextMenu = customeMenu;
			
			//获取参数
			coverURL 		= ObjectUtil.getSWFParameter("coverURL", this.stage);
			hlsURL 			= ObjectUtil.getSWFParameter("hlsURL", this.stage);
			prerollURL  	= ObjectUtil.getSWFParameter('prerollURL', this.stage);
			prerollClickURL = ObjectUtil.getSWFParameter('prerollClickURL', this.stage);
			srtURL 			= ObjectUtil.getSWFParameter('srtURL', this.stage);
			thumbURL 		= ObjectUtil.getSWFParameter('thumbURL', this.stage);
			skinURL 		= ObjectUtil.getSWFParameter('skinURL', this.stage);
			pauseADImageURL = ObjectUtil.getSWFParameter('pauseADImageURL', this.stage);
			pauseADClickURL = ObjectUtil.getSWFParameter('pauseADClickURL', this.stage);
			autoPlay 		= ObjectUtil.parseBoolean(ObjectUtil.getSWFParameter('autoPlay', this.stage));
			
			//加载皮肤
			SkinLoader.getInstance().load(skinURL, skinLoadedHandler);
		}
		
		private function skinLoadedHandler(skinClip:*):void
		{
			if (skinClip != null)
			{
				initPlayer(skinClip);
			}
			else
			{
				this.graphics.clear();
				this.graphics.beginFill(0x1F272A, 1.0);
				this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
				this.graphics.endFill();
				
				var txt:TextField 		= new TextField();
					txt.width 			= 300;
					txt.height 			= 30;
					txt.mouseEnabled 	= false;
					txt.selectable 		= false;
					txt.x				= (this.stage.stageWidth - 300) / 2;
					txt.y				= (this.stage.stageHeight - 30) / 2;
					txt.textColor 		= 0xFFFFFF;
					txt.htmlText		= "<p align='center'>播放器皮肤加载失败.</p>";
				
				this.addChild(txt);
			}
		}
		
		private function initPlayer(skin:MovieClip):void
		{
			hlsPlayer = new HLSPlayer();
			var viewController:ViewController = new ViewController(hlsPlayer, skin);
			viewController.srtController = new SRTController(srtURL);
			viewController.vttController = new VTTControler(thumbURL);
			viewController.coverPath = coverURL;
			viewController.pauseADImagePath = pauseADImageURL;
			viewController.pauseADClickURL = pauseADClickURL
			viewController.stage = this.stage;
			viewController.onCoverButtonCallback = initADPlayer;
			
			HLSSettings.logDebug = false;
			HLSSettings.logInfo = false;
			HLSSettings.seekMode = HLSSeekMode.KEYFRAME_SEEK;
			
			this.addChild(skin);
		}

		private function initADPlayer():void
		{
			adPlayer			=	new ADPlayer();
			adPlayer.volume 	= 0.3;
			adPlayer.onEnd 		= onADEnd;
			adPlayer.onError 	= onADEnd;
			adPlayer.jumpURL 	= prerollClickURL;
			adPlayer.resize(this.stage.stageWidth, this.stage.stageHeight);
			adPlayer.play(prerollURL, 0);

			this.addChild(adPlayer);
		}

		private function onADEnd():void
		{
			adPlayer.onEnd	 = null;
			adPlayer.onError = null

			if (this.contains(adPlayer))
			{
				this.removeChild(adPlayer);
			}
			
			adPlayer = null;

			hlsPlayer.autoPlay 	= autoPlay;
			hlsPlayer.preload 	= true;
			hlsPlayer.url 		= hlsURL;
		}

	}
}