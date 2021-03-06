package com.choomba
{
	import com.choomba.utils.GridUtils;
	import com.gskinner.motion.GTween;
	import com.timo.astar.Astar;
	import com.timo.astar.Node;
	
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Actor extends Prop
	{
		private var _sheet:Sheet;
		//private var _sheetMap:Dictionary;
		private var _sheetTileWidth:int;
		private var _sheetTileHeight:int;
		private var _speed:int;
		private var _sheetFrameRate:int;
		
		public var tween:GTween;
		private var _moving:Boolean;
		private var _active:Boolean;

		private var _isMobile:Boolean;
		
		protected var path:Vector.<Node>;
		
		public function Actor(image:Image=null, isSheet:Boolean=false)
		{
			if (isSheet)
			{
				// sheetMap
				sheet = new Sheet(this, image.bitmapData);//, sheetMap);
			}

			super(image);
			
			//blendMode = BlendMode.LAYER;
		}
		
		public function update():void
		{
			if (!active) return;
			
			//trace('updateing actor');
		}
		
		override protected function setImage():void
		{
			if (sheet==null)
				super.setImage();
			else
			{
				addChild(sheet);
			}
		}
		
		/*protected function mapSheet():void
		{
			
		}*/
		
		public function pathToPoint(point:Point, speed:int):void
		{
			// find path a*
			var gridTo:Object = GridUtils.getMapNodeFromCoordinates(point);
			var gridFrom:Object = GridUtils.getMapNodeFromCoordinates(new Point(this.x, this.y));
			var a:Astar = new Astar(GridUtils.metaLayer['walls']);
			
			path = a.findPath(new Node(gridFrom.x, gridFrom.y), new Node(gridTo.x, gridTo.y));// as Vector.<com.timo.astar.Node>;
			
			// if path fails or nodes are 20+
			if (!path || path.length >= 20) 
			{
				trace("PATHFINDING FAILED!!!");
				return;
			}
			
			// remove first node (currnt/start position)
			path.shift();
			
			for each(var node:Node in path)
				trace('-->', node.name);
			
			var speed:int = 65;
			moveToPos(new Point(path[0].x * Studio.DEFAULT_TILE_WIDTH, 
				path[0].y * Studio.DEFAULT_TILE_HEIGHT), speed);
		}
		
		public function moveToNode():void
		{
			// remove last position
			path.shift();
			
			var speed:int = 65;
			
			moveToPos(new Point(path[0].x * Studio.DEFAULT_TILE_WIDTH, 
				path[0].y * Studio.DEFAULT_TILE_HEIGHT), speed);
		}
		
		public function moveToPos(pTo:Point, s:int):void
		{
			if (!active) return;
			
			if (moving)
			{
				// clear previous tween
				tween.onComplete = null;
				tween.resetValues();
			}
			
			var pFrom:Point = new Point(x, y);
			var d:Number = Point.distance(pFrom, pTo);
			var speed:Number = d / s;
			
			var p:Object = new Object();
			p.x = pTo.x;
			p.y = pTo.y;
			p.alpha = 1;
			
			tween = new GTween(this, speed, p);
			tween.onComplete = tweenCompleteHandler;
			moving = true;
		}
		
		protected function tweenCompleteHandler(e:GTween=null):void
		{
			trace('# tween complete', e);
			
			if (path && path.length > 1)
			{
				trace('## next path', path[0].x, path[0].y);
				moveToNode();
				return;
			}
			
			moving = false;
			
			if (sheet)
			{
				sheet.stop();
				//frame = 0; // reset
				
				switch(sheet.type)
				{
					case 'walkEast': sheet.play('standEast'); break;
					case 'walkWest': sheet.play('standWest'); break;
					case 'walkNorth': sheet.play('standNorth'); break;
					case 'walkSouth': sheet.play('standSouth'); break;
				}
			}
			
		}

		public function get sheet():Sheet
		{
			return _sheet;
		}

		public function set sheet(value:Sheet):void
		{
			_sheet = value;
		}

		/*public function get sheetMap():Dictionary
		{
			return _sheetMap;
		}

		public function set sheetMap(value:Dictionary):void
		{
			_sheetMap = value;
		}*/

		public function get sheetTileWidth():int
		{
			return _sheetTileWidth;
		}

		public function set sheetTileWidth(value:int):void
		{
			_sheetTileWidth = value;
		}

		public function get sheetTileHeight():int
		{
			return _sheetTileHeight;
		}

		public function set sheetTileHeight(value:int):void
		{
			_sheetTileHeight = value;
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get sheetFrameRate():int
		{
			return _sheetFrameRate;
		}

		public function set sheetFrameRate(value:int):void
		{
			_sheetFrameRate = value;
		}

		public function get isMobile():Boolean
		{
			return _isMobile;
		}

		public function set isMobile(value:Boolean):void
		{
			_isMobile = value;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

		public function get moving():Boolean
		{
			return _moving;
		}

		public function set moving(value:Boolean):void
		{
			_moving = value;
		}
		


	}
}