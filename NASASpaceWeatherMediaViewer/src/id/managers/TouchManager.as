/* Trace out touch point histories..................................................

Touch Points History is located in GestureGlobals.pointHistory

var length:int=GestureGlobals.pointHistory[event.touchPointID].length;
trace(GestureGlobals.pointHistory[event.touchPointID][length-1].x);

..................................................................................

*/

package id.managers
{
	import flash.utils.Dictionary;
	import id.core.GestureWorks;
	import id.core.GestureGlobals;
	import flash.events.TouchEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import id.core.gw_public;
	import flash.display.Shape;

	public class TouchManager extends Sprite
	{
		private static var count:int;
		private static var touchObjects:Dictionary = new Dictionary();
		private static var pointDictionary:Dictionary = new Dictionary();
		private static var pointArray:Array;
		private static var pointHistoryQueue:Dictionary = new Dictionary();
		private static var historyCaptureLength:int;
		private static var pointHistory:Dictionary = new Dictionary();
		public static var points:Dictionary = new Dictionary();

		public function TouchManager()
		{
			super();
		}

		gw_public static function initialize():void
		{
			trace("rasta");
			
			GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchUp);

			GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);

			historyCaptureLength=GestureGlobals.historyCaptureLength;
			
			pointHistory=GestureGlobals.gw_public::pointHistory;
			
			points=GestureGlobals.gw_public::points;
		}

		gw_public static function registerTouchPoint(object:Object):void
		{
			object.id=count;

			pointArray = new Array();
			pointHistory[object.touchPointID]=pointArray;

			count++;

			if (! touchObjects[object.object])
			{
				var obj:Object={"count":1};

				touchObjects[object.object]=obj;
			}
			else
			{
				touchObjects[object.object].count++;
			}

			if (! GestureWorks.application.hasEventListener(Event.ENTER_FRAME))
			{
				GestureWorks.application.addEventListener(Event.ENTER_FRAME, enterFrame);
			}
		}
		
		public static function removeAllTouchPoints():void
		{
			for (var key:Object in points)
			{
				count--;
				
				points[key].object.arrangePointArray(points[key].id);
				
				touchObjects[points[key].object].count--;
				
				if (touchObjects[points[key].object].count==0)
				{
					delete touchObjects[points[key].object];
					GestureGlobals.gw_public::objectCount--;
				}
				
				pointHistory[key]=[];
				
				if (count==0)
				{
					GestureWorks.application.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
				
				delete points[key];
			}
			
			trace("removed all touch points");
		}
		
		private static function onTouchUp(event:TouchEvent):void
		{
			if (points[event.touchPointID])
			{
				if(GestureGlobals.debugPoints)
				{
					var point:Shape=points[event.touchPointID].point;
					GestureWorks.application.removeChild(point);
					point=null;
				}
				
				removeTouchPoint(event);
			}
		}

		private static function removeTouchPoint(event:TouchEvent):void
		{
			count--;
			
			points[event.touchPointID].object.arrangePointArray(points[event.touchPointID].id);
			
			touchObjects[points[event.touchPointID].object].count--;

			if (touchObjects[points[event.touchPointID].object].count==0)
			{
				delete touchObjects[points[event.touchPointID].object];
				GestureGlobals.gw_public::objectCount--;
			}

			pointHistory[event.touchPointID]=[];

			if (count==0)
			{
				GestureWorks.application.removeEventListener(Event.ENTER_FRAME, enterFrame);
			}
			
			delete points[event.touchPointID];
		}

		private static function onTouchMove(event:TouchEvent):void
		{
			if (points[event.touchPointID])
			{
				pointHistoryQueue[event.touchPointID]=event;

				if (pointHistory[event.touchPointID].length==0)
				{
					pointHistory[event.touchPointID][0]=historyObject(event);
				}

				points[event.touchPointID].object.onTouchMoving(event);
			}
		}

		private static function enterFrame(event:Event):void
		{
			releaseHistoryOueue();
		}

		private static function releaseHistoryOueue():void
		{
			for each (var event:TouchEvent in pointHistoryQueue)
			{
				pointHistory[event.touchPointID][length-1]=historyObject(event);

				if (pointHistory[event.touchPointID].length-1>=historyCaptureLength)
				{
					pointHistory[event.touchPointID].shift();
				}
			}
		}

		private static function historyObject(event:TouchEvent):Object
		{
			var object:Object = new Object();
			object.x=event.stageX;
			object.y=event.stageY;

			return object;
		}
	}
}