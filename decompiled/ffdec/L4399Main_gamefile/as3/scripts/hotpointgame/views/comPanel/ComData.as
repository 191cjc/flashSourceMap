package hotpointgame.views.comPanel
{
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.*;
   
   public class ComData
   {
      
      public static var dataArr:Array = [];
      
      public static var jpArr:Array = [];
      
      public static var jpNum:Number = 0;
      
      private static var jpIdArr:Array = [];
      
      public function ComData()
      {
         super();
      }
      
      public static function setDataArr(param1:Array) : void
      {
         var _loc3_:GoodsData = null;
         var _loc7_:Object = null;
         var _loc2_:Array = [];
         var _loc4_:Array = ["等级","颜色"];
         var _loc5_:Array = [Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC];
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            _loc3_ = param1[_loc6_][0] as GoodsData;
            _loc7_ = {
               "girdObj":param1[_loc6_],
               "等级":_loc3_.getUseLevel(),
               "颜色":_loc3_.getColor()
            };
            _loc2_.push(_loc7_);
            _loc6_++;
         }
         _loc2_.sortOn(_loc4_,_loc5_);
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length)
         {
            dataArr.push(_loc2_[_loc6_].girdObj);
            _loc6_++;
         }
      }
      
      public static function initJpData() : void
      {
         jpIdArr = GoodsFactory.getIdArrBySmType(GS.a13);
      }
      
      public static function initData() : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Goods = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Goods = null;
         var _loc11_:Number = NaN;
         var _loc12_:Object = null;
         var _loc1_:Array = ["满足","等级","颜色"];
         var _loc2_:Array = [Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC];
         if(jpIdArr.length != 0)
         {
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < jpIdArr.length)
            {
               if(BagFactory.getNumById((jpIdArr[_loc4_] as GoodsData).getId()) > GS.a0)
               {
                  _loc7_ = (jpIdArr[_loc4_] as GoodsData).createGoods();
                  _loc8_ = Number(BagFactory.getNumById((jpIdArr[_loc4_] as GoodsData).getId()));
                  _loc9_ = isBo(_loc7_);
                  _loc3_.push(new Array(_loc7_,_loc8_,_loc9_));
               }
               _loc4_++;
            }
            _loc5_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc10_ = _loc3_[_loc4_][0] as Goods;
               _loc11_ = Number(_loc3_[_loc4_][2]);
               _loc12_ = {
                  "goodData":_loc3_[_loc4_],
                  "满足":_loc11_,
                  "等级":_loc10_.getUseLevel(),
                  "颜色":_loc10_.getColor()
               };
               _loc5_.push(_loc12_);
               _loc4_++;
            }
            _loc5_.sortOn(_loc1_,_loc2_);
            _loc6_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc6_.push(_loc5_[_loc4_]["goodData"]);
               _loc4_++;
            }
            jpArr = getArr(_loc6_,GS.a6);
            jpNum = jpArr.length;
         }
      }
      
      public static function closeDate() : void
      {
         jpIdArr.length = 0;
      }
      
      public static function isBo(param1:Goods) : Number
      {
         var _loc2_:Array = param1.getNeedId();
         var _loc3_:Array = param1.getNeedNum();
         var _loc4_:Array = [];
         var _loc5_:Number = 0;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(BagFactory.getNumById(_loc2_[_loc6_]) < _loc3_[_loc6_])
            {
               return 1;
            }
            _loc6_++;
         }
         return 0;
      }
      
      public static function getGoodsByGl(param1:Number) : Array
      {
         var _loc2_:VT = VT.createVT(0);
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < dataArr.length)
         {
            _loc2_.setValue(_loc2_.getValue() + dataArr[_loc4_][1]);
            if(_loc2_.getValue() >= param1)
            {
               if(dataArr[_loc4_][2] == null)
               {
                  _loc3_ = [(dataArr[_loc4_][0] as GoodsData).createGoods(),GS.a1];
               }
               else
               {
                  _loc3_ = [(dataArr[_loc4_][0] as GoodsData).createGoods(),dataArr[_loc4_][2]];
               }
               return _loc3_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getArr(param1:Array, param2:Number) : Array
      {
         param1 = DeepCopyUtil.clone(param1);
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            if(param1.length >= param2)
            {
               _loc3_.push(param1.splice(0,param2));
            }
            else if(param1.length > 0)
            {
               _loc3_.push(param1.splice(0));
               break;
            }
            _loc4_ = --_loc4_ + 1;
         }
         return _loc3_;
      }
   }
}

