package com.choomba.sqlite
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SQLBase extends EventDispatcher
	{
		public function SQLBase(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}