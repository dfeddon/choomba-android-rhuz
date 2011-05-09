package com.dfeddon.rhuz
{
	import com.choomba.Image;
	import com.choomba.Npc;
	import com.choomba.vo.NpcVO;
	import com.choomba.vo.SheetMapVO;
	
	import flash.events.TouchEvent;
	
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
				sheet.mapArray.push(new SheetMapVO(1, [0,1,2,3,4,5,6,7,8], 'toPileW', false, false));
				sheet.mapArray.push(new SheetMapVO(2, [9,10,11,12,13,14,15,16], 'fromPileW', false, false));
				//sheet.mapArray.push(new SheetMapVO(3, [18,19,20,21,22,23,24,25], 'walkNorth', true));
				//sheet.mapArray.push(new SheetMapVO(4, [27,28,29,30,31,32,33,34], 'walkSouth', true));
				
				sheet.mapArray.push(new SheetMapVO(3, [0], 'standWest', false));
				sheet.mapArray.push(new SheetMapVO(4, [9], 'pile', false));
				//sheet.mapArray.push(new SheetMapVO(7, [26], 'standNorth', false));
				//sheet.mapArray.push(new SheetMapVO(8, [35], 'standSouth', false));
			}
			
			sheet.play('pile');
			//blendMode = BlendMode.SCREEN;
			
			//addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		private function touchEndHandler(e:TouchEvent):void
		{
			sheet.play('fromPileW');
		}
	}
}