package com.choomba
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.flintparticles.common.displayObjects.Rect;
	
	public class AbstractPopup extends Sprite
	{
		private static const CORNER_RADIUS:int = 10;
		private static const DEFAULT_OFFSET_X:int = 15;
		private static const DEFAULT_OFFSET_Y:int = 15;
		
		public function AbstractPopup(xOffset:int, yOffset:int)
		{
			super();
			
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
			
			var x:TextField = new TextField();
			x.text = 'X';
			x.textColor = 0xffffff;
			var close:DisplayObject = addChild(x);
			close.x = w;// - x.width;
			close.y = yOffset;// + x.height;
		}
		
		protected function closePopup():void
		{
			parent.removeChild(this);
			
			Studio.currentLot.active = true;
		}
	}
}