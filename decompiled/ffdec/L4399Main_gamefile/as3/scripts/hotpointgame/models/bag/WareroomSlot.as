package hotpointgame.models.bag
{
   import hotpointgame.common.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.*;
   import hotpointgame.views.vipPanel.*;
   
   public class WareroomSlot extends Bag
   {
      
      private var roomBag:Array = [];
      
      private var goldMax:VT = VT.createVT(GS.a12);
      
      private var goldCurr:VT = VT.createVT(0);
      
      public var addBo:VT = VT.createVT(GS.a0);
      
      public function WareroomSlot()
      {
         super();
      }
      
      public static function createEquipSlot() : WareroomSlot
      {
         var _loc1_:WareroomSlot = new WareroomSlot();
         _loc1_.setBagNum(GS.a100 + GS.a50);
         _loc1_.setKeyNum(GS.a31);
         _loc1_.initBag();
         _loc1_.initSmallBag();
         return _loc1_;
      }
      
      override public function save() : Object
      {
         var _loc3_:Gird = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         if(isKzDb())
         {
            for each(_loc3_ in _bagArr)
            {
               if(_loc3_.getGoods() != null || _loc3_.getKey() == GS.a0)
               {
                  _loc2_.push(_loc3_.save());
               }
               else
               {
                  _loc2_.push("null");
               }
            }
            _loc1_["bg"] = _loc2_;
            _loc1_["ad"] = this.addBo.getValue();
            bfBag();
         }
         return _loc1_;
      }
      
      override public function readData(param1:Object = null) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         bagArr.length = 0;
         var _loc2_:Array = param1["bg"];
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != "null")
            {
               bagArr.push(Gird.readData(_loc3_));
            }
            else
            {
               bagArr.push(Gird.creatGird());
            }
         }
         if(param1["ad"] == null)
         {
            _loc4_ = 0;
            while(_loc4_ < GS.a60)
            {
               bagArr.push(Gird.creatGird());
               _loc4_++;
            }
            bfBag();
            openBag(GS.a30);
         }
         bfBag();
      }
      
      public function initSmallBag() : void
      {
         this.roomBag.length = 0;
         var _loc1_:Array = DeepCopyUtil.clone(getBagArr());
         var _loc2_:uint = 0;
         while(_loc2_ < 5)
         {
            this.roomBag.push(_loc1_.splice(0,GS.a30));
            _loc2_++;
         }
      }
      
      public function getSmallBagByState(param1:Number) : Array
      {
         return this.roomBag[param1];
      }
      
      public function zhenliFunction() : Boolean
      {
         var _loc5_:Goods = null;
         var _loc9_:Gird = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Gird = null;
         var _loc13_:Object = null;
         var _loc1_:Array = DeepCopyUtil.clone(getBagArr());
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc1_.length)
         {
            _loc12_ = _loc1_[_loc8_] as Gird;
            _loc5_ = _loc12_.getGoods();
            if(_loc5_ != null)
            {
               _loc2_.push(_loc12_);
            }
            else if(_loc12_.getKey() == GS.a0)
            {
               _loc6_.push(_loc12_);
            }
            else if(_loc12_.getKey() == -1)
            {
               _loc7_.push(_loc12_);
            }
            _loc8_++;
         }
         for each(_loc9_ in _loc2_)
         {
            _loc5_ = _loc9_.getGoods();
            _loc13_ = {
               "girdObj":_loc9_,
               "类型":_loc5_.getType(),
               "小类型":_loc5_.getSmallType(),
               "等级":_loc5_.getUseLevel(),
               "颜色":_loc5_.getColor()
            };
            _loc3_.push(_loc13_);
         }
         _loc10_ = ["类型","小类型","等级","颜色"];
         _loc11_ = [Array.NUMERIC,Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC];
         _loc3_.sortOn(_loc10_,_loc11_);
         _loc8_ = 0;
         while(_loc8_ < _loc3_.length)
         {
            _loc4_.push(_loc3_[_loc8_].girdObj as Gird);
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc4_.push(_loc6_[_loc8_] as Gird);
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc4_.push(_loc7_[_loc8_] as Gird);
            _loc8_++;
         }
         return addNewBag(_loc4_);
      }
      
      public function getGoldMax() : Number
      {
         this.goldMax.setValue(GS.a12);
         if(VipData.vip.getValue() != -1)
         {
            if(VipData.vip.getValue() == GS.a1)
            {
               this.goldMax.setValue(this.goldMax.getValue() + GS.a5);
            }
            else
            {
               this.goldMax.setValue(this.goldMax.getValue() + GS.a10);
            }
         }
         return this.goldMax.getValue();
      }
      
      public function getGoldCurr() : Number
      {
         return this.goldCurr.getValue();
      }
      
      public function setGoldCurr(param1:Number) : void
      {
         this.goldCurr.setValue(this.goldCurr.getValue() + param1);
      }
      
      public function readGoldCurr(param1:Number) : void
      {
         this.goldCurr.setValue(param1);
      }
      
      public function getGoldSx() : Number
      {
         if(this.getGoldMax() - this.getGoldCurr() < getNoKey())
         {
            return this.getGoldMax() - this.getGoldCurr();
         }
         return getNoKey();
      }
   }
}

