package hotpointgame.common.event
{
   import flash.events.Event;
   
   public class UpdateBagEvent extends Event
   {
      
      public static const DO_UPDATE:String = "do_update";
      
      public static const D0_UPDATE_SHOP:String = "shop_update";
      
      private var _update:Number;
      
      private var _updataeBag:Number;
      
      private var _bo:Boolean;
      
      public function UpdateBagEvent(param1:String, param2:Number = 0, param3:Number = 0, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this._update = param2;
         this._updataeBag = param3;
         this._bo = param4;
      }
      
      public function get update() : Number
      {
         return this._update;
      }
      
      public function get updateBag() : Number
      {
         return this._updataeBag;
      }
      
      public function get bo() : Boolean
      {
         return this._bo;
      }
      
      override public function clone() : Event
      {
         return new UpdateBagEvent(type,this._update,this._updataeBag,this._bo,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("UpdateBagEvent","type","_update","_updataeBag","_bo","bubbles","cancelable","eventPhase");
      }
   }
}

