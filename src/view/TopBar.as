package view
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	
	import component.skin.button.ShareBigButtonSkin;
	
	import constant.NetConstant;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.HttpEvent;
	import events.PlayerEvent;
	
	import net.HttpRequest;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	
	public class TopBar extends Group
	{
		private var searchTxt:EditableText;
		private var searchBtn:Button;
		private var shareBtn:Button;
		
		private var _IsSearch:Boolean=false;
		public function TopBar()
		{
			super();
			
//			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		public function get IsSearch():Boolean
		{
			return _IsSearch;
		}

		public function set IsSearch(value:Boolean):void
		{
			_IsSearch = value;
		}

		protected function addToStageHandler(event:Event):void
		{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreenChangeHandler);
		}
		
		protected function fullScreenChangeHandler(event:FullScreenEvent):void
		{
//			zoomInBtn.visible = event.fullScreen;
//			zoomOutBtn.visible = ! zoomInBtn.visible;
		}
		
		private function zoomInOutSwitch(evt:MouseEvent):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				stage.displayState = StageDisplayState.NORMAL;
			}else
			{
				stage.displayState = StageDisplayState.FULL_SCREEN
			}
		}
		
		private function clickShare(event:MouseEvent):void
		{
			GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.VIDEO_SHARE_ADD));
//			GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_PAUSE));
		}
		
		private function clickSearch(event:MouseEvent):void
		{
			var http:HttpRequest = new HttpRequest();
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, complete);
			var data:Object = "q="+searchTxt.text+"&count=7&startPage=1&alt=json&fields=id,published,content,title,t:props,media:group,t:rtype,summary";
			http.connect(NetConstant.VIDEO_SEARCH, data);
		}
		
		private function complete(event:HttpEvent):void
		{
			var loader:URLLoader = new URLLoader();
			if(loader.data == undefined || loader.data == "")
			{
				return;
			}
			var datas:Object = JSON.parse(loader.data);
			trace(datas);
		}
		
		private function focusIn(event:FocusEvent):void
		{
			IsSearch = true;
			searchTxt.text = "";
		}
		
		private function focusOut(event:FocusEvent):void
		{
			IsSearch = false;
			if(searchTxt.text == "")
			{
				searchTxt.text = "无心法师";
			}
		}
		//UI Bg
		override protected function createChildren():void
		{
			super.createChildren();
			
			var bg:Rect = new Rect();
			bg.fillColor = 0x262C3E;
//			bg.alpha = 0.6;
			bg.percentHeight = bg.percentWidth = 100;
			addElement(bg);
			
			var sg:UIAsset = new UIAsset();
			sg.left = 20;
			sg.verticalCenter = 0;
			sg.skinName = new searchBg;
//			addElement(sg);
			
			searchTxt = new EditableText();
			searchTxt.text = "无心法师";
			searchTxt.width = 150;
			searchTxt.height = 18;
			searchTxt.verticalCenter = 0;
			searchTxt.left = 25;
//			addElement(searchTxt);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			searchTxt.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			searchBtn = new Button();
			searchBtn.width = searchBtn.height = 12;
			searchBtn.verticalCenter = 0;
			searchBtn.left = 165;
			searchBtn.skinName = new serchBtn;
//			addElement(searchBtn);
			searchBtn.addEventListener(MouseEvent.CLICK, clickSearch);
			
			shareBtn = new Button();
//			shareBtn.width = shareBtn.height = 28;
			shareBtn.verticalCenter = 0;
			shareBtn.right = 20;
			shareBtn.skinName = ShareBigButtonSkin;
			addElement(shareBtn);
//			shareBtn.skinName = new Bitmap(new shareBtn.png);
			shareBtn.addEventListener(MouseEvent.CLICK, clickShare);
		}
	}
}