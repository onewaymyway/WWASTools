package classes.tools
{
	import classes.dataStruct.MyClassDescribe;
	import classes.dataStruct.MyModuleDescribe;
	import classes.dataStruct.ProtocalDescribe;
	import classes.dataStruct.dataItem;
	import classes.load.ZHLoader;
	
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.sampler.StackFrame;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import org.osmf.net.StreamingURLResource;

	/**
	 * 代码创建函数库
	 * @author ww
	 * 
	 */
	public class CreateFunLib
	{
		/**
		 *{className}
		 * {addVar}
		 * {addFill}
		 * {addClear}
		 * {addInit} 
		 * 
		 */		
		private static var classTemplate:String;
		private static var wordsByKeyMap:Dictionary;
		
		private static  var _instance:CreateFunLib; 
		
		public static var tClassName:String="";
		
		/**
		 * 当前使用的显示对象描述类 
		 */
		public static var tClassDs:MyClassDescribe;
		
		public static var tModDs:MyModuleDescribe;
		
		public static function getInstance():CreateFunLib
		{
			if (_instance == null) 
			{
				_instance = new CreateFunLib();
			}
			return _instance;
		}
		//==========================================================================
		//  Class public methods
		//==========================================================================
		/**
		 * 载入XML以后，内部解析、初始化
		 */
		public   function init(e:*=null):void
		{
			var source:XML;
			source=ZHLoader.getInstance().getXMLByName("swfDecodeXML");
			if(wordsByKeyMap) return;
			wordsByKeyMap = new Dictionary();
			var wordsList:XMLList = source.e;
			var len:int = wordsList.length();
			var word:XML;
			for(var i:int = 0; i < len; i++)
			{
				word = wordsList[i];
				wordsByKeyMap[String(word.k)] = String(word.v);
			}
			var temp:Dictionary;
			temp=wordsByKeyMap;
			classTemplate=wordsByKeyMap["itemClassTemplate"];
			
			trace("createFunLib created");
		}
		public function CreateFunLib()
		{
			ZHLoader.getInstance().loadXML("swfDecodeXML","res/template/STTemplate.xml",init);
			//TweenMax.delayedCall(1,init);
		}
		/**
		 * 
		 * @param className 类名
		 * @param vars 变量定义
		 * @param fills 赋值
		 * @param inits 初始化
		 * @param clears 清理
		 * @return 
		 * 
		 */
		public  function createClass(className:String,vars:String,fills:String,inits:String,clears:String=""):String
		{
			var rst:String;
			rst=classTemplate;
			rst = rst.replace(new RegExp("\\{className\\}", "g"), className);
			rst = rst.replace(new RegExp("\\{addVar\\}", "g"), vars);
			rst = rst.replace(new RegExp("\\{addFill\\}", "g"), fills);
			rst = rst.replace(new RegExp("\\{addClear\\}", "g"), clears);
			rst = rst.replace(new RegExp("\\{addInit\\}", "g"), inits);
			return rst;
		}
		/**
		 * 创建label填充代码 
		 * @param text
		 * @return 
		 * 
		 */
		public function createLabelFill(text:TextField):String
		{
			var rst:String;
			if(!text) return "";
			if(text.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{
				// {name}.txt="";
				rst=wordsByKeyMap["LableFill"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), text.name);
			}
			return rst;
		}
		/**
		 * 创建label定义代码 
		 * @param text
		 * @return 
		 * 
		 */
		public function createLabelDefine(text:TextField):String
		{
			var rst:String;
			if(!text) return "";
			if(text.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{
				// private var {varName}:Label;
				if(text.height>20)
				{
				   rst=wordsByKeyMap["textAreaDefine"];
				}
				else
				{
					rst=wordsByKeyMap["labelDefine"];
				}
				
				rst = rst.replace(new RegExp("\\{varName\\}", "g"), text.name);
			}
			return rst;
		}
		
		/**
		 * 生成Item类代码 
		 * @param classDs
		 * @param vars
		 * @param inits
		 * @param ButtonAddEventListeners
		 * @param ButtonEventHandlers
		 * @return 
		 * 
		 */
		public  function createSTItemClass(classDs:MyClassDescribe,vars:String="",inits:String="",ButtonAddEventListeners:String="",ButtonEventHandlers:String=""):String
		{
			var rst:String;
			rst=wordsByKeyMap["itemClassTemplate"];
			rst = rst.replace(new RegExp("\\{className\\}", "g"), classDs.className);
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			rst = rst.replace(new RegExp("\\{package\\}", "g"), classDs.classPackage);
			rst = rst.replace(new RegExp("\\{addVar\\}", "g"), vars);
			rst = rst.replace(new RegExp("\\{addButtonAddEventListener\\}", "g"), ButtonAddEventListeners);
			rst = rst.replace(new RegExp("\\{addButtonEventHandlers\\}", "g"), ButtonEventHandlers);
			rst = rst.replace(new RegExp("\\{addInit\\}", "g"), inits);
			rst = rst.replace(new RegExp("\\{addReset\\}", "g"), inits);
			return rst;
		}
		
		
		/**
		 * 生成Panel类代码 
		 * @param classDs
		 * @param vars
		 * @param inits
		 * @param ButtonAddEventListeners
		 * @param ButtonEventHandlers
		 * @return 
		 * 
		 */
		public  function createSTPanelClass(classDs:MyClassDescribe,vars:String="",inits:String="",ButtonAddEventListeners:String="",ButtonEventHandlers:String=""):String
		{
			var rst:String;
			rst=wordsByKeyMap["panelClassTemplate"];
			rst = rst.replace(new RegExp("\\{className\\}", "g"), classDs.className);
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), classDs.funName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), classDs.modName);
			rst = rst.replace(new RegExp("\\{package\\}", "g"), classDs.classPackage);
			rst = rst.replace(new RegExp("\\{addVar\\}", "g"), vars);
			rst = rst.replace(new RegExp("\\{addButtonAddEventListener\\}", "g"), ButtonAddEventListeners);
			rst = rst.replace(new RegExp("\\{addButtonEventHandlers\\}", "g"), ButtonEventHandlers);
			rst = rst.replace(new RegExp("\\{addInit\\}", "g"), inits);
			rst = rst.replace(new RegExp("\\{addReset\\}", "g"), inits);
			
			return rst;
		}
		/**
		 * 创建变量定义 
		 * @param dis
		 * @return 
		 * 
		 */
		public function createVarDefine(dis:DisplayObject):String
		{
			
			var rst:String;
			if(!dis) return "";
			if(dis.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{				
				rst=wordsByKeyMap["varDefine"];
								
				rst = rst.replace(new RegExp("\\{varName\\}", "g"), dis.name);
				rst = rst.replace(new RegExp("\\{className\\}", "g"), ClassAnalyser.getClassName(dis));
				
				
				if(tClassDs.classType==MyClassDescribe.CLASS_TYPE_ITEM)//item类型 为按钮添加回调函数
					if(ClassAnalyser.isButton(dis))
					{
					    var btnHandler:String;
						btnHandler=wordsByKeyMap["BtnEventHandlersDefine"];
						btnHandler = btnHandler.replace(new RegExp("\\{BtnName\\}", "g"), ClassAnalyser.getButtonName(dis));
//						rst+=btnHandler;
					}
			}
			return rst;
		}
		
		/**
		 * 创建 Btn加侦听代码 
		 * @param dis
		 * @return 
		 * 
		 */
		public function createAddButtonAddEventListener(dis:DisplayObject):String
		{
			
			var rst:String;
			if(!dis) return "";
			if(!ClassAnalyser.isButton(dis)) return "";
			if(dis.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{				
				rst=wordsByKeyMap["BtnAddEventListner"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), dis.name);
			}
			return rst;
		}
		
		/**
		 * 创建 Btn加侦听代码 
		 * @param dis
		 * @return 
		 * 
		 */
		public function createPanelAddButtonAddEventListener(dis:DisplayObject):String
		{
			
			var rst:String;
			if(!dis) return "";
			if(!ClassAnalyser.isButton(dis)) return "";
			if(dis.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{				
				rst=wordsByKeyMap["PanelBtnAddEventListner"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), dis.name);
				rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			}
			return rst;
		}
		
		/**
		 * 创建按钮事件处理代码 
		 * @param dis
		 * @return 
		 * 
		 */
		public function createBtnEventHandlers(dis:DisplayObject):String
		{
			
			var rst:String;
			if(!dis) return "";
			if(!ClassAnalyser.isButton(dis)) return "";
			if(dis.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{				
				rst=wordsByKeyMap["BtnEventHandlers"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), dis.name);
				rst = rst.replace(new RegExp("\\{BtnName\\}", "g"), ClassAnalyser.getButtonName(dis));
				//rst = rst.replace(new RegExp("\\{name\\}", "g"), dis.name);
			}
			return rst;
		}
		
		
		/**
		 * 生成ViewBtnHandler代码类 
		 * @return 
		 * 
		 */
		public function createViewBtnEventCode(btnName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["viewBtnEventHandler"];
			rst = rst.replace(new RegExp("\\{BtnName\\}", "g"), btnName);
			
			return rst;
		}
		
		
		/**
		 * 生成Event代码类 
		 * @return 
		 * 
		 */
		public function createPanelEventCode():String
		{
			var rst:String;
			rst=wordsByKeyMap["eventFile"];
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), tClassDs.modName);
			
			return rst;
		}
		
		
		/**
		 * 生成Base代码类 
		 * @return 
		 * 
		 */
		public function createBaseCode():String
		{
			var rst:String;
			rst=wordsByKeyMap["baseFile"];
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			rst = rst.replace(new RegExp("\\{className\\}", "g"), tClassDs.className);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), tClassDs.modName);
			return rst;
		}
		
		/**
		 * 生成View代码类 
		 * @return 
		 * 
		 */
		public function createViewCode():String
		{
			var rst:String;
			rst=wordsByKeyMap["viewFile"];
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			rst = rst.replace(new RegExp("\\{className\\}", "g"), tClassDs.className);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), tClassDs.modName);
			rst = rst.replace(new RegExp("\\{upfunName\\}", "g"), StringTool.toUpCase(tClassDs.funName));
			rst = rst.replace(new RegExp("\\{addBtnCases\\}", "g"),tClassDs.createViewBtnEventHandler());
			
			rst = rst.replace(new RegExp("\\{addProtocalCallBack\\}", "g"), tModDs.getAddProtocalCallBack());
			rst = rst.replace(new RegExp("\\{viewProtocalCallBack\\}", "g"),tModDs.getViewProtocalCallBack());
			return rst;
		}
		/**
		 * 生成addProtocalCallBack代码类 
		 * @return 
		 * 
		 */
		public function createAddProtocalCallBack(tProtocalDS:ProtocalDescribe):String
		{
			var rst:String;
			rst=wordsByKeyMap["addProtocalCallBack"];
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			return rst;
		}
		/**
		 * 生成viewProtocalCallBack代码类 
		 * @return 
		 * 
		 */
		public function createViewProtocalCallBack(tProtocalDS:ProtocalDescribe):String
		{
			var rst:String;
			rst=wordsByKeyMap["viewProtocalCallBack"];
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{protocalName\\}", "g"), tProtocalDS.protocalDesInfo);
			return rst;
		}
		/**
		 * 生成resolverDataDecodeItem代码类 
		 * @return 
		 * 
		 */
		public function createResolverDataDecodeItem(tProtocalDS:ProtocalDescribe,index:int):String
		{
			var rst:String;
			var tItem:dataItem;
			tItem=tProtocalDS.response[index] as dataItem;
			rst=wordsByKeyMap["resolverDataDecodeItem"];
			rst = rst.replace(new RegExp("\\{index\\}", "g"),  index);
			rst = rst.replace(new RegExp("\\{dataName\\}", "g"),tItem.dataName);
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			return rst;
		}
		
		
		/**
		 * 生成resolverItem代码类 
		 * @return 
		 * 
		 */
		public function createResolverItem(tProtocalDS:ProtocalDescribe,addDecodeItems:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["callItem"];
			rst = rst.replace(new RegExp("\\{exp\\}", "g"),  tProtocalDS.protocalDesInfo);
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{addDecodeItems\\}", "g"), addDecodeItems);
			rst = rst.replace(new RegExp("\\{addLib\\}", "g"),com.adobe.serialization.json.JSON.encode( tProtocalDS.decodeLib));
			rst = rst.replace(new RegExp("\\{param\\}", "g"), tProtocalDS.getRequestParam());
			rst = rst.replace(new RegExp("\\{paramPure\\}", "g"),tProtocalDS.getRequestParamPure());
			return rst;
		}
		
		/**
		 * 生成Resolver类代码 
		 * @param addResolverItems
		 * @return 
		 * 
		 */
		public function createResolverCode(addResolverItems:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["resolverFile"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{addResolverItems\\}", "g"), addResolverItems);
			
			return rst;
		}
		
		
//		public function createModelCode(addResolverItems:String):String
//		{
//			var rst:String;
//			rst=wordsByKeyMap["modelFile"];
//			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
//			rst = rst.replace(new RegExp("\\{addResolverItems\\}", "g"), addResolverItems);
//			
//			return rst;
//		}
		
		/**
		 * 生成matchRegistItem代码类 
		 * @return 
		 * 
		 */
		public function createMatchRegistItem(tProtocalDS:ProtocalDescribe):String
		{
			var rst:String;
			rst=wordsByKeyMap["matchRegistItem"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{exp\\}", "g"),  tProtocalDS.protocalName);
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			return rst;
		}
		
		/**
		 * 生成matchHandlerItem代码类 
		 * @return 
		 * 
		 */
		public function createMatchHandlerItem(tProtocalDS:ProtocalDescribe):String
		{
			var rst:String;
			rst=wordsByKeyMap["matchHandlerItem"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{exp\\}", "g"),  tProtocalDS.protocalName);
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			rst = rst.replace(new RegExp("\\{addLib\\}", "g"),com.adobe.serialization.json.JSON.encode( tProtocalDS.decodeLib));
			return rst;
		}
		
		/**
		 * 生成Match类代码 
		 * @param createResImport
		 * @param createResGet
		 * @return 
		 * 
		 */
		public function createMatchCode(addRegists:String,addHandlers:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["matchFile"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{addRegists\\}", "g"), addRegists);
			rst = rst.replace(new RegExp("\\{addHandlers\\}", "g"), addHandlers);
			
			return rst;
		}
		
		
		/**
		 * 生成resImport代码类 
		 * @return 
		 * 
		 */
		public function createResImport(funName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["resImport"];
			rst=modReplace(rst,funName);
			return rst;
		}
		
		/**
		 * 生成resGet代码类 
		 * @return 
		 * 
		 */
		public function createResGet(funName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["resGet"];
			rst=modReplace(rst,funName);
			return rst;
		}
		
		/**
		 * 生成Res类代码 
		 * @param createResImport
		 * @param createResGet
		 * @return 
		 * 
		 */
		public function createResCode(createResImport:String,createResGet:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["resFile"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{addImports\\}", "g"), createResImport);
			rst = rst.replace(new RegExp("\\{addGets\\}", "g"), createResGet);

			return rst;
		}
		
		public function modReplace(rst:String,funName:String):String
		{
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), funName);
			rst = rst.replace(new RegExp("\\{funNameL\\}", "g"), StringTool.toLowHead(funName));
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), tModDs.modName);
			return rst;
		}
		/**
		 * 生成ModeViewImport代码类 
		 * @return 
		 * 
		 */
		public function createModeViewImport(funName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["modeViewImport"];
			rst=modReplace(rst,funName);
			return rst;
		}
		
		/**
		 * 生成modeViewDefine代码类 
		 * @return 
		 * 
		 */
		public function createModeViewDefine(funName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["modeViewDefine"];
			rst=modReplace(rst,funName);
			return rst;
		}
		
		/**
		 * 生成modeViewInit代码类 
		 * @return 
		 * 
		 */
		public function createModeViewInit(funName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["modeViewInit"];
			rst=modReplace(rst,funName);
			return rst;
		}
		
		/**
		 * 生成modeOpenView代码类 
		 * @return 
		 * 
		 */
		public function createModeOpenView(funName:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["modeOpenView"];
			rst=modReplace(rst,funName);
			return rst;
		}
		
		/**
		 * 创建Mod类代码 
		 * @param createModeViewImport
		 * @param createModeViewDefine
		 * @param createModeViewInit
		 * @param createModeOpenView
		 * @return 
		 * 
		 */
		public function createModCode(createModeViewImport:String,createModeViewDefine:String,createModeViewInit:String,createModeOpenView:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["modFile"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{addVarImport\\}", "g"), createModeViewImport);
			rst = rst.replace(new RegExp("\\{addVarDefine\\}", "g"), createModeViewDefine);
			rst = rst.replace(new RegExp("\\{addVarInit\\}", "g"), createModeViewInit);
			rst = rst.replace(new RegExp("\\{addOpenViews\\}", "g"), createModeOpenView);
			return rst;
		}
		
		
		/**
		 * 生成structProtocalItem代码类 
		 * @return 
		 * 
		 */
		public function createStructProtocalItem(tProtocalDS:ProtocalDescribe):String
		{
			var rst:String;
			rst=wordsByKeyMap["structProtocalItem"];
			rst = rst.replace(new RegExp("\\{exp\\}", "g"),  tProtocalDS.protocalName);
			rst = rst.replace(new RegExp("\\{protocalFunName\\}", "g"), tProtocalDS.protocalFunName);
			rst = rst.replace(new RegExp("\\{moduleID\\}", "g"),  tProtocalDS.moduleID);
			rst = rst.replace(new RegExp("\\{actionID\\}", "g"),  tProtocalDS.actionID);
			rst = rst.replace(new RegExp("\\{request\\}", "g"), FileAnalyser.parseProtocalArray( tProtocalDS.request));
			rst = rst.replace(new RegExp("\\{response\\}", "g"),  FileAnalyser.parseProtocalArray( tProtocalDS.response));
			return rst;
		}
		
		public function createStructCode(addProtocals:String):String
		{
			var rst:String;
			rst=wordsByKeyMap["structFile"];
			rst = rst.replace(new RegExp("\\{modName\\}", "g"),  tModDs.modName);
			rst = rst.replace(new RegExp("\\{addProtocals\\}", "g"), addProtocals);
			return rst;
		}
		/**
		 * 生成Model代码类 
		 * @return 
		 * 
		 */
		public function createModelCode():String
		{
			var rst:String;
			rst=wordsByKeyMap["modelFile"];
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), tClassDs.modName);
//			rst = rst.replace(new RegExp("\\{param\\}", "g"), tProtocalDS.getRequestParam());
			return rst;
		}
		
		/**
		 * 生成Bean代码类 
		 * @return 
		 * 
		 */
		public function createBeanCode():String
		{
			var rst:String;
			rst=wordsByKeyMap["beanFile"];
			rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
			rst = rst.replace(new RegExp("\\{modName\\}", "g"), tClassDs.modName);
			
			return rst;
		}
		
		/**
		 * 创建Panel按钮事件处理代码 
		 * @param dis
		 * @return 
		 * 
		 */
		public function createPanelBtnEventHandlers(dis:DisplayObject):String
		{
			
			var rst:String;
			if(!dis) return "";
			if(!tClassDs) 
			{
				trace("no classDS given from createPanelBtnEventHandlers");
				return "";
			}
			if(!ClassAnalyser.isButton(dis)) return "";
			if(dis.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{				
				rst=wordsByKeyMap["PanelBtnEventHandlers"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), dis.name);
				rst = rst.replace(new RegExp("\\{funName\\}", "g"), tClassDs.funName);
				rst = rst.replace(new RegExp("\\{BtnName\\}", "g"), ClassAnalyser.getButtonEventName(dis));
			}
			return rst;
		}
		/**
		 * 创建文本框reset 
		 * @param text
		 * @return 
		 * 
		 */
		public function createTextFill(text:TextField):String
		{
			var rst:String;
			if(!text) return "";
			if(text.name.indexOf("instance")>=0)
			{
				return "";
				
			}else
			{
				// {name}.txt="";
				rst=wordsByKeyMap["LableFill"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), text.name);
			}
			return rst;
		}
		
		/**
		 * 获取按钮中的文本框 
		 * @param button
		 * @return 
		 * 
		 */
		public static function getButtonTxt(button:DisplayObjectContainer):TextField
		{
			var i:int;
			var len:int;
			var dis:DisplayObject;
			len=button.numChildren;
			for(i=0;i<len;i++)
			{
				dis=button.getChildAt(i);
				if(dis is TextField)
				{
					return dis as TextField;
				}
			}
			return null;
		}
		/**
		 * 创建XMLItem代码 
		 * @param display
		 * @return 
		 * 
		 */
		public function createXMLItem(display:DisplayObject):String
		{
			var rst:String;
			var tTxt:TextField;
			var tName:String;
			if(!display) return "";
			tName=display.name;
			if(display is TextField)
			{
				tTxt=display as TextField;
				
			}else
			{
				if(display is MovieClip)
				{
					tTxt=getButtonTxt(display as MovieClip);
				}
			}
			if(!tTxt) return "";
				// <e k="{key}" v="{value}"/>
				rst=wordsByKeyMap["xmlItem"];
				if((display is TextField)&&(tTxt.name.indexOf("instance")>=0))
				{
					rst = rst.replace(new RegExp("\\{key\\}", "g"),  CreateFunLib.tClassName+"_"+tName+"_Lang");
					rst = rst.replace(new RegExp("\\{value\\}", "g"), tTxt.text);
				}else
				{
					rst = rst.replace(new RegExp("\\{key\\}", "g"), tName+"_Lang");
					rst = rst.replace(new RegExp("\\{value\\}", "g"), tTxt.text);
				}
				

			return rst;
		}
		/**
		 * 获取文本框格式代码 
		 * @param text
		 * @return 
		 * 
		 */
		private function TextIsCenter(text:TextField):String
		{
			var fmt:TextFormat;
			fmt=text.defaultTextFormat;
			var rst:String;
			//rst=wordsByKeyMap["textFormat"];	
			if(text.height>20)
			{
				rst=wordsByKeyMap["textAreaFormat"];
			}
			else
			{
				rst=wordsByKeyMap["textFormat"];
			}
			rst = rst.replace(new RegExp("\\{align\\}", "g"),fmt.align);
			rst = rst.replace(new RegExp("\\{color\\}", "g"),fmt.color);
			return rst;
		}
		
		/**
		 * 创建ST风格的显示对象初始化代码 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public function createSTDisplayInit(displayObj:DisplayObject):String
		{
			if(displayObj is TextField)
			{
				return createTextFill(displayObj as TextField);
			}
			else
			{
//				if(displayObj is MovieClip)
//				{
//					if(displayObj.name.indexOf("Btn")>0)
//					{
//						return createBtnInit(displayObj as MovieClip);
//					}
//				}
			}
			return "";
		}
		
		/**
		 * 创建显示对象初始化代码 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public function createDisplayInit(displayObj:DisplayObject):String
		{
			if(displayObj is TextField)
			{
				return createLabelInit(displayObj as TextField);
			}
			else
			{
				if(displayObj is MovieClip)
				{
					if(displayObj.name.indexOf("Btn")>0)
					{
						return createBtnInit(displayObj as MovieClip);
					}
				}
			}
			return "";
		}
		/**
		 * 创建按钮初始化代码 
		 * @param button
		 * @return 
		 * 
		 */
		public function createBtnInit(button:MovieClip):String
		{
			var rst:String;
			rst="";
			if(button.name.indexOf("Close_Btn")>0)
			{
				rst=wordsByKeyMap["closeButtonInit"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), button.name);
				rst = rst.replace(new RegExp("\\{x\\}", "g"), button.x);
				rst = rst.replace(new RegExp("\\{y\\}", "g"), button.y);
				rst = rst.replace(new RegExp("\\{parent\\}", "g"), "itemMain");
			}else
			{
				var txt:TextField=getButtonTxt(button);
				if(txt)
				{
					rst=wordsByKeyMap["labelButtonInit"];
					rst = rst.replace(new RegExp("\\{name\\}", "g"),button.name);
//					rst = rst.replace(new RegExp("\\{txt\\}", "g"), txt.text);
					rst = rst.replace(new RegExp("\\{width\\}", "g"), button.width);
					rst = rst.replace(new RegExp("\\{x\\}", "g"), button.x);
					rst = rst.replace(new RegExp("\\{y\\}", "g"), button.y);
					rst = rst.replace(new RegExp("\\{parent\\}", "g"), "itemMain");
				}
			}
			
			return rst;
		}
		/**
		 * 创建label初始化代码 
		 * @param text
		 * @return 
		 * 
		 */
		public function createLabelInit(text:TextField):String
		{
			var rst:String;
			if(!text) return "";
			
			if(text.name.indexOf("instance")>=0)
			{
				//tipText=new LimitLabel("{txt}",{width});
				//DisplayUtil.moveTarget({parent},tipText,{x},{y});
				
				if(text.height>20)
				{
					rst=wordsByKeyMap["noNameTextAreaInit"];
				}
				else
				{
					rst=wordsByKeyMap["noNameLableInit"];
				}
				
				
				rst = rst.replace(new RegExp("\\{name\\}", "g"), CreateFunLib.tClassName+"_"+text.name);
				rst = rst.replace(new RegExp("\\{txt\\}", "g"), text.text);
				rst = rst.replace(new RegExp("\\{width\\}", "g"), text.width);
				rst = rst.replace(new RegExp("\\{height\\}", "g"), text.height);
				rst = rst.replace(new RegExp("\\{x\\}", "g"), text.x);
				rst = rst.replace(new RegExp("\\{y\\}", "g"), text.y);
				rst = rst.replace(new RegExp("\\{parent\\}", "g"), "itemMain");
				rst = rst.replace(new RegExp("\\{center\\}", "g"),TextIsCenter(text));

			}else
			{
//				<e>
//					<k>NamedLableInit</k>
//					<v>
//					<![CDATA[
//							{name}=new LimitLabel("{txt}",{width});
//							DisplayUtil.moveTarget({parent},{name},{x},{y},"{name}");
//				]]>
//					</v>
//					</e>
				
				if(text.height>20)
				{
					rst=wordsByKeyMap["NamedTextAreaInit"];
				}
				else
				{
					rst=wordsByKeyMap["NamedLableInit"];
				}
				
				//rst=wordsByKeyMap["NamedLableInit"];
				rst = rst.replace(new RegExp("\\{name\\}", "g"), text.name);
				rst = rst.replace(new RegExp("\\{txt\\}", "g"), text.text);
				rst = rst.replace(new RegExp("\\{width\\}", "g"), text.width);
				rst = rst.replace(new RegExp("\\{height\\}", "g"), text.height);
				rst = rst.replace(new RegExp("\\{x\\}", "g"), text.x);
				rst = rst.replace(new RegExp("\\{y\\}", "g"), text.y);
				rst = rst.replace(new RegExp("\\{parent\\}", "g"), "itemMain");
				rst = rst.replace(new RegExp("\\{center\\}", "g"),TextIsCenter(text));
			}
			return rst;
		}
		
		
	}
}