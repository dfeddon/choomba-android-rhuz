package com.choomba.vo
{
	public class InventoryActionVO
	{
		public static const INVENTORY_ACTION_DROP:String = 'drop';
		public static const INVENTORY_ACTION_DRINK:String = 'drink';
		public static const INVENTORY_ACTION_POUR:String = 'pour';
		public static const INVENTORY_ACTION_WEAR:String = 'wear';
		public static const INVENTORY_ACTION_REMOVE:String = 'remove';
		public static const INVENTORY_ACTION_ATTACK:String = 'attack';
		public static const INVENTORY_ACTION_READ:String = 'read';
		public static const INVENTORY_ACTION_BLOW:String = 'blow';
		public static const INVENTORY_ACTION_EAT:String = 'eat';
		
		private var _name:String;
		private var _type:String;
		
		public function InventoryActionVO(actionType:String)
		{
			type = actionType;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			
			switch(value)
			{
				case INVENTORY_ACTION_DROP:
					_name = 'Drop';
					break;
				case INVENTORY_ACTION_DRINK:
					_name = 'Quaff (Drink)';
					break;
				case INVENTORY_ACTION_POUR:
					_name = 'Pour';
					break;
				case INVENTORY_ACTION_WEAR:
					_name = 'Don (Wear)';
					break;
				case INVENTORY_ACTION_REMOVE:
					_name = 'Doff (Remove)';
					break;
				case INVENTORY_ACTION_ATTACK:
					_name = 'Attack';
					break;
				case INVENTORY_ACTION_READ:
					_name = 'Read';
					break;
				case INVENTORY_ACTION_BLOW:
					_name = 'Blow';
					break;
				case INVENTORY_ACTION_EAT:
					_name = 'Ingest (Eat)';
					break;
			}
		}


	}
}