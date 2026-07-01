package hotpointgame.views.shopPanel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.shop.*;
   import hotpointgame.repository.shop.*;
   
   public class ShopData
   {
      
      public static var dataArr1:Array = [];
      
      public static var dataArr2:Array = [];
      
      public static var gArr1:Array = [];
      
      public static var gArr2:Array = [];
      
      public static var timerNum:VT = VT.createVT(GS.a1800);
      
      public static var saveTimer:VT = VT.createVT(GS.a1800000);
      
      public static var shopDate:VT = VT.createVT(-1);
      
      public static var currentDate:VT = VT.createVT(-1);
      
      public static var newShopBo:Boolean = false;
      
      public static var sxTimes:VT = VT.createVT(0);
      
      public static var sxAllTimes:VT = VT.createVT(27);
      
      public static var spMy:Array = [VT.createVT(100),VT.createVT(90),VT.createVT(90),VT.createVT(80),VT.createVT(80),VT.createVT(70),VT.createVT(70),VT.createVT(70),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60),VT.createVT(60)];
      
      public static var spIdArr:Array = [VT.createVT(284),VT.createVT(285),VT.createVT(286),VT.createVT(287),VT.createVT(288),VT.createVT(289),VT.createVT(290),VT.createVT(291),VT.createVT(292),VT.createVT(293),VT.createVT(294),VT.createVT(295),VT.createVT(296),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297),VT.createVT(297)];
      
      public function ShopData()
      {
         super();
      }
      
      public static function getShopId(param1:Number) : Number
      {
         return spIdArr[param1].getValue();
      }
      
      public static function getShopGold(param1:Number) : Number
      {
         return spMy[param1].getValue();
      }
      
      public static function initShopTime(param1:Number) : void
      {
         if(shopDate.getValue() == -1)
         {
            shopDate.setValue(param1);
         }
      }
      
      public static function save() : Object
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < gArr1.length)
         {
            _loc2_.push(gArr1[_loc4_].getValue());
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < gArr2.length)
         {
            _loc3_.push(gArr2[_loc4_].getValue());
            _loc4_++;
         }
         _loc1_["g1"] = _loc2_.slice();
         _loc1_["g2"] = _loc3_.slice();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         for each(_loc7_ in dataArr1)
         {
            if(_loc7_ != null)
            {
               _loc5_.push((_loc7_ as Shop).getId());
            }
            else
            {
               _loc5_.push(-1);
            }
         }
         for each(_loc8_ in dataArr2)
         {
            if(_loc8_ != null)
            {
               _loc6_.push((_loc8_ as Shop).getId());
            }
            else
            {
               _loc6_.push(-1);
            }
         }
         _loc1_["s1"] = _loc5_;
         _loc1_["s2"] = _loc6_;
         _loc1_["ts"] = sxTimes.getValue();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         var _loc7_:Number = NaN;
         clearData();
         var _loc2_:Array = param1["g1"];
         var _loc3_:Array = param1["g2"];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            gArr1.push(VT.createVT(_loc2_[_loc4_]));
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            gArr2.push(VT.createVT(_loc3_[_loc4_]));
            _loc4_++;
         }
         var _loc5_:Array = param1["s1"];
         var _loc6_:Array = param1["s2"];
         if(param1["ts"] != null)
         {
            sxTimes.setValue(param1["ts"]);
         }
         for each(_loc7_ in _loc5_)
         {
            if(_loc7_ != -1)
            {
               dataArr1.push(Shop.createShop(_loc7_));
            }
            else
            {
               dataArr1.push(null);
            }
         }
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_ != -1)
            {
               dataArr2.push(Shop.createShop(_loc7_));
            }
            else
            {
               dataArr2.push(null);
            }
         }
      }
      
      public static function evClear() : void
      {
         sxTimes.setValue(0);
      }
      
      public static function initGArr() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 9)
         {
            gArr1[_loc1_] = VT.createVT(0);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            gArr2[_loc1_] = VT.createVT(0);
            _loc1_++;
         }
      }
      
      public static function initData() : void
      {
         var _loc1_:uint = 0;
         initGArr();
         clearData();
         var _loc2_:uint = 0;
         while(_loc2_ < 9)
         {
            _loc1_ = Math.floor(Math.random() * GS.a10000);
            dataArr1.push(ShopGoodsFactory.getShopData(false,getJd(),_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = Math.floor(Math.random() * GS.a10000);
            dataArr2.push(ShopGoodsFactory.getShopData(true,getJd(),_loc1_));
            _loc2_++;
         }
         newShopBo = true;
      }
      
      public static function clearData() : void
      {
         dataArr1.length = 0;
         dataArr2.length = 0;
      }
      
      public static function closeData() : void
      {
         dataArr1.length = 0;
         dataArr2.length = 0;
         gArr1.length = 0;
         gArr2.length = 0;
         timerNum.setValue(GS.a1800);
         currentDate.setValue(-1);
         shopDate.setValue(-1);
         sxTimes.setValue(0);
      }
      
      public static function getJd() : Number
      {
         if(FlowInterface.getLevelByRole() >= GS.a1 && FlowInterface.getLevelByRole() <= GS.a15)
         {
            return GS.a1;
         }
         if(FlowInterface.getLevelByRole() >= GS.a16 && FlowInterface.getLevelByRole() <= GS.a35)
         {
            return GS.a2;
         }
         if(FlowInterface.getLevelByRole() >= GS.a36 && FlowInterface.getLevelByRole() <= GS.a55)
         {
            return GS.a3;
         }
         if(FlowInterface.getLevelByRole() >= GS.a56 && FlowInterface.getLevelByRole() <= GS.a80)
         {
            return GS.a4;
         }
         return 1;
      }
      
      public static function getNewShop() : Boolean
      {
         return newShopBo;
      }
   }
}

