package classes.Creater
{
	import classes.tools.ArrayTool;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.FileDealer;
	import classes.tools.StringTool;
	import classes.tools.analysers.DramaDataAnalyser;
	
	import ww599.load.LoadTools;

	public class DramaXMLCreater extends CreaterBase
	{
		public function DramaXMLCreater()
		{
			super();
		}
		
		override public function work():void
		{
			trace("begin work");
			createDramaData();
		}
		
		public function createDramaData():void
		{
			fileAnalyser=new DramaDataAnalyser();
			initModel();
			initData();
			
		}
		
		
		private function initModel():void
		{
					
						
		}
		
		private var fileAnalyser:DramaDataAnalyser;
		private var dramaDataO:Object;
		private function initData():void
		{
			trace("begin initData");
			var fileName:String;
			fileName="/res/xml/dramaXML.xml";
			LoadTools.loadXML(fileName,function(rst:Object):void
			{
				
				dramaDataO=rst;
				parseData();
			}
			);
		}
		private function parseData():void
		{
                var i:int;
				var len:int;
				var tDramaO:Object;
				var dramaList:Array;
				dramaList=dramaDataO.drama as Array;
				len=dramaList.length;
				for(i=0;i<len;i++)
				{
					tDramaO=dramaList[i];
					fileAnalyser.parseDramaData(tDramaO);
					savaDramaData(tDramaO);
					reWriteMissionData(tDramaO);
				}
				saveDramaMission();
		}
		private function savaDramaData(dramadata:Object):void
		{
			
			FileDealer.getInstance().saveObjectToXmlFile("/dramaXML/"+dramadata.fileName+".xml",dramadata.dramaXMLO,"drama");
			
		}
		
		private function reWriteMissionData(dramadata:Object):void
		{
			var tMissionName:String;
			tMissionName=dramadata.missionName;
			var dramaFileName:String;
			dramaFileName=dramadata.fileName+".xml";
			var tDramaPos:String;
			tDramaPos=dramadata.pos;
			
			var tMissionO:Object;
			tMissionO=getMissionOByMissionName(tMissionName);
			
			switch(tDramaPos)
			{
				case "s":
					tMissionO.video_file=dramaFileName;
					break;
				case "e":
					var mstList:Array;
					var tMonster:Object;
					mstList=tMissionO.scenes[0].monsters;
					tMonster=mstList[mstList.length-1];
					tMonster.end_video_file=dramaFileName;
					break;
			}
		}
		private var dataDramaMissionDic:Object={};
		private function getMissionOByMissionName(tMissionName:String):Object
		{
			if(dataDramaMissionDic.hasOwnProperty(tMissionName)) return dataDramaMissionDic[tMissionName];
			var tMissionO:Object;
			tMissionO=FileDealer.getInstance().readJSONFile("/MainTask/mapData/"+tMissionName+".txt");
			dataDramaMissionDic[tMissionName]=tMissionO;
			return tMissionO;
		}
		private function saveDramaMission():void
		{
			var tMissionName:String;
			var tMissionO:Object;
			var dramadMissionNameList:Array=[];
			for(tMissionName in dataDramaMissionDic)
			{
				tMissionO=dataDramaMissionDic[tMissionName];
				if(tMissionO)
				{
					FileDealer.getInstance().saveTxtFile("/missionDataDramaedNew/"+tMissionName+".txt",StringTool.getJSONString(tMissionO));
				}
				dramadMissionNameList.push(tMissionName);
			}
			FileDealer.getInstance().saveTxtFile("/dramadMissionNameListNew/"+"dramadMissionNameList"+".txt",StringTool.getJSONString(dramadMissionNameList));
		}
		private function saveMissionSign():void
		{

		}
	}
}