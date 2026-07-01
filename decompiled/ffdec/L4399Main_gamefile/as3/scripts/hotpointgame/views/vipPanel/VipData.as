package hotpointgame.views.vipPanel
{
   import hotpointgame.common.*;
   import hotpointgame.repository.vip.*;
   
   public class VipData
   {
      
      public static var vip:VT = VT.createVT(-1);
      
      public static var evLq:VT = VT.createVT(GS.a0);
      
      public function VipData()
      {
         super();
      }
      
      public static function initData() : void
      {
         vip.setValue(-1);
         evLq.setValue(GS.a0);
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["eq"] = evLq.getValue();
         _loc1_["vip"] = vip.getValue();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         evLq.setValue(param1["eq"]);
         if(param1["vip"] != null)
         {
            vip.setValue(param1["vip"]);
         }
      }
      
      public static function isSx() : void
      {
         if(evLq.getValue() == GS.a1)
         {
            setEvLq(GS.a0);
         }
      }
      
      public static function setVip(param1:Number) : void
      {
         vip.setValue(VipFactory.getDataByCz(param1));
      }
      
      public static function getEvLq() : Number
      {
         return evLq.getValue();
      }
      
      public static function setEvLq(param1:Number) : void
      {
         evLq.setValue(param1);
      }
   }
}

