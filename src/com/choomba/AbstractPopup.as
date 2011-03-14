package com.choomba
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flintparticles.common.displayObjects.Rect;
	
	public class AbstractPopup extends Sprite
	{
		private static const CORNER_RADIUS:int = 10;
		private static const DEFAULT_OFFSET_X:int = 15;
		private static const DEFAULT_OFFSET_Y:int = 15;
		
		protected var _xOffset:int;
		protected var _yOffset:int;
		
		public function AbstractPopup(xOffset:int, yOffset:int)
		{
			super();
			
			Studio.player.active = false;
			
			_xOffset = xOffset;
			_yOffset = yOffset;
			
			Studio.studio.addChild(this);
			
			if (xOffset < 1)
				xOffset = DEFAULT_OFFSET_X;
			if (yOffset < 1)
				yOffset = DEFAULT_OFFSET_Y;
			
			var w:int = stage.stageWidth - (xOffset * 2);
			var h:int = stage.stageHeight - (yOffset * 2);
			
			// frame
			this.graphics.beginFill(0x000000, .85);
			this.graphics.lineStyle(1, 0xffffff, 1);
			this.graphics.drawRoundRect(xOffset, yOffset, w, h, CORNER_RADIUS);
			this.graphics.endFill();
			
			// close circle
			var cir:Sprite = new Sprite();
			cir.graphics.beginFill(0x000000, 1);
			cir.graphics.lineStyle(3, 0xffffff);
			cir.graphics.drawCircle(w + 5, yOffset+5, 20);
			cir.graphics.endFill();
			addChild(cir);
			
			var x:TextField = new TextField();
			var xf:TextFormat = new TextFormat();
			xf.size = 25;
			x.text = 'X';
			x.selectable = false;
			x.textColor = 0xffffff;
			x.setTextFormat(xf);
			var close:DisplayObject = addChild(x);
			close.x = w - 5;
			close.y = yOffset - 12;// + x.height;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		protected function touchBeginHandler(e:TouchEvent):void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function touchEndHandler(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			
			if (e.localX > (stage.stageWidth - _xOffset - 50)
				&& e.localY < (_yOffset + 50))
			{
				e.stopImmediatePropagation();
				
				closePopup();
				//Studio.player.pSplash.remove();
			}
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			if (e.localX > (stage.stageWidth - _xOffset - 50)
				&& e.localY < (_yOffset + 50))
			{
				e.stopImmediatePropagation();
				
				closePopup();
				//Studio.player.pSplash.remove();
			}
		}
		
		protected function closePopup():void
		{
			trace('closing popup!');
			removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			
			parent.removeChild(this);
			
			Studio.player.pSplash.remove();
			//Studio.currentLot.active = true;
		}
	}
}