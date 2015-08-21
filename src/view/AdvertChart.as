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
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 *	广告图 
	 */
	public class AdvertChart extends BasePanel
	{
		private var img:UIAsset;
		
		private var _data:Object;//{image:url, link:url}
		private var _IsAdvert:Boolean=false;
		public function AdvertChart()
		{
			super();
		}
		
		public function get IsAdvert():Boolean
		{
			return _IsAdvert;
		}

		public function set IsAdvert(value:Boolean):void
		{
			_IsAdvert = value;
			
			closeBtn.visible = value;
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
			if(IsAdvert)
			{
				if(data != null)
					NetManager.getInstance().sendURL(data.link);
			}
			else
			{
				GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_PAUSE));
			}
		}
		
		private var _scale:Number;
		public function setWH(scale:Number):void
		{
			_scale = scale;
			
			if(img != null)
			{
				img.scaleX = scale;
				img.scaleY = scale;
				
				if(IsAdvert)
				{
					graphics.clear();
					graphics.lineStyle(1, 0xffffff);
					graphics.drawRect(-1, -1, img.width+2, img.height+2);
				}
			}
			
//			if(closeBtn != null)
//			{
//				closeBtn.scaleX = scale;
//				closeBtn.scaleY = scale;
//			}
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
//			img.skinName = new pop();
			addElement(img);
			img.addEventListener(MouseEvent.CLICK, clickHandler);
			img.buttonMode = true;
			
			closeBtn = new UIAsset();
			closeBtn.right = 5;
			closeBtn.top = 5;
			closeBtn.skinName = new adverchat_close;
			addElement(closeBtn);
			closeBtn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{close()});
			closeBtn.buttonMode = true;
			closeBtn.visible = false;
				
			var http:HttpRequest = new HttpRequest();
			http.addEventListener(HttpEvent.HTTPSERVICE_FAIL, function(event:HttpEvent):void{
				IsAdvert = false;
				img.skinName = new play_center;
			});
			http.addEventListener(HttpEvent.HTTPDATA_SUCCESS, function(event:HttpEvent):void{
				var loader:URLLoader = event.data as URLLoader;
				if(loader.data == undefined || loader.data == "")
				{
					IsAdvert = false;
					GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.WEBOPLAYER_LOG, "推荐广告无效数据"));
					img.skinName = new play_center;
					return;					
				}
				var object:Object = JSON.parse(String(loader.data));
				if(object.code != null && object.code  == 1)
				{
					IsAdvert = false;
					img.skinName = new play_center;
					return;
				}
				data = {image:object.spread.image, link:object.spread.link};
				NetManager.getInstance().loadImg(data.image,
					function(bit:Bitmap):void{
					IsAdvert = true;
					img.skinName = bit;
					},
					function():void{
						IsAdvert = false;
						GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.WEBOPLAYER_LOG, "推荐广告无效数据"))
						img.skinName = new play_center;
					}
				);
			});
			http.connect(NetConstant.ADVERTCHARTURL);
			
			if(_scale > 0)
				setWH(_scale);
		}
		
		private var closeBtn:UIAsset;
		
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