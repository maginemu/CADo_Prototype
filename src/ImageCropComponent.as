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
    }
}