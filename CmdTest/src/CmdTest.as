package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class CmdTest extends Sprite
	{
		public function CmdTest()
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent); 
			myTxt=new TextField();
			addChild(myTxt);
			myTxt.multiline=true;
			myTxt.width=100;
			myTxt.wordWrap=true;
		}
		public function myTrace(msg:String):void
		{
			myTxt.appendText("\n"+msg);
			trace(msg);
		}
		public var myTxt:TextField;
		public var arguments:Array; 
		public var currentDir:File; 
		public function onInvokeEvent(invocation:InvokeEvent):void { 
			arguments = invocation.arguments; 
			currentDir = invocation.currentDirectory; 
			var i:int;
			var len:int;
			len=arguments.length;
			myTrace("arguments:"+len);
			for(i=0;i<len;i++)
			{
				myTrace(arguments[i]);
			}
			setTimeout(closeme,2000);
		} 
		private function closeme():void
		{
			NativeApplication.nativeApplication.exit();
		}
	}
}