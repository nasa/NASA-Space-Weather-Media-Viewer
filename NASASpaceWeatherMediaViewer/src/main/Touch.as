package main
{
	import main.Extender;
	
	import spark.core.SpriteVisualElement;
	
	public class Touch extends SpriteVisualElement
	{
		public function Touch()
		{
			trace("cool beans");
			var extender:Extender = new Extender();
			addChild(extender);
		}
	}
}