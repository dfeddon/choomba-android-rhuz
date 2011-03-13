package com.choomba.vo
{
	public class TilesetVO
	{
		private var _firstGID:int;
		private var _name:String;
		private var _tileWidth:int;
		private var _tileHeight:int;
		private var _image:TilesetImageVO;
		//private var _properties:Array;
		//private var _tileId:int;
		//private var _tilesetTile:TilesetTileVO;
		private var _tiles:Array;
		
		public function TilesetVO(xml:XML)
		{
			if (xml)
			{
				_firstGID = xml.@firstgid;
				_name = xml.@name;
				_tileWidth = xml.@tilewidth;
				_tileHeight = xml.@tileheight;
				
				_image = new TilesetImageVO(xml.image[0]);
				
				var tilesList:XMLList = xml..tile;
				
				if (tilesList.length() > 0) 
					_tiles = new Array();
				
				for(var i:uint = 0; i < tilesList.length(); i++)
				{
					tiles.push(new TilesetTileVO(tilesList[i], _firstGID));
				}
			}
		}

		/*public function get properties():Array
		{
			return _properties;
		}

		public function set properties(value:Array):void
		{
			_properties = value;
		}*/

		public function get tiles():Array
		{
			return _tiles;
		}

		public function set tiles(value:Array):void
		{
			_tiles = value;
		}

		public function get firstGID():int
		{
			return _firstGID;
		}

		public function set firstGID(value:int):void
		{
			_firstGID = value;
		}


	}
}