package net
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	import events.HttpEvent;

	public class NetManager
	{
		/**加载图片传入返回函数*/
		private var _loadCall:Function;
		private static var _instance:NetManager;
		public function NetManager()
		{
		}
		
		public static function getInstance():NetManager
		{
			if(_instance == null)
				_instance = new NetManager();
			
			return _instance;
		}
		/**
		 *	@url 跳转地址 
		 */
		public  function sendURL(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request);
		}
		
		/**
		 *	加载图片 
		 */
		public  function loadImg(url:String, callBack:Function):void
		{
			_loadCall = callBack;
			
			var http:HttpRequest = new HttpRequest(URLRequestMethod.GET, URLLoaderDataFormat.BINARY);
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, onSendComplete);
			http.connect(url);
		}
		
		private  function onSendComplete(event:HttpEvent):void
		{
			var urlLoader:URLLoader = event.data as URLLoader;
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			load.loadBytes(urlLoader.data);
		}
		
		private  function complete(event:Event):void
		{
			if(_loadCall)
				_loadCall.call(null, event.target.loader.content);
		}
	}
}