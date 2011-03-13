package com.choomba
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	public class Splash extends Sprite
	{
		private var _splashWidth:int;
		private var _splashHeight:int;
		private var _type:String;
		private var _caller:DisplayObject;
		private var _splashAlpha:Number;
		
		public function Splash(caller:DisplayObject=null, width:int=200, height:int=200, transparency:Number=1, type:String="")
		{
			super();
			
			_splashWidth = width;
			_splashHeight = height;
			_type = type;
			
			if (!caller)
				_caller = this;
			else _caller = caller;
			
			_splashAlpha = transparency;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// set boundaries
			graphics.beginFill(0x000000, splashAlpha);
			graphics.drawRect(
				caller.x - (splashWidth / 2),
				caller.y - (splashHeight / 2), 
				splashWidth,
				splashHeight
			);
			graphics.endFill();

		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			// suppress event from bubbling
			e.stopImmediatePropagation();
		}
		
		public function remove():void
		{
			// remove listener
			removeEventListener(MouseEvent.CLICK, clickHandler);
			
			// re-enable lot
			Studio.currentLot.active = true;
			
			// remove splash
			Studio.currentLot.removeChild(this);
		}

		public function get splashWidth():int
		{
			return _splashWidth;
		}

		public function set splashWidth(value:int):void
		{
			_splashWidth = value;
		}

		public function get splashHeight():int
		{
			return _splashHeight;
		}

		public function set splashHeight(value:int):void
		{
			_splashHeight = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get caller():DisplayObject
		{
			return _caller;
		}

		public function set caller(value:DisplayObject):void
		{
			_caller = value;
		}

		public function get splashAlpha():Number
		{
			return _splashAlpha;
		}

		public function set splashAlpha(value:Number):void
		{
			_splashAlpha = value;
		}


	}
}