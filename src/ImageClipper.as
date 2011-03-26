package {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    import mx.controls.Image;
    import mx.core.UIComponent;
    
    import spark.components.Group;

    public class ImageClipper
    {
		private var sourceImage:Image;
		private var destGroup:Group;
		
		private var movingFlag:Boolean;
		
		private var clickedLocalPoint:Point = new Point();
		
		public function ImageClipper(source:Image, dest:Group):void
		{
			this.sourceImage = source;
			this.destGroup = dest;
		}

		public function sliceImage(lup:Point, rdp:Point):void
		{
			var width:Number = rdp.x - lup.x;
			if (width < 0) 
			{
				width = -width;
			}
			
			var height:Number = rdp.y - lup.y;
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
		    matrix.tx = -lup.x;
		    matrix.ty = -lup.y;
	
		    var bitmap_data:BitmapData = new BitmapData(width, height, true);
		    bitmap_data.draw(sourceImage, matrix, new ColorTransform(), "normal", rect, true);
		    var bitmap:Bitmap = new Bitmap(bitmap_data);
			
			var flexibleImageComponent:FlexibleImageComponent
				= new FlexibleImageComponent(this.destGroup, bitmap);

		    this.destGroup.addElement(flexibleImageComponent);
	
		}
		

    }
}