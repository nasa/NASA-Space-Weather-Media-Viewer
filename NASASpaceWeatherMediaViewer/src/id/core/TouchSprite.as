package id.core
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import flash.events.Event;
	import id.events.GestureEvent;
	import id.core.GestureGlobals;
	import id.managers.TouchManager;
	import id.core.GestureWorks;
	import id.core.GestureList;
	import id.core.gw_public;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import id.managers.TapManager;
	import id.utils.DebugPoint;
	import spark.core.SpriteVisualElement;
	import mx.core.UIComponent;
	
	public class TouchSprite extends UIComponent
	{
		private var count:int;
		private var point:*;
		private var local:Point;
		private var percentWid:Number;
		private var pointDistance:Number;
		private var dx:Number;
		private var dy:Number;
		private var dist:Number;
		private var widthDiff:Number;
		private var currentScale:Number;
		private var currentRotation:Number;
		private var currentScaleValue:Number;
		private var currentRotate:Number;
		private var rotationDifference:Number;
		private var CX:Number=0;
		private var CY:Number=0;
		private var gestureList:XMLList;
		private var touchPointCoordinates:Object;
		private var localArray:Array = new Array();
		public var pointArray:Array = new Array();
		private var pointDictionary:Dictionary = new Dictionary();
		private var functionDictionary:Dictionary = new Dictionary();
		
		private var tapTimer:Timer;
		private var tapTypeTimer:Timer;
		private var tapTypeCount:int;
		private var isTypeTimer:Boolean;
		
		
		
		public function TouchSprite()
		{
			super();
			gestureList=new XMLList(GestureList.Gestures.Gesture);
			
			functionDictionary["rotateFunction"]=findRotation;
			functionDictionary["dragFunction"]=findDrag;
			functionDictionary["scaleFunction"]=findScale;
			
			tapTimer=new Timer(100);
			tapTimer.addEventListener(TimerEvent.TIMER, tapTimerComplete);
			
			tapTypeTimer=new Timer(300);
			tapTypeTimer.addEventListener(TimerEvent.TIMER, tapTypeTimerComplete);
			
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown);
			addEventListener(TouchEvent.TOUCH_TAP, onTapDown);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
		}
		
		private function tapTimerComplete(event:TimerEvent):void
		{
			tapTimer.stop();
			tapTimer.reset();
		}
		
		private function onTapDown(event:TouchEvent):void
		{
			if (! tapTimer.running)
			{
				return;
			}
			
			tapTimer.stop();
			tapTimer.reset();
			
			registerTap();
			
			//TapManager.gw_public::registerTap(this,event);
		}
		
		private function registerTap():void
		{
			tapTypeCount++;
			if (!tapTypeTimer.running)
			{
				tapTypeTimer.start();
			}
			else
			{
				tapTypeTimer.stop();
				tapTypeTimer.reset();
				tapTypeTimer.start();
			}
		}
		
		private function tapTypeTimerComplete(event:TimerEvent):void
		{			
			var o:Object = new Object();
			
			if (tapTypeCount==1)
			{
				dispatchEvent(new GestureEvent(GestureEvent.TAP,o));
			}
			
			if (tapTypeCount==2)
			{
				dispatchEvent(new GestureEvent(GestureEvent.DOUBLE_TAP,o));
			}
			
			if (tapTypeCount==3)
			{
				dispatchEvent(new GestureEvent(GestureEvent.TRIPLE_TAP,o));
			}
			
			tapTypeTimer.stop();
			tapTypeTimer.reset();
			
			tapTypeCount=0;
		}
		
		private function onTouchDown(event:TouchEvent):void
		{
			if(tapTimer.running)
			{
				tapTimer.stop();
				tapTimer.reset();
			}
			
			tapTimer.start();
			
			var pointObject:Object  = new Object();
			pointObject.object=this;
			
			if(GestureGlobals.debugPoints)
			{
				point=new DebugPoint();
				stage.addChild(point);
			}
			else
			{
				point = new Object();
			}
			
			point.x=event.stageX;
			point.y=event.stageY;
			
			pointDictionary[event.touchPointID]=point;
			pointObject.point=point;
			
			pointObject.id=count;
			pointObject.touchPointID=event.touchPointID;
			pointArray.push(pointObject);
			
			GestureGlobals.gw_public::points[event.touchPointID]=pointObject;
			
			var localPoint:Point=new Point(event.localX,event.localY);
			localArray.push(localPoint);
			
			local=localFind();
			
			var l:Point=localToGlobal(local);
			
			CX=0-(l.x - findCenterX());
			CY=0-(l.y - findCenterY());
			
			TouchManager.gw_public::registerTouchPoint(pointObject);
			
			if (pointArray.length>1)
			{
				dx=pointArray[0].point.x-pointArray[1].point.x;
				dy=pointArray[0].point.y-pointArray[1].point.y;
				
				dist = Math.sqrt((dx*dx)+(dy*dy));
				
				pointDistance=dist;
				percentWid=100/pointDistance;
				
				currentScale=scaleX;
				currentScaleValue=currentScale;
				
				currentRotation=rotation;
				currentRotate=currentRotation;
				
				var dox=pointArray[0].point.x;
				var doy=pointArray[0].point.y;
				var dox2=pointArray[1].point.x;
				var doy2=pointArray[1].point.y;
				
				var X:Number;
				var Y:Number;
				
				X=dox2-dox;
				Y=doy2-doy;
				
				var value=Math.atan2(Y,X)*(180/Math.PI);
				
				rotationDifference=currentRotation-value;
			}
			
			count++;
		}
		
		public function onTouchMoving(event:TouchEvent):void
		{
			pointDictionary[event.touchPointID].x=event.stageX;
			pointDictionary[event.touchPointID].y=event.stageY;
			
			var l:Point=localToGlobal(local);
			
			x -=  (l.x - findCenterX())+CX;
			y -=  (l.y - findCenterY())+CY;
			
			for (var i:int; i<gestureList.length(); i++)
			{
				if (hasEventListener(gestureList[i].@type))
				{
					var type:String=gestureList[i].@type;
					
					for (var j:int=0; j<gestureList[i].TouchPoints.point.length(); j++)
					{
						if (count==gestureList[i].TouchPoints.point[j])
						{
							var s:String=gestureList[i].property.@type;
							var func=functionDictionary[gestureList[i].calculation.@type.toString()]();
							gestureList[i].value=func[s];
							dispatchEvent(new GestureEvent( gestureList[i].@type, func));							
						}
					}
				}
			}
			
			checkObjectBounds();
			
			// Trace out touch point histories..................................................
			//var length:int=GestureGlobals.gw_public::pointHistory[event.touchPointID].length;
			//trace(GestureGlobals.gw_public::pointHistory[event.touchPointID][length-1].x);
			//..................................................................................
		}
		
		private function checkObjectBounds():void
		{
			if(((x+width)-(width*.10))<0 || x>GestureWorks.application.stageWidth-(width*.10) || ((y+height)-(width*.10))<0 || y>GestureWorks.application.stageHeight-(width*.10))
			{
				TouchManager.removeAllTouchPoints();
				
				dispatchEvent(new Event(GWTouchSprite.OUT_OF_BOUNDS));
			}
		}
		
		private function findScale():Object
		{
			return {
				scaleX:scaleValue(),
				scaleY:scaleValue()
			};
		}
		
		private function findRotation():Object
		{
			return {
				rotation:rotationValue()
			};
		}
		
		private function findDrag():Object
		{
			return {
				x:0,
				y:0
			};
		}
		
		private function rotationValue():Number
		{
			return ( Math.atan2((pointArray[1].point.y-pointArray[0].point.y),(pointArray[1].point.x-pointArray[0].point.x)) * (180/Math.PI) )+rotationDifference;
		}
		
		private function scaleValue():Number
		{
			dist = Math.sqrt((Math.round(pointArray[0].point.x-pointArray[1].point.x)*Math.round(pointArray[0].point.x-pointArray[1].point.x))+(Math.round(pointArray[0].point.y-pointArray[1].point.y)*Math.round(pointArray[0].point.y-pointArray[1].point.y)));
			widthDiff=dist-pointDistance;
			return currentScale+((widthDiff*percentWid)/100);
		}
		
		private function findCenterX():Number
		{
			var value:Number=local.x;
			
			if (pointArray.length>1)
			{
				if (pointArray[0].point.x>pointArray[1].point.x)
				{
					value=(((pointArray[0].point.x-pointArray[1].point.x)/2)+pointArray[1].point.x);
				}
				else
				{
					value=(((pointArray[1].point.x-pointArray[0].point.x)/2)+pointArray[0].point.x);
				}
			}
			else
			{
				value=pointArray[0].point.x;
			}
			
			return value;
		}
		
		private function findCenterY():Number
		{
			var value:Number=local.y;
			
			if (pointArray.length>1)
			{
				if (pointArray[0].point.y>pointArray[1].point.y)
				{
					value=(((pointArray[0].point.y-pointArray[1].point.y)/2)+pointArray[1].point.y);
					
				}
				else
				{
					value=(((pointArray[1].point.y-pointArray[0].point.y)/2)+pointArray[0].point.y);
				}
			}
			else
			{
				value=pointArray[0].point.y;
			}
			
			return value;
		}
		
		private function localFind():Point
		{
			var xValue:Number;
			var yValue:Number;
			
			if (pointArray.length>1)
			{
				if (localArray[0].y>localArray[0].y)
				{
					yValue=(localArray[0].y-localArray[1].y)/2+localArray[1].y;
				}
				else
				{
					yValue=(localArray[1].y-localArray[0].y)/2+localArray[0].y;
				}
				
				if (localArray[0].x>localArray[0].x)
				{
					xValue=(localArray[0].x-localArray[1].x)/2+localArray[1].x;
				}
				else
				{
					xValue=(localArray[1].x-localArray[0].x)/2+localArray[0].x;
				}
			}
			else
			{
				yValue=localArray[0].y;
				xValue=localArray[0].x;
			}
			
			var point:Point=new Point(xValue,yValue);
			
			return point;
		}
		
		public function arrangePointArray(id:int):void
		{
			pointArray.splice(id,1);
			localArray.splice(id,1);
			count--;
			
			for (var i in pointArray)
			{
				pointArray[i].id=i;
				GestureGlobals.gw_public::points[pointArray[i].touchPointID].id=i;
			}
			
			if (localArray.length>0)
			{
				local=localFind();
			}
		}
		
	}
}