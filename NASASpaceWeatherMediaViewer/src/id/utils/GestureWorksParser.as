package id.utils
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import id.core.GestureGlobals;
	import id.core.gw_public;

	/**
	 * This is the GestureWorksParser class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 3.0 Mobile
	 */
	public class GestureWorksParser extends EventDispatcher
	{
		public static var settings:XML;
		private static var _settingsPath:String="";
		public static var totalAmount:int;
		public static var amountToShow:int;
		private static var settingsLoader:URLLoader;
		protected static var dispatch:EventDispatcher;

		gw_public static function get settingsPath():String
		{
			return _settingsPath;
		}

		gw_public static function set settingsPath(value:String):void
		{
			if (_settingsPath==value)
			{
				return;
			}

			settingsLoader = new URLLoader();
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			settingsLoader.addEventListener(IOErrorEvent.IO_ERROR, settingsLoader_Error);
			_settingsPath=value;
			settingsLoader.load(new URLRequest(_settingsPath));
		}
		
		gw_public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (dispatch==null)
			{
				dispatch = new EventDispatcher();
			}
			
			dispatch.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		
		private static function settingsLoader_Error(e:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private static function settingsLoader_completeHandler(event:Event):void
		{
			settings=new XML(settingsLoader.data);
			
			setGlobalVariables();

			settingsLoader.removeEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			settingsLoader=null;
		}

		private static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (dispatch==null)
			{
				return;
			}
			
			dispatch.removeEventListener(p_type, p_listener, p_useCapture);
		}

		private static function dispatchEvent(event:Event):void
		{
			if (dispatch==null)
			{
				return;
			}
			
			dispatch.dispatchEvent(event);
		}
		
		private static function setGlobalVariables():void
		{			
			if(settings.debugPoints!=undefined)
			{
				GestureGlobals.debugPoints=settings.debugPoints=="true"?true:false;
			}
			
			if(settings.historyCaptureLength!=undefined)
			{
				GestureGlobals.historyCaptureLength=settings.historyCaptureLength;
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}