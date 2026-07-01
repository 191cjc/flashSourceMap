package hotpointgame.pet
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   import hotpointgame.repository.strengthen.*;
   
   public class PetBag extends Bag
   {
      
      private var hp:VT = VT.createVT(0);
      
      private var nl:VT = VT.createVT(0);
      
      private var att:VT = VT.createVT(0);
      
      private var fy:VT = VT.createVT(0);
      
      private var sp:VT = VT.createVT(0);
      
      private var hp_b:VT = VT.createVT(1);
      
      private var nl_b:VT = VT.createVT(1);
      
      private var att_b:VT = VT.createVT(1);
      
      private var fy_b:VT = VT.createVT(1);
      
      private var bj_b:VT = VT.createVT(1);
      
      private var jin:VT = VT.createVT(0);
      
      private var mu:VT = VT.createVT(0);
      
      private var shui:VT = VT.createVT(0);
      
      private var huo:VT = VT.createVT(0);
      
      private var tu:VT = VT.createVT(0);
      
      private var hd:VT = VT.createVT(0);
      
      private var skillList:Array = [];
      
      private var zdl:VT = VT.createVT(GS.a0);
      
      public function PetBag()
      {
         super();
      }
      
      public static function createPetBag() : PetBag
      {
         var _loc1_:PetBag = new PetBag();
         _loc1_.setBagNum(16);
         _loc1_.setKeyNum(16);
         _loc1_.initBag();
         return _loc1_;
      }
      
      public static function readPetBag(param1:Object = null) : PetBag
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc2_:PetBag = new PetBag();
         if(param1 != null)
         {
            _loc2_._bagArr.length = 0;
            _loc3_ = param1["bg"];
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ != "null")
               {
                  _loc2_._bagArr.push(Gird.readData(_loc4_));
               }
               else
               {
                  _loc2_._bagArr.push(Gird.creatGird());
               }
            }
         }
         else
         {
            _loc2_.setBagNum(16);
            _loc2_.setKeyNum(16);
            _loc2_.initBag();
         }
         _loc2_.bfBag();
         return _loc2_;
      }
      
      public function getSkillList() : Array
      {
         return this.skillList;
      }
      
      public function getHp(param1:Number = 0) : Number
      {
         if(param1 == GS.a0)
         {
            return this.hp.getValue();
         }
         return this.hp_b.getValue();
      }
      
      public function getNl(param1:Number = 0) : Number
      {
         if(param1 == GS.a0)
         {
            return this.nl.getValue();
         }
         return this.nl_b.getValue();
      }
      
      public function getAtt(param1:Number = 0) : Number
      {
         if(param1 == GS.a0)
         {
            return this.att.getValue();
         }
         return this.att_b.getValue();
      }
      
      public function getFy(param1:Number = 0) : Number
      {
         if(param1 == GS.a0)
         {
            return this.fy.getValue();
         }
         return this.fy_b.getValue();
      }
      
      public function getBj() : Number
      {
         return this.bj_b.getValue();
      }
      
      public function getSp() : Number
      {
         return this.sp.getValue();
      }
      
      public function getJin() : Number
      {
         return this.jin.getValue();
      }
      
      public function getMu() : Number
      {
         return this.mu.getValue();
      }
      
      public function getShui() : Number
      {
         return this.shui.getValue();
      }
      
      public function getHuo() : Number
      {
         return this.huo.getValue();
      }
      
      public function getTu() : Number
      {
         return this.tu.getValue();
      }
      
      public function getHd() : Number
      {
         return this.hd.getValue();
      }
      
      public function getSuitEquiping(param1:Number) : Number
      {
         var _loc4_:Gird = null;
         var _loc5_:Goods = null;
         var _loc2_:VT = VT.createVT(0);
         var _loc3_:uint = 0;
         while(_loc3_ < bagArr.length)
         {
            _loc4_ = bagArr[_loc3_] as Gird;
            if(_loc4_.getGoods() != null)
            {
               _loc5_ = _loc4_.getGoods();
               if(_loc5_.getSuiteId() == param1)
               {
                  _loc2_.setValue(_loc2_.getValue() + GS.a1);
               }
            }
            _loc3_++;
         }
         return _loc2_.getValue();
      }
      
      public function isInEquipSlotByName(param1:String) : Boolean
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc2_:uint = 0;
         while(_loc2_ < bagArr.length)
         {
            _loc3_ = bagArr[_loc2_] as Gird;
            if(_loc3_.getGoods() != null)
            {
               _loc4_ = _loc3_.getGoods();
               if(_loc4_.getName() == param1)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      private function getGdSxValue(param1:Number, param2:uint) : Number
      {
         var _loc4_:BasicSx = null;
         var _loc8_:Gird = null;
         var _loc9_:Goods = null;
         var _loc10_:uint = 0;
         var _loc3_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:VT = VT.createVT(0);
         var _loc7_:uint = 0;
         while(_loc7_ < bagArr.length)
         {
            _loc8_ = bagArr[_loc7_] as Gird;
            if(_loc8_.getGoods() != null)
            {
               _loc9_ = _loc8_.getGoods();
               if(_loc9_.getFixAtSx() != null)
               {
                  _loc3_ = _loc9_.getFixAtSx();
                  _loc5_ = _loc9_.getGdBo();
                  _loc10_ = 0;
                  while(_loc10_ < _loc3_.length)
                  {
                     _loc4_ = _loc3_[_loc10_] as BasicSx;
                     if(_loc4_.getSxType() == param1 && _loc5_[param1 - 1] == param2)
                     {
                        if(param1 == 1 || param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5)
                        {
                           _loc6_.setValue(_loc6_.getValue() + _loc4_.getValue() + _loc4_.getValue() * _loc9_.getWmLevel() * GS.a5 / GS.a100);
                        }
                        else
                        {
                           _loc6_.setValue(_loc6_.getValue() + _loc4_.getValue());
                        }
                        break;
                     }
                     _loc10_++;
                  }
               }
            }
            _loc7_++;
         }
         return _loc6_.getValue();
      }
      
      private function getWxKxValue(param1:Number, param2:uint) : Number
      {
         var _loc3_:BasicSx = null;
         var _loc6_:Gird = null;
         var _loc7_:Goods = null;
         var _loc4_:VT = VT.createVT(0);
         var _loc5_:uint = 0;
         while(_loc5_ < bagArr.length)
         {
            _loc6_ = bagArr[_loc5_] as Gird;
            if(_loc6_.getGoods() != null)
            {
               _loc7_ = _loc6_.getGoods();
               if(_loc7_.getFiveSx() != null && _loc7_.getWxBo() == param2)
               {
                  _loc3_ = _loc7_.getFiveSx();
                  if(_loc3_.getSxType() == param1)
                  {
                     _loc4_.setValue(_loc4_.getValue() + _loc3_.getValue());
                  }
               }
            }
            _loc5_++;
         }
         return _loc4_.getValue();
      }
      
      public function isEquip() : Boolean
      {
         var _loc2_:Gird = null;
         var _loc1_:uint = 0;
         while(_loc1_ < bagArr.length)
         {
            _loc2_ = bagArr[_loc1_] as Gird;
            if(_loc2_.getGoods() != null)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function getStrValue(param1:Number, param2:uint) : Number
      {
         var _loc5_:Gird = null;
         var _loc6_:Goods = null;
         var _loc3_:VT = VT.createVT(0);
         var _loc4_:uint = 0;
         while(_loc4_ < bagArr.length)
         {
            _loc5_ = bagArr[_loc4_] as Gird;
            if(_loc5_.getGoods() != null)
            {
               _loc6_ = _loc5_.getGoods();
               if(param1 == 3 && param2 == GS.a0 && _loc6_.getSmallType() == 0 && _loc6_.getSmallType() != 3 && _loc6_.getSmallType() != 7 && _loc6_.isStrengBo() != -1 && _loc6_.getStrengLevel() != 0)
               {
                  _loc3_.setValue(StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()));
               }
               else if(param1 == 4 && param2 == GS.a0 && _loc6_.getSmallType() != 0 && _loc6_.getSmallType() != 3 && _loc6_.getSmallType() != 7 && _loc6_.isStrengBo() != -1 && _loc6_.getStrengLevel() != 0)
               {
                  _loc3_.setValue(_loc3_.getValue() + StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()));
               }
            }
            _loc4_++;
         }
         return _loc3_.getValue();
      }
      
      private function getGemValue(param1:Number, param2:uint) : Number
      {
         var _loc3_:BasicSx = null;
         var _loc6_:Gird = null;
         var _loc7_:Goods = null;
         var _loc8_:EquipGemSlot = null;
         var _loc9_:Number = NaN;
         var _loc10_:uint = 0;
         var _loc11_:Goods = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:uint = 0;
         var _loc4_:VT = VT.createVT(0);
         var _loc5_:uint = 0;
         while(_loc5_ < bagArr.length)
         {
            _loc6_ = bagArr[_loc5_] as Gird;
            if(_loc6_.getGoods() != null)
            {
               _loc7_ = _loc6_.getGoods();
               if(_loc7_.getGemSlot() != null)
               {
                  _loc8_ = _loc7_.getGemSlot();
                  _loc9_ = _loc8_.getSlotNum();
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_)
                  {
                     if(_loc8_.getGem(_loc10_) != null)
                     {
                        _loc11_ = _loc8_.getGem(_loc10_);
                        _loc12_ = _loc11_.getFixAtSx();
                        _loc13_ = _loc11_.getGdBo();
                        _loc14_ = 0;
                        while(_loc14_ < _loc12_.length)
                        {
                           _loc3_ = _loc12_[_loc14_] as BasicSx;
                           if(_loc14_ > 0)
                           {
                              throw new Error("属性石头只能有一个固定属性");
                           }
                           if(_loc3_.getSxType() == param1 && _loc13_[param1 - 1] == param2)
                           {
                              _loc4_.setValue(_loc4_.getValue() + _loc3_.getValue());
                              break;
                           }
                           _loc14_++;
                        }
                     }
                     _loc10_++;
                  }
               }
            }
            _loc5_++;
         }
         return _loc4_.getValue();
      }
      
      private function getEquipSkill(param1:Number, param2:uint) : Number
      {
         var _loc5_:Gird = null;
         var _loc6_:Goods = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc3_:VT = VT.createVT(0);
         var _loc4_:uint = 0;
         while(_loc4_ < bagArr.length)
         {
            _loc5_ = bagArr[_loc4_] as Gird;
            if(_loc5_.getGoods() != null)
            {
               _loc6_ = _loc5_.getGoods();
               if(_loc6_.getSkill(0).length != 0)
               {
                  _loc7_ = _loc6_.getSkill(0);
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     if((_loc7_[_loc8_] as GoodsSkillData).getStype() == param1 && (_loc7_[_loc8_] as GoodsSkillData).getValueType() == param2)
                     {
                        _loc3_.setValue(_loc3_.getValue() + (_loc7_[_loc8_] as GoodsSkillData).getValue());
                     }
                     _loc8_++;
                  }
               }
            }
            _loc4_++;
         }
         return _loc3_.getValue();
      }
      
      private function getEquipSkillXg() : void
      {
         var _loc2_:Gird = null;
         var _loc3_:Goods = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         this.skillList.length = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < bagArr.length)
         {
            _loc2_ = bagArr[_loc1_] as Gird;
            if(_loc2_.getGoods() != null)
            {
               _loc3_ = _loc2_.getGoods();
               if(_loc3_.getSkill(1).length != 0)
               {
                  _loc4_ = _loc3_.getSkill(1);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     this.skillList[(_loc4_[_loc5_] as GoodsSkillData).getId()] = _loc4_[_loc5_];
                     _loc5_++;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function getSuitValue(param1:Number, param2:uint) : Number
      {
         var _loc5_:BasicSx = null;
         var _loc7_:Gird = null;
         var _loc8_:Goods = null;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc3_:VT = VT.createVT(0);
         var _loc4_:Array = [];
         var _loc6_:uint = 0;
         while(_loc6_ < bagArr.length)
         {
            _loc7_ = bagArr[_loc6_] as Gird;
            if(_loc7_.getGoods() != null)
            {
               _loc8_ = _loc7_.getGoods();
               if(_loc8_.getSuiteId() != -1)
               {
                  if(_loc4_.length == 0)
                  {
                     _loc4_[0] = _loc8_.getSuiteId();
                  }
                  else
                  {
                     _loc9_ = false;
                     _loc10_ = 0;
                     while(_loc10_ < _loc4_.length)
                     {
                        if(_loc8_.getSuiteId() == _loc4_[_loc10_])
                        {
                           _loc9_ = true;
                           break;
                        }
                        _loc10_++;
                     }
                     if(!_loc9_)
                     {
                        _loc4_.push(_loc8_.getSuiteId());
                     }
                  }
               }
            }
            _loc6_++;
         }
         if(_loc4_.length != 0)
         {
            _loc11_ = [];
            _loc12_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc11_ = SuitEquipFactory.getSuitSxByIdAndNum(_loc4_[_loc6_],this.getSuitEquiping(_loc4_[_loc6_]));
               _loc12_ = SuitEquipFactory.getSuitBfb(_loc4_[_loc6_],this.getSuitEquiping(_loc4_[_loc6_]));
               _loc10_ = 0;
               while(_loc10_ < _loc11_.length)
               {
                  _loc5_ = _loc11_[_loc10_] as BasicSx;
                  if(_loc5_.getSxType() == param1 && _loc12_[_loc10_] == param2)
                  {
                     _loc3_.setValue(_loc3_.getValue() + _loc5_.getValue());
                     break;
                  }
                  _loc10_++;
               }
               _loc6_++;
            }
         }
         if(param1 == 5)
         {
         }
         return _loc3_.getValue();
      }
      
      private function getAllSx(param1:Number, param2:uint) : Number
      {
         var _loc3_:VT = VT.createVT(0);
         _loc3_.setValue(this.getGdSxValue(param1,param2) + this.getWxKxValue(param1,param2) + this.getStrValue(param1,param2) + this.getGemValue(param1,param2) + this.getEquipSkill(param1,param2) + this.getSuitValue(param1,param2));
         if(param2 == GS.a1)
         {
            return _loc3_.getValue() / GS.a10000;
         }
         return _loc3_.getValue();
      }
      
      public function jsSx(param1:PetR = null) : void
      {
         var _loc2_:VT = null;
         var _loc3_:VT = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         var _loc6_:VT = null;
         var _loc7_:VT = null;
         var _loc8_:VT = null;
         var _loc9_:VT = null;
         this.getEquipSkillXg();
         this.hp.setValue(this.getAllHp(GS.a0) + GoodsManger.dataList.cwZfBag.getHp(0));
         this.nl.setValue(this.getAllNengL(GS.a0));
         this.att.setValue(this.getAllAtt(GS.a0) + GoodsManger.dataList.cwZfBag.getAtt(0));
         this.fy.setValue(this.getAllFy(GS.a0) + GoodsManger.dataList.cwZfBag.getFy(0));
         this.sp.setValue(this.getAllSpeed(GS.a0));
         this.hp_b.setValue(this.getAllHp(GS.a1) + GoodsManger.dataList.cwZfBag.getHp(1));
         this.nl_b.setValue(this.getAllNengL(GS.a1));
         this.att_b.setValue(this.getAllAtt(GS.a1) + GoodsManger.dataList.cwZfBag.getAtt(1));
         this.fy_b.setValue(this.getAllFy(GS.a1) + GoodsManger.dataList.cwZfBag.getFy(1));
         this.bj_b.setValue(this.getAllBaoJi(GS.a1) + GoodsManger.dataList.cwZfBag.getBj());
         this.jin.setValue(this.getAllJin(GS.a0) + this.getAllJin(GS.a0) * this.getAllJin(GS.a1));
         this.mu.setValue(this.getAllMu(GS.a0) + this.getAllMu(GS.a0) * this.getAllMu(GS.a1));
         this.shui.setValue(this.getAllShui(GS.a0) + this.getAllShui(GS.a0) * this.getAllShui(GS.a1));
         this.huo.setValue(this.getAllHuo(GS.a0) + this.getAllHuo(GS.a0) * this.getAllHuo(GS.a1));
         this.tu.setValue(this.getAllTu(GS.a0) + this.getAllTu(GS.a0) * this.getAllTu(GS.a1));
         this.hd.setValue(this.getAllHd(GS.a0) + this.getAllHd(GS.a0) * this.getAllHd(GS.a1));
         if(param1 != null)
         {
            _loc2_ = VT.createVT(param1.getHp() * (this.hp_b.getValue() + GS.a1));
            _loc3_ = VT.createVT(Math.pow((param1.lv + 22) * 0.5,1.1));
            _loc4_ = VT.createVT(param1.getFy());
            _loc5_ = VT.createVT(_loc4_.getValue() / _loc3_.getValue() * 0.01 / (1 + _loc4_.getValue() / _loc3_.getValue() * 0.01));
            _loc6_ = VT.createVT(param1.getJin() + param1.getMu() + param1.getShui() + param1.getHuo() + param1.getTu());
            _loc7_ = VT.createVT(1 - 1000 / (1000 / (1 - _loc5_.getValue()) / 1000 + (_loc6_.getValue() * 1.4 + param1.getHd() * 1.9) / Math.pow(Math.pow(param1.lv,1.4) + 80,0.5) * 0.028) / 1000);
            _loc8_ = VT.createVT(param1.getFightScore());
            _loc9_ = VT.createVT(param1.getAtt() * (1 + param1.getBj()) * (1 + (_loc6_.getValue() * 1.4 + param1.getHd() * 1.9) / Math.pow(Math.pow(param1.lv,1.4) + 80,0.5) * 0.008) * _loc8_.getValue());
            this.zdl.setValue(_loc2_.getValue() / (GS.a1 - _loc7_.getValue()) * _loc9_.getValue() / 100000);
         }
      }
      
      public function getZdl() : Number
      {
         return this.zdl.getValue();
      }
      
      private function getAllHp(param1:uint) : Number
      {
         return this.getAllSx(GS.a1,param1);
      }
      
      private function getAllNengL(param1:uint) : Number
      {
         return this.getAllSx(GS.a2,param1);
      }
      
      private function getAllAtt(param1:uint) : Number
      {
         return this.getAllSx(GS.a3,param1);
      }
      
      private function getAllFy(param1:uint) : Number
      {
         return this.getAllSx(GS.a4,param1);
      }
      
      private function getAllBaoJi(param1:uint) : Number
      {
         return this.getAllSx(GS.a5,param1);
      }
      
      private function getAllSpeed(param1:uint) : Number
      {
         return this.getAllSx(GS.a6,param1);
      }
      
      private function getAllJin(param1:uint) : Number
      {
         return this.getAllSx(GS.a7,param1);
      }
      
      private function getAllMu(param1:uint) : Number
      {
         return this.getAllSx(GS.a8,param1);
      }
      
      private function getAllShui(param1:uint) : Number
      {
         return this.getAllSx(GS.a9,param1);
      }
      
      private function getAllHuo(param1:uint) : Number
      {
         return this.getAllSx(GS.a10,param1);
      }
      
      private function getAllTu(param1:uint) : Number
      {
         return this.getAllSx(GS.a11,param1);
      }
      
      private function getAllHd(param1:uint) : Number
      {
         return this.getAllSx(GS.a12,param1);
      }
   }
}

