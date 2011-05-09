package com.choomba
{
	import com.choomba.vo.NpcVO;

	public class Npc extends Actor
	{
		private var _vo:NpcVO;
		
		public function Npc(image:Image=null, isSheet:Boolean=false, vo:NpcVO=null)
		{
			super(image, isSheet);
			
			_vo = vo;
			
			setImage();
		}

		public function get vo():NpcVO
		{
			return _vo;
		}

		public function set vo(value:NpcVO):void
		{
			_vo = value;
		}

	}
}