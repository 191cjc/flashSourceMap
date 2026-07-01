package hotpointgame.repository.strengthen
{
   public class StrengthenFactory
   {
      
      public static var strDataList:Array = [];
      
      public function StrengthenFactory()
      {
         super();
      }
      
      public static function creatStrFactory(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:StrengthenBasicData = null;
         for each(_loc2_ in param1.强化)
         {
            _loc3_ = Number(_loc2_.掉落等级);
            _loc4_ = Number(_loc2_.品质);
            _loc5_ = String(_loc2_.强化值);
            _loc6_ = String(_loc2_.强化概率);
            _loc7_ = String(_loc2_.金币);
            _loc8_ = String(_loc2_.点卷);
            _loc9_ = String(_loc2_.材料id);
            _loc10_ = String(_loc2_.材料数量);
            _loc11_ = String(_loc2_.商店id);
            _loc12_ = StrengthenBasicData.createStrBasicData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
            strDataList.push(_loc12_);
         }
      }
      
      public static function getStrDataByClAndCo(param1:Number, param2:Number) : StrengthenBasicData
      {
         var _loc4_:StrengthenBasicData = null;
         var _loc3_:Array = [];
         for each(_loc4_ in strDataList)
         {
            if(_loc4_.getChangeLevel() == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length == 0)
         {
            return null;
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getColor() == param2)
            {
               return _loc4_;
            }
         }
         throw new Error("没此强化数据",param1 + param2);
      }
      
      public static function getStrengValue(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getStrValue(param3);
      }
      
      public static function getProbability(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getProbability(param3);
      }
      
      public static function getGold(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getGold(param3);
      }
      
      public static function getDj(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getDj(param3);
      }
      
      public static function getMateriaId(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getMateriaId(param3);
      }
      
      public static function getMateriaNum(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getMateriaNum(param3);
      }
      
      public static function getShopId(param1:Number, param2:Number, param3:Number) : Number
      {
         return getStrDataByClAndCo(param1,param2).getShopId(param3);
      }
   }
}

