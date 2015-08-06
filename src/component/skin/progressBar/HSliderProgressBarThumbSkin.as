package component.skin.progressBar
{
	import org.flexlite.domUI.skins.vector.ProgressBarThumbSkin;
	
	public class HSliderProgressBarThumbSkin extends ProgressBarThumbSkin
	{
		public function HSliderProgressBarThumbSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			h= 4;
			graphics.clear();
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			graphics.lineStyle();
			drawRoundRect(
				0, 0, w, h, 2,
				0x86878C, 1,
				verticalGradientMatrix(0, 0, w, h)); 
			if(w>5)
				drawLine(1,0,w-1,0,0x86878C);
		}
	}
}