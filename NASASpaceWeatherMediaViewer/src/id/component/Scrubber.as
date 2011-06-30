package id.component
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import id.core.GestureWorks;
	import id.element.TimeDisplay;

	public class Scrubber extends Sprite
	{
		public var handle:Sprite;
		private var background:Sprite;
		private var foreground:Sprite;
		private var outline:Sprite;
		private var rect:Rectangle;
		public var scrubing:Boolean;
		private var xStart:Number=0;
		private var xFinish:Number=0;
		private var time:TimeDisplay;
		private var timeR:TimeDisplay;

		public static var MOVING:String="scrubber grab and move";
		public static var RELEASE:String="scrubber release";

		public function Scrubber()
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

		public function get timeText():String
		{
			return time.text;
		}
		public function set timeText(value:String):void
		{
			time.text=value;
			//timeR.text=value;
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
			handle = new scrubHandle();
			background = new scrubBackground();
			foreground = new scrubForeground();
			outline = new scrubOutline();
			time = new TimeDisplay();
			timeR = new TimeDisplay();

			addChild(time);
		//	addChild(timeR);
			addChild(background);
			addChild(foreground);
			addChild(outline);
			addChild(handle);
			
			//handle.blobContainerEnabled=true;

			//handle.addEventListener(TouchEvent.TOUCH_BEGIN, scrubDownHandler);
			//handle.addEventListener(GestureEvent.GESTURE_DRAG_1, dragEventHandler);
		}

		protected function commitUI():void
		{
			width=background.width;
			height=handle.height;

			foreground.width=0;

			handle.y=(background.height)/2;

			//time.x=0-time.width-6;
			time.y=-6;
			
			time.x=background.width;
			//timeR.y=-9;

			xStart=0;
			xFinish=width;
			
		}

		protected function layoutUI():void{}

		protected function updateUI():void{}

		private function dragEventHandler(event:MouseEvent):void
		{
			if(!scrubing)return;
			
			event.target.x+=event.localX;

			event.target.x=event.target.x>Number(xFinish) ?
			Number(xFinish):event.target.x<Number(xStart) ?
			Number(xStart):event.target.x;
			
			foreground.width=event.target.x;
			
			this.dispatchEvent(new Event(Scrubber.MOVING));
		}
		
		public function handleXpos(value:Number):void
		{
			if(!scrubing)
			{
				handle.x=value;
				foreground.width=handle.x;
			}
		}

		private function scrubDownHandler(e:TouchEvent):void
		{
			scrubing=true;
		}
		
	}
}