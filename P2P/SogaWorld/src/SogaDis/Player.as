package SogaDis
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Player extends Sprite
	{
		public function Player()
		{
			super();
			nameTxt=new TextField;
			nameTxt.selectable=false;
			this.addChild(nameTxt);
			create();
		}
		public var linesize:Number=10;
		public var color:uint;
		public var nameTxt:TextField;
		public function create():void
		{
			graphics.clear();
			graphics.lineStyle(linesize, color);
			graphics.moveTo(-5, 0);
			graphics.lineTo(5, 0);
			
		}
		
		public function set nameStr(str:String):void
		{
			nameTxt.text=str;
			nameTxt.x=-nameTxt.textWidth*0.5;
		}
		
		
		public function moveTo(tX:Number,tY:Number):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this,5,{x:tX,y:tY});
		}
	}
}