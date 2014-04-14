package ww599.Tools
{
	/**
	 *  
	 * @author ww
	 * 
	 */	
	public class DebugTools
	{
		public function DebugTools()
		{
		}
		/**
		 * trace obj 对象的jsong 
		 * @param obj
		 * @param objName
		 * 
		 */
		public static function traceObj(obj:Object,objName:String="obj"):void
		{
			trace("-----------------------------");
			trace("trace obj begin:"+objName);
			trace(StringTool.getJSONString(obj));
			trace("trace obj end:"+objName);
			trace("-----------------------------");
		}
	}
}