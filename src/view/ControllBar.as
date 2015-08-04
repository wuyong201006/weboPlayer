package view
{
	import com.greensock.TweenLite;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import component.skin.button.PauseButtonSkin;
	import component.skin.button.PlayButtonSkin;
	import component.skin.button.PlayerButtonSkin;
	import component.skin.slider.PlayerHSliderSkin;
	import component.skin.volumeBar.VolumeHSliderSkin;
	import component.slider.PlayerHSlider;
	
	import constant.NetConstant;
	
	import date.DateString;
	
	import events.PlayerEvent;
	
	import net.NetManager;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.HSlider;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VSlider;
	
	public class ControllBar extends Group
	{
		private var progressBar:PlayerHSlider;
		private var volumeBar:HSlider;
		//UI PlayButton
		private var playBtn:Button;
		
		//UI StopButton
		private var pauseBtn:Button;
		
		private var curProLabel:Label;
		
		private var zoomInBtn:Button;
		private var zoomOutBtn:Button;
		
		private var volumeContainer:Group;
		private var volumeOpenBtn:Button;
		private var volumeCloseBtn:Button;
		
		private var frameList:Array = [];
		public function ControllBar()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		protected function addToStageHandler(event:Event):void
		{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreenChangeHandler);
//			stage.addEventListener(ResizeEvent.RESIZE, updatePosition);
		}
		
		public function updateProgressBarMaximum(value:Number):void
		{
			progressBar.maximum = value;
//			talProLabel.text = int(progressBar.maximum/3600)+":"+DateString.dateToString(progressBar.maximum%3600);
		}
		
		public function updateLoadProgress(value:Number):void
		{
			progressBar.progressValue = value;
		}
		
		public function updateProgressBarCur(curValue:Number, maxValue:Number=0):void
		{
			progressBar.value = curValue;
			maxValue = progressBar.maximum;
			curProLabel.text = DateString.dateToString(curValue%3600)+"/"+DateString.dateToString(maxValue%3600);
		}
		
		public function set playStatus(value:Boolean):void
		{
			playBtn.visible = !(pauseBtn.visible = value);
		}
		
		private function set volumeStatus(value:Boolean):void
		{
			volumeOpenBtn.visible = !(volumeCloseBtn.visible = value);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			var data:int=0;
			if(event.target == playBtn)
			{
				data = 0;
				playStatus = true;
			}
			else
			{
				data = 1;
				playStatus = false;
			}
			
			dispatchEvent( new PlayerEvent(PlayerEvent.CONTROLLBAR_PLAY, data));
		}
		
		private function progressBarChange(event:Event):void
		{
			dispatchEvent( new PlayerEvent(PlayerEvent.CONTROLLBAR_UPDATE, progressBar.value));
			var value:Number = progressBar.value;
			curProLabel.text = int(value/3600)+":"+DateString.dateToString(value%3600);
		}
		
		protected function fullScreenChangeHandler(event:FullScreenEvent):void
		{
			zoomInBtn.visible = Boolean(event.fullScreen);
			zoomOutBtn.visible = !zoomInBtn.visible;
		}
		
		private var lastVolumeValue:Number;
		private function volumeSwitch(event:MouseEvent):void
		{
			if(volumeBar.value > 0)
				lastVolumeValue = volumeBar.value;
			
			var volume:Number;
			if(event.target == volumeCloseBtn)
			{
				volumeStatus = false;
				volume = lastVolumeValue;
			}
			else
			{
				volumeStatus = true;
				volume = 0;
			}
			
			volumeBar.value = volume;
			dispatchEvent( new PlayerEvent(PlayerEvent.VOLUME_UPDATE, volume));
		}
		
		private function zoomInOutSwitch(event:MouseEvent):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				stage.displayState = StageDisplayState.NORMAL;
			}else
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		
		private function volumeBarChanged(event:Event):void
		{
			if(volumeBar.value == 0)
				volumeStatus = true;
			else
				volumeStatus = false;
			
			dispatchEvent( new PlayerEvent(PlayerEvent.VOLUME_UPDATE, volumeBar.value));
		}
		
		private function rollOver(event:MouseEvent):void
		{
			volumeBar.visible = true;
		}
		
		private function rollOut(event:MouseEvent):void
		{
			volumeBar.visible = false;
		}
		
		private function clickGlobal(event:MouseEvent):void
		{
			NetManager.sendURL(NetConstant.GLOABLPLAYERURL);
		}
		
		private function frameClick(event:MouseEvent):void
		{
			
		}
		
		private var scale:Number = 395/950;
		private var lastWidth:Number;
		public function updatePosition(wid:Number):void
		{
//			if(stage.stageWidth < 395 || stage.stageWidth > 950)return;
//			if(wid == lastWidth)return;
			
			lastWidth = wid;
			
			var  scaleWidth:Number=lastWidth;
			scale = scaleWidth/395;
			progressBar.width = scale*145;
			
			if(wid < 395)
			{
				scaleWidth = 395;
			}
			else if(wid > 950)
			{
				scaleWidth = 950;
			}
			else
			{
				scaleWidth = wid;
			}
			
			scale = scaleWidth/395;
			
			playBtn.left = pauseBtn.left = 50*scale;
			curProLabel.left = 75*scale;
//			talProLabel.left = 290*scale;
			progressBar.left = 133*scale;
//			progressBar.width = 145*scale;
			zoomInBtn.right = zoomOutBtn.right = 5*scale;
			volumeContainer.right = 28*scale;
			var volumeValue:Number = 50*scale;
			if(volumeValue > 100)
				volumeValue = 100;
			volumeBar.height = volumeValue;
			volumeBar.top = -volumeValue;
			
			var tvmScaleValue:Number = scale*.8;
			if(tvmScaleValue > 1)
				tvmScaleValue = 1;
			
			var ppScale:Number = playBtn.width/playBtn.height;
			var ppScaleValue:Number = scale*.5;
			if(ppScaleValue > 1)
				ppScaleValue = 1;
			playBtn.scaleX = pauseBtn.scaleX = Number(ppScaleValue.toFixed(2));
			playBtn.scaleY = pauseBtn.scaleY = Number(ppScaleValue.toFixed(2));
			
//			var ctScale:Number = curProLabel.width/curProLabel.height;
//			curProLabel.scaleX = talProLabel.scaleX = .5;
//			curProLabel.scaleY = talProLabel.scaleY = .5/ctScale;
			var fontSize:Number = scale*12;
			if(fontSize > 18)
				fontSize = 18;
			curProLabel.size = fontSize;
			
			var ioScale:Number = zoomInBtn.width/zoomInBtn.height;
			var ioScaleValue:Number = scale*.5;
			if(ioScaleValue > 1)
				ioScaleValue = 1;
			zoomInBtn.scaleX = zoomOutBtn.scaleX = Number(ioScaleValue.toFixed(2));
			zoomInBtn.scaleY = zoomOutBtn.scaleY = Number(ioScaleValue.toFixed(2));
			
			var ocScale:Number = volumeOpenBtn.width/volumeOpenBtn.height;
			var ocScaleValue:Number = scale*.5;
			if(ocScaleValue > 1)
				ocScaleValue = 1;
			volumeOpenBtn.scaleX = volumeCloseBtn.scaleX = Number(ocScaleValue.toFixed(2));
			volumeOpenBtn.scaleY = volumeCloseBtn.scaleY = Number(ocScaleValue.toFixed(2));
		}
		
		private const minWidht:Number = 482;
		private const minHeight:Number = 355;
		public function scaleWidthAndHeight(width:Number, height:Number):void
		{
			var perw:Number = width / minWidth;
			var perh:Number = height / minHeight;
			var scale:Number = perw < perh ? perw : perh;
			
			
		}
		
		override protected function measure():void
		{
			super.measure();
//			updatePosition(null);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
//			updatePosition(null);
		}
		//UI Bg
		override protected function createChildren():void
		{
			super.createChildren();
			
			var bg:Rect = new Rect();
			bg.fillColor = 0x1A1E27;
			bg.percentHeight = bg.percentWidth = 100;
//			bg.alpha = 0.6;
			addElement(bg);
//			var bg:UIAsset = new UIAsset();
//			bg.percentHeight = bg.percentWidth = 100;
//			bg.skinName = new back_bottom;
//			addElement(bg);
			
			
			playBtn = new Button();
//			playBtn.skinName = new Bitmap(new playSmall);
//			playBtn.horizontalCenter = 0;
//			playBtn.width = 50;
//			playBtn.height = 42;
//			playBtn.bottom = 0;
			playBtn.skinName = PlayButtonSkin;
			addElement(playBtn);
			playBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			pauseBtn = new Button();
			pauseBtn.width = 50;
			pauseBtn.height = 42;
			pauseBtn.visible = false;
//			pauseBtn.skinName = new Bitmap(new pauseSmall);
//			pauseBtn.bottom = 0;
			pauseBtn.skinName = PauseButtonSkin;
			addElement(pauseBtn);
			pauseBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			curProLabel = new Label();
			curProLabel.left = 70;
			curProLabel.verticalCenter = 0;
			addElement(curProLabel);
//			curProLabel.bold = true;
			curProLabel.size = 12;
			curProLabel.textColor = 0xffffff;
			curProLabel.text = "00:00/00:00";
			
			
			zoomInBtn = new Button()
			zoomInBtn.width = 20;
			zoomInBtn.height = 20;
			zoomInBtn.visible = false;
			zoomInBtn.verticalCenter = 0;
			zoomInBtn.right = 142;
			zoomInBtn.skinName = new PlayerButtonSkin(screen_normal, screen_hover);
			addElement(zoomInBtn);
			zoomInBtn.addEventListener(MouseEvent.CLICK,zoomInOutSwitch)
			
			zoomOutBtn = new Button()
			zoomOutBtn.width = 18;
			zoomOutBtn.height = 18;
			zoomOutBtn.verticalCenter = 0;
			zoomOutBtn.right = 142;
			zoomOutBtn.skinName = new PlayerButtonSkin(fullScreen_normal, fullScreen_hover);
			addElement(zoomOutBtn);
			zoomOutBtn.addEventListener(MouseEvent.CLICK,zoomInOutSwitch);
			
			volumeContainer = new Group();
			volumeContainer.verticalCenter = 0;
			volumeContainer.left = 150;
			addElement(volumeContainer);
//			volumeContainer.addEventListener(MouseEvent.ROLL_OVER, rollOver);
//			volumeContainer.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			volumeOpenBtn = new Button()
			volumeOpenBtn.height = 17
			volumeOpenBtn.width = 16;
			volumeOpenBtn.left = 0;
			volumeOpenBtn.skinName = new volumeOpen;
			volumeContainer.addElement(volumeOpenBtn);
			volumeOpenBtn.addEventListener(MouseEvent.CLICK, volumeSwitch);
			
			volumeCloseBtn = new Button()
			volumeCloseBtn.width = 17
			volumeCloseBtn.height = 17;
			volumeCloseBtn.left = 0;
			volumeCloseBtn.skinName = new volumeClose;
			volumeContainer.addElement(volumeCloseBtn);
			volumeCloseBtn.addEventListener(MouseEvent.CLICK, volumeSwitch);
			volumeCloseBtn.visible = false;
			
			volumeBar = new HSlider();
			volumeBar.width = 74;
			volumeBar.verticalCenter = 0;
			volumeBar.left = 20;
			volumeBar.minimum = 0;
			volumeBar.maximum = 1;
			volumeBar.stepSize = 0.1;
			volumeBar.skinName = VolumeHSliderSkin;
			volumeContainer.addElement(volumeBar);
			volumeBar.addEventListener(Event.CHANGE,volumeBarChanged);
			
//			volumeBar.visible = false;
			TweenLite.delayedCall(0.5, function():void{
				volumeBar.value = 0.5;
				dispatchEvent( new PlayerEvent(PlayerEvent.VOLUME_UPDATE, volumeBar.value));
			})
				
			var g:Group = new Group();
//			g.right = 20;
//			g.verticalCenter = 0;
//			addElement(g);
//			g.buttonMode = true;
//			g.addEventListener(MouseEvent.CLICK, clickGlobal);
			
			var glogo:UIAsset = new UIAsset();
			glogo.skinName = new logo;
			g.addElement(glogo);
			
			var gTxt:Label = new Label();
			gTxt.left = 28;
			gTxt.verticalCenter = 0;
			gTxt.text = "环球视讯";
			gTxt.textColor = 0xffffff;
			gTxt.size = 14;
			gTxt.bold = true;
			g.addElement(gTxt);
			
			var global:Button = new Button();
			global.right = 20;
			global.verticalCenter = 0;
			global.skinName = g;
			addElement(global);
			global.addEventListener(MouseEvent.CLICK, clickGlobal);
			
			progressBar = new PlayerHSlider();
			progressBar.percentWidth = 100;
			progressBar.top = -8;
			addElement(progressBar);
			progressBar.minimum = 0;
			progressBar.maximum = 1;
			progressBar.stepSize = 1;
			progressBar.skinName = PlayerHSliderSkin;
			progressBar.addEventListener(Event.CHANGE, progressBarChange);
		}
	}
}