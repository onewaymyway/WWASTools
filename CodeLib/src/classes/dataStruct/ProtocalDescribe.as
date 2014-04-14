package classes.dataStruct
{
	/**
	 * 通信协议描述类
	 * @author ww
	 * 
	 */
	public class ProtocalDescribe
	{
		public function ProtocalDescribe()
		{
			request=[];
			response=[];
		}
		/**
		 * 协议中文名
		 */
		public var protocalName:String;
		/**
		 * 协议英文名
		 */
		public var protocalFunName:String;
		/**
		 * 客户端请求数据列表
		 */
		public var request:Array;
		/**
		 * 服务器回复数据列表
		 */
		public var response:Array;
		/**
		 * 协议的模块ID
		 */
		public var moduleID:int;
		/**
		 * 协议在模块中的ID
		 */
		public var actionID:int;
		
		/**
		 * 解码服务器数据用的字典文件 
		 */
		public var decodeLib:Object;
		
		/**
		 * 创建解码用的字典文件 
		 * @return 
		 * 
		 */
		public function getResponseDecoderLib():String
		{
			decodeLib={};
			
			addDecodeLib("main",response);
			return "";
		}
		
		/**
		 *  
		 * @param tName
		 * @param itemArr
		 * 
		 */
		private function addDecodeLib(tName:String,itemArr:Array):void
		{
			var i:int;
			var len:int;
			len=itemArr.length;
			var tItem:dataItem;
			var tArr:Array;
			tArr=[];
			decodeLib[tName]=tArr;
			for(i=0;i<len;i++)
			{
				tItem=itemArr[i] as dataItem;
				tArr.push(tItem.dataName);
				if(tItem.data is Array)
				{
					addDecodeLib(tItem.dataName,tItem.data);
				}
			}
		}
	}
}