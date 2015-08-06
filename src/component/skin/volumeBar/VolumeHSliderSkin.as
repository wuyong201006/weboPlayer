package component.skin.volumeBar
{
	import org.flexlite.domUI.skins.vector.HSliderSkin;
	
	public class VolumeHSliderSkin extends HSliderSkin
	{
		public function VolumeHSliderSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			track.skinName = VolumeHSliderTrackSkin;
			
			trackHighlight.skinName = VolumeHSliderTrackHightSkin;
			
			thumb.skinName = new volumeThumb;
			thumb.top = 2;
			thumb.bottom = 0;
		}
	}
}