package hotpointgame.models.bag
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.jjia.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gsound.*;
   import hotpointgame.views.comPanel.*;
   import hotpointgame.views.insertPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.wmdPanel.*;
   
   public class BagFactory
   {
      
      public static var equipBag:Bag = Bag.creatBag();
      
      public static var gemBag:Bag = Bag.creatBag();
      
      public static var otherBag:Bag = Bag.creatBag();
      
      public static var clothesBag:Bag = Bag.creatBag();
      
      public static var equipSlot:EquipSlot = EquipSlot.createEquipSlot();
      
      public static var stSlot:StrengthenSlot = StrengthenSlot.createStrengSlot();
      
      public static var comSlot:ComSlot = ComSlot.createComSlot();
      
      public static var wmSlot:WmSlot = WmSlot.createWmSlot();
      
      public static var inSlot:InsertSlot = InsertSlot.createInsertSlot();
      
      public static var roomSlot:WareroomSlot = WareroomSlot.createEquipSlot();
      
      private static var openKeyBo:Boolean = false;
      
      private static var lqBo:Boolean = false;
      
      public function BagFactory()
      {
         super();
      }
      
      public static function backGoodsSI() : void
      {
         var _loc1_:Goods = null;
         var _loc3_:Number = NaN;
         if(stSlot.getGoods(0) != null)
         {
            _loc1_ = DeepCopyUtil.clone(stSlot.getGoods(0));
            stSlot.deleteBag(GS.a0,GS.a1);
            if(equipBag.getAirGirdNum() > 0)
            {
               equipBag.addInBag(_loc1_,GS.a1);
            }
            else
            {
               equipSlot.addToBag(_loc1_,_loc1_.getSmallType(),GS.a1);
            }
         }
         var _loc2_:uint = 0;
         while(_loc2_ < 3)
         {
            if(inSlot.getGoods(_loc2_) != null)
            {
               _loc1_ = DeepCopyUtil.clone(inSlot.getGoods(_loc2_));
               _loc3_ = inSlot.getGoodsNum(_loc2_);
               inSlot.deleteBag(_loc2_,_loc3_);
               if(_loc2_ == 0)
               {
                  if(equipBag.getAirGirdNum() > 0)
                  {
                     equipBag.addInBag(_loc1_,GS.a1);
                  }
                  else
                  {
                     equipSlot.addToBag(_loc1_,_loc1_.getSmallType(),GS.a1);
                  }
               }
               else if(_loc2_ == 1)
               {
                  gemBag.addInBag(_loc1_,_loc3_);
               }
               else if(_loc2_ == 2)
               {
                  otherBag.addInBag(_loc1_,_loc3_);
               }
            }
            _loc2_++;
         }
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["b1"] = equipBag.save();
         _loc1_["b2"] = gemBag.save();
         _loc1_["b3"] = otherBag.save();
         _loc1_["b4"] = clothesBag.save();
         _loc1_["b5"] = equipSlot.save();
         _loc1_["b6"] = stSlot.save();
         _loc1_["b7"] = inSlot.save();
         _loc1_["b8"] = comSlot.save();
         _loc1_["b9"] = roomSlot.save();
         _loc1_["b10"] = openKeyBo;
         _loc1_["b11"] = lqBo;
         _loc1_["b12"] = wmSlot.save();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         equipBag.readData(param1["b1"]);
         gemBag.readData(param1["b2"]);
         otherBag.readData(param1["b3"]);
         clothesBag.readData(param1["b4"]);
         equipSlot.readData(param1["b5"]);
         stSlot.readData(param1["b6"]);
         inSlot.readData(param1["b7"]);
         if(param1["b8"] != null)
         {
            comSlot.readData(param1["b8"]);
         }
         if(param1["b9"] != null)
         {
            roomSlot.readData(param1["b9"]);
         }
         if(param1["b12"] != null)
         {
            wmSlot.readData(param1["b12"]);
         }
         if(param1["b10"] != null)
         {
            openKeyBo = param1["b10"];
         }
         if(param1["b11"] != null)
         {
            lqBo = param1["b11"];
         }
         openOldBag();
         equipSlot.initYcread();
      }
      
      public static function initBag() : void
      {
         equipBag.initBag();
         gemBag.initBag();
         otherBag.initBag();
         clothesBag.initBag();
         equipSlot.initBag();
         equipSlot.initYc();
         stSlot.initBag();
         inSlot.initBag();
         comSlot.initBag();
         wmSlot.initBag();
         roomSlot.initBag();
         roomSlot.readGoldCurr(GS.a0);
         openKeyBo = false;
         lqBo = false;
      }
      
      public static function addInBagByGoods(param1:Goods, param2:Number, param3:Boolean) : void
      {
         switch(param1.getbagNum())
         {
            case 0:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,equipBag.addInBag(param1,param2),param1.getbagNum(),param3));
               break;
            case 1:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,gemBag.addInBag(param1,param2),param1.getbagNum(),param3));
               break;
            case 2:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,otherBag.addInBag(param1,param2),param1.getbagNum(),param3));
               break;
            case 3:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,clothesBag.addInBag(param1,param2),param1.getbagNum(),param3));
         }
      }
      
      public static function addToBag(param1:Goods, param2:Number, param3:Number, param4:Boolean) : void
      {
         switch(param1.getbagNum())
         {
            case 0:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,equipBag.addToBag(param1,param3,param2),param1.getbagNum(),param4));
               break;
            case 1:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,gemBag.addToBag(param1,param3,param2),param1.getbagNum(),param4));
               break;
            case 2:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,otherBag.addToBag(param1,param3,param2),param1.getbagNum(),param4));
               break;
            case 3:
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.DO_UPDATE,clothesBag.addToBag(param1,param3,param2),param1.getbagNum(),param4));
         }
      }
      
      public static function addInBagById(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:Goods = null;
         var _loc4_:Array = [];
         if(isFullById(param1,param2))
         {
            _loc5_ = 0;
            while(_loc5_ < param2)
            {
               _loc4_.push(GoodsFactory.createGoodsById(param1));
               _loc5_++;
            }
            if(_loc4_.length != 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = _loc4_[_loc5_] as Goods;
                  if(_loc6_.isStrengBo() != -1 && param3 != 0)
                  {
                     _loc6_.changeStrengByLevel(param3);
                  }
                  addInBagJk(_loc6_,GS.a1);
                  _loc5_++;
               }
            }
            return true;
         }
         return false;
      }
      
      public static function hdGoodsTs(param1:Number, param2:Number) : void
      {
         var _loc3_:Array = [param1];
         var _loc4_:Array = [param2];
         GoodsManger.tsManger("Ts_43",_loc3_,_loc4_);
         SoundManager.playOnlySound("mp_discovery");
      }
      
      public static function onlyBagOne() : Boolean
      {
         if(equipBag.getAirGirdNum() > GS.a0 && gemBag.getAirGirdNum() > GS.a0 && otherBag.getAirGirdNum() > GS.a0 && clothesBag.getAirGirdNum() > GS.a0)
         {
            return true;
         }
         return false;
      }
      
      public static function deteleGoods(param1:Number, param2:Number) : Boolean
      {
         if(GoodsFactory.getBagNum(param1) == 0)
         {
            return equipBag.deleteGoods(param1,param2);
         }
         if(GoodsFactory.getBagNum(param1) == 1)
         {
            return gemBag.deleteGoods(param1,param2);
         }
         if(GoodsFactory.getBagNum(param1) == 2)
         {
            return otherBag.deleteGoods(param1,param2);
         }
         if(GoodsFactory.getBagNum(param1) == 3)
         {
            return clothesBag.deleteGoods(param1,param2);
         }
         return false;
      }
      
      public static function deleteGoodsByBag(param1:Number, param2:Number) : Goods
      {
         if(GoodsFactory.getBagNum(param1) == 0)
         {
            return equipBag.deleteGs(param1,param2);
         }
         if(GoodsFactory.getBagNum(param1) == 1)
         {
            return gemBag.deleteGs(param1,param2);
         }
         if(GoodsFactory.getBagNum(param1) == 2)
         {
            return otherBag.deleteGs(param1,param2);
         }
         if(GoodsFactory.getBagNum(param1) == 3)
         {
            return clothesBag.deleteGs(param1,param2);
         }
         return null;
      }
      
      public static function deleteGoodsByEquipSlot(param1:Number, param2:Number) : Goods
      {
         return equipSlot.deleteGs(param1,param2);
      }
      
      public static function deleteGoodsByCk(param1:Number, param2:Number) : Goods
      {
         return roomSlot.deleteGs(param1,param2);
      }
      
      public static function deleteGoodsByAll(param1:Number, param2:Number) : Goods
      {
         var _loc3_:Goods = deleteGoodsByBag(param1,param2);
         if(_loc3_ == null)
         {
            _loc3_ = deleteGoodsByEquipSlot(param1,param2);
         }
         if(_loc3_ == null)
         {
            _loc3_ = deleteGoodsByCk(param1,param2);
         }
         return _loc3_;
      }
      
      public static function sjChFun(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Goods = null;
         if(param1 == GS.a0)
         {
            if(isFullById(param2,GS.a1))
            {
               addInBagById(param2,GS.a1,GS.a0);
               hdGoodsTs(param2,GS.a1);
               return true;
            }
         }
         else if(isFullById(param2,GS.a1))
         {
            _loc3_ = deleteGoodsByAll(param1,GS.a1);
            if(_loc3_ != null)
            {
               addInBagById(param2,GS.a1,_loc3_.getStrengLevel());
               hdGoodsTs(param2,GS.a1);
               return true;
            }
            addInBagById(param2,GS.a1,GS.a0);
            hdGoodsTs(param2,GS.a1);
            return true;
         }
         return false;
      }
      
      public static function deleteArrGoods(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            deteleGoods(param1[_loc3_],param2[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function deleteArrByRoom(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            roomSlot.deleteGoods(param1[_loc3_],param2[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function addInBagDL(param1:Goods, param2:Number) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(isFullBagOnlyOne(param1,param2))
         {
            addInBagJk(param1,param2);
            TaskData.isGoodsOk();
            _loc3_ = [param1.getId()];
            _loc4_ = [param2];
            GoodsManger.tsManger("Ts_43",_loc3_,_loc4_,100);
            TaskData.isGoodsOk(param1.getId());
            SoundManager.playOnlySound("mp_discovery");
            return true;
         }
         GoodsManger.cwTs("背包已满");
         return false;
      }
      
      public static function addInBagJk(param1:Goods, param2:Number) : void
      {
         switch(param1.getbagNum())
         {
            case 0:
               equipBag.addInBag(param1,param2);
               break;
            case 1:
               gemBag.addInBag(param1,param2);
               break;
            case 2:
               otherBag.addInBag(param1,param2);
               break;
            case 3:
               clothesBag.addInBag(param1,param2);
         }
      }
      
      public static function isFullById(param1:Number, param2:Number) : Boolean
      {
         if(GoodsFactory.getBagNum(param1) == 0 && equipBag.getSyNumById(param1) >= param2)
         {
            return true;
         }
         if(GoodsFactory.getBagNum(param1) == 1 && gemBag.getSyNumById(param1) >= param2)
         {
            return true;
         }
         if(GoodsFactory.getBagNum(param1) == 2 && otherBag.getSyNumById(param1) >= param2)
         {
            return true;
         }
         if(GoodsFactory.getBagNum(param1) == 3 && clothesBag.getSyNumById(param1) >= param2)
         {
            return true;
         }
         return false;
      }
      
      public static function isfullByRoom(param1:Goods, param2:Number) : Boolean
      {
         if(roomSlot.getSyNumById(param1.getId()) >= param2)
         {
            return true;
         }
         return false;
      }
      
      public static function isFullBagOnlyOne(param1:Goods, param2:Number) : Boolean
      {
         if(GoodsFactory.getBagNum(param1.getId()) == 0 && equipBag.getSyNumById(param1.getId()) >= param2)
         {
            return true;
         }
         if(GoodsFactory.getBagNum(param1.getId()) == 1 && gemBag.getSyNumById(param1.getId()) >= param2)
         {
            return true;
         }
         if(GoodsFactory.getBagNum(param1.getId()) == 2 && otherBag.getSyNumById(param1.getId()) >= param2)
         {
            return true;
         }
         if(GoodsFactory.getBagNum(param1.getId()) == 3 && clothesBag.getSyNumById(param1.getId()) >= param2)
         {
            return true;
         }
         return false;
      }
      
      public static function addSameInBag(param1:Array, param2:Array) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Goods = null;
         var _loc3_:Array = [];
         if(isFullBag(param1,param2))
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc5_ = 0;
               while(_loc5_ < param2[_loc4_])
               {
                  _loc3_.push(GoodsFactory.createGoodsById(param1[_loc4_]));
                  _loc5_++;
               }
               _loc4_++;
            }
            if(_loc3_.length != GS.a0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc6_ = _loc3_[_loc4_] as Goods;
                  addInBagJk(_loc6_,GS.a1);
                  TaskData.isGoodsOk(_loc6_.getId());
                  _loc4_++;
               }
               SoundManager.playOnlySound("mp_discovery");
               GoodsManger.tsManger("Ts_43",param1,param2);
            }
            return true;
         }
         GoodsManger.cwTs("背包已满");
         return false;
      }
      
      public static function addBagArr(param1:Array, param2:Array) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:Goods = null;
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = 0;
            while(_loc5_ < param2[_loc4_])
            {
               _loc3_.push(GoodsFactory.createGoodsById(param1[_loc4_]));
               _loc5_++;
            }
            _loc4_++;
         }
         if(_loc3_.length != GS.a0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc6_ = _loc3_[_loc4_] as Goods;
               addInBagJk(_loc6_,GS.a1);
               _loc4_++;
            }
            SoundManager.playOnlySound("mp_discovery");
            GoodsManger.tsManger("Ts_43",param1,param2);
         }
      }
      
      public static function addBagArrGoods(param1:Array, param2:Array) : void
      {
         var _loc4_:Goods = null;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_] as Goods;
            addInBagJk(_loc4_,param2[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function isFullBag(param1:Array, param2:Array) : Boolean
      {
         var _loc3_:Bag = DeepCopyUtil.clone(equipBag);
         var _loc4_:Bag = DeepCopyUtil.clone(gemBag);
         var _loc5_:Bag = DeepCopyUtil.clone(otherBag);
         var _loc6_:Bag = DeepCopyUtil.clone(clothesBag);
         var _loc7_:uint = 0;
         while(_loc7_ < param1.length)
         {
            if(GoodsFactory.getBagNum(param1[_loc7_]) == 0)
            {
               if(_loc3_.getSyNumById(param1[_loc7_]) < param2[_loc7_])
               {
                  return false;
               }
               _loc3_.addInBagXX(GoodsFactory.createGoodsById(param1[_loc7_]),param2[_loc7_]);
            }
            else if(GoodsFactory.getBagNum(param1[_loc7_]) == 1)
            {
               if(_loc4_.getSyNumById(param1[_loc7_]) < param2[_loc7_])
               {
                  return false;
               }
               _loc4_.addInBagXX(GoodsFactory.createGoodsById(param1[_loc7_]),param2[_loc7_]);
            }
            else if(GoodsFactory.getBagNum(param1[_loc7_]) == 2)
            {
               if(_loc5_.getSyNumById(param1[_loc7_]) < param2[_loc7_])
               {
                  return false;
               }
               _loc5_.addInBagXX(GoodsFactory.createGoodsById(param1[_loc7_]),param2[_loc7_]);
            }
            else if(GoodsFactory.getBagNum(param1[_loc7_]) == 3)
            {
               if(_loc6_.getSyNumById(param1[_loc7_]) < param2[_loc7_])
               {
                  return false;
               }
               _loc6_.addInBagXX(GoodsFactory.createGoodsById(param1[_loc7_]),param2[_loc7_]);
            }
            _loc7_++;
         }
         return true;
      }
      
      public static function getEquipMcName(param1:Number) : String
      {
         if(equipSlot.getGoods(param1) != null)
         {
            return equipSlot.getGoods(param1).getMcName();
         }
         return "";
      }
      
      public static function getEquipMcFrame(param1:Number) : int
      {
         if(equipSlot.getGoods(param1) != null)
         {
            return equipSlot.getGoods(param1).getFrame();
         }
         return 1;
      }
      
      public static function getEquipSlotId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ <= 16)
         {
            if(equipSlot.getGoods(_loc2_) != null)
            {
               if(_loc2_ == 0 || _loc2_ == 16 || _loc2_ == 1 || _loc2_ == 2 || _loc2_ == 5 || _loc2_ == 8 || _loc2_ == 10 || _loc2_ == 3 || _loc2_ == 11 || _loc2_ == 12)
               {
                  _loc1_.push(equipSlot.getGoods(_loc2_).getMcName());
               }
            }
            else if(FlowInterface.getJobByRole() == GS.a1)
            {
               if(_loc2_ == 1)
               {
                  _loc1_.push("e_kaijiachushi");
               }
               else if(_loc2_ == 2)
               {
                  _loc1_.push("e_yaodaichushi");
               }
               else if(_loc2_ == 5)
               {
                  _loc1_.push("e_huwanchushi");
               }
               else if(_loc2_ == 0)
               {
                  _loc1_.push("WuqiB_xinshouqiang");
               }
            }
            else if(FlowInterface.getJobByRole() == GS.a2)
            {
               if(_loc2_ == 1)
               {
                  _loc1_.push("e_wkaijiachushi");
               }
               else if(_loc2_ == 2)
               {
                  _loc1_.push("e_wyaodaichushi");
               }
               else if(_loc2_ == 5)
               {
                  _loc1_.push("e_whuwanchushi");
               }
               else if(_loc2_ == 0)
               {
                  _loc1_.push("WuqiB_xinshoupao");
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function isXg() : Boolean
      {
         if(equipBag.isKzDb() == false || gemBag.isKzDb() == false || otherBag.isKzDb() == false || clothesBag.isKzDb() == false || stSlot.isKzDb() == false || inSlot.isKzDb() == false && comSlot.isKzDb() == false && roomSlot.isKzDb() == false && wmSlot.isKzDb == false)
         {
            return true;
         }
         return false;
      }
      
      public static function isXgBo() : void
      {
         if(!equipBag.isXgBo() || !gemBag.isXgBo() || !otherBag.isXgBo() || !clothesBag.isXgBo())
         {
            FlowInterface.findCheat(GS.a103);
         }
      }
      
      public static function getFhbNum() : Number
      {
         return getNumById(GS.a511032) + getNumById(GS.a631000);
      }
      
      public static function getNumById(param1:Number) : Number
      {
         if(GoodsFactory.getBagNum(param1) == 0)
         {
            return equipBag.getGoodsNumById(param1);
         }
         if(GoodsFactory.getBagNum(param1) == 1)
         {
            return gemBag.getGoodsNumById(param1);
         }
         if(GoodsFactory.getBagNum(param1) == 2)
         {
            return otherBag.getGoodsNumById(param1);
         }
         if(GoodsFactory.getBagNum(param1) == 3)
         {
            return clothesBag.getGoodsNumById(param1);
         }
         return 0;
      }
      
      public static function deleteTimeGs() : void
      {
         equipBag.deleteTimerGs();
         gemBag.deleteTimerGs();
         otherBag.deleteTimerGs();
         clothesBag.deleteTimerGs();
         equipSlot.deleteTimerGs();
      }
      
      public static function deleteTimeRoom() : void
      {
         roomSlot.deleteTimerGs();
      }
      
      public static function bagOnlyGird() : Boolean
      {
         if(equipBag.getAirGirdNum() > GS.a0 && gemBag.getAirGirdNum() > GS.a0 && otherBag.getAirGirdNum() > GS.a0 && clothesBag.getAirGirdNum() > GS.a0)
         {
            return true;
         }
         return false;
      }
      
      public static function openOldBag() : void
      {
         if(!openKeyBo)
         {
            openKeyBo = true;
            equipBag.initKey();
            gemBag.initKey();
            otherBag.initKey();
            clothesBag.initKey();
            equipSlot.initKey();
            stSlot.initKey();
            comSlot.initKey();
            inSlot.initKey();
         }
      }
      
      public static function getShopG() : Number
      {
         return equipBag.getShopG() + gemBag.getShopG() + otherBag.getShopG() + clothesBag.getShopG() + equipSlot.getShopG() + roomSlot.getShopG();
      }
      
      public static function getGoodsMaxNum() : Array
      {
         var _loc2_:GoodsNumBasicData = null;
         var _loc3_:VT = null;
         var _loc1_:Array = GoodsFactory.goodsMaxList;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = VT.createVT(getNumxx(_loc2_.getGid()));
            if(_loc3_.getValue() >= _loc2_.getNum())
            {
               return [_loc2_.getGid(),_loc3_.getValue()];
            }
         }
         return [];
      }
      
      public static function getNumxx(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(GoodsFactory.getBagNum(param1) == 0)
         {
            _loc2_.setValue(getNumById(param1) + roomSlot.getGoodsNumById(param1) + equipSlot.getGoodsNumById(param1));
         }
         else
         {
            _loc2_.setValue(getNumById(param1) + roomSlot.getGoodsNumById(param1));
         }
         return _loc2_.getValue();
      }
      
      public static function bcLb() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         if(!lqBo)
         {
            _loc1_ = [VT.createVT(GS.a511060),VT.createVT(GS.a511060 + GS.a1),VT.createVT(GS.a511060 + GS.a2),VT.createVT(GS.a331119 + GS.a1),VT.createVT(GS.a331119 + GS.a2),VT.createVT(GS.a331119 + GS.a3),VT.createVT(GS.a331119 + GS.a4),VT.createVT(GS.a331119 + GS.a5),VT.createVT(GS.a331144 + GS.a1),VT.createVT(GS.a331144 + GS.a100 + GS.a35)];
            if(otherBag.getAirGirdNum() > GS.a0)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.length)
               {
                  if(getNumxx(_loc1_[_loc2_].getValue()) >= GS.a1)
                  {
                     lqBo = true;
                     GoodsManger.cwTs("你已经有新手礼包了，别太贪心");
                     FlowInterface.saveDataByKai();
                     return;
                  }
                  _loc2_++;
               }
               addInBagById(_loc1_[0].getValue(),GS.a1,GS.a0);
               hdGoodsTs(_loc1_[0].getValue(),GS.a1);
               GoodsManger.cwTs("恭喜，你已经获得了新手礼包");
               lqBo = true;
               FlowInterface.saveDataByKai();
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
         else
         {
            GoodsManger.cwTs("你已经有新手礼包了，别太贪心");
         }
      }
      
      public static function addJJExp(param1:Number) : void
      {
         var _loc4_:VT = null;
         var _loc2_:Array = [0,VT.createVT(GS.a25),VT.createVT(GS.a50),VT.createVT(GS.a75),VT.createVT(GS.a100)];
         var _loc3_:Goods = equipSlot.getGoods(GS.a7);
         if(_loc3_ != null)
         {
            if(_loc3_.getJjLv() < _loc2_[_loc3_.getJhLv()].getValue())
            {
               _loc3_.addJexp(param1);
               equipSlot.bfBag();
            }
            else
            {
               _loc4_ = VT.createVT(JjiaFactory.getDataByIdAndLv(_loc3_.getId(),_loc2_[_loc3_.getJhLv()].getValue()).getNeedExp());
               if(_loc3_.getJexp() != _loc4_.getValue())
               {
                  _loc3_.setJexp(_loc4_.getValue());
                  _loc3_.setjQl(_loc2_[_loc3_.getJhLv()].getValue() * GS.a5);
                  equipSlot.bfBag();
               }
            }
         }
      }
   }
}

