package classes.tools
{
	/**
	 * Array操作相关的一些函数
	 * @author ww
	 * 
	 */
	public class ArrayTool
	{
		public function ArrayTool()
		{
		}
		
		/**
		 * 合并两个数组
		 * @param oArr
		 * @param aArr
		 * 
		 */
		public static function addDistictArray(oArr:Array,aArr:Array):void
		{
			var i:int;
			var len :int;
			len=aArr.length;
			
			for(i=0;i<len;i++)
			{
				addDistictItem(oArr,aArr[i]);
			}
		}
		
		/**
		 * 向数组加入一个唯一的元素
		 * @param oArr
		 * @param item
		 * 
		 */
		public static function addDistictItem(oArr:Array,item:*):void
		{
			if(isDistict(oArr,item))
			{
				oArr.push(item);
			}
		}
		/**
		 * 判断是否是新的 
		 * @param oArr
		 * @param item
		 * @return 
		 * 
		 */
		public static function isDistict(oArr:Array,item:*):Boolean
		{
			var i:int;
			var len :int;
			len=oArr.length;
			
			for(i=0;i<len;i++)
			{
				if(oArr[i]==item)
				{
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * 返回数组中的随机一个元素 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function getRandom(arr:Array):*
		{
			if(!arr) return null;
			var i:int;
			i=int(Math.random()*100000)%arr.length;
			return arr[i];
		}
	}
}