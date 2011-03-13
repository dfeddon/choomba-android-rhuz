package com.choomba.fx
{
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
			counter = new Blast( 30 );
			
			addInitializer( new SharedImage( new Dot( 2 ) ) );
			addInitializer( new ColorInit( 0xFFFF00FF, 0xFF00FFFF ) );
			addInitializer( new Position( new RectangleZone( 10, 10, 380, 380 ) ) );
			
			addAction( new MutualGravity( 10, 500, 3 ) );
			addAction( new BoundingBox( 0, 0, 400, 400 ) );
			addAction( new SpeedLimit( 150 ) );
			addAction( new Move() );
		}
	}
}