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
	
	
	/**
	 * FlexibleImageComponentは移動・回転可能な画像コンポーネントを提供します。
	 * 
	 **/
	public class FlexibleImageComponent extends UIComponent
	{
		//このFlexibleImageComponentが所属するグループ
		private var group:Group;
		
		// 回転開始時にクリックした点
		private var rotateStartPt:Point = new Point();
		
		// moveが開始したときの,描画座標系におけるクリックされた点
		private var startMousePos:Point = new Point();
		
		// ローカル左上の点のgroup内の座標とドラッグ開始時のマウス座標の差を保持しておく
		private var diffToLU:Point = new Point();
		
		// centerと左上の点の差のベクトル
		private var lUToCenterVector:Point = new Point();
		
		// 回転を検知する位置
		private var cornerAreas:Vector.<CornerArea> = new Vector.<CornerArea>();
		
		// このFlexibleImageComponentを描画する座標系における
		// このcomponentの中心座標
		private var center:Point = new Point();
		
		public function FlexibleImageComponent(group:Group, child:DisplayObject)
		{
			super();
			
			this.group = group;
			
			group.mouseEnabledWhereTransparent = true;
			
			this.addChild(child);
			
			this.width = child.width;
			this.height = child.height;
			
			
			var localCenter:Point = new Point();
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
			
			this.updateLUToCenterVector();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, startMoving);
			
			
			mylog("w:"+this.width);
			mylog("h:"+this.height);
			
			// -------------------------------
			// corner area settings
			var cornerAreaSize:int = 10;
			
			// cornterArea 生成
			var luCornerArea:CornerArea = new CornerArea(-cornerAreaSize, -cornerAreaSize, cornerAreaSize, cornerAreaSize);
			var ruCornerArea:CornerArea = new CornerArea(this.width + cornerAreaSize, -cornerAreaSize, cornerAreaSize, cornerAreaSize);
			var rdCornerArea:CornerArea = new CornerArea(this.width + cornerAreaSize, this.height + cornerAreaSize, cornerAreaSize, cornerAreaSize);
			var ldCornerArea:CornerArea = new CornerArea(-cornerAreaSize, this.height + cornerAreaSize, cornerAreaSize, cornerAreaSize);
			
			// 子として追加
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
			
			// corner がクリックされたら回転開始
			rdCornerArea.addEventListener(MouseEvent.MOUSE_DOWN, startRotation);
		}
		
		
		// 回転開始
		private function startRotation(e:MouseEvent):void
		{
			mylog("[startRotation]");
			rotateStartPt.x = this.group.contentMouseX;
			rotateStartPt.y = this.group.contentMouseY;
			
			// 親(このcomponent)に他のイベントが発生しないようにstopする
			// 例えばstartMovingとか。
			e.stopPropagation();
			this.updateLUToCenterVector();
			mylog("center", this.center);
			
			// mouseMoveとmouseUpに回転と回転停止をイベントをAddする
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, beRotate);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopRotation);
		}
		
		// 回転終了
		private function stopRotation(e:MouseEvent):void
		{
			// mouseMove/mouseUpから回転と回転停止イベントをremoveする
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, beRotate);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotation);
			mylog("[stopRotation]");
			this.updateLUToCenterVector();
			this.drawLU();
			this.drawCenter(false);
		}
		
		private function startMoving(e:MouseEvent):void
		{	
			// mouseMoveとmouseUpに移動と移動終了イベントをAddする
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, beMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopMoving);
			
			mylog("[startMoving called]");
			// 最前面に移動
			this.group.setElementIndex(this, this.group.numElements - 1);
			
			// 移動開始時にクリックした点を保持する
			this.startMousePos.x = group.contentMouseX;
			this.startMousePos.y = group.contentMouseY;
			
			// 左上の点とクリックしている点の差を保持しておく
			this.diffToLU.x = group.contentMouseX - this.x;
			this.diffToLU.y = group.contentMouseY - this.y;
			
			//this.updateLUToCenterVector();
			this.updateCenter();
			
			this.drawLU();
			this.drawCenter(false);
			
			mylog("clicked point(in group): ", this.startMousePos);
		}
		
		// 移動終了
		private function stopMoving(e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, beMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopMoving);
			mylog("[stopMoving]");
			
			this.updateCenter();
			this.drawLU();
			this.drawCenter(false);
		}
		

		
		private function drawLU(clear:Boolean= true):void {
			if(clear) {
				group.graphics.clear();
			}
			group.graphics.lineStyle(3,0x000);
			group.graphics.drawCircle(this.x, this.y, 2);
		}
		
		private function drawCenter(clear:Boolean = true):void {
			if (clear) {
				this.group.graphics.clear();
			}
			this.group.graphics.lineStyle(3, 0x0000FF);
			this.group.graphics.drawCircle(center.x, center.y, 3);
		}
		
		private function updateCenter():void {
			center.x = this.x + this.lUToCenterVector.x;
			center.y = this.y + this.lUToCenterVector.y;
		}
		
		private function updateLUToCenterVector():void {
			this.lUToCenterVector.x = center.x - this.x;
			this.lUToCenterVector.y = center.y - this.y;
			
		}
		
		private function beRotate(e:MouseEvent):void
		{
			mylog("[beRotate executed]");
			// rotation
			
			var currentPoint:Point = new Point(this.group.contentMouseX, this.group.contentMouseY);
			
			// 原点中心に平行移動
			var cTranslated:Point = currentPoint.subtract(center);
			var sTranslated:Point = rotateStartPt.subtract(center);
			
			// それぞれの角度を算出
			var currentDeg:Number = Math.atan2(cTranslated.y, cTranslated.x);
			var startDeg:Number = Math.atan2(sTranslated.y, sTranslated.x);
			
			var deg:Number = currentDeg - startDeg;
			var rMatrix:Matrix = this.transform.matrix;
			rMatrix.translate(-center.x, -center.y);
			rMatrix.rotate(deg);
			rMatrix.translate(center.x, center.y);
			
			this.transform.matrix = rMatrix;
			
			mylog("rotation:", cTranslated, sTranslated, deg);
			mylog("w, h:", this.width, this.height);
		}
		
		private function beMove(e:MouseEvent):void
		{
			mylog("[beMove]");
			
			this.move(
				this.group.contentMouseX - this.diffToLU.x,
				this.group.contentMouseY - this.diffToLU.y);
				
				mylog("x, y when mousemove:", this.x, this.y);
				
				this.group.graphics.clear();
				this.group.graphics.lineStyle(3, 0x0000FF);
				this.group.graphics.drawCircle(center.x, center.y, 3);
		}
		
		private function mylog(...messages:Array):void 
		{
			trace(this.id, messages);
		}
	}
}