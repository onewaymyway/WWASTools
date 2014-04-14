package classes.tools.Base
{
	import classes.dataStruct.MapData;
	import classes.tools.FileDealer;
	
	import flash.text.TextField;

	public class FileAnalyserBase
	{

		public function FileAnalyserBase()
		{
			txtField=new TextField();
		}
		public var txtField:TextField;
		public var tLine:int;
		public function setContent(txt:String):void
		{
			txtField.text=txt;
			txtField.wordWrap=false;
			tLine=0;
		}
		
		/**
		 * 获取某行的文本
		 * @param line
		 * @return 
		 * 
		 */
		public function getLineTxt(line:int):String
		{
			return txtField.getLineText(line);
		}
		
		public function loadTargetFile(fileName:String):void
		{
			var fileContent:String;
			fileContent=FileDealer.getInstance().readTxtFile(fileName);
			setContent(fileContent);
		}
		/**
		 * 获取行数
		 * @return 
		 * 
		 */
		public function getLineCount():int
		{
			return txtField.numLines;
		}
		
		public function parseLine(lineNum:int):*
		{
			var tLine:String;
			tLine=getLineTxt(lineNum);
			
			trace("line:"+lineNum+" "+tLine);
			if(tLine.indexOf("=")>0)
			{
                 return parseData(tLine);
			}
			else
			{
				trace("line:"+lineNum+" is empty");
				return null;
			}
			return null;
		}
		
		public function parseWork():void
		{
			var i:int;
			var len:int;
			var tMapItem;
			len=this.getLineCount();
			for(i=0;i<len;i++)
			{
				
			}
		}
		public function parseData(str:String):*
		{
			var mapData:MapData;
			mapData=new MapData();
			
			var tempArr:Array;
			tempArr=str.split("=");
			var tempStr:String;
			tempStr=tempArr[1];
			tempArr=tempStr.split("|");
			var missionID:int;
			mapData.sign=tempArr[0];
			missionID=tempArr[1];
			mapData.missionID=missionID;
			var i:int;
			var len:int;
			var tMonsterID:int;
			len=tempArr.length;
			for(i=3;i<len;i++)
			{
				tMonsterID=parseMonsterData(tempArr[i]);
				if(tMonsterID>0)
				mapData.monsterList.push(tMonsterID);
			}
			
			return mapData;
		}
		public function parseMonsterData(data:String):int
		{
			var tID:int;
			tID=data.indexOf("(");
			var monsterID:int;
			monsterID=-1;
			if(tID>0)
			{
				monsterID=Number(data.substring(0,tID));
			}
			
			return monsterID;
		}
	}
}