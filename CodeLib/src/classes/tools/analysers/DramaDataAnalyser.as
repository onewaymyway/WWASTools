package classes.tools.analysers
{
	import classes.DataClasses.MapMissionTaskData;
	import classes.tools.ArrayTool;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.StringTool;
	
	public class DramaDataAnalyser extends FileAnalyserBase
	{
		public function DramaDataAnalyser()
		{
			super();
		}
		
		private var DramaXMLO:Object;
		override public function parseData(str:String):*
		{
			// TODO Auto Generated method stub
			var rst:Object;
			return super.parseData(str);
		}
		
		public function parseDramaData(dramaO:Object):Object
		{
			this.setContent(dramaO.data);
			var dataList:Array=[];
			var roleNameList:Array=[];
			var rstRoleList:Array=[];
			var i:int;
			var len:int;
			var tLine:String;
			var tStr:String;
			var tName:String;
			var tMsg:String;
			var tArr:Array;
			var tXMLO:Object;
			len=getLineCount();
			for(i=0;i<len;i++)
			{
				
				tLine=getLineTxt(i);
				tLine=StringTool.trim(tLine);
				if(tLine.indexOf("：")<0) continue;
				tArr=tLine.split("：");
				tName=tArr[0];
				tMsg=tArr[1];
				tXMLO=getDataItem(tName,tMsg);
				dataList.push(tXMLO);
				if((tName!="主角")&&(tName!="heimu"))
				{
					ArrayTool.addDistictItem(roleNameList,tName);
				}
			}
			DramaXMLO={};
			len=roleNameList.length;
			for(i=0;i<len;i++)
			{
				tName=roleNameList[i];
				tXMLO=getRolePos(tName);
				rstRoleList.push(tXMLO);
			}
			dramaO.map=MapMissionTaskData.getMissionMapByMissionName(dramaO.missionName);
			DramaXMLO.map=getMapData(dramaO.map);
			DramaXMLO.user=getUserPos();
			DramaXMLO.role=rstRoleList;
			DramaXMLO.data=dataList;
			dramaO.dramaXMLO=DramaXMLO;
			return dramaO;
		}
		private function getDataItem(name:String,msg:String):Object
		{
			var rst:Object;
			rst={};
			rst.type="say";
			if(name=="heimu")
			{
				rst.type="heimu";
			}
			rst.msg=msg;
			rst.name=name;
			if(name=="主角")
			{
				rst.name="user";
				rst.dir=1;
			}else
			{
				rst.dir=2;
			}
			rst.t1="0";
			rst.t2="9999";
			rst.scale="0";
			rst.wait="2000";
			return rst;
		}
		private function getUserPos():Object
		{
			var rst:Object;
			rst={};
			rst.name="user";
			rst.x="650";
			rst.y="650";
			rst.sign="";
			rst.t1="0";
			rst.t2="9999";
			rst.dir="1";
			return rst;
		}
		private function getRolePos(name:String):Object
		{
			var rst:Object;
			rst={};
			rst.name=name;
			rst.x="850";
			rst.y="650";
			rst.sign="";
			rst.t1="0";
			rst.t2="999990";
			rst.dir="2";
			return rst;
		}
		private function getMapData(mapSign:String):Object
		{
			var rst:Object;
			rst={};
			rst.url="map/mission/"+mapSign+"/map.swf";
			rst.x="0";
			rst.y="650";
			return rst;
		}
	}
}