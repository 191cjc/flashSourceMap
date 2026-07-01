package open4399Tools
{
   import flash.events.*;
   
   public class Open4399ToolsApi
   {
      
      private static var _instance:Open4399ToolsApi = new Open4399ToolsApi();
      
      private var open4399ToolsService:Open4399ToolsService = null;
      
      private var _eventDispatcher:EventDispatcher = new EventDispatcher();
      
      public function Open4399ToolsApi()
      {
         super();
         if(_instance)
         {
            throw new Error("Cannot create instance! Please use getInstance() instead.");
         }
      }
      
      public static function getInstance() : Open4399ToolsApi
      {
         return _instance;
      }
      
      public function init() : void
      {
         if(this.open4399ToolsService == null)
         {
            this.open4399ToolsService = new Open4399ToolsService();
         }
      }
      
      public function checkBadWords(param1:String) : void
      {
         if(this.open4399ToolsService == null)
         {
            return;
         }
         this.open4399ToolsService.badWordsService.checkBadWords(param1);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this._eventDispatcher.dispatchEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function resetApi() : void
      {
         _instance = null;
      }
   }
}

