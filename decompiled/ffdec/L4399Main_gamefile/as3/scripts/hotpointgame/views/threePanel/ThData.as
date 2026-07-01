package hotpointgame.views.threePanel
{
   import hotpointgame.common.*;
   
   public class ThData
   {
      
      private var lv:VT;
      
      private var maxLv:VT;
      
      public function ThData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : ThData
      {
         var _loc2_:ThData = new ThData();
         if(param1 != null)
         {
            _loc2_.lv = VT.createVT(param1["lv"]);
         }
         else
         {
            _loc2_.lv = VT.createVT(GS.a1);
         }
         _loc2_.maxLv = VT.createVT(GS.a4);
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["lv"] = this.lv.getValue();
         return _loc1_;
      }
      
      public function getLv() : Number
      {
         return this.lv.getValue();
      }
      
      public function setLv(param1:Number) : void
      {
         this.lv.setValue(param1);
      }
      
      public function getMaxLv() : Number
      {
         return this.maxLv.getValue();
      }
   }
}

