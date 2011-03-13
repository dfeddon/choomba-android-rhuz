package com.choomba
{
	import flash.display.Sprite;
	
	public class TilemapContainer extends Sprite
	{
		private var _mapName:String;
		private var _mapIndex:int;
		private var _layerName:String;
		
		public function TilemapContainer()
		{
			super();
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