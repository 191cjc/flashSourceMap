package hotpointgame.utils.gameloader
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public class SwfLoader
   {
      
      private var _load:Loader;
      
      private var _loaderContext:LoaderContext;
      
      private var _complete:Function;
      
      private var _ioError:Function;
      
      private var _progress:Function;
      
      public function SwfLoader()
      {
         super();
         this.init();
      }
      
      public function loadSwf(param1:*) : void
      {
         if(param1 is String)
         {
            this.urlLoad(param1);
         }
         else
         {
            if(!(param1 is Class))
            {
               throw new Error("SwfLoader 不支持的类型");
            }
            this.byteArrayLoad(param1);
         }
      }
      
      private function urlLoad(param1:String) : void
      {
         this._load.load(new URLRequest(param1),this._loaderContext);
      }
      
      private function byteArrayLoad(param1:Class) : void
      {
         this._load.loadBytes(new param1());
      }
      
      private function init() : void
      {
         this._load = new Loader();
         this._loaderContext = new LoaderContext();
         this._load.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
         this._load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      }
      
      public function getDisplayO() : MovieClip
      {
         return this._load.content as MovieClip;
      }
      
      public function getClass(param1:String) : Object
      {
         return this._load.contentLoaderInfo.applicationDomain.getDefinition(param1);
      }
      
      private function completeHandler(param1:Event) : void
      {
         if(this._complete != null)
         {
            this._complete(param1);
         }
         this.deleteMe();
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         if(this._ioError != null)
         {
            this._ioError(param1);
         }
         this.deleteMe();
         throw new Error("SwfLoader is error!:" + param1.toString());
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         if(this._progress != null)
         {
            this._progress(param1.bytesLoaded / param1.bytesTotal * 100);
         }
      }
      
      private function deleteMe() : void
      {
         this._load.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.completeHandler);
         this._load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._load.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._complete = null;
         this._ioError = null;
         this._progress = null;
      }
      
      public function set progress(param1:Function) : void
      {
         this._progress = param1;
      }
      
      public function set ioError(param1:Function) : void
      {
         this._ioError = param1;
      }
      
      public function set complete(param1:Function) : void
      {
         this._complete = param1;
      }
   }
}

