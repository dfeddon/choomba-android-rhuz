package com.choomba
{
	import com.gskinner.motion.GTween;
	
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
			trace('tween complete', e);
			
			moving = false;
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