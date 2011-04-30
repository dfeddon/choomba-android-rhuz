package com.choomba.vo
{
	import com.choomba.Item;
	
	import flash.display.BitmapData;

	public class InventoryVO
	{
		private var _name:String;
		private var _type:InventoryTypeVO;
		private var _image:BitmapData;
		private var _desc:String;
		private var _item:Item;

		public function InventoryVO(name:String=null, type:InventoryTypeVO=null, 
									image:BitmapData=null, desc:String=null, item:Item=null)
		{
			if (name) _name = name;
			if (type) _type = type;
			if (image) _image = image;
			if (desc) _desc = desc;
			if (item) _item = item;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():InventoryTypeVO
		{
			return _type;
		}

		public function set type(value:InventoryTypeVO):void
		{
			_type = value;
		}

		public function get image():BitmapData
		{
			return _image;
		}

		public function set image(value:BitmapData):void
		{
			_image = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get item():Item
		{
			return _item;
		}

		public function set item(value:Item):void
		{
			_item = value;
		}


	}
}