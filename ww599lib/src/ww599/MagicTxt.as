package ww599
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import ww599.Tools.DrawTools;

	public class MagicTxt extends Sprite
	{
		public static var tFormat:TextFormat=new TextFormat(null,12);
		public function MagicTxt()
		{
			_textField=new TextField;
			_textField.defaultTextFormat=tFormat;
//			_textField.autoSize=true;
			_container=new Sprite();
			this.addChild(_container);
		}
		private var _textField:TextField;
		private var _container:Sprite;
		public function getTxt(txt:String):void
		{
			_container.graphics.clear();
			_container.addChild(_textField);
			_textField.text=txt;
			_textField.width=_textField.textWidth+5;
			_textField.height=_textField.textHeight+5;
			var bm:BitmapData = new BitmapData(_textField.width,_textField.height, false, 0xffffff);
			bm.draw(_textField);
			//把txt看成位图，并把txt位图信息存入mb
			var DotArray:Array = new Array();
			//申请一个数组用于存储mb位图信息
			var w:Number = 8;
			var h:Number = 8;
			//w,h分别为点间宽度和高度
			
			var x:int;
			var y:int;
			for (y=0; y<bm.height; y++) {
				for (x=0; x<bm.width; x++) {
					if (bm.getPixel(x, y) != 0xffffff) {
						DotArray.push({x:x*w, y:y*h});
						//逐行逐列取像素,把有字的像素位置存入数组并乘上w,h以扩展距离
						DrawTools.drawCircle(_container,x*w,y*h,2,0xFF0000);
					}
				}
			}
			bm.dispose();
		}
		
	}
}