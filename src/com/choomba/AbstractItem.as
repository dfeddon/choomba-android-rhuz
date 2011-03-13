package com.choomba
{
	import flash.display.Sprite;
	
	public class AbstractItem extends Sprite
	{
		public function AbstractItem()
		{
			super();
		}
		
		protected function addItem():void
		{
			trace('add item');
		}
		
		protected function removeItem():void
		{
			trace('remove item');
		}
		
		protected function takeItem():void
		{
			trace('take item');
		}
		
		protected function dropItem():void
		{
			trace('drop item');
		}
	}
}