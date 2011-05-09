package com.choomba.vo
{
	public class SheetMapVO
	{
		private var _index:int;
		private var _aniMap:Array;
		private var _type:String;
		private var _repeater:Boolean;
		private var _reset:Boolean;
		
		public function SheetMapVO(index:int=NaN, map:Array=null, type:String="", 
								   repeater:Boolean=true, reset:Boolean=true)
		{
			_index = index;
			_aniMap = map;
			_repeater = repeater;
			_reset = reset;
			if (type) 
				_type = type;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get aniMap():Array
		{
			return _aniMap;
		}

		public function set aniMap(value:Array):void
		{
			_aniMap = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get repeater():Boolean
		{
			return _repeater;
		}

		public function set repeater(value:Boolean):void
		{
			_repeater = value;
		}

		public function get reset():Boolean
		{
			return _reset;
		}

		public function set reset(value:Boolean):void
		{
			_reset = value;
		}


	}
}