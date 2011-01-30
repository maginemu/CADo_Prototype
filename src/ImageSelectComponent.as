package {
    import mx.controls.Image;
    import spark.components.Button;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;

    import ImageFilePicker;

    /**
     * Imageをターゲットとして選択された画像を読み込む。
     * Buttonクリックイベントをハンドルして選択ダイアログをオープンする。
     */
    public class ImageSelectComponent 
    {
	private var imageFilePicker:ImageFilePicker = new ImageFilePicker();
	private var renderTarget:Image;
	private var button:Button;
	
	/**
	 * コンストラクタ。
	 * 描画対象ImageとイベントをハンドルするButtonを登録する
	 */
	public function ImageSelectComponent(img:Image, button:Button)
	{
	    this.renderTarget = img;
	    this.button = button;
	    
	    button.addEventListener(MouseEvent.CLICK, onButtonDown);
	}
	
	
	/**
	 * クリックイベントハンドラメソッド。
	 * 既存画像データのdisposeと
	 * ImageFilePickerによる画像読み込み
	 */
	private function onButtonDown(event:MouseEvent):void
	{
	    trace("Select-Image Button Clicked");

	    // if not initialized
	    if (this.renderTarget.source == null)
	    {
		this.renderTarget.source = new Bitmap();
	    }

	    // dispose
	    if (this.renderTarget.source != null 
		&& this.renderTarget.source.bitmapData != null) 
	    {
		this.renderTarget.source.bitmapData.dispose();
	    }
	    
	    // select & load image into buffer
	    imageFilePicker.selectImageFile(imageFileSelected);
	}
	

	/**
	 * 画像が選択された際の動作用のハンドラ
	 */
	private function imageFileSelected(bmp:Bitmap):void
	{
	    Bitmap(this.renderTarget.content).bitmapData = bmp.bitmapData;
	}
    }
}