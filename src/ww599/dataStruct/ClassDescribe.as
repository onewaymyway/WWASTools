package ww599.dataStruct
{
	import ww599.Tools.ObjectTools;

	public class ClassDescribe extends CodeBaseDes
	{
		public function ClassDescribe()
		{
			funList=[];
			varList=[];
		}
		
		public var className:String;
		public var packageName:String;
		public var funList:Array;
		public var varList:Array;
		
		public function addFun(fun:FunDescribe):void
		{
			funList.push(fun);
		}
		public function addValue(value:VarDescribe):void
		{
			varList.push(value);
		}
		
		public function getClassText():void
		{
			
		}
		
		public function getValueDefineText():void
		{
			
		}
		public function getFunDefineText():void
		{
			
		}
		
		public function parseClass(tObject:Object):ClassDescribe
		{
			if(!tObject) return null;
			var clsDes:ClassDescribe;
			clsDes=new ClassDescribe;
			clsDes.varList=ObjectTools.getVarDesListFromObject(tObject);
			return clsDes;
		}
	}
}