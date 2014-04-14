package classes.tools
{
	import com.adobe.serialization.json.JSON;

	/**
	 * 一些字符串操作函数
	 * @author ww
	 * 
	 */
	public class StringTool
	{
		public function StringTool()
		{
		}
		
		/**
		 * 返回全大写 
		 * @param str
		 * @return 
		 * 
		 */
		public static function toUpCase(str:String):String
		{
			return str.toUpperCase();
		}
		
		/**
		 * 返回全小写 
		 * @param str
		 * @return 
		 * 
		 */
		public static function toLowCase(str:String):String
		{
			return str.toLowerCase();
		}
		/**
		 * 返回首字母大写 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function toUpHead(str:String):String
		{
			var rst:String;
			if(str.length<=1) return str.toUpperCase();
			rst=str.charAt(0).toUpperCase()+str.substr(1);
			return rst;
		}
		
		/**
		 * 返回首字母小写 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function toLowHead(str:String):String
		{
			var rst:String;
			if(str.length<=1) return str.toLowerCase();
			rst=str.charAt(0).toLowerCase()+str.substr(1);
			return rst;
		}
		
		
		/**
		 * 包名转路径名 
		 * @param packageName
		 * @return 
		 * 
		 */
		public static function packageToFolderPath(packageName:String):String
		{
			var rst:String;
			rst=packageName.replace(".","/");
			return rst;
		}
		
		/**
		 * 去除空格和换行符
		 * @param str
		 * @return 
		 * 
		 */
		public static function trim(str:String):String
		{
			var rst:String;
			rst=getReplace(str," ","");
			rst=getReplace(rst,"\r","");
			return rst;
		}
		
		/**
		 * 替换文本 
		 * @param str
		 * @param oStr
		 * @param nStr
		 * @return 
		 * 
		 */
		public static function getReplace(str:String,oStr:String,nStr:String):String
		{
			var rst:String;
			rst=str.replace(new RegExp(oStr, "g"),nStr);
			return rst;
		}
		
		
		/**
		 * 将Array转成字符串
		 * @param arr
		 * @return 
		 * 
		 */
		public static function ArrayToString(arr:Array):String
		{
			var rst:String;
			rst="[{items}]".replace(new RegExp("\\{items\\}", "g"),  getArrayItems(arr));
			return rst;
		}

		public static function getArrayItems(arr:Array):String
		{
			var rst:String;
			
			if(arr.length<1) return "";
			rst=parseItem(arr[0]);
			
			var i:int;
			var len:int;
			len=arr.length;
			for(i=1;i<len;i++)
			{
				rst+=","+parseItem(arr[i]);
			}
			
			
			return rst;
		}
		public static function parseItem(item:*):String
		{
			var rst:String;
			rst="\""+item+"\"";
			return "";
		}
	    
		/**
		 * 返回对象的JSon字符串 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getJSONString(obj:Object):String
		{
			return com.adobe.serialization.json.JSON.encode(obj);
		}
		
		/**
		 * 返回json字符串表示的对象 
		 * @param jsonString
		 * @return 
		 * 
		 */
		public static function getJSONObject(jsonString:String):Object
		{
			return com.adobe.serialization.json.JSON.decode(jsonString);
		}
	}
}