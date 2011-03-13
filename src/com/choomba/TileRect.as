package com.choomba
{
	import flash.geom.Rectangle;
	
	public class TileRect extends Rectangle
	{
		private var _collidable:Boolean = false;
		
		public function TileRect(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
		}

		public function get collidable():Boolean
		{
			return _collidable;
		}

		public function set collidable(value:Boolean):void
		{
			_collidable = value;
		}

	}
}