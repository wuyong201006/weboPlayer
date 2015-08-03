package component.skin.progressBar
{
	import org.flexlite.domUI.skins.vector.ProgressBarThumbSkin;
	
	public class LoadProgressBarThumbSkin extends ProgressBarThumbSkin
	{
		public function LoadProgressBarThumbSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRoundRect(0,0,w,h, 5);
			graphics.endFill();
			graphics.lineStyle();
			drawRoundRect(
				0, 0, w, h, 5,
				0x0066CF, 1,
				verticalGradientMatrix(0, 0, w, h)); 
//			if(w>5)
//				drawLine(1,0,w-1,0,0x0066CF);
		}
		
	}
}