package com.choomba
{
	import com.choomba.vo.InventoryActionVO;
	import com.choomba.vo.InventoryVO;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;

	public class InventoryPopup extends AbstractPopup
	{
		private const WIN_ITEM_POINT:Point = new Point(50, 75);
		private const WIN_ACTION_POINT:Point = new Point(340, 75);
		
		private var _cItem:InventoryVO;
		private var _cAction:String;
		private var txtDesc:TextField;
		private var playerInv:Array = new Array();
		private var viewActions:Sprite;
		
		private var iwin:Sprite;
		//private var isel:Shape;
		//private var atf:TextFormat;
		
		public function InventoryPopup(xOffset:int=0, yOffset:int=0)
		{
			super(xOffset, yOffset);
			
			//addChild(new Image(AssetManager.getInstance().winBGImg));
			
			// text
			var h1:TextField = new TextField();
			var h2:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			h1.text = 'Inventory';
			h1.textColor = 0xffff99;
			h1.x = 50;
			h1.y = 30;
			h1.width = 200;
			h2.text = 'Actions';
			h2.textColor = 0xffff99;
			h2.x = 340;
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
			txtDesc.textColor = 0xffff99;
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
			
			// actions sprite
			viewActions = new Sprite();
			var ap:Point = WIN_ACTION_POINT;// new Point(50, 75);
			viewActions.graphics.lineStyle(1, 0xffffff, 1);
			viewActions.graphics.drawRoundRect(ap.x, ap.y, 200, 
				Studio.DEFAULT_TILE_HEIGHT * 4, 15);
			addChild(viewActions);
			
			// submit
			//buildActions();//(itms, pt);
			var sbt:TextField = new TextField();
			var sbtf:TextFormat = new TextFormat();
			sbtf.size = 18;
			sbtf.align = 'center';
			sbt.width = 200;
			sbt.multiline = true;
			sbt.selectable = false;
			sbt.textColor = 0xffffff;
			sbt.htmlText = '<b>YES, Submit<br>Thy Request</b>';
			sbt.x = 555;
			sbt.y = 150;
			sbt.setTextFormat(sbtf);
			sbt.addEventListener(MouseEvent.CLICK, submitClickHandler);
			addChild(sbt);
		}
		
		private function buildList(win:Sprite, pt:Point):void
		{
			iwin = win;
			
			var ar:Array = Studio.player.inv;
			
			var spr:Sprite;
			//var shp:Shape;
			var img:Image;
			var row:int = 0;
			var col:int = 0;
			
			for each(var vo:InventoryVO in ar)
			//for (var i:uint = 0; i < ar.length; i++)
			{
				//var vo:InventoryVO = ar[i] as InventoryVO;
				
				playerInv.push(vo);
				
				spr = new Sprite();
				
				img = new Image(vo.image);
				spr.addChild(img);
				spr.x = pt.x + (Studio.DEFAULT_TILE_WIDTH * col + 10);
				spr.y = pt.y + (Studio.DEFAULT_TILE_HEIGHT * row);
				
				win.addChild(spr);
				
				row++;
				
				if (row == 4)
				{
					row = 0;
					col = 1;
				}
			}
			
			win.addEventListener(MouseEvent.CLICK, itemClickHandler);
		}
		
		private function submitClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			trace("SUBMIT", _cItem.name, _cAction);
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			/*if (e.localX > 785 && e.localY < 15)
				closePopup();*/
			
			//trace('::', e.localX, e.localY);
			var r:int = Math.floor((e.localY + e.target.y) / WIN_ITEM_POINT.y);
			var c:int = Math.floor((e.localX + e.target.x) / (WIN_ITEM_POINT.x+10));
			var ci:int;
			if (c > 1)
				ci = r * 1 + ((c-1) * 4);
			else ci = r * c;
			//trace('r', r, 'c', c, '=', ci);
			
			var s:Sprite;
			for (var i:uint = 0; i < iwin.numChildren; i++)
			{
				s = iwin.getChildAt(i) as Sprite;
				
				s.graphics.lineStyle(2, 0x000000, 1);
				s.graphics.moveTo(5,5);
				s.graphics.lineTo(15, 5);
				s.graphics.moveTo(5,5);
				s.graphics.lineTo(5, 15);
				s.graphics.moveTo(55, 60);
				s.graphics.lineTo(45, 60);
				s.graphics.moveTo(55, 60);
				s.graphics.lineTo(55, 50);
			}
			
			cItem = Studio.player.inv[ci - 1];
			var spr:Sprite = e.target as Sprite;
			spr.graphics.lineStyle(2, 0x00ff00, 1);
			spr.graphics.moveTo(5,5);
			spr.graphics.lineTo(15, 5);
			spr.graphics.moveTo(5,5);
			spr.graphics.lineTo(5, 15);
			spr.graphics.moveTo(55, 60);
			spr.graphics.lineTo(45, 60);
			spr.graphics.moveTo(55, 60);
			spr.graphics.lineTo(55, 50);
			
			trace('item clicked', ci);/*, Math.floor(e.localX / WIN_ITEM_POINT.x), 
				Math.floor(e.localY / WIN_ITEM_POINT.y));*/
		}
		
		private function buildActions():void
		{
			trace('actions');
			
			// clear extant actions
			while (viewActions.numChildren) 
				viewActions.removeChildAt(0);
			
			var txt:TextField;// = new TextField();
			var dObj:DisplayObject;
			
			var count:int = 0;
			for each(var i:InventoryActionVO in _cItem.type.actions)
			{
				trace('::', i.name);
				txt = new TextField();
				txt.addEventListener(MouseEvent.CLICK, actionClickHandler);
				var atf:TextFormat = new TextFormat();
				atf.size = 24;
				
				txt.text = i.name;
				txt.selectable = false;
				txt.mouseEnabled = true;
				txt.textColor = 0xffffff;
				txt.x = WIN_ACTION_POINT.x + 10;
				txt.y = WIN_ACTION_POINT.y + 10 + (count * 44);
				txt.width = 225;
				txt.setTextFormat(atf);
				
				dObj = viewActions.addChild(txt);
				count++;
			}
			//trace(_cItem.name);
		}
		
		private function actionClickHandler(e:MouseEvent):void
		{
			var txt:TextField = e.currentTarget as TextField;
			trace('action clicked', txt.text);
			_cAction = txt.text.toLocaleLowerCase();
			
			// clear styles
			for (var i:uint = 0; i < viewActions.numChildren; i++)
			{
				TextField(viewActions.getChildAt(i)).textColor = 0xffffff;
			}
			
			// add highlight style
			var tf:TextFormat = new TextFormat();
			tf.color = 0x00ff00;
			txt.setTextFormat(tf);
		}
		
		override protected function closePopup():void
		{
			removeEventListener(MouseEvent.CLICK, itemClickHandler);
			
			super.closePopup();
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
			txtDesc.text = value.name.toUpperCase() + ' : ' + value.desc;
			
			buildActions();
		}

	}
}