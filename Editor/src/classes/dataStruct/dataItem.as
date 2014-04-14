package classes.dataStruct
{
	import classes.tools.FileAnalyser;

	/**
	 * 通信协议中的数据单元Item
	 * @author ww
	 * 
	 */
	public class dataItem
	{
		public function dataItem()
		{
		}
		public var data:*;
		public var dataName:String;
		public var dataType:String;
		
		public function getDataParamText():String
		{
			var type:String;
			type=FileAnalyser.ItemToASDic[dataType];
			if(!type)
			{
				var i:int;
				i=1;
			}
			return dataName+":"+type;
		}
		
	}
}