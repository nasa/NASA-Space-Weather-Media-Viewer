package id.component
{
	import id.core.TouchComponent;
	import id.element.BitmapLoader;
	import id.element.VideoLoader;
	import id.element.GoBackButton;
	import flash.events.TouchEvent;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import id.Globals;
	import gl.events.GestureEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import id.element.InfoButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import com.log2e.utils.SpinningPreloader;
	import id.core.TouchMovieClip;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import id.core.TouchSprite;
	import id.component.Scrubber;
	import flash.display.Shape;
	
	public class MediaViewer extends TouchComponent
	{
		private var _url:String="";
		private var _description:String="";
		private var _title:String="";
		private var image:*;
		public var backBtn:GoBackButton;
		private var _categoryName:String="";
		public var headerBackground:Sprite;
		private var refreshBtn:Sprite;
		private var infoBtn:InfoButton;
		private var shareBtn:ShareBtn;
		private var infoView:InfoViewer;
		public static var OPEN:String="open";
		public static var INFO:String="information";
		private var helvetica:Font;
		private var textFormat:TextFormat;
		private var headerText:TextField;
		private var isVideo:Boolean;
		
		//private var rect:Rectangle;
		private var videoCountTimer:Timer;
		private var videoControls:VideoControls;
		//private var scrubing:Boolean;
		
		private var scrubBar:Scrubber;

		public function MediaViewer()
		{
			super();
			visible=false;
		}

		override public function Dispose():void
		{
			if(isVideo)
			{
			videoCountTimer.removeEventListener(TimerEvent.TIMER,updateVideoScrub);	
			videoCountTimer=null;
			}
				
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		private var _xml:XML;
		public function get xml():XML
		{
			return _xml;
		}
		public function set xml(value:XML):void
		{
			_xml=value;
			
			createUI();
			layoutUI();
		}

		override protected function createUI():void
		{
			textFormat = new TextFormat();
			headerText = new TextField();
			helvetica = new Helvetica();
			
			if(xml.@type!=undefined)
			{
				image=new VideoLoader();
				isVideo=true;
				refreshBtn = new FullScreenBtn();
			}
			else
			{
				image=new BitmapLoader();
				image.pixels=Main.s.stageHeight-100;
				refreshBtn = new Refresh();
			}
			
			headerBackground = new HeaderBack();
			
			backBtn = new GoBackButton();
			infoBtn = new InfoButton();
			shareBtn = new ShareBtn();
			infoView = new InfoViewer();

			addChild(image);
			addChild(headerBackground);
			
			if(isVideo)
			{
				scrubBar = new Scrubber();
				videoControls = new VideoControls();
				
				videoCountTimer=new Timer(10);
				videoCountTimer.addEventListener(TimerEvent.TIMER,updateVideoScrub);
				addEventListener(VideoLoader.TIME,timeHandler);
				
				addChild(scrubBar);
				addChild(videoControls);
				
				scrubBar.addEventListener(Scrubber.MOVING, scrubberMoving);
				
				videoControls.x=(Main.s.stageWidth-videoControls.width)/2;
				videoControls.y=Main.s.stageHeight-videoControls.height-100;
				
				videoControls.addEventListener(VideoControls.PLAY, playVideo);
				videoControls.addEventListener(VideoControls.PAUSE, pauseVideo);
				videoControls.addEventListener(VideoControls.BACK, backVideo);
				videoControls.addEventListener(VideoControls.FORWARD, forwardVideo);
				addEventListener(TouchEvent.TOUCH_END, scrubberRelease);
			}
			
			if(!isVideo)
			{
				addChild(headerText);
			}
			
			addChild(backBtn);
			addChild(refreshBtn);
			addChild(infoView);
			
			backBtn.addEventListener(TouchEvent.TOUCH_BEGIN, buttonDown);
			refreshBtn.addEventListener(TouchEvent.TOUCH_BEGIN, refreshDown);
						
			headerBackground.alpha=.5;
			headerBackground.width=Main.s.stageWidth;
		}

		private var preloader:SpinningPreloader;
		override protected function commitUI():void
		{			
			Main.s.addEventListener(MediaViewer.INFO, infoCallBack);

			if (image.url!="")
			{
				return;
			}
			
			preloader = new SpinningPreloader(this, Main.s.stageWidth/2, Main.s.stageHeight/2, 21, 18, 12, 3, 0xCCCCCC, 15, .75);
			preloader.start();

			if(!isVideo)
			{
				image.blobContainerEnabled=true;
				image.addEventListener(GestureEvent.GESTURE_DRAG, imageDrag);
				image.addEventListener(GestureEvent.GESTURE_SCALE, imageScale);
			}
			
			image.url=xml.@source;
		}
		
		override protected function layoutUI():void
		{
			infoView.xml=xml;
			
			infoView.x=Main.s.stageWidth;
			
			backBtn.text=xml.categoryName;
			backBtn.x=15;
			backBtn.y=10;

			refreshBtn.x=Main.s.stageWidth-refreshBtn.width-15;
			refreshBtn.y=10;
			
			shareBtn.x=20;
			shareBtn.y=Main.s.stageHeight-shareBtn.width-15;
			
			infoBtn.touchChildren=false;
			infoBtn.x=80;
			infoBtn.y=Main.s.stageHeight-infoBtn.height-50;
			
			textFormat.align=TextFormatAlign.LEFT;
			textFormat.size=21;
			textFormat.font=helvetica.fontName;
			textFormat.color=0xFFFFFF;

			headerText.embedFonts=true;
			headerText.defaultTextFormat=textFormat;
			headerText.antiAliasType=AntiAliasType.ADVANCED;
			headerText.autoSize=TextFieldAutoSize.LEFT;
			headerText.text=xml.@title.toString();
			headerText.selectable=false;
			
			Globals.title=xml.@title.toString();
			
			headerText.x=(Main.s.stageWidth-headerText.textWidth)/2;
			headerText.y=((headerBackground.height-headerText.textHeight)/2)-2;
			
			if(isVideo)
			{
				scrubBar.y=headerText.y+2;
				backBtn.text="done";
			}
		}

		override protected function updateUI():void
		{
			preloader.stop();
			
			image.alpha=1;
			image.visible=true;
			image.x=(Main.s.stageWidth-image.width)/2;
			image.y=(Main.s.stageHeight-image.height)/2;
		}

		private function refreshDown(event:TouchEvent):void
		{
			if(!isVideo)
			{
				removeChild(image);
				image=null;
				
				image=new BitmapLoader();
				addChild(image);
				
				setChildIndex( image, 0 );
				
				preloader = new SpinningPreloader(this, Main.s.stageWidth/2, Main.s.stageHeight/2, 21, 18, 12, 3, 0xCCCCCC, 15, .75);
				preloader.start();
				
				image.pixels=Main.s.stageHeight-100;
				image.blobContainerEnabled=true;
				image.addEventListener(GestureEvent.GESTURE_DRAG, imageDrag);
				image.addEventListener(GestureEvent.GESTURE_SCALE, imageScale);
				image.url=xml.@source;
			}
			else
			{
				trace("full screen");
			}
		}
		
		private function buttonDown(event:TouchEvent):void
		{
			image.visible=true;
			Main.s.removeEventListener(MediaViewer.INFO, infoCallBack);
			Main.s.dispatchEvent(new Event(FooterBackground.SHOW_BUTTONS));
			Main.s.dispatchEvent(new Event(FooterBackground.HIDE_INFOBTNS));
			
			if(isVideo && image.isPlaying)
			{
				image.pause();
			}
			super.updateUI();
		}
		
		private function infoBtnDown(event:TouchEvent):void
		{
			//TweenNano.to(this, 0.5, {x:x-Main.s.stageWidth/*, onComplete:resetContainer, onCompleteParams:[event]*/});
		}
		
		private var max:Number=2;
		private var min:Number=.5;
		private function imageScale(event:GestureEvent):void
		{
			event.target.scaleX+=event.value;
			event.target.scaleY+=event.value;

			event.target.scaleY=event.target.scaleY>Number(max)?Number(max):event.target.scaleY<Number(min)?Number(min):event.target.scaleY;
			event.target.scaleX=event.target.scaleX>Number(max)?Number(max):event.target.scaleX<Number(min)?Number(min):event.target.scaleX;
		}
		
		private function imageDrag(event:GestureEvent):void
		{
			event.target.x+=event.dx;
			event.target.y+=event.dy;
		}

		public function startLoadingImage():void
		{
			Main.s.dispatchEvent(new Event(FooterBackground.SHOW_INFOBTNS));
			Main.s.dispatchEvent(new Event(FooterBackground.HIDE_BUTTONS));
			commitUI();
		}
		
		private function infoCallBack(event:Event):void
		{
			infoView.isCurrentInfoViewer=true;
			TweenNano.to(this, 0.5, {x:x-Main.s.stageWidth});
			Main.s.dispatchEvent(new Event(FooterBackground.HIDE_INFOBTNS));
			Main.s.dispatchEvent(new Event(FooterBackground.SHOW_TEXTBUTTONS));
			
			if(isVideo && image.isPlaying)
			{
				image.pause();
			}
		}
		
		private function updateVideoScrub(e:TimerEvent):void 
		{
			
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
		
		private function scrubberRelease(event:TouchEvent):void
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
		
		private function pauseVideo(event:Event):void
		{
			image.pause();
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
		
	}
}