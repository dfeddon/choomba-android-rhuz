package com.choomba.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CloseButton extends Sprite
	{
		public function CloseButton()
		{
			super();
			
			graphics.drawRect(0,0, 20, 20);
			// close circle
			graphics.beginFill(0x000000, 1);
			graphics.lineStyle(3, 0xffffff);
			graphics.drawCircle(5, 5, 20);
			graphics.endFill();
			//addChild(cir);
			
			var x:TextField = new TextField();
			var xf:TextFormat = new TextFormat();
			xf.size = 25;
			x.text = 'X';
			x.selectable = false;
			x.textColor = 0xffffff;
			x.setTextFormat(xf);
			var close:DisplayObject = addChild(x);
			close.x = -5;
			close.y = -12;// + x.height;
			
			width = 80;
			height = 80;
			
			/*addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);*/
		}
		/*protected function touchBeginHandler(e:TouchEvent):void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function touchEndHandler(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			
			if (e.localX > (stage.stageWidth - 50)
				&& e.localY < (50))
			{
				e.stopImmediatePropagation();
				
				//closePopup();
			}
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			if (e.localX > (stage.stageWidth - 50)
				&& e.localY < (50))
			{
				e.stopImmediatePropagation();
				
				//closePopup();
			}
		}*/
	}
}