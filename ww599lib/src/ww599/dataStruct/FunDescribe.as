package ww599.dataStruct
{
	import ww599.consts.VarConsts;

	public class FunDescribe  extends CodeBaseDes
	{
		public function FunDescribe()
		{
			funReturn=new VarDescribe;
			funReturn.varType=VarConsts.VT_Void;
		}
		public var funName:String;
		public var funType:String;
		public var funPermission:String;
		public var funParaList:Array;
		public var funReturn:VarDescribe;
		public var funCodeBlock:CodeBlockDescribe;
		
		public function getFunText():String
		{
			return funPermission+" function "+funName+"("+getParamText()+"):"+funReturn.varType+funCodeBlock.getBlockText();
		}
		public function getParamText():String
		{
			if(!funParaList||funParaList.length<1) return"";
			var rst:String;
			var tPara:VarDescribe;
			tPara=funParaList[0];
			rst=tPara.getVarParamText();
			if(funParaList.length==1)
			{
			  return rst;	
			}
			var i:int;
			var len:int;
			len=funParaList.length;
			for(i=1;i<len;i++)
			{
				tPara=funParaList[i];
				rst+=","+tPara.getVarParamText();
			}
			return rst;
		}
	}
}