package hotpointgame.repository.zhanpan
{
   import hotpointgame.common.*;
   
   public class ZpFactory
   {
      
      public static var zpList:Array = [];
      
      public function ZpFactory()
      {
         super();
      }
      
      public static function createZpFactory(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:ZpBasicData = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.转盘)
         {
            _loc4_ = Number(_loc3_.ID);
            _loc5_ = String(_loc3_.物品ID);
            _loc6_ = String(_loc3_.物品数量);
            _loc7_ = Number(_loc3_.概率);
            _loc8_ = Number(_loc3_.阶段);
            _loc9_ = Number(_loc3_.位置);
            _loc10_ = ZpBasicData.createZp(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
            zpList.push(_loc10_);
         }
      }
      
      public static function getDataByJd(param1:Number) : Array
      {
         var _loc3_:ZpBasicData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in zpList)
         {
            if(_loc3_.getJd() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length == GS.a0)
         {
            throw new Error("没有这个阶段" + param1);
         }
         return _loc2_;
      }
      
      public static function getDataByJdAndWz(param1:Number, param2:Number) : ZpBasicData
      {
         var _loc4_:ZpBasicData = null;
         var _loc3_:Array = getDataByJd(param1);
         if(_loc3_.length != 0)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.getWz() == param2)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public static function getDataById(param1:Number) : ZpBasicData
      {
         var _loc2_:ZpBasicData = null;
         for each(_loc2_ in zpList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getDataByRanNum(param1:Number, param2:Number) : ZpBasicData
      {
         var _loc5_:ZpBasicData = null;
         var _loc3_:Array = getDataByJd(param1);
         var _loc4_:VT = VT.createVT(GS.a0);
         for each(_loc5_ in _loc3_)
         {
            _loc4_.setValue(_loc4_.getValue() + _loc5_.getGl());
            if(_loc4_.getValue() >= param2)
            {
               return _loc5_;
            }
         }
         return null;
      }
   }
}

