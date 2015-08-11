package view
{
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.system.ImageDecodingPolicy;
	
	import constant.NetConstant;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.HttpEvent;
	
	import net.HttpRequest;
	import net.NetManager;
	
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 *	广告图 
	 */
	public class AdvertChart extends BasePanel
	{
		private var img:UIAsset;
		
		private var _data:Object;//{image:url, link:url}
		public function AdvertChart()
		{
			super();
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		private function clickHandler(event:MouseEvent):void
		{
			if(data != null)
				NetManager.getInstance().sendURL(data.link);
		}
		
		private var _scale:Number;
		public function setWH(scale:Number):void
		{
			_scale = scale;
			
			if(img != null)
			{
				img.scaleX = scale;
				img.scaleY = scale;
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var back:UIAsset = new UIAsset();
			back.skinName = new popBack;
//			addElement(back);
			
			img = new UIAsset();
			img.horizontalCenter = 0;
			img.verticalCenter = 0;
			img.skinName = new pop();
			addElement(img);
			img.addEventListener(MouseEvent.CLICK, clickHandler);
			img.buttonMode = true;
			
			var http:HttpRequest = new HttpRequest();
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, function(event:HttpEvent):void{
				try
				{
					var loader:URLLoader = event.data as URLLoader;
					var object:Object = JSON.parse(String(loader.data));
					data = {image:object.spread.image, link:object.spread.link};
					NetManager.getInstance().loadImg(data.image,
						function(bit:Bitmap):void{
						img.skinName = bit;},
						function():void{
							GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.WEBOPLAYER_LOG, "推荐广告无效数据"))}
					);
				}
				catch(e:ErrorEvent)
				{
					
				}
			});
			http.connect(NetConstant.ADVERTCHARTURL);
			
			if(_scale > 0)
				setWH(_scale);
		}
		
		override public function open():void
		{
			super.open();
		}
		
		override public function close():void
		{
			super.close();	
		}
	}
}