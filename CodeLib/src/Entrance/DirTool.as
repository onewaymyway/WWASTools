package  Entrance
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class DirTool extends Sprite
	{
		public function DirTool()
		{
			stage.addEventListener(MouseEvent.CLICK,this.clickHanlder);
			init();
		}
		private var sysFile:File;
		private var FilrUrlArr:Array;
		private var key:int;//递归结束标志
		
		private function init():void{
			sysFile = new File();
			sysFile.addEventListener(Event.SELECT,selectHandler);
			FilrUrlArr = new Array();
		}
		
		/**
		 递归函数开始递归
		 **/
		private function getFileArr(_url:String=""):void{
			key++;
			if(_url!=""){
				sysFile.url = _url;
			}
			var arr:Array = sysFile.getDirectoryListing();
			var leg:int = arr.length;
			for(var i:int=0;i<leg;i++){
				var file:File = arr[i] as File;
				if(file.isDirectory){
					getFileArr(file.url);
				}else{
					FilrUrlArr.push(file.url);
					trace(file.url);
				}
			}
			key--;
			if(key==0){//判断递归是否结束
				Idone();
			}
		}
		
		/**
		 开始执行获取文件地址的方法
		 **/
		private function selectHandler(event:Event):void{
			getFileArr();
		}
		
		
		/**
		 这里可以切一个断点看看结果，或者干脆用用trace
		 **/
		private function Idone():void{
			FilrUrlArr;
		}
		
		
		/**
		 开始执行按钮方法
		 **/
		private function clickHanlder(event:MouseEvent):void{
			sysFile.browseForDirectory("请选择您的文件夹");
		}
	}
}