package {
    import mx.controls.Image;
    import spark.components.Button;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;

	
    import ImageClipper;
    /**
     * 
     */
    public class ImageCropComponent 
    {

	private var sourceImage:Image;
	private var destImage:Image;

	private var imageClipper:ImageClipper;
	private var slice_sprite:Sprite;

	// 左上と右下の点
	private var lux:int;
	private var luy:int;
	private var rdx:int;
	private var rdy:int;
	
	public function ImageCropComponent(source:Image, dest:Image):void
	{
	    this.sourceImage = source;
	    this.destImage = dest;

	    this.sourceImage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	    this.sourceImage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

	    this.imageClipper = new ImageClipper(sourceImage, destImage);
		this.slice_sprite = new Sprite;
		
		ui_obj.addChild(slice_sprite);
	    

	}

	private function onMouseDown(event:MouseEvent):void
	{
	    this.lux = event.target.mouseX;
	    this.luy = event.target.mouseY;

	}

	private function onMouseUp(event:MouseEvent):void
	{
	    this.rdx = event.target.mouseX;
	    this.rdy = event.target.mouseY;

	    trace("lux:"+this.lux);
	    trace("luy:"+this.luy);
	    trace("rdx:"+this.rdx);
	    trace("rdy:"+this.rdy);

	    imageClipper.sliceImage(lux, luy, rdx, rdy);
	}
	
	private function imageEnterFrameHandler(event:Event):void{
		slice_sprite.graphics.clear();
		slice_sprite.graphics.lineStyle(2, 0xFF6666);
　　　　　
		var rdx:Number = img.mouseX;
　　　　　var rdy:Number = img.mouseY;
　　　　　
			if(rdx < 0){
				rdx = 0;
			}
			else if(edx > img.width) {
				rdx = img.width;
			}
			if(rdy < 0)  {
				rdy = 0;
			}
　　　　　　　	else if(rdy > this.imageBox.height){ 
				rdy = this.imageBox.height;
			}
			else if(rdy> img.height) {
				rdy = img.height;
			}
		
			slice_sprite.graphics.moveTo(lux, luy);
			slice_sprite.graphics.lineTo(rdx, luy);
			slice_sprite.graphics.lineTo(rdx, rdy);
			slice_sprite.graphics.lineTo(lux, rdy);
			slice_sprite.graphics.lineTo(lux, luy);
		}
    }
}