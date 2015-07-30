package view
{
	import flash.display.Bitmap;
	
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 *	加载进度条 
	 */
	public class LoadingBar extends Group
	{
		private var progressBar:ProgressBar;
		private var turn:UIAsset;
		public function LoadingBar()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		private var group:Group
		override protected function createChildren():void
		{
			super.createChildren();
			
			var back:UIAsset = new UIAsset();
			back.skinName = new loadBack;
			addElement(back);
			
			group = new Group();
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
//			progressBar.skinName =
			progressBar.width = 210;
			g.addElement(progressBar);
			
			turn = new UIAsset();
			turn.skinName = new loadTurn;
			turn.left = 220;
			g.addElement(turn);
		}
	}
}