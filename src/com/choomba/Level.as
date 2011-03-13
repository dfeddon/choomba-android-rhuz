package com.choomba
{
	
	import com.choomba.TiledLevel;
	
	public class Level extends TiledLevel
	{
		// Embed the tileset
		[Embed(source="assets/images/scene1_1.png")] private var tileClass:Class;
		
		// Embed the map
		[Embed(source="scene1.tmx", mimeType="application/octet-stream")] private var mapClass:Class;
		
		//var player:Entity;
		
		public function Level():void 
		{
			drawMap(mapClass, tileClass);
		}
		
		override public function tileLogic(tile:Number, layer:String):Boolean
		{
			if (layer == "Entities") {
				// Tile 5 is the player
				/*if (tile == 5) {
					player = add(new Player(this));
					player.x = tileInfo.x * tileInfo.tileWidth;
					player.y = tileInfo.y * tileInfo.tileHeight;
					
					return false;
				}*/
				
				// Always return false for the Entities layer. We don't want entities in our tilemap
				return false;
			}
			
			return true;
		}
		
	}
	
}