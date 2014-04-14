package classes.Creater
{
	import classes.dataStruct.RoleItem;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.FileDealer;
	import classes.tools.StringTool;
	import classes.tools.analysers.RoleFileAnalyser;

	public class RoleDataCreater extends CreaterBase
	{
		public function RoleDataCreater()
		{
		}
		
		
		override public function work():void
		{
			trace("begin work");
			createMissionData();
		}
		
		public function createMissionData():void
		{
			fileAnalyser=new RoleFileAnalyser();
			initModel();
			initData();
			parseData();
		}
		
		private var roleList:Array=[];
		private function initModel():void
		{
			trace("begin initModel");

			roleList=[];
			
		}
		
		private var fileAnalyser:FileAnalyserBase;
		private function initData():void
		{
			trace("begin initData");
//			fileAnalyser.setContent(FileDealer.getInstance().readTxtFile("/res/data/人物属性.ini"));
			fileAnalyser.setContent(FileDealer.getInstance().readTxtFile("/res/data/renwushuxing.ini"));
		}
		private function parseData():void
		{
			trace("begin initModel");
			var i:int;
			var len:int;
			var data:*;
			len=fileAnalyser.getLineCount();
			for(i=0;i<len;i++)
			{
				data=fileAnalyser.parseLine(i);
				if(data)
				{
					roleList.push(data);
				}
			}
			savaData();
		}
		private function savaData():void
		{
            var rst:Array;
			var i:int;
			var len:int;
			var tRole:RoleItem;
			rst=[];
			len=roleList.length;
			for(i=0;i<len;i++)
			{
				tRole=roleList[i];
//				rst[tRole.id]=tRole.sign;
				rst.push(tRole.sign);
			}
			FileDealer.getInstance().saveTxtFile("/roleData/"+"roleJson"+".txt",StringTool.getJSONString(rst));
		}
	}
}