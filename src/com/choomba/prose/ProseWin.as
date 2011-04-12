package com.choomba.prose
{
	import com.choomba.Studio;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ProseWin extends Sprite
	{
		public function ProseWin()
		{
			super();
			
			//mouseEnabled = false;
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			trace(' --> ',Studio.player.x, Studio.player.y);
		}
		
		public function addProse(txt:String):void
		{
			trace(' --> ',Studio.player.x, Studio.player.y);
			
			// add end text padding
			txt += '<br><br><br>                          •  •  •<br><br>';
			
			var _bx:int;
			
			var _bw:int = (stage.fullScreenWidth - 100) / 2;
			var _bh:int = stage.fullScreenHeight - 50;
			//var _bx:int = 5;
			var _by:int = 50;
			var _buf:int = 5;
			
			if (Studio.player.x < stage.fullScreenWidth)
				_bx = stage.fullScreenWidth - _bw - _buf;
			else _bx = _bx = 0 + _buf;
					
			
			var tf:TextField = new TextField();
			tf.addEventListener(MouseEvent.CLICK, clickHandler);
			var f:TextFormat = new TextFormat();
			//tf.mouseEnabled = false;
			tf.x = _bx + _buf;
			tf.y = _by + _buf;
			tf.width = _bw - (_buf * 2);
			tf.height = _bh - (_buf * 2);
			tf.wordWrap = true;
			tf.multiline = true;
			tf.htmlText = txt;
			tf.textColor = 0xffffff;
			f.size = 22;
			tf.setTextFormat(f);
			addChild(tf);
			
			graphics.lineStyle(2, 0x828282, .25);
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(_bx,_by, _bw, tf.height);
			graphics.endFill();
		}
	}
}