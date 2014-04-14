package classes.tools
{

	
	import classes.dataStruct.ProtocalDescribe;
	import classes.dataStruct.dataItem;
	
	import flash.text.TextField;
	
	import org.osmf.net.StreamingURLResource;

	/**
	 * 协议文件分析类
	 * 用于分析文本形式的协议文件
	 * 并创建与通信协议相关的类文件
	 * @author ww
	 * 
	 */
	public class FileAnalyser
	{
		
		/**
		 * 协议开始标志
		 */
		public static const LINETYPE_PROTOCALBEGIN:String="###";
		/**
		 * 协议号标志
		 */
		public static const LINETYPE_PROTOCALNUM:String="协议号";
		/**
		 * 客户端请求标志
		 */
		public static const LINETYPE_PROTOCALREQUESTBEGIN:String="c >> s:";
		/**
		 * 服务器回复标志
		 */
		public static const LINETYPE_PROTOCALREPONSEBEGIN:String="s >> c:";
		/**
		 * int标志
		 */
		public static const LINETYPE_INT:String="int:32";
		/**
		 * long int标志
		 */
		public static const LINETYPE_LONG:String="int:64";
		/**
		 * byte标志
		 */
		public static const LINETYPE_BYTE:String="int:8";
		/**
		 * 字符串标志
		 */
		public static const LINETYPE_STRING :String="str";
		/**
		 * array长度标志
		 */
		public static const LINETYPE_INT16:String="int:16";
		/**
		 * 数组开头标志
		 */
		public static const LINETYPE_ARRAYBEGIN :String="(";
		/**
		 * 数组结束标志
		 */
		public static const LINETYPE_ARRAYEND :String=")";
		
		
		/**
		 * 协议通信中的元数据 
		 */
		public static const ItemDic:Object=
			{
				"int:32":"IntUtil",
				"int:64":"LongUtil",
				"int:8":"ByteUtil",
				"str":"StringUtil",
				"int:16":"ShortUtil"
			}
		public static const ItemToASDic:Object=
			{
				"int:32":"int",
				"int:64":"Number",
				"int:8":"int",
				"str":"String",
				"(":"Array",
				"int:16":"int"
			}
		/**
		 * 分析协议时要考虑的关键词 
		 */
		public static const protocalItemList:Array=[
			LINETYPE_PROTOCALBEGIN,
			LINETYPE_PROTOCALNUM,
			LINETYPE_PROTOCALREQUESTBEGIN,
			LINETYPE_PROTOCALREPONSEBEGIN,
			LINETYPE_INT,
			LINETYPE_LONG,
			LINETYPE_BYTE,
			LINETYPE_STRING,
			LINETYPE_INT16,
			LINETYPE_ARRAYBEGIN,
			LINETYPE_ARRAYEND
];
		
		public var protocalArray:Array;
		public function FileAnalyser()
		{
			txtField=new TextField();
		}
		public var txtField:TextField;
		public var tLine:int;
		public function setContent(txt:String):void
		{
			txtField.text=txt;
			txtField.wordWrap=false;
			tLine=0;
		}
		
		
		/**
		 * 让每个协议创建解码用的字典文件 
		 * 
		 */
		public function createProtocalDecodeDic():void
		{
			var i:int;
			var len:int;
			len=protocalArray.length;
			
			var tProtocal:ProtocalDescribe;
			for(i=0;i<len;i++)
			{
				tProtocal=protocalArray[i] as ProtocalDescribe;
				tProtocal.getResponseDecoderLib();
			}
		}
		/**
		 * 获取某行的文本
		 * @param line
		 * @return 
		 * 
		 */
		public function getLineTxt(line:int):String
		{
			return txtField.getLineText(line);
		}
		
		/**
		 * 获取行数
		 * @return 
		 * 
		 */
		public function getLineCount():int
		{
			return txtField.numLines;
		}

		
		public function getAProtocal():String
		{
			
			return "";
		}
		
		/**
		 * 获取某行的文本类型 
		 * @param lineNum
		 * @return 
		 * 
		 */
		public function getLineType(lineNum:int):String
		{
			var tLine:String;
			tLine=getLineTxt(lineNum);
			
			var i:int;
			var len:int;
			var tType:String;
			len=protocalItemList.length;
			for(i=0;i<len;i++)
			{
				tType=protocalItemList[i];
				if(tLine.indexOf(tType)>=0)
				{
					return tType;
				}
			}
			return "empty";
		}
		public function parseLine(lineNum:int):String
		{
			var tLine:String;
			tLine=getLineTxt(lineNum);
			
			trace("line:"+lineNum+" "+tLine);
			if(tLine.length>0)
			{
				//var txtArr:Array;
				//txtArr=tLine.split(" ");
				//trace("line:"+lineNum+" itemNum:"+txtArr.length);
				//showArray(txtArr);
				var tType:String;
				tType=getLineType(lineNum);
				trace("line:"+lineNum+" lineType:"+getLineType(lineNum));
				if(tType==LINETYPE_PROTOCALBEGIN)
				{
					trace("protocalName:"+getProtocalName(tLine));
				}
			}
			else
			{
				trace("line:"+lineNum+" is empty");
			}
			return tLine;
		}
		
		/**
		 * 获取协议名文本行中的协议名 
		 * @param str
		 * @return 
		 * 
		 */
		public function getProtocalName(str:String):String
		{
			var rst:String;
			rst=getReplace(str,"#","");
			rst=getReplace(rst,"\r","");
			return rst;
		}
		/**
		 * 获取协议号问本行中的协议号 
		 * @param str
		 * @return 
		 * 
		 */
		public function getProtocalNum(str:String):String
		{
			var rst:String;
			rst=trim(str);
			rst=rst.substr(4);
			//return getReplace(str,LINETYPE_PROTOCALNUM,"");
			return rst;
		}
		public function trim(str:String):String
		{
			var rst:String;
			rst=getReplace(str," ","");
			rst=getReplace(rst,"\r","");
			return rst;
		}
		public function getReplace(str:String,oStr:String,nStr:String):String
		{
			var rst:String;
			rst=str.replace(new RegExp(oStr, "g"),nStr);
			return rst;
		}
		public var status:String;
		
		/**
		 * 
		 */
		public static const STATUS_FINDPROTOCALBEGIN:String="status_findBegin";
		/**
		 * 解析协议文件 
		 * 
		 */
		public function parseProtocalFile():void
		{
			protocalArray=[];
			var len:int;
			len=getLineCount();
			var tProtocal:ProtocalDescribe;
			var tLineType:String;
			var tLineTxt:String;
			var tArray:Array;
			var tValueArray:Array;
			var workArrayList:Array;
			var tWorkArray:Array;
			var tData:dataItem;
			workArrayList=[];
			while(tLine<len)
			{
				tLineType=getLineType(tLine);
				tLineTxt=getLineTxt(tLine);
//				trace(tLineTxt+":"+tLineType);
				switch(tLineType)
				{
					case LINETYPE_PROTOCALBEGIN:
						tProtocal=new ProtocalDescribe();
						protocalArray.push(tProtocal);
						tProtocal.protocalName=getProtocalName(tLineTxt);
						tProtocal.protocalFunName=getDataName(tProtocal.protocalName);
						tProtocal.protocalDesInfo=tLineTxt;
						break;
					case LINETYPE_PROTOCALNUM:
						var protocalNum:int;
						protocalNum=Number(getProtocalNum(tLineTxt));
						tProtocal.moduleID=int(protocalNum/1000);
						tProtocal.actionID=protocalNum%1000;
						tProtocal.protocalDesInfo+=tLineTxt;
						break;
					case LINETYPE_PROTOCALREQUESTBEGIN:
						tWorkArray=tProtocal.request;
						workArrayList.length=0;
						workArrayList.push(tWorkArray);
						tProtocal.protocalDesInfo+=tLineTxt;
						break;
					case LINETYPE_PROTOCALREPONSEBEGIN:
						tWorkArray=tProtocal.response;
						workArrayList.length=0;
						workArrayList.push(tWorkArray);
						tProtocal.protocalDesInfo+=tLineTxt;
						break;
					case LINETYPE_INT:
						//tData.data=LINETYPE_INT;
						
						//tWorkArray.push(LINETYPE_INT);
						pushData(tLineType,tLineType);
						break;
					case LINETYPE_LONG:
						//tData.data=LINETYPE_INT;
						
						//tWorkArray.push(LINETYPE_INT);
						pushData(tLineType,tLineType);
						break;
					case LINETYPE_BYTE:
						//tWorkArray.push(LINETYPE_BYTE);
						pushData(tLineType,tLineType);
						break;
					case LINETYPE_STRING:
						//tWorkArray.push(LINETYPE_STRING);
						pushData(tLineType,tLineType);
						break;
					case LINETYPE_INT16:
						//tWorkArray.push(LINETYPE_INT16);
						//pushData(tLineType,tLineType);
						if(getDataName(tLineTxt).length>=2)
						{
							pushData(tLineType,tLineType);
						}
						break;
					case LINETYPE_ARRAYBEGIN :
						
					    var newArray:Array;
						newArray=[];
						//tWorkArray.push(newArray);
						
						workArrayList.push(newArray);
						pushData(tLineType,newArray);
						tWorkArray=newArray;
						break;
					case LINETYPE_ARRAYEND:
						workArrayList.pop();
						tWorkArray=workArrayList[workArrayList.length-1];
						tProtocal.protocalDesInfo+=tLineTxt;
						break;
					default:
//						trace("wrong line:"+tLineTxt+":"+tLineType);
					
				}
				/**
				 * 向array中添加通信元素
				 * @param dataType
				 * @param data
				 * 
				 */
				function pushData(dataType:String,data:*):void
				{
					tData=new dataItem();
					tData.data=data;
					tData.dataName=getDataName(tLineTxt);
					tData.dataType=dataType;
					tProtocal.protocalDesInfo+=tLineTxt;
					trace("pushData:"+tLineTxt);
					tWorkArray.push(tData);
					
				}
				/**
				 * 获取当前元素的英文名
				 * @param tLineTxt
				 * @return 
				 * 
				 */
				function getDataName(tLineTxt:String):String
				{
					var rst:String;
					var i:int;
					i=tLineTxt.indexOf("@");
					if(i>=0) 
					{
						rst=tLineTxt.substr(i+1);
						return trim(rst);
					}
					else
					{
						return "";
					}
				}
				tLine++;
			}
			
			createProtocalDecodeDic();
		}
		
		/**
		 * 解码通信数据到Struct格式 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function parseProtocalArray(arr:Array):String
		{
			var rst:String;
			rst="[{items}]".replace(new RegExp("\\{items\\}", "g"),  getArrayItems(arr));
			return rst;
		}
		/**
		 * 获取通信Array中的数据元素代表的字符串
		 * @param arr
		 * @return 
		 * 
		 */
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
		
		/**
		 * 解析返回通信元素代表的字符串
		 * @param item
		 * @return 
		 * 
		 */
		public static function parseItem(item:*):String
		{
			var rst:String;
			if(item is dataItem)
			{
				var tDataItem:dataItem;
				tDataItem=item as dataItem;
				if(tDataItem.data is Array)
				{
					return parseProtocalArray(tDataItem.data as Array);
				}
				else
				{
					rst=(item as dataItem).data;
					rst=ItemDic[rst];
					return rst;
				}
				
			}else
			{
				if(item is Array)
				{
					return parseProtocalArray(item as Array);
				}
			}
			return "";
		}
		/**
		 * 测试用 
		 * @param arr
		 * 
		 */
		public function showArray(arr:Array):void
		{
			var i:int;
			var len:int;
			len=arr.length;
			for(i=0;i<len;i++)
			{
				trace(arr[i]);
			}
		}
	}
}