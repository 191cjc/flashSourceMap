package hotpointgame.repository.ship
{
   import hotpointgame.common.*;
   import hotpointgame.repository.goods.*;
   
   public class ShipFactory
   {
      
      public static var lvArr:Array = [];
      
      public static var xlArr:Array = [];
      
      public static var gkArr:Array = [];
      
      public function ShipFactory()
      {
         super();
      }
      
      public static function createLvFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:ShipLvBasicData = null;
         for each(_loc2_ in param1.等级)
         {
            _loc3_ = Number(_loc2_.LV);
            _loc4_ = String(_loc2_.物品);
            _loc5_ = String(_loc2_.数量);
            _loc6_ = Number(_loc2_.功勋);
            _loc7_ = Number(_loc2_.晶币);
            _loc8_ = ShipLvBasicData.createShLvData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
            lvArr.push(_loc8_);
         }
      }
      
      public static function createXlFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:ShipXlBasicData = null;
         for each(_loc2_ in param1.效率)
         {
            _loc3_ = Number(_loc2_.LV);
            _loc4_ = Number(_loc2_.时间);
            _loc5_ = Number(_loc2_.次数);
            _loc6_ = String(_loc2_.物品);
            _loc7_ = String(_loc2_.数量);
            _loc8_ = Number(_loc2_.晶币);
            _loc9_ = ShipXlBasicData.createShipXlData(_loc3_,_loc4_,_loc6_,_loc7_,_loc5_,_loc8_);
            xlArr.push(_loc9_);
         }
      }
      
      public static function createGkFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:ShipGkBasicData = null;
         for each(_loc2_ in param1.关卡)
         {
            _loc3_ = Number(_loc2_.ID);
            _loc4_ = Number(_loc2_.大关卡);
            _loc5_ = Number(_loc2_.关卡ID);
            _loc6_ = Number(_loc2_.关卡等级);
            _loc7_ = Number(_loc2_.帧数);
            _loc8_ = Number(_loc2_.体力);
            _loc9_ = Number(_loc2_.需求物品);
            _loc10_ = Number(_loc2_.需求数量);
            _loc11_ = String(_loc2_.物品);
            _loc12_ = String(_loc2_.物品B);
            _loc13_ = String(_loc2_.物品C);
            _loc14_ = String(_loc2_.物品D);
            _loc15_ = String(_loc2_.掉落等级);
            _loc16_ = String(_loc2_.数量);
            _loc17_ = String(_loc2_.概率);
            _loc18_ = Number(_loc2_.晶币);
            _loc19_ = Number(_loc2_.经验);
            _loc20_ = ShipGkBasicData.createShipGkData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_);
            gkArr.push(_loc20_);
         }
      }
      
      public static function getIdByGk(param1:Number) : ShipGkBasicData
      {
         var _loc2_:ShipGkBasicData = null;
         for each(_loc2_ in gkArr)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         throw new Error("挂机没有关卡数据" + param1);
      }
      
      public static function getDlLevel(param1:Number, param2:Number) : Array
      {
         var _loc3_:ShipGkBasicData = getIdByGk(param1);
         var _loc4_:Array = _loc3_.getGl();
         var _loc5_:Array = _loc3_.getDlId();
         var _loc6_:Array = _loc3_.getGsNum();
         var _loc7_:VT = VT.createVT(0);
         var _loc8_:uint = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc7_.setValue(_loc7_.getValue() + _loc4_[_loc8_]);
            if(_loc7_.getValue() >= param2)
            {
               return [GoodsFactory.createGoodsByCreateLevel(_loc5_[_loc8_]),VT.createVT(_loc6_[_loc8_])];
            }
            _loc8_++;
         }
         return [];
      }
      
      public static function getDataByLv(param1:Number) : ShipLvBasicData
      {
         var _loc2_:ShipLvBasicData = null;
         for each(_loc2_ in lvArr)
         {
            if(_loc2_.getLv() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getDataByShLv(param1:Number) : ShipXlBasicData
      {
         var _loc2_:ShipXlBasicData = null;
         for each(_loc2_ in xlArr)
         {
            if(param1 == _loc2_.getLv())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getGkByType(param1:Number) : Array
      {
         var _loc3_:ShipGkBasicData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in gkArr)
         {
            if(_loc3_.getType() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

