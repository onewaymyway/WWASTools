package ww599.dataStruct
{
	public class XMLObject
	{
		public function XMLObject(data:Object,name:String,depth:int=0)
		{
			initData(data,name,depth);
		}
		public var name:String;
		public var items:Object;
		public var depth:int=0;
		public function initData(data:Object,name:String,depth:int=0):void
		{
			this.name=name;
			this.depth=depth;
			items={};
			if(isBasic(data)) 
			{
				items=String(data);	
			}
			
			items=data;
		}
		
		public static function isBasic(data:Object):Boolean
		{
			if(data is Number) return true;
			if(data is String) return true;
			return false;
		}
		private function writeFormatLine(str:String):String
		{
			return getEmpty(this.depth)+str+"\n";
		}
		private function writeFormatLineNoEnter(str:String):String
		{
			return getEmpty(this.depth)+str;
		}
		public function writeXML():String
		{
		    if(isBasic(items)) return writeBasic();
			
			if(items is Array) return writeArray();
			
			return writeObject();
		}
		
		private function writeBasic():String
		{
			var rst:String;
			rst="<"+name+">"+"\""+items+"\""+"</"+name+">";
			
			return writeFormatLine(rst);
		}
		public function writeBasicProperty():String
		{
			var rst:String;
			rst=" "+name+"="+"\""+items+"\"";
			
			return rst;
		}
        private function getEmpty(len:int):String
		{
		   var rst:String;
		   len*=2;
		   rst="";
		   while(len>0)
		   {
			   rst+=" ";
			   len--;
		   }
		   return rst;
		}
		private function writeArray():String
		{
			var rst:String;
			
			rst="";
			var i:int;
			var len:int;
			var tItem:Object;
			var tArr:Array;
			var tXmlO:XMLObject;
			tArr=items as Array;
			len=tArr.length;
			for(i=0;i<len;i++)
			{
				tItem=tArr[i];
				tXmlO=new XMLObject(tItem,name,depth+1);
				rst+=tXmlO.writeXML();
			}
			
			return rst;
		}
		
		private function writeObject():String
		{
			
			if(isAllBasic()) return writeBasicObject();
			var rst:String;
			rst="";
			rst+=writeFormatLine("<"+name +""+writeBasicChilds()+">");
			
			var property:String;
			var tItem:Object;
			var tXmlO:XMLObject;
			for(property in items)
			{
				tItem=items[property];
				if(isBasic(tItem)) continue;
				tXmlO=new XMLObject(tItem,property,depth+1);
				
				if(tXmlO.isAllBasic()||(tItem is Array)) 
				{
					rst+=tXmlO.writeXML();
				}else
				{
					rst+="\n"+tXmlO.writeXML()+"\n";
				}
	
			}
			
			rst+=writeFormatLine("</"+name +">");
			return rst;
		}
		private function writeBasicObject():String
		{
			var rst:String;
			rst=writeFormatLine("<"+name +""+writeBasicChilds()+"/>");
			return rst;
		}
		private function isAllBasic():Boolean
		{
			
			var property:String;
			var tItem:Object;
			var tXmlO:XMLObject;
			for(property in items)
			{
				tItem=items[property];
				if(!isBasic(tItem)) return false;

			}
			return true;
		}
		private function writeBasicChilds():String
		{
			var rst:String;
			rst="";
			
			var property:String;
			var tItem:Object;
			var tXmlO:XMLObject;
			for(property in items)
			{
				tItem=items[property];
				if(!isBasic(tItem)) continue;
				tXmlO=new XMLObject(tItem,property,depth+1);
				rst+=tXmlO.writeBasicProperty();
			}
			return rst;
		}
		
	}
}