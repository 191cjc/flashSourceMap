package hotpointgame.views.zppanel
{
   import hotpointgame.common.*;
   
   public class ZpData
   {
      
      public static var tims:VT = VT.createVT(GS.a1);
      
      public function ZpData()
      {
         super();
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["te"] = tims.getValue();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         tims.setValue(param1["te"]);
      }
      
      public static function clearTimes() : void
      {
         tims.setValue(GS.a1);
      }
   }
}

