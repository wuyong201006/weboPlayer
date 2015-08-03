package component.skin.button
{
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.ButtonSkin;

	public class RecommendButtonSkin extends ButtonSkin
	{
		private var bg:UIAsset;
		
		private var _normal:Object;
		private var _hover:Object;
		public function RecommendButtonSkin(normal:Object, hover:Object)
		{
			_normal = normal;
			_hover = hover;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			bg = new UIAsset();
			bg.skinName = _normal;
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
					bg.skinName = _normal;
					break;
				case "over":
					bg.skinName = _hover;
					break;
			}
		}
	}
}