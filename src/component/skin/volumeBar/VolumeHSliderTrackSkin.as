package component.skin.volumeBar
{
	import org.flexlite.domUI.skins.vector.HSliderTrackSkin;
	
	public class VolumeHSliderTrackSkin extends HSliderTrackSkin
	{
		public function VolumeHSliderTrackSkin()
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
				0, offsetY, w, h, 2,
				0x363543, 1,
				verticalGradientMatrix(0, offsetY, w, h)); 
			if(w>4)
				drawLine(1,offsetY,w-1,offsetY,0x363543);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}