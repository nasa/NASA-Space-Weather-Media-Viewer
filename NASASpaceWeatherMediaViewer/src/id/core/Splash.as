package id.core
{
	import com.greensock.TweenNano;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import id.core.GestureGlobals;
	import id.core.GestureWorks;
	import id.element.BitmapLoader;
	
	import mx.flash.UIMovieClip;
	
	import spark.core.SpriteVisualElement;
	
	public class Splash extends SpriteVisualElement
	{
		public static var LOADED:String="media loaded";
		private var image:*;
		
		private var background:UIMovieClip;
		private var stg:Stage;
		
		public function Splash(s:Stage)
		{
			super();
			
			stg=s;
			
			createUI();
			commitUI();
			updateUI();
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
		
		private function createUI():void
		{			
			background = new backgroundSplash();
			addChild(background);
			background.width=stg.stageWidth;
			background.height=stg.stageHeight;
			
			alpha=0;
		}
		
		private function commitUI():void
		{
			//image.pixels=300;
			//image.url=url;
			
			//trace("here");
			
			trace(parent);
		}
		
		public function updateUI():void
		{
			TweenNano.to(this, 0.5, {alpha:1});
		}		
	}
}