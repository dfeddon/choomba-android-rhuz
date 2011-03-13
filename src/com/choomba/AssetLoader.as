package com.choomba
{
	import com.choomba.vo.AssetVO;
	
	import flash.display.Loader;
	
	public class AssetLoader extends Loader
	{
		private var _vo:AssetVO;
		
		public function AssetLoader()
		{
			super();
		}

		public function get vo():com.choomba.vo.AssetVO
		{
			return _vo;
		}

		public function set vo(value:AssetVO):void
		{
			_vo = value;
		}

	}
}