package
{
	import classes.dataStruct.MyClassDescribe;
	import classes.dataStruct.MyModuleDescribe;
	import classes.load.ZHLoader;
	import classes.tools.ClassAnalyser;
	import classes.tools.CreateFunLib;
	import classes.tools.FileAnalyser;
	import classes.tools.FileDealer;
	
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.NameUtil;
	
	
	/**
	 * 代码生成器主控制类
	 * @author ww
	 * 
	 */
	public class Editor extends Sprite
	{
		private var completeCount:int;
		private var classList:Array;
		private var loader:URLLoader=new URLLoader();
		private var createObj:Object;
		
		public var modDs:MyModuleDescribe;
		public function Editor()
		{
			classList=new Array;
			CreateFunLib.getInstance();
			//TweenMax.delayedCall(2,solveSWF,["res/swfs/GetReward.swf"]);
			modDs=new MyModuleDescribe;
			configEditor();
			//solveSWF("res/swfs/Union_System_View.swf");
		}
		
		/**
		 * 配置生成器参数 
		 * 
		 */
        public function configEditor():void
		{
			//设置模块名称
			
			
			
//			modDs.modName="Mission";
////			modDs.setProtocalFile("39协议-主线副本.txt");
//			modDs.setProtocalFile("39协议-主线副本新.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="MainMissionHang";
//			modDs.setProtocalFile("39协议-主线副本挂机.txt");
//			beginWork("MainMissionHang.swf");
			
			
//			modDs.modName="EliteMissionHang";
//			modDs.setProtocalFile("50协议-精英副本挂机.txt");
//			beginWork("EliteMissionHang.swf");
			
//			modDs.modName="Man18MissionHang";
//			modDs.setProtocalFile("51协议-十八好汉挂机.txt");
//			beginWork("Man18MissionHang.swf");
			
//			modDs.modName="BattleData";
//			//			modDs.setProtocalFile("39协议-主线副本.txt");
//			modDs.setProtocalFile("14协议-战斗.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="Auto";
//			modDs.setProtocalFile("47协议-主动推送 .txt");
//			beginWork("moneyTree.swf");
			
			
//			modDs.modName="Auto";
//			modDs.setProtocalFile("47协议-主动推送 .txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="Effect";
//			modDs.setProtocalFile("47协议-主动推送 .txt");
//			beginWork("AcceptFlowerEffect.swf");
			
//			modDs.modName="SeekFriend";
//			modDs.setProtocalFile("31协议-好友添加.txt");
//			beginWork("SeekFriend.swf");
			
//			modDs.modName="LegionTech";
//			modDs.setProtocalFile("43协议-军团科技.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="Question";
//			modDs.setProtocalFile("33协议-答题.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="Legion";
//			modDs.setProtocalFile("17协议-军团.txt");
//			beginWork("moneyTree.swf");
			
			
//			modDs.modName="ToolBar";
//			modDs.setProtocalFile("55协议-功能开放.txt");
//			beginWork("moneyTree.swf");
			
			
//			modDs.modName="ChargeReward";
//			modDs.setProtocalFile("56协议-奖励充值.txt");
//			beginWork(modDs.modName+".swf");
			
//			modDs.modName="Upgrade";
//			//			modDs.setProtocalFile("39协议-主线副本.txt");
//			modDs.setProtocalFile("12协议-强化.txt");
//			beginWork("upgrade.swf");
//			
//			modDs.modName="CampWar";
//			modDs.setProtocalFile("27协议-阵营.txt");
//			beginWork(modDs.modName+".swf");
			
//			modDs.modName="DealEquips";
//			modDs.setProtocalFile("11协议-背包.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="FourForOne";
//			modDs.setProtocalFile("35协议-四海同心.txt");
//			beginWork("moneyTree.swf");
//			modDs.modName="NPCDialog";
//			
			
			modDs.modName="WorldBoss";
			modDs.setProtocalFile("23协议-世界BOSS.txt");
			beginWork("moneyTree.swf");
			
			
//			modDs.modName="FriendNew";
//			modDs.setProtocalFile("31协议-好友.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="Friend";
//			modDs.setProtocalFile("31协议-好友.txt");
//			beginWork("friend.swf");
//			modDs.modName="TradeHouse";
//			modDs.setProtocalFile("54协议-阅历交易所.txt");
//			beginWork(modDs.modName+".swf");
			
			
//			modDs.modName="MoneyTree";
//			modDs.setProtocalFile("40协议-摇钱树.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="FactionWar";
//			modDs.setProtocalFile("44协议-军团争霸战.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="DealMissionReward";
//			modDs.setProtocalFile("50协议-精英副本分配奖品.txt");
//			beginWork("DealMissionReward.swf");
			
			
//			modDs.modName="FactionWarDeploy";
//			modDs.setProtocalFile("45协议-军团争霸战布阵.txt");
//			beginWork("moneyTree.swf");
			
//			modDs.modName="FlagWar";
//			modDs.setProtocalFile("58协议-军团夺旗战.txt");
//			beginWork(modDs.modName+".swf");
			
//			modDs.modName="MaidNew";
//			modDs.setProtocalFile("60协议-女仆2.txt");
//			beginWork(modDs.modName+".swf");
			
//			modDs.modName="Task";
////			modDs.setProtocalFile("24协议-任务.txt");
//			modDs.setProtocalFile("24协议-任务新.txt");
//			beginWork(modDs.modName+".swf");
			
//			modDs.modName="FollowedStore";
//			modDs.setProtocalFile("46协议-随身商店1.txt");	
//			beginWork("moneyTree.swf");
			
//			modDs.modName="EliteMission";
//			modDs.setProtocalFile("50协议-精英副本.txt");	
//			beginWork("Man18UI.swf");
			
//			modDs.modName="EliteTask";
//			modDs.setProtocalFile("50协议-精英副本.txt");	
//			beginWork("Man18UI.swf");
			
			
//			modDs.modName="Man18Task";
//			modDs.setProtocalFile("51协议-十八好汉.txt");	
//			beginWork("Man18UI.swf");
			
//			modDs.modName="Man18Mission";
//			modDs.setProtocalFile("51协议-十八好汉.txt");	
//			beginWork("Man18UI.swf");
			
			
//			modDs.modName="Maid";
//			modDs.setProtocalFile("21协议-女仆.txt");	
//			beginWork("Man18UI.swf");
			
			
//			modDs.modName="TeamNew";
//			modDs.setProtocalFile("13协议-组队新.txt");	
//			beginWork("Man18UI.swf");
			
//			modDs.modName="TuJueShop";
//			modDs.setProtocalFile("48协议-突厥商人.txt");
//			beginWork("moneyTree.swf");
//			modDs.modName="GM";
//			modDs.setProtocalFile("99协议-GM.txt");
			
//			modDs.modName="PlayerData";
//			modDs.setProtocalFile("16协议-移动.txt");
		
			
			
//			modDs.modName="World";
//			modDs.setProtocalFile("57协议-城镇开放.txt");
//			beginWork(modDs.modName+".swf");
			
			
//			modDs.modName="MapResources";
//			modDs.setProtocalFile("53协议-宝石.txt");
//			beginWork(modDs.modName+".swf");
			
			//设置模块协议文件名

			
						
//			modDs.modName="Stone";
//			modDs.setProtocalFile("53协议-宝石.txt");
//			beginWork(modDs.modName+".swf");
			
			//FileDealer.getInstance().createFolders();
//			beginWork(modDs.modName+".swf");
//			beginWork("moneyTree.swf");
			
//			beginWork("moneyTree.swf");
		}
		/**
		 * 开始工作 
		 * @param swfURL
		 * 
		 */
		public function beginWork(swfURL:String):void
		{
			TweenMax.delayedCall(2,solveSWF,["res/swfs/"+swfURL]);
		}
		private function solveSWF(url:String):void
		{
			completeCount=0;
			classList=[];
			getClassList(url);
			ZHLoader.getInstance().loadMovieClip("hello",url,loaded);
		}
		/**
		 * 解析并创建文件 
		 * 
		 */
		private function outPut():void
		{
			trace("output");
			var i:int;
			var len:int;
			var tMC:MovieClip;
			len=classList.length;
			
			//创建面板型类文件
			for(i=0;i<len;i++)
			{
				trace(classList[i]);
				
				if(MyClassDescribe.getClassTypeByName(classList[i])==MyClassDescribe.CLASS_TYPE_PANEL) continue;
				
				tMC=ZHLoader.getInstance().getMovieClipByName(classList[i]);
				//solveDisplayObject(tMC,classList[i]);
				solveDisplayObjectForST(tMC,classList[i]);
			}
			
			//创建Item型类文件
			for(i=0;i<len;i++)
			{
				trace(classList[i]);
				
				if(MyClassDescribe.getClassTypeByName(classList[i])!=MyClassDescribe.CLASS_TYPE_PANEL) continue;
				
				tMC=ZHLoader.getInstance().getMovieClipByName(classList[i]);
				//solveDisplayObject(tMC,classList[i]);
				solveDisplayObjectForST(tMC,classList[i]);
			}
			
			var rst:String;
			
			//			创建Mod类文件
			rst=modDs.createModCode();
			saveFile(modDs.modName+"Mod",rst);
			
			//			创建Res类文件
			rst=modDs.createResCode();
			saveFile(modDs.modName+"Res",rst);
			
			//			创建Struct类文件
			rst=modDs.createStructCode();;
			saveFile("protocal/"+modDs.modName+"Struct",rst);
			
			//			创建Match类文件
			rst=modDs.createMatchCode();;
			saveFile("resolver/"+modDs.modName+"Match",rst);
			
//			//			创建Resolver类文件
//			rst=modDs.createResolverCode();;
//			saveFile("resolver/"+modDs.modName+"Resolver",rst);
			
			//			创建Call类文件
			rst=modDs.createResolverCode();;
			saveFile("model/"+modDs.modName+"Call",rst);
			
			modDs.checkResult();
		}
		
		/**
		 * 根据显示对象创建类对象描述 
		 * @param dis 显示对象
		 * @param className 类名
		 * 
		 */
		private function solveDisplayObjectForST(dis:DisplayObjectContainer,className:String):void
		{
			if(!dis) return;
			var i:int;
			var len:int;
			var tChild:DisplayObject;
			var tText:TextField;
			var tClassDs:MyClassDescribe;
			
			len=dis.numChildren;
			createObj={};
			trace("-----------------------------------------");
			trace("--------------newClassBegin-------------");
			trace("-----------------------------------------");
			trace("class FullName:"+className);
			
//			tClassDs=ClassAnalyser.deCodeClassName(className);
			tClassDs=ClassAnalyser.deCodeDisplayObject(dis);
			modDs.addClass(tClassDs);
			trace("-----------------------------------------");
			trace("-----------------------------------------");
			
			
			trace("class Package:"+tClassDs.classPackage);
			trace("class Name:"+tClassDs.className);
			
			trace("-----------------------------------------");
			trace("-----------------------------------------");
			

			for(i=0;i<len;i++)
			{
				tChild=dis.getChildAt(i);
				trace(tChild.name+":"+ClassAnalyser.getClassName(tChild));
				if(ClassAnalyser.isNamed(tChild))
				{
					createObj[tChild.name]=tChild;
				}
			}
			trace("-----------------------------------------");
			trace("class End:"+className);
			trace("-----------------------------------------");
			trace("-----------------------------------------");
			
			saveSTDecode(createObj,tClassDs);
			//saveDecode(createObj,className);
		}
		
		private function saveSTDecode(obj:Object,classDS:MyClassDescribe):void
		{
			var rst:String;
			//rst=CreateFunLib.getInstance().createClass(className,createVars(obj),createFills(obj),createInit(obj));
			//rst=CreateFunLib.getInstance().createSTItemClass(classDS,createSTVars(obj),createSTInit(obj),createSTButtonAddEventListener(obj),createSTBtnEventHandlers(obj));
			
//			创建当前解析对象的类文件
			rst=classDS.createClassCode();
			
			trace("-----------------------------------------");
			trace("-----------------------------------------");
			trace("class :"+classDS.className);
			trace("-----------------------------------------");
			trace(rst);
			trace("-----------------------------------------");
			trace("-----------------------------------------");
			saveFile("res/"+classDS.className,rst);
			
			if(classDS.classType==MyClassDescribe.CLASS_TYPE_PANEL)
			{
//				创建相应的Event类文件
				rst=CreateFunLib.getInstance().createPanelEventCode();
				saveFile("event/"+classDS.funName+"Event",rst);
//				创建相应的Base类文件
				rst=CreateFunLib.getInstance().createBaseCode();
				saveFile(""+classDS.funName+"Base",rst);
//				创建相应的View类文件
				rst=CreateFunLib.getInstance().createViewCode();
				saveFile("view/"+classDS.funName+"View",rst);
//				创建相应的Model类文件
				rst=CreateFunLib.getInstance().createModelCode();
				saveFile("model/"+classDS.funName+"Model",rst);
				//				创建相应的Bean类文件
				rst=CreateFunLib.getInstance().createBeanCode();
				saveFile("bean/"+classDS.funName+"Bean",rst);
			}
			
			//saveXMLFile(className,createXML(obj));
		}
		

        private function saveFile(className:String,fileContent:String):void
		{	
			FileDealer.getInstance().saveAsFile(className,fileContent);
		}
		
		private function complete():void
		{
			completeCount++;
			
			if(completeCount>=2)
			{
				outPut();
			}
		}
		private function loaded(e:*):void
		{
			complete();
		}
		/**
		 * 获取swf中的类定义列表 
		 * @param url
		 * 
		 */
		private function getClassList(url:String):void 
		{
			
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.load(new URLRequest(url));
		}
		private function completeHandler(event:Event):void 
		{
			var bytes:ByteArray=URLLoader(event.target).data;
			bytes.endian=Endian.LITTLE_ENDIAN;
			bytes.writeBytes(bytes,8);
			bytes.uncompress();
			bytes.position=Math.ceil(((bytes[0]>>>3)*4+5)/8)+4;
			while(bytes.bytesAvailable>2){
				var head:int=bytes.readUnsignedShort();
				var size:int=head&63;
				if (size==63)size=bytes.readInt();
				if (head>>6!=76)bytes.position+=size;
				else {
					head=bytes.readShort();
					for(var i:int=0;i<head;i++){
						bytes.readShort();
						size=bytes.position;
						while(bytes.readByte()!=0);
						size=bytes.position-(bytes.position=size);
						classList.push(bytes.readUTFBytes(size));
						//trace();
					}
				}
			}
			
			complete();
			
		}
	}
}