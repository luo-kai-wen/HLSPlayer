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
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(width="720", height="408", frameRate="60")]
	public class FPlayer extends Sprite
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

		public function FPlayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onPlayerdAddedToStageHandler, false, 0, true);
		}
		
		private function onPlayerdAddedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onPlayerdAddedToStageHandler);

			//设置舞台缩放模式
			stage.align 	= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//初始化右键菜单
			createMenu(this);
			
			//获取相关参数
			getParameters(this.stage);
			
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
				showErrorMessage("播放器皮肤加载失败.");
			}
		}
		
		private function initPlayer(skin:MovieClip):void
		{
			hlsPlayer = new HLSPlayer();
			
			var viewController:ViewController 	= new ViewController(hlsPlayer, skin);
			
			viewController.srtController  		 = new SRTController(srtURL);
			viewController.vttController  		 = new VTTControler(thumbURL);
			viewController.coverPath 	  		 = coverURL;
			viewController.pauseADImagePath 	 = pauseADImageURL;
			viewController.pauseADClickURL  	 = pauseADClickURL
			viewController.stage 				 = this.stage;
			viewController.onCoverButtonCallback = initADPlayer;
			
			HLSSettings.logDebug = false;
			HLSSettings.logInfo  = false;
			HLSSettings.seekMode = HLSSeekMode.KEYFRAME_SEEK;
			
			this.addChild(skin);
		}
		
		private function initADPlayer():void
		{
			adPlayer			= new ADPlayer();
			adPlayer.volume 	= 0.3;
			adPlayer.onEnd 		= onADEnd;
			adPlayer.onError 	= onADEnd;
			adPlayer.jumpURL 	= prerollClickURL;
			adPlayer.play(prerollURL, 3);
			
			this.addChild(adPlayer);
		}
		
		private function onADEnd():void
		{
			adPlayer.onEnd	 = null;
			adPlayer.onError = null
			
			if (adPlayer.parent != null)
			{
				adPlayer.parent.removeChild(adPlayer);
			}
			
			adPlayer = null;
			
			hlsPlayer.autoPlay 	= autoPlay;
			hlsPlayer.preload 	= true;
			hlsPlayer.url 		= hlsURL;
		}
		
		//-------------------------------------------------------工具方法------------------------------------------------//
		private function createMenu(target:InteractiveObject):void
		{
			var verItem:ContextMenuItem = new ContextMenuItem("www.fenhongxiang.com", false, false);

			var customeMenu:ContextMenu = new ContextMenu();
				customeMenu.hideBuiltInItems();
				customeMenu.customItems.push(verItem);
				
			target.contextMenu = customeMenu;
		}
		
		private function getParameters(target:Stage):void
		{
			//获取参数
			coverURL 		= ObjectUtil.getSWFParameter("coverURL", target);
			hlsURL 			= ObjectUtil.getSWFParameter("hlsURL", target);
			prerollURL  	= ObjectUtil.getSWFParameter('prerollURL', target);
			prerollClickURL = ObjectUtil.getSWFParameter('prerollClickURL', target);//跳转地址需要对地址合法性进行验证，防止跨域攻击
			srtURL 			= ObjectUtil.getSWFParameter('srtURL', target);
			thumbURL 		= ObjectUtil.getSWFParameter('thumbURL', target);
			skinURL 		= ObjectUtil.getSWFParameter('skinURL', target);
			pauseADImageURL = ObjectUtil.getSWFParameter('pauseADImageURL', target);
			pauseADClickURL = ObjectUtil.getSWFParameter('pauseADClickURL', target);//跳转地址需要对地址合法性进行验证，防止跨域攻击
			autoPlay 		= ObjectUtil.parseBoolean(ObjectUtil.getSWFParameter('autoPlay', target));
		}
		
		private function showErrorMessage(msg:String):void
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
				txt.htmlText		= "<p align='center'>"+msg+"</p>";
			
			this.addChild(txt);
		}
	}
}