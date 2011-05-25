package com.dfeddon.rhuz
{
	import com.choomba.Image;
	import com.choomba.Npc;
	import com.choomba.vo.NpcVO;
	import com.choomba.vo.SheetMapVO;
	
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.utils.Timer;
	
	public class Skeleton extends Npc
	{
		public function Skeleton(image:Image=null, isSheet:Boolean=false, vo:NpcVO=null)
		{
			super(image, isSheet, vo);
			active = true;
			
			x = this.vo.loc.x;
			y = this.vo.loc.y;
			
			sheetTileWidth = 64;
			sheetTileHeight = 64;
			sheetFrameRate = 1;
			speed = 15;
			
			//super(image, isSheet);
			
			if (isSheet)
			{
				sheet.mapArray.push(new SheetMapVO(1, [0,1,2,3,4,5,6,7,8], 'toPileW', 1, false, this));
				sheet.mapArray.push(new SheetMapVO(2, [9,10,11,12,13,14,15,16,17], 'fromPileW', 1, false, this, 3));
				sheet.mapArray.push(new SheetMapVO(3, [18,19,20,21,22,23,24], 'toSitting', 1, false, this, 4));
				sheet.mapArray.push(new SheetMapVO(4, [27,28,29,30,31,32,33], 'talking', 2, true, this, 4));
				
				sheet.mapArray.push(new SheetMapVO(5, [0], 'standWest', 1, true, this));
				sheet.mapArray.push(new SheetMapVO(6, [9], 'pile', 1, true, this));
				sheet.mapArray.push(new SheetMapVO(7, [24], 'sit', 1, true, this));
			}
			
			sheet.play('pile');
			
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		private function touchEndHandler(e:TouchEvent):void
		{
			sheet.play('fromPileW');
		}
		
		private function timerCompleteHandler(e:TimerEvent):void
		{
			sheet.play('toSitting');
		}
		
		override public function sheetComplete(vo:SheetMapVO):void
		{
			super.sheetComplete(vo);
			
			trace('skeleton sheet complete', vo.type);
			
			switch(vo.type)
			{
				case 'fromPileW':
					sheet.play('talking');
					break;
				
				case 'talking':
					var timer:Timer = new Timer(2000, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
					timer.start();
					break;
				
				case 'toSitting':
					sheet.play('sit');
					break;
				
				default: trace('skeleton sheet end:', vo.type);
			}

		}
	}
}