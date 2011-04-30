package com.choomba.prose
{
	import com.choomba.Studio;
	import com.choomba.components.CloseButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ProseWin extends Sprite
	{
		public static const POS_LEFT:String = 'posLeft';
		public static const POS_RIGHT:String = 'posRight';
		
		public var pos:String;
		
		public function ProseWin()
		{
			super();
			
			//mouseEnabled = false;
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(TouchEvent.TOUCH_BEGIN, touchHandler);
			addEventListener(TouchEvent.TOUCH_END, touchHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			trace(' --> ',Studio.player.x, Studio.player.y);
		}
		
		private function touchHandler(e:TouchEvent):void			
		{
			e.stopImmediatePropagation();
			
			trace('touch!');
		}
		
		public function addProse(txt:String):void
		{
			trace(' --> ',Studio.player.x, Studio.player.y);
			
			var _txt:String;
			
			// add end text padding
			_txt = '<br>';//                          •  •  •<br><br>';
			_txt += txt + '<br><br>                          •  •  •<br><br>';
			
			var _bx:int;
			
			var _bw:int = (stage.fullScreenWidth - 100) / 2;
			var _bh:int = stage.fullScreenHeight - 50;
			//var _bx:int = 5;
			var _by:int = 50;
			var _buf:int = 5;
			
			if (Studio.player.x < stage.fullScreenWidth)
			{
				_bx = stage.fullScreenWidth - _bw - _buf;
				pos = POS_RIGHT;
			}
			else
			{
				_bx = _bx = 0 + _buf;
				pos = POS_LEFT;
			}
					
			
			var tf:TextField = new TextField();
			tf.addEventListener(MouseEvent.CLICK, clickHandler);
			var f:TextFormat = new TextFormat();
			//tf.mouseEnabled = false;
			tf.x = _bx + _buf;
			tf.y = _by + _buf + 10;
			tf.width = _bw - (_buf * 2);
			tf.height = _bh - (_buf * 2);
			tf.wordWrap = true;
			tf.multiline = true;
			tf.htmlText = _txt;
			tf.textColor = 0xffffff;
			f.size = 22;
			tf.setTextFormat(f);
			addChild(tf);
			
			graphics.lineStyle(2, 0x828282, .25);
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(_bx,_by, _bw, tf.height);
			graphics.endFill();
			
			// close button
			var close:Sprite = addChild(new CloseButton) as Sprite;
			if (Studio.player.x < stage.fullScreenWidth)
				close.x = _bx;
			else close.x = _bx + _bw;
			close.y = _by;
			close.addEventListener(MouseEvent.CLICK, closeClickHandler);
		}
		
		private function closeClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			parent.removeChild(this);
		}
		
		public function removeProse():void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(TouchEvent.TOUCH_BEGIN, touchHandler);
			removeEventListener(TouchEvent.TOUCH_END, touchHandler);
		}
	}
}