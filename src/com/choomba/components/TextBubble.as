package com.choomba.components
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TextBubble extends Sprite
	{
		private static const CORNER_RADIUS:int = 10;
		private static const FIXED_WIDTH:int = 250;
		// display objects
		private var background:Sprite;
		private var textField:TextField;
		private var point:Point;
		private var container:Sprite;
		
		private var isRemovable:Boolean = false;
		
		// properties
		private var _text:String;
		
		public function TextBubble(container:Sprite, point:Point, text:String)
		{
			super();
			
			buttonMode = true;
			
			this.text = text;
			this.point = point;
			this.container = container;
			
			background = new Sprite;
			addChild(background);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 14;
			
			textField = new TextField;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.width = FIXED_WIDTH - 10;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = text;
			textField.setTextFormat(textFormat);
			textField.selectable = false;
			textField.mouseEnabled = false;
			
			var displayText:DisplayObject = addChild(textField);
			displayText.x += 5;
			displayText.y += 5;
			
			var displayObject:DisplayObject = container.addChildAt(this, container.numChildren - 1);
			displayObject.x = point.x - (width / 2);
			displayObject.y = point.y - (height / 2);

			display();
		}
		
		private function display():void
		{
			//textField.text = _text;
			
			var g:Graphics = background.graphics;
			g.clear();
			g.lineStyle(0, 0x0);
			g.beginFill(0xFFFFFF);
			g.drawRoundRect(0, 0, FIXED_WIDTH, textField.height + 10, CORNER_RADIUS);
			trace('bg', point.x, point.y);
		}
		
		public function remove():void
		{
			container.removeChild(this);
		}
		
		public function set text(newText:String):void
		{
			_text = newText;
		}
		
		public function get text():String
		{
			return _text;
		}
		
	}
}