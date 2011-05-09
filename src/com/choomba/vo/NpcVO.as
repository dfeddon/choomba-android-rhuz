
package com.choomba.vo
{
	import com.choomba.Studio;
	
	import flash.geom.Point;
	
	public class NpcVO
	{
		private var _id:String;
		private var _imgCoord:Point;
		private var _loc:Point;
		private var _pos:Point;
		private var _image:String;
		
		public function NpcVO(xml:XML)
		{
			_id = xml.@id;
			_image = xml.@image;
			
			var ic:Array = String(xml.@imgCoord).split(',');
			_imgCoord = new Point(Number(ic[0]), Number(ic[1]));
			
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

		public function get imgCoord():Point
		{
			return _imgCoord;
		}

		public function set imgCoord(value:Point):void
		{
			_imgCoord = value;
		}

		public function get loc():Point
		{
			return _loc;
		}

		public function set loc(value:Point):void
		{
			_loc = value;
		}

		public function get pos():Point
		{
			return _pos;
		}

		public function set pos(value:Point):void
		{
			_pos = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}


	}
}