package com.choomba
{
	import com.choomba.vo.InventoryTypeVO;
	import com.choomba.vo.InventoryVO;
	import com.choomba.vo.ItemVO;

	public class Item extends Prop
	{
		private var _vo:ItemVO;
		
		public function Item()
		{
			super();
			
			this.mouseEnabled = false;
		}
		
		public function itemToInv():void
		{
			Studio.player.inv.push(new InventoryVO
				(
					_vo.name, 
					new InventoryTypeVO(_vo.invType), 
					AssetManager.getInstance()[_vo.imgL],
					_vo.desc,
					this
				)
			);

		}

		public function get vo():ItemVO
		{
			return _vo;
		}

		public function set vo(value:ItemVO):void
		{
			_vo = value;
		}

	}
}