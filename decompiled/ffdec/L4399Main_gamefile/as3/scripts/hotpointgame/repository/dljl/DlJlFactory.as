package hotpointgame.repository.dljl
{
   public class DlJlFactory
   {
      
      public static var dataList:Array = [];
      
      public function DlJlFactory()
      {
         super();
      }
      
      public static function ctreateDlJlFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:DlJlBasicData = null;
         for each(_loc2_ in param1.物品)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.次数);
            _loc5_ = String(_loc2_.奖励);
            _loc6_ = DlJlBasicData.createDljlBasicData(_loc3_,_loc4_,_loc5_);
            dataList.push(_loc6_);
         }
      }
      
      public static function getDataByCs(param1:Number) : DlJlBasicData
      {
         var _loc2_:DlJlBasicData = null;
         for each(_loc2_ in dataList)
         {
            if(_loc2_.getCs() == param1)
            {
               return _loc2_;
            }
         }
         throw new Error("没有这个次数的奖励:" + param1);
      }
   }
}

