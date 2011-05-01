package com.choomba
{
	import com.choomba.Lot;
	import com.choomba.components.TextBubble;
	import com.choomba.prose.ProseWin;
	import com.choomba.utils.GridUtils;
	import com.choomba.vo.ItemVO;
	import com.choomba.vo.TilesetPropertyVO;
	import com.dfeddon.rhuz.Player;
	import com.efnx.fps.fpsBox;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.profiler.showRedrawRegions;
	import flash.system.System;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	public class Studio extends Sprite
	{
		public static const TOUCH_BASED_MODE:Boolean = true;
		
		//public static const DYNAMIC_LIGHTING_TYPE:String = Fog.TYPE_FOG_OF_WAR;
		
		public static const DEFAULT_TILE_WIDTH:int = 64;
		public static const DEFAULT_TILE_HEIGHT:int = 64;
		public static const DEFAULT_LOT_COLUMNS:int = 25;
		public static const DEFAULT_LOT_ROWS:int = 25;
		
		private static var _studio:Studio;
		private static var _player:Player;		
		private static var _currentLot:Lot;
		private static var _textBubble:TextBubble;

		private static var _fog:Fog;
		public static var cam:SteadyCam;
		public static var proseWin:ProseWin;
		
		public static var sql:SQLConnection;
		public static var sqlStmt:SQLStatement;
		
		private var touchBegin:TouchEvent;
		private var tapTimer:Timer;
		
		public var level:TileCode;

		public function Studio()
		{
			super();
			
			studio = this;
			
			// sqlite
			connect();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//doubleClickEnabled = true;
			
			// listeners
			addEventListener(Event.COMPLETE, assetsLoadedHandler);
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, update);
			
			//addEventListener(PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP, pressAndTapHandler);
			//addEventListener(TouchEvent.TOUCH_TAP, touchTapHandler);
			addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			
			//addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			//addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			//addEventListener(MouseEvent.CLICK, clickHandler);
			//addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		}
		
		protected function connect():void
		{
			var sqlFile:File;
			var sqlSt:SQLStatement;
			
			sql = new SQLConnection();
			sql.addEventListener(SQLEvent.OPEN, sqlOpenHandler);
			sql.addEventListener(SQLErrorEvent.ERROR, sqlErrorHandler);
			
			var embededSessionDB:File = File.applicationDirectory.resolvePath("rhuz.db");
			var writeSessionDB:File = File.applicationStorageDirectory.resolvePath("rhuz.db");
			if (!writeSessionDB.exists)
			{
				trace('sql no db');
				embededSessionDB.copyTo(writeSessionDB);
			}
			
			sqlFile = writeSessionDB;
			sql.openAsync(writeSessionDB);
			trace('sqlite');
		}
		
		private function sqlOpenHandler(e:SQLEvent):void
		{
			trace('sql success!');
			
			sqlStmt = new SQLStatement();
			sqlStmt.addEventListener(SQLEvent.RESULT, sqlResult);
			
			sqlStmt.sqlConnection = sql;
			sqlStmt.text = 'SELECT * FROM prose';
			sqlStmt.execute();
		}
		
		private function sqlErrorHandler(e:SQLErrorEvent):void
		{
			trace('sql error!');
		}
		
		private function sqlResult(e:SQLEvent):void
		{
			trace('sql result');
			
			var result:SQLResult = sqlStmt.getResult();
			
			trace('hi', result.data[0].text);
		}
		
		protected function init(e:Event):void
		{
			//trace('studio init', width, height);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// define tap timer
			tapTimer = new Timer(1000, 1);
			tapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, tapTimerCompleteHandler);
			
			//graphics.beginFill(0x000000);
			graphics.drawRect(0,0, 
				stage.fullScreenWidth,//Studio.DEFAULT_LOT_COLUMNS,
				stage.fullScreenHeight//Studio.DEFAULT_LOT_ROWS
			);
			//graphics.endFill();
			
			// load assets
			loadAssets();
		}
		
		protected function update(event:Event):void
		{
			if (!_currentLot) return;
			
			if (_currentLot.active)
			{
				// update lot
				currentLot.update();
				
				// update actors
				for (var i:uint =0; i < currentLot.numChildren; i++)
				{
					if (currentLot.getChildAt(i) is Actor)
						Actor(currentLot.getChildAt(i)).update();
				}
			}
		}
		
		protected function addStage(obj:Lot):Lot
		{
			currentLot = addChild(obj) as Lot;
			
			if (obj.tileBG)
				addChild(new TileBackground(AssetManager.getInstance()[obj.tileBG]));
			return obj;
		}
		
		protected function addItems(items:Array):void
		{
			var vo:ItemVO;
			var img:Image;
			var item:Item = new Item();
			var len:int = items.length;
			
			for (var i:uint=0; i < len; i++)
			{
				vo = items[i] as ItemVO;
				
				//item.graphics.drawRect(0,0,DEFAULT_TILE_WIDTH,DEFAULT_TILE_HEIGHT);
				item.image = new Image(AssetManager.getInstance()[vo.imgS]);
				item.x = vo.pos.x + 32;
				item.y = vo.pos.y + 32;
				item.vo = vo;
				currentLot.items.push(item);
				currentLot.addChild(item);
			}
		}
		
		protected function addPlayer(obj:Player):Player
		{
			player = currentLot.addChild(obj) as Player;
			trace('player index', currentLot.getChildIndex(player));
			
			return player;
		}
		
		/*protected function pressAndTapHandler(e:PressAndTapGestureEvent):void
		{
			trace('press and tap');
		}*/

		protected function touchTapHandler(e:TouchEvent):void
		{
			trace('tapped', e.localX, e.localY);
			var point:Point = new Point(e.localX, e.localY);
			
			//if (currentLot.active)
			tapAtPoint(point);
		}
		
		protected function touchBeginHandler(e:TouchEvent):void
		{
			//removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			//removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			tapTimer.start();
			touchBegin = e;
		}
		
		protected function tapTimerCompleteHandler(e:TimerEvent):void
		{
			trace('tap hold!');
			tapTimer.reset();
			
			var point:Point = new Point(touchBegin.localX, touchBegin.localY); 
			
			if (point.x <= 0 || point.y <= 0) return;
			
			var grid:Object = GridUtils.getMapNodeFromCoordinates(point);
			
			var description:String;
			
			// find tile property desc
			for each(var prop:TilesetPropertyVO in grid.properties)
			{
				if (prop.name == "description")
					description = prop.value;
			}
			
			// find item desc
			for each(var item:Item in Studio.currentLot.items)
			{
				trace('->--->', item.vo.loc, grid);
				
				if (grid.x == item.vo.loc.x && grid.y == item.vo.loc.y)
				{
					var idesc:String = item.vo.desc1;
					
					if (description)
					{
						description += '<br><br>You also see ' + item.vo.prep + 
							' ' + item.vo.name.toLowerCase() + '.  ' + idesc;
					}
					else description = idesc;
				}
			}
			
			// remove pre-existing text bubble
			if (textBubble)
			{
				textBubble.remove();
				textBubble = null;
			}
			
			if (description)
			{
				textBubble = new TextBubble(currentLot, point, description);
			}
		}
		
		protected function touchEndHandler(e:TouchEvent):void
		{
			trace('touch end', e.touchPointID);
			
			/*if (!currentLot.active)
				return;*/
			
			// if tap timer running, just a simple tap
			if (tapTimer.running)
			{
				touchTapHandler(e);
			}
			// otherwise, coming out of a tap-and-hold event
			else
			{
				//trace('tap hold end');
			}
			
			// reset tap timer
			tapTimer.reset()
		}
		
		/*protected function mouseDownHandler(e:MouseEvent):void
		{
			var touchBegin:TouchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
			
			touchBegin.localX = e.localX;
			touchBegin.localY = e.localY;
			
			touchBeginHandler(touchBegin);
		}
		
		protected function mouseUpHandler(e:MouseEvent):void
		{
			var touchEnd:TouchEvent = new TouchEvent(TouchEvent.TOUCH_END);
			
			touchEnd.localX = e.localX;
			touchEnd.localY = e.localY;
			
			touchEndHandler(touchEnd);
		}*/
		
		/*protected function doubleClickHandler(e:MouseEvent):void
		{
			trace('double click');
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			trace('clicked');
			
			var point:Point = new Point(e.localX, e.localY);
			
			if (tapTimer.running)
				tapAtPoint(point);
		}*/
		
		protected function tapAtPoint(point:Point):void
		{
			trace('tap at point...');
			
			/*if (!Studio.currentLot.active)
			{
				trace('lot inactive');
				return;
			}*/
			
			if (!player.active && player.pSplash)
			{
				player.pSplash.remove();
				
				return;
			}
			
			if (textBubble)
			{
				textBubble.remove();
				textBubble = null;
				
				return;
			}
			//var point:Point = new Point(e.localX, e.localY);
			
			// not a valid grid
			if (point.x <= 0 || point.y <= 0) return;
			
			var grid:Object = GridUtils.getMapNodeFromCoordinates(point);//, 'walls');
			
			if (grid.isCollidable)
			{
				trace("tapped collidable");
			}
			else
			{
				//player.moveToPos(point, player.speed);
				player.pathToPoint(point, player.speed);
			}
			/*
			//var game:Game = FP.world as Game;
			var game:GameBase = FP.world as GameBase;
			var player:Player = game.player;
			
			// get global x y values from mouse/tap coordinates relative to world
			var point:Point = new Point(game.mouseX, game.mouseY);
			var gPoint:Point = localToGlobal(point);
			
			player.posTo(gPoint.x, gPoint.y);
			*/
		}
		
		protected function loadAssets():void
		{
			AssetManager.getInstance().addEventListener(Event.COMPLETE, assetsLoadedHandler);
			AssetManager.getInstance().loadData();
		}
		
		protected function assetsLoadedHandler(e:Event):void
		{
			removeEventListener(Event.COMPLETE, assetsLoadedHandler);
			//System.gc();
			trace('assets loaded', System.totalMemory / 1024);
		}
		
		public function tilemapComplete(tilemap:TileCode):void
		{
			trace('tile complete');
			
			/*currentLot.addChild(tilemap);
			
			// add items
			
			
			// add player to stage
			var img:Image = new Image(AssetManager.getInstance()[currentLot.playerImage]);
			var startX:int = currentLot.startTile[0] * Studio.DEFAULT_TILE_WIDTH;
			var startY:int = currentLot.startTile[1] * Studio.DEFAULT_TILE_HEIGHT;
			player = new Player(img, true, startX, startY);
			addPlayer(player);
			//trace('x', player.x, 'y', player.y);
			//player.moveToPos(new Point(player.x, player.y), 20);
			
			// add fog
			if (currentLot.fogEnabled)
			{
				fog = currentLot.addChild(new Fog) as Fog;
				fog.name = 'fog';
				Studio.fog.update();
			}
			
			cam = currentLot.addChild(new SteadyCam) as SteadyCam;
			
			
			// debugger
			var fps:fpsBox = new fpsBox(stage);
			addChild(fps);
			
			//flash.profiler.showRedrawRegions(true, 0x0000ff);
			
			// 3 sec delay (for mobile)
			var timer:Timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, playerStartPos);
			timer.start();*/
		}
		
		protected function playerStartPos(e:TimerEvent):void
		{
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, playerStartPos);
			
			player.moveToPos(new Point(player.x, player.y), 20);
		}
		
		public function addProse(txt:String):void			
		{
			proseWin = new ProseWin();
			//pw.name = 'prose';
			
			addChild(proseWin);
			
			proseWin.addProse(txt);
		}

		public static function get studio():Studio
		{
			return _studio;
		}
		
		public static function set studio(value:Studio):void
		{
			_studio = value;
		}
		
/*		public static function get player():Player
		{
			return _player;
		}
		
		public static function set player(value:Player):void
		{
			_player = value;
		}
*/				
		public static function get currentLot():Lot
		{
			return _currentLot;
		}

		public static function set currentLot(value:Lot):void
		{
			_currentLot = value;
		}

		public static function get player():Player
		{
			return _player;
		}

		public static function set player(value:Player):void
		{
			_player = value;
		}

		public static function get fog():Fog
		{
			return _fog;
		}

		public static function set fog(value:Fog):void
		{
			_fog = value;
		}

		public static function get textBubble():TextBubble
		{
			return _textBubble;
		}

		public static function set textBubble(value:TextBubble):void
		{
			_textBubble = value;
		}


	}
}