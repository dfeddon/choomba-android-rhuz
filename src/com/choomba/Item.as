package com.choomba
{
	import com.choomba.vo.InventoryTypeVO;
	import com.choomba.vo.InventoryVO;
	import com.choomba.vo.ItemVO;
	
	import flash.events.TouchEvent;

	public class Item extends Prop
	{
		private var _vo:ItemVO;
		
		public function Item()
		{
			super();
			
			this.mouseEnabled = false;
			addEventListener(TouchEvent.TOUCH_END, touchEndListener);
		}
		
		private function touchEndListener(e:TouchEvent):void
		{
			trace('touch!');
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