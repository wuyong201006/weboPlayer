package
{
	import com.alex.flexlite.components.VideoUI;
	import com.hurlant.util.Base64;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import events.PlayerEvent;
	
	import net.DefinedPlayer;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.managers.SystemManager;
	import org.flexlite.domUI.skins.themes.VectorTheme;
	
	import view.AdvertChart;
	import view.ControllBar;
	import view.LoadingBar;
	import view.Recommend;
	import view.TopBar;
	
	[SWF(width="482", height="355", frameRate="25"]
	public class Main extends SystemManager
	{
		private var videoScreen:VideoUI;
		private var topBar:TopBar;
		private var controllBar:ControllBar;
		
		private var definedPlayer:DefinedPlayer;
		private var playerUrl:String = "http://www.tvm.cn/weibo/get_data?url=www.tvm.cn/ishare/play/play.html?id=";
		private var playerParams:Object={
			url:null//(mp4url, druation)
		}
			
		private var IsPlayer:Boolean=true;//是否第一次播放
		public function Main()
		{
			super();
			
			Injector.mapClass(Theme,VectorTheme);
			//收藏页
			//navigateToURL( (new URLRequest("javascript:window.external.addFavorite('http://qq.com', '收藏名字')")), "_self");
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			playerParams.url = this.loaderInfo.parameters.url;
			
			playerParams.url = 566389;
		}
		
		private function addedToStage(event:Event):void
		{
			requestPlayer();
		}
		
		
		private function requestPlayer():void
		{
			var request:URLRequest = new URLRequest(playerUrl);
			
			request.method = URLRequestMethod.GET;
			request.data = playerParams.url;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			loader.load(request);
		}
		
		private function ioError(event:Event):void
		{
			//			trace("请求视频源加载错误！！！");
		}
		
		private function complete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			playerParams.url = parseContent("TVM", loader.data);
			if(definedPlayer == null)
				initPlayer();
		}
		
		//parse url 		
		private function parseContent(keyStr:String, decryptStr:String):Object
		{
			
			//反转，解码
//			var decryptArray:Array = decryptStr.split("");
//			var rev:Array = decryptArray.reverse();
//			var dec:String = rev.join("");
			return JSON.parse(decryptStr);
		}
		
		private function initPlayer():void
		{
			if(playerParams.url)
			{
				//				controllBar.updateProgressBarMaximum(playerParams.content.duration);
				
				definedPlayer = new DefinedPlayer(playerParams.url.stream.url, 0);
				videoScreen.attatchNetStream(definedPlayer.netStream);
			}
			
			definedPlayer.addEventListener(PlayerEvent.PLAYER_UPDATE, playerUpdate);
			definedPlayer.addEventListener(PlayerEvent.MEDIA_DURATION_UPDATE, durationUpdate);
			
			controllBar.addEventListener(PlayerEvent.CONTROLLBAR_UPDATE, controllBarUpdate);
			controllBar.addEventListener(PlayerEvent.CONTROLLBAR_PLAY, controllBarPlay);
			controllBar.addEventListener(PlayerEvent.VOLUME_UPDATE, volumeUpdate);
//			
			definedPlayer.play();
//			
//			controllBar.playStatus = Boolean(int(playerParams.auto_play));
//			playerStatus = !playerParams.auto_play;
//			
//			videoScreenChange();
//			if(ExternalInterface.available)
//			{
//				ExternalInterface.addCallback("seek", seekExternal);//秒
//			}
		}
		
		private var rateCount:int=0;
		private function playerUpdate(event:PlayerEvent):void
		{
			var object:Object = event.data;
			rateCount++;
			//call2js
			if(ExternalInterface.available)
			{
				ExternalInterface.call('updateTime', Number(object.time)*1000);
			}
			
			//			playLabel.text = "当前播放时间"+(Number(event.data));
			
			if(rateCount >= 10)
			{
				rateCount = 0;
				controllBar.updateProgressBarCur(Number(object.time));
				
				controllBar.updateLoadProgress(object.bytesProgress);
			}
		}
		
		private function durationUpdate(event:PlayerEvent):void
		{
//			if(!Boolean(int(playerParams.auto_play)) && IsPlayer)
//			{
//				definedPlayer.pause();
//				IsPlayer = false;				
//			}
			
			controllBar.updateProgressBarMaximum(Number(event.data));
		}
		
		private function controllBarUpdate(event:PlayerEvent):void
		{
			definedPlayer.seek(Number(event.data));
		}
		
		private function controllBarPlay(event:PlayerEvent):void
		{
			definedPlayer.pause();
		}
		
		private function volumeUpdate(event:PlayerEvent):void
		{
			definedPlayer.volume(Number(event.data));
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			videoScreen = new VideoUI();
			videoScreen.percentHeight = videoScreen.percentWidth = 100;
			videoScreen.horizontalCenter = 0;
			videoScreen.verticalCenter = 0;
			addElement(videoScreen);
			
			topBar = new TopBar();
			topBar.percentWidth = 100;
			topBar.height = 40;
			topBar.top = 0;
			addElement(topBar);
			
			var load:LoadingBar = new LoadingBar();
			load.horizontalCenter = 0;
			load.top = 40;
			addElement(load);
			
//			var re:Recommend = new Recommend();
//			re.x = 0;
//			re.y = 40;
//			addElement(re);
			
			controllBar = new ControllBar();
			controllBar.percentWidth = 100;
			controllBar.height = 40;
			controllBar.bottom = 0;
			addElement(controllBar);
			
//			var ac:AdvertChart = new AdvertChart();
//			ac.horizontalCenter = 0;
//			ac.verticalCenter = 0;
//			addElement(ac);
			
		}
	}
}