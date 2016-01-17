package
{
	import com.fenhongxiang.ADPlayer;
	import com.fenhongxiang.HLSPlayer;
	import com.fenhongxiang.hls.HLSSettings;
	import com.fenhongxiang.hls.constant.HLSSeekMode;
	import com.fenhongxiang.srt.SRTController;
	import com.fenhongxiang.util.SkinLoader;
	import com.fenhongxiang.view.ViewController;
	import com.fenhongxiang.vtt.VTTControler;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;

	[SWF(width="720", height="408", frameRate="60")]
//	[SWF(width="360", height="204", frameRate="60")]
//	[SWF(width="800", height="600")]
	public class PinkPlayer extends Sprite
	{
		private var hlsPlayer:HLSPlayer;
		private var adPlayer:ADPlayer;

		private var coverURL:String;
		private var hlsURL:String;
		private var prerollURL:String;
		private var prerollClickURL:String;
		private var srtURL:String;
		private var thumbURL:String;
		private var skinURL:String;
		private var pauseADImageURL:String;
		private var pauseADClickURL:String;
		private var autoPlay:Boolean=false;

		public function PinkPlayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onPlayerdAddedToStageHandler, false, 0, true);
		}

		private function onPlayerdAddedToStageHandler(e:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onPlayerdAddedToStageHandler);

			coverURL=getSWFParameterValueByName("coverURL");
			hlsURL=getSWFParameterValueByName("hlsURL");
			prerollURL=getSWFParameterValueByName('prerollURL');
			prerollClickURL=getSWFParameterValueByName('prerollClickURL');
			srtURL=getSWFParameterValueByName('srtURL');
			thumbURL=getSWFParameterValueByName('thumbURL');
			skinURL=getSWFParameterValueByName('skinURL');
			pauseADImageURL=getSWFParameterValueByName('pauseADImageURL');
			pauseADClickURL=getSWFParameterValueByName('pauseADClickURL');
			autoPlay=parseBoolean(getSWFParameterValueByName('autoPlay'));

			//加载皮肤
			SkinLoader.getInstance().load(skinURL, skinLoadedHandler);
		}

		private function parseBoolean(value:*):Boolean
		{
			var result:Boolean=false;

			if (value is String)
			{
				result=(value == "true") ? true : false;
			}
			else
			{
				result=Boolean(value);
			}

			return result;
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

				var txt:TextField=new TextField();
				txt.width=300;
				txt.height=30;
				txt.mouseEnabled=false;
				txt.selectable=false;
				txt.x=(this.stage.stageWidth - 300) / 2;
				txt.y=(this.stage.stageHeight - 30) / 2;
				txt.textColor=0xFFFFFF;
				txt.htmlText="<p align='center'>播放器皮肤加载失败.</p><p align='center'> Player Skin Not Found</p>";

				this.addChild(txt);
			}
		}

		private function getSWFParameterValueByName(name:String):String
		{
			var paramValue:*="";

			if (this.stage && name)
			{
				paramValue=this.stage.loaderInfo.parameters[name];
			}

			return paramValue;
		}

		private function initPlayer(skin:MovieClip):void
		{
			hlsPlayer=new HLSPlayer();
			var viewController:ViewController=new ViewController(hlsPlayer, skin);
			viewController.srtController=new SRTController(srtURL);
			viewController.vttController=new VTTControler(thumbURL);
			viewController.coverPath=coverURL;
			viewController.pauseADImagePath=pauseADImageURL;
			viewController.pauseADClickURL=pauseADClickURL
			viewController.stage=this.stage;
			viewController.onCoverButtonCallback=initADPlayer;

			HLSSettings.logDebug=true;
			HLSSettings.logInfo=true;
			HLSSettings.seekMode=HLSSeekMode.KEYFRAME_SEEK;

			this.addChild(skin);
		}

		private function initADPlayer():void
		{
			adPlayer=new ADPlayer();
			adPlayer.resize(this.stage.stageWidth, this.stage.stageHeight);
			adPlayer.volume=0.3;
			adPlayer.onEnd=onADEnd;
			adPlayer.onError=onADEnd;
			adPlayer.jumpURL=prerollClickURL;
			adPlayer.play(prerollURL, 0);

			this.addChild(adPlayer);
		}

		private function onADEnd():void
		{
			adPlayer.onEnd=null;
			adPlayer.onError=null

			if (this.contains(adPlayer))
			{
				this.removeChild(adPlayer);
			}

			hlsPlayer.autoPlay=autoPlay;
			hlsPlayer.preload=true;
			hlsPlayer.url=hlsURL;
		}
	}
}