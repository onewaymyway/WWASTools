package ww599.load
{
	import ww599.Tools.XML2Object;

	public class LoadTools
	{
		public function LoadTools()
		{
		}
		
		/**
		 *  
		 * @param url
		 * @param backFun
		 * 
		 * 
		 * 使用范例
		 * 	var xmlObj:Object;
			LoadTools.loadXML(url,function(rst:Object):void
			{
				xmlObj=rst;
			}
			);
		 */
		public static function loadXML(url:String,backFun:Function=null):void
		{
			var http:HTTP;
			http=new HTTP();
			http.onComplete = function (arg1:String):void
			{
				var rst:Object;
				rst=XML2Object.parse(XML(arg1));
				if(backFun!=null)
				{
					backFun(rst);
				}
			}
			http.load(url);
		}
	}
}