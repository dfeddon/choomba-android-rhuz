package com.choomba.vo
{
	import flash.geom.Point;
	
	import org.osmf.net.StreamingURLResource;

	public class AssetVO
	{
		public static const ASSET_TYPE_XML:String = 'assetTypeXML';
		public static const ASSET_TYPE_TMX:String = 'assetTypeTMX';
		public static const ASSET_TYPE_IMAGE:String = 'assetTypeImage';
		
		private var _src:String;
		private var _id:String;
		private var _type:String;
		
		public function AssetVO(assetId:String=null, assetSource:String=null, assetType:String=null)
		{
			super();
			
			if (assetId) id = assetId;
			if (assetSource) src = assetSource;
			if (assetType) type = assetType;
		}

		public function get src():String
		{
			return _src;
		}

		public function set src(value:String):void
		{
			_src = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}


	}
}