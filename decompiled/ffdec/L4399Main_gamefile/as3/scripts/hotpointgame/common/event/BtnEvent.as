package hotpointgame.common.event
{
   import flash.events.Event;
   
   public class BtnEvent extends Event
   {
      
      public static const DO_CHANGE:String = "doChange";
      
      public static const DO_CLICK:String = "doClick";
      
      public static const DO_CLOSE:String = "doClose";
      
      public static const DO_SAME_CHANGE:String = "doSameChange";
      
      public static const DO_OVER:String = "doOver";
      
      public static const DO_OUT:String = "doOUT";
      
      public static const DO_DOWN:String = "doDonw";
      
      public static const DO_MOUSEUP_ONE:String = "doMouseUpOne";
      
      public static const DO_MOUSEUP_TOW:String = "doMouseUpTow";
      
      public static const DO_MOUSEMOVE:String = "doMouseMove";
      
      private var _id:Number;
      
      private var _name:String;
      
      public function BtnEvent(param1:String, param2:Number = 0, param3:String = null, param4:Boolean = true, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._id = param2;
         this._name = param3;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      override public function clone() : Event
      {
         return new BtnEvent(type,this._id,this._name,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("BtnEvent","type","_id","_name","bubbles","cancelable","eventPhase");
      }
   }
}

