package open4399Tools.events
{
   import flash.events.Event;
   
   public class Open4399ToolsEvent extends Event
   {
      
      public static const SERVICE_INIT:* = "init_service";
      
      public static const CHECK_BAD_WORDS:* = "check_bad_words";
      
      public static const CHECK_BAD_WORDS_ERROR:* = "check_bad_words_error";
      
      private var _data:*;
      
      public function Open4399ToolsEvent(param1:String, param2:* = null)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      override public function clone() : Event
      {
         return new Open4399ToolsEvent(type,this._data);
      }
   }
}

