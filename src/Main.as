package
{
	import com.choomba.AssetManager;
	import com.choomba.Fog;
	import com.choomba.Image;
	import com.choomba.Level;
	import com.choomba.Lot;
	import com.choomba.Sheet;
	import com.choomba.SteadyCam;
	import com.choomba.Studio;
	import com.choomba.TileBackground;
	import com.choomba.TileCode;
	import com.choomba.fx.Fire;
	import com.choomba.vo.InventoryTypeVO;
	import com.choomba.vo.InventoryVO;
	import com.dfeddon.rhuz.Basement;
	import com.dfeddon.rhuz.Player;
	import com.efnx.fps.fpsBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.profiler.showRedrawRegions;
	import flash.system.System;
	import flash.utils.Timer;
	
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	
	public class Main extends Studio
	{
		public function Main()
		{
			super();
		}
		
		override protected function assetsLoadedHandler(e:Event):void
		{
			var basement:Lot = new Lot();
			basement.fogEnabled = true;
			basement.tileBG = 's1FloorImg';
			basement.tileMapSource = 'scene1';
			basement.playerImage = 'playerMageImg';
			basement.startTile = [1, 23];

			var incubus:Lot = new Lot();
			incubus.fogEnabled = true;
			incubus.tileBG = 's2FloorImg';
			incubus.tileMapSource = 'scene2';
			incubus.playerImage = 'playerMageImg';
			incubus.startTile = [12,12];

			addStage(basement);
			
			level = new TileCode(currentLot.tileMapSource);
			
			currentLot.addChild(level);
			
			// add items
			
			
			// add player to stage
			var img:Image = new Image(AssetManager.getInstance()[currentLot.playerImage]);
			var startX:int = currentLot.startTile[0] * Studio.DEFAULT_TILE_WIDTH;
			var startY:int = currentLot.startTile[1] * Studio.DEFAULT_TILE_HEIGHT;
			player = new Player(img, true, startX, startY);
			addPlayer(player);
			//trace('x', player.x, 'y', player.y);
			//player.moveToPos(new Point(player.x, player.y), 20);
			
			// add fg
			//currentLot.setChildIndex(currentLot.fg, currentLot.numChildren - 1);
			
			// add fog
			if (currentLot.fogEnabled)
			{
				fog = currentLot.addChild(new Fog) as Fog;
				fog.name = 'fog';
				Studio.fog.update();
			}
			
			cam = currentLot.addChild(new SteadyCam) as SteadyCam;
			
			
			// debugger
			var fps:fpsBox = new fpsBox(stage);
			addChild(fps);
			
			//flash.profiler.showRedrawRegions(true, 0x0000ff);
			
			// 3 sec delay (for mobile)
			var timer:Timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, playerStartPos);
			timer.start();
			
		}
		
		override protected function playerStartPos(e:TimerEvent):void
		{
			super.playerStartPos(e);
			
			// add start items
			Studio.player.inv.push(new InventoryVO('Potion of Healing', new InventoryTypeVO(InventoryTypeVO.INVENTORY_TYPE_POTION), 
				AssetManager.getInstance().invPotionBlueImg,
				'This is the potion description and lets just see how many lines we can print on this particular item.'
				)
			);
			Studio.player.inv.push(new InventoryVO('Scroll of Recall', new InventoryTypeVO(InventoryTypeVO.INVENTORY_TYPE_SCROLL), 
				AssetManager.getInstance().invScroll1Img,
				'When invoked, when need for urgent flight arises suddenly, user is instantly relocated to an unknown location.'
				)
			);
			Studio.player.inv.push(new InventoryVO('Guantlet of Strength', new InventoryTypeVO(InventoryTypeVO.INVENTORY_TYPE_WEARABLE), 
				AssetManager.getInstance().invGauntletBronzeImg,
				'Wearer will receive a surge of strength in the hand that wears the bronze gauntlet.'
			)
			);
			Studio.player.inv.push(new InventoryVO('Horn of Blasting', new InventoryTypeVO(InventoryTypeVO.INVENTORY_TYPE_BLOWABLE), 
				AssetManager.getInstance().invHornBlastingImg,
				'When blown, will rattle the very firmaments.'
			)
			);
			Studio.player.inv.push(new InventoryVO('Arrow', new InventoryTypeVO(InventoryTypeVO.INVENTORY_TYPE_WEAPON), 
				AssetManager.getInstance().invArrowImg,
				'An flat-head arrow with the thinnest of fletchings.'
			)
			);
			Studio.player.inv.push(new InventoryVO('Herbs', new InventoryTypeVO(InventoryTypeVO.INVENTORY_TYPE_EDIBLE), 
				AssetManager.getInstance().invHerbsImg,
				'A small, leafy handful of herbs.'
			)
			);
			
			var fire:Fire = new Fire();
			fire.x = 12 * 64 + (64 / 2);
			fire.y = 12 * 64 + (64 / 2);
			fire.start();
			
			var renderer:BitmapRenderer = new BitmapRenderer( new Rectangle( fire.x - 50, fire.y - 50, 100, 100 ) );
			//renderer.addEmitter( smoke );
			renderer.addEmitter( fire );
			fire.start();
			var fow:DisplayObject = currentLot.getChildByName('fog');
			var obj:DisplayObject = currentLot.addChildAt(renderer, currentLot.getChildIndex(fow) - 1);
			//obj.x = 12 * 64;
			//obj.y = 12 * 64;
		}
	}
}