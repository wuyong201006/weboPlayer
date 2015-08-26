package net
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import events.GlobalServer;
	import events.GlobalServerEvent;
	import events.PlayerEvent;
	
	public class DefinedPlayer extends EventDispatcher
	{
		public const BUFFERMIN:Number = 1;//缓存最少时间
		private var _url:String="";
		private var _mediaInfo:Object;
		private var _druation:Number = 0;
		private var _netStream:NetStream;
		
		private var _playStatus:Boolean=false;//播放状态
		private var heartbeat:Timer = new Timer(100);
		
		private var _IsPlayEnd:Boolean=false;//是否播放到最后 
		public function DefinedPlayer(url:String, druation:Number)
		{
			_url = url;
//			_druation = druation;
			var netConnection:NetConnection = new NetConnection();
			netConnection.connect(null);
			_netStream = new NetStream(netConnection);
			_netStream.client = {onMetaData:this.onMetaData, onCuePoint:this.onCuePoint, onPlayStatus:this.onPlayStatus};
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStreamStatus);
			
			heartbeat.addEventListener(TimerEvent.TIMER, onHeartbear);
		}
		
		public function get IsBufferFull():Boolean
		{
			return _IsBufferFull;
		}

		public function set IsBufferFull(value:Boolean):void
		{
			_IsBufferFull = value;
		}

		public function get IsPlayEnd():Boolean
		{
			return _IsPlayEnd;
		}

		public function set IsPlayEnd(value:Boolean):void
		{
			_IsPlayEnd = value;
		}

		public function get druation():Number
		{
			return _druation;
		}
		
		public function get playStatus():Boolean
		{
			return _playStatus;
		}

		public function set playStatus(value:Boolean):void
		{
			_playStatus = value;
			
			if(!value)
				heartbeat && heartbeat.stop();
			else
				heartbeat && heartbeat.start();
		}

		public function get netStream():NetStream
		{
			return _netStream;
		}

		public function set netStream(value:NetStream):void
		{
			_netStream = value;
		}
		
		/**
		 *	定在开始显示流之前需要多长时间将消息存入缓冲区。 
		 */
		public function set bufferTime(value:Number):void
		{
			_netStream.bufferTime = value;	
		}
		
		public function get mediaInfo():Object
		{
			return _mediaInfo;
		}
		
		private var _IsBufferFull:Boolean=false;
		private var timeOut:Number;
		private var curTi:Number = 0;
		public function play():void
		{
			playStatus = !playStatus;
			
			_netStream.play(_url);
			
			if(!IsBufferFull)
			{
				var dp:DefinedPlayer = this;
				
				var lastTimer:Number = 0;
				timeOut = setInterval(function():void{
					
					if(getTimer()-lastTimer < 100)return;
					lastTimer = getTimer();
					
					curTi += 0.1;
					if(IsBufferFull && curTi > BUFFERMIN)
					{
						defineBufferFull();
					}
					dp.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYER_BUFFER_UPDATE, curTi/*netStream.bufferLength*/))
				}, 33);
			}
		}
		
		public function pause():void
		{
			playStatus = !playStatus;
			_netStream.togglePause();
		}
		
		private var seekID:int;
		private var seeking:Boolean = true;
		private var lastOffset:Number
		public function seek(offset:Number):void
		{
			_netStream.seek(offset);
			
			if(!heartbeat.running)
				heartbeat.start();
		}
		
		private function checkForTimeUpdate(snapshot:Number):void
		{
			if(_netStream.time != snapshot)
			{
				clearInterval(seekID);
				seekID = -1;
				seeking = false;
//				dispatchEvent( new VideoStreamEvent(VideoStreamEvent.SEEK_
			}
		}
		/**
		 * 	@param value 声音大小
		 **/
		public function volume(value:Number):void
		{
			var soundTransform:SoundTransform = netStream.soundTransform;
			soundTransform.volume = value;
			netStream.soundTransform = soundTransform;
		}
		
		private function defineBufferFull():void
		{
			if(!playStatus)
				pause();
			
			clearTimeout(timeOut);
			dispatchEvent( new PlayerEvent(PlayerEvent.PLAYER_BUFFER_FULL));
		}
		
		private function netStreamStatus(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetStream.Connect.Failed":
					break;
				case "NetStream.Connect.Success":
					break;
				case "NetStream.Buffer.Empty":
					break;
				case "NetStream.Buffer.Full":
					IsBufferFull = true;
					if(curTi < BUFFERMIN)
					{
						trace("curTi"+curTi);
						
						if(playStatus)
							pause();						
						return;
					}
					
					trace("across");
					defineBufferFull();
					break;
				case "NetStream.Play.Start":
					heartbeat.start();
//					GlobalServer.dispatchEvent(new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_START));
					break;
				case "NetStream.Play.Stop":
					IsPlayEnd = true;
					heartbeat.stop();
					GlobalServer.dispatchEvent( new GlobalServerEvent(GlobalServerEvent.PLAYER_PLAY_STOP));
					break;
				case "NetStream.Seek.Failed":
					clearInterval(seekID);
					seeking = false;
					break;
				case "NetStream.Seek.InvalidTime":
//					clearInterval(seekID);
//					seeking = false;
					var lvtime:Number = parseFloat(event.info.details);
//					seek(lvtime);
//					trace("lvtime"+lvtime);
					break;
//				case "NetStream.Seek.Notify":
//					break;
			}
		}
		
		private function onHeartbear(event:TimerEvent):void
		{
			dispatchEvent( new PlayerEvent(PlayerEvent.PLAYER_UPDATE, {time:_netStream.time, bytesProgress:_netStream.bytesLoaded/_netStream.bytesTotal*100}));
			
			
			IsPlayEnd = _netStream.time == druation;
		}
		
		private function onMetaData(info:Object) : void
		{
			_mediaInfo = info;
			_druation = info.duration;
			dispatchEvent( new PlayerEvent(PlayerEvent.MEDIA_DURATION_UPDATE, info.duration));
		}
		
		private function onCuePoint(info:Object) : void
		{
		}
		
		private function onPlayStatus(info:Object):void
		{
			if(info.code == "NetStream.Play.Complete")
			{
			}
		}
	}
}