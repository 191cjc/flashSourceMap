package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   import hotpointgame.models.unionShop.*;
   import hotpointgame.repository.unionVip.*;
   
   public class UnPanelShopData
   {
      
      private var level:VT;
      
      private var shopList:Array = [];
      
      private var currentList:Array = [];
      
      public function UnPanelShopData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : UnPanelShopData
      {
         var _loc3_:uint = 0;
         var _loc2_:UnPanelShopData = new UnPanelShopData();
         if(param1 != null)
         {
            _loc2_.level = VT.createVT(param1["lv"]);
            _loc2_.shopList.length = GS.a0;
            _loc3_ = 0;
            while(_loc3_ < param1["da"].length)
            {
               _loc2_.shopList.push(UnionShop.read(param1["da"][_loc3_]));
               _loc3_++;
            }
         }
         else
         {
            _loc2_.level = VT.createVT(GS.a1);
            _loc2_.shopList.length = GS.a0;
         }
         _loc2_.currentList.length = GS.a0;
         return _loc2_;
      }
      
      public function initData() : void
      {
         this.level.setValue(GS.a1);
         this.shopList.length = GS.a0;
      }
      
      public function save() : Object
      {
         var _loc3_:UnionShop = null;
         var _loc1_:Object = new Object();
         _loc1_["lv"] = this.level.getValue();
         var _loc2_:Array = [];
         for each(_loc3_ in this.shopList)
         {
            _loc2_.push(_loc3_.save());
         }
         _loc1_["da"] = _loc2_;
         return _loc1_;
      }
      
      public function getShopByKey(param1:Number) : UnionShop
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.currentList.length)
         {
            if(this.currentList[param1] != null)
            {
               return this.currentList[param1];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getCurrShopList(param1:Number, param2:Number = 6) : Array
      {
         this.currentList.length = GS.a0;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            this.currentList.push(this.shopList[(param1 - 1) * param2 + _loc3_]);
            _loc3_++;
         }
         return this.currentList;
      }
      
      public function getAllYe() : Number
      {
         var _loc1_:Number = Number(this.shopList.length);
         var _loc2_:Number = int(_loc1_ / 6);
         if(_loc1_ % 6 > 0)
         {
            _loc2_ += 1;
         }
         return _loc2_;
      }
      
      public function getLevel() : Number
      {
         return this.level.getValue();
      }
      
      public function isChangeLevel(param1:Number) : void
      {
         if(this.shopList.length != GS.a0)
         {
            if(param1 > this.level.getValue())
            {
               this.level.setValue(param1);
               this.shopList = UnionVipFactory.getShopByLv(this.level.getValue());
            }
         }
         else
         {
            this.shopList = UnionVipFactory.getShopByLv(this.level.getValue());
         }
      }
      
      public function clearEv() : void
      {
         var _loc1_:UnionShop = null;
         for each(_loc1_ in this.shopList)
         {
            _loc1_.setTimes(GS.a0);
         }
      }
   }
}

