package
{
	import com.alex.flexlite.components.VideoUI;
	import com.greensock.TweenLite;
	import com.hurlant.util.Base64;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.HttpEvent;
	import events.PlayerEvent;
	
	import net.DefinedPlayer;
	import net.HttpRequest;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.managers.SystemManager;
	import org.flexlite.domUI.skins.themes.VectorTheme;
	
	import view.AdvertChart;
	import view.ControllBar;
	import view.LoadingBar;
	import view.Recommend;
	import view.TopBar;
	import view.VideoShare;
	
	[SWF(width="482", height="355", frameRate="25"]
	public class Main extends SystemManager
	{
		private const minWidth:Number = 482;
		private const minHeight:Number = 355;
		
		private var loadingBar:LoadingBar;
		private var advertChart:AdvertChart;
		private var videoScreen:VideoUI;
		private var topBar:TopBar;
		private var controllBar:ControllBar;
		private var recommend:Recommend;
		private var share:VideoShare;
		
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
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreenChangeHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			addEventListener(MouseEvent.MOUSE_MOVE,userActiveHandler);
		}
		
		
		private function requestPlayer():void
		{
//			var request:URLRequest = new URLRequest(playerUrl);
//			
//			request.method = URLRequestMethod.GET;
//			request.data = playerParams.url;
//			
//			var loader:URLLoader = new URLLoader();
//			loader.dataFormat = URLLoaderDataFormat.TEXT;
//			loader.addEventListener(Event.COMPLETE, complete);
//			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
//			loader.load(request);
			var http:HttpRequest = new HttpRequest();
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, complete);
			http.connect(playerUrl+playerParams.url);
		}
		
		private function ioError(event:Event):void
		{
			//			trace("请求视频源加载错误！！！");
		}
		
		private function complete(event:HttpEvent):void
		{
			var loader:URLLoader = event.data as URLLoader;
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
			definedPlayer.addEventListener(PlayerEvent.PLAYER_BUFFER_UPDATE, bufferUpdate);
			definedPlayer.addEventListener(PlayerEvent.PLAYER_BUFFER_FULL, removeLoadBar);
			
			controllBar.addEventListener(PlayerEvent.CONTROLLBAR_UPDATE, controllBarUpdate);
			controllBar.addEventListener(PlayerEvent.CONTROLLBAR_PLAY, controllBarPlay);
			controllBar.addEventListener(PlayerEvent.VOLUME_UPDATE, volumeUpdate);
//			
			share.addEventListener(PlayerEvent.VIDEO_SHARE_ADD, shareAdd);
			share.addEventListener(PlayerEvent.VIDEO_SHARE_REMOVE, shareRemove);
			
			
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_PLAY_START, playerPlayStart);
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_PLAY_STOP, playerPlayStop);
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_SEEK_UPDATE, playerSeekUpdate);
			definedPlayer.bufferTime = 30;
			definedPlayer.play();
			loadingBarStatus = true;
			controllBar.playStatus = true;
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
			
			fullScreenChangeHandler(null);
		}
		
		private function bufferUpdate(event:PlayerEvent):void
		{
			trace("buff"+event.data);
			
			var buffTime:Number = Number(event.data)%2;
			loadingBar.updateProgress(buffTime, 2);
		}
		
		private function removeLoadBar(event:PlayerEvent):void
		{
			loadingBarStatus = false;
		}
		
		private function controllBarUpdate(event:PlayerEvent):void
		{
//			definedPlayer.seek(Number(event.data));
			playerSeek(Number(event.data));
		}
		
		private function playerSeekUpdate(event:GlobalServerEvent):void
		{
			playerSeek(Number(event.data));
		}
	
		private function playerSeek(value:Number):void
		{
			definedPlayer.seek(value);
		}
		
		private function controllBarPlay(event:PlayerEvent):void
		{
			advertChartStatus = Boolean(event.data);
			definedPlayer.pause();
		}
		
		private function volumeUpdate(event:PlayerEvent):void
		{
			definedPlayer.volume(Number(event.data));
		}
		
		private function playerPlayStart(event:GlobalServerEvent):void
		{
			recommendStatus = false;
			
			fullScreenChangeHandler(null);
		}
		
		private function playerPlayStop(event:GlobalServerEvent):void
		{
			recommendStatus = true;
		}
		
		private function shareAdd(event:PlayerEvent):void
		{
			videoShare = true;
		}
		
		private function shareRemove(event:PlayerEvent):void
		{
			videoShare = false;
		}
		
		private function set loadingBarStatus(value:Boolean):void
		{
			loadingBar.visible = value;
		}
		/**
		 *	广告图状态 
		 */
		private function set advertChartStatus(value:Boolean):void
		{
			advertChart.visible = value;
		}
		
		private function set recommendStatus(value:Boolean):void
		{
			recommend.visible = value;	
		}
		
		private function set videoShare(value:Boolean):void
		{
			share.visible = value;
		}
		
		private var _userActive:Boolean;
		public function get userActive():Boolean
		{
			return _userActive;
		}
		
		public function set userActive(value:Boolean):void
		{
			if(_userActive !== value)
			{
				_userActive = value;
				
				showControllBar(userActive);
			}
		}
		
		//Hide&ShowAnimation
		private function showControllBar(userActive:Boolean):void
		{
			if(topBar)
			{
				TweenLite.killTweensOf(topBar);
				
				TweenLite.to(topBar, 1, {top:(userActive ? 0 : -topBar.height)});
			}
			
			if(controllBar)
			{
				TweenLite.killTweensOf(controllBar);
				
				TweenLite.to(controllBar, 1, {bottom:(userActive ? 0 : -controllBar.height-8)});
			}
		}
		
		//DeAcitvehandlerFun
		protected function userActiveHandler(event:MouseEvent):void
		{
			userActive = true;
			
			monitorDeactive();
		}
		
		//MonitorTiemoutID
		private var monitorId:int;
		
		//Monitor Controllbar Deative
		private function monitorDeactive():void
		{
			if(monitorId) clearTimeout(monitorId);
			
			monitorId = setTimeout(function():void
			{
				userActive = false;
			},2000);
		}
		
		private function resizeHandler(event:Event):void
		{
			fullScreenChangeHandler(null);
		}
		
		private function fullScreenChangeHandler(event:FullScreenEvent):void
		{
			if(!IsInit)return;
			if(definedPlayer == null)return;
			
			var mediaInfo:Object = definedPlayer.mediaInfo;
			if(mediaInfo == null || mediaInfo.height <= 0 || mediaInfo.width <= 0)return;
			
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight
			if(w < stage.fullScreenWidth)
				w = minWidth;
			if(h <stage.fullScreenHeight)
				h = minHeight;
			
			var perw:Number = w / mediaInfo.width;
			var perh:Number = h / mediaInfo.height;
			var scale:Number = perw < perh ? perw : perh;
			
			videoScreen.width = w*scale;
			videoScreen.height = h*scale;
			recommend.scaleWH(w, h);
		}
		
		private var IsInit:Boolean=false;
		override protected function createChildren():void
		{
			super.createChildren();
			
			videoScreen = new VideoUI();
//			videoScreen.percentHeight = videoScreen.percentWidth = 100;
			videoScreen.horizontalCenter = 0;
			videoScreen.verticalCenter = 0;
			addElement(videoScreen);
			
			topBar = new TopBar();
			topBar.percentWidth = 100;
			topBar.height = 40;
			topBar.top = 0;
			addElement(topBar);
			
			loadingBar = new LoadingBar();
			loadingBar.horizontalCenter = 0;
			loadingBar.top = 40;
			addElement(loadingBar);
			loadingBarStatus = false;
			
			recommend = new Recommend();
			recommend.x = 0;
			recommend.y = 40;
			addElement(recommend);
			recommendStatus = false;
			
			controllBar = new ControllBar();
			controllBar.percentWidth = 100;
			controllBar.height = 40;
			controllBar.bottom = 0;
			addElement(controllBar);
			
			advertChart = new AdvertChart();
			advertChart.horizontalCenter = 0;
			advertChart.verticalCenter = 0;
			addElement(advertChart);
			advertChartStatus = false;
			
			share = new VideoShare();
			share.horizontalCenter = 0;
			share.verticalCenter = 0;
			addElement(share);
			videoShare = false;
			
			IsInit = true;
		}
	}
}