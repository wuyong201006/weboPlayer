package component.skin.button
{
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	
	public class PlayButtonSkin extends ButtonSkin
	{
		private var bg:UIAsset;
		public function PlayButtonSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			bg = new UIAsset();
			bg.skinName = new play_normal;
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
					bg.skinName = new play_normal;
					break;
				case "over":
					bg.skinName = new play_hover;
					break;
			}
		}
	}
}