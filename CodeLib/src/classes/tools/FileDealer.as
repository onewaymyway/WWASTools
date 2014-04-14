package classes.tools
{

	
	
	import classes.dataStruct.XMLObject;
	
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
			var xmlHeader:String="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
			saveTxtFile("/output/"+className,xmlHeader+fileContent);
		}
		public function saveObjectToXmlFile(fileName:String,obj:Object,objName:String):void
		{
			var tO:XMLObject;
			tO=new XMLObject(obj,objName,0);
			FileDealer.getInstance().saveXMLFile(fileName,tO.writeXML());
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
			stream.close();
			trace("rst:"+rst);
			return rst;
		}
		
		/**
		 * 读取XML并转换为Object 
		 * @param fileName
		 * @return 
		 * 
		 */
		public function readXMLFile(fileName:String):Object
		{
			var rst:Object;
			var fileContent:String;
			fileContent=readTxtFile(fileName);
			var xml:XML;
			xml=new XML(fileContent);
			rst=XML2Object.parse(xml);
			return rst;
		}
		
		/**
		 * 读取Json并转换为Object 
		 * @param fileName
		 * @return 
		 * 
		 */
		public function readJSONFile(fileName:String):Object
		{
			var rst:Object;
			var fileContent:String;
			fileContent=readTxtFile(fileName);
			fileContent=StringTool.trim(fileContent);
			rst=StringTool.getJSONObject(fileContent);
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
		
		/**
		 * 复制文件 
		 * @param oPath
		 * @param dPath
		 * 
		 */
		public function copyFile(oPath:String,dPath:String):void
		{
			
			var _Path:File = File.applicationDirectory;
			var _url:String = _Path.nativePath.toString();
			var original:File = new File(_url+oPath);		
			var newFile:File = new File(_url+dPath);
			original.copyTo(newFile, true);
		}
	}
}