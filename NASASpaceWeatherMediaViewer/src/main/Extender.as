package main
{
	import id.core.Application;
	import id.core.TouchSprite;
	import gl.events.GestureEvent;

	public class Extender extends Application
	{
		public function Extender()
		{
			trace("cooyes i application=================")
			var image:TouchSprite = new TouchSprite();
			image.graphics.beginFill(0x990000, 1);
			image.graphics.drawRect(0,0,200,200);
			image.graphics.endFill();
			addChild(image);
			
			image.blobContainerEnabled = true;
			
			image.addEventListener(GestureEvent.GESTURE_DRAG, drag);
			image.addEventListener(GestureEvent.GESTURE_SCALE, scale);
		}
		
		private function drag(event:GestureEvent):void
		{
			event.target.x+=event.dx;
			event.target.y+=event.dy;
		}
		
		private function scale(event:GestureEvent):void
		{
			event.target.scaleX+=event.value;
			event.target.scaleY+=event.value;
		}
	}
}