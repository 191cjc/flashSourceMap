package hotpointgame.views.unionVip
{
   import hotpointgame.common.*;
   
   public class UnVipData
   {
      
      private var lq:VT = VT.createVT(GS.a0);
      
      private var vip:VT = VT.createVT(GS.a0);
      
      public function UnVipData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : UnVipData
      {
         var _loc2_:UnVipData = new UnVipData();
         if(param1 != null)
         {
            _loc2_.lq.setValue(param1["lq"]);
            _loc2_.vip.setValue(param1["vp"]);
         }
         else
         {
            _loc2_.lq = VT.createVT(GS.a0);
            _loc2_.vip = VT.createVT(GS.a0);
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["lq"] = this.lq.getValue();
         _loc1_["vp"] = this.vip.getValue();
         return _loc1_;
      }
      
      public function setEvLq(param1:Number) : void
      {
         this.lq.setValue(param1);
      }
      
      public function getEvLq() : Number
      {
         return this.lq.getValue();
      }
      
      public function getVip() : Number
      {
         return this.vip.getValue();
      }
      
      public function setVip(param1:Number) : void
      {
         this.vip.setValue(param1);
      }
   }
}

