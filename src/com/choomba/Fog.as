package com.choomba
{
	import com.dfeddon.rhuz.Player;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.getInvocationCount;

	public class Fog extends Sprite 
	{
		public static const TYPE_FOG_OF_WAR:String = 'typeFogOfWar';
		public static const TYPE_STATIC_LIGHT:String = 'typeStaticLight';
		public static const TYPE_STATIC_LIGHT_RECT:String = 'typeStaticLightRect';
		private static const DARKNESS_BLOCK_SIZE:int = 384;
		
		public static const FOG_WINDOW:int = 250;
		private static var fogMask:Bitmap;
		
		private var matrix:Matrix;// = new Matrix();
		private var eMatrix:Matrix;
		private var wMatrix:Matrix;
		private var nMatrix:Matrix;
		private var sMatrix:Matrix;
		private var aMatrix:Matrix;
		
		private var c:Bitmap;
		private var cE:Bitmap;
		private var cW:Bitmap;
		private var cN:Bitmap;
		private var cS:Bitmap;
		private var alt:Bitmap;

		public function Fog():void 
		{
			// disable mouse event handling
			mouseEnabled = false;
			
			var dark:Bitmap;
			var maxW:int = Math.floor(Studio.currentLot.width / DARKNESS_BLOCK_SIZE);
			var maxH:int = Math.floor(Studio.currentLot.height / DARKNESS_BLOCK_SIZE);
			
			var h:int = Studio.DEFAULT_TILE_HEIGHT * Studio.DEFAULT_LOT_COLUMNS;
			var w:int = Studio.DEFAULT_TILE_WIDTH * Studio.DEFAULT_LOT_ROWS;

			var circle:Shape = new Shape();
			
			var dx:Number = 0;
			var dy:Number = 0;
			
			for (var hor:uint = 0; hor < maxW; hor++)
			{
				for (var i:uint = 0; i < maxH; i++)
				{
					dark = new Bitmap(new BitmapData(DARKNESS_BLOCK_SIZE, DARKNESS_BLOCK_SIZE, 
						true, 0xff000000));
					//dark.blendMode = BlendMode.LAYER;
					dark.x = dx;
					dark.y = dy;
					addChild(dark);
					
					//dx += 384;
					dy += DARKNESS_BLOCK_SIZE;
					//trace(dy, h);
				}
				
				dx += DARKNESS_BLOCK_SIZE
				dy = 0; // reset
			}

			circle.graphics.beginFill(0xffffff, 1);
			circle.graphics.drawEllipse(0, 0, FOG_WINDOW, FOG_WINDOW);
			fogMask = new Bitmap(new BitmapData(FOG_WINDOW, FOG_WINDOW, true, 0));
			fogMask.bitmapData.draw(circle);
			/*fogMask.filters = [new GlowFilter(0, 1, 32.0, 32.0, 4,
			BitmapFilterQuality.LOW, false, false)];*/
			//fogMask.blendMode = BlendMode.LAYER;
			
			matrix = new Matrix();
			matrix.a = 1;
			matrix.b = 0;
			matrix.c = 0;
			matrix.d = 1;
		}
		
		public function update():void 
		{
			var p:Player = Studio.player;
			
			var ix:int = Math.floor(p.x / DARKNESS_BLOCK_SIZE);
			var iy:int = Math.floor(p.y / DARKNESS_BLOCK_SIZE);
			
			var xOffset:int = Math.round(DARKNESS_BLOCK_SIZE * ix);
			var yOffset:int = Math.round(DARKNESS_BLOCK_SIZE * iy);
			
			var mult:int = Math.floor(Studio.currentLot.width / DARKNESS_BLOCK_SIZE);
			var ind:int = (ix * mult) + iy;
			
			c = getChildAt(ind) as Bitmap;
			
			c.bitmapData.lock();
			
			matrix.tx = Math.round(p.x - (FOG_WINDOW / 2) - xOffset);//(DARKNESS_BLOCK_SIZE * ix));
			matrix.ty = Math.round(p.y - (FOG_WINDOW / 2) - yOffset);//(DARKNESS_BLOCK_SIZE * iy));// + (FOG_WINDOW / 2));
			
			switch(Studio.DYNAMIC_LIGHTING_TYPE)
			{
				case TYPE_STATIC_LIGHT:
					
					c.bitmapData.fillRect(c.bitmapData.rect, 0xff000000);
					
					c.bitmapData.draw(fogMask, 
						matrix,
						null, 
						BlendMode.ERASE
					);
					
					break;
					
				case TYPE_FOG_OF_WAR:
					//////////////////////////////////////////////////
					// reveal current block
					//////////////////////////////////////////////////
					c.bitmapData.draw(fogMask, matrix, null, BlendMode.ERASE);
					
					var diff:int;
					
					//////////////////////////////////////////////////
					// reveal block east
					//////////////////////////////////////////////////
					if ( (p.x + (FOG_WINDOW / 2) - xOffset) > c.width )
					{
						diff = Math.round(p.x + (FOG_WINDOW / 2) - c.width); 
						
						// check if last block
						if (ind + mult > numChildren) break;
						
						eMatrix = matrix.clone();
						eMatrix.tx = Math.round(diff - (FOG_WINDOW + xOffset));
						
						cE = getChildAt(ind + mult) as Bitmap;
						cE.bitmapData.draw(fogMask, eMatrix, null, BlendMode.ERASE);
					}
					else cE = null;
					
					//////////////////////////////////////////////////
					// reveal block west
					//////////////////////////////////////////////////
					if ( (p.x - (FOG_WINDOW / 2) - xOffset) < 0 )
					{
						diff = Math.round(p.x - (FOG_WINDOW / 2) + c.width); 
						
						// check if last block
						if (ind - mult < 0) break;
						
						wMatrix = matrix.clone();
						wMatrix.tx = Math.round(diff-xOffset);
						
						cW = getChildAt(ind - mult) as Bitmap;
						cW.bitmapData.draw(fogMask, wMatrix, null, BlendMode.ERASE);
					}
					else cW = null;
					
					//////////////////////////////////////////////////
					// reveal block south
					//////////////////////////////////////////////////
					if ( (p.y + (FOG_WINDOW / 2) - yOffset) > c.height )
					{
						diff = Math.round(p.y + (FOG_WINDOW / 2) - yOffset) - DARKNESS_BLOCK_SIZE; 
						
						// check if last block
						if (ind + 1 > numChildren) break;
						
						sMatrix = matrix.clone();
						sMatrix.ty = Math.round(diff - (FOG_WINDOW));
						
						cS = getChildAt(ind + 1) as Bitmap;
						cS.bitmapData.draw(fogMask, sMatrix, null, BlendMode.ERASE);
						
						// if east or west blocks exposed, include these
						if (cE)
						{
							alt = getChildAt(ind + 1 + mult) as Bitmap;
							aMatrix = sMatrix.clone();
							aMatrix.tx = eMatrix.tx;
							alt.bitmapData.draw(fogMask, aMatrix, null, BlendMode.ERASE);
						}
						else if (cW)
						{
							alt = getChildAt(ind + 1 - mult) as Bitmap;
							aMatrix = sMatrix.clone();
							aMatrix.tx = wMatrix.tx;
							alt.bitmapData.draw(fogMask, aMatrix, null, BlendMode.ERASE);
						}
					}
					else cS = null;
					
					//////////////////////////////////////////////////
					// reveal block north
					//////////////////////////////////////////////////
					//trace(':', p.y + FOG_WINDOW / 2, yOffset, c.height);
					
					/*if ( (p.y + (FOG_WINDOW / 2) - yOffset) > c.height )
					{
						diff = Math.round(p.y + (FOG_WINDOW / 2) - yOffset) - DARKNESS_BLOCK_SIZE; 
						
						// check if last block
						if (ind + 1 > numChildren) break;
						
						sMatrix = matrix.clone();
						sMatrix.ty = Math.round(diff - (FOG_WINDOW));
						
						cS = getChildAt(ind + 1) as Bitmap;
						cS.bitmapData.draw(fogMask, sMatrix, null, BlendMode.ERASE);
						
						// if east or west blocks exposed, include these
						if (cE)
						{
							alt = getChildAt(ind + 1 + mult) as Bitmap;
							aMatrix = sMatrix.clone();
							aMatrix.tx = eMatrix.tx;
							alt.bitmapData.draw(fogMask, aMatrix, null, BlendMode.ERASE);
						}
						else if (cW)
						{
							alt = getChildAt(ind + 1 - mult) as Bitmap;
							aMatrix = sMatrix.clone();
							aMatrix.tx = wMatrix.tx;
							alt.bitmapData.draw(fogMask, aMatrix, null, BlendMode.ERASE);
						}
					}
					else cS = null;*/
					
					break;
			}
			
			c.bitmapData.unlock();
		}		
	}
}