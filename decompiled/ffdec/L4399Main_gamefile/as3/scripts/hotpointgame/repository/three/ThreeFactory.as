package hotpointgame.repository.three
{
   public class ThreeFactory
   {
      
      public static var dataList:Array = [];
      
      public function ThreeFactory()
      {
         super();
      }
      
      public static function createThreeFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:ThreeData = null;
         for each(_loc2_ in param1.物品)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.物品ID);
            _loc5_ = String(_loc2_.物品数量);
            _loc6_ = String(_loc2_.枪手奖励ID);
            _loc7_ = String(_loc2_.炮手奖励ID);
            _loc8_ = String(_loc2_.奖励数量);
            _loc9_ = ThreeData.createThreeData(_loc3_,_loc4_,_loc5_,_loc6_,_loc8_,_loc7_);
            dataList.push(_loc9_);
         }
      }
      
      public static function getDataById(param1:Number) : ThreeData
      {
         var _loc2_:ThreeData = null;
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

