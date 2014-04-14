package classes.tools
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	

	/**
	 * 文件读写类
	 * @author ww
	 * 
	 */
	public class FileDealer
	{
		public function FileDealer()
		{
		}
		private static  var _instance:FileDealer; 
		
		
		public static function getInstance():FileDealer
		{
			if (_instance == null) 
			{
				_instance = new FileDealer();
			}
			return _instance;
		}
		/**
		 * 保存XML文件
		 * @param className
		 * @param fileContent
		 * 
		 */
		public function saveXMLFile(className:String,fileContent:String):void
		{
//			var _Path:File = File.applicationDirectory;
//			var _url:String = _Path.nativePath.toString();
//			_url+= "/output/"+className+".xml";
//			var file:File = new File(_url);
//			//var file:File;
//			//file=File.applicationDirectory.resolvePath(""+className+".as");
//			var stream:FileStream = new FileStream;
//			stream.open(file, FileMode.WRITE);
//			stream.writeMultiByte(fileContent,"utf-8");
//			stream.close();
			saveTxtFile("/output/"+className+".xml",fileContent);
		}
		/**
		 * 保存AS文件
		 * @param className
		 * @param fileContent
		 * 
		 */
		public function saveAsFile(className:String,fileContent:String):void
		{
//			var _Path:File = File.applicationDirectory;
//			var _url:String = _Path.nativePath.toString();
//			_url+= "/output/"+className+".as";
//			var file:File = new File(_url);
//			//var file:File;
//			//file=File.applicationDirectory.resolvePath(""+className+".as");
//			var stream:FileStream = new FileStream;
//			stream.open(file, FileMode.WRITE);
//			stream.writeMultiByte(fileContent,"utf-8");
//			stream.close();
			saveTxtFile("/output/"+CreateFunLib.tModDs.modName+"/"+className+".as",fileContent);
		}
		
		
		public function createFolders():void
		{
			createFolder(/output/+CreateFunLib.tModDs.modName+"/");
		}
		
		public function createFolder(path:String):void
		{
			//var _Path:File = File.applicationDirectory.resolvePath("/hello");
			
			var _Path:File = File.applicationDirectory;
			var _url:String = _Path.nativePath.toString();
			_url+=path;
			var file:File = new File(_url);
			file.createDirectory();
			//_Path.createDirectory();
		}
		/**
		 * 保存文本文件 
		 * @param fileName
		 * @param fileContent
		 * 
		 */
		public function saveTxtFile(fileName:String,fileContent:String):void
		{
			var _Path:File = File.applicationDirectory;
			var _url:String = _Path.nativePath.toString();
			_url+= fileName;
			var file:File = new File(_url);
			//file.createDirectory();
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(fileContent,"utf-8");
			stream.close();
			
//						var _Path:File = File.applicationDirectory;
//						var _url:String = _Path.nativePath.toString();
//						_url+= "/output/"+className+".as";
//						var file:File = new File(_url);
//						//var file:File;
//						//file=File.applicationDirectory.resolvePath(""+className+".as");
//						var stream:FileStream = new FileStream;
//						stream.open(file, FileMode.WRITE);
//						stream.writeMultiByte(fileContent,"utf-8");
//						stream.close();
		}
		/**
		 * 读取文本文件 
		 * @param fileName
		 * @return 
		 * 
		 */
		public function readTxtFile(fileName:String):String
		{
			var _Path:File = File.applicationDirectory;
			var _url:String = _Path.nativePath.toString();
			_url+= fileName;
			var file:File = new File(_url);
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.READ);
			var rst:String;
			//rst=stream.readUTFBytes(stream.bytesAvailable);
			rst=stream.readMultiByte(stream.bytesAvailable,"utf-8");
			trace("rst:"+rst);
			return rst;
		}
		/**
		 * 读取协议文本文件 
		 * @param fileName
		 * @return 
		 * 
		 */
		public function readProtocalFile(fileName:String):FileAnalyser
		{
			var rst:String;
			//rst=stream.readUTFBytes(stream.bytesAvailable);
			rst=readTxtFile("/res/orginal/"+fileName);
			trace("rst:"+rst);
			
			var fAnalyser:FileAnalyser=new FileAnalyser();
			fAnalyser.setContent(rst);
			return fAnalyser;
		}
	}
}