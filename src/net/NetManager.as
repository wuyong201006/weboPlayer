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
		private var _errorCall:Function;
		
		private var _IsComplete:Boolean=true;
		private var cacheList:Array;
		private static var _instance:NetManager;
		public function NetManager()
		{
			cacheList = new Array();
		}
		
		public static function getInstance():NetManager
		{
			if(_instance == null)
				_instance = new NetManager();
			
			return _instance;
		}
		
		public function get IsComplete():Boolean
		{
			return _IsComplete;
		}
		
		public function set IsComplete(value:Boolean):void
		{
			_IsComplete = value;
			
			if(cacheList.length > 0)
			{
				var data:Object = cacheList.shift();
				loadImg(data.url, data.callBack, data.errorBack);
			}
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
		public  function loadImg(url:String, callBack:Function, errorBack:Function=null):void
		{
			if(!IsComplete)
			{
				cacheList.push({url:url, callBack:callBack, errorBack:errorBack});
				return;
			}
			
			IsComplete = false;
			
			_loadCall = callBack;
			_errorCall = errorBack;
			
			var http:HttpRequest = new HttpRequest(URLRequestMethod.GET, URLLoaderDataFormat.BINARY);
			http.addEventListener(HttpEvent.HTTPSERVICE_FAIL, serviceFail);
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, onSendComplete);
			http.connect(url);
		}
		
		private function serviceFail(event:HttpEvent):void
		{
			if(_errorCall != null)
				_errorCall.call();
			
			IsComplete = true;
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
			if(_loadCall != null)
				_loadCall.call(null, event.target.loader.content);
			
			IsComplete = true;
		}
	}
}