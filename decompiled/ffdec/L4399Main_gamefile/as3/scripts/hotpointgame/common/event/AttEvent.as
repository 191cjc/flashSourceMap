package hotpointgame.common.event
{
   import flash.events.Event;
   
   public class AttEvent extends Event
   {
      
      public static const MY_ATT:String = "myatt";
      
      public static const ATT_LIST:String = "attlist";
      
      public static const TJ_OK:String = "OK";
      
      public static const UNTION_THREE:String = "untion_three";
      
      public static const MY_UNTION_PM:String = "my_uniton_pm";
      
      public static const TJ_UNTION_FS:String = "tj_untion_fs";
      
      private var _obj:*;
      
      public function AttEvent(param1:String, param2:* = null, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._obj = param2;
      }
      
      public function get obj() : Object
      {
         return this._obj;
      }
      
      override public function clone() : Event
      {
         return new UnEvent(type,this._obj,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("attEvent","type","_obj","bubbles","cancelable","eventPhase");
      }
   }
}

