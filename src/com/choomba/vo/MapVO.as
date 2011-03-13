package com.choomba.vo
{
	public class MapVO
	{
		private var _mapLayers:Array;
		private var _tilesets:Array;
		private var _orientation:String;
		private var _width:int;
		private var _height:int;
		private var _tileWidth:int;
		private var _tileHeight:int;
		
		public function MapVO()
		{
			_mapLayers = new Array();
			_tilesets = new Array();
		}

		public function get mapLayers():Array
		{
			return _mapLayers;
		}

		public function set mapLayers(value:Array):void
		{
			_mapLayers = value;
		}

		public function get orientation():String
		{
			return _orientation;
		}

		public function set orientation(value:String):void
		{
			_orientation = value;
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

		public function get tileWidth():int
		{
			return _tileWidth;
		}

		public function set tileWidth(value:int):void
		{
			_tileWidth = value;
		}

		public function get tileHeight():int
		{
			return _tileHeight;
		}

		public function set tileHeight(value:int):void
		{
			_tileHeight = value;
		}

		public function get tilesets():Array
		{
			return _tilesets;
		}

		public function set tilesets(value:Array):void
		{
			_tilesets = value;
		}


	}
}