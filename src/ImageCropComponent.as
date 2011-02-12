package {
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.MouseEvent;
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
		private var lux:int;
		private var luy:int;
		private var rdx:int;
		private var rdy:int;
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
		    this.lux = event.target.mouseX;
		    this.luy = event.target.mouseY;
			this.dragging = true;
	
		}
	
		private function onMouseUp(event:MouseEvent):void
		{
		    this.rdx = event.target.mouseX;
		    this.rdy = event.target.mouseY;
	
			this.dragging = false;
			
		    trace("lux:"+this.lux);
		    trace("luy:"+this.luy);
		    trace("rdx:"+this.rdx);
		    trace("rdy:"+this.rdy);
			
	
		    imageClipper.sliceImage(lux, luy, rdx, rdy);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			var rdx:int = event.target.mouseX;
			var rdy:int = event.target.mouseY;
			
			if(dragging){
				this.imageSelector.graphics.clear();
				this.imageSelector.graphics.lineStyle(1 , 0);
				this.imageSelector.graphics.drawRect(lux, luy, rdx - lux, rdy - luy);
			}	
		}
	}
}