/**
 *具有绑定图片功能的资源加载管理类
 */

package ww599.load
{
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.BinaryDataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.core.LoaderItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 封装LoaderMax的加载资源类
	 * @author unKnown
	 * 
	 */
	public class ZHLoader
	{
		private var urls:Object = LoaderUrl.urls;
		private var context:LoaderContext;
		
		private static var allowInstance:Boolean;
		private static var instance:ZHLoader;
		
		public function ZHLoader()
		{
			if(!allowInstance) 
				throw new Error("只能用 getInstance");
			context = new LoaderContext(true,ApplicationDomain.currentDomain)
		}
		
		public static function getInstance():ZHLoader
		{
			if(instance == null)
			{
				allowInstance = true;
				instance = new ZHLoader();
				allowInstance = false;
			}
			return instance;
		}

		/**
		 * 加载图片
		 * @param name
		 * 图片的名字
		 * @param url
		 * 图片的地址
		 * @param onCompleteHandler
		 * 加载完成后的回调方法
		 * @param container
		 * 父容器
		 * @param posArr
		 * 坐标X,Y
		 * @param onProgressHandler
		 * @param estimatedBytes
		 * @param repeat
		 * 
		 */		
		public function loadImage(name:String,url:String,onCompleteHandler:Function = null,container:DisplayObject = null,posArr:Array = null, onProgressHandler:Function = null,estimatedBytes:uint = 0,repeat:Boolean = true,autoDispose:Boolean = true):void
		{
			var vars:Object = new Object();
			vars.name = name;
			vars.crop = true;
			vars.autoDispose = autoDispose;
			if(onProgressHandler != null)
				vars.onProgress = onProgressHandler;
			if(onCompleteHandler != null)
				vars.onComplete = onCompleteHandler;
			if(estimatedBytes != 0)
				vars.estimatedBytes = estimatedBytes;
			if(container != null)
				vars.container = container;
			if(posArr != null)
			{
				vars.x = posArr[0];
				vars.y = posArr[1];
			}
				
			load(2,url,vars,repeat);
		}
		
		/**
		 * 加载影片剪辑
		 * @param url
		 * @param onCompleteHandler
		 * @param onProgressHandler
		 * @param estimatedBytes
		 * 
		 */		
		public function loadMovieClip(name:String,url:String,onCompleteHandler:Function = null,onProgressHandler:Function = null,estimatedBytes:uint = 0,repeat:Boolean = false):void
		{
			var vars:Object = new Object();			
			//trace(vars.name);
			vars.name = name;
			vars.crop = true;
			vars.noCache = true;
			if(onProgressHandler != null)
				vars.onProgress = onProgressHandler;
			if(onCompleteHandler != null)
				vars.onComplete = onCompleteHandler;
			if(estimatedBytes != 0)
				vars.estimatedBytes = estimatedBytes;
			load(3,url,vars,repeat);
		}
		/**
		 *加载XML
		 * @param name
		 * @param url
		 * @param onCompleteHandler
		 * @param onProgressHandler
		 * @param estimatedBytes
		 * @param repeat
		 * 
		 */		
		public function loadXML(name:String,url:String,onCompleteHandler:Function = null,onProgressHandler:Function = null,estimatedBytes:uint = 0,repeat:Boolean = false):void
		{
			var vars:Object = new Object();			
			vars.name = name;
			if(onProgressHandler != null)
				vars.onProgress = onProgressHandler;
			if(onCompleteHandler != null)
				vars.onComplete = onCompleteHandler;
			if(estimatedBytes != 0)
				vars.estimatedBytes = estimatedBytes;
			load(1,url,vars,repeat);
		}
		
		/**
		 * 获取影片剪辑里的Bitmap
		 * @param name
		 * @return 
		 * 
		 */		
		public function getBitmap(swfName:String,bitmapClassName:String,width:int,height:int):Bitmap
		{
			var swfLoader:SWFLoader =  LoaderMax.getLoader(swfName) as SWFLoader;
			
			var BitmapDataCla:Class = swfLoader.getClass(bitmapClassName);
			
			var bitmap:Bitmap = new Bitmap(new BitmapDataCla(width,height));
			
			return bitmap;
		}
		
		/**
		 * 直接获取影片剪辑里的Bitmap
		 * @param name
		 * @return 
		 * 
		 */		
		public function getBitmapByName(className:String,width:int = 0,height:int = 0):Bitmap
		{	
			if(context.applicationDomain.hasDefinition(className))
			{
				var bmpCla:Class = context.applicationDomain.getDefinition(className) as Class;
				if(bmpCla != null)
				{
					var bmpData:BitmapData = new bmpCla();
					var bmp:Bitmap = new Bitmap(bmpData);
					bmpData = null
					return bmp;
				}
				
			}
			return null;
		}
		
		/**
		 * 获取影片剪辑里的类模板
		 * @param name
		 * @return 
		 * 
		 */		
		public function getClass(className:String):Class
		{
			var cla:Class = context.applicationDomain.getDefinition(className) as Class;
			
			return cla;
		}
		
		/**
		 * 获取外部图片 如jpg, png 等
		 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getImage(imageName:String):Bitmap
		{
			var imageLoader:ImageLoader =  LoaderMax.getLoader(imageName) as ImageLoader;
			
			return Bitmap(imageLoader.rawContent);
		}
		
		/**
		 * 从swf文件中获取图片文件 add by zhm 
		 * @param swfName
		 * @param bitmapClassName
		 * @return 
		 * 
		 */		
		public function getImageFromMc(swfName:String,bitmapClassName:String):BitmapData {
			return getBitmap(swfName,bitmapClassName,0,0).bitmapData;
		}
		
		/**
		 * 根据图片文件获取bitmapdata add by zhm 
		 * @param pngName
		 * @return 
		 * 
		 */		
		public function getBitmapDataFromPng(pngName:String):BitmapData {
			return getImage(pngName).bitmapData;
		}
		/**
		 * 从swf获取按钮 add by zhm
		 * @param swfName
		 * @param btnName
		 * @return 
		 * 
		 */		
		public function getSimpleButtonFromMc(swfName:String,btnName:String):SimpleButton {
			
			var swfLoader:SWFLoader =  LoaderMax.getLoader(swfName) as SWFLoader;
			
			var mcCla:Class = swfLoader.getClass(btnName);
			
			var mc:DisplayObject = new mcCla();
			
			if(mc is SimpleButton)
			{
				mcCla = null
				return SimpleButton(mc);	
			}
			return null;
		}
		
		
		/**
		 * 通过swf名字和子类获取影片剪辑 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getMovieClip(swfName:String,mcClassName:String):MovieClip
		{
			var swfLoader:SWFLoader =  LoaderMax.getLoader(swfName) as SWFLoader;
			
			var mcCla:Class = swfLoader.getClass(mcClassName);
			
			var mc:DisplayObject = new mcCla();
			
			if(mc is MovieClip)
			{
				mcCla = null
				return MovieClip(mc);	
			}
			return null;
		}
		/**
		 * 直接通过类名获取影片剪辑 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getMovieClipByName(className:String):MovieClip
		{
			if(className==null) return null;
			if(!context.applicationDomain.hasDefinition(className))  return null;
			var cla:Class = context.applicationDomain.getDefinition(className) as Class;
			
			if(cla != null)
			{
				var mc:DisplayObject = new cla();
				if(mc is MovieClip)
				{
					cla = null;
					return MovieClip(mc);
				}
			}
			return null;
		}
		/**
		 * 通过设置的名字获取XML 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getXMLByName(xmlName:String):XML
		{
			var xmlLoader:XMLLoader = LoaderMax.getLoader(xmlName) as XMLLoader;
			
			if(xmlLoader != null)
				return xmlLoader.content as XML;
			else
				return null;
		}
		/**
		* 通过URL地址获取二进制文件
		* @param URL
		* @return 
		* 
		*/		
		public function getBinaryByURL(URL:String):ByteArray
		{
			var xmlLoader:BinaryDataLoader = LoaderMax.getLoader(URL) as BinaryDataLoader;
			
			if(xmlLoader != null){
				var bytearray:ByteArray = xmlLoader.content as ByteArray;
				bytearray.position =0;
				return bytearray;
			}
			else
				return null;
		}
		/**
		 *通过URL地址获取JSON object
		 * @param URL
		 * @return 
		 * 
		 */		
		public function getJsonObjectByURL(URL:String):Object
		{
			var xmlLoader:BinaryDataLoader = LoaderMax.getLoader(URL) as BinaryDataLoader;
			
			if(xmlLoader != null){
				var str:String = xmlLoader.content;
				var obj:Object = JSON.parse(str);
				return obj;
				
			}
			else
				return null;
		}
		/**
		 *获得swf加载的域 
		 * @return 
		 * 
		 */		
		public function getApplicationDomain():ApplicationDomain
		{
			return context.applicationDomain;
		}
		/**
		 *同一时间加载多个资源时候保存加载信息 
		 */		
		private var paraList:Object = new Object();
		
		private var loader:LoaderItem;
		/**
		 *  
		 * @param resType 1:多个加载（各种类型） 2. 加载图片 3. 加载影片剪辑
		 * @param repeat 是否重复加载内容
		 */		
		private function load(resType:int,url:String,para:Object,repeat:Boolean = false):void
		{	
			if(!repeat)
			{
				//trace(para.name);
				
				if(urls[url])
				{
					//trace(LoaderMax.getLoader(urls[url]));
					var LI:LoaderCore = LoaderMax.getLoader(urls[url]) as LoaderCore;
					if(LI == null)
					{
						delete urls.url;
					}else
					{
						if(LI.status == LoaderStatus.COMPLETED)
						{
							if(para.onComplete != null)
								para.onComplete(new LoaderEvent(LoaderEvent.COMPLETE,LI));
						}else{
							if(paraList[urls[url]])
							{
								(paraList[urls[url]] as Array).push(para);
							}else{
								var arr:Array = new Array();
								arr.push(para);
								paraList[urls[url]] = arr;
								LI.addEventListener(LoaderEvent.COMPLETE,loaderCP);
							}
						}
						return;
					}
					
				}
				urls[url] = url;
			}
//			var loader:LoaderItem;
			para.context = context;
			if(resType == 1)
			{
				loader = new XMLLoader(url,para);
			}else if(resType == 2)
			{
				loader = new ImageLoader(url,para);
			}else if(resType == 3)
			{
				loader = new SWFLoader(url,para);
			}
			loader.load();
		}
		
		private function loaderCP(e:LoaderEvent):void
		{
			var arr:Array = paraList[(e.target as LoaderItem).url];
			for each(var o:Object in arr)
			{
				if(o.onComplete != null)
					o.onComplete(new LoaderEvent(LoaderEvent.COMPLETE,e.target));
				if(o.container != null && e.target is ImageLoader)
				{
					var bit:Bitmap = Bitmap(e.target.rawContent);
					o.container.addChild(bit);
					if(o.x)
						bit.x = o.x;
					if(o.y)
						bit.y = o.y;
				}
					
					
					
			}
			paraList[(e.target as LoaderItem).url] = null;
		}
		
		
		
	}
}