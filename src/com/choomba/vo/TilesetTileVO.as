package com.choomba.vo
{
	public class TilesetTileVO
	{
		// TilesetVO firstGID value
		public var TILE_ID_OFFSET:int;
		
		private var _id:int;
		private var _properties:Array;
		
		public function TilesetTileVO(xml:XML, firstGID:int)
		{
			TILE_ID_OFFSET = firstGID;
			
			if (xml)
			{
				// tile id's are offset by 1
				_id = int(xml.@id) + TILE_ID_OFFSET;
				
				var propertiesList:XMLList = xml..property;
				
				var propertyVO:TilesetPropertyVO;
				
				if (propertiesList.length() > 0)
					_properties = new Array();
				
				//loop through the results
				for(var i:uint = 0; i < propertiesList.length();i++)
				{
					propertyVO = new TilesetPropertyVO();
					propertyVO.name = propertiesList[i]..@name;
					propertyVO.value = propertiesList[i]..@value;
					
					_properties.push(propertyVO);
				}			
			}
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
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