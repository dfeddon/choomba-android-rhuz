package com.choomba.vo
{
	public class TileVO
	{
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
		private var _collidable:Boolean = false;
		
		public function TileVO(xpos:int, ypos:int, tileWidth:int, tileHeight:int, isCollidable:Boolean=false)
		{
			_x = xpos;
			_y = ypos;
			_width = tileWidth;
			_height = tileHeight;
			_collidable = isCollidable;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
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