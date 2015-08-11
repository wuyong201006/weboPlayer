package view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import component.skin.progressBar.LoadProgressBarSkin;
	
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 *	加载进度条 
	 */
	public class LoadingBar extends BasePanel
	{
		private var progressBar:ProgressBar;
		private var turn:UIAsset;
		private var tg:Group;
		
		private var tweenLite:TweenLite;
		public function LoadingBar()
		{
			super();
		}
		
		public function updateProgress(curValue:Number, maxValue:Number):void
		{
			progressBar.value = curValue/maxValue*100;
			if(!IsTurn)
			{
				IsTurn = true;
				startTurn();
			}
		}
		
		private var IsTurn:Boolean = false;
		private function startTurn():void
		{
			
			if(tg.rotation > 0)
				tg.rotation = 0;
			
			tweenLite = TweenLite.to(tg, 0.5, {rotation:360, ease:Linear.easeNone, onComplete:startTurn});
		}
		
		private function stopTurn():void
		{
			tweenLite && tweenLite.kill();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var back:UIAsset = new UIAsset();
			back.skinName = new loadBack;
			addElement(back);
			
			var group:Group = new Group();
			group.verticalCenter = 0;
			group.horizontalCenter = 0;
			addElement(group);
			
			var img:UIAsset = new UIAsset();
			img.skinName = new loadImg;
			group.addElement(img);
			
			var g:Group = new Group();
			g.top = 80;
			group.addElement(g);
			
			progressBar = new ProgressBar();
			progressBar.height = 10;
			progressBar.width = 210;
			progressBar.skinName = LoadProgressBarSkin;
			g.addElement(progressBar);
			
			tg = new Group();
			tg.left = 222;
			tg.top = 5;
			g.addElement(tg);
			
			turn = new UIAsset();
			turn.skinName = new loadTurn;
			turn.left = -13;
			turn.top = -13;
			tg.addElement(turn);
//			startTurn();
		}
		
		override public function open():void
		{
			super.open();
		}
		
		override public function close():void
		{
			super.close();
			destory();
		}
		
		public function destory():void
		{
			stopTurn();
		}
	}
}