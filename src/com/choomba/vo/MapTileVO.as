package com.choomba.vo
{
	public class MapTileVO
	{
		private var _gid:int;
		private var _properties:Array;
		
		public function MapTileVO(xml:XML=null)
		{
			var mapTileProperty:MapTilePropertyVO;
			
			_properties = new Array();
			
			if (xml)
			{
				_gid = xml.@gid;
				
				if (xml.property)
				{
					for each(var prop:XML in xml.property)
					{
						mapTileProperty = new MapTilePropertyVO(prop);
						properties.push(mapTileProperty);
					}
				}
			}
		}

		public function get gid():int
		{
			return _gid;
		}

		public function set gid(value:int):void
		{
			_gid = value;
		}

		public function get properties():Array
		{
			return _properties;
		}

		public function set properties(value:Array):void
		{
			_properties = value;
		}


	}
}