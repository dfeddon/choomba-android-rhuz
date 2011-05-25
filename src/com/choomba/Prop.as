package com.choomba
{
	import com.choomba.vo.SheetMapVO;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Prop extends Sprite
	{
		private var _image:Image;
		
		public function Prop(img:Image=null)
		{
			super();
			
			// auto cache for gpu acceleration
			//cacheAsBitmap = true;
			//cacheAsBitmapMatrix = new Matrix()
			
			if (img)
			{
				// apply image
				image = img;
				
				setImage();
			}
		}
		
		protected function setImage():void
		{
			// center image
			_image.x -= _image.width / 2;
			_image.y -= _image.height / 2;
			
			// add to stage
			addChild(image);
		}
		
		public function sheetComplete(vo:SheetMapVO):void
		{
			
		}
		
		////////////////////////////////////////

		public function get image():Image
		{
			return _image;
		}

		public function set image(value:Image):void
		{
			_image = value;
			
			setImage();
		}

	}
}