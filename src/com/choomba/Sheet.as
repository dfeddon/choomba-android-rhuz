package com.choomba 
{
	import com.choomba.utils.DataUtils;
	import com.choomba.vo.SheetMapVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	//class declaration
	public class Sheet extends Image 
	{
		//declare variables
		private var mapArr:Array;
		private var curMap:Array;
		private var complexTiles:Array;
		private var animatedObjects:Dictionary;// D:Array;
		private var mapW:int;
		private var mapH:int;
		private var ts:int;
		private var actor:Actor;
		private var tilesBmp:Image;
		private var bmd:BitmapData;
		private var _type:String;
		
		private var img:Image;
		private var _active:Boolean;
		private var _vo:SheetMapVO;
		//private var map:Dictionary;
		
		private var _mapArray:Array;

		private var displayBitmap:DisplayObject;

		//class constructor function
		public function Sheet(actor:Actor, bitmapData:BitmapData)//, sheetMap:Dictionary=null) 
		{
			_mapArray = new Array();
			
			this.actor = actor;
			this.bmd = bitmapData;
			//map = sheetMap;
			
			//prepareGame();
		}
		
		private function getMapByType(type:String):SheetMapVO
		{
			var returnVO:SheetMapVO;
			
			for (var i:uint = 0; i < mapArray.length; i++)
			{
				if (SheetMapVO(mapArray[i]).type == type)
				{
					returnVO = DataUtils.clone(mapArray[i]) as SheetMapVO;
					break;
				}
			}
			
			//trace('ar:', returnVO.aniMap);
			
			return returnVO;
		}
		
		public function stop():void
		{
			active = false;
		}
		
		//start the game by preparing stuff
		public function play(type:String):void 
		{
			//trace('play');

			this.active = true;
			
			this.type = type;
			
			// sheet vo
			vo = getMapByType(type);
			
			// tile size
			ts = actor.sheetTileWidth; // 64;
			
			//we set new map data and call buildMap function
			mapArr = [[0]];
			complexTiles = [];//new Array();
			
			var fr:int;
			// also, if single frame map, set frame rate to 1
			//trace('len1', vo.aniMap.length, vo.aniMap);
			//if (vo.aniMap.length == 2)
				//vo.aniMap.pop();
			if (vo.aniMap.length == 1)
				fr = 1;
			else fr = actor.sheetFrameRate;// 3;
			
			//complexTiles[0] = createComplexTile(1, [0,fr,1,fr,2,fr,3,fr,4,fr,5,fr,6,fr,7,fr]);
			// inject frame rate into map
			var newMap:Array = new Array();
			
			for (var i:uint = 0; i < vo.aniMap.length; i++)
			{
				newMap.push(vo.aniMap[i]);
				newMap.push(fr);
			}
			//trace(newMap);
			vo.aniMap = newMap;
			complexTiles[0] = vo;//createComplexTile(1, [0,fr,1,fr,2,fr,3,fr,4,fr,5,fr,6,fr,7,fr]);
			//set up array for all animated things
			animatedObjects = new Dictionary(true);// new Array();
			//get the tilesheet
			//bmd = AssetManager.getInstance().playerMageImg;
			//set up current map array
			curMap = mapArr;
			//create map
			buildMap ();
			
			// start animation to avoid blinking
			animateSprite();
			
			// add listener only once
			if (!actor.hasEventListener(Event.ENTER_FRAME))
				actor.addEventListener(Event.ENTER_FRAME, update);
		}
		
		//build new map
		private function buildMap():void 
		{
			//get map dimensions
			mapW = 1;
			mapH = 1;
			
			//main bitmap to be shown on screen
			tilesBmp = new Image(new BitmapData(ts * mapW, ts * mapH, true, 0x000000));
			
			// first, remove existing bitmap (if exists)
			if (displayBitmap)
			{
				actor.removeChildAt(0);
			}
			
			//add this clip to stage
			displayBitmap = actor.addChildAt(tilesBmp, 0);
			
			// center sheet
			displayBitmap.x = -(actor.sheetTileWidth / 2);
			displayBitmap.y = -(actor.sheetTileHeight / 2);
			
			var yt:int = 0;
			var xt:int = 0;
			var s:int = curMap[yt][xt];

			//check for complex tile type
			var cT:SheetMapVO = complexTiles[s];

			//draw one image
			drawTile (cT.index, xt, yt);
			
			//check for animated image
			var ob:Object = new Object();
			ob.anim = cT.aniMap;
			ob.baseSpr = cT.index;

			//reset animation counters
			ob.animCount = 0;
			ob.animTime = 0;
			ob.xt = xt;
			ob.yt = yt;
			
			//add to animated objects array
			animatedObjects[ob] = ob;
			
			//second image to be drawn later
			s = cT.aniMap[0];
			
			//put image on screen
			drawTile (s, xt, yt);
		}
		
		//this is main game function that is run at enterframe event
		protected function update(ev:Event):void 
		{
			//animate the objects
			if (active)
				animateSprite();
			else actor.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		//this function will animate all the objects
		private function animateSprite():void 
		{
			tilesBmp.bitmapData.lock();

			//run through all objects needing the animation
			for (var ob:Object in animatedObjects)
			{
				//add 1 to time counter
				ob.animTime++;
				
				//check if the time has counted up
				if(ob.animTime == ob.anim[ob.animCount + 1])
				{
					//add to current image counter
					ob.animCount += 2;
					
					//check if end of animation is reached
					if(ob.animCount == ob.anim.length)
					{
						//reset to start
						ob.animCount = 0;
						
						// if animation doesn't repeat, stop
						if (!vo.repeater) 
							active = false;
					}

					//clear the current tile image
					var rect:Rectangle = new Rectangle(ob.xt * ts, ob.yt * ts, ts, ts);
					tilesBmp.bitmapData.fillRect (rect, 0x00000000);
					
					//change the image if time is right
					ob.s = ob.anim[ob.animCount];
					
					//drawTile (ob.baseSpr, ob.xt, ob.yt);
					drawTile (ob.s, ob.xt, ob.yt);
					
					//reset animation timer
					ob.animTime = 0;
				}
			}
			tilesBmp.bitmapData.unlock();
		}
		
		private function getImageFromSheet(s:Number, ob:* = null):Image 
		{
			var tsize:int = ts;
			var sheet:BitmapData = bmd;
			/*if(ob != null)
			{
				tsize = ob.ts;
				sheet = ob.sheet;
			}*/
			
			//number of columns in tilesheet
			var sheetColumns:int = bmd.width / tsize;
			
			//position where to take graphics from
			var col:int = s % sheetColumns;
			var row:int = Math.floor(s / sheetColumns);
			
			//rectangle that defines tile graphics
			var rect:Rectangle = new Rectangle(col * tsize, row * tsize, tsize, tsize);
			var pt:Point = new Point(0, 0);
			
			//get the tile graphics from tilesheet
			var bmp:Image =  new Image(new BitmapData(tsize, tsize, true, 0));
			bmp.bitmapData.copyPixels (sheet, rect, pt, null, null, true);

			return bmp;
		}
		private function drawTile(s:Number, xt:int, yt:int):void 
		{
			var bmp:Image = getImageFromSheet (s);
			//rectangle has size of tile and it starts from 0,0
			var rect:Rectangle = new Rectangle(0, 0, ts, ts);
			//point on screen where the tile goes
			var pt:Point = new Point(xt * ts, yt * ts);
			//copy tile bitmap to main bitmap
			tilesBmp.bitmapData.copyPixels (bmp.bitmapData, rect, pt, null, null, true);
		}
		
		private function createComplexTile(spr1:int, animArr:Array, st:String = ""):Object 
		{
			//create new object
			var ob:Object = new Object();
			//base graphics, will always remain same
			ob.baseSpr = spr1;
			//array of animation graphics
			ob.anim = animArr;
			//tile could be some special type
			ob.specialType = st;
			
			return ob;
		}

		public function get mapArray():Array
		{
			return _mapArray;
		}

		public function set mapArray(value:Array):void
		{
			_mapArray = value;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

		public function get vo():SheetMapVO
		{
			return _vo;
		}

		public function set vo(value:SheetMapVO):void
		{
			_vo = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}


	}
}