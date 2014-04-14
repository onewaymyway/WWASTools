package classes.Creater
{
	import classes.dataStruct.MapData;
	import classes.load.LoadTools;
	import classes.tools.ArrayTool;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.FileDealer;
	import classes.tools.StringTool;

	public class MissionDataCreater extends CreaterBase
	{
		public function MissionDataCreater()
		{
		}
		public static const type_MainTask:String="MainTask";
		public static const type_Man18Task:String="Man18Task";
		public static const type_HeroTask:String="HeroTask";
		private var map1Model:Object;
		private var map3Model:Object;
		private var missionSignList:Array;
		private var missionSignDList:Array;
		
		public static var missionType:String;
		override public function work():void
		{
			trace("begin work");
			missionType=type_MainTask;
//			missionType=type_Man18Task;
			createMissionData();
		}
		
		public function createMissionData():void
		{
			fileAnalyser=new FileAnalyserBase();
			initModel();
			initData();
			
		}
		
		
		private function initModel():void
		{
			
			missionSignList=[];
			missionSignDList=[];
			trace("begin initModel");
			var modelStr:String;
			modelStr=FileDealer.getInstance().readTxtFile("/res/tempData/map1.txt");
			map1Model=StringTool.getJSONObject(modelStr);
			
			modelStr=FileDealer.getInstance().readTxtFile("/res/tempData/map3.txt");
			map3Model=StringTool.getJSONObject(modelStr);
			
			
			
		}
		
		private var fileAnalyser:FileAnalyserBase;
		private var missionDataO:Object;
		private function initData():void
		{
			trace("begin initData");
//			fileAnalyser.setContent(FileDealer.getInstance().readTxtFile("/res/data/副本.ini"));
//			missionDataO=FileDealer.getInstance().readXMLFile("/res/xml/missionData.xml");
			var fileName:String;
//			fileName="/res/xml/missionData.xml";
			switch(missionType)
			{
				case type_MainTask:
					fileName="/res/xml/zhuxianfuben.xml";
					break;
				case type_Man18Task:
					fileName="/res/xml/shibahaohan.xml";
					break;
				default:
					fileName="/res/xml/shibahaohan.xml";
			}
//			fileName="/res/xml/zhuxianfuben.xml";
			LoadTools.loadXML(fileName,function(rst:Object):void
			{
				
				missionDataO=rst;
				parseData();
			}
			);
		}
		private function parseData():void
		{
			trace("begin initModel");
			var i:int;
			var len:int;
			var tMapData:MapData;
//			len=fileAnalyser.getLineCount();
//			for(i=0;i<len;i++)
//			{
//				tMapData=fileAnalyser.parseLine(i);
//				if(tMapData)
//				{
//					savaMissionData(tMapData);
//				}
//			}
//			
			var missionList:Array;
			missionList=missionDataO.mission;
			len=missionList.length;
			for(i=0;i<len;i++)
			{
				tMapData=MapData.parseMissionData(missionList[i]);
				if(tMapData)
				{
					savaMissionData(tMapData);
				}
				missionNameMapDic[tMapData.taskName]=tMapData.sign;
				missionNameIDDic[tMapData.taskName]=tMapData.missionID;
			}
			saveMissionSign();
		}
	    private var missionNameMapDic:Object={};
		private var missionNameIDDic:Object={};
		private function savaMissionData(mapdata:MapData):void
		{
			trace("begin savaMissionData:"+mapdata.missionID);
			var tMapModel:Object;
			trace(StringTool.getJSONString(mapdata));
			missionSignList[mapdata.missionID]=mapdata.sign;
			ArrayTool.addDistictItem(missionSignDList,mapdata.sign);
			switch(mapdata.monsterList.length)
			{
				case 1:
					tMapModel=this.map1Model;
					break;
				case 3:
					tMapModel=this.map3Model;
					break;
				default:
					trace("wrong monsterLen:"+mapdata.missionID);
					return;
			}
			
			var tMonsterList:Array;
			tMonsterList=tMapModel.scenes[0].monsters;
			var i:int;
			var len:int;
			var tMonster:Object;
			len=tMonsterList.length;
			for(i=0;i<len;i++)
			{
				tMonster=tMonsterList[i];
				tMonster.id=i+1;
				tMonster.monster_id=mapdata.monsterList[i].id;
			}
			
			FileDealer.getInstance().saveTxtFile("/"+missionType+"/mapData/"+mapdata.missionID+".txt",StringTool.getJSONString(tMapModel));
			FileDealer.getInstance().saveTxtFile("/"+missionType+"/mapData/"+mapdata.taskName+".txt",StringTool.getJSONString(tMapModel));
		}
		
		private function saveMissionSign():void
		{
			FileDealer.getInstance().saveTxtFile("/"+missionType+"/missionData/"+"missionSign"+".txt",StringTool.getJSONString(missionSignList));
			FileDealer.getInstance().saveTxtFile("/"+missionType+"/missionData/"+"missionSignD"+".txt",StringTool.getJSONString(missionSignDList));
			FileDealer.getInstance().saveTxtFile("/"+missionType+"/missionData/"+"missionNameMapDic"+".txt",StringTool.getJSONString(missionNameMapDic));
			FileDealer.getInstance().saveTxtFile("/"+missionType+"/missionData/"+"missionNameIDDic"+".txt",StringTool.getJSONString(missionNameIDDic));
			FileDealer.getInstance().saveObjectToXmlFile("/"+missionType+"/missionData/MissionEntrance.xml",MapData.missionConfigXmlO,missionType);
		}
	}
}