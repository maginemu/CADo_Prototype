package {
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.ui.Mouse;
    
    import mx.controls.Image;
    
    import spark.components.Button;
    import spark.components.Group;

    /**
     * 
     */
    
	public class ImageCropComponent 
    {

		private var sourceImage:Image;
		private var imageClipper:ImageClipper;
		private var imageSelector:Group;

		// 左上と右下の点
		private var lup:Point = new Point();
		private var rdp:Point = new Point();
		private var dragging:Boolean = false;
		
		public function ImageCropComponent(source:Image, dest:Group, select:Group):void
		{
		    this.sourceImage = source;
			this.imageSelector = select;

		    this.sourceImage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		    this.imageSelector.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.sourceImage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
	
		    this.imageClipper = new ImageClipper(sourceImage, dest);
			
	
		}
	
		private function onMouseDown(event:MouseEvent):void
		{
		    this.lup.x = event.target.mouseX;
		    this.lup.y = event.target.mouseY;
			this.dragging = true;
		}
	
		private function onMouseUp(event:MouseEvent):void
		{
		    this.rdp.x = event.target.mouseX;
		    this.rdp.y = event.target.mouseY;
	
			this.dragging = false;
			
		    trace("lux:"+this.lup.x);
		    trace("luy:"+this.lup.y);
		    trace("rdx:"+this.rdp.x);
		    trace("rdy:"+this.rdp.y);
			
	
		    imageClipper.sliceImage(lup, rdp);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			var x:int = event.target.mouseX;
			var y:int = event.target.mouseY;
			
			/*
			if (x < lup.x)
			{
				if (y < lup.y) {
					rdp.x = lup.x;
					rdp.y = lup.x;
					lup.x = x;
					lup.y = y;
				} else {
					rdp.x = lup.x;
					rdp.y = y;
					lup.x = x;
					lup.y = 
				}
			} else {
				if (y < lup.y) {
					
				}
			}
			*/
			rdp.x = event.target.mouseX;
			rdp.y = event.target.mouseY;
			
			if(dragging){
				var width:Number = rdp.x - lup.x;
				if (width < 0)
				{
					width = -width
				}
				
				var height:Number = rdp.y - lup.y;
				if (height < 0)
				{
					height = -height;
				}
				this.imageSelector.graphics.clear();
				this.imageSelector.graphics.lineStyle(3 , 0xFF0000);
				this.imageSelector.graphics.drawRect(lup.x, lup.y, width, height);
			}	
		}
	}
}