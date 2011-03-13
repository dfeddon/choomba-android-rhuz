package com.choomba
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class DynamicLighting extends Sprite
	{
		public static const TYPE_FOG_OF_WAR:String = 'typeFogOfWar';
		public static const TYPE_STATIC_LIGHT:String = 'typeStaticLight';
		public static const TYPE_STATIC_LIGHT_RECT:String = 'typeStaticLightRect';
		
		private var _typeOfLight:String;
		
		private var fogCanvas:Shape;
		
		public function DynamicLighting(type:String, width:int, height:int, fogAlpha:Number=NaN)
		{
			blendMode = BlendMode.LAYER;
			
			if (isNaN(fogAlpha))
				fogAlpha = Studio.DYNAMIC_LIGHTING_FOG_ALPHA;

			graphics.beginFill(0x000000);
			graphics.drawRect(0,0, width, height);
			graphics.endFill();
			//blendMode = BlendMode.SUBTRACT;

			fogCanvas = new Shape();
			_typeOfLight = type;
			addChild(fogCanvas);
		}
		
		public function drawVisibleRegion(xPos:Number, yPos:Number, width:int, height:int):void
		{
			//var image:Sprite;
			
			switch(_typeOfLight)
			{
				case TYPE_FOG_OF_WAR:
					fogCanvas.graphics.beginFill(0x000000, 1);//, fogAlpha);//new Rectangle(0, 0, width, height), 0xFFFFFF, fogAlpha);
					fogCanvas.graphics.drawCircle(xPos, yPos, width);
					fogCanvas.graphics.endFill();
					
					//graphics.beginBitmapFill(AssetManager.getInstance().playerImg);// .drawGraphicsData(image);
					fogCanvas.blendMode = BlendMode.ERASE;
					break;
				
				case TYPE_STATIC_LIGHT:
					//image = new Image(AssetManager.getInstance().staticLightImg);
					break;
				
				case TYPE_STATIC_LIGHT_RECT:
					//fogCanvas.fill(new Rectangle(xPos, yPos, width, height), 0x000000, Game.DYNAMIC_LIGHTING_REVEAL_ALPHA);
					return;
			}

			//fogCanvas.drawGraphic(xPos, yPos, image);
		}

		public function get typeOfLight():String
		{
			return _typeOfLight;
		}

		public function set typeOfLight(value:String):void
		{
			_typeOfLight = value;
		}

		
	}
	
}