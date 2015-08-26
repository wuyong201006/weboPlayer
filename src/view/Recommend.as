package view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.utils.getTimer;
	
	import component.skin.button.PlayerButtonSkin;
	
	import constant.NetConstant;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.HttpEvent;
	
	import net.HttpRequest;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	
	import vo.VideoInfo;
	
	/**
	 *	推荐页 
	 */
	public class Recommend extends BasePanel
	{
		private var container:Group;
		
		private var preBtn:Button;
		private var nextBtn:Button;
		
		private var lastIndex:int=-1;
		private var _curIndex:int=0;
		
		private var minValue:int=1;
		private var maxValue:int=5;
		
		private var lastRecommend:Group;
		private var curRecommend:Group;
		
		private var lastTweenlite:TweenLite;
		private var curTweenlite:TweenLite;
		
		private var _videoList:Vector.<VideoInfo>;
		
		private var _scale:Number=1;
		public function Recommend()
		{
			super();
			
			this.width = minW;
			this.height = minH;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function get curIndex():int
		{
			return _curIndex;
		}

		public function set curIndex(value:int):void
		{
			_curIndex = value;
		}

		private function addedToStage(event:Event):void
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			
//			createTimer();
			
//			var test:Vector.<VideoInfo> = new Vector.<VideoInfo>();
//			for(var i:int=0;i<7;i++)
//			{
//				test.push(new VideoInfo());
//			}
//			
//			videoList = test;
		}
		
		private function rollOver(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		private function rollOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			this.panel_open_status && createTimer();
		}
		
		private function moveHandler(event:MouseEvent):void
		{
			clearTimer();
//			destory();
		}
		
		private function requestPlayerList():void
		{
			var http:HttpRequest = new HttpRequest();
			http.addEventListener(HttpEvent.HTTPSERVICE_FAIL, fail);
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, complete);
			var data:Object = "alt=json&count=7&i=tv&id="+Main.main.playerParams.id+"&startPage=1&fields=id,published,content,title,t:props,media:group,t:rtype,summary";
			http.connect(NetConstant.RECOMMENDURL+data);
		}
		
		private function fail(event:HttpEvent):void
		{
			GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.WEBOPLAYER_LOG, "推荐页加载错误:"+event.data));
		}
		
		private function complete(event:HttpEvent):void
		{
			var loader:URLLoader = event.data as URLLoader;
			if(loader.data == "")
			{
				GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.WEBOPLAYER_LOG, "推荐页无效数据"));
				return;
			}
			
			var data:Object = JSON.parse(loader.data);
			var datas:Object = data.feed.entry;
			
			var list:Vector.<VideoInfo> = new Vector.<VideoInfo>();
			for(var i:int=0;i<datas.length;i++)
			{
				var videoInfo:VideoInfo = new VideoInfo(datas[i]);
				list.push(videoInfo);
			}
			
			videoList = list;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function get videoList():Vector.<VideoInfo>
		{
			return _videoList;
		}

		public function set videoList(value:Vector.<VideoInfo>):void
		{
			_videoList = value;
			
			minValue = 0;
			maxValue = int((_videoList.length+1)/4)+((_videoList.length+1)%4 >0 ? 1 : 0);
			
			start();
			lastTime = getTimer();
			createTimer();
		}
		
		private function createTimer():void
		{
			if(videoList == null)return;
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function clearTimer():void
		{
//			lastTime = 0;
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private var lastTime:Number=0;
		private function loop(event:Event):void
		{
			if(maxValue <= 1)return;
			if(getTimer()-lastTime < 4000)return;
			
			curIndex++;
			if(curIndex >= maxValue)
				curIndex = 0;
			
			clearTimer();
			createTimer();
			if(curIndex == lastIndex)
			{
				return;
			}
			
			lastTime = getTimer();
			
			start();
		}
		
		private var IsClick:Boolean=false;
		private function clickHandler(event:MouseEvent):void
		{
			clearTimer();
			
			if(moveExcute())return;
			
			if(event.target == preBtn)
			{
				IsClick = true;
				curIndex --;
				if(curIndex < minValue)
					curIndex = maxValue-1;
			}
			else
			{
				IsClick = false;				
				curIndex++;
				if(curIndex > maxValue-1)
					curIndex = 0;
			}
				
			if(curIndex == lastIndex)return;
			
			start();
		}
		
		/**
		 *	是否在移动中 
		 */
		private function moveExcute():Boolean
		{
			if(IsMove)return true;
			IsMove = true;
			
			return false;
		}
		
		private function start():void
		{
			var offIndex:int = curIndex == 0 ? curIndex*4 : curIndex*4-1;
			var list:Vector.<VideoInfo> = new Vector.<VideoInfo>();
			for(var i:int=offIndex;i<videoList.length;i++)
			{
				if(offIndex == 0 && i >= offIndex+3)
					break;
				if(i >= offIndex+4)
					break;
				list.push(videoList[i]);
			}
			
			turn(list);
		}
		
		private var IsMove:Boolean=false;
		private function turn(list:Vector.<VideoInfo>):void
		{
			var IsLeft:Boolean= false;
			if(IsClick)
				IsLeft = false;
			else
				IsLeft = true;
			
			IsClick = false;
			var wid:Number = this.width;
			curRecommend = draw(list);	
			curRecommend.x = IsLeft ? wid : -wid;
			container.addElement(curRecommend);
			 
//			TweenLite.delayedCall(2, function():void{
			if(lastRecommend != null)
			{
				lastTweenlite = TweenLite.to(lastRecommend,  1, {x:IsLeft ? -wid : wid, ease:Linear.ease, onComplete:function():void{
					removeRecommend(lastRecommend);
				}});
			}
			
				curTweenlite = TweenLite.to(curRecommend, 1, {x:0, ease:Linear.ease, onComplete:function():void{
				lastRecommend = curRecommend;
				lastIndex = curIndex;
				
				IsMove = false;
			}});
//			});
		}
		
		private function draw(list:Vector.<VideoInfo>):Group
		{
			var gr:Group = new Group();
			gr.percentWidth = 100;
			gr.percentHeight = 100;
//			gr.width = 390*scale;
//			gr.height = 225*scale;
			
			for(var i:int=0;i<list.length;i++)
			{
				var g:RecommendUnit = new RecommendUnit(list[i], scale);
				g.left = int(i%2)*(15+g.width);
				g.top = int(i/2)*(15+g.height);
				gr.addElement(g);
			}
			
			if(curIndex == 0 && list.length < 4)
			{
				var group:RecommendUnit = new RecommendUnit(null, scale, false);
				group.left = group.width+15;
				group.top = group.height+15;
				gr.addElement(group);
			}
			return gr;
		}
		
		private var minW:Number = 482;
		private var minH:Number = 271;
		
		private var wid:Number;
		private var hei:Number;
		public function scaleWH(width:Number, height:Number):void
		{
			wid = width;
			hei = height;
			
			if(stage == null)return;
			
			if(width < stage.fullScreenWidth)
				this.width = minW;
			else
				this.width = width;
				
			if(height < stage.fullScreenHeight)
				this.height = minH;
			else
				this.height = height;
			
			var perw:Number = width / minW;
			var perh:Number = height / minH;
			var scale:Number = perw < perh ? perw : perh;
			
			_scale = scale;
			
			if(bg != null)
			{
				bg.width = 482*scale;				
				bg.height = height+80/*271*scale*/;
			}
			
			if(mask != null)
			{
				mask.width = 482*scale;
				mask.height = height+40;
			}
			
			if(container != null)
			{
				container.width = 390*scale;
				container.height = 225*scale;
			}
			
			if(preBtn != null)
			{
				preBtn.left = 15*scale;
				preBtn.scaleX = scale;
				preBtn.scaleY = scale;				
			}
			
			if(nextBtn != null)
			{
				nextBtn.scaleX = scale;
				nextBtn.scaleY = scale;
				nextBtn.x = this.width-nextBtn.width-15*scale;
				
				GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.WEBOPLAYER_LOG, "Recommend:"+"width"+this.width+"nextBtn"+nextBtn.width)); 
			}
			
			var reWidth:Number = 190*scale;
			var reHeight:Number = 108*scale;
			
			setRecommendWH(reWidth, reHeight, curRecommend);
			setRecommendWH(reWidth, reHeight, lastRecommend);
		}
		
		private function setRecommendWH(width:Number, height:Number, group:Group):void
		{
			if(group != null)
			{
				for(var i:int=0;i<group.numChildren;i++)
				{
					var re:RecommendUnit = group.getElementAt(i) as RecommendUnit;
					re.width = width;
					re.height = height;
					re.left = int(i%2)*(15+re.width);
					re.top = int(i/2)*(15+re.height);
					
					re.scaleWH();
				}
			}
		}
		
		private var bg:Rect;
		private var mask:Rect;
		override protected function createChildren():void
		{
			super.createChildren();
			
			bg = new Rect();
			bg.fillColor = 0x000000;
			bg.width = /*percentWidth*/482*scale;
			bg.height = /*271*/355*scale;
			bg.top = -80;
			bg.alpha = 0.6;
			addElement(bg);
			
			container = new Group();
			container.width = 390*scale;
			container.height =  225*scale;
			container.horizontalCenter = 0;
			container.verticalCenter = 0;
			addElement(container);
			
			preBtn = new Button();
			preBtn.left = 15;
			preBtn.verticalCenter = 0;
			preBtn.skinName = new PlayerButtonSkin(prePage_normal, prePage_hover);
			addElement(preBtn);
			preBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			nextBtn = new Button();
			nextBtn.width = 17;
			nextBtn.height = 26;
			nextBtn.x = this.width-nextBtn.width-15;
			nextBtn.verticalCenter = 0;
			nextBtn.skinName = new PlayerButtonSkin(nextPage_normal, nextPage_hover);
			addElement(nextBtn);
			nextBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			mask = new Rect();
			mask.fillColor = 0x000000;
			mask.width = /*percentWidth*/482*scale;
			mask.height = /*271*/355*scale;
			mask.top = -40;
			addElement(mask);
			mask.mouseEnabled = false;
			mask.mouseChildren = false;
			
			container.mask = mask;
		}
		
		 protected function removeRecommend(group:Group):void
		 {
			 if(container == null || group == null)return;
			 
			 if(container.getElementIndex(group) >= 0)
				 container.removeElement(group);
			 
			 while(group.numChildren)
			 {
				 var re:Group = group.removeElementAt(group.numChildren-1) as Group;
				 if(re is RecommendUnit)
				 {
						RecommendUnit(re).destory();
						re = null;					 
				 }
			 }
			 
			 group = null;
		 }
		 
		 override public function open():void
		 {
			 super.open();
			 
			 if(wid > 0 || hei > 0)
				 scaleWH(wid, hei);
			 
//			 destory();
			 requestPlayerList();
		 }
		 
		 override public function close():void
		 {
			super.close(); 
			destory();
		 }
		 
		 public function destory():void
		 {
			clearTimer();
			 
			 curIndex = 0;
			 IsClick = false;
			 IsMove = false;
			 
			 lastTweenlite && lastTweenlite.kill();
			 curTweenlite && curTweenlite.kill();
			
			 while(container.numElements > 0)
			 {
				 var group:Group = container.getElementAt(0) as Group;
				 removeRecommend(group);
			 }
			 
			 if(videoList != null)
			 	videoList.length = 0;
		 }
	}
}

import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.TextFormatAlign;

import component.RecommendSkinUnit;
import component.skin.button.RecommendButtonSkin;

import constant.NetConstant;

import events.GlobalServer;
import events.GlobalServerEvent;
import events.HttpEvent;

import net.HttpRequest;
import net.NetManager;

import org.flexlite.domUI.components.Button;
import org.flexlite.domUI.components.Group;
import org.flexlite.domUI.components.Label;
import org.flexlite.domUI.components.Rect;
import org.flexlite.domUI.components.UIAsset;

import vo.VideoInfo;

class RecommendUnit extends Group
{
	private var rePlay:Button;
	private var store:Button;
	private var share:Button;
	
	private var _videoInfo:VideoInfo;
	private var _IsVideo:Boolean;
	
	private var _scale:Number;
	public function RecommendUnit(videoInfo:VideoInfo, scale:Number= 1, IsVideo:Boolean=true):void
	{
		super();
		
		this.width = minW*scale;
		this.height = minH*scale;
		
		_videoInfo = videoInfo;
		_IsVideo = IsVideo;
		
		initUI(IsVideo);
	}
	
	public function get videoInfo():VideoInfo
	{
		return _videoInfo;
	}
	
	public function get IsVideo():Boolean
	{
		return _IsVideo;
	}
	
	/**收入收藏夹*/
	public function favorites():void
	{
		var url:String = NetConstant.VIDEOSHARE_HTMLURL+Main.main.playerParams.id;
		var name:String = Main.main.playerInfo.title;
		
		navigateToURL( new URLRequest("javascript:window.external.addFavorite('"+url+"', '"+name+"'')"), "_self");
	}
	
	private function playVideo(event:MouseEvent):void
	{
		GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_START));
		GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.RECOMMEND_PLAY, videoInfo.id));
	}
	
	private function clickHandler(event:MouseEvent):void
	{
		switch(event.target)
		{
			case rePlay:
				GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.PLAYER_SEEK_UPDATE, 0));
				GlobalServer.dispatchEvent(new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_START));
				break;
			case store:
//				favorites();
				break;
			case share:
				GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.VIDEO_SHARE_ADD));
				break;
		}
	}
	
	private function setTitle():void
	{
		if(label == null || videoInfo == null)return;
		
		var str:String = ""+videoInfo.title;
		var len:Number = int(this.width/13)-2;
		var s:String = "";
		for(var i:int=0;i<len;i++)
		{
			if(str.charAt(i) != "")
				s += str.charAt(i);
			else
				break;
		}
		
		if(str.charAt(len) != "")
			s += "...";
		
		label.text = s;
	}
	
	private var minW:Number=190;
	private var minH:Number = 108;
	public function scaleWH():void
	{
		var perw:Number = this.width / minW;
		var perh:Number = this.height / minH;
		var scale:Number = perw < perh ? perw : perh;
		
		if(rePlay != null)
		{
			rePlay.scaleX = scale;
			rePlay.scaleY = scale;
		}
		
		if(store != null)
		{
			store.top = 32*scale;
			store.scaleX = scale;
			store.scaleY = scale;
		}
		if(share != null)
		{
			share.left = 82*scale;
			share.scaleX = scale;
			share.scaleY = scale;
		}
		
		if(label != null)
		{
			label.width = this.width;
			label.bottom = 5*scale;
		}
		
		if(labelBack != null)
		{
			if(stage && stage.displayState == StageDisplayState.FULL_SCREEN)
				labelBack.height = 40;
			else
				labelBack.height = 25;
		}
		
		setTitle();
	}
	
	private var labelBack:Rect;
	private var label:Label;
	private var IsInit:Boolean=false;
	public function initUI(IsVideo:Boolean=true):void
	{
		IsInit = true;
		if(IsVideo)
		{
			var video:UIAsset = new UIAsset();
//			video.skinName = "";
			var re:Rect = new Rect();
			re.fillColor = 0xffffff;
//			re.width = 190;
//			re.height = 108;
			re.percentWidth = 100;
			re.percentHeight = 100;
			video.skinName = re;
			addElement(video);
			video.percentWidth = 100;
			video.percentHeight = 100;
			video.buttonMode = true;
			video.addEventListener(MouseEvent.CLICK, playVideo);
			
			NetManager.getInstance().loadImg(videoInfo.thumburl, function(bit:Bitmap):void{
				video.skinName = bit;
			});
			
			labelBack = new Rect();
			labelBack.bottom = 0;
			labelBack.fillColor = 0x0;
			labelBack.percentWidth = 100;
			labelBack.height = 25;
			addElement(labelBack);
			labelBack.alpha = 0.8;
			
			label = new Label();
			label.horizontalCenter = 0;
			label.bottom = 5;
			label.textColor = 0xffffff;
			label.width = this.width;
			label.textAlign = TextFormatAlign.CENTER;
			addElement(label);
			label.text = ""+videoInfo.title;
			
			setTitle();
		}
		else
		{
			 var bg:Rect = new Rect();
 			bg.fillColor = 0x282828;
// 			bg.width = 190;
//			bg.height = 108;
			bg.percentWidth = 100;
			bg.percentHeight = 100;
// 			bg.alpha = 0.6;
 			addElement(bg);
			
			var rect:Group = new Group();
			rect.horizontalCenter = 0;
			rect.verticalCenter = 0;
			addElement(rect);
			
			var gr:Group = new Group();
			rect.addElement(gr);
			
			rePlay = new Button();
			rePlay.skinName = new RecommendButtonSkin(new RecommendSkinUnit(replay_normal, "重播", 0xffffff), new RecommendSkinUnit(replay_hover, "重播", 0xb8d9f6));
			gr.addElement(rePlay);
			rePlay.addEventListener(MouseEvent.CLICK, clickHandler);
			
			store = new Button();
			store.top = 32;
			store.skinName = new RecommendButtonSkin(new RecommendSkinUnit(store_normal, "收藏", 0xffffff), new RecommendSkinUnit(store_hover, "收藏", 0xb8d9f6));
//			gr.addElement(store);
			store.addEventListener(MouseEvent.CLICK, clickHandler);
			
			share = new Button();
			share.left = 82;
			share.skinName = new RecommendButtonSkin(new RecommendSkinUnit(share_small_normal, "分享", 0xffffff), new RecommendSkinUnit(share_small_hover, "分享", 0xb8d9f6));
			rect.addElement(share);
			share.addEventListener(MouseEvent.CLICK, clickHandler);
			
			scaleWH();
		}
	}
	
	public function destory():void
	{
		this.removeAllElements();
	}
}

