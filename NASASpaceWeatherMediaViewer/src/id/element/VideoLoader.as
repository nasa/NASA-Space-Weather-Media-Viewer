package id.element
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import id.core.GestureWorks;
	
	//import id.component.ControlBtns;

	public class VideoLoader extends Sprite
	{
		public static var TIME:String = "Time";
		public static var COMPLETE:String = "videoComplete";
		private var nc:NetConnection;
		public var timer:Timer;
		public var ns:NetStream;
		private var video:Video;
		private var _width:Number;
		private var _height:Number;
		private var _url:String="";
		private var _scale:Number=1;
		private var _pixels:Number=0;
		public var videoObject:Object;
		private var _timerFormated:String="00:00";
		public var timerUpdate:Boolean;
		private var count:int;
		public var isPlaying:Boolean;

		public function VideoLoader()
		{
			super();
			trace("videoloader here")
		}

		public function Dispose():void
		{
			timer.stop();
			
			timer.removeEventListener(TimerEvent.TIMER, updateDisplay);
			//timer=null;
			
			ns.close();
			//ns = null;
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			_url=value;
			createUI();
			commitUI();
		}

		public function get scale():Number
		{
			return _scale;
		}
		public function set scale(value:Number):void
		{
			_scale=value;
		}

		public function get pixels():Number
		{
			return _pixels;
		}
		public function set pixels(value:Number):void
		{
			_pixels=value;
		}

		public function get time():String
		{
			return _timerFormated;
		}
		
		protected function createUI():void
		{
			videoObject = new Object();
			timer=new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, updateDisplay);
		}

		protected function commitUI():void
		{
			var customClient:Object = new Object();

			nc=new NetConnection();
			nc.connect(null);
			ns=new NetStream(nc);
			video=new Video();
			video.attachNetStream(ns);

			customClient.onMetaData=metaDataHandler;

			ns.client=customClient;
			
			ns.play(url);
		
			ns.pause();
			ns.seek(0);
			
			play();

			if (_pixels!=0)
			{
				var reduceX:Number=_pixels/video.width;
				var reduceY:Number=_pixels/video.height;
				_scale=reduceX>reduceY?reduceY:reduceX;
			}

			video.width*=_scale;
			video.height*=_scale;

			addChild(video);

			ns.addEventListener(NetStatusEvent.NET_STATUS,onVideoStatus);
		}
		
		protected function layoutUI():void
		{
		}
		
		protected function updateUI():void
		{
		}

		private function metaDataHandler(info:Object):void
		{
			videoObject=info;

			count++;
			
			if (count==1)
			{
				dispatchEvent(new Event(VideoLoader.COMPLETE));
				
				var pw:Number = info.width;
				var ph:Number = info.height;
				var pratio:Number = pw/ph;
				var sw:Number = GestureWorks.application.stageWidth;
				var sh:Number = GestureWorks.application.stageHeight;
				var sratio:Number = sw/sh;
				var targetwidth:Number;
				var targetheight:Number; 
				
				if(pratio<=sratio)
				{
					targetwidth = Math.floor(sh*pratio);
					targetheight = sh;
				}
				else if(pratio>sratio)
				{
					targetwidth = sw;
					targetheight = Math.floor(sw*(1/pratio));
				}
				
				video.width=targetwidth;
				video.height=targetheight;
				
				width=video.width;
				height=video.height;
				
				x=(0-width)/2;
				y=(0-height)/2;
				
				trace(targetwidth,targetheight);
				
			}
			
			trace("meta update")
		}

		public function play():void
		{
			ns.resume();
			isPlaying=true;
			trace("PLAYING");
			
			timer.start();
		}

		public function pause():void
		{
			ns.pause();
			timer.stop();
		}

		public function back():void
		{
			timer.stop();
			timer.reset();
			ns.seek(0);
			ns.pause();
		}
		
		public function forward():void
		{
			ns.seek(ns.time+2);
			var stringForward:String=formatTime(ns.time+2);
			sendUpdate(stringForward);
		}
		
		private function onVideoStatus(evt:Object):void
		{
		//	trace(evt);
		//	trace(evt.info.code);
			
			if (evt.info.code=="NetStream.Play.Start")
			{
				
			}
			if (evt.info.code=="NetStream.Seek.Notify")
			{
				sendUpdate("00:00");
			}
			if (evt.info.code=="NetStream.Play.Stop")
			{
				back();
				sendUpdate("00:00");
			}
		}

		private function updateDisplay(event:TimerEvent):void
		{
			var string:String=formatTime(ns.time);
			sendUpdate(string);
		}

		private function sendUpdate(string:String):void
		{
			_timerFormated=string;
			dispatchEvent(new Event(VideoLoader.TIME, true, true));
		}

		private function formatTime(t:int):String
		{
			var s:int=Math.round(t);
			var m:int=0;
			if (s>0)
			{
				while (s > 59)
				{
					m++;
					s-=60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
				//return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			}
			else
			{
				return "00:00";
			}
		}

	}
}