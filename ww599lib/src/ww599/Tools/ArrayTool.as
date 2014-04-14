package ww599.Tools
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
		 * 填充数组 到指定长度，超长不删
		 * @param oArr 目标数组
		 * @param len 目标长度
		 * @param data 填充的数据
		 * @param clone 是否使用深拷贝
		 * 
		 */
		public static function fillArray(oArr:Array,len:int,data:*,clone:Boolean=false):void
		{
			if(clone)
			{
				while(oArr.length<len)
				{
					oArr.push(ObjectTools.clone(data));
				}
			}else
			{
				while(oArr.length<len)
				{
					oArr.push(data);
				}
			}
			
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
			
//			DebugTools.traceObj(oArr,"before addDistinctItem arr:");
//			DebugTools.traceObj(item,"addDistinctItem item:");
			if(isDistict(oArr,item))
			{
				oArr.push(item);
			}
//			DebugTools.traceObj(oArr,"after addDistinctItem arr:");
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
				if(item is Object && (item as Object).hasOwnProperty("id"))
				{
					
					if(item.id==oArr[i].id)
					{
						return false;
					}
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
		
		private static const monsterSighList:Array=["PiaoQiNan","PiaoQiNv","ShenWuNan","ShenWuNv","YuLinNan","YuLinNv"];
		
		/**
		 * 获取随机的Sign标志 
		 * 
		 */
		public static function getRandomSign():String
		{
			return getRandom(monsterSighList);
		}
		
	}
}