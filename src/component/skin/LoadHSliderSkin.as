package component.skin
{
	import org.flexlite.domUI.skins.vector.HSliderSkin;
	
	public class LoadHSliderSkin extends HSliderSkin
	{
		public function LoadHSliderSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			track.skinName = "";
		}
	}
}