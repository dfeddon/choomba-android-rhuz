package com.choomba.fx
{
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.Line;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.activities.RotateEmitter;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	
	import flash.geom.Point;
	
	public class CatherineWheel extends Emitter2D
	{
		public function CatherineWheel()
		{
			counter = new Steady( 100 );
			
			addActivity( new RotateEmitter( -7 ) );
			
			addInitializer( new SharedImage( new Line( 3 ) ) );
			addInitializer( new ColorInit( 0xFFFFFF00, 0xFFFF6600 ) );
			addInitializer( new Velocity( new DiscSectorZone( new Point( 0, 0 ), 250, 170, 0, 0.2 ) ) );
			addInitializer( new Lifetime( 1.3 ) );
			
			addAction( new Age( Quadratic.easeIn ) );
			addAction( new Move() );
			//addAction( new Fade() );
			addAction( new Accelerate( 0, 50 ) );
			addAction( new LinearDrag( 0.5 ) );
		}
	}
}