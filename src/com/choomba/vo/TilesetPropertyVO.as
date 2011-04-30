package com.choomba.vo
{
	public class TilesetPropertyVO
	{
		public static const TAKEABLE:String = 'takeable';
		
		private var _name:String;
		private var _value:*;
		
		public function TilesetPropertyVO()
		{
		}
		
		private function strToBool(str:String):Boolean
		{
			var bool:Boolean = false;
			
			if (str.toLowerCase() == 'true')
				bool = true;
			
			return bool;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get value():*
		{
			switch(_name)
			{
				case TAKEABLE:
					_value = strToBool(_value);
					break;
			}
			
			return _value;
			
		}

		public function set value(value:String):void
		{
			_value = value;
		}


	}
}