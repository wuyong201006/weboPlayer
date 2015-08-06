package view
{
	import com.greensock.easing.Quad;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import constant.NetConstant;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.HttpEvent;
	import events.PlayerEvent;
	
	import net.HttpRequest;
	import net.NetManager;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	
	public class VideoShare extends BasePanel
	{
		private var qrCode:UIAsset;
		private var copy:EditableText;
		public function VideoShare()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
//			requestQRcode();
		}
		
		private function clickClose(event:MouseEvent):void
		{
			close();
			
			GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.VIDEO_SHARE_REMOVE));
		}
		
		private function clickQQZone(event:MouseEvent):void
		{
			var playerInfo:Object = Main.main.playerInfo;
			//分享qq空间
			var pic:String = String(playerInfo.thumburl).replace(/\n/g, "");
			var title:String = playerInfo.title;//简述标题
			var summary:String = playerInfo.summary;
			var rLink:String = playerInfo.linksUrl;//网站链接
			var url:String = "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?title="+encodeURIComponent(title)+'&url='+encodeURIComponent(rLink)+'&summary='+encodeURIComponent(summary);
			NetManager.getInstance().sendURL(url);
		}
		
		private function clickHtml(event:MouseEvent):void
		{
			var htmlUrl:String = NetConstant.VIDEOSHARE_HTMLURL+Main.main.playerParams.id;
			copy.text = htmlUrl;
			
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, htmlUrl);
		}
		
		private function clickSwf(event:MouseEvent):void
		{
			var playerInfo:Object = Main.main.playerInfo;
			copy.text = playerInfo.swfUrl;
			
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, playerInfo.swfUrl);
		}
		
		private function createLabel(text:String, color:uint,  size:Number, parent:Group, bold:Boolean=false):Label
		{
			var label:Label = new Label();
			label.text = text;
			label.textColor = color;
			label.size = size;
			label.bold = bold;
			parent.addElement(label);
			
			return label;
		}
		
		private function createGroup(text:String, color:uint, size:Number):Group
		{
			var group:Group = new Group();
			
			var rect:Rect = new Rect();
			rect.fillColor = 0x86878C;
			rect.width = 90;
			rect.height = 26;
			group.addElement(rect);
			//			rect.alpha = 0.6;
			var label:Label = createLabel(text, color, size, group);
			label.horizontalCenter = 0;
			label.verticalCenter = 0;
			return group;
		}
		
		override protected function childrenCreated():void
		{
			var bg:Rect = new Rect();
			bg.fillColor = 0x000000;
			bg.width = 390;
			bg.height = 245;
			 bg.alpha = 0.6;
			addElement(bg);
			
			var close:Button = new Button();
			close.width = 11;
			close.height = 11;
			close.right = 5;
			close.top = 5;
			close.skinName = new popClose;
			addElement(close);
			close.addEventListener(MouseEvent.CLICK, clickClose);
			
			var group:Group = new Group();
			group.left = 60;
			group.top = 28;
			addElement(group);
			
			createLabel("分享到:", 0xcccccc, 14, group, true);
			
			var qqzone:Button = new Button();
			qqzone.left = 65;
			qqzone.verticalCenter = 0;
			qqzone.skinName = new qq;
			group.addElement(qqzone);
			qqzone.addEventListener(MouseEvent.CLICK, clickQQZone);
			
			var gro:Group = new Group();
			gro.left = 60;
			gro.top = 68;
			addElement(gro);
			
			createLabel("复  制:", 0xcccccc, 14, gro, true);
			
			var rect:Rect = new Rect();
			rect.fillColor = 0xffffff;
			rect.width = 215;
			rect.height = 26;
//			rect.alpha = 0.6;
			rect.left = 60;
			rect.top = -5;
			gro.addElement(rect);
			
			copy = new EditableText();
			copy.left = 62;
			copy.top = -1;
			copy.width = 212;
			copy.text = "点击下方按钮复制对应分享链接地址";
			copy.textColor = 0xcccccc;
			copy.size = 13;
			copy.multiline = false;
			gro.addElement(copy);
			
			var html:Button = new Button();
			html.left = 60;
			html.top = 25;
			html.skinName = createGroup("复制HTML代码", 0xffffff, 12);
			gro.addElement(html);
			html.addEventListener(MouseEvent.CLICK, clickHtml);
			
			var swf:Button = new Button();
			swf.left = 155;
			swf.top = 25;
			swf.skinName = createGroup("复制播放器地址", 0xffffff, 12);
			gro.addElement(swf);
			swf.addEventListener(MouseEvent.CLICK, clickSwf);
			
			var g:Group = new Group();
			g.left = 60;
			g.top = 128;
			addElement(g);
			
			
			createLabel("二维码:", 0xcccccc, 14, g, true);
			
			qrCode = new UIAsset();
			qrCode.width = 100;
			qrCode.height = 100;
			qrCode.left = 60;
			qrCode.top = -5;
			g.addElement(qrCode);
			
			var qrTxt:Label = createLabel("扫描左侧二维码用手机继续观看", 0xcccccc, 14, g, true);
			qrTxt.width = 110;
			qrTxt.left = 160;
			qrTxt.verticalCenter = 0;
		}
		
		override public function open():void
		{
			super.open();
			
			NetManager.getInstance().loadImg(NetConstant.QRCODEURL, function(bit:Bitmap):void{
				qrCode.skinName = bit;
			});
		}
		
		override public function close():void
		{
			super.close();	
		}
	}
}