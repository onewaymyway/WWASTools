package classes.tools.analysers
{
	import classes.consts.CommonConsts;
	import classes.dataStruct.XMLObject;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.DebugTools;
	import classes.tools.FileDealer;
	import classes.tools.XML2Object;
	import classes.tools.parser.ParserEngine;
	
	
	public class MissionMapDataAnalyser extends FileAnalyserBase
	{
		public function MissionMapDataAnalyser()
		{
			super();
			parserEngine=new ParserEngine;
//			parserEngine.loadDesFile("/res/parseDes/MissionDataDesS.txt");
			parserEngine.loadDesFile("/res/parseDes/MissionDataDesNow.txt");
		}
		public var MissionDataList:Array=[];
		public var parserEngine:ParserEngine;
		override public function parseWork():void
		{
			var i:int;
			var len:int;
			var tType:String;
			var tStr:String;
			var tMissionData:Object={};
			len=this.getLineCount();
			for(i=0;i<len;i++)
			{
				tStr=this.getLineTxt(i);
				tType=parserEngine.getLineType(tStr);
				switch(tType)
				{
					case CommonConsts.TYPE_BEGIN:
						tMissionData=new Object;
						tMissionData.name=parserEngine.getSectionName(tStr);
						MissionDataList.push(tMissionData);
						break;
					case CommonConsts.TYPE_COMMENT:
					case CommonConsts.TYPE_EMPTY:
						continue;
						break;
					default:
						parserEngine.parseLine(tStr,tType,tMissionData);
				}
			}
			
			DebugTools.traceObj(MissionDataList,"resultdd");
			var tO:XMLObject;
			tO=new XMLObject(MissionDataList,"data",0);
			FileDealer.getInstance().saveXMLFile("/output/xml/data.xml",tO.writeXML());
		}
	}
}