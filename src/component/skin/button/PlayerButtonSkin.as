package component.skin.button
{
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	
	/**
	 *	播放器按钮基类 
	 */
	public class PlayerButtonSkin extends ButtonSkin
	{
		private var bg:UIAsset;
		private var _normal:Class;
		private var _hover:Class;
		public function PlayerButtonSkin(normal:Class, hover:Class)
		{
			super();
			_normal = normal;
			_hover = hover;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			bg = new UIAsset();
			bg.skinName = new _normal;
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
					bg.skinName = new _normal;
					break;
				case "over":
					bg.skinName = new _hover;
					break;
			}
		}
	}
}