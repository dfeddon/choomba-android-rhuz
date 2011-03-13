/**
 * The TiledLevel class is used for loading maps created in Tiled (http://mapeditor.org/)
 * in to FlashPunk. (http://flashpunk.net)
 * 
 * @author		Anders Antila <anders.antila@gmail.com>
 * @version		0.6
 * @date 		19.01.2010
 * @license 	Public Domain
 * 
 * Needs the following libraries to work:
 * ascompress   http://code.google.com/p/ascompress/
 * base64       http://dynamicflash.com/goodies/base64/
 * 
 * I hereby waive all copyright and related or neighboring rights together
 * with all associated claims and causes of action with respect to this 
 * work to the extent possible under the law.
 *
 */

package com.choomba
{
	
	import com.dynamicflash.util.Base64;
	import com.probertson.utils.GZIPBytesEncoder;
	
	import flash.display.Sprite;
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.core.ByteArrayAsset;
	
	public class TiledLevel extends Sprite
	{
		public var tileInfo:Object = new Object();
		public var tilegrid:Sprite;
		
		public function drawMap(mapClass:Class, tileClass:Class):void
		{
			// Convert the Map Class to XML 
			var mapByteArray:ByteArrayAsset = ByteArrayAsset( new mapClass() );
			var mapXML:XML = new XML( mapByteArray.readUTFBytes( mapByteArray.length ) );
			
			// Read the map properties
			var mapWidth:Number = mapXML.@width;
			var mapHeight:Number = mapXML.@height;
			var tileWidth:Number = mapXML.@tilewidth;
			var tileHeight:Number = mapXML.@tileheight;
			
			var depth:Number = 1;
			
			// Create a new tilemap with data from the XML
			//var tilemap:TileMap = new TileMap(mapWidth*tileWidth, mapHeight*tileHeight);
			//tilegrid = new Grid(tileWidth, tileHeight, mapWidth, mapHeight);
			
			// Loop trough every layer in the map
			for each (var layer:XML in mapXML.layer) 
			{
				// Get the base64 encoded layer data
				var mapData:ByteArray = Base64.decodeToByteArray(layer.data);
				
				// Uncompress the GZIPed layer data
				var gzip:GZIPBytesEncoder = new GZIPBytesEncoder();
				var unzippedMap:ByteArray = gzip.uncompressToByteArray(mapData);
				unzippedMap.endian = Endian.LITTLE_ENDIAN;
				
				// Variables for keeping track of map drawing
				var tileLength:Number = mapWidth*mapHeight;
				var drawQueue:Number = 0;
				var currentColumn:Number = 0;
				
				// Map in FlashPunk format
				var tileString:String = "";
				
				// Info about the current tile
				tileInfo.tileWidth = tileWidth;
				tileInfo.tileHeight = tileHeight;
				
				// Loop trough all tiles in the layer
				while (drawQueue < tileLength) {
					
					// See which column we're in
					currentColumn = drawQueue % mapWidth;
					
					// Try/catch here because byteArray.readInt() throws an error if we try to read past end of file
					try {
						// Grab the current tile
						var tile:int = unzippedMap.readInt();
						
						// Update the tile info with the current tile
						tileInfo.x = currentColumn;
						tileInfo.y = drawQueue % mapHeight;
						
						// If tile logic returns true we add it to the tilemap
						// Tile logic may want to return false if it added a player to the map or similar
						if (tileLogic(tile, layer.@name) == true) {
							
							tileString += tile.toString();
							
							// Check if we're on last column
							if (currentColumn == mapWidth-1) { 
								// ..then add a new row
								tileString += "\n"; 
							} else {
								// ...otherwise just add a separator
								tileString += ","; 
							}
							
						}
						
					} catch(e:EOFError) {
						// End of file, we shouldn't end up here
					}
					
					drawQueue++;					
				}
				
				// Check whether it's a tilemap or a grid
				trace('hi');
				/*if (layer.@name == "Grid") {
					// It's a grid, load the tilemap with the generated data
					tilegrid.loadFromString(tileString);
					//add(grid);
				} else {
					// It's a tilemap, load the tilemap with the generated data
					tilemap.loadFromString(tileClass, tileWidth, tileHeight, tileString);
					tilemap.depth = depth++;
					// And add it to the stage
					add(tilemap);
				}*/
			}
		}
		
		// Gets called everytime a tile is added. Here you can add if-statements to do things
		// when a certain tile is added. For example add a player, objects or similar
		public function tileLogic(tile:Number, layer:String):Boolean
		{
			// Override this function in your extension of this class
			return true;
		}
		
	}
	
}