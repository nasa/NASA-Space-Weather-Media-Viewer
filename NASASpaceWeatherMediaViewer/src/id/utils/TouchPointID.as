package id.utils
{
	import flash.display.Sprite;

	public class TouchPointID extends Sprite
	{
		
		private static var _gwPointID:int;
		public static function get gwPointID():int
		{
			return _gwPointID;
		}
		public static function set gwPointID(value:int):void
		{
			_gwPointID=value; 
		}

	}
}