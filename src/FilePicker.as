package {
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.FileFilter;


    public class FilePicker {

	private var file:File = new File();
	private var filePath:String = "";
	private var filter:FileFilter;
	public function FilePicker(filterExplain:String = "Files", filterExt:String = "*"):void
	{
		this.filter = new FileFilter(filterExplain, filterExt);
	}
	
	/**
	 * onSelected: Stringを引数に取るfunction. 選択された画像のパスが渡される。
	 * onCanceled: キャンセルされる際にコールされる
	 */
	public function onFileSelected(onSelected:Function, onCanceled:Function = null):void {

	    try {
		file.addEventListener(Event.SELECT, function(e:Event):void {
			onSelected(e.target.url);
			trace("selectedPath:", e.target.url);
		    });
		file.addEventListener(Event.CANCEL, function(e:Event):void {
			if (onCanceled != null) {
			    onCanceled();
			    trace("canceled.");
			}
		    });
		file.browseForOpen("Choose an Image file", [filter]);
	    } catch (error:Error) {
		trace(error.message);
	    }
	}
    }
}