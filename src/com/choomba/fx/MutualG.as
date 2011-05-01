package com.choomba.fx
{
	import com.choomba.Studio;
	import com.dfeddon.rhuz.Player;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.BoundingBox;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.MutualGravity;
	import org.flintparticles.twoD.actions.SpeedLimit;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class MutualG extends Emitter2D
	{
		public function MutualG()
		{
			var p:Player = Studio.player;
			counter = new Blast( 20 );
			
			addInitializer( new SharedImage( new Dot( 2 ) ) );
			addInitializer( new ColorInit( 0xFFFF00FF, 0xFF00FFFF ) );
			addInitializer( new Position( new RectangleZone( p.x - 90, p.y - 90, 180, 180 ) ) );
			
			addAction( new MutualGravity( 10, 200, 3 ) );
			addAction( new BoundingBox( p.x - 100, p.y - 100, 200, 200 ) );
			addAction( new SpeedLimit( 150 ) );
			addAction( new Move() );
		}
	}
}