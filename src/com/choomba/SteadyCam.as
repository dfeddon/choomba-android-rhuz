package com.choomba 
{
	import com.choomba.prose.ProseWin;
	import com.dfeddon.rhuz.Player;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.System;
	
	/**
	 * Henke's VCam v1.1
	 *
	 * VCam using the flash.geom package.
	 *
	 * Special Thanks to the authors of the other vcams, I wouldn't have been able to do this without their inspiration.
	 *
	 * @author Henrik "henke37" Andersson
	 * @version 1.0
	 * @created 24-June-2009
	 *
	 * Requirements: Flash CS3+ & Actionscript 3
	 */
	
	public class SteadyCam extends Sprite 
	{
		public static const CAMERA_OFFSET_X:int = 100;
		public static const CAMERA_OFFSET_Y:int = 100;
		private static const CAMERA_SPEED_MULTIPLE:int = 10; 
		
		public static var active:Boolean;
		
		public static const CAMERA_SPEED:int = 1;
		private var moveObj:Image;
		
		private var _basePos:Matrix;
		
		private var tween:GTween;
		
		public function SteadyCam() 
		{
/*			moveObj = new Image();
			//moveObj.x = Studio.player.x;
			//moveObj.y = Studio.player.y;
			moveObj.visible = false;
*/			
			visible = false;
			
			addEventListener(Event.ADDED, added);
			addEventListener(Event.REMOVED, removed);
			//addEventListener(Event.RENDER, onRend);
			
			//Studio.studio.camComplete(this);
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED, added);
			
			if( parent.blendMode == BlendMode.NORMAL) 
			{
				//if there isn't any blendmode set yet,
				//set it as layer so that possible alpha rendering actually looks good
				parent.blendMode = BlendMode.LAYER;
			}
			
			//addEventListener(Event.ENTER_FRAME,eFrame,false,0,true);
			
		}
		
		private function removed(e:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, eFrame, false);
			removeEventListener(Event.REMOVED, removed);
			
			parent.transform.matrix = new Matrix();
			parent.transform.colorTransform = new ColorTransform();
			parent.alpha = 1;
		}
		
		public function update(e:Event):void //eFrame(e:Event=null):void
		{
			stage.invalidate();
		//}
		
		//private function onRend(e:Event):void
		//{
			
			if(!basePos) 
			{
				basePos = parent.transform.matrix;
			}
			else
			{
				basePos.tx = Math.round(moveObj.x);
				basePos.ty = Math.round(moveObj.y);
			}
			
			//trace(basePos.tx, basePos.ty);
			
			//set up the movement/rotation data
			//the getter returns a copy for us, we don't risk messing it up
			var t:Matrix = transform.matrix;
			
			//then just invert it, leaving us with the exact matrix we need to
			//get the parent into the position the camera should be in
			t.invert();
			
			var t2:Matrix = basePos.clone();
			
			t2.concat(t);
			
			//do the moving
			parent.transform.matrix = t2;
			
			//people want to use these too
			parent.transform.colorTransform = transform.colorTransform;
			parent.blendMode = blendMode;
			parent.filters = filters;
			parent.alpha = alpha;
			
		}
		
		public function reset():void
		{
			// clear previous tween
			tween.onComplete = null;
			tween.resetValues();
		}

		public function moveToPos(pTo:Point, s:int):void
		{
			//trace("=======");
			var player:Player = Studio.player;
			
			var offsetX:Number;
			var offsetY:Number;
			var p:Object = new Object();

			var pFrom:Point;
			var d:Number;
			var speed:int;

			if (active) 
				reset();
			
			offsetX = (stage.fullScreenWidth / 2) - pTo.x;
			offsetY = (stage.fullScreenHeight / 2) - pTo.y;
			
			var lotW:int = Studio.DEFAULT_LOT_COLUMNS * Studio.DEFAULT_TILE_WIDTH;
			var lotH:int = Studio.DEFAULT_LOT_ROWS * Studio.DEFAULT_TILE_HEIGHT;
			
			// stop at edges
			if (offsetX > 0) 
				offsetX = 0;  // west edge
			else if (offsetX < -((lotW)-(stage.fullScreenWidth)))
				offsetX = -((lotW)-(stage.fullScreenWidth)); // east edge
			if (offsetY > 0) 
				offsetY = 0; // north edge
			else if (offsetY < -((lotH)-(stage.fullScreenHeight)))
				offsetY = -((lotH)-(stage.fullScreenHeight)); // south edge
			
			p.x = Math.round(offsetX);	
			p.y = Math.round(offsetY);
			p.alpha = 1;
			
			if (!moveObj)
			{
				moveObj = new Image();
				moveObj.x = parent.transform.matrix.tx;
				moveObj.y = parent.transform.matrix.ty;
				moveObj.visible = false;
			}
			
			if (Studio.proseWin)
			{
				trace('::', Studio.proseWin.pos, pTo.x);
				/*if (Studio.proseWin.pos == ProseWin.POS_LEFT)
					pTo.x = 0;//Studio.proseWin.width;
				else pTo.x += (stage.fullScreenWidth - 100) / 2;*/// Studio.proseWin.width;
			}
			trace('->', pTo.x);
			
			// calculate speed
			pFrom = new Point(x, y);
			d = Point.distance(new Point(moveObj.x, moveObj.y), pTo);
			speed = d / (player.speed * CAMERA_SPEED_MULTIPLE);

			tween = new GTween(moveObj, speed, p);
			//tween.ease = Sine.easeInOut;
			tween.onComplete = tweenCompleteHandler;
			
			active = true;
			
			addEventListener(Event.ENTER_FRAME, update);//,false,0,true);
		}
		
		protected function tweenCompleteHandler(e:GTween=null):void
		{
			//trace('cam tween complete', e);
			//trace(this.x, this.y);
			removeEventListener(Event.ENTER_FRAME, update);
			tween.onComplete = null;
			
			active = false;
			
			System.gc();
		}
		
		public function get basePos():Matrix
		{
			return _basePos;
		}

		public function set basePos(value:Matrix):void
		{
			_basePos = value;
		}

	}
}