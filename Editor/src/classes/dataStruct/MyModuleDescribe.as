package classes.dataStruct
{
	import classes.tools.ArrayTool;
	import classes.tools.CreateFunLib;
	import classes.tools.FileAnalyser;
	import classes.tools.FileDealer;
	
	import flash.utils.Dictionary;

	/**
	 * 模块描述信息类 
	 * 用于解析模块结构以及创建模块级别的代码文件
	 * @author ww
	 * 
	 */
	public class MyModuleDescribe
	{
		public function MyModuleDescribe()
		{
			modClassDic=new Dictionary;
			panelNameList=[];
			CreateFunLib.tModDs=this;
		}
		
		/**
		 * 模块名称
		 */
		public var modName:String;
		/**
		 * 模块包含各种面板和Item的classDS
		 */
		public var modClassDic:Dictionary;
		
		/**
		 * 模块包含的面板的功能名列表 用于生成Mod类文件 和Res类文件
		 */
		public var panelNameList:Array;
		
		public var mProtocalAnalyser:FileAnalyser;
		
		
		/**
		 * 设置模块的协议文件 
		 * @param fileName
		 * 
		 */
		public function setProtocalFile(fileName:String):void
		{
			mProtocalAnalyser=FileDealer.getInstance().readProtocalFile(fileName);
			mProtocalAnalyser.parseProtocalFile();
			
//			打断点看结果用
			var i:int;
			i=3;
		}
		
		
		/**
		 * 创建Resolver类代码 
		 * @return 
		 * 
		 */
		public function createResolverCode():String
		{
			var rst:String;
			var className:String;
			var tClassDs:MyClassDescribe;
			//			for(className in modClassDic)
			//			{
			//				tClassDs=modClassDic[className];
			//			}
			
			rst=CreateFunLib.getInstance().createResolverCode(
				getProtocalResolverCreateCode(CreateFunLib.getInstance().createResolverItem)
			);
			return rst;
		}
		
		public function getAddProtocalCallBack():String
		{
			return getProtocalCreateCode( CreateFunLib.getInstance().createAddProtocalCallBack);
		}
		public function getViewProtocalCallBack():String
		{
			return getProtocalCreateCode( CreateFunLib.getInstance().createViewProtocalCallBack);
		}
		/**
		 * 遍历协议数组生成代码 
		 * @param createFun 生成代码的函数
		 * @return 
		 * 
		 */
		public function getProtocalResolverCreateCode(createFun:Function):String
		{
			var rst:String;
			rst="";
			
			var i:int;
			var len:int;
			len=mProtocalAnalyser.protocalArray.length;
			var tprotocal:ProtocalDescribe;
			
			for(i=0;i<len;i++)
			{
				tprotocal=mProtocalAnalyser.protocalArray[i];
				rst+=createFun(tprotocal,getProtocalResolverDecodeCreateCode(tprotocal));
			}
			
			
			return rst;
		}
		
		/**
		 * 创建resolver中解码的代码 
		 * @param tprotocal
		 * @return 
		 * 
		 */
		public function getProtocalResolverDecodeCreateCode(tprotocal:ProtocalDescribe):String
		{
			var rst:String;
			rst="";
			
			var i:int;
			var len:int;
			len=tprotocal.response.length;
			var tItem:dataItem;
			
			
			for(i=0;i<len;i++)
			{
				tItem=tprotocal.response[i] as dataItem;
				rst+=CreateFunLib.getInstance().createResolverDataDecodeItem(tprotocal,i);
			}
			
			
			return rst;
		}
		
		/**
		 * 创建Struct类代码 
		 * @return 
		 * 
		 */
		public function createStructCode():String
		{
			var rst:String;
			var className:String;
			var tClassDs:MyClassDescribe;
			//			for(className in modClassDic)
			//			{
			//				tClassDs=modClassDic[className];
			//			}
			
			rst=CreateFunLib.getInstance().createStructCode(
				getProtocalCreateCode(CreateFunLib.getInstance().createStructProtocalItem)
			);
			return rst;
		}
		
		/**
		 * 创建Match类代码 
		 * @return 
		 * 
		 */
		public function createMatchCode():String
		{
			var rst:String;
			var className:String;
			var tClassDs:MyClassDescribe;
			
			rst=CreateFunLib.getInstance().createMatchCode(
				getProtocalCreateCode(CreateFunLib.getInstance().createMatchRegistItem),
				getProtocalCreateCode(CreateFunLib.getInstance().createMatchHandlerItem)
			);
			return rst;
		}
		
		
		/**
		 * 获取创建protocalItem代码 
		 * @param createFun
		 * @return 
		 * 
		 */
		public function getProtocalCreateCode(createFun:Function):String
		{
			var rst:String;
			rst="";
			
			var i:int;
			var len:int;
			len=mProtocalAnalyser.protocalArray.length;
			var tprotocal:ProtocalDescribe;
			
			for(i=0;i<len;i++)
			{
				tprotocal=mProtocalAnalyser.protocalArray[i];
				rst+=createFun(tprotocal);
			}
			
			
			return rst;
		}
		/**
		 * 添加一个类描述
		 * @param classDs
		 * 
		 */
		public function addClass(classDs:MyClassDescribe):void
		{
			modClassDic[classDs.className]=classDs;
			if(classDs.classType==MyClassDescribe.CLASS_TYPE_PANEL)
			{
				ArrayTool.addDistictItem(panelNameList,classDs.funName);
			}
		}
		
		/**
		 * 根据类名获取类描述对象
		 * @param className
		 * @return 
		 * 
		 */
		public function getClassDs(className:String):MyClassDescribe
		{
			return modClassDic[className] as MyClassDescribe;
		}
		
		/**
		 * 根据类名获取某个类的所有按钮名
		 * @param className
		 * @return 
		 * 
		 */
		public function getClassBtnList(className:String):Array
		{
			if(!getClassDs(className)) return [];
			return getClassDs(className).btnNameList;
		}
		
		/**
		 * 创建Mod类代码
		 * @return 
		 * 
		 */
		public function createModCode():String
		{
			var rst:String;
			var className:String;
			var tClassDs:MyClassDescribe;
//			for(className in modClassDic)
//			{
//				tClassDs=modClassDic[className];
//			}
			
			rst=CreateFunLib.getInstance().createModCode(
				getCreateCode(CreateFunLib.getInstance().createModeViewImport),
				getCreateCode(CreateFunLib.getInstance().createModeViewDefine),
				getCreateCode(CreateFunLib.getInstance().createModeViewInit),
				getCreateCode(CreateFunLib.getInstance().createModeOpenView)
			);
			return rst;
		}
		
		/**
		 * 创建Res类代码
		 * @return 
		 * 
		 */
		public function createResCode():String
		{
			var rst:String;
			var className:String;
			var tClassDs:MyClassDescribe;
			//			for(className in modClassDic)
			//			{
			//				tClassDs=modClassDic[className];
			//			}
			
			rst=CreateFunLib.getInstance().createResCode(
				getCreateCode(CreateFunLib.getInstance().createResImport),
				getCreateCode(CreateFunLib.getInstance().createResGet)
			);
			return rst;
		}
		
		public function getCreateCode(createFun:Function):String
		{
			var rst:String;
			rst="";
			
			var i:int;
			var len:int;
			len=panelNameList.length;
			var tFunName:String;
			
			for(i=0;i<len;i++)
			{
				tFunName=panelNameList[i];
				rst+=createFun(tFunName);
			}
			
			
			return rst;
		}
		public function getPanelFunNames():void
		{
			
		}
		/**
		 * 调试打断点看结果用 
		 * 
		 */
		public function checkResult():void
		{
			var i:int;
			i=3;
		}
	}
}