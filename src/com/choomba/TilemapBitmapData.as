package com.choomba
{
	import flash.display.BitmapData;
	
	public class TilemapBitmapData extends BitmapData
	{
		private var _mapName:String;
		private var _mapIndex:int;
		private var _layerName:String;
		
		public function TilemapBitmapData(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
		
		public function get mapName():String
		{
			return _mapName;
		}
		
		public function set mapName(value:String):void
		{
			_mapName = value;
		}

		public function get mapIndex():int
		{
			return _mapIndex;
		}

		public function set mapIndex(value:int):void
		{
			_mapIndex = value;
		}

		public function get layerName():String
		{
			return _layerName;
		}

		public function set layerName(value:String):void
		{
			_layerName = value;
		}

		
	}
}