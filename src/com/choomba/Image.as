package com.choomba
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class Image extends Bitmap
	{
		private var _cacheBitmap:Boolean;
		private var _cacheBitmapMatrix:Boolean;
		
		public function Image(bitmapData:BitmapData=null, cache:Boolean=false, cacheMatrix:Boolean=false)
		{
			super(bitmapData);
			
			cacheBitmap = cache;
			cacheBitmapMatrix = cacheMatrix;

			//smoothing = true;
			//cacheAsBitmap = true;
			//cacheAsBitmapMatrix = new Matrix();
		}

		public function get cacheBitmap():Boolean
		{
			return _cacheBitmap;
		}

		public function set cacheBitmap(value:Boolean):void
		{
			_cacheBitmap = value;
			
			cacheAsBitmap = value;
		}

		public function get cacheBitmapMatrix():Boolean
		{
			return _cacheBitmapMatrix;
		}

		public function set cacheBitmapMatrix(value:Boolean):void
		{
			_cacheBitmapMatrix = value;
			
			cacheAsBitmapMatrix = transform.concatenatedMatrix;
		}


	}
}