package
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	public class CornerArea extends UIComponent
	{
		public function CornerArea(x:Number, y:Number, width:Number, height:Number)
		{
			super();
			this.x = x/2;
			this.y = y/2;
			this.z = 1;
			this.width = width;
			this.height = height;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function drawArea():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x00FF00, 0.5);
			this.graphics.drawRect(this.x, this.y, this.width, this.height);
		}
		
		private function highlightArea():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x00FF00, 1.0);
			this.graphics.drawRect(this.x, this.y, this.width, this.height);
		}

		private function onMouseOver(e:MouseEvent):void
		{
			trace("on corner");
			trace("x:"+this.x);
			trace("y:"+this.y);
			trace("w:"+this.width);
			trace("h:"+this.height);
			highlightArea();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			trace("out corner");
			this.drawArea();
		}
	}
}