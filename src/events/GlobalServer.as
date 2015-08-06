package events
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 *	 
	 */
	public class GlobalServer extends Object
	{
		private static var dictionary:Dictionary = new Dictionary();
		public function GlobalServer()
		{
			return;
		}
		
		public static function dispatchEvent(event:Event):void
		{
			var listener:Object = null;
			if(GlobalServer.dictionary[event.type])
			{
				for(listener in GlobalServer.dictionary[event.type])
				{
					listener.call(null, event);
				}
			}
		}
		
		public static function addEventListener(type:String, listener:Function):void
		{
			if(!GlobalServer.dictionary[type])
			{
				GlobalServer.dictionary[type] = new Dictionary();
			}
			
			GlobalServer.dictionary[type][listener] = listener;
		}
		
		public static function hasAddListener(type:String, listener:Function):Boolean
		{
			if (GlobalServer.dictionary[type])
			{
			}
			
			return GlobalServer.dictionary[type][listener];
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			delete GlobalServer.dictionary[type][listener];
		}
	}
}