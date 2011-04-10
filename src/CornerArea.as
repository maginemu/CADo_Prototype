package
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	/**
	 * 回転をハンドルするための角のオブジェクト
	 * 
	 **/
	public class CornerArea extends UIComponent
	{
		public function CornerArea(x:Number, y:Number, width:Number, height:Number)
		{
			super();
			this.x = x;
			this.y = y;
			this.z = 1;
			this.width = width;
			this.height = height;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			// マウスイベントを取得するには描画しておく必要があるらしい
			drawArea();
		}
		
		public function drawArea():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x00FF00, 0.0);
			this.graphics.drawRect(-this.width/2, -this.height/2, this.width, this.height);
		}
		
		private function highlightArea():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x00FF00, 1.0);
			this.graphics.drawRect(-this.width/2, -this.height/2, this.width, this.height);
		}

		private function onMouseOver(e:MouseEvent):void
		{
			highlightArea();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			trace("out corner");
			this.drawArea();
		}
	}
}