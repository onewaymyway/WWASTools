package ww599.dataStruct
{
	public class CodeBlockDescribe  extends CodeBaseDes
	{
		public function CodeBlockDescribe()
		{
			codeList=[];
		}
		public var codeList:Array;
		
		public function addCode(codeDes:CodeDescribe):void
		{
			codeList.push(codeDes);
		}
		public function addCodeBlock(codeBlock:CodeBlockDescribe):void
		{
			codeList.push(codeBlock);
		}
		public function getBlockText():String
		{
			var rst:String;
			
			rst="{";
			var tBlock:CodeBlockDescribe;
			var tCode:CodeDescribe;
			var i:int;
			var len:int;
			len=codeList.length;
			for(i=0;i<len;i++)
			{
				tBlock=codeList[i] as CodeBlockDescribe;
				if(tBlock) rst+=tBlock.getBlockText();
				tCode=codeList[i] as CodeDescribe;
				if(tCode) rst+=tCode.getCodeText();
			}
			
			rst+="}";
			return rst;
		}
	}
}