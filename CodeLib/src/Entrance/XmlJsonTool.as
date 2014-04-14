package  Entrance
{
	import classes.dataStruct.XMLObject;
	import classes.load.LoadTools;
	import classes.tools.FileDealer;
	
	import flash.display.Sprite;
	
	public class XmlJsonTool extends Sprite
	{
		public function XmlJsonTool()
		{
//			reWriteXML("res/xml/Task.xml","/res/xml/re/Task.xml");
			
			
			reWriteXML("res/xml/TaskEntrance.xml","/xml/re/TaskEntrance.xml");
		}
		
		public function reWriteXML(fileName:String,oPath:String):void
		{
//			oObjec=FileDealer.getInstance().readXMLFile(fileName);
			
			LoadTools.loadXML(fileName,function(rst:Object):void
			{
				
				editObject(rst);
				writeXML(oPath,rst);
			}
			);
			
		}
		public function editObject(data:Object):void
		{
			reWriteEntrance(data);
		}
		private function reWriteTask(data:Object):void
		{
			var tObj:Object;
			tObj=data;
			var taskList:Array;
			taskList=tObj["task"];
			
			var i:int;
			var len:int;
			var tTask:Object;
			var tDo:Object;
			len=taskList.length;
			for(i=0;i<len;i++)
			{
				tTask=taskList[i];
				tTask["next"]="[1,2]"
				tDo=tTask["do"]["d"];
				tDo.time="1";
			}
		}
		
		private var entranceList:Array=["Man18Task","HeroTask","KingTask","MainTask"];
		public function reWriteEntrance(data:Object):void
		{
			var tObj:Object;		
			var tType:String;
			var i:int;
			var len:int;
			len=entranceList.length;
			for(i=0;i<len;i++)
			{
				tType=entranceList[i];
				tObj=data[tType];
				reWriteEntranceT(tObj);
			}
		}
		public function reWriteEntranceT(data:Object):void
		{
			var tObj:Object;
			tObj=data;
			var taskList:Array;
			taskList=tObj["war"];
			
			var tType:String;
			var i:int;
			var len:int;
			var tWar:Object;
			len=taskList.length;
			for(i=0;i<len;i++)
			{
				tWar=taskList[i];
				reWriteWar(tWar);
			}
		}
		public function reWriteWar(data:Object):void
		{
			var tObj:Object;
			tObj=data;
			var taskList:Array;
			taskList=tObj["task"];
			
			var tType:String;
			var i:int;
			var len:int;
			var tWar:Object;
			len=taskList.length;
			for(i=0;i<len;i++)
			{
				tWar=taskList[i];
				tWar.missionID=Number(tWar.id)+1;
			}
		}
		public function writeXML(fileName:String,object:Object):void
		{
			var tO:XMLObject;
			tO=new XMLObject(object,object.name,0);
			FileDealer.getInstance().saveXMLFile(fileName,tO.writeXML());
		}
	}
}