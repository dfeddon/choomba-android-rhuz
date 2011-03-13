package com.choomba.vo
{
	public class TilesetPropertyVO
	{
		private var _name:String;
		private var _value:String;
		
		public function TilesetPropertyVO()
		{
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}


	}
}