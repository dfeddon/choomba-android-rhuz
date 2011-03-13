package com.choomba
{
	import com.choomba.vo.AssetVO;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class AssetURLLoader extends URLLoader
	{
		private var _vo:AssetVO;
		
		public function AssetURLLoader(request:URLRequest=null, assetVO:AssetVO=null)
		{
			if (assetVO) vo = assetVO;
			
			super(request);
		}

		public function get vo():AssetVO
		{
			return _vo;
		}

		public function set vo(value:AssetVO):void
		{
			_vo = value;
		}

	}
}