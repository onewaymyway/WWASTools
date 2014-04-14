package ww599.dataStruct
{
	import ww599.Tools.ClassAnalyser;
	import ww599.consts.PermissionConst;
	import ww599.consts.VarConsts;

	public class VarDescribe  extends CodeBaseDes
	{
		public function VarDescribe(varName:String="")
		{
			this.varName=varName;
			varPermission=PermissionConst.P_PUBLIC;
		}
		public var varName:String;
		public var varType:String; 
		public var varClass:String;
		public var varPermission:String;
		
		public function getVarDefineText():String
		{
			var rst:String;
			rst=varPermission+" var "+varName+":"+varClass+";";
			return rst;
		}
		
		public function getVarParamText():String
		{
			var rst:String;
			rst=varName+":"+varClass;
			return rst;
		}
		public static function parseValue(tVar:*,varName:String):VarDescribe
		{
			if(!tVar) return null;
			var varDes:VarDescribe;
			varDes=new VarDescribe(varName);
			if(tVar is Array)
			{
				varDes.varClass=VarConsts.VT_ARRAY;
				varDes.varType=VarConsts.VT_ARRAY;
				return varDes;
			}
			if(tVar is Number)
			{
				varDes.varClass=VarConsts.VT_NUMBER;
				varDes.varType=VarConsts.VT_NUMBER;
				return varDes;
			}
			
			if(tVar is String)
			{
				varDes.varClass=VarConsts.VT_STRING;
				varDes.varType=VarConsts.VT_STRING;
				return varDes;
			}
			
            if(tVar is Function)
			{
				varDes.varClass=VarConsts.VT_FUNCTION;
				varDes.varType=VarConsts.VT_FUNCTION;
				return varDes;
			}
			
			if(tVar is Class)
			{
				varDes.varClass=VarConsts.VT_CLASS;
				varDes.varType=VarConsts.VT_CLASS;
				return varDes;
			}
			varDes.varClass=ClassAnalyser.getClassName(tVar)
			varDes.varType=varDes.varClass;
			return varDes;
		
		}
	}
}