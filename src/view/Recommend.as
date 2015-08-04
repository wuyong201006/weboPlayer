package view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import component.skin.button.PlayerButtonSkin;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	
	import vo.VideoInfo;
	
	/**
	 *	推荐页 
	 */
	public class Recommend extends Group
	{
		private var container:Group;
		
		private var preBtn:Button;
		private var nextBtn:Button;
		
		private var lastIndex:int=-1;
		private var curIndex:int=0;
		
		private var minValue:int=1;
		private var maxValue:int=5;
		
		private var lastRecommend:Group;
		private var curRecommend:Group;
		
		private var _videoList:Vector.<VideoInfo>;
		private var timer:Timer;
		
		private var delayTime:int;
		
		private var _scale:Number=1;
		public function Recommend()
		{
			super();
			
			this.width = minWidth;
			this.height = minHeight;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			createTimer();
			
			var test:Vector.<VideoInfo> = new Vector.<VideoInfo>();
			for(var i:int=0;i<7;i++)
			{
				test.push(new VideoInfo());
			}
			
			videoList = test;
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
			timer.start();
		}
		
		private function createTimer():void
		{
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			delayTime++;
			
			if(delayTime >= 4)
			{
				delayTime = 0;
				curIndex++;
				if(curIndex >= maxValue)
					curIndex = 0;
				start();
			}
		}
		
		private var IsClick:Boolean=false;
		private function clickHandler(event:MouseEvent):void
		{
			delayTime = 0;
			if(event.target == preBtn)
				curIndex --;
			else
				curIndex++;
				
			if(curIndex <= minValue)
				curIndex = minValue;
			
			if(curIndex > maxValue-1)
				curIndex = maxValue-1;
			
			if(curIndex == lastIndex)return;
			
			IsClick = true;
			start();
		}
		private function start():void
		{
			if(IsMove)return;
			IsMove = true;
			
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
				IsLeft = curIndex > lastIndex;
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
				TweenLite.to(lastRecommend,  2, {x:IsLeft ? -wid : wid, ease:Linear.ease, onComplete:function():void{
					removeRecommend(lastRecommend);
				}});
			}
			
			TweenLite.to(curRecommend, 2, {x:0, ease:Linear.ease, onComplete:function():void{
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
		
		private var minWidth:Number = 482;
		private var minHeight:Number = 271;
		public function scaleWH(width:Number, height:Number):void
		{
			if(width < stage.fullScreenWidth)
				this.width = minWidth;
			else
				this.width = width;
				
			if(height < stage.fullScreenHeight)
				this.height = minHeight;
			else
				this.height = height;
			
			var perw:Number = width / minWidth;
			var perh:Number = height / minHeight;
			var scale:Number = perw < perh ? perw : perh;
			
			_scale = scale;
			
			if(bg != null)
			{
				bg.width = 482*scale;				
				bg.height = 271*scale;
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
		override protected function createChildren():void
		{
			super.createChildren();
			
			bg = new Rect();
			bg.fillColor = 0x000000;
			bg.width = /*percentWidth*/482*scale;
			bg.height = 271*scale;
//			bg.alpha = 0.6;
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
		}
		
		 protected function removeRecommend(group:Group):void
		 {
			 if(container.getElementIndex(group) >= 0 )
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
		 }
		 
		 public function destory():void
		 {
			 timer && timer.stop();
		 }
	}
}

import flash.events.MouseEvent;

import component.RecommendSkinUnit;
import component.skin.button.RecommendButtonSkin;

import events.GlobalServer;
import events.GlobalServerEvent;

import org.flexlite.domUI.components.Button;
import org.flexlite.domUI.components.Group;
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
		
		this.width = minWidth*scale;
		this.height = minHeight*scale;
		
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
	
	private function playVideo(event:MouseEvent):void
	{
		
	}
	
	private function clickHandler(event:MouseEvent):void
	{
		switch(event.target)
		{
			case rePlay:
				GlobalServer.dispatchEvent(new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_START));
				GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.PLAYER_SEEK_UPDATE, 0));
				break;
			case store:
				break;
			case share:
				break;
		}
	}
	
	private var minWidth:Number=190;
	private var minHeight:Number = 108;
	public function scaleWH():void
	{
		var perw:Number = this.width / minWidth;
		var perh:Number = this.height / minHeight;
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
	}
	
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
			video.addEventListener(MouseEvent.CLICK, playVideo);
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

