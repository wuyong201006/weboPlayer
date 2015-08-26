package component.slider
{
	import org.flexlite.domUI.components.HSlider;
	import org.flexlite.domUI.components.ProgressBar;
	
	public class PlayerHSlider extends HSlider
	{
		/**
		 *	加载进度 
		 */
		public var progress:ProgressBar;
		
		/**播放到结束**/
		private var _IsFinish:Boolean=false;
		public function PlayerHSlider()
		{
			super();
		}
		
		

		public function get IsFinish():Boolean
		{
			return _IsFinish;
		}

		public function set IsFinish(value:Boolean):void
		{
			_IsFinish = value;
		}

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
		 
		 public function set setEnabled(value:Boolean):void
		 {
			 IsComplete = !value;
			 this.mouseEnabled = this.mouseChildren = value;
		 }
		 
		 /**
		 *	进度条到最后了 
		 */
		 private var _IsComplete:Boolean=false
		 override protected function setValue(value:Number):void
		 {
			 if(IsComplete)return;
			 if(IsFinish && value == maximum)
			 {
				setEnabled = false; 
			 }
			 super.setValue(value);
		 }
//		 override protected function updateSkinDisplayList():void
//		 {
//			 super.updateDisplayList(width, height);
//		 }
	}
}