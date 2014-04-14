package classes.tools.parser
{
	import classes.consts.CommonConsts;
	import classes.tools.StringTool;
	
	import org.osmf.net.StreamingURLResource;

	public class CommonParser
	{
		public function CommonParser()
		{
		}
		public var desStruct:Object;
		public var parentO:Object;
		public var sign:String;
		public var name:String;
		public var sSign:String;
		public var desList:Array;
		public var type:String;
		public var stype:String;
		public var dataO:*;
		public function setDesStruct(desStructO:Object):void
		{
			desStruct=desStructO;
			sign=desStruct["sign"];
			name=desStruct["name"];
			sSign=desStruct["sSign"];
			desList=desStruct["desList"];
			type=desStruct["type"];
			stype=desStruct["stype"];

		}
		public function parseData(data:String,pObject:Object):void
		{
			this.parentO=pObject;
			var tmpName:String;
			if(this.stype==CommonConsts.TYPE_SIGNARR)
			{
				tmpName=desStruct["name"];
				name=desStruct["nameS"]=tmpName+StringTool.readInt(data);
			}
			if(this.sign==CommonConsts.TYPE_NUMBER)
			{
				dataO=parse(data,desStruct);
				pObject[dataO.id]=dataO;
			}else
			{
				dataO=parse(data,desStruct,pObject);
			}
		}
		
		/**
		 * 解析数据 
		 * @param data 当前使用的字符串
		 * @param tDes 当前使用的结构描述
		 * @param tPObject 当前要加属性的对象
		 * @return 
		 * 
		 */
		private function parse(data:String,tDes:Object,tPObject:Object=null):*
		{
			if(!data||data.length<1) return null;
			var tType:String;
			var tsType:String;
			var tSSign:String;
			var tName:String;
			var tDesList:Array;
			var tArr:Array;
			var tResult:*;
			var isSelf:Boolean=false;
			tName=tDes["name"];
			if(tDes.hasOwnProperty("nameS"))
			{
				tName=tDes["nameS"];
			}
			tType=tDes["type"];
			tsType=tDes["stype"];
			tSSign=tDes["sSign"];
			tDesList=tDes["desList"];
			tArr=data.split(tSSign);
			if(tName==CommonConsts.TYPE_TYPESIGN) return null;
			if(tName==CommonConsts.TYPE_SELF)
			{
				tName=name;
				tResult=tPObject;
				isSelf=true;
				if(tType==CommonConsts.TYPE_DATA)
				{
					tPObject=data;
					return data;
				}
			}else
			{
				
			}
			
			if(tName==CommonConsts.TYPE_TYPESIGN) return null;		

			switch(tType)
			{
				case CommonConsts.TYPE_DATA:
					if(tPObject)
					{
						tPObject[tName]=data;
					}									
					return data;
					break;
				case CommonConsts.TYPE_ARRAY:

					tResult=parseArray();
					
					if(tPObject)
					{
						if(isSelf)
						{
							tPObject=tResult;
						}else
						{
							tPObject[tName]=tResult;
						}
						
					}	
					return tResult;
					break;
				case CommonConsts.TYPE_STRUCT:
					tResult=parseStruct();
					if(tPObject)
					{
						if(isSelf)
						{
							tPObject=tResult;
						}else
						{
							tPObject[tName]=tResult;
						}
						
					}	
					return tResult;
					break;
			}
			
			
			return null;
			function parseStruct():Object
			{
				var tPDes:Object;
				var tData:String;
				var i:int;
				var len:int;
				var data:*;
				var tResult:Object={};
				var ttName:String;
				len=tDesList.length;
                if((tsType==CommonConsts.TYPE_SMARTSPLIT)&&(tArr.length>tDesList.length))
				{
					adaptDataArr();
				}
				for(i=0;i<len;i++)
				{
					tData=tArr[i];
					tPDes=tDesList[i];
					if((!tData)||(!tPDes)) continue;
					data=parse(tData,tPDes);
					ttName=tPDes["name"];
					if(ttName==CommonConsts.TYPE_TYPESIGN) continue;
					if(ttName==CommonConsts.TYPE_SELF)
					{
						if(tResult.hasOwnProperty("id"))
						{
							data.id=tResult.id;
						}
						tResult=data;
					}
					else
					{
						tResult[ttName]=data;
					}
				}
				return tResult;
			}
			function adaptDataArr():void
			{
				var s:int;
				var e:int;
				var tmpArr:Array;
				var tStr:String;
				e=tArr.length;
				s=tDesList.length-1;
				tmpArr=tArr.slice(s,e);
				tStr=tmpArr.join(tSSign);
				tArr[s]=tStr;
			}
			function parseArray():Array
			{
				var tPDes:Object;
				var tData:String;
				var i:int;
				var len:int;
				var tResult:Array=[];
				tPDes=tDesList[0];
				len=tArr.length;
				for(i=0;i<len;i++)
				{
					tData=tArr[i];
					if((!tData)||(!tPDes)) continue;
					tResult.push(parse(tData,tPDes));
				}
				return tResult;
			}
			function getDesName(desO:Object):String
			{
				var rst:String;
				rst=desO["name"];
				switch(rst)
				{
					case CommonConsts.TYPE_SELF:
						rst=name;
						break;
					case CommonConsts.TYPE_TYPESIGN:
						break;
					default:
				}
				return rst;
			}
		}

	}
}