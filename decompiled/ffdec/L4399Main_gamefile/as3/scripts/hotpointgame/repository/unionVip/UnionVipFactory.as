package hotpointgame.repository.unionVip
{
   import hotpointgame.common.*;
   import hotpointgame.models.unionShop.*;
   
   public class UnionVipFactory
   {
      
      public static var vipList:Array = [];
      
      private static var shoplist:Array = [];
      
      public static var unShopList:Array = [];
      
      public static var unJsList:Array = [];
      
      public static var unJtzList:Array = [];
      
      public function UnionVipFactory()
      {
         super();
      }
      
      public static function createUnVipFactory(param1:XML) : void
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
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Number = NaN;
         var _loc16_:UnionVipData = null;
         for each(_loc2_ in param1.vip)
         {
            _loc3_ = Number(_loc2_.vipId);
            _loc4_ = Number(_loc2_.消费);
            _loc5_ = Number(_loc2_.生命);
            _loc6_ = Number(_loc2_.攻击);
            _loc7_ = Number(_loc2_.防御);
            _loc8_ = Number(_loc2_.暴击);
            _loc9_ = Number(_loc2_.五行);
            _loc10_ = Number(_loc2_.经验);
            _loc11_ = Number(_loc2_.宠物经验);
            _loc12_ = Number(_loc2_.金币);
            _loc13_ = String(_loc2_.物品ID);
            _loc14_ = String(_loc2_.物品数量);
            _loc15_ = Number(_loc2_.贡献);
            _loc16_ = UnionVipData.createUnionVip(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_);
            vipList.unshift(_loc16_);
         }
      }
      
      public static function createUnShopFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc13_:UnionShopData = null;
         for each(_loc2_ in param1.商品)
         {
            _loc3_ = Number(_loc2_.ID);
            _loc4_ = Number(_loc2_.商店等级);
            _loc5_ = String(_loc2_.物品名称);
            _loc6_ = Number(_loc2_.需求金币);
            _loc7_ = Number(_loc2_.需求贡献);
            _loc8_ = String(_loc2_.物品ID);
            _loc9_ = Number(_loc2_.物品数量);
            _loc10_ = Number(_loc2_.可卖数量);
            _loc11_ = Number(_loc2_.排序);
            _loc12_ = String(_loc2_.说明);
            _loc13_ = UnionShopData.createUnShopData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
            shoplist.push(_loc13_);
            unShopList.push(_loc13_.createUnShop());
         }
      }
      
      public static function createUnJsFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc13_:UnionJsData = null;
         for each(_loc2_ in param1.升级)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.名字);
            _loc5_ = Number(_loc2_.帧数);
            _loc6_ = Number(_loc2_.npc);
            _loc7_ = Number(_loc2_.系统);
            _loc8_ = Number(_loc2_.等级);
            _loc9_ = Number(_loc2_.需求资金);
            _loc10_ = Number(_loc2_.需求建设);
            _loc11_ = Number(_loc2_.军团等级);
            _loc12_ = String(_loc2_.说明);
            _loc13_ = UnionJsData.createUjData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
            unJsList.push(_loc13_);
         }
      }
      
      public static function createUnJtzFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:UnionJtzData = null;
         for each(_loc2_ in param1.奖励)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.奖励);
            _loc5_ = String(_loc2_.数量);
            _loc6_ = UnionJtzData.createJtzData(_loc3_,_loc4_,_loc5_);
            unJtzList.push(_loc6_);
         }
      }
      
      public static function getjtzjl(param1:Number) : UnionJtzData
      {
         var _loc2_:UnionJtzData = null;
         for each(_loc2_ in unJtzList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getdataArr(param1:Number) : Array
      {
         var _loc3_:UnionJsData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in unJsList)
         {
            if(_loc3_.getNpc() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getDataByNpcAndXt(param1:Number, param2:Number, param3:Number) : UnionJsData
      {
         var _loc6_:UnionJsData = null;
         var _loc4_:Array = getdataArr(param1);
         var _loc5_:Array = [];
         if(_loc4_.length == 0)
         {
            return null;
         }
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.getXt() == param2)
            {
               _loc5_.push(_loc6_);
            }
         }
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.getLv() == param3)
            {
               return _loc6_;
            }
         }
         return null;
      }
      
      public static function getDataZy(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc6_:UnionJsData = null;
         var _loc7_:VT = null;
         var _loc4_:Array = getdataArr(param1);
         var _loc5_:Array = [];
         if(_loc4_.length == 0)
         {
            return 0;
         }
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.getXt() == param2)
            {
               _loc5_.push(_loc6_);
            }
         }
         _loc7_ = VT.createVT(GS.a0);
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.getLv() < param3)
            {
               _loc7_.setValue(_loc7_.getValue() + _loc6_.getNjs());
            }
         }
         return _loc7_.getValue();
      }
      
      public static function getDataNumByNpcAndXt(param1:Number, param2:Number) : Number
      {
         var _loc5_:UnionJsData = null;
         var _loc3_:Array = getdataArr(param1);
         var _loc4_:Array = [];
         if(_loc3_.length == 0)
         {
            return 0;
         }
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.getXt() == param2)
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_.length;
      }
      
      public static function getShopDataById(param1:Number) : UnionShopData
      {
         var _loc2_:UnionShopData = null;
         for each(_loc2_ in shoplist)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getShopByLv(param1:Number) : Array
      {
         var _loc3_:UnionShop = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:UnionShop = null;
         var _loc9_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in unShopList)
         {
            if(_loc3_.getLv() == param1)
            {
               _loc3_.setTimes(0);
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = [];
         _loc5_ = ["排序"];
         _loc6_ = [Array.NUMERIC];
         _loc7_ = 0;
         while(_loc7_ < _loc2_.length)
         {
            _loc8_ = _loc2_[_loc7_] as UnionShop;
            _loc9_ = {
               "uObj":_loc8_,
               "排序":_loc8_.getPx()
            };
            _loc4_[_loc7_] = _loc9_;
            _loc7_++;
         }
         _loc4_.sortOn(_loc5_,_loc6_);
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc2_[_loc7_] = _loc4_[_loc7_].uObj;
            _loc7_++;
         }
         return _loc2_;
      }
      
      public static function getDataByCz(param1:Number) : Number
      {
         var _loc2_:uint = 0;
         while(_loc2_ < vipList.length)
         {
            if(param1 >= (vipList[_loc2_] as UnionVipData).getNeedNum())
            {
               return (vipList[_loc2_] as UnionVipData).getVipId();
            }
            _loc2_++;
         }
         return -1;
      }
      
      public static function getVipById(param1:Number) : UnionVipData
      {
         var _loc2_:UnionVipData = null;
         for each(_loc2_ in vipList)
         {
            if(_loc2_.getVipId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

