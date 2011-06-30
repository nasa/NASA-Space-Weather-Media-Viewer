package id.core
{
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import id.core.gw_public;
	import id.utils.TouchPointID;

	public class GestureGlobals
	{		
		gw_public static var points:Dictionary = new Dictionary();
		
		gw_public static var pointHistory:Dictionary = new Dictionary();
		
		public static var btnBarHeight:Number=0;
		
		public static var stage:Stage;
		

		//  historyCaptureLength -------------------------------------
		private static var _historyCaptureLength:int=10;//int.MAX_VALUE
		public static function get historyCaptureLength():int
		{
			return _historyCaptureLength;
		}
		public static function set historyCaptureLength(value:int):void
		{
			_historyCaptureLength=value;
		}
		
		
		//  debugPoints ---------------------------------------------
		private static var _debugPoints:Boolean=false;
		public static function get debugPoints():Boolean
		{
			return _debugPoints;
		}
		public static function set debugPoints(value:Boolean):void
		{
			_debugPoints=value;
		}
		
		
		//  objectCount -------------------------------------
		private static var _objectCount:int;
		public static function get objectCount():int
		{
			return _objectCount;
		}
		gw_public static function set objectCount(value:int):void
		{
			_objectCount=value;
		}


		//  gwPointID -----------------------------------------------
		public static function get gwPointID():int
		{
			return TouchPointID.gwPointID;
		}
		gw_public static function set gwPointID(value:int):void
		{
			TouchPointID.gwPointID=value;
		}
		
		
		//  pointList -----------------------------------------------
		private static var _pointList:Array=[];
		public static function get pointList():Array
		{
			return _pointList;
		}
		gw_public static function set pointList(value:Array):void
		{
			_pointList=value;
		}
		
		
		//  pointClusterList -----------------------------------------------
		private static var _pointClusterList:Array=[];
		public static function get pointClusterList():Array
		{
			return _pointClusterList;
		}
		gw_public static function set pointClusterList(value:Array):void
		{
			_pointClusterList=value;
		}
	}
}