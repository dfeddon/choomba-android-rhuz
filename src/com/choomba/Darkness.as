package com.choomba
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	public class Darkness extends Sprite
	{
		public function Darkness()
		{
			super();

			//darkness.createGraphic(FlxG.width, FlxG.height, 0xff000000);
			//darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			//darkness.blend = "multiply"
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0, Studio.currentLot.width, 300);
			graphics.endFill();
			
			blendMode = BlendMode.MULTIPLY;
		}
	}
}