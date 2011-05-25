package com.choomba.vo
{
	import com.choomba.Prop;

	public class SheetMapVO
	{
		private var _index:int;
		private var _aniMap:Array;
		private var _type:String;
		private var _repeater:int;
		private var _reset:Boolean;
		private var _owner:Prop;
		private var _speedOffset:int;
		
		public function SheetMapVO(index:int=NaN, map:Array=null, type:String="", 
								   repeater:int=0, reset:Boolean=true, owner:Prop=null,
									speedOffset:int=0)
		{
			_index = index;
			_aniMap = map;
			_repeater = repeater;
			_reset = reset;
			_speedOffset = speedOffset;
			if (type) 
				_type = type;
			if (owner)
				_owner = owner;
		}
		
		public function sheetComplete():void
		{
			if (_owner)
				_owner.sheetComplete(this);
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

		public function get repeater():int
		{
			return _repeater;
		}

		public function set repeater(value:int):void
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

		public function get owner():Prop
		{
			return _owner;
		}

		public function set owner(value:Prop):void
		{
			_owner = value;
		}

		public function get speedOffset():int
		{
			return _speedOffset;
		}

		public function set speedOffset(value:int):void
		{
			_speedOffset = value;
		}


	}
}