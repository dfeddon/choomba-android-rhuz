package com.choomba.vo
{
	public class InventoryTypeVO
	{
		public static const INVENTORY_TYPE_POTION:String = 'invTypePotion';
		public static const INVENTORY_TYPE_WEAPON:String = 'invTypeWeapon';
		public static const INVENTORY_TYPE_SCROLL:String = 'invTypeScroll';
		public static const INVENTORY_TYPE_WEARABLE:String = 'invTypeWearable';
		public static const INVENTORY_TYPE_BLOWABLE:String = 'invTypeBlowable';
		public static const INVENTORY_TYPE_EDIBLE:String = 'invTypeEdible';
		
		private var _type:String;
		private var _actions:Array = new Array();
		
		public function InventoryTypeVO(inventoryType:String)
		{
			_type = inventoryType;
			
			defaultActions();
		}
		
		private function defaultActions():void
		{
			switch(_type)
			{
				case INVENTORY_TYPE_POTION:
					_actions = 
					[
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DRINK),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DROP),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_POUR)
					];
					break;
				
				case INVENTORY_TYPE_SCROLL:
					_actions = 
					[
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DROP),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_READ)
					];
					break;
				
				case INVENTORY_TYPE_WEAPON:
					_actions = 
					[
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_ATTACK),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DROP)
					];
					break;
				
				case INVENTORY_TYPE_WEARABLE:
					_actions = 
					[
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_WEAR),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_REMOVE),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DROP)
					];
					break;
				
				case INVENTORY_TYPE_BLOWABLE:
					_actions = 
					[
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_BLOW),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DROP)
					];
					break;
				
				case INVENTORY_TYPE_EDIBLE:
					_actions = 
					[
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_EAT),
						new InventoryActionVO(InventoryActionVO.INVENTORY_ACTION_DROP)
					];
					break;
				
				default: trace('undefined inventory type!');
			}
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			
			defaultActions();
		}

		public function get actions():Array
		{
			return _actions;
		}

		public function set actions(value:Array):void
		{
			_actions = value;
		}


	}
}