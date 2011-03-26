package
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.List;
	
	public class FlexibleImageComponent extends UIComponent
	{
		//このFlexibleImageComponentが所属するグループ
		private var group:Group;
		
		//現在移動中かどうかを表すフラグ
		private var moving:Boolean = false;
		
		private var mouseOuted:Boolean = false;
		
		//clickされた際のローカル座標
		private var clickedLocalPoint:Point = new Point();
		
		private var cornerAreas:Vector.<CornerArea> = new Vector.<CornerArea>();
		
		// ローカル座標におけるこのcomponentの中心座標
		private var localCenter:Point = new Point();
		
		// グローバル座標系におけるこのcomponentの中心座標
		private var center:Point = new Point();
		
		public function FlexibleImageComponent(group:Group, child:DisplayObject)
		{
			super();
			
			this.group = group;
			
			this.addChild(child);
			this.width = child.width;
			this.height = child.height;
			
			if (width != 0)
			{
				localCenter.x = width/2;
			}
			if (height != 0)
			{
				localCenter.y = height/2;
			}
			center.x = localCenter.x + this.x;
			center.y = localCenter.y + this.y;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			this.group.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.group.addEventListener(MouseEvent.MOUSE_UP, onCornerMouseUp);
			this.group.addEventListener(MouseEvent.MOUSE_MOVE, onGroupMouseMove);
			
			this.group.addEventListener(MouseEvent.MOUSE_MOVE, onRotate);
			
			var cornerAreaSize:int = 10;
			
			trace("w:"+this.width);
			trace("h:"+this.height);
			
			// cornterArea 生成
			var luCornerArea:CornerArea = new CornerArea(-cornerAreaSize, -cornerAreaSize, cornerAreaSize, cornerAreaSize);
			var ruCornerArea:CornerArea = new CornerArea(this.width + cornerAreaSize, -cornerAreaSize, cornerAreaSize, cornerAreaSize);
			var rdCornerArea:CornerArea = new CornerArea(this.width + cornerAreaSize, this.height + cornerAreaSize, cornerAreaSize, cornerAreaSize);
			var ldCornerArea:CornerArea = new CornerArea(-cornerAreaSize, this.height + cornerAreaSize, cornerAreaSize, cornerAreaSize);
			
			// componentの子として追加
			this.addChild(luCornerArea);
			this.addChild(ruCornerArea);
			this.addChild(ldCornerArea);
			this.addChild(rdCornerArea);
			
			// cornerAreaの集合に追加
			cornerAreas.push(luCornerArea);
			cornerAreas.push(ruCornerArea);
			cornerAreas.push(rdCornerArea);
			cornerAreas.push(ldCornerArea);

			
			// 配置を一番手前にする
			this.setChildIndex(luCornerArea, this.numChildren - 1);
			this.setChildIndex(ruCornerArea, this.numChildren - 1);
			this.setChildIndex(rdCornerArea, this.numChildren - 1);
			this.setChildIndex(ldCornerArea, this.numChildren - 1);
			
			// corner area を描画
			luCornerArea.drawArea();
			ruCornerArea.drawArea();
			rdCornerArea.drawArea();
			ldCornerArea.drawArea();
			
			
			rdCornerArea.addEventListener(MouseEvent.MOUSE_DOWN, onCornerMouseDown);
			rdCornerArea.addEventListener(MouseEvent.MOUSE_UP, onCornerMouseUp);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		// 回転中フラグ
		private var rotate:Boolean = false;
		
		// 回転開始時にクリックした点
		private var rotateStartPt:Point = new Point();
		
		// 回転開始
		private function onCornerMouseDown(e:MouseEvent):void
		{
			rotate = true;
			rotateStartPt.x = this.group.mouseX;
			rotateStartPt.y = this.group.mouseY;
			
			this.center.x = this.localCenter.x + this.x;
			this.center.y = this.localCenter.y + this.y;
			trace("center", this.center);
		}
		
		// 回転終了
		private function onCornerMouseUp(e:MouseEvent):void
		{
			trace("x,y when cornerMouseUp:", this.x, this.y);
			trace("w,h when cornerMouseUp:", this.width, this.height);
			trace("rotation end");
			rotate = false;
		}
		
		// 回転中(ドラッグ中)
		private function onRotate(e:MouseEvent):void
		{
			if (rotate)
			{
				trace("onRotate");
				var currentPoint:Point = new Point(this.group.mouseX, this.group.mouseY);
				
				// 原点中心に平行移動
				var cTranslated:Point = currentPoint.subtract(center);
				var sTranslated:Point = rotateStartPt.subtract(center);
				
				// それぞれの角度を算出
				var currentDeg:Number = Math.atan2(cTranslated.y, cTranslated.x);
				var startDeg:Number = Math.atan2(sTranslated.y, sTranslated.x);
				
				var rad:Number = currentDeg - startDeg;
				
				var rotationMatrix:Matrix = new Matrix();
				rotationMatrix.translate(- center.x, - center.y);
				rotationMatrix.rotate(rad);
				rotationMatrix.translate(center.x, center.y);
				
				this.transform.matrix = rotationMatrix;
				trace("rotation:", cTranslated, sTranslated, rad);
				trace("w, h:", this.width, this.height);
			}
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			//if (isOnCornerArea(
		}
		
		/*
		private function isOnCornerArea(x:Number, y:Number):Boolean
		{
			for(var area:CornerArea in cornerAreas)
			{
				if (area.contains(x, y)) {
					return true;
				}
			}
			return false;
		}*/
		
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
				trace("move end");
				moving = false;
				center.x = localCenter.x + this.x;
				center.y = localCenter.y + this.y;
			}
			
			if (rotate)
			{
				trace("rotation end");
				rotate = false;
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
				
				trace("x, y when mousemove:", this.x, this.y);
				
				this.group.graphics.lineStyle(3, 0x0000FF);
				this.group.graphics.drawCircle(center.x, center.y, 3);
			}
		}
		
	}
}