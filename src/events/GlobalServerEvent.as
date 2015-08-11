package events
{
	import flash.events.Event;
	
	public class GlobalServerEvent extends Event
	{
		private var _data:Object;
		public static var PLAYER_PLAY_START:String = "player_play_start";
		public static var PLAYER_PLAY_STOP:String = "player_play_stop";
		public static var PLAYER_SEEK_UPDATE:String = "player_seek_update";
		
		public static var VIDEO_SHARE_ADD:String = "video_share_add";
		public static var VIDEO_SHARE_REMOVE:String = "video_share_remove";
		
		public static var RECOMMEND_PLAY:String="recommend_play";
		
		public static var PLAYER_PLAY_PAUSE:String = "player_play_pause";
		
		public static var WEBOPLAYER_LOG:String = "weboplayer_log";
		public function GlobalServerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}