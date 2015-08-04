package events
{
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		private var _data:Object;
		
		public static var NET_STATUS:String = "net_status";
		
		public static var PLAYER_UPDATE:String = "player_update";
		public static var VOLUME_UPDATE:String = "volume_update";
		public static var MEDIA_DURATION_UPDATE:String = "media_duration_update";
		public static var PLAYER_BUFFER_UPDATE:String = "player_buffer_update";
		public static var PLAYER_BUFFER_FULL:String = "player_buffer_full";
		
		public static var CONTROLLBAR_UPDATE:String = "controllBar_update";
		public static var CONTROLLBAR_PLAY:String = "controllbar_play";
		public static var VIDEO_SHARE_ADD:String = "video_share_add";
		public static var VIDEO_SHARE_REMOVE:String = "video_share_remove";
		
		public function PlayerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			
			super(type, bubbles, cancelable);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}