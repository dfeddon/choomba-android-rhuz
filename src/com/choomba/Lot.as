package com.choomba
{
	import com.dfeddon.rhuz.Player;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	
	public class Lot extends Sprite
	{
		public var fogEnabled:Boolean;
		public var tileBG:String;
		public var tileMapSource:String;
		public var playerImage:String;
		public var startTile:Array;
		public var items:Array;
		public var npcs:Array;
		
		private var _lightingType:String;
		
		public static var _currentScene:Scene;
		
		private var _active:Boolean;
		
		public var bg:Sprite;
		public var fg:Sprite;
		//protected var fog:DynamicLighting;
		
		public function Lot()
		{
			super();
			
			items = new Array();
			npcs = new Array();
			
			// steady cam requires blend mode type 'layer'
			blendMode = BlendMode.LAYER;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			//bg = addChildAt(new Sprite, 0) as Sprite;
			//fg = addChild(new Sprite) as Sprite;
		}
		
		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			active = true;
			
			// set boundaries
			//graphics.beginFill(0x000000);
			graphics.drawRect(0,0,//stage.fullScreenWidth,stage.fullScreenHeight 
				Studio.DEFAULT_TILE_WIDTH * Studio.DEFAULT_LOT_COLUMNS,
				Studio.DEFAULT_TILE_HEIGHT * Studio.DEFAULT_LOT_ROWS
			);
			//graphics.endFill();
			
			// set fg boundaries
			//fg.graphics.beginFill(0xffffff);
			//fg.graphics.lineStyle(3, 0xffff00, 1);
			/*fg.graphics.drawRect(0,0,
				Studio.DEFAULT_TILE_WIDTH * Studio.DEFAULT_LOT_COLUMNS,
				Studio.DEFAULT_TILE_HEIGHT * Studio.DEFAULT_LOT_ROWS
			);*/
			//fg.graphics.endFill();

			trace('stage', width, height);
		}
		
		public function update():void
		{
			var p:Player = Studio.player;
			var s:Lot = Studio.currentLot;
			
			if (active)
			{
				//trace('updating stage', p, s);
			}
		}

		public static function get currentScene():Scene
		{
			return _currentScene;
		}

		public static function set currentScene(value:Scene):void
		{
			_currentScene = value;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			var child:DisplayObject;
			
			// propagate active value to children
			for (var i:uint = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
					
				if (child.hasOwnProperty("active"))
				{
					trace(child);
					child['active'] = value;
				}
				if (child is BitmapRenderer)
				{
					if (value)
						BitmapRenderer(child).emitters[0].start();
					else BitmapRenderer(child).emitters[0].stop();
				}
			}
			
			if (!value)
			{
				// tint
				//this.alpha = .5;
			}
			else
			{
				// remove tint
				//this.alpha = 1;
			}
		}

		public function get lightingType():String
		{
			return _lightingType;
		}

		public function set lightingType(value:String):void
		{
			_lightingType = value;
		}


	}
}