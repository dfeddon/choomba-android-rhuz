package com.choomba.utils
{
	import com.choomba.Lot;
	import com.choomba.Studio;
	import com.choomba.vo.MapVO;
	import com.choomba.vo.TilesetPropertyVO;
	import com.choomba.vo.TilesetTileVO;
	import com.choomba.vo.TilesetVO;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class GridUtils
	{
		public static var metaLayer:Dictionary = new Dictionary();
		//public static var metaRows:Array = new Array();
		public static var metaCols:Array = new Array();
		
		public static var map:MapVO;
		
		public function GridUtils()
		{
		}
		
		public static function buildMap(layerName:String):void
		{
			var colTotal:int = Studio.DEFAULT_LOT_COLUMNS;
			var rowTotal:int = Studio.DEFAULT_LOT_ROWS;
			
			// build map sans collidables
			//var map:Array = new Array();
			//var col:Array;
			//var row:Array = new Array();
			
			var metaRows:Array = new Array();
			
			for (var rows:uint = 0; rows < rowTotal; rows++)
			{
				//col=[]; // clear var
				metaCols=[];
				
				for (var cols:uint = 0; cols < colTotal; cols++)
				{
					//col.push(0);
					metaCols.push(0);
				}
				//row.push(col);
				metaRows.push(metaCols);
			}
			
			// add to metaLayer
			metaLayer[layerName] = metaRows;
			// print map
			//printMap();
		}
		
		public static function addNodeToMap(xCol:int, yRow:int, id:int, layerName:String):void
		{
			for (var key:String in metaLayer)
			{
				if (layerName == key)
				{
					//trace('key match!');
					metaLayer[key][yRow][xCol] = id;
				}	
			}
			//metaRows[yRow][xCol] = id;
			//printMap();
		}
		
		public static function getMapNodeFromCoordinates(point:Point, 
														 layerName:String=null):Object
		{
			var returnValue:Object = new Object();
			var ids:Array;
			var properties:Array = new Array();
			var id:int;
			var property:Array;//TilesetPropertyVO;
			var isCollidable:Boolean = false;
			
			var x:Number = Math.floor(point.x / Studio.DEFAULT_TILE_WIDTH);
			var y:Number = Math.floor(point.y / Studio.DEFAULT_TILE_HEIGHT);
			
			if (!layerName)
			{
				ids = new Array();
				var props:Array = new Array();
				for (var key:String in metaLayer)
				{
					// ids
					ids[key] = metaLayer[key][y][x];
					
					// properties
					for each(var tileset:TilesetVO in map.tilesets)
					{
						for each(var tile:TilesetTileVO in tileset.tiles)
						{
							//trace('## ', metaLayer[key][y][x], key, tile.id);
							if (tile.id == metaLayer[key][y][x] && tile.id > 0 && metaLayer[key][y][x] > 0)
							{
								props[key] = [];
								for each(var prop:TilesetPropertyVO in tile.properties)
								{
									props[key] = prop;
									trace('   ', prop.name, prop.value);
									if (prop.name == "collidable" && prop.value == "true")
										isCollidable = true;
									
									properties.push(prop);
								}
							}
						}
					}
				}
			}
			else
			{
				id = metaLayer[layerName][y][x];
				properties = getPropertiesById(id);
			}
			
			var tileCenter:Point = getTileCenter(y, x);
			
			returnValue.x = x;
			returnValue.y = y;
			returnValue.id = id;
			returnValue.ids = ids;
			returnValue.properties = properties;
			returnValue.property = property;
			returnValue.tileCenter = tileCenter;
			returnValue.isCollidable = isCollidable;
			
			trace('row', x, 'col', y, ids);
			return returnValue;
		}
		
		public static function getTileCenter(row:int, col:int):Point
		{
			var returnValue:Point = new Point();
			
			var x:Number = col * Studio.DEFAULT_TILE_WIDTH + (Studio.DEFAULT_TILE_WIDTH / 2);
			var y:Number = row * Studio.DEFAULT_TILE_HEIGHT + (Studio.DEFAULT_TILE_HEIGHT / 2);
			
			returnValue.x = x;
			returnValue.y = y;
			
			return returnValue;
		}
		
		private static function getIdsByLayer(layer:String):void
		{
			
		}
		
		private static function getPropertiesById(id:int):Array
		{
			var a:Array = new Array();
			
			for (var key:String in metaLayer)
			{
				// ids
				//ids[key] = metaLayer[key][y][x];
				
				// properties
				for each(var tileset:TilesetVO in map.tilesets)
				{
					for each(var tile:TilesetTileVO in tileset.tiles)
					{
						if (tile.id == id)
						{
							for each(var prop:TilesetPropertyVO in tile.properties)
							a[key] = prop;
						}
					}
				}
			}
			
			return a;
		}
		
		private static function printMap(layerName:String):void
		{
			var layer:Array = metaLayer[layerName];
			
			for (var i:uint = 0; i < layer.length; i++)
			{
				trace(layer[i]);
			}
		}
		
		public static function printObject(o:Object):void
		{
			for(var val:* in o)
			{
				trace('[' + typeof(o[val]) + '] ' + val + ' => ' + o[val]);
			}
		}
	}
}