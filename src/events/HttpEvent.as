package events
{
	import flash.events.Event;

	public class HttpEvent extends Event
	{
		private var _data:Object;
		public static var HTTPSERVICE_START:String = "http_service_start";//开始
		public static var HTTPSERVICE_CONN:String = "http_service_conn";//状态
		public static var HTTPSERVICE_PROGRESS:String = "httpservice_progress";//进度
		public static var HTTPSERVICE_FAIL:String = "http_service_fail";//失败
		
		public static var HTTPDATA_SUCCESS:String = "httpdata_success";
		public function HttpEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
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