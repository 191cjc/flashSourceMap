package hotpointgame.gameobj
{
   import com.adobeadobe.serialization.json.JSON;
   import hotpointgame.common.event.*;
   import open4399Tools.*;
   import open4399Tools.events.*;
   
   public class ApiCheckWord
   {
      
      public static var self:ApiCheckWord;
      
      private var open4399ToolsApi:Open4399ToolsApi = Open4399ToolsApi.getInstance();
      
      private var okFlag:int = 0;
      
      public function ApiCheckWord()
      {
         super();
         this.open4399ToolsApi.addEventListener(Open4399ToolsEvent.SERVICE_INIT,this.onServiceInitComplete);
         this.open4399ToolsApi.addEventListener(Open4399ToolsEvent.CHECK_BAD_WORDS_ERROR,this.onCheckBadWordsError);
         this.open4399ToolsApi.addEventListener(Open4399ToolsEvent.CHECK_BAD_WORDS,this.onCheckBadWords);
         this.open4399ToolsApi.init();
      }
      
      public function checkWordByapi(param1:String) : Boolean
      {
         if(this.okFlag == 1)
         {
            this.open4399ToolsApi.checkBadWords(param1);
            return true;
         }
         return false;
      }
      
      private function onServiceInitComplete(param1:Open4399ToolsEvent) : void
      {
         this.okFlag = 1;
      }
      
      private function onCheckBadWordsError(param1:Open4399ToolsEvent) : void
      {
      }
      
      private function onCheckBadWords(param1:Open4399ToolsEvent) : void
      {
         var _loc2_:Object = com.adobeadobe.serialization.json.JSON.decode(String(param1.data));
         Main.self.dispatchEvent(new UnEvent(UnEvent.JC_API,_loc2_));
      }
   }
}

