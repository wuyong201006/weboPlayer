package component.skin
{
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	
	public class ShareBigButtonSkin extends ButtonSkin
	{
		private var bg:UIAsset;
		public function ShareBigButtonSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			bg = new UIAsset();
			bg.skinName = new share_big_normal;
			addElement(bg);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			graphics.clear();
			switch(currentState)
			{
				case "up":
				case "disabled":
				case "down":
					bg.skinName = new share_big_normal;
					break;
				case "over":
					bg.skinName = new share_big_hover;
					break;
			}
		}
	}
}