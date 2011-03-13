package com.choomba
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import com.choomba.vo.AssetVO;

	public dynamic class AssetManager extends EventDispatcher
	{
		private static var _instance:AssetManager;
		
		private var assetLoader:AssetLoader;
		private var assetURLLoader:AssetURLLoader;
		private var assetRequest:URLRequest;
		
		private var assetsTotal:int;
		private var assetsLoaded:int;

		private var xmlArray:Array;
		private var tmxArray:Array;
		private var imagesArray:Array;
		
		private var _rawMaps:Array;
		
		public function AssetManager(enforcer:SingletonEnforcer)
		{
			rawMaps = new Array();
			
			assetsTotal = 0;
			assetsLoaded = 0;
		}

		public static function getInstance():AssetManager
		{
			if(AssetManager._instance == null)
			{
				AssetManager._instance = new AssetManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		public function loadData():void
		{
			trace('mem loadData', System.totalMemory / 1024);
			// first, load sources.xml
			var url:String = "assets/xml/sources.xml";
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, sourcesLoadedHandler);
		}

		private function sourcesLoadedHandler(event:Event):void
		{
			trace("sources.xml loaded.", System.totalMemory / 1024);
			trace(event.currentTarget.data);

			event.target.removeEventListener(Event.COMPLETE, sourcesLoadedHandler);

			var sources:XML = XML(event.currentTarget.data);
			
			xmlArray = xmlToArrayHelper(sources..xml.file, AssetVO.ASSET_TYPE_XML);
			tmxArray = xmlToArrayHelper(sources..tmx.file, AssetVO.ASSET_TYPE_TMX);
			imagesArray = xmlToArrayHelper(sources..images.file, AssetVO.ASSET_TYPE_IMAGE);
			
			assetsTotal = xmlArray.length + tmxArray.length + imagesArray.length;
			
			var i:uint;
			
			// load xml
			for (i = 0; i < xmlArray.length; i++)
				loadAsset(AssetVO(xmlArray[i]));

			// load eol
			for (i = 0; i < tmxArray.length; i++)
				loadAsset(AssetVO(tmxArray[i]));

			// load images
			for (i = 0; i < imagesArray.length; i++)
				loadAsset(AssetVO(imagesArray[i]));
			
			// dispose sources XML
			System.disposeXML(sources);
			
			// remove listener
			event.currentTarget.removeEventListener(Event.COMPLETE, sourcesLoadedHandler);
		}
		
		private function xmlToArrayHelper(xml:XMLList, type:String):Array
		{
			var returnArray:Array = new Array();
			
			var prependPath:String;
			
			switch(type)
			{
				case AssetVO.ASSET_TYPE_XML:
					prependPath = 'assets/xml/';
					break;
				
				case AssetVO.ASSET_TYPE_TMX:
					prependPath = '';
					break;
				
				case AssetVO.ASSET_TYPE_IMAGE:
					prependPath = 'assets/images/';
					break;
				
			}
			
			for each(var i:XML in xml)
			{
				//trace('loading', prependPath + i.@src);
				returnArray.push(new AssetVO(i.@id, prependPath + i.@src, type));
			}
			
			return returnArray;
		}
		
		public function loadAsset(vo:AssetVO):void 
		{
			// image/oel
			var assetRequest:URLRequest = new URLRequest(vo.src);
			
			if (vo.type != AssetVO.ASSET_TYPE_IMAGE)
			{
				var assetURLLoader:AssetURLLoader = new AssetURLLoader();
				assetURLLoader.vo = vo;

				assetURLLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
				assetURLLoader.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
				assetURLLoader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				assetURLLoader.addEventListener(Event.OPEN, loadInitHandler);

				assetURLLoader.load(assetRequest);
			}
			else
			{
				var assetLoader:AssetLoader = new AssetLoader();
				assetLoader.vo = vo;
				
				assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				assetLoader.contentLoaderInfo.addEventListener(Event.INIT, loadInitHandler);
				assetLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				assetLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);

				assetLoader.load(assetRequest);
			}
		}
		
		protected function loadInitHandler(event:Event):void
		{
			//trace('init', event.currentTarget);
		}
		
		protected function loadIOErrorHandler(event:IOErrorEvent):void
		{
			trace('IO Error', event.text);
		}
		protected function loadProgressHandler(event:ProgressEvent):void
		{
			//trace(event.currentTarget.loader.vo.id, 'loaded', event.bytesLoaded, 'of', event.bytesTotal);
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			if (event.currentTarget is AssetURLLoader)
			{
				trace('# loaded', event.currentTarget.vo.id);
				var xml:XML = new XML(event.currentTarget.data);
				
				// define dynamic variable
				this[event.currentTarget.vo.id] = xml;//event.currentTarget.data;
				
				// add oel data to rawMaps array
				if (event.currentTarget.vo.type == AssetVO.ASSET_TYPE_TMX)
				{
					rawMaps.push(this[event.currentTarget.vo.id]);
				}
			}
			else
			{
				trace('# loaded', event.currentTarget.loader.vo.id);
				var bmp:BitmapData = event.currentTarget.loader.content.bitmapData as BitmapData;
				
				// define dynamic variable
				this[event.currentTarget.loader.vo.id] = bmp;
			}
			
			// remove listeners
			event.currentTarget.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			event.currentTarget.removeEventListener(Event.INIT, loadInitHandler);
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);

			assetsLoaded++;
			if (assetsLoaded == assetsTotal)
			{
				trace(assetsLoaded, 'assets loaded!');
				dispatchEvent(new Event(Event.COMPLETE));
				
				release();
			}
		}
		
		private function release():void
		{
			trace('release', System.totalMemory / 1024, System.freeMemory);
		}

		public function get rawMaps():Array
		{
			return _rawMaps;
		}

		public function set rawMaps(value:Array):void
		{
			_rawMaps = value;
		}

	}
}

class SingletonEnforcer {}