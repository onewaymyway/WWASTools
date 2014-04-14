package ww599.load
{
    import flash.events.*;
    import flash.net.*;
    
    public class HTTP extends Object
    {
        public function HTTP(arg1:String="text", arg2:String="get")
        {
            super();
            this._loader = new flash.net.URLLoader();
            this._loader.dataFormat = arg1;
            this._method = arg2;
            return;
        }

        public function load(arg1:String=""):void
        {
            var loc2:*=null;
            var loc3:*=null;
            if (arg1 == "" && this.url == "") 
            {
                throw new Error("无效的url！");
            }
            if (arg1) 
            {
                this.url = arg1;
            }
            this.addEvent();
            var loc1:*=new flash.net.URLRequest(this.url);
            loc1.method = this._method;
            if (this.data) 
            {
                loc2 = new flash.net.URLVariables();
                var loc4:*=0;
                var loc5:*=this.data;
                for (loc3 in loc5) 
                {
                    loc2[loc3] = this.data[loc3];
                }
                loc1.data = loc2;
            }
            this._loader.load(loc1);
            return;
        }

        internal function addEvent():void
        {
            this._loader.addEventListener(flash.events.Event.COMPLETE, this.complete);
            this._loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            this._loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._loader.addEventListener(flash.events.Event.OPEN, this.openHandler);
            this._loader.addEventListener(flash.events.ProgressEvent.PROGRESS, this.progressHandler);
            return;
        }

        internal function removeEvent():void
        {
            this._loader.removeEventListener(flash.events.Event.COMPLETE, this.complete);
            this._loader.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            this._loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._loader.removeEventListener(flash.events.Event.OPEN, this.openHandler);
            this._loader.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.progressHandler);
            return;
        }

        internal function progressHandler(arg1:flash.events.ProgressEvent):void
        {
            return;
        }

        internal function openHandler(arg1:flash.events.Event):void
        {
            return;
        }

        internal function complete(arg1:flash.events.Event):void
        {
            this.removeEvent();
            if (this.onComplete is Function) 
            {
                this.onComplete(arg1.target.data);
            }
            return;
        }

        internal function httpStatus(arg1:flash.events.HTTPStatusEvent):void
        {
            return;
        }

        internal function ioErrorHandler(arg1:flash.events.IOErrorEvent):void
        {
            this.removeEvent();
            if (this.onError is Function) 
            {
                this.onError();
            }
            return;
        }

        internal function securityErrorHandler(arg1:flash.events.SecurityErrorEvent):void
        {
            this.removeEvent();
            if (this.onError is Function) 
            {
                this.onError();
            }
            return;
        }

        public function get loader():flash.net.URLLoader
        {
            return this._loader;
        }

        internal var _loader:flash.net.URLLoader;

        internal var _method:String;

        public var url:String;

        public var data:Object;

        public var onComplete:Function;

        public var onError:Function;
    }
}
