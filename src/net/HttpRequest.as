package net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import events.HttpEvent;

	public class HttpRequest extends EventDispatcher
	{
		private var loader:URLLoader;
		private var _requestMethod:String;
		private var _dataFormat:String;
		public function HttpRequest(requestMethod:String=URLRequestMethod.GET, dataFormat:String=URLLoaderDataFormat.TEXT)
		{
			_requestMethod = requestMethod;
			_dataFormat = dataFormat;
		}
		
		public function connect(url:String, data:Object=null):void
		{
			var request:URLRequest = new URLRequest(url);
			request.data = data;
			request.method = _requestMethod;
			loader = new URLLoader();
			loader.dataFormat = _dataFormat;
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			loader.addEventListener(ProgressEvent.PROGRESS, progress);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			
			try
			{
				loader.load(request);
			} 
			catch(error:Error) 
			{
				trace(error);	
			}
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			dispatchEvent( new HttpEvent(HttpEvent.HTTPSERVICE_FAIL, "IOError"));
		}
		
		private function securityError(event:SecurityErrorEvent):void
		{
			dispatchEvent( new HttpEvent(HttpEvent.HTTPSERVICE_FAIL, "SecurityError"));
		}
		
		private function openHandler(event:Event):void
		{
			dispatchEvent( new HttpEvent(HttpEvent.HTTPSERVICE_START) );
		}
		
		private function progress(event:ProgressEvent):void
		{
			dispatchEvent( new HttpEvent(HttpEvent.HTTPSERVICE_PROGRESS, {bytesLoaded:event.bytesLoaded, bytesTotal:event.bytesTotal}));
		}
		
		private function httpStatus(event:HTTPStatusEvent):void
		{
			dispatchEvent( new HttpEvent(HttpEvent.HTTPSERVICE_CONN, event.status));
		}
		
		private function completeHandler(event:Event):void
		{
			dispatchEvent( new HttpEvent(HttpEvent.HTTPDATA_SUCCESS, loader));
		}
	}
}