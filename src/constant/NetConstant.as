package constant
{
	public class NetConstant
	{
		//数字类型的id值（专辑）接口：
		public static const PLAYER_REQUEST_TYPE_DIGITAL_URL:String = "http://saasapi.newsapp.cibntv.net/share/getbyid.php?topicid=";
		//字符串类型的id值（电视）接口：
		public static const PLAYER_REQUEST_TYPE_STRING_URL:String = "http://web.newsapp.cibntv.net/share/search.php?action=guid&guid=";
		//环球视讯跳转
		public static const GLOABLPLAYERURL:String = "http://web.newsapp.cibntv.net/app/intro/";
		//二维码
		public static const QRCODEURL:String = "http://web.newsapp.cibntv.net/share/qrcode.php?size=4&url=";
		//推荐页
		public static const RECOMMENDURL:String = "http://s.newsapp.cibntv.net/tvmfusion/v4/feed-rel/feed?";
		
		//广告页
		public static const ADVERTCHARTURL:String = "http://api.saas.tvm.cn/spread/";
		
		//html打开网页
		public static const VIDEOSHARE_HTMLURL:String = "http://web.newsapp.cibntv.net/app/play/?id=";
		
		//搜索接口
		public static const VIDEO_SEARCH:String = "http://s.newsapp.cibntv.net/tvmfusion/v4/fusion/v3-query?";
		
		//外部分享地址
		public static const PLAYER_LINK_URL:String = "http://web.newsapp.cibntv.net/app/play/?";
		
		public static const PLAYER_DOMAIN_OLD:String = "www.tvm.cn";
		public static const PLAYER_DOMAIN_LAST:String = "web.newsapp.cibntv.net";
		public function NetConstant()
		{
		}
	}
}