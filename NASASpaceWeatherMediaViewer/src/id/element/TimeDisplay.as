package id.element
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import id.core.GWTouchSprite;
	//import id.element.TextDisplay;

	/**
	 * This is the TimeDisplay class for the Control Buttons.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class TimeDisplay extends Sprite
	{
		private var _initialized:Boolean;
		private var background:Shape;
		private var textFormat:TextFormat;
		private var font:Font;
		private var txt:TextField;
		private var _text:String="00:00";
		private var _width:Number;
		private var _height:Number;

		private var _style:Object=
		{
		buttonRadius:21,
		buttonColorPassive:0x000000,
		buttonColorActive:0x966540,
		buttonOutlineStroke:2,
		buttonOutlineColor:0xc3aa7b,
		buttonSymbolColor:0xFFFFFF,
		timeFontSize:11
		};

		public function TimeDisplay()
		{
			super();
			createUI();
			commitUI();
			layoutUI();
			updateUI();

			_initialized=true;
		}

		public function Dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width=value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height=value;
		}

		public function get styleList():Object
		{
			return _style;
		}
		public function set styleList(value:Object):void
		{
			if (! value)
			{
				return;
			}

			if (value.buttonRadius!=undefined&&value.buttonRadius!="")
			{
				_style.buttonRadius=value.buttonRadius;
			}

			if (value.buttonColorPassive!=undefined&&value.buttonColorPassive!="")
			{
				_style.buttonColorPassive=value.buttonColorPassive;
			}

			if (value.buttonColorActive!=undefined&&value.buttonColorActive!="")
			{
				_style.buttonColorActive=value.buttonColorActive;
			}

			if (value.buttonOutlineStroke!=undefined&&value.buttonOutlineStroke!="")
			{
				_style.buttonOutlineStroke=value.buttonOutlineStroke;
			}

			if (value.buttonOutlineColor!=undefined&&value.buttonOutlineColor!="")
			{
				_style.buttonOutlineColor=value.buttonOutlineColor;
			}

			if (value.buttonSymbolColor!=undefined&&value.buttonSymbolColor!="")
			{
				_style.buttonSymbolColor=value.buttonSymbolColor;
			}
			
			if (value.timeFontSize!=undefined&&value.timeFontSize!="")
			{
				_style.timeFontSize=value.timeFontSize;
			}
			
			layoutUI()
			updateUI();
		}

		public function get buttonRadius():Object
		{
			return _style.buttonRadius;
		}
		public function set buttonRadius(value:Object):void
		{
			_style.buttonRadius=value;
			layoutUI()
			updateUI();
		}

		public function get buttonColorPassive():Object
		{
			return _style.buttonColorPassive;
		}
		public function set buttonColorPassive(value:Object):void
		{
			_style.buttonColorPassive=value;
			layoutUI()
			updateUI();
		}

		public function get buttonColorActive():Object
		{
			return _style.buttonColorActive;
		}
		public function set buttonColorActive(value:Object):void
		{
			_style.buttonColorActive=value;
			layoutUI()
			updateUI();
		}

		public function get buttonOutlineStroke():Object
		{
			return _style.buttonOutlineStroke;
		}
		public function set buttonOutlineStroke(value:Object):void
		{
			_style.buttonOutlineStroke=value;
			layoutUI()
			updateUI();
		}

		public function get buttonOutlineColor():Object
		{
			return _style.buttonOutlineColor;
		}
		public function set buttonOutlineColor(value:Object):void
		{
			_style.buttonOutlineColor=value;
			layoutUI()
			updateUI();
		}

		public function get buttonSymbolColor():Object
		{
			return _style.buttonSymbolColor;
		}
		public function set buttonSymbolColor(value:Object):void
		{
			_style.buttonSymbolColor=value;
			layoutUI()
			updateUI();
		}
		
		public function get timeFontSize():Object
		{
			return _style.timeFontSize;
		}
		public function set timeFontSize(value:Object):void
		{
			_style.timeFontSize=value;
			layoutUI()
			updateUI();
		}
		
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text=value;
			layoutUI()
			updateUI();
		}

		protected function createUI():void
		{
			background = new Shape();
			textFormat = new TextFormat();
			txt = new TextField();
			//font = new Arial();
			addChild(background)
			addChild(txt);
		}

		protected function commitUI():void
		{
			
		}

		protected function layoutUI():void
		{			
			//textFormat.font = font.fontName;
			textFormat.color=_style.buttonSymbolColor;
			textFormat.size=_style.timeFontSize;
			textFormat.align = TextFormatAlign.CENTER;
			
			//txt.embedFonts = true;
			txt.defaultTextFormat = textFormat;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = _text;
			txt.blendMode = BlendMode.LAYER;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.CENTER;
		}

		protected function updateUI():void
		{
			txt.text=_text;
			
			background.graphics.clear();
			//background.graphics.lineStyle(_style.buttonOutlineStroke,_style.buttonOutlineColor,1);
			background.graphics.beginFill(_style.buttonColorPassive,0);
			background.graphics.drawRect(0,0,txt.textWidth+15,27);
			background.graphics.endFill();
			
			txt.width=background.width;
			txt.height=txt.textHeight;
			
			txt.y=(background.height-txt.height)/2-1;
			
			width=background.width;
			height=background.height;
		}
	}
}