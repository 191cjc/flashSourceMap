package hotpointgame.repository.openBox
{
   import hotpointgame.common.*;
   
   public class OpenBoxFactory
   {
      
      public static var gsList:Array = [];
      
      public function OpenBoxFactory()
      {
         super();
      }
      
      public static function creatOpenBoxFactory(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         for each(_loc2_ in param1.物品)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.概率);
            _loc5_ = Number(_loc2_.物品ID);
            gsList.push(OpenBoxBasicData.createOpenBoxData(_loc3_,_loc4_,_loc5_));
         }
      }
      
      public static function getGoodsByGl(param1:Number) : OpenBoxBasicData
      {
         var _loc3_:OpenBoxBasicData = null;
         var _loc2_:VT = VT.createVT(0);
         for each(_loc3_ in gsList)
         {
            _loc2_.setValue(_loc2_.getValue() + _loc3_.getGl());
            if(_loc2_.getValue() >= param1)
            {
               return _loc3_;
            }
         }
         throw new Error("概率不足" + param1);
      }
   }
}

