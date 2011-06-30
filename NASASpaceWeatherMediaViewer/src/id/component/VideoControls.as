package id.component
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import id.component.Scrubber;

	public class VideoControls extends Sprite
	{
		public var handle:Sprite;
		private var background:Sprite;
		private var foreground:Sprite;
		private var outline:Sprite;
		public var scrubing:Boolean;
		private var xStart:Number=0;
		private var xFinish:Number=0;
		private var scrubber:Sprite;

		public static var MOVING:String="volume scrubber grab and move";
		public static var RELEASE:String="volume scrubber release";
		
		public static var BACK:String = "back";
		public static var FORWARD:String = "forward";
		public static var PLAY:String = "play";
		public static var PAUSE:String = "pause";

		private var videoCB:Sprite;
		private var playBtn:Sprite;
		private var pauseBtn:Sprite;
		
		private var backBtn:Sprite;
		private var forwardBtn:Sprite;
		
		private var isPause:Boolean;

		public function VideoControls()
		{
			super();

			createUI();
			commitUI();
		}

		public function Dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		private var _width:Number=0;
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width=value;
		}

		private var _height:Number=0;
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height=value;
		}

		private var _videoDuration:Number=0;
		public function get videoDuration():Number
		{
			return _videoDuration;
		}
		public function set videoDuration(value:Number):void
		{
			_videoDuration=value;
		}

		protected function createUI():void
		{
			scrubber = new Sprite();
			handle = new scrubHandle();
			background = new scrubBackground();
			foreground = new scrubForeground();
			outline = new scrubOutline();

			videoCB= new videoControlBack();
			playBtn= new playButton();
			backBtn = new videoBackButton();
			forwardBtn = new forwardButton();
			pauseBtn = new pauseButton();

			scrubber.addChild(background);
			scrubber.addChild(foreground);
			scrubber.addChild(outline);
			scrubber.addChild(handle);
			
			addChild(videoCB);
			addChild(pauseBtn);
			addChild(playBtn);
			addChild(backBtn);
			addChild(forwardBtn);
			addChild(scrubber);
			
			playBtn.addEventListener(MouseEvent.MOUSE_DOWN, playBtnDown);
			pauseBtn.addEventListener(MouseEvent.MOUSE_DOWN, pauseBtnDown);
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, backBtnDown);
			forwardBtn.addEventListener(MouseEvent.MOUSE_DOWN, forwardBtnDown);

			handle.addEventListener(MouseEvent.MOUSE_DOWN, scrubDownHandler);
			//handle.addEventListener(GestureEvent.GESTURE_DRAG_1, dragEventHandler);
		}

		protected function commitUI():void
		{
			width=videoCB.width;
			height=videoCB.height;
			
			playBtn.x=(width)/2;
			playBtn.y=(height)/2-25;
			playBtn.visible=false;	
			
			pauseBtn.x=(width)/2;
			pauseBtn.y=(height)/2-25;
			//pauseBtn.visible=false;	
			
			backBtn.x=(width)/2-100;
			backBtn.y=(height)/2-25;
			
			forwardBtn.x=(width)/2+100;
			forwardBtn.y=(height)/2-25;
			
			scrubber.x=(width-background.width)/2;
			scrubber.y=(height)/2+15;
			
			handle.x=background.width;
			handle.y=(background.height)/2;
			
			xStart=0;
			xFinish=background.width;
		}

		protected function layoutUI():void{}

		protected function updateUI():void{}

		private function dragEventHandler(event:MouseEvent):void
		{
			if (! scrubing)
			{
				return;
			}

			event.target.x+=event.localX;

			event.target.x=event.target.x>Number(xFinish) ?
			Number(xFinish):event.target.x<Number(xStart) ?
			Number(xStart):event.target.x;

			foreground.width=event.target.x;

			this.dispatchEvent(new Event(Scrubber.MOVING));
		}

		public function handleXpos(value:Number):void
		{
			//if (! scrubing)
			//{
				//handle.x=value;
				//foreground.width=handle.x;
			//}
		}

		private function scrubDownHandler(e:MouseEvent):void
		{
			//scrubing=true;
		}
		
		private function playBtnDown(event:MouseEvent):void
		{
			dispatchEvent(new Event(VideoControls.PLAY));
			playBtn.visible=false;
			pauseBtn.visible=true;			
		}
		
		public function pauseBtnDown(event:MouseEvent):void
		{
			dispatchEvent(new Event(VideoControls.PAUSE));
			playBtn.visible=true;
			pauseBtn.visible=false;			
		}
		
		private function backBtnDown(event:MouseEvent):void
		{
			dispatchEvent(new Event(VideoControls.BACK));
		}
		
		private function forwardBtnDown(event:MouseEvent):void
		{
			dispatchEvent(new Event(VideoControls.FORWARD));
		}

	}
}