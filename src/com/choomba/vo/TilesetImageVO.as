package com.choomba.vo
{
	public class TilesetImageVO
	{
		private var _source:String;
		
		public function TilesetImageVO(xml:XML)
		{
			if (xml)
				_source = xml.@source;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
		}

	}
}