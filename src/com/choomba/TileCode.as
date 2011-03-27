package com.choomba 
{
	import com.choomba.utils.GridUtils;
	import com.choomba.vo.MapLayerPropertyVO;
	import com.choomba.vo.MapLayerVO;
	import com.choomba.vo.MapTileVO;
	import com.choomba.vo.MapVO;
	import com.choomba.vo.TileVO;
	import com.choomba.vo.TilesetVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	public class TileCode extends Sprite 
	{
		private var loader:Loader; // The bitmap loader
		
		private var xmlLoader:URLLoader; // for making the url request later
		private var xmlRoot:XML; // loading the xml file in this property
		private var tilesBitmapData:BitmapData; // data of a tile, which gets later into screenBitmapData

		// following declerations are getting the values from the tmx file
		private var spriteWidth:uint;
		private var spriteHeight:uint;
		private var tileWidth:uint;
		private var tileHeight:uint;
		//private var tileLength:uint;
		private var spriteSource:String;
		
		// converting the tiles array into a multidimensional array later
		private var tileCoordinates:Array = new Array();
		
		private var tileSets:XMLList;
		private var tileSetsIndex:int = 0;

		private var totalLayers:int = 0;
		private var layers:Array = new Array();
		private var layersIndex:int = 0;
		
		private var map:MapVO;
		
		private var _sceneNumber:int;
		private var _sceneName:String;

		public function TileCode(scene:String) 
		{
			map = new MapVO();
			
			_sceneName = scene;
			loadMapXML();
		}
		
		private function loadMapXML():void 
		{
			/*xmlLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			xmlLoader.load(new URLRequest("scene1.tmx"));*/
			
			//xmlRoot = (AssetManager.getInstance()['scene' + _sceneNumber.toString() + 'Map']);
			xmlRoot = (AssetManager.getInstance()[_sceneName + 'Map']);
			
			// tile length = map dimen * number of layers
			//tileLength = xmlRoot.layer.data.tile.length();
			
			/*spriteWidth = xmlRoot.attribute("width");
			spriteHeight = xmlRoot.attribute("height");
			tileWidth = xmlRoot.attribute("tilewidth");
			tileHeight = xmlRoot.attribute("tileheight");*/
			//spriteSource = xml.tileset.image.attribute("source");
			
			xmlConverter(xmlRoot);
		}
		
		/*private function xmlLoadComplete(e:Event):void 
		{
			xmlRoot = new XML(e.target.data);
			
			tileLength = xmlRoot.layer.data.tile.length();
			spriteWidth = xmlRoot.attribute("width");
			spriteHeight = xmlRoot.attribute("height");
			tileWidth = xmlRoot.attribute("tilewidth");
			tileHeight = xmlRoot.attribute("tileheight");
			//spriteSource = xml.tileset.image.attribute("source");
			
			xmlConverter(xmlRoot);
		}*/
		
		private function xmlConverter(xml:XML):void
		{
			var mapLayer:MapLayerVO;
			var tileset:TilesetVO;
			
			map.orientation = xmlRoot.attribute("orientation");
			map.width = xmlRoot.attribute("width");
			map.height = xmlRoot.attribute("height");
			map.tileWidth = xmlRoot.attribute("tilewidth");
			map.tileHeight = xmlRoot.attribute("tileheight");
			
			// set width/height
			this.graphics.lineStyle(1, 0xffffff, 1);
			this.graphics.drawRect(0, 0, map.width * map.tileWidth, map.height * map.tileHeight);
			
			for each(var tilesetXML:XML in xmlRoot.tileset)
			{
				tileset = new TilesetVO(tilesetXML);
				map.tilesets.push(tileset);
			}
			
			for each (var layerXML:XML in xmlRoot.layer)
			{
				totalLayers++;
				layers.push(layerXML);
				
				// declare layer
				mapLayer = new MapLayerVO(layerXML);
				
				// add layer to map
				map.mapLayers.push(mapLayer);
			}
			
			if (xml.tileset is XMLList)
			{
				tileSets = xml.tileset as XMLList;
			}
			
			//trace('loading map', tileSets[tileSetsIndex].@name, layers[layersIndex].@name);
			process();//tileSets[tileSetsIndex], layers[layersIndex]);
			
		}
		
		private function process():void//xml:XML, layer:XML):void
		{
			trace('processing layer');
			
			var total:int = Math.floor(map.width * map.height);
			tileCoordinates = []; // clear array
			
			var tiles:Array = new Array();
			
			for (var tileFor:int = 0; tileFor < total; tileFor++) 
			{
				//trace('for', tileFor, 'len', total, layer.@name, layer.data.tile[tileFor].attribute("gid"));
				tiles.push(MapLayerVO(map.mapLayers[layersIndex]).data[tileFor].gid);
			}
			
			for (var tileX:int = 0; tileX < map.width; tileX++) 
			{
				tileCoordinates[tileX] = new Array();
				
				for (var tileY:int = 0; tileY < map.height; tileY++) 
				{
					tileCoordinates[tileX][tileY] = tiles[(tileX + (tileY * map.width))];
				}
			}
			
			tilesLoadInit();
		}
		
		private function tilesLoadInit():void 
		{
			/*var tilemapContainer:TilemapContainer = new TilemapContainer();
			tilemapContainer.graphics.lineStyle(1, 0xffffff, 1);
			tilemapContainer.graphics.drawRect(0, 0, map.width * map.tileWidth, map.height * map.tileHeight);
			tilemapContainer.mapName = getLayerPropertyValueByName(map.mapLayers[layersIndex], 'tileset');
			tilemapContainer.mapIndex = layersIndex;
			tilemapContainer.layerName = map.mapLayers[layersIndex].name;*/
			
			var screenBitmapData:TilemapBitmapData = new TilemapBitmapData(
				map.width * map.tileWidth,
				map.height * map.tileHeight,
				true,
				0x000000
			);

			screenBitmapData.mapName =  getLayerPropertyValueByName(map.mapLayers[layersIndex], 'tileset');//tileset.@name;
			screenBitmapData.mapIndex = layersIndex;
			screenBitmapData.layerName = map.mapLayers[layersIndex].name;

			if (screenBitmapData)
				GridUtils.buildMap(screenBitmapData.layerName);
			/*if (tilemapContainer)
				GridUtils.buildMap(tilemapContainer.layerName);*/
			
			var tilemapProperty:String = getLayerPropertyValueByName(map.mapLayers[layersIndex], 'tileset');
			tilesBitmapData = AssetManager.getInstance()[tilemapProperty];
			
			var h:int = 16;//9;
			var w:int = 16;//16
			trace('+++++++++++++++++++++++++++++++++++++++++++++++++++++');
			for (var spriteForX:int = 0; spriteForX < map.width; spriteForX++) 
			{
				for (var spriteForY:int = 0; spriteForY < map.height; spriteForY++) 
				{
					var tileNum:int = int(tileCoordinates[spriteForX][spriteForY]);
					var destY:int = spriteForY * map.tileWidth;
					var destX:int = spriteForX * map.tileWidth;
					var sourceY:int = Math.ceil(tileNum / h) - 1;
					var sourceX:int = ( ((tileNum / w) - (sourceY)) * w - 1 );
					
					//trace(screenBitmapData.mapName, screenBitmapData.mapIndex, screenBitmapData.layerName);
					
					var tile:TileVO = new TileVO(sourceX, sourceY, map.tileWidth, map.tileHeight, true);
					
					GridUtils.addNodeToMap(destX / Studio.DEFAULT_TILE_WIDTH, 
						destY / Studio.DEFAULT_TILE_HEIGHT, tileNum,
						screenBitmapData.layerName
					);
					
					MapLayerVO(map.mapLayers[layersIndex]).tiles.push(tile);
					
					var tileRect:TileRect = new TileRect(sourceX * map.tileWidth, sourceY * map.tileWidth, map.tileWidth, map.tileHeight);
					var point:Point = new Point(destX, destY);
					
					screenBitmapData.copyPixels(tilesBitmapData, tileRect, point);
					
					/*var tileRect:TileRect = new TileRect(sourceX * map.tileWidth, 
						sourceY * map.tileWidth, map.tileWidth, map.tileHeight);
					var point:Point = new Point(0, 0);
					var bmpd:BitmapData = new BitmapData(map.tileWidth, 
						map.tileHeight, true, 0x000000);
					bmpd.copyPixels(tilesBitmapData, tileRect, point);
					var img:Image = new Image(bmpd);
					var tiled:DisplayObject = tilemapContainer.addChild(img);
					tiled.x = destX;
					tiled.y = destY;*/
				}
			}
			
			//display screen by adding screenBitmapData to screenBitmap 
			// and add screenBitmap data to displaylist
			var mapImg:Image = new Image(screenBitmapData);//, true, true);
			
			addChild(mapImg);
			//addChild(tilemapContainer);
			//trace('container', tilemapContainer.x, tilemapContainer.y);
			
			if (layersIndex < (layers.length - 1))
			{
				//tileSetsIndex++;
				layersIndex++;
				trace('next', tileSets[tileSetsIndex].@name, layers[layersIndex].@name);
				process();//tileSets[tileSetsIndex], layers[layersIndex]);
			}
			else if (tileSetsIndex < map.tilesets.length)
			{
				trace("# ", tileSetsIndex, map.tilesets.length);
				tileSetsIndex++;
				process();
				
			}
			else
			{
				trace('done, total layers', numChildren);//, 'for tileset', tileSets[tileSetsIndex].@name);
				GridUtils.map = map;
				Studio.studio.tilemapComplete(this);
			}
		}
		
		private function getLayerTilemap(src:String):BitmapData
		{
			// convert image source string to image string
			//var src:String = tileset.image.@source;
			var splitPath:Array = src.split('assets/images/');
			var splitName:Array = splitPath[1].split('.');
			var img:String = splitName[0] + 'Img';
			
			trace('using image asset', img);
			// get tile images (based on >= firstgid value)
			return AssetManager.getInstance()[img];
		}
		
		private function getLayerPropertyValueByName(layer:MapLayerVO, property:String):String
		{
			var returnValue:String = new String();
			
			for each(var i:MapLayerPropertyVO in layer.properties)
			{
				if (i.name == property)
				{
					returnValue = i.value;
					break;
				}
			}
			
			return returnValue;
		}
		
		//private function getTilesetByGid
	}
}