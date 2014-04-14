package ww599.Tools
{
	import flash.utils.ByteArray;
	
	import ww599.dataStruct.VarDescribe;

	public class ObjectTools
	{
		public function ObjectTools()
		{
		}
		
		/**
		 * 深拷贝object 
		 * @param source
		 * @return 
		 * 
		 */
		public static function clone(source:Object):*
		{
			var oData:ByteArray=new ByteArray();
			oData.writeObject(source);
			oData.position=0;
			return (oData.readObject());
		}
		
		/**
		 * 从一个对象中拷贝属性到另一个对象 
		 * @param destObj
		 * @param srcObj
		 * 
		 */
		public static function copyValues(destObj:Object,srcObj:Object):void
		{
			var value:String;
			for(value in srcObj)
			{
				if(destObj.hasOwnProperty(value))
				{
					destObj[value]=srcObj[value];
				}
			}
		}
		
		/**
		 * 修改数组中的元素 
		 * @param objectList
		 * @param adaptFun  fun(object:Object,index:int)
		 * 
		 */
		public static function adaptObjectList(objectList:Array,adaptFun:Function=null):void
		{
			if(null==adaptFun) return;
			var i:int;
			var len:int;
			len=objectList.length;
			var tObject:Object;
			for(i=0;i<len;i++)
			{
				tObject=objectList[i];
				if(!tObject) continue;
				switch(adaptFun.length)
				{
					case 1:
						adaptFun(tObject);
						break;
					case 2:
						adaptFun(tObject,i);
						break;
				}
				
			}
		}
		
		/**
		 * 根据object数组生成bean数组 
		 * @param objectList
		 * @param beanClass
		 * 
		 */
		public static function getBeanListFromObjectList(objectList:Array,beanClass:Class):Array
		{
			var i:int;
			var len:int;
			var beanList:Array;
			var tObject:Array;
			var tBean:*;
			beanList=[];
			len=objectList.length;
			for(i=0;i<len;i++)
			{
				tObject=objectList[i];
				tBean=new beanClass;
				copyValues(tBean,tObject);
				beanList.push(tBean);
			}
			return beanList;
		}
		
		/**
		 * 从object中解析出属性列表 
		 * @param resObject
		 * @return varDesList
		 * 
		 */
		public static function getVarDesListFromObject(resObject:Object):Array
		{
			var tVarName:String;
			var tVarDes:VarDescribe;
			var varDesList:Array=[];
			for(tVarName in resObject)
			{
			   tVarDes=VarDescribe.parseValue(resObject[tVarName],tVarName);
			   if(tVarDes)
			   {
				   varDesList.push(tVarDes);
			   }
			}
			return varDesList;
		}
	}
}