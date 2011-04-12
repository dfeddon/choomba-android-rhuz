package com.choomba
{
	import com.choomba.Studio;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class TileBackground extends Image
	{
		private var _bmd:BitmapData;
		private var _repeatV:Boolean;
		private var _repeatH:Boolean;
		
		public function TileBackground(img:BitmapData=null, tileVert:Boolean=true, tileHoriz:Boolean=true)
		{
			super();
			
			this.cacheAsBitmap = true;
			this.cacheAsBitmapMatrix = new Matrix();
			
			bmd = img;
			repeatH = tileHoriz;
			repeatV = tileVert;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void
		{
			var lot:Lot = Studio.currentLot;
			
			var cols:int = Math.ceil(lot.width / bmd.width);
			var rows:int = Math.ceil(lot.height / bmd.height);
			var tiles:int = cols * rows;
			
			var col:int = 0;
			var row:int = 0;

			for (var tile:uint = 0; tile < tiles; tile++)
			{
				var img:Image = lot.addChild(new Image(bmd)) as Image;
				
				img.x = Math.floor(col);
				img.y = Math.floor(row);
				
				col += bmd.width;
				
				if (col + bmd.width > (cols * bmd.width))
				{
					// add new row
					row += bmd.height;
					
					// reset col
					col = 0;
				}
			}
		}
		
		public function get repeatV():Boolean
		{
			return _repeatV;
		}
		
		public function set repeatV(value:Boolean):void
		{
			_repeatV = value;
		}
		
		public function get repeatH():Boolean
		{
			return _repeatH;
		}
		
		public function set repeatH(value:Boolean):void
		{
			_repeatH = value;
		}

		public function get bmd():BitmapData
		{
			return _bmd;
		}

		public function set bmd(value:BitmapData):void
		{
			_bmd = value;
		}


	}
}