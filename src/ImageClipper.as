package {
    import mx.controls.Image;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;

    public class ImageClipper
    {
	private var sourceImage:Image;
	private var destImage:Image;

	public function ImageClipper(source:Image, dest:Image):void
	{
	    this.sourceImage = source;
	    this.destImage = dest;
	}
	    
	public function sliceImage(lux:int, luy:int, rdx:int, rdy:int):void
	{
	    var width:Number = rdx - lux;
	    if (width < 0) 
	    {
		width = -width;
	    }

	    var height:Number = rdy - luy;
	    if (height < 0)
	    {
		height = -height;
	    }

	    if (width <= 0 && height <= 0)
	    {
		return;
	    }

	    var rect:Rectangle = new Rectangle(0, 0, width, height);
	    var matrix:Matrix = new Matrix();
	    matrix.tx = -lux;
	    matrix.ty = -luy;

	    var bitmap_data:BitmapData = new BitmapData(width, height, true);
	    bitmap_data.draw(sourceImage, matrix, new ColorTransform(), "normal", rect, true);
	    var bitmap:Bitmap = new Bitmap(bitmap_data);

	    this.destImage.load(bitmap);

	}
    }
}