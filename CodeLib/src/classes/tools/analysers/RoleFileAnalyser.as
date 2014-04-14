package classes.tools.analysers
{
	import classes.dataStruct.RoleItem;
	import classes.tools.Base.FileAnalyserBase;
	
	public class RoleFileAnalyser extends FileAnalyserBase
	{
		public function RoleFileAnalyser()
		{
			super();
		}
		
		override public function parseData(str:String):*
		{
			var data:RoleItem;
			data=new RoleItem();
			
			var tempArr:Array;
			tempArr=str.split("=");
			data.id=tempArr[0];
			var tempStr:String;
			tempStr=tempArr[1];
			tempArr=tempStr.split("|");
			
			data.sign=tempArr[0];		
			return data;
		}
		

		
		
	}
}