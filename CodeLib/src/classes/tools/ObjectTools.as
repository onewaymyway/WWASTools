package classes.tools
{
	import flash.utils.ByteArray;

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
			oData.position-0;
			return (oData.readObject());
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
				adaptFun(tObject,i);
			}
		}
		
	}
}