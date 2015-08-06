package view
{
	import org.flexlite.domUI.components.UIAsset;

	public class WaterMark extends BasePanel
	{
		private var mark:UIAsset;
		public function WaterMark()
		{
			super();
		}
		
		public function setWH(width:Number, height:Number):void
		{
			
		}
		
		override protected function createChildren():void
		{
			mark = new UIAsset();
			mark.skinName = new watermark;
			addElement(mark);
			
			this.width = mark.width;
			this.height = mark.height;
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