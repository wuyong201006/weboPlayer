package component
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;

	public class RecommendSkinUnit extends Group
	{
		public function RecommendSkinUnit(cla:Class, value:String, color:uint, size:Number=14)
		{
			var img:UIAsset = new UIAsset();
			img.skinName = new cla;
			addElement(img);
			
			var label:Label = new Label();
			label.left = 28;
			label.textColor = color;
			label.size = size;
			label.text = value;
			addElement(label);
		}
	}
}