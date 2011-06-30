package id.core
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import id.core.GestureGlobals;
	import id.core.gw_public;
	import id.managers.TouchManager;
	import id.utils.GestureWorksParser;
	
	import spark.core.SpriteVisualElement;

	public class GestureWorks extends SpriteVisualElement
	{
		public static var application:Stage;
		
		public function GestureWorks()
		{
			super();
		}
		
		public static function initialize(stage:Stage):void
		{
			application = stage;
			
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
			
			TouchManager.gw_public::initialize();
			
			//GestureWorksParser.gw_public::settingsPath="GestureWorks.xml";
			//GestureWorksParser.gw_public::addEventListener(Event.COMPLETE,onParseComplete);
		}
		
		/*private function onParseComplete(event:Event):void
		{	
			TouchManager.gw_public::initialize();
			
			trace("historyCaptureLength:",GestureGlobals.historyCaptureLength);
			
			gestureworksInit();
		}*/
		
		protected function gestureworksInit():void{}
		
	}
}