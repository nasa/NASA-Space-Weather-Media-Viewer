package id.utils
{
	public class StringTrim
	{
		public static var amountToStay:Number=50;
		public static var dotString:String="......"
		
		public static function stringTrim(value:String):String
		{
			var myStr:String;
			var char:Array = value.split("");
			var idx:Number = value.length-amountToStay;
			
			myStr=value;
			
			if(amountToStay<value.length)
			{
				char.splice(amountToStay,idx);
				myStr = char.join("");
				value=myStr+dotString;
			}
			
			return value;
		}
	}
}