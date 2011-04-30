package com.choomba.vo
{
	import com.choomba.Studio;
	
	import flash.geom.Point;

	public class ItemVO
	{
		private var _id:String;
		private var _imgS:String;
		private var _imgL:String;
		private var _takeable:Boolean;
		private var _loc:Point;
		private var _pos:Point;
		private var _desc:String;
		private var _invType:String;
		private var _name:String;
		
		public function ItemVO(xml:XML)
		{
			_id = xml.@id;
			_imgS = xml.@imgS;
			_imgL = xml.@imgL;
			_desc = xml.@desc;
			_invType = xml.@invType;
			_name = xml.@name;
			
			if (String(xml.@takeable).toLowerCase() == 'true')
				_takeable = true;
			else _takeable = false;
			
			var sp:Array = String(xml.@loc).split(',');
			_loc = new Point(Number(sp[0]), Number(sp[1]));
			_pos = new Point(Number(sp[0]) * Studio.DEFAULT_TILE_WIDTH, Number(sp[1]) * Studio.DEFAULT_TILE_HEIGHT);
		}
		
		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get imgS():String
		{
			return _imgS;
		}

		public function set imgS(value:String):void
		{
			_imgS = value;
		}

		public function get imgL():String
		{
			return _imgL;
		}

		public function set imgL(value:String):void
		{
			_imgL = value;
		}

		public function get takeable():Boolean
		{
			return _takeable;
		}

		public function set takeable(value:Boolean):void
		{
			_takeable = value;
		}

		public function get loc():Point
		{
			return _loc;
		}

		public function set loc(value:Point):void
		{
			_loc = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get invType():String
		{
			return _invType;
		}

		public function set invType(value:String):void
		{
			_invType = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get pos():Point
		{
			return _pos;
		}

		public function set pos(value:Point):void
		{
			_pos = value;
		}


	}
}