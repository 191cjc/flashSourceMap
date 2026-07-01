package hotpointgame.repository.gift
{
   import hotpointgame.common.*;
   import hotpointgame.models.gift.Gift;
   
   public class GiftFactory
   {
      
      private static var giftList:Array = [];
      
      private static var giftDataList:Array = [];
      
      public function GiftFactory()
      {
         super();
      }
      
      public static function createGiftFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:GiftBasicData = null;
         for each(_loc2_ in param1.礼包)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.类型);
            _loc5_ = Number(_loc2_.小类型);
            _loc6_ = Number(_loc2_.礼包编号);
            _loc7_ = String(_loc2_.名称);
            _loc8_ = Number(_loc2_.需求);
            _loc9_ = String(_loc2_.起始时间);
            _loc10_ = String(_loc2_.结束时间);
            _loc11_ = String(_loc2_.网址);
            _loc12_ = Number(_loc2_.帧数);
            _loc13_ = String(_loc2_.奖励);
            _loc14_ = String(_loc2_.说明);
            _loc15_ = Number(_loc2_.存档);
            _loc16_ = Number(_loc2_.下架);
            _loc17_ = GiftBasicData.createGiftBasicData(_loc3_,_loc4_,_loc5_,_loc7_,_loc6_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_);
            giftDataList.push(_loc17_);
            giftList.push(_loc17_.createGift());
         }
      }
      
      public static function getGiftDataById(param1:Number) : GiftBasicData
      {
         var _loc2_:GiftBasicData = null;
         for each(_loc2_ in giftDataList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getJfArr(param1:Number) : Array
      {
         var _loc3_:Gift = null;
         var _loc2_:Array = [];
         for each(_loc3_ in giftList)
         {
            if(_loc3_.getType() == param1)
            {
               if(_loc3_.getXiaJ() == GS.a0)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
   }
}

