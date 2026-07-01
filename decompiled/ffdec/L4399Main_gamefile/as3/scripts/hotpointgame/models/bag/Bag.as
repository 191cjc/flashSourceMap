package hotpointgame.models.bag
{
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.*;
   
   public class Bag
   {
      
      protected var _bagArr:Array = [];
      
      protected var _bagNum:Number = 20;
      
      protected var _byte:ByteArray;
      
      protected var _keyNum:VT = VT.createVT(GS.a20);
      
      public function Bag()
      {
         super();
      }
      
      public static function creatBag() : Bag
      {
         var _loc1_:Bag = new Bag();
         _loc1_.initBag();
         return _loc1_;
      }
      
      public function save() : Object
      {
         var _loc3_:Gird = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         if(this.isKzDb())
         {
            for each(_loc3_ in this._bagArr)
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
            this.bfBag();
         }
         return _loc1_;
      }
      
      public function readData(param1:Object = null) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Gird = null;
         this._bagArr.length = 0;
         var _loc2_:Array = param1["bg"];
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != "null")
            {
               this._bagArr.push(Gird.readData(_loc3_));
            }
            else
            {
               this._bagArr.push(Gird.creatGird());
            }
         }
         if(this as EquipSlot)
         {
            if(EquipSlot.addEqSlotBo == false && this._bagArr.length < GS.a17)
            {
               EquipSlot.addEqSlotBo = true;
               _loc4_ = new Gird();
               (_loc4_ as Gird).openGird();
               this._bagArr.push(_loc4_);
            }
         }
         this.bfBag();
      }
      
      public function bfBag() : void
      {
         this.byte = new ByteArray();
         this.byte.writeObject(this._bagArr);
         this.byte.position = 0;
      }
      
      public function setBagNum(param1:Number) : void
      {
         this._bagNum = param1;
      }
      
      public function setKeyNum(param1:Number) : void
      {
         this.keyNum.setValue(param1);
      }
      
      public function initBag() : void
      {
         var _loc2_:Gird = null;
         this._bagArr.length = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < this._bagNum)
         {
            this._bagArr.push(Gird.creatGird());
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.keyNum.getValue())
         {
            _loc2_ = this._bagArr[_loc1_] as Gird;
            _loc2_.openGird();
            _loc1_++;
         }
         this.bfBag();
      }
      
      public function initKey() : void
      {
         var _loc2_:Gird = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.keyNum.getValue())
         {
            _loc2_ = this._bagArr[_loc1_] as Gird;
            _loc2_.openGird();
            _loc1_++;
         }
         this.bfBag();
      }
      
      public function getBagArr() : Array
      {
         return this._bagArr;
      }
      
      public function openBag(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Gird = null;
         if(param1 < GS.a1)
         {
            return;
         }
         if(param1 > this._bagNum)
         {
            param1 = this._bagNum;
         }
         if(this.isKzDb())
         {
            _loc2_ = 0;
            while(_loc2_ < this._bagNum)
            {
               _loc3_ = this._bagArr[_loc2_] as Gird;
               if(param1 > GS.a0)
               {
                  if(_loc3_.getKey() == -1)
                  {
                     _loc3_.openGird();
                     param1--;
                  }
               }
               _loc2_++;
            }
            this.bfBag();
         }
      }
      
      public function getNoKey() : Number
      {
         var _loc3_:Gird = null;
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:uint = 0;
         while(_loc2_ < this._bagNum)
         {
            _loc3_ = this._bagArr[_loc2_] as Gird;
            if(_loc3_.getKey() == -1)
            {
               _loc1_.setValue(_loc1_.getValue() + GS.a1);
            }
            _loc2_++;
         }
         return _loc1_.getValue();
      }
      
      private function getGirdNum(param1:Goods) : Number
      {
         var _loc4_:Gird = null;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this._bagNum)
         {
            _loc4_ = this._bagArr[_loc3_] as Gird;
            _loc2_ += _loc4_.getGirdNum(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getGirdOne(param1:Goods, param2:Number) : Number
      {
         var _loc3_:Gird = this._bagArr[param2] as Gird;
         return _loc3_.getGirdNum(param1);
      }
      
      public function getAirGirdNum() : Number
      {
         var _loc3_:Gird = null;
         var _loc1_:Number = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < this._bagNum)
         {
            _loc3_ = this._bagArr[_loc2_] as Gird;
            if(_loc3_.getKey() == GS.a0 && _loc3_.getGoods() == null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getSyNum(param1:Goods) : Number
      {
         if(param1.getOverlapping() == -1)
         {
            return this.getAirGirdNum();
         }
         return this.getGirdNum(param1);
      }
      
      public function getSyNumById(param1:Number) : Number
      {
         var _loc2_:Goods = GoodsFactory.createGoodsById(param1);
         if(_loc2_.getOverlapping() == -1)
         {
            return this.getAirGirdNum();
         }
         return this.getGirdNum(_loc2_);
      }
      
      public function isKzDb() : Boolean
      {
         var _loc3_:int = 0;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this._bagArr);
         _loc1_.position = 0;
         var _loc2_:uint = _loc1_.length;
         if(this.byte.length == _loc1_.length)
         {
            this.byte.position = 0;
            _loc1_.position = 0;
            while(_loc2_ - this.byte.position > 4)
            {
               if(this.byte.readInt() != _loc1_.readInt())
               {
                  return false;
               }
            }
            while(this.byte.position < _loc2_)
            {
               _loc3_ = this.byte.readByte();
               if(_loc3_ != _loc1_.readByte())
               {
                  return false;
               }
            }
            return true;
         }
         FlowInterface.findCheat(GS.a102);
         return false;
      }
      
      public function addInBagXX(param1:Goods, param2:Number) : Number
      {
         var _loc3_:Gird = null;
         var _loc5_:uint = 0;
         var _loc4_:VT = VT.createVT(param2);
         if(param1.getOverlapping() != -1 && this.getGirdNum(param1) >= _loc4_.getValue())
         {
            _loc5_ = 0;
            while(_loc5_ < this._bagNum)
            {
               _loc3_ = this._bagArr[_loc5_] as Gird;
               if(_loc3_.compareById(param1.getId()))
               {
                  if(_loc3_.getGirdNum(param1) > GS.a0)
                  {
                     if(_loc4_.getValue() > _loc3_.getGirdNum(param1))
                     {
                        _loc4_.setValue(_loc4_.getValue() - _loc3_.getGirdNum(param1));
                        _loc3_.addGoods(param1,_loc3_.getGirdNum(param1));
                     }
                     else if(_loc3_.addGoods(param1,_loc4_.getValue()))
                     {
                        return _loc5_;
                     }
                  }
               }
               _loc5_++;
            }
            if(_loc4_.getValue() > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < this._bagNum)
               {
                  _loc3_ = this._bagArr[_loc5_] as Gird;
                  if(_loc3_.getGirdNum(param1) > GS.a0)
                  {
                     if(_loc4_.getValue() > _loc3_.getGirdNum(param1))
                     {
                        _loc4_.setValue(_loc4_.getValue() - _loc3_.getGirdNum(param1));
                        _loc3_.addGoods(param1,_loc3_.getGirdNum(param1));
                     }
                     else if(_loc3_.addGoods(param1,_loc4_.getValue()))
                     {
                        return _loc5_;
                     }
                  }
                  _loc5_++;
               }
            }
         }
         else if(this.getAirGirdNum() >= _loc4_.getValue())
         {
            _loc5_ = 0;
            while(true)
            {
               if(_loc5_ < this._bagNum)
               {
                  _loc3_ = this._bagArr[_loc5_] as Gird;
                  if(_loc4_.getValue() > 0)
                  {
                     if(_loc3_.addGoods(param1,GS.a1))
                     {
                        _loc4_.setValue(_loc4_.getValue() - GS.a1);
                        if(_loc4_.getValue() == 0)
                        {
                           break;
                        }
                     }
                  }
                  continue;
               }
               _loc5_++;
            }
            return _loc5_;
         }
         return -1;
      }
      
      public function addInBag(param1:Goods, param2:Number) : Number
      {
         var _loc3_:Gird = null;
         var _loc4_:VT = null;
         var _loc5_:uint = 0;
         if(this.isKzDb())
         {
            _loc4_ = VT.createVT(param2);
            if(param1.getOverlapping() != -1 && this.getGirdNum(param1) >= _loc4_.getValue())
            {
               _loc5_ = 0;
               while(_loc5_ < this._bagNum)
               {
                  _loc3_ = this._bagArr[_loc5_] as Gird;
                  if(_loc3_.compareById(param1.getId()))
                  {
                     if(_loc3_.getGirdNum(param1) > GS.a0)
                     {
                        if(_loc4_.getValue() > _loc3_.getGirdNum(param1))
                        {
                           _loc4_.setValue(_loc4_.getValue() - _loc3_.getGirdNum(param1));
                           _loc3_.addGoods(param1,_loc3_.getGirdNum(param1));
                           this.bfBag();
                        }
                        else if(_loc3_.addGoods(param1,_loc4_.getValue()))
                        {
                           this.bfBag();
                           return _loc5_;
                        }
                     }
                  }
                  _loc5_++;
               }
               if(_loc4_.getValue() > 0)
               {
                  _loc5_ = 0;
                  while(_loc5_ < this._bagNum)
                  {
                     _loc3_ = this._bagArr[_loc5_] as Gird;
                     if(_loc3_.getGirdNum(param1) > GS.a0)
                     {
                        if(_loc4_.getValue() > _loc3_.getGirdNum(param1))
                        {
                           _loc4_.setValue(_loc4_.getValue() - _loc3_.getGirdNum(param1));
                           _loc3_.addGoods(param1,_loc3_.getGirdNum(param1));
                           this.bfBag();
                        }
                        else if(_loc3_.addGoods(param1,_loc4_.getValue()))
                        {
                           this.bfBag();
                           return _loc5_;
                        }
                     }
                     _loc5_++;
                  }
               }
            }
            else if(this.getAirGirdNum() >= _loc4_.getValue())
            {
               _loc5_ = 0;
               while(true)
               {
                  if(_loc5_ < this._bagNum)
                  {
                     _loc3_ = this._bagArr[_loc5_] as Gird;
                     if(_loc4_.getValue() > GS.a0)
                     {
                        if(_loc3_.addGoods(param1,GS.a1))
                        {
                           _loc4_.setValue(_loc4_.getValue() - GS.a1);
                           this.bfBag();
                           if(_loc4_.getValue() == GS.a0)
                           {
                              break;
                           }
                        }
                     }
                     continue;
                  }
                  _loc5_++;
               }
               return _loc5_;
            }
         }
         return -1;
      }
      
      public function getGoodsNumById(param1:Number) : Number
      {
         var _loc4_:Gird = null;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this._bagNum)
         {
            _loc4_ = this._bagArr[_loc3_] as Gird;
            if(_loc4_.compareById(param1))
            {
               _loc2_ += _loc4_.getGoodsNum();
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addToBag(param1:Goods, param2:Number, param3:Number) : Number
      {
         var _loc4_:Gird = null;
         if(this.isKzDb())
         {
            _loc4_ = this._bagArr[param2] as Gird;
            if(_loc4_.addGoods(param1,param3))
            {
               this.bfBag();
               return param2;
            }
         }
         return -1;
      }
      
      public function changeGird(param1:Gird, param2:Number, param3:Number) : void
      {
         var _loc4_:Gird = null;
         if(this.isKzDb())
         {
            _loc4_ = DeepCopyUtil.clone(this._bagArr[param3]);
            if(_loc4_.getKey() == GS.a0)
            {
               this._bagArr[param3] = param1;
               this._bagArr[param2] = _loc4_;
               this.bfBag();
            }
         }
      }
      
      public function deleteGoods(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:Gird = null;
         if(this.isKzDb())
         {
            _loc3_ = param2;
            if(this.getGoodsNumById(param1) >= param2)
            {
               _loc4_ = 0;
               while(_loc4_ < this._bagNum)
               {
                  _loc5_ = this._bagArr[_loc4_] as Gird;
                  if(_loc5_.compareById(param1))
                  {
                     if(_loc5_.getGoodsNum() >= _loc3_)
                     {
                        if(_loc5_.deleteGoods(_loc3_))
                        {
                           this.bfBag();
                           return true;
                        }
                     }
                     else
                     {
                        _loc3_ -= _loc5_.getGoodsNum();
                        _loc5_.deleteGoods(_loc5_.getGoodsNum());
                        this.bfBag();
                     }
                  }
                  _loc4_++;
               }
            }
         }
         return false;
      }
      
      public function deleteGs(param1:Number, param2:Number) : Goods
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:Gird = null;
         var _loc6_:Goods = null;
         if(this.isKzDb())
         {
            _loc3_ = param2;
            if(this.getGoodsNumById(param1) >= param2)
            {
               _loc4_ = 0;
               while(_loc4_ < this._bagNum)
               {
                  _loc5_ = this._bagArr[_loc4_] as Gird;
                  if(_loc5_.compareById(param1))
                  {
                     if(_loc5_.getGoodsNum() >= _loc3_)
                     {
                        _loc6_ = DeepCopyUtil.clone(_loc5_.getGoods());
                        if(_loc5_.deleteGoods(_loc3_))
                        {
                           this.bfBag();
                           return _loc6_;
                        }
                     }
                     else
                     {
                        _loc3_ -= _loc5_.getGoodsNum();
                        _loc5_.deleteGoods(_loc5_.getGoodsNum());
                        this.bfBag();
                     }
                  }
                  _loc4_++;
               }
            }
         }
         return null;
      }
      
      public function deleteBag(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Gird = null;
         if(this.isKzDb())
         {
            _loc3_ = this._bagArr[param1] as Gird;
            if(_loc3_.deleteGoods(param2))
            {
               this.bfBag();
               return true;
            }
         }
         return false;
      }
      
      public function deleteBagBack(param1:Number, param2:Number) : Goods
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         if(this.isKzDb())
         {
            _loc3_ = this._bagArr[param1] as Gird;
            _loc4_ = DeepCopyUtil.clone(_loc3_.getGoods());
            if(_loc3_.deleteGoods(param2))
            {
               this.bfBag();
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getGird(param1:Number) : Gird
      {
         return this._bagArr[param1] as Gird;
      }
      
      public function getGoods(param1:Number) : Goods
      {
         var _loc2_:Gird = this._bagArr[param1] as Gird;
         return _loc2_.getGoods();
      }
      
      public function getGoodsNum(param1:Number) : Number
      {
         var _loc2_:Gird = this._bagArr[param1] as Gird;
         return _loc2_.getGoodsNum();
      }
      
      public function addNewBag(param1:Array) : Boolean
      {
         var _loc2_:uint = 0;
         if(this.isKzDb())
         {
            this._bagArr = [];
            this.initBag();
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this._bagArr[_loc2_] = param1[_loc2_];
               _loc2_++;
            }
            this.bfBag();
            return true;
         }
         return false;
      }
      
      public function isXgBo() : Boolean
      {
         var _loc2_:Gird = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._bagNum)
         {
            _loc2_ = this._bagArr[_loc1_] as Gird;
            if(_loc2_.getGoods() != null)
            {
               if(_loc2_.getGoods().getOverlapping() == -1)
               {
                  if(_loc2_.getGoodsNum() > GS.a1)
                  {
                     return false;
                  }
               }
               else if(_loc2_.getGoodsNum() > _loc2_.getGoods().getOverlapping())
               {
                  return false;
               }
            }
            _loc1_++;
         }
         return true;
      }
      
      public function deleteTimerGs() : void
      {
         var _loc2_:Gird = null;
         var _loc3_:Goods = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._bagArr.length)
         {
            _loc2_ = this._bagArr[_loc1_] as Gird;
            if(_loc2_.getGoods() != null)
            {
               _loc3_ = _loc2_.getGoods();
               if(_loc3_.getOverTimer() != -1)
               {
                  if(_loc3_.getCurrOverTimer() <= GS.a0)
                  {
                     this.deleteBag(_loc1_,_loc2_.getGoodsNum());
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public function getShopG() : Number
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:uint = 0;
         while(_loc2_ < this._bagArr.length)
         {
            _loc3_ = this._bagArr[_loc2_] as Gird;
            if(_loc3_.getGoods() != null)
            {
               _loc4_ = _loc3_.getGoods();
               if(_loc4_.getShopG() != -1)
               {
                  _loc1_.setValue(_loc1_.getValue() + _loc3_.getGoodsNum() * _loc4_.getShopG());
               }
            }
            _loc2_++;
         }
         return _loc1_.getValue();
      }
      
      public function get bagArr() : Array
      {
         return this._bagArr;
      }
      
      public function set bagArr(param1:Array) : void
      {
         this._bagArr = param1;
      }
      
      public function get bagNum() : Number
      {
         return this._bagNum;
      }
      
      public function set bagNum(param1:Number) : void
      {
         this._bagNum = param1;
      }
      
      public function get byte() : ByteArray
      {
         return this._byte;
      }
      
      public function set byte(param1:ByteArray) : void
      {
         this._byte = param1;
      }
      
      public function get keyNum() : VT
      {
         return this._keyNum;
      }
      
      public function set keyNum(param1:VT) : void
      {
         this._keyNum = param1;
      }
   }
}

