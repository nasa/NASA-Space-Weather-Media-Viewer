package id.events
{
	import flash.events.Event;
	import id.core.GestureGlobals;

	public class GestureEvent extends Event
	{
		public var value:Object;

		public var x:Number;
		public var y:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;

		public static var DRAG:String="drag";
		public static var ROTATION:String="rotate";
		public static var SCALE:String="scale";
		public static var TAP:String="tap";
		public static var DOUBLE_TAP:String="double_tap";
		public static var TRIPLE_TAP:String="triple_tap"

		public function GestureEvent(type:String, data:Object,  bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			value=data;

			x=value.x;
			y=value.y;
			rotation=value.rotation;
			scaleX=value.scaleX;
			scaleY=value.scaleY;
		}

		override public function clone():Event
		{
			return new GestureEvent(type, value, bubbles, cancelable);
		}

	}
}