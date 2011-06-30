package id.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import id.component.Scrubber;
	import id.component.VideoControls;
	import id.core.GWTouchSprite;
	import id.core.GestureGlobals;
	import id.core.GestureWorks;
	import id.element.BitmapLoader;
	import id.element.VideoLoader;
	
	public class ImageSprite extends GWTouchSprite
	{
		public static var LOADED:String="media loaded";
		private var image:*;
		private var videoCountTimer:Timer;
		private var videoControls:VideoControls;
		private var scrubing:Boolean;
		private var scrubBar:Scrubber;
		private var originalWidth:Number=0;
		private var originalHeight:Number=0;
		private var isFullScreen:Boolean;
		private var isPortrait:Boolean;
		private var spriteContainer:Sprite;
		
		public function ImageSprite()
		{
			super();
		}
		
		private var _url:String;
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			_url = value;
			
			createUI();
			commitUI();
		}
		
		private var _isVideo:Boolean;
		public function get isVideo():Boolean
		{
			return _isVideo;
		}
		public function set isVideo(value:Boolean):void
		{
			_isVideo = value;
		}
		
		private function createUI():void
		{			
			if(isVideo)
			{
				image=new VideoLoader();
				scrubBar = new Scrubber();
				videoControls = new VideoControls();
				
				addEventListener(VideoLoader.TIME,timeHandler);
				
				addChild(image);
				
				addChild(scrubBar);
				addChild(videoControls);
				
				scrubBar.addEventListener(Scrubber.MOVING, scrubberMoving);
				
				videoControls.x=(GestureWorks.application.stageWidth-videoControls.width)/2;
				videoControls.y=GestureWorks.application.stageHeight-videoControls.height-100;
				
				videoControls.addEventListener(VideoControls.PLAY, playVideo);
				videoControls.addEventListener(VideoControls.PAUSE, pauseVideo);
				videoControls.addEventListener(VideoControls.BACK, backVideo);
				videoControls.addEventListener(VideoControls.FORWARD, forwardVideo);
				addEventListener(MouseEvent.MOUSE_UP, scrubberRelease);
				image.addEventListener(VideoLoader.COMPLETE, updateUI);
				
				touch=false;
			}
			else
			{
				spriteContainer = new Sprite();
				image = new BitmapLoader()
				spriteContainer.addChild(image);
				addChild(spriteContainer);
				image.addEventListener(BitmapLoader.COMPLETE, updateUI);
				touch=true;
			}
		}
		
		private function commitUI():void
		{
			if(!isVideo)
			{
				image.pixels=GestureWorks.application.stageWidth-100;
			}
			image.url=url;	
		}
		
		public function updateUI(event:Event):void
		{
			if(event!=null)
			{
				if(width==0)
				{
					width=image.width;
					height=image.height;
					
					originalWidth=width;
					originalHeight=height;
				}
				
				dispatchEvent(new Event(ImageSprite.LOADED));
			}
			image.alpha=1;
			image.visible=true;
			
			if(isVideo)
			{
				videoControls.x=(0-videoControls.width)/2;
				videoControls.y=GestureWorks.application.stageHeight-y-(GestureGlobals.btnBarHeight*2)-36;
				scrubBar.x=videoControls.x;
				scrubBar.y=y-GestureWorks.application.stageHeight+GestureGlobals.btnBarHeight+20;
				
				setFullScreen();
				
				image.x=(0-image.width)/2;
				image.y=(0-image.height)/2;
			}
			else
			{
				x=(GestureWorks.application.stageWidth-width)/2;
				y=(GestureWorks.application.stageHeight-height)/2;
			}
			
			if(isFullScreen)
			{
				
				//image.x=(0-image.width)/2;
				//image.y=(0-image.height)/2;
			}
		}
		
		public function refresh():void
		{
			if(!isVideo)
			{
				removeChild(image);
				image=null;
				
				image=new BitmapLoader();
				addChild(image);
				
				setChildIndex( image, 0 );
				
				image.pixels=GestureWorks.application.stageWidth-100;
				image.url=url;
				image.addEventListener(BitmapLoader.COMPLETE, updateUI);
			}
		}
		
		private var isScrubberMoving:Boolean;
		private function scrubberMoving(event:Event):void
		{
			if(!isScrubberMoving)
			{
				isScrubberMoving=true;
				image.pause();
			}
		}
		
		private function scrubberRelease(event:MouseEvent):void
		{			
			if(!scrubBar.scrubing)return;
			
			scrubBar.scrubing=false;
			
			image.ns.seek(Math.round(scrubBar.handle.x * image.videoObject.duration / scrubBar.width ));
			
			if(image.isPlaying)
			{
				image.play();
			}
			
			isScrubberMoving=false;
		}
		
		private function timeHandler(event:Event):void
		{
			scrubBar.timeText=image.time;
			
			scrubBar.handleXpos((image.ns.time*(scrubBar.width))/image.videoObject.duration);
		}
		
		private function playVideo(event:Event):void
		{
			image.play();
		}
		
		public function pauseVideo(event:Event):void
		{
			image.pause();
		}
		
		public function disposeVideo():void
		{
			image.Dispose();
		}
		
		private function backVideo(event:Event):void
		{
			image.back();
			scrubBar.handleXpos(0);
		}
		
		private function forwardVideo(event:Event):void
		{
			image.forward();
		}
		
		public function fullScreen():void
		{
			if(!isFullScreen)
			{
				isFullScreen=true;
				setFullScreen();
			}
			else
			{
				image.width=originalWidth;
				image.height=originalHeight;
				isFullScreen=false;
			}
			
			image.x=(0-image.width)/2;
			image.y=(0-image.height)/2;
		}
		
		private function setFullScreen():void
		{
			var pw:Number = originalWidth;
			var ph:Number = originalHeight;
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
			
			image.width=targetwidth;
			image.height=targetheight;
		}
		
		public function setControlVisible(value:Boolean):void
		{
			if(isVideo)
			{
				videoControls.visible=value;
				scrubBar.visible=value;
			}
		}
		
		public function cleanUp():void
		{
			if(isVideo)
			{
				image.Dispose();
			}
		}
		
		public function pause():void
		{
			if(isVideo)
			{
				videoControls.pauseBtnDown(null);
			}
		}
	}
}