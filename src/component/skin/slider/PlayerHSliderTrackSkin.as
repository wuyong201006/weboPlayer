package component.skin.slider
{
	import org.flexlite.domUI.skins.vector.HSliderTrackSkin;
	
	public class PlayerHSliderTrackSkin extends HSliderTrackSkin
	{
		public function PlayerHSliderTrackSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var offsetY:Number = Math.round(h*0.5-2);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			h=4;
			graphics.lineStyle();
			drawRoundRect(
				0, offsetY, w, h, 1,
				0x656667, 1,
				verticalGradientMatrix(0, offsetY, w, h)); 
			if(w>4)
				drawLine(1,offsetY,w-1,offsetY,0x656667);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}