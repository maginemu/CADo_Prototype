package {
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;


    public class ImageFilePicker extends FilePicker {
	
		
	public function ImageFilePicker(filterExplain:String = "Images", filterExt:String = "*.jpg;*.png;*.bmp"):void
	{
		super(filterExplain, filterExt);
	}
		
	public function selectImageFile(onSelected:Function, onCanceled:Function = null):void {
	    
	    var bmp:Bitmap = new Bitmap();
	    var loader:Loader = new Loader();
	    var loaderInfo:LoaderInfo = loader.contentLoaderInfo;

	    loaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
		    trace("loadCompleted.");
		    bmp.bitmapData = Bitmap(loader.content).bitmapData;
		    onSelected(bmp);
		});
	    loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
		    trace("an IOError occured in ImageFilePicker.onSelected. detail is below:");
			trace(e.text);
		});

	    super.onFileSelected(function(path:String):void {
		    loader.load(new URLRequest(path));
		});
	}

    }
}