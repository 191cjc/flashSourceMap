package hotpointgame.repository.analysis
{
   import hotpointgame.common.*;
   
   public class AnalysisFactory
   {
      
      private static var dataList:Array = [];
      
      public function AnalysisFactory()
      {
         super();
      }
      
      public static function creatGoodsFactory(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:AnalysisBasicData = null;
         for each(_loc2_ in param1.分解)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.等级);
            _loc5_ = Number(_loc2_.品质);
            _loc6_ = String(_loc2_.分解id);
            _loc7_ = String(_loc2_.分解概率);
            _loc8_ = String(_loc2_.分解数量);
            _loc9_ = AnalysisBasicData.createAnalysisBasicData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
            dataList[_loc3_] = _loc9_;
         }
      }
      
      public static function getAnalysisGoods(param1:Number, param2:Number, param3:Number) : Array
      {
         var _loc4_:AnalysisBasicData = null;
         var _loc6_:AnalysisBasicData = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in dataList)
         {
            if(_loc6_ != null && _loc6_.getLevel() == param1 && _loc6_.getColor() == param2)
            {
               _loc4_ = _loc6_;
            }
         }
         if(_loc4_ != null)
         {
            _loc7_ = _loc4_.getGlArr();
            _loc8_ = _loc4_.getNum();
            _loc9_ = _loc4_.getIdArr();
            _loc10_ = 0;
            _loc11_ = 0;
            while(_loc11_ < _loc7_.length)
            {
               _loc10_ += _loc7_[_loc11_];
               if(_loc10_ >= param3)
               {
                  _loc5_ = [VT.createVT(_loc9_[_loc11_]),VT.createVT(_loc8_[_loc11_])];
                  break;
               }
               _loc11_++;
            }
            return _loc5_;
         }
         throw new Error("无此分解数据" + param1 + param2);
      }
   }
}

