package
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class FlexibleImageComponent extends UIComponent
	{
		//このFlexibleImageComponentが所属するグループ
		private var group:Group;
		
		//現在移動中かどうかを表すフラグ
		private var moving:Boolean = false;
		
		private var mouseOuted:Boolean = false;
		
		//clickされた際のローカル座標
		private var clickedLocalPoint:Point = new Point();
		
		
		public function FlexibleImageComponent(group:Group, child:DisplayObject)
		{
			super();
			
			this.group = group;
			
			super.addChild(child);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			this.group.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.group.addEventListener(MouseEvent.MOUSE_MOVE, onGroupMouseMove);
			
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			// 最前面に移動
			this.group.setElementIndex(this, this.group.numElements - 1);
			
			this.clickedLocalPoint.x = this.mouseX;
			this.clickedLocalPoint.y = this.mouseY;
			
			this.moving = true;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (moving) 
			{
				moving = false;
			}
		}
		
		private function onGroupMouseMove(e:MouseEvent):void
		{
			if (moving)
			{
				this.move(
					this.group.contentMouseX - this.clickedLocalPoint.x,
					this.group.contentMouseY - this.clickedLocalPoint.y);
				mouseOuted = false;
			}
		}
		
	}
}