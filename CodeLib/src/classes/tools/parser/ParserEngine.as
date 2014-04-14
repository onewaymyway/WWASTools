package classes.tools.parser
{
	import classes.consts.CommonConsts;
	import classes.tools.ArrayTool;
	import classes.tools.FileDealer;
	import classes.tools.StringTool;
	
	import ww599.Tools.ObjectTools;
	
	
	

	/**
	 * ini解析引擎
	 * @author ww
	 * 
	 */
	public class ParserEngine
	{
		public function ParserEngine()
		{
			parserDic={};
		}
		public var parserDic:Object;
		public function loadDesFile(fileName:String):void
		{
			var tObject:Object;
			tObject=FileDealer.getInstance().readJSONFile(fileName);
			var tObjectList:Array;
			tObjectList=tObject as Array;
			ObjectTools.adaptObjectList(tObjectList,createParserDicI);
			function createParserDicI(tDes:Object,index:int):void
			{
				var tCommonParser:CommonParser;
				tCommonParser=new CommonParser;
				tCommonParser.setDesStruct(tDes);
				parserDic[tCommonParser.sign]=tCommonParser;
			}
		}
		public function getLineType(str:String):String
		{
			var type:String;
			str=StringTool.trim(str);
			if(!str||str.length<1)
			{
				type=CommonConsts.TYPE_EMPTY;
				return type;
			}
			var tStr:String;
			tStr=str.substr(1,2);
//			if(tStr=="//")
			if(str.indexOf("//")>=0)
			{
				type=CommonConsts.TYPE_COMMENT;
				return type;
			}
			tStr=str.substr(1,1);
//			if(tStr=="[")
			if(str.indexOf("[")>=0)
			{
				type=CommonConsts.TYPE_BEGIN;
				return type;
			}
			var sPos:int;
			sPos=str.indexOf("=");
			if(sPos>=0)
			{
				var tNum:int;
				
				tNum=Number(str.substring(0,sPos));
				if(tNum>0)
				{
					type=CommonConsts.TYPE_NUMBER;
					return type;
				}
				
			}
			var tType:String;
			var tCParser:CommonParser;
			for(tType in parserDic)
			{
				tCParser=parserDic[tType];
				if(tCParser)
				{
					if(str.indexOf(tType)==0)
					{
						return tType;
					}
				}
			}
			return CommonConsts.TYPE_EMPTY;
		}
		public function getSectionName(str:String):String
		{
			var rst:String;
			rst=StringTool.trim(str);
			rst=rst.substr(1);
//			rst=StringTool.getReplace(rst,"[","");
			rst=StringTool.getReplace(rst,"]","");
			return rst;
		}
		public function getSignArrID(str:String):int
		{
			var tType:String;
			tType=getLineType(str);
			var kID:int;
			var rst:Number;
			rst=StringTool.readInt(str);
			return rst;
		}
		public function parseLine(str:String,tType:String,tPObject:Object):void
		{
			str=StringTool.trim(str);
			var tCParser:CommonParser;
			tCParser=parserDic[tType];
			if(tCParser)
			{
				tCParser.parseData(str,tPObject);
			}else
			{
				return;
			}
		}
	}
}