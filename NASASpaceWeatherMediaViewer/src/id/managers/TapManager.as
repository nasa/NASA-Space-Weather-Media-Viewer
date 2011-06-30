package id.managers
{
	import flash.utils.Dictionary;
	import id.core.GestureWorks;
	import id.core.GestureGlobals;
	import flash.events.TouchEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import id.core.gw_public;
	import id.core.GWTouchSprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class TapManager extends Sprite
	{
		private var tapTimer:Timer;
		
		public function TapManager()
		{
			super();
		}

		gw_public static function registerTap(object:GWTouchSprite, event:TouchEvent):void
		{
			trace(object,event.touchPointID);
			
			//tapTimer=new Timer(100);
			//tapTimer.addEventListener(TimerEvent.TIMER, tapTimerComplete);
		}

		private static function tapTimerComplete(event:TouchEvent):void
		{
			
		}

		
	}
}