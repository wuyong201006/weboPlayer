package component.skin.slider
{
	import component.skin.progressBar.HSliderProgressBarSkin;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.HSliderSkin;
	import org.flexlite.domUI.skins.vector.HSliderTrackHighlightSkin;
	import org.flexlite.domUI.skins.vector.HSliderTrackSkin;
	import org.flexlite.domUI.skins.vector.SliderThumbSkin;
	
	public class PlayerHSliderSkin extends HSliderSkin
	{
		
		public function PlayerHSliderSkin()
		{
			super();
		}
		
		public var progress:ProgressBar;
		override protected function createChildren():void
		{
			super.createChildren();
			
			track.skinName = PlayerHSliderTrackSkin;
			
			progress = new ProgressBar();
//			progress.top = 0;
//			progress.bottom = 0;
			progress.verticalCenter = 0;
			progress.left = 0;
			progress.right = 0;
			progress.minWidth = 33;
			progress.width = 100;
			progress.height = 4;
			progress.tabEnabled = false;
			progress.skinName = HSliderProgressBarSkin;
			addElementAt(progress, getElementIndex(trackHighlight));
			
			trackHighlight.skinName = PlayerHSliderTrackHighlightSkin;
			
			thumb.skinName = SliderThumbSkin;
		}
		
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w,h);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}