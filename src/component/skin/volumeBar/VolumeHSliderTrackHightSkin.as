package component.skin.volumeBar
{
	import org.flexlite.domUI.skins.vector.HSliderTrackHighlightSkin;
	
	public class VolumeHSliderTrackHightSkin extends HSliderTrackHighlightSkin
	{
		public function VolumeHSliderTrackHightSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var offsetY:Number = Math.round(h*0.5-2);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			h=4;
			graphics.lineStyle();
			drawRoundRect(
				0, offsetY, w, h, 2,
				0x74BAC6, 1,
				verticalGradientMatrix(0, offsetY, w, h)); 
			if(w>5)
				drawLine(1,offsetY,w-1,offsetY,0x74BAC6);
		}
	}
}