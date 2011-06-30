package id.utils
{
	import flash.display.Shape;

	public class DebugPoint extends Shape
	{

		public function DebugPoint()
		{
			super();

			graphics.clear();
			graphics.lineStyle(2,0xFFFFFF,1);

			var x1:Number=0;
			var y1:Number=0;
			var x2:Number=0;
			var y2:Number=0;
			var radius:Number=24;
			var accuracy:Number=8;
			var span:Number=Math.PI/accuracy;
			var controlRadius:Number=radius/Math.cos(span);
			var anchorAngle:Number=0;
			var controlAngle:Number=0;
			var depth:Number=0;

			x1=x+Math.cos(anchorAngle)*radius;
			y1=y+Math.sin(anchorAngle)*radius;

			graphics.moveTo(x1,y1);

			for (var i:int=0; i<accuracy; i++)
			{
				controlAngle=anchorAngle+span;
				anchorAngle=controlAngle+span;

				x1=x+Math.cos(controlAngle)*controlRadius;
				y1=y+Math.sin(controlAngle)*controlRadius;
				x2=x+Math.cos(anchorAngle)*radius;
				y2=y+Math.sin(anchorAngle)*radius;

				graphics.curveTo(x1,y1,x2,y2);
			}
		}
	}
}