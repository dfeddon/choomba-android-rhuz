package com.dfeddon.rhuz
{
	import com.choomba.Actor;
	import com.choomba.Image;
	import com.choomba.Item;
	import com.choomba.PlayerSplash;
	import com.choomba.Splash;
	import com.choomba.SteadyCam;
	import com.choomba.Studio;
	import com.choomba.TileRect;
	import com.choomba.utils.GridUtils;
	import com.choomba.vo.ItemVO;
	import com.choomba.vo.SheetMapVO;
	import com.choomba.vo.TilesetPropertyVO;
	import com.gskinner.motion.GTween;
	import com.timo.astar.Astar;
	import com.timo.astar.Node;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Player extends Actor
	{
		private const FOG_UPDATE_FRAMERATE:int = 1;//12;
		
		private var frame:int = 0;
		private var dest:Point;
		
		public var pSplash:PlayerSplash;
		
		private var _inv:Array = new Array();
		
		public function Player(image:Image=null, isSheet:Boolean=false, startX:Number=0, startY:Number=0)
		{
			active = true;
			
			x = startX;
			y = startY;
			
			sheetTileWidth = 64;
			sheetTileHeight = 64;
			sheetFrameRate = 2;
			speed = 65;
			
			super(image, isSheet);
			
			if (isSheet)
			{
				sheet.mapArray.push(new SheetMapVO(1, [0,1,2,3,4,5,6,7], 'walkEast', true));
				sheet.mapArray.push(new SheetMapVO(2, [9,10,11,12,13,14,15,16], 'walkWest', true));
				sheet.mapArray.push(new SheetMapVO(3, [18,19,20,21,22,23,24,25], 'walkNorth', true));
				sheet.mapArray.push(new SheetMapVO(4, [27,28,29,30,31,32,33,34], 'walkSouth', true));
				
				sheet.mapArray.push(new SheetMapVO(5, [8], 'standEast', false));
				sheet.mapArray.push(new SheetMapVO(6, [17], 'standWest', false));
				sheet.mapArray.push(new SheetMapVO(7, [26], 'standNorth', false));
				sheet.mapArray.push(new SheetMapVO(8, [35], 'standSouth', false));
			}
			
			sheet.play('standSouth');
			//blendMode = BlendMode.SCREEN;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		protected function touchEndHandler(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			
			// do nothing if moving
			if (moving)
				return;
			
			// disable clicks
			Studio.currentLot.active = false;
			
			// inventory
			pSplash = Studio.currentLot.addChild(new PlayerSplash) as PlayerSplash;
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			// stop event from bubbling, handle here
			e.stopImmediatePropagation();
		}
		
		override public function update():void
		{
			var playerRect:Rectangle = getRect(this);
			
			var tiles:Array;
			
			super.update();
			
			if (moving)
			{
				frame++;
				
				// collision
				/*tiles = stage.getObjectsUnderPoint(new Point(this.x, this.y));
				trace('t', tiles.length, this.x, this.y);
				for (var i:uint = 0; i < tiles.length; i++)
					trace('# tiles', tiles[i]);*/
				
				//var tile:Rectangle = getRect(this);// as TileRect;
				//trace('##', tile, Studio.currentLot.getBounds(this));
				
				// fog of war
				if (Studio.currentLot.fogEnabled)
				{
					if ( ((frame / FOG_UPDATE_FRAMERATE) % 1) == 0 )
						Studio.fog.update();
				}
				
				// move camera
				if (!SteadyCam.active &&
				(
					x < SteadyCam.CAMERA_OFFSET_X ||
					x > (stage.fullScreenWidth - SteadyCam.CAMERA_OFFSET_X) ||
					y < SteadyCam.CAMERA_OFFSET_Y ||
					y > (stage.fullScreenHeight - SteadyCam.CAMERA_OFFSET_Y)
				))
				{
					//trace('move cam', dest);
					Studio.cam.moveToPos(dest, 25);
				}
				//else trace(SteadyCam.active);
				//Studio.cam.basePos.ty -= SteadyCam.CAMERA_SPEED;
			}
		}
		
		override public function moveToPos(pTo:Point, s:int):void
		{
			// is player inactive
			if (!active || !Studio.currentLot.active) 
				return;
			
			// if moving, reset camera
			if (moving)
			{
				SteadyCam.active = false;
				Studio.cam.reset();
			}
			
			// find path a*
			var gridTo:Object = GridUtils.getMapNodeFromCoordinates(pTo);
			var gridFrom:Object = GridUtils.getMapNodeFromCoordinates(new Point(this.x, this.y));
			var a:Astar = new Astar(GridUtils.metaLayer['walls']);
			var path:Vector.<Node> = a.findPath(new Node(gridFrom.x, gridFrom.y), new Node(gridTo.x, gridTo.y));// as Vector.<com.timo.astar.Node>;
			//GridUtils.buildMapWithCollidables();
			trace('->', pTo);
			var center:Point = GridUtils.getMapNodeFromCoordinates(pTo).tileCenter;
			trace('->', center);
			super.moveToPos(center, s);
			
			dest = pTo;
			
			var curAnimation:String;
			
			// if x position is greater than y position, use east/west spritesheet
			if ( Math.abs(center.x - x) > Math.abs(center.y - y) )
			{
				if (x < center.x)
					curAnimation = 'walkEast';
				else curAnimation = 'walkWest';
			}
				// otherwise, use north/south spritesheet
			else
			{
				if (y > center.y)
					curAnimation = 'walkNorth';
				else curAnimation = 'walkSouth';
			}
			
			// start animation
			sheet.play(curAnimation);
		}
		
		override protected function tweenCompleteHandler(e:GTween=null):void
		{
			super.tweenCompleteHandler(e);
			
			frame = 0; // reset
			
			/*sheet.stop();
			frame = 0; // reset
			
			switch(sheet.type)
			{
				case 'walkEast': sheet.play('standEast'); break;
				case 'walkWest': sheet.play('standWest'); break;
				case 'walkNorth': sheet.play('standNorth'); break;
				case 'walkSouth': sheet.play('standSouth'); break;
			}*/
			
			if (Studio.currentLot.fogEnabled)
				Studio.fog.update();
			
			var o:Object = GridUtils.getMapNodeFromCoordinates(new Point(this.x, this.y));
			GridUtils.printObject(o);
			//GridUtils.printObject(o.properties);
			
			/*for each (var prop:TilesetPropertyVO in o.properties)
			{
				trace(prop.name, '->', prop.value);
				
				if (prop.name == TilesetPropertyVO.TAKEABLE)
					trace("TAKEABLE", prop.value);
			}*/
			
			for each(var item:Item in Studio.currentLot.items)
			{
				trace('----->', item.vo.loc, item.vo.pos);
				if (this.hitTestObject(item))
				{
					trace("HIT ITEM!");
					if (item.vo.takeable)
					{
						// remove from lot
						Studio.currentLot.removeChildAt(
							Studio.currentLot.getChildIndex(item));
						
						// add to inventory
						item.itemToInv();
					}
				}
			}

		}

		public function get inv():Array
		{
			return _inv;
		}

		public function set inv(value:Array):void
		{
			_inv = value;
		}

	}
}