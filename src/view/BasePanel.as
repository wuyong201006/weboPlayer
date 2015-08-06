package view
{
	import org.flexlite.domUI.components.Group;
	
	public class BasePanel extends Group
	{
		public function BasePanel()
		{
			super();
		}
		
		public function open():void
		{
			addToScene();
			this.visible = true;			
		}
		
		public function close():void
		{
			removeToScene();
			
			this.visible = false;	
		}
		
		private function addToScene():void
		{
			if(this is LoadingBar || this is Recommend)
			{
				Main.main.frontContainer.addElement(this);
			}
			else
			{
				Main.main.behindContainer.addElement(this);
			}
		}
		
		private function removeToScene():void
		{
			if(Main.main.frontContainer.getElementIndex(this) < 0)
				return;
			if(this is LoadingBar || this is Recommend)
			{
				Main.main.frontContainer.removeElement(this);
			}
			else
			{
				Main.main.behindContainer.removeElement(this);
			}
		}
	}
}