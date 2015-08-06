package view
{
	import org.flexlite.domUI.components.Group;
	
	public class BasePanel extends Group
	{
		private var _panel_open_status:Boolean=false;
		public function BasePanel()
		{
			super();
		}
		
		public function get panel_open_status():Boolean
		{
			return _panel_open_status;
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
			_panel_open_status = true;
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
			_panel_open_status = false;
			
			if(this is LoadingBar || this is Recommend)
			{
				if(Main.main.frontContainer.getElementIndex(this) >= 0)
					Main.main.frontContainer.removeElement(this);
			}
			else
			{
				if(Main.main.behindContainer.getElementIndex(this) >= 0)
					Main.main.behindContainer.removeElement(this);
			}
		}
	}
}