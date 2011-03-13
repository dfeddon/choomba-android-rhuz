package com.choomba
{
	import com.choomba.Image;
	import com.choomba.fx.MutualG;
	import com.choomba.fx.Sparkler;
	import com.dfeddon.rhuz.Player;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	
	public class PlayerSplash extends Splash
	{
		public var equip:Sprite;
		public var magic:Sprite;
		public var items:Sprite;
		public var journal:Sprite;
		
		private var emitter:Emitter2D;
		
		public function PlayerSplash()//caller:DisplayObject=null, width:int=200, height:int=200, transparency:Number=1, type:String="")
		{
			//super(caller, width, height, transparency, type);
			
			caller = Studio.player;
			splashWidth = 100;
			splashHeight = 100;
			splashAlpha = 0;
		}
		
		override protected function init(e:Event):void
		{
			var p:Player = Studio.player;
			var spd:Number = .25;
			
			super.init(e);
			
			// equip
			var t1:Object = new Object();
			t1.alpha = 1;
			
			equip = addChild(new Sprite) as Sprite;
			equip.name = 'equip';
			equip.addChild(new Image(AssetManager.getInstance().invEquipImg));
			
			equip.x = p.x - (equip.width / 2);
			equip.y = p.y - (equip.height / 2);
			
			t1.x = p.x + (equip.width / 2) + 5;
			t1.y = p.y - (equip.height / 2);
			
			var tween1:GTween = new GTween(equip, spd, t1);
			tween1.ease = Exponential.easeInOut;
			
			equip.addEventListener(MouseEvent.CLICK, clickInvHandler);
			
			// magic
			var t2:Object = new Object();
			t2.alpha = 1;
			
			magic = addChild(new Sprite) as Sprite;
			magic.name = 'magic';
			magic.addChild(new Image(AssetManager.getInstance().invMagicImg));

			magic.x = p.x - (magic.width / 2);
			magic.y = p.y - (magic.height / 2);
			
			t2.x = p.x - (magic.width / 2);
			t2.y = p.y - (p.height / 2) - (magic.height) - 10;
			
			var tween2:GTween = new GTween(magic, spd, t2);
			tween2.ease = Exponential.easeInOut;
			
			magic.addEventListener(MouseEvent.CLICK, clickInvHandler);
			
			// items
			var t3:Object = new Object();
			t3.alpha = 1;
			
			items = addChild(new Sprite) as Sprite;
			items.name = 'items';
			items.addChild(new Image(AssetManager.getInstance().invItemsImg));
			
			items.x = p.x - (items.width / 2);
			items.y = p.y - (items.height / 2);
			
			t3.x = p.x - (p.width / 4) - items.width - 5;
			t3.y = p.y - (items.height / 2);
			
			var tween3:GTween = new GTween(items, spd, t3);
			tween3.ease = Exponential.easeInOut;
			
			items.addEventListener(MouseEvent.CLICK, clickInvHandler);
			
			// journal
			var t4:Object = new Object();
			t4.alpha = 1;
			
			journal = addChild(new Sprite) as Sprite;
			journal.name = 'journal';
			journal.addChild(new Image(AssetManager.getInstance().invJournalImg));

			journal.x = p.x - (journal.width / 2);
			journal.y = p.y - (journal.height / 2);

			t4.x = p.x - (journal.width / 2);
			t4.y = p.y + (p.height / 2);
			
			var tween4:GTween = new GTween(journal, spd, t4);
			tween4.ease = Exponential.easeInOut;
			
			journal.addEventListener(MouseEvent.CLICK, clickInvHandler);
		}
		
		private function clickInvHandler(e:MouseEvent):void
		{
			trace('clicked', e.currentTarget.name);
			
			var p:Player = Studio.player;
			
			switch(e.currentTarget.name)
			{
				case 'magic':
					
					emitter = new MutualG();
					
					var area:int = 200;
					var renderer:BitmapRenderer = new BitmapRenderer( 
						new Rectangle( p.x - (area/2), p.y - (area/2), area, area ) 
					);
					renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
					renderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.95,0 ] ) );
					Studio.currentLot.addChild( renderer );
					
					emitter = new Sparkler( renderer );
					renderer.addEmitter( emitter );
					emitter.start( );
					/*renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
					renderer.addEmitter( emitter );
					Studio.currentLot.addChild( renderer );
					emitter.start( );*/
					
					break;
				
				case 'items':
					break;
				
				case 'equip':
					Studio.currentLot.active = false;
					
					var inv:InventoryPopup = new InventoryPopup();
					
					break
					
				case 'journal':
					break;
				
				default: trace('error');
			}
		}
		
		override public function remove():void
		{
			super.remove();
			
			Studio.player.pSplash = null;
		}
	}
}