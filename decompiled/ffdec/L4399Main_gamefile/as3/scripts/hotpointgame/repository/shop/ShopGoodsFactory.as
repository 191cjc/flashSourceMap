package hotpointgame.repository.shop
{
   import hotpointgame.models.shop.Shop;
   
   public class ShopGoodsFactory
   {
      
      public static var shopDataList:Array = [];
      
      public static var shopList1:Array = [];
      
      public static var shopList2:Array = [];
      
      public function ShopGoodsFactory()
      {
         super();
      }
      
      public static function creatShopFactory(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:Number = NaN;
         var _loc22_:ShopBasicData = null;
         var _loc2_:String = param1.toXMLString();
         var _loc3_:RegExp = /&lt;/g;
         var _loc4_:RegExp = /&gt;/g;
         _loc2_ = _loc2_.replace(_loc3_,"<");
         _loc2_ = _loc2_.replace(_loc4_,">");
         param1 = new XML(_loc2_);
         for each(_loc5_ in param1.商品)
         {
            _loc6_ = Number(_loc5_.id);
            _loc7_ = Number(_loc5_.阶段);
            _loc8_ = String(_loc5_.名称);
            _loc9_ = Number(_loc5_.颜色);
            _loc10_ = Number(_loc5_.出售值);
            _loc11_ = String(_loc5_.数量);
            _loc12_ = Number(_loc5_.帧数);
            _loc13_ = String(_loc5_.等级);
            _loc14_ = Number(_loc5_.概率);
            _loc15_ = (_loc5_.是否id.toString() == "true") as Boolean;
            _loc16_ = (_loc5_.是否点卷.toString() == "true") as Boolean;
            _loc17_ = String(_loc5_.商品标识);
            _loc18_ = String(_loc5_.商品数量);
            _loc19_ = String(_loc5_.商品概率);
            _loc20_ = String(_loc5_.说明);
            _loc21_ = Number(_loc5_.商店id);
            _loc22_ = ShopBasicData.createShopBasicData(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc17_,_loc18_,_loc19_,_loc15_,_loc16_,_loc20_,_loc21_);
            shopDataList[_loc6_] = _loc22_;
            if(_loc22_.isDj())
            {
               shopList2[_loc6_] = _loc22_.createShop();
            }
            else
            {
               shopList1[_loc6_] = _loc22_.createShop();
            }
         }
      }
      
      public static function getDataById(param1:Number) : ShopBasicData
      {
         if(shopDataList[param1] != null)
         {
            return shopDataList[param1];
         }
         return null;
      }
      
      public static function getShopData(param1:Boolean, param2:Number, param3:Number) : Shop
      {
         if(param1)
         {
            return getShop(shopList2,param2,param3);
         }
         return getShop(shopList1,param2,param3);
      }
      
      private static function getShop(param1:Array, param2:Number, param3:Number) : Shop
      {
         var _loc6_:Shop = null;
         var _loc4_:Number = 0;
         var _loc5_:Array = [];
         if(param1.length == 0)
         {
            return null;
         }
         for each(_loc6_ in param1)
         {
            if(_loc6_ != null)
            {
               if(_loc6_.getjd() == param2)
               {
                  _loc5_.push(_loc6_);
               }
            }
         }
         if(_loc5_.length != 0)
         {
            for each(_loc6_ in _loc5_)
            {
               _loc4_ += _loc6_.cxGl();
               if(_loc4_ >= param3)
               {
                  return _loc6_;
               }
            }
            if(_loc4_ <= param3)
            {
               return null;
            }
         }
         return null;
      }
   }
}

