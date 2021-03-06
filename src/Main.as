package
{
	import com.alex.flexlite.components.VideoUI;
	import com.greensock.TweenLite;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.system.Security;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import constant.NetConstant;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.HttpEvent;
	import events.PlayerEvent;
	
	import net.DefinedPlayer;
	import net.HttpRequest;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.managers.IFocusManager;
	import org.flexlite.domUI.managers.SystemManager;
	import org.flexlite.domUI.skins.themes.VectorTheme;
	
	import view.AdvertChart;
	import view.ControllBar;
	import view.LoadingBar;
	import view.Recommend;
	import view.TopBar;
	import view.VideoShare;
	import view.WaterMark;
	
	[SWF(width="482", height="355", frameRate="25", backgroundColor="#000000")]
	public class Main extends SystemManager
	{
		private const minW:Number = 482;
		private const minH:Number = 355;
		
		private var _frontContainer:Group;
		private var _behindContainer:Group;
		
		private var background:Rect;
		
		private var loadingBar:LoadingBar;
		private var advertChart:AdvertChart;
		private var videoScreen:VideoUI;
		private var topBar:TopBar;
		private var controllBar:ControllBar;
		private var recommend:Recommend;
		private var share:VideoShare;
		private var waterMark:WaterMark;
		
		private var definedPlayer:DefinedPlayer;
		private var playerUrl:String = "http://www.tvm.cn/weibo/get_data?url=www.tvm.cn/ishare/play/play.html?id=";
		
		private var _playerParams:Object={
			swfUrl:null,//swf地址
			id:null,//(url id)视频请求地址
			url:null,//swf地址
			params:null//swf参数
		}
		
		private var _playerInfo:Object={
			url:null,//(mp4url)
			thumburl:null,//缩略图
			sharetitle:null, //专题
			title:null,//标题
			summary:null,//总结
			linksUrl:null//来源链接
		}
		
		private var playerCurIndex:int=0;
		private var playerInfoList:Vector.<Object>;
		private var IsDigitalID:Boolean=false;
		private var IsPlayer:Boolean=true;//是否第一次播放
		public function Main()
		{
			super();
			
			Injector.mapClass(Theme,VectorTheme);
			stage.color = 0x000000;
			//收藏页
			//navigateToURL( (new URLRequest("javascript:window.external.addFavorite('http://qq.com', '收藏名字')")), "_self");
			playerParams.swfUrl = this.loaderInfo.url;
			var urlArray:Array = playerParams.swfUrl.split("?");
			if(urlArray == null)return;
			playerParams.url = urlArray.length > 0 ? urlArray[0] : "";
			playerParams.params = urlArray.length > 1 ? urlArray[1] : "";
			playerParams.id = this.loaderInfo.parameters.id;
//			playerParams.id = 566389;
//			playerParams.id = "18d24f91-c252-9644-32b8-902bcf309103";
//			playerParams.id = 591376;
			
			_main = this;
			
			Security.allowDomain('*');
			
			playerInfoList = new Vector.<Object>();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private static var _main:Main

		public function get playerParams():Object
		{
			return _playerParams;
		}

		public function set playerParams(value:Object):void
		{
			_playerParams = value;
		}

		public static function get main():Main
		{
			return _main;
		}
		
		public function get frontContainer():Group
		{
			if(_frontContainer == null)
				_frontContainer = new Group();
			return _frontContainer;
		}
		
		public function get playerInfo():Object
		{
			return _playerInfo;	
		}
		
		public function get behindContainer():Group
		{
			if(_behindContainer == null)
				_behindContainer = new Group();
			return _behindContainer;
		}
		
		private function addedToStage(event:Event):void
		{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreenChangeHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			addEventListener(MouseEvent.MOUSE_MOVE,userActiveHandler);
			
			GlobalServer.addEventListener(GlobalServerEvent.WEBOPLAYER_LOG, weboPlayerLog);
			
			requestPlayer();
		}
		
		
		public function requestPlayer():void
		{
			var http:HttpRequest = new HttpRequest();
			http.addEventListener(HttpEvent.HTTPSERVICE_FAIL, fail);
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, complete);
			
			IsDigitalID = !isNaN(playerParams.id);
			
			if(!IsDigitalID)
				http.connect(NetConstant.PLAYER_REQUEST_TYPE_STRING_URL+playerParams.id);
			else
				http.connect(NetConstant.PLAYER_REQUEST_TYPE_DIGITAL_URL+playerParams.id);
		}
		
		private function fail(event:HttpEvent):void
		{
//			log("请求视频源加载错误"+event.data);
		}
		
		private function complete(event:HttpEvent):void
		{
			var loader:URLLoader = event.data as URLLoader;
			if(loader.data == "")
			{
//				log("请求视频-无效数据");
				return;
			}
			
			var data:Object = JSON.parse(loader.data);
			if(data.status == "failed")
				return;
			
			//data.sharetitle
			if(IsDigitalID)
			{
				var entrys:Array = data.entry;
				for(var i:int=0;i<entrys.length;i++)
				{
					var da:Object = entrys[i];
					var pInfo:Object = new Object();
					pInfo.sharetitle = data.sharetitle;
					pInfo.title = da.title;
					pInfo.url = da.media.content.url;
					pInfo.summary = da.summary;
					pInfo.thumburl = da.media.thumbnail.url;
					pInfo.linksUrl = NetConstant.PLAYER_LINK_URL+playerParams.params;
					playerInfoList.push(pInfo);
				}
				
				continueToPlay();
			}
			else
			{
				var entry:Object = data.feed.entry;
				if(entry != null)
				{
					playerInfo.sharetitle = "";
					playerInfo.title = entry.title.$t;
					playerInfo.url  = entry.media$group.media$content[0].url;
					playerInfo.summary = entry.summary.$t;
					playerInfo.thumburl = entry.media$group.media$thumbnail.url;
					playerInfo.linksUrl = NetConstant.PLAYER_LINK_URL+playerParams.params;
					
					initPlayer();
				}
			}
		}
		
		private function continueToPlay():void
		{
			if(playerCurIndex >= playerInfoList.length)
				return;
				
			var data:Object = playerInfoList[playerCurIndex];
			playerInfo.sharetitle = data.sharetitle;
			playerInfo.title = data.title;
			playerInfo.url  = data.url;
			playerInfo.summary = data.summary;
			playerInfo.thumburl = data.thumburl;
			playerInfo.linksUrl = data.linksUrl;
			
			initPlayer();
		}
		
		private function initPlayer():void
		{
			if(playerInfo.url)
			{
				//				controllBar.updateProgressBarMaximum(playerParams.content.duration);
				
				definedPlayer = new DefinedPlayer(playerInfo.url, 0);
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
			GlobalServer.addEventListener(GlobalServerEvent.VIDEO_SHARE_ADD, shareAdd);
			GlobalServer.addEventListener(GlobalServerEvent.VIDEO_SHARE_REMOVE, shareRemove);
			
			
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_PLAY_START, playerPlayStart);
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_PLAY_STOP, playerPlayStop);
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_SEEK_UPDATE, playerSeekUpdate);
			
			GlobalServer.addEventListener(GlobalServerEvent.RECOMMEND_PLAY, recommendPlay);
			
			GlobalServer.addEventListener(GlobalServerEvent.PLAYER_PLAY_PAUSE, playerPlayPause);
			
			definedPlayer.bufferTime = 0.5;
			definedPlayer.play();
			
			loadingBar.open();
			
			controllBar.playStatus = true;
		}
		
		/**收入收藏夹*/
		public function favorites():void
		{
			var url:String = NetConstant.VIDEOSHARE_HTMLURL;
			var name:String = Main.main.playerInfo.title;
			if(ExternalInterface.available)
			{
				ExternalInterface.call("favourites", {url:url, name:name});
			}
//			
//			navigateToURL( new URLRequest("javascript:window.external.AddFavorite('"+url+"', '"+name+"'')"), "_self");
		}
		
		private function recommendPlay(event:GlobalServerEvent):void
		{
			controllBar.progressBarEnabled = true;
			
			playerParams.id = event.data;
			
			requestPlayer();
		}
		
		private var rateCount:int=0;
		private function playerUpdate(event:PlayerEvent):void
		{
			var object:Object = event.data;
			rateCount++;
			
			controllBar.updateProgressBarCur(Number(object.time)*10);
			
			if(rateCount >= 10)
			{
				rateCount = 0;
				
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
			
			controllBar.updateProgressBarMaximum(Number(event.data)*10);
			
			fullScreenChangeHandler(null);
		}
		
		private function bufferUpdate(event:PlayerEvent):void
		{
			var data:Number = Number(event.data.toFixed(1));
			var buffTime:Number = data%2 == 0 ? 2 : data%2;
			loadingBar.updateProgress(buffTime, 2);
		}
		
		private function removeLoadBar(event:PlayerEvent):void
		{
			loadingBar.close();
		}
		
		private function controllBarUpdate(event:PlayerEvent):void
		{
//			definedPlayer.seek(Number(event.data));
			if(!definedPlayer.playStatus)
				controllBar.playStatus = true;
			
			if(advertChart.panel_open_status)
				advertChart.close();
			if(recommend.panel_open_status)
				recommend.close();
			if(share.panel_open_status)
				recommend.close();
			playerSeek(Number(event.data)/10);
		}
		
		private function playerSeekUpdate(event:GlobalServerEvent):void
		{
			playerSeek(Number(event.data)/10);
		}
	
		private function playerSeek(value:Number):void
		{
			definedPlayer.seek(value);
		}
		
		private function controllBarPlay(event:PlayerEvent):void
		{
			if(definedPlayer.IsPlayEnd)
			{
				if(recommend.panel_open_status)
					recommend.close();
				
				playerSeek(0);
				
				controllBar.progressBarEnabled = true;
				return;
			}
			playerPause();
		}
		
		private function volumeUpdate(event:PlayerEvent):void
		{
			definedPlayer.volume(Number(event.data));
		}
		
		private function playerPlayPause(event:GlobalServerEvent):void
		{
			playerPause();
		}
		
		private function playerPlayStart(event:GlobalServerEvent=null):void
		{
			if(recommend.panel_open_status)
				recommend.close();
			if(advertChart.panel_open_status)
				advertChart.close();
			if(share.panel_open_status)
				share.close();
			
			controllBar.playStatus = true;
			
			controllBar.progressBarEnabled = true;
			
			fullScreenChangeHandler(null);
		}
		
		private function playerPlayStop(event:GlobalServerEvent):void
		{
			if(!recommend.panel_open_status)
				recommend.open();
			
			controllBar.playStatus = false;
		}
		
		private function shareAdd(event:GlobalServerEvent):void
		{
			share.open();
			if(definedPlayer.playStatus)
				playerPause();
		}
		
		private function shareRemove(event:GlobalServerEvent):void
		{
		}
		
		private function clickPlayPause(event:MouseEvent):void
		{
			playerPause();
		}
		
		/**
		 *	播放器暂停播放 
		 */
		private function playerPause():void
		{
			if(definedPlayer == null)return;
			
			definedPlayer.pause();
			
			if(definedPlayer.playStatus)
			{
				share.close();
				advertChart.close();
			}
			else
			{
				if(!share.panel_open_status && !definedPlayer.IsPlayEnd)
					advertChart.open();
			}
			
			controllBar.playStatus = definedPlayer.playStatus;
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
				
				showControllBar(userActive, visibleType);
			}
		}
		
		private var _visibleType:int;
		public function get visibleType():int
		{
			return _visibleType;
		}
		
		public function set visibleType(value:int):void
		{
			_visibleType = value;
		}
		//Hide&ShowAnimation
		private function showControllBar(userActive:Boolean, visibleType:int):void
		{
			if(visibleType == 0)
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
			else if(visibleType ==1)
			{
				if(topBar)
				{
					TweenLite.killTweensOf(topBar);
					
					TweenLite.to(topBar, 1, {top:(userActive ? 0 : -topBar.height)});
				}
			}
			else if(visibleType == 2)
			{
				if(controllBar)
				{
					TweenLite.killTweensOf(controllBar);
					
					TweenLite.to(controllBar, 1, {bottom:(userActive ? 0 : -controllBar.height-8)});
				}
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
				if(loadingBar && loadingBar.panel_open_status || stage.displayState == StageDisplayState.NORMAL && !IsNormal)
				{
					return;
				}
				
				if( topBar.IsSearch)
				{
					return;
				}
				
				userActive = false;
			},1000);
		}
		
		private function enterFrame(event:Event):void
		{
			fullScreenChangeHandler(null);
		}
		
		private function resizeHandler(event:Event):void
		{
			fullScreenChangeHandler(null);
		}
		
		private var IsNormal:Boolean=false;
		private var lastW:Number;
		private var lastH:Number;
		private function fullScreenChangeHandler(event:FullScreenEvent):void
		{
			if(!IsInit)return;
			if(definedPlayer == null)return;
			
			var mediaInfo:Object = definedPlayer.mediaInfo;
			if(mediaInfo == null || mediaInfo.height <= 0 || mediaInfo.width <= 0)return;
			
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			if(w == lastW && h == lastH)return;
			
			lastW = w;
			lastH = h;
//			if(w < stage.fullScreenWidth)
//				w = minW;
//			if(h <stage.fullScreenHeight)
//				h = minH;
//			
//			if(h == minH)
//				w = minW;
//			if(w == minW)
//				h = minH;
			if(stage.displayState == StageDisplayState.NORMAL)
			{
				visibleType = 0;
				userActive = true;
			}
			
			IsNormal = (mediaInfo.width/mediaInfo.height) == 4/3;
			if(IsNormal)
				visibleType = 1;
			
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
				visibleType = 0;
			
			if(stage.displayState == StageDisplayState.NORMAL && IsNormal)
				userActive = false;
			
			var perw:Number = w / mediaInfo.width;
			var perh:Number = (stage.displayState == StageDisplayState.FULL_SCREEN ? h : (IsNormal ? h-40 : h-80)) / mediaInfo.height;
			var scale:Number = perw < perh ? perw : perh;
			
			videoScreen.width = mediaInfo.width*scale;
			videoScreen.height = mediaInfo.height*scale;
			
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				videoScreen.y = (h-videoScreen.height)/2;
			}
			else
			{
				if(stage.displayState == StageDisplayState.NORMAL && IsNormal)
				{
					videoScreen.y = 0;
				}
				else
				{
					videoScreen.y = ((h-80)-videoScreen.height)/2+40;
				}
			}
//			log("videoScreenWidth"+videoScreen.width+"videoScreenHeight"+videoScreen.height);
			frontContainer.width = mediaInfo.width*scale;
			frontContainer.height = mediaInfo.height*scale;
			
			behindContainer.width = mediaInfo.width*scale;
			behindContainer.height = mediaInfo.height*scale;
//			waterMark.right = (w-videoScreen.width)/2+30/*+waterMark.width*/;
//			waterMark.top = (h-videoScreen.height)/2+20/*+waterMark.height*/;
//			waterMark.right = 15*scale-;
			waterMark.setWH(scale);
			waterMark.right = 15*scale+scale*waterMark.minW;
			
			advertChart.setWH(scale);
			
//			if(stage.displayState == StageDisplayState.FULL_SCREEN)
				recommend.scaleWH(w, h);
//			else
//				recommend.scaleWH(mediaInfo.width, mediaInfo.height);
			
			loadingBar.setWH(w, h);
		}
		
		private function weboPlayerLog(event:GlobalServerEvent):void
		{
//			log(event.data);
		}
		
		private function log(...args):void
		{
			var logstr:String = JSON.stringify(args);
			
			if(info != null)
				info.text = info.text +"weboPlayer"+logstr;
			
			if(ExternalInterface.available)
			{
				ExternalInterface.call('console.log', 'WEBOPLAYER--->',logstr);
			}
		}
		
		private var info:Label;
		private var IsInit:Boolean=false;
		override protected function createChildren():void
		{
			super.createChildren();
			
			background = new Rect();
			background.percentWidth = 100;
			background.percentHeight = 100;
			background.fillColor = 0x000000;
			addElement(background);
			
			videoScreen = new VideoUI();
//			videoScreen.percentHeight = videoScreen.percentWidth = 100;
			videoScreen.horizontalCenter = 0;
//			videoScreen.verticalCenter = 0;
			addElement(videoScreen);
			videoScreen.buttonMode = true;
			videoScreen.addEventListener(MouseEvent.CLICK, clickPlayPause);
			
			frontContainer.horizontalCenter = 0;
			frontContainer.verticalCenter = 0;
			addElement(frontContainer);
			
			topBar = new TopBar();
			topBar.percentWidth = 100;
			topBar.height = 40;
			topBar.top = 0;
			addElement(topBar);
			
			loadingBar = new LoadingBar();
			loadingBar.horizontalCenter = 0;
//			loadingBar.top = 40;
			loadingBar.verticalCenter = 0;
//			addElement(loadingBar);
//			loadingBarStatus = false;
			
			recommend = new Recommend();
//			recommend.x = 0;
//			recommend.y = 40;
			recommend.horizontalCenter = 0;
			recommend.verticalCenter = 0;
//			recommend.open();
			
			controllBar = new ControllBar();
			controllBar.percentWidth = 100;
			controllBar.height = 40;
			controllBar.bottom = 0;
			addElement(controllBar);
			
			behindContainer.horizontalCenter = 0;
			behindContainer.verticalCenter = 0;
			addElement(behindContainer);
			
			advertChart = new AdvertChart();
			advertChart.horizontalCenter = 0;
			advertChart.verticalCenter = 0;
//			addElement(advertChart);
//			advertChartStatus = false;
			
			share = new VideoShare();
			share.horizontalCenter = 0;
			share.verticalCenter = 0;
//			addElement(share);
//			videoShare = false;
			
			waterMark = new WaterMark();
			waterMark.right = 15;
			waterMark.top = 15;
			videoScreen.addElement(waterMark);
//			waterMark.open();
			
			info = new Label();
//			addElement(info);
			info.text = "宽度信息";
			info.textColor = 0xffffff;
			
			IsInit = true;
		}
	}
}