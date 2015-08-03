package component.skin.progressBar
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.ProgressBarSkin;
	import org.flexlite.domUI.skins.vector.ProgressBarThumbSkin;
	import org.flexlite.domUI.skins.vector.ProgressBarTrackSkin;
	
	public class HSliderProgressBarSkin extends ProgressBarSkin
	{
		public function HSliderProgressBarSkin()
		{
			super();
			this.minWidth = 4;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
//			track = new UIAsset();
//			track.skinName = ProgressBarTrackSkin;
//			track.left = 0;
//			track.right = 0;
//			addElement(track);
//			removeElement(track);
			track.visible = false;
			
			thumb.skinName = HSliderProgressBarThumbSkin;
			
			labelDisplay.visible = false;
		}
	}
}