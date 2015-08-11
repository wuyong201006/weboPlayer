package view
{
	import org.flexlite.domUI.components.UIAsset;

	public class WaterMark extends BasePanel
	{
		private var _minW:Number = 141;
		private var _minH:Number = 34;
		
		private var mark:UIAsset;
		public function WaterMark()
		{
			super();
		}
		
		public function get minW():Number
		{
			return _minW;
		}
		
		public function setWH(scale:Number):void
		{
			if(mark != null)
			{
				mark.scaleX = scale;
				mark.scaleY = scale;				
			}
		}
		
		override protected function createChildren():void
		{
			mark = new UIAsset();
			mark.skinName = new watermark;
			addElement(mark);
			
//			this.width = mark.width;
//			this.height = mark.height;
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