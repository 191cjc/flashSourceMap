package hotpointgame.repository.timeJl
{
   public class TimeJlFactory
   {
      
      public static var dataList:Array = [];
      
      public function TimeJlFactory()
      {
         super();
      }
      
      public static function createTimeJl(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         for each(_loc2_ in param1.奖励)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.时间);
            _loc5_ = Number(_loc2_.类型);
            _loc6_ = Number(_loc2_.阶段);
            _loc7_ = String(_loc2_.角色奖励一);
            _loc8_ = String(_loc2_.角色数量一);
            _loc9_ = String(_loc2_.角色奖励二);
            _loc10_ = String(_loc2_.角色数量二);
            dataList.push(TimeJlBasicData.createTimeJlData(_loc3_,_loc6_,_loc5_,_loc4_,_loc7_,_loc8_,_loc9_,_loc10_));
         }
      }
      
      public static function getDataById(param1:Number, param2:Number) : TimeJlBasicData
      {
         var _loc4_:TimeJlBasicData = null;
         var _loc3_:Array = [];
         for each(_loc4_ in dataList)
         {
            if(_loc4_.getType() == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length != 0)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.getJd() == param2)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public static function getDataByType(param1:Number) : TimeJlBasicData
      {
         var _loc3_:TimeJlBasicData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in dataList)
         {
            if(_loc3_.getType() == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

