package com.choomba.vo
{
	public class MapLayerVO
	{
		private var _name:String;
		private var _width:int;
		private var _height:int;
		private var _properties:Array;
		private var _data:Array;
		private var _tiles:Array;
		
		public function MapLayerVO(xml:XML=null)
		{
			var mapTile:MapTileVO;
			
			_properties = new Array();
			_data = new Array();
			_tiles = new Array();
			
			if (xml)
			{
				name = xml.@name;
				width = xml.@width;
				height = xml.@height;
				
				var propVO:MapLayerPropertyVO;
				for each (var prop:XML in xml.properties)
				{
					propVO = new MapLayerPropertyVO(prop);
					
					properties.push(propVO);
				}
				
				// add tiles (data)
				for each(var tileXML:XML in xml.data.tile)
				{
					mapTile = new MapTileVO(tileXML);
					data.push(mapTile);
				}
			}
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
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

		public function get properties():Array
		{
			return _properties;
		}

		public function set properties(value:Array):void
		{
			_properties = value;
		}

		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
		}

		public function get tiles():Array
		{
			return _tiles;
		}

		public function set tiles(value:Array):void
		{
			_tiles = value;
		}


	}
}