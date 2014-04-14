package ww599.Tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	/**
	 * @author luli&ww
	 */
	public class DisplayUtil
	{
        /**
         * 清空指定container
         * @param container 指定容器
         */
        public static function clean(container:DisplayObjectContainer):void {
			if(!container) return;
			while(container.numChildren)
			{
				container.removeChildAt(0);
			}
        }
		
		/**
		 * 将显示对象设置到父容器的最顶层 
		 * @param dis
		 * 
		 */
		public static function setTop(dis:DisplayObject):void
		{
			if(dis.parent)
			{
				var tParent:DisplayObjectContainer;
				tParent=dis.parent;
				tParent.setChildIndex(dis,tParent.numChildren-1);
			}
		}
		
		
		/**
		 * 隐藏容器中的条目 
		 * @param container
		 * @param preFix 条目名字前缀
		 * @param count 最大index
		 * @param start 最小index
		 * 
		 */
		public static function setHideItems(container:DisplayObjectContainer,preFix:String,end:int,start:int=0):void
		{
			var i:int;
			for(i=start;i<=end;i++)
			{
				container[preFix+i].visible=false;
			}
		}
		/**
		 * 将指定对象移除显示列表
		 * @param item 指定显示对象
		 */
		public static function selfRemove(item:DisplayObject):void {
			if(item && item.parent) item.parent.removeChild(item);
		}
		/**
		 * 给对象添加滤镜，需要考虑多个滤镜的情况
		 * @param target 需要应用滤镜的对象
		 * @param filter 滤镜滤镜
		 * @return 添加的滤镜对象
		 */
		public static function addFilter(target:DisplayObject, filter:*):void
		{
			var currentFilters:Array = target.filters || [];
			currentFilters.push(filter);
			target.filters = currentFilters;
		}
		/**
		 * 为可视对象添加发光滤镜
		 * @param target 目标对象
		 * @param color 发光颜色
		 * @param thinkness 发光范围
		 */
		public static function glow(target:DisplayObject, color:int, thinkness:int = 2):void
		{
			addFilter(target, new GlowFilter(color, 1, thinkness, thinkness));
		}
		/**
		 * 经典黑边滤镜
		 */
//		public static function outlineBlack(target:DisplayObject):void 
//		{
//			addFilter(target, FilterStyle.blackFilter);
//		}
//		/**
//		 * 增加灰度滤镜
//		 */
//		public static function gray(target:DisplayObject):void 
//		{
//			target.filters = [FilterStyle.grayFilter];
//		}
		/**
		 * 添加元素到容器中，并设置元素的name和坐标
		 */
		public static function moveTarget(container:DisplayObjectContainer, target:DisplayObject, x:int = 0, y:int = 0, name:String = ""):void 
		{
			container.addChild(target);
			target.x = x;
			target.y = y;
			if(name) target.name = name;
		}
	}
}
