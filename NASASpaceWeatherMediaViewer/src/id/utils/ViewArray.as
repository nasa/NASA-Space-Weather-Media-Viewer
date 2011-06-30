package id.utils
{
	import spark.components.View;
	
	import views.*;
	
	public class ViewArray
	{
		public static var liveViewsArray:Array = [LiveViewsView,TheSunLiveView,SolarWindView,AurorasView];
		public static var visualizationsArray:Array=[VisualizationsView,SunVisualView,AuroraVisualView];
		public static var videosViewArray:Array=[VideosView,SunVideoView,SolarWindVideoView,MagnetosphereVideoView,AuroraVideoView,HeliosphereVideoView,MissionsVideoView];
		public static var moreViewArray:Array=[MoreView,SavedView,NasaMissionView,AboutView];
		
		public static var liveViewsIndex:int;
		public static var visualizationsIndex:int;
		public static var videosViewIndex:int;
		public static var moreViewIndex:int;
		
		public static var indexArray:Array=[liveViewsIndex,visualizationsIndex,videosViewIndex,moreViewIndex];
		public static var buttonBarArray:Array = [liveViewsArray, visualizationsArray, videosViewArray, moreViewArray];
		
		public static function newView(value:int):Class
		{
			var viewIndex:int=indexArray[value];
						
			return buttonBarArray[value][viewIndex];
		}
	}
}