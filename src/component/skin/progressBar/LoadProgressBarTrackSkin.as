package component.skin.progressBar
{
	import org.flexlite.domUI.skins.vector.ProgressBarTrackSkin;
	
	public class LoadProgressBarTrackSkin extends ProgressBarTrackSkin
	{
		public function LoadProgressBarTrackSkin()
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
				0xB8D9F6, 1,
				verticalGradientMatrix(0, 0, w, h)); 
			if(w>4)
				drawLine(1,0,w-1,0,0xB8D9F6);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}