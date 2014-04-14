package classes.tools.parser
{
	import classes.consts.CommonConsts;
	import classes.tools.StringTool;

	public class ParserBase
	{
		public function ParserBase()
		{
		}
		public var type:String;
		public var data:Array;
		public function parse(str:String):void
		{
			str=StringTool.trim(str);
			if(!str||str.length<1)
			{
				type=CommonConsts.TYPE_EMPTY;
				return;
			}
			if(str.substr(0,2)=="//")
			{
				type=CommonConsts.TYPE_COMMENT;
				return;
			}
			if(str.substr(0,1)=="[")
			{
			   type=CommonConsts.TYPE_BEGIN;
			   return;
			}
			var tmpArr:Array;
			tmpArr=str.split("=");
			type=tmpArr[0];
			var tmpStr:String;
			tmpStr=tmpArr[1];
			if(tmpStr)
			{
				data=tmpStr.split("|");
			}
			moreParse();
		}
		public function moreParse():void
		{
			
		}
	}
}