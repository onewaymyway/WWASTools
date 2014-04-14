package classes.dataStruct
{
	import classes.tools.ArrayTool;
	import classes.tools.ClassAnalyser;
	import classes.tools.CreateFunLib;
	import classes.tools.StringTool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 显示对象信息描述类
	 * 用于解析显示对象并生成相应代码
	 * @author ww
	 * 
	 */
	public class MyClassDescribe
	{
		/**
		 * item型
		 */
		public static const CLASS_TYPE_ITEM:String="CLASS_TYPE_ITEM";
		/**
		 * panel型
		 */
		public static const CLASS_TYPE_PANEL:String="CLASS_TYPE_PANEL";
		/**
		 * 未特别关注的类型
		 */
		public static const CLASS_TYPE_UNDEFINE:String="CLASS_TYPE_UNDEFINE";
		/**
		 * 类名
		 */
		public var className:String;
		/**
		 * 类所在的包
		 */
		public var classPackage:String;
		
		/**
		 * 主包 
		 */
		public var mainPackage:String;
		
		/**
		 * 模块名 
		 */
		public var modName:String;
		
		/**
		 * 功能面板名 
		 */
		public var funName:String;
		
		/**
		 * 功能面板名首字母小写 
		 */
		public var funNameL:String;
		private var _classFullPath:String;
		/**
		 * 类的类型 
		 */
		public var classType:String;
		
		public var disObj:Object=null;
		
		/**
		 * 显示对象容器包含的所有带名字的显示对象 
		 */
		public var disArray:Array;
		
		
		public var btnNameList:Array;
		
		public var _display:DisplayObjectContainer;
		
		public function MyClassDescribe()
		{
			btnNameList=[];
		}
		/**
		 * 添加要处理的按钮 
		 * @param dis
		 * 
		 */
		public function addBtn(dis:DisplayObject):void
		{
			ArrayTool.addDistictItem(btnNameList,dis.name);
		}
		/**
		 * 设置要解析的显示对象 
		 * @param dis
		 * 
		 */
		public function set displayObj(dis:DisplayObjectContainer):void
		{
			_display=dis;
			var classFullName:String;
			classFullName=ClassAnalyser.getFullClassName(dis);
			var i:int;
			i=classFullName.lastIndexOf("::");
			
			this.classFullPath=classFullName.replace(new RegExp("\\:\\:", "g"), ".");
			if(className.indexOf("Item")>=0)
			{
				classType=CLASS_TYPE_ITEM;
			}
			else
				if(className.indexOf("Panel")>=0)
				{
					classType=CLASS_TYPE_PANEL;
				}
				else
				{
					classType=CLASS_TYPE_UNDEFINE;
				}
			
			
			createDescribeArray(_display);
		}
		
		/**
		 * 获取类的类别 
		 * @param className
		 * @return 
		 * 
		 */
		public static function getClassTypeByName(className:String):String
		{
			var classType:String;
			
			if(className.indexOf("Item")>=0)
			{
				classType=CLASS_TYPE_ITEM;
			}
			else
				if(className.indexOf("Panel")>=0)
				{
					classType=CLASS_TYPE_PANEL;
				}
				else
				{
					classType=CLASS_TYPE_UNDEFINE;
				}
			
			return classType;
		}
		
		/**
		 * 创建类代码 
		 * @return 
		 * 
		 */
		public function createClassCode():String
		{
			var rst:String;

			CreateFunLib.tClassDs=this;
			switch(this.classType)
			{
				case CLASS_TYPE_PANEL:
					rst=CreateFunLib.getInstance().createSTPanelClass(this,createVars(),createInits(),createPanelButtonAddEventListener(),"");
					break;
				case CLASS_TYPE_ITEM:
					rst=CreateFunLib.getInstance().createSTItemClass(this,createVars(),createInits(),createButtonAddEventListener(),createBtnEventHandlers());
					break;
				default:
					rst=CreateFunLib.getInstance().createSTItemClass(this,createVars(),createInits(),createButtonAddEventListener(),createBtnEventHandlers());
			}
			
			
			return rst;
		}
		/**
		 * 创建包含的显示对象列表 
		 * @param dis
		 * 
		 */
		private function createDescribeArray(dis:DisplayObjectContainer):void
		{
			disArray=[];
			if(!dis) return;
			var i:int;
			var len:int;
			var tChild:DisplayObject;
			len=dis.numChildren;					
			for(i=0;i<len;i++)
			{
				tChild=dis.getChildAt(i);
				if(ClassAnalyser.isNamed(tChild))
				{
					disArray.push(tChild);
					if(ClassAnalyser.isButton(tChild))
					{
						addBtn(tChild);
					}else
					{
				      ArrayTool.addDistictArray(this.btnNameList,CreateFunLib.tModDs.getClassBtnList(ClassAnalyser.getClassName(tChild)));
					}
				}
			}
			trace("desArrayLen:"+disArray.length);
			
			disArray.sortOn(["y","x"],[Array.NUMERIC,Array.NUMERIC]);
		}
		
		/**
		 * 创建view类处理按钮事件代码 
		 * @return 
		 * 
		 */
		public function createViewBtnEventHandler():String
		{
			var rst:String;
			var i:int;
			var len:int;
			len=btnNameList.length;
			rst="";
			for(i=0;i<len;i++)
			{
				
			   rst+=CreateFunLib.getInstance().createViewBtnEventCode(btnNameList[i]);
			}			
			return rst;
		}
		
		/**
		 * 创建ST的变量定义 代码
		 * @return 
		 * 
		 */
		private function createVars():String
		{
			return createCodes(CODETYPE_VARDEFINES);
		}
		
		/**
		 * 创建初始化代码
		 * @return 
		 * 
		 */
		private function createInits():String
		{
			return createCodes(CODETYPE_INIT);
		}
		/**
		 * 创建按钮加监听代码
		 * @return 
		 * 
		 */
		private function createButtonAddEventListener():String
		{
			return createCodes(CODETYPE_BUTTONADDEVENTLISTENER);
		}
		
		/**
		 * 创建Panel按钮加监听代码
		 * @return 
		 * 
		 */
		private function createPanelButtonAddEventListener():String
		{
			return createCodes(CODETYPE_PANELBUTTONADDEVENTLISTENER);
		}
		
		/**
		 * 创建按钮事件处理代码
		 * @return 
		 * 
		 */
		private function createBtnEventHandlers():String
		{
			return createCodes(CODETYPE_BTNEVENTHANDLERS);
		}
		
		/**
		 * 创建Panel按钮事件处理代码
		 * @return 
		 * 
		 */
		private function createPanelBtnEventHandlers():String
		{
			return createCodes( CODETYPE_PANELBTNEVENTHANDLERS);
		}
		
		
		/**
		 * 创建变量定义代码
		 */
		public static const CODETYPE_VARDEFINES:String="CODETYPE_VARDEFINES";
		/**
		 * 创建初始化代码
		 */
		public static const CODETYPE_INIT:String="CODETYPE_INIT";
		/**
		 * 创建按钮加侦听代码
		 */
		public static const CODETYPE_BUTTONADDEVENTLISTENER:String="CODETYPE_BUTTONADDEVENTLISTENER";
		public static const CODETYPE_PANELBUTTONADDEVENTLISTENER:String="CODETYPE_PANELBUTTONADDEVENTLISTENER";
		/**
		 * 创建按钮事件处理代码
		 */
		public static const CODETYPE_BTNEVENTHANDLERS:String="CODETYPE_BTNEVENTHANDLERS";
		/**
		 * 创建Panel按钮事件处理代码
		 */
		public static const CODETYPE_PANELBTNEVENTHANDLERS:String="CODETYPE_PANELBTNEVENTHANDLERS";
		
		/**
		 * 创建代码 
		 * @param type
		 * @return 
		 * 
		 */
		private function createCodes(type:String):String
		{
			var createFun:Function;
			switch(type)
			{
				case CODETYPE_VARDEFINES:
					createFun=CreateFunLib.getInstance().createVarDefine;
					break;
				case CODETYPE_INIT:
					createFun=CreateFunLib.getInstance().createSTDisplayInit;
					break;
				case CODETYPE_BUTTONADDEVENTLISTENER:
					createFun=CreateFunLib.getInstance().createAddButtonAddEventListener;
					break;
				case CODETYPE_PANELBUTTONADDEVENTLISTENER:
					createFun=CreateFunLib.getInstance().createPanelAddButtonAddEventListener;
					break;
				case CODETYPE_BTNEVENTHANDLERS:
					createFun=CreateFunLib.getInstance().createBtnEventHandlers;
					break;
				case CODETYPE_PANELBTNEVENTHANDLERS:
					createFun=CreateFunLib.getInstance().createPanelBtnEventHandlers;
					break;
				default:
					return "";
			}
			
			
			var rst:String;
			var dis:DisplayObject;
			var i:int;
			var len:int;
			len=disArray.length;
			rst="";
			for(i=0;i<len;i++)
			{
				dis=disArray[i]as DisplayObject;
				if(dis)
				{
					rst+=createFun(dis);
				}
			}			
			return rst;
		}
		/**
		 * 初始化类的全路径名 
		 * @param classFullName
		 * 
		 */
		public function set classFullPath(classFullName:String):void
		{
			_classFullPath=classFullName;
			var i:int;
			i=classFullName.lastIndexOf(".");

			this.className=classFullName.substring(i+1,classFullName.length);
			this.classPackage=classFullName.substring(0,i);
			
			i=classPackage.lastIndexOf(".res");
			
			this.mainPackage=classPackage;
			if(i>=0)
			{
				this.mainPackage=classPackage.substr(0,i);
			}
			
			i=mainPackage.lastIndexOf(".");
			
			if(i>=0)
			{
				this.modName=mainPackage.substr(i+1);
			}
			if(className.indexOf("Item")>=0)
			{
				classType=CLASS_TYPE_ITEM;
				i=className.indexOf("Item");
				this.funName=className.substring(0,i);
			}
			else
				if(className.indexOf("Panel")>=0)
				{
					classType=CLASS_TYPE_PANEL;
					
					i=className.indexOf("Panel");
					this.funName=className.substring(0,i);
				}
				else
				{
					classType=CLASS_TYPE_UNDEFINE;
					this.funName=className
				}
			funNameL=StringTool.toLowHead(funName);
		}
		
		public function get classFullPath():String
		{
			return _classFullPath;
		}
	}
}