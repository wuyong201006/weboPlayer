package component.slider
{
	import org.flexlite.domUI.components.HSlider;
	import org.flexlite.domUI.components.ProgressBar;
	
	public class PlayerHSlider extends HSlider
	{
		public function PlayerHSlider()
		{
			super();
		}
		
		/**
		 *	加载进度 
		 */
		public var progress:ProgressBar;
		 public function set progressValue(value:Number):void
		{
			progress.value = value;
		}
		 
//		 override protected function updateSkinDisplayList():void
//		 {
//			 super.updateDisplayList(width, height);
//		 }
	}
}