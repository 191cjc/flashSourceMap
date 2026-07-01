package hotpointgame.repository.chHd
{
   public class ChHdFactory
   {
      
      private static var dataList:Array = [];
      
      public function ChHdFactory()
      {
         super();
      }
      
      public static function createChHdFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:ChHdData = null;
         for each(_loc2_ in param1.奖励)
         {
            _loc3_ = Number(_loc2_.ID);
            _loc4_ = Number(_loc2_.消费);
            _loc5_ = String(_loc2_.物品);
            _loc6_ = Number(_loc2_.物品数量);
            _loc7_ = ChHdData.createHdData(_loc3_,_loc4_,_loc5_,_loc6_);
            dataList.push(_loc7_);
         }
      }
      
      public static function getDataById(param1:Number) : ChHdData
      {
         var _loc2_:ChHdData = null;
         for each(_loc2_ in dataList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

