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

		 public function get IsComplete():Boolean
		 {
			 return _IsComplete;
		 }

		 public function set IsComplete(value:Boolean):void
		 {
			 _IsComplete = value;
		 }

		 public function set progressValue(value:Number):void
		{
			progress.value = value;
		}
		 
		 /**
		 *	进度条到最后了 
		 */
		 private var _IsComplete:Boolean=false
		 override protected function setValue(value:Number):void
		 {
			 if(IsComplete)return;
			 
			 super.setValue(value);
		 }
//		 override protected function updateSkinDisplayList():void
//		 {
//			 super.updateDisplayList(width, height);
//		 }
	}
}