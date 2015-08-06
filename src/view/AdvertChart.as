package view
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 *	广告图 
	 */
	public class AdvertChart extends BasePanel
	{
		public function AdvertChart()
		{
			super();
		}
		
		private function loadImg():void
		{
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var back:UIAsset = new UIAsset();
			back.skinName = new popBack;
			addElement(back);
			
			var img:UIAsset = new UIAsset();
			img.horizontalCenter = 0;
			img.verticalCenter = 0;
			img.skinName = new pop();
			addElement(img);
		}
		
		override public function open():void
		{
			super.open();
		}
		
		override public function close():void
		{
			super.close();	
		}
	}
}