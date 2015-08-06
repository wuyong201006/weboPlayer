package vo
{
	public class VideoInfo
	{
		private var _id:Object;//视频唯一ID
		private var _title:Object;//标题
		private var _content:Object;//内容
		private var _thumburl:String;//缩略图
		
		private var _data:Object;
		public function VideoInfo(data:Object)
		{
			_data = data;
			
			_id = String(data.id.$t).split(":")[2];
			_content = data.content;
			_title = data.title;
			_thumburl = data.media$group.media$thumbnail.url;
		}
		
		public function get thumburl():String
		{
			return _thumburl;
		}

		public function get content():Object
		{
			return _content;
		}

		public function get title():Object
		{
			return _title;
		}

		public function get id():Object
		{
			return _id;
		}

		public function get data():Object
		{
			return _data;
		}
	}
}