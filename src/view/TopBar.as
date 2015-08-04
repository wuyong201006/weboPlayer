package view
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import component.skin.button.ShareBigButtonSkin;
	
	import events.PlayerEvent;
	
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
		public function TopBar()
		{
			super();
			
//			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
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
			dispatchEvent( new PlayerEvent(PlayerEvent.VIDEO_SHARE_ADD));
		}
		
		private function clickSearch(event:MouseEvent):void
		{
			
		}
		
		private function focusIn(event:FocusEvent):void
		{
			searchTxt.text = "";
		}
		
		private function focusOut(event:FocusEvent):void
		{
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
			addElement(sg);
			
			searchTxt = new EditableText();
			searchTxt.text = "无心法师";
			searchTxt.width = 150;
			searchTxt.height = 18;
			searchTxt.verticalCenter = 0;
			searchTxt.left = 25;
			addElement(searchTxt);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			searchTxt.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			searchBtn = new Button();
			searchBtn.width = searchBtn.height = 12;
			searchBtn.verticalCenter = 0;
			searchBtn.left = 165;
			searchBtn.skinName = new serchBtn;
			addElement(searchBtn);
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