package classes.dataStruct
{
	import classes.Creater.MissionDataCreater;

	public class MapData
	{
		public function MapData()
		{
		}
		
		public var missionID:int=0;
		public var monsterList:Array=[];
		public var sign:String;
		public var cityID:int;
		public var taskName:String;
		public static const mapList:Array=[
			"JiaoWai",
			"JiaoWai",//1
			"ZhaShuGang",//2
			"ErXianZhuang",//3
			"LeiTai",//4
			"XingHuaLin",//5
			"ZaoJiaoLin",//6
			"BeiPingFu",//7
			"LiangShanGe",//8
			"JunYing",//9
			"YueWangFu",//10
			"ChangMingDian",//11
			"HuaDengJie",//12
			"JiNanFu",//13
			"ZongBingFu",//14
			"LiCheng",//15
			"NuNanZhuang",//16
			"XiaoGuShan",//17
			"ChiShuiWan",//18
			"JinYePo",//19
			"JunYing",//20
			"JiaoWai"
		];
		public static function parseMissionData(data:Object):MapData
		{
			if(MissionDataCreater.missionType==MissionDataCreater.type_Man18Task)
			{
				data.cityID=data.jmap;
			}
			var tMapData:MapData;
			tMapData=new MapData();
			tMapData.missionID=Number(data.id);
			tMapData.cityID=Number(data.cityID);
			tMapData.taskName=String(data.name);
			tMapData.sign=mapList[Number(data.mapID)];
			if(data.monster is Array)
			{
				tMapData.monsterList=data.monster;
			}else
			{
				tMapData.monsterList=[data.monster];
			}
			addMission(tMapData);
			return tMapData;
		}
		public static var missionConfigXmlO:Object={"war":[]};
		public static function addMission(tMapData:MapData):void
		{
			var missionO:Object={};
			missionO.id=tMapData.missionID-1;
			missionO.missionID=tMapData.missionID;
			missionO.taskName=tMapData.taskName;
			missionO.picURL="";
			var tList:Array;
			tList=getWarListByWarID(tMapData.cityID);
			tList.push(missionO);
		}
		public static function getWarListByWarID(warID:int):Array
		{
		
			return getWarObj(warID).task;
		}
		public static function getWarObj(warID:int):Object
		{
			var rst:Object;
			var all:Array;
			all=missionConfigXmlO["war"];
			if(all.hasOwnProperty(warID))
			{
				rst=all[warID];
			}else
			{
				rst=getTempWarObj(warID);
				all[warID]=rst;
			}
			return rst;
		}
		/**
		 * 城镇名字列表
		 */
		public static const townNameList:Array=[
			"",//
			"潞州",//0
			"顺义村",//1
			"幽州",//2
			"长安",//3
			"登州",//4
			"兖州",//5
			"瓦岗",//6
			"潞州",//7
		];
		public static function getTempWarObj(warID:int):Object
		{
			var rst:Object={};
			rst.id=warID;
			rst.warName=townNameList[warID];
			rst.minTaskId=1;
			rst.maxTaskID=1;
			rst.defaultPicURL="ShiDaNai.png";
			rst.task=[];
			return rst;
		}
	}
}