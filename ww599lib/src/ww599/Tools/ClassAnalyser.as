package ww599.Tools
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.NameUtil;
	

	/**
	 * 显示对象分析工具
	 * @author ww
	 * 
	 */
	public class ClassAnalyser
	{
		public function ClassAnalyser()
		{
		}
		/**
		 * 获取显示对象无路径类名 
		 * @param dis 显示对象
		 * @return 类名
		 * 
		 */
		public static function getClassName(dis:DisplayObject):String
		{
			var myName:String;
			myName=mx.utils.NameUtil.getUnqualifiedClassName(dis);;
			//trace("className:"+myName);
			return myName;
		}
		/**
		 * 获取显示对象的全路径类名  
		 * @param dis 显示对象
		 * @return 类似 packaage::className 格式
		 * 
		 */
		public static function getFullClassName(dis:DisplayObject):String
		{
			var myName:String;
			myName=flash.utils.getQualifiedClassName(dis);
			//trace("classFullName:"+myName);
		//	myName=mx.utils.NameUtil.getUnqualifiedClassName(dis);
			//mx.utils.NameUtil.getUnqualifiedClassName(dis);
			
			//trace("classFullName:"+myName);
			return myName;
		}

		/**
		 * 根据类获取类名 
		 * @param cla
		 * @return 
		 * 
		 */
		public static function getClassNameByClass(cla:Class):String
		{
			var tO:*;
			tO=new cla;
			return getClassName(tO);
		}
		
		/**
		 * 获取显示对象是否已命名 
		 * @param dis
		 * @return 
		 * 
		 */
		public static function isNamed(dis:DisplayObject):Boolean
		{
			if(!dis) return false;
			if(dis.name.indexOf("instance")>=0) return false;
			return true;
		}
		
		/**
		 * 判断是否是按钮
		 * @param dis
		 * @return 
		 * 
		 */
		public static function isButton(dis:DisplayObject):Boolean
		{
			if(!dis) return false;
			if(dis.name.indexOf("Btn")>=0) 
			{
//				CreateFunLib.tClassDs.addBtn(dis);
				return true;
			}
			return false;
		}
		
		/**
		 * 获取按钮的名字
		 * @param dis
		 * @return 
		 * 
		 */
		public static function getButtonName(dis:DisplayObject):String
		{
			if(!isButton(dis)) return "";
			var i:int;
			var rst:String;
			i=dis.name.indexOf("Btn");
			rst=dis.name.substr(0,i);
			return rst;
		}
		
		/**
		 * 获取按钮的事件名
		 * @param dis
		 * @return 
		 * 
		 */
		public static function getButtonEventName(dis:DisplayObject):String
		{
			return StringTool.toUpCase(getButtonName(dis));
		}
	}
}