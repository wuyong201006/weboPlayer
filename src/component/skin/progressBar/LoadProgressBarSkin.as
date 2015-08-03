package component.skin.progressBar
{
	import org.flexlite.domUI.skins.vector.ProgressBarSkin;
	
	public class LoadProgressBarSkin extends ProgressBarSkin
	{
		public function LoadProgressBarSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			track.skinName = LoadProgressBarTrackSkin;
			
			thumb.skinName = LoadProgressBarThumbSkin;
			
			labelDisplay.visible = false;
		}
	}
}