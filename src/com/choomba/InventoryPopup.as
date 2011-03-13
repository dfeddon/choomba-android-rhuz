package com.choomba
{
	import com.choomba.vo.InventoryVO;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class InventoryPopup extends AbstractPopup
	{
		private const WIN_ITEM_POINT:Point = new Point(50, 75);
		
		private var _cItem:InventoryVO;
		private var txtDesc:TextField;
		
		public function InventoryPopup(xOffset:int=0, yOffset:int=0)
		{
			super(xOffset, yOffset);
			
			//addChild(new Image(AssetManager.getInstance().winBGImg));
			
			// text
			var h1:TextField = new TextField();
			var h2:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			h1.text = 'Inventory Items';
			h1.textColor = 0xffffff;
			h1.x = 50;
			h1.y = 30;
			h1.width = 200;
			h2.text = 'Actions';
			h2.textColor = 0xffffff;
			h2.x = 400;
			h2.y = 30;
			h1.setTextFormat(tf);
			h2.setTextFormat(tf);
			addChild(h1);
			addChild(h2);
			
			// item sprite
			var itms:Sprite = new Sprite();
			var pt:Point = WIN_ITEM_POINT;// new Point(50, 75);
			itms.graphics.lineStyle(1, 0xffffff, 1);
			itms.graphics.drawRoundRect(pt.x, pt.y, Studio.DEFAULT_TILE_WIDTH * 4, 
				Studio.DEFAULT_TILE_HEIGHT * 4, 15);
			addChild(itms);
			// item grid
			buildList(itms, pt);
			
			// add description text field
			txtDesc = new TextField();
			var tdf:TextFormat = new TextFormat();
			tdf.size = 24;
			txtDesc.textColor = 0xffffff;
			txtDesc.x = 50;
			txtDesc.y = pt.y + itms.height + 10;
			txtDesc.multiline = true;
			txtDesc.wordWrap = true;
			txtDesc.width = 700;
			txtDesc.height = 200;
			txtDesc.text = 'Select an item above to view a more detailed description.';
			txtDesc.setTextFormat(tdf);
			addChild(txtDesc);
			// listeners
			//addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function buildList(win:Sprite, pt:Point):void
		{
			var ar:Array = Studio.player.inv;
			
			var img:Image;
			var row:int = 0;
			var col:int = 0;
			
			for (var i:uint = 0; i < ar.length; i++)
			{
				var vo:InventoryVO = ar[i] as InventoryVO;				
				img = new Image(vo.image);
				img.x = pt.x + (Studio.DEFAULT_TILE_WIDTH * col);
				img.y = pt.y + (Studio.DEFAULT_TILE_HEIGHT * row);
				
				win.addChild(img);
				
				row++;
				
				if (row == 4)
				{
					row = 0;
					col = 1;
				}
			}
			
			win.addEventListener(MouseEvent.CLICK, itemClickHandler);
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			var r:int = Math.floor(e.localY / WIN_ITEM_POINT.y);
			var c:int = Math.floor(e.localX / WIN_ITEM_POINT.x);
			var ci:int;
			if (c > 1)
				ci = r * 1 + ((c-1) * 4);
			else ci = r * c;
			trace('r', r, 'c', c, '=', ci);
			
			cItem = Studio.player.inv[ci - 1];
			trace('item clicked', ci);/*, Math.floor(e.localX / WIN_ITEM_POINT.x), 
				Math.floor(e.localY / WIN_ITEM_POINT.y));*/
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			//removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(MouseEvent.CLICK, itemClickHandler);
			
			closePopup();
		}

		public function get cItem():InventoryVO
		{
			return _cItem;
		}

		public function set cItem(value:InventoryVO):void
		{
			if (!value) return;
			
			_cItem = value;
			
			// update description text
			txtDesc.defaultTextFormat = txtDesc.getTextFormat();
			txtDesc.text = value.desc;
		}

	}
}