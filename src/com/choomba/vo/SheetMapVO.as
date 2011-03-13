package com.choomba.vo
{
	public class SheetMapVO
	{
		private var _index:int;
		private var _aniMap:Array;
		private var _type:String;
		private var _repeater:Boolean;
		
		public function SheetMapVO(index:int=NaN, map:Array=null, type:String="", repeater:Boolean=true)
		{
			this.index = index;
			this.aniMap = map;
			if (type) this.type = type;
			this.repeater = repeater;
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


	}
}