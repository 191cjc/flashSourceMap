package hotpointgame.models.bag
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   import hotpointgame.repository.jjia.*;
   import hotpointgame.repository.strengthen.*;
   import hotpointgame.repository.unionVip.*;
   import hotpointgame.repository.vip.*;
   import hotpointgame.views.geneChangePanel.*;
   import hotpointgame.views.vipPanel.*;
   import hotpointgame.views.zenfuPanel.PlayerZfBag;
   
   public class EquipSlot extends Bag
   {
      
      public static var addEqSlotBo:Boolean = false;
      
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
      
      private var jin_b:VT = VT.createVT(0);
      
      private var mu_b:VT = VT.createVT(0);
      
      private var shui_b:VT = VT.createVT(0);
      
      private var huo_b:VT = VT.createVT(0);
      
      private var tu_b:VT = VT.createVT(0);
      
      private var hd_b:VT = VT.createVT(0);
      
      private var skillList:Array = [];
      
      private var ycBtnArr:Array = [];
      
      private var vipPk:VT = VT.createVT(-1);
      
      private var zdl:VT = VT.createVT(0);
      
      public function EquipSlot()
      {
         super();
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["add"] = addEqSlotBo;
         return _loc1_;
      }
      
      public static function read(param1:*) : void
      {
         addEqSlotBo = param1["add"];
      }
      
      public static function createEquipSlot() : EquipSlot
      {
         var _loc1_:EquipSlot = new EquipSlot();
         _loc1_.setBagNum(17);
         _loc1_.setKeyNum(17);
         _loc1_.initBag();
         _loc1_.initYc();
         return _loc1_;
      }
      
      public static function pkRead(param1:Object) : EquipSlot
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Gird = null;
         var _loc2_:EquipSlot = new EquipSlot();
         if(param1 != null)
         {
            _loc2_._bagArr.length = GS.a0;
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
            if(_loc2_._bagArr.length < GS.a17)
            {
               _loc5_ = new Gird();
               (_loc5_ as Gird).openGird();
               _loc2_._bagArr.push(_loc5_);
            }
            _loc2_.bagNum = _loc2_._bagArr.length;
            _loc2_.keyNum = VT.createVT(_loc2_._bagArr.length);
         }
         else
         {
            _loc2_.setBagNum(17);
            _loc2_.setKeyNum(17);
            _loc2_.initBag();
         }
         _loc2_.initYc();
         _loc2_.bfBag();
         return _loc2_;
      }
      
      public function initYc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < bagArr.length)
         {
            this.ycBtnArr[_loc1_] = false;
            _loc1_++;
         }
      }
      
      public function setYcArr(param1:Array) : void
      {
         this.ycBtnArr = param1;
      }
      
      public function setYcid(param1:Number, param2:Boolean) : void
      {
         this.ycBtnArr[param1] = param2;
      }
      
      public function getYc(param1:Number) : Boolean
      {
         return this.ycBtnArr[param1];
      }
      
      public function getYcArr() : Array
      {
         return this.ycBtnArr;
      }
      
      public function initYcread() : void
      {
         var _loc2_:Gird = null;
         var _loc1_:uint = 0;
         while(_loc1_ < bagArr.length)
         {
            _loc2_ = bagArr[_loc1_] as Gird;
            if(_loc1_ > 7)
            {
               if(_loc2_.getGoods() != null)
               {
                  this.ycBtnArr[_loc1_] = true;
               }
               else
               {
                  this.ycBtnArr[_loc1_] = false;
               }
            }
            else
            {
               this.ycBtnArr[_loc1_] = false;
            }
            _loc1_++;
         }
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
      
      public function getJin(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            return this.jin.getValue();
         }
         return this.jin_b.getValue();
      }
      
      public function getMu(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            return this.mu.getValue();
         }
         return this.mu_b.getValue();
      }
      
      public function getShui(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            return this.shui.getValue();
         }
         return this.shui_b.getValue();
      }
      
      public function getHuo(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            return this.huo.getValue();
         }
         return this.huo_b.getValue();
      }
      
      public function getTu(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            return this.tu.getValue();
         }
         return this.tu_b.getValue();
      }
      
      public function getHd(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            return this.hd.getValue();
         }
         return this.hd_b.getValue();
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
      
      private function getGdSxValue(param1:Number, param2:uint, param3:Number = -1) : Number
      {
         var _loc5_:BasicSx = null;
         var _loc8_:uint = 0;
         var _loc9_:Gird = null;
         var _loc10_:Goods = null;
         var _loc11_:uint = 0;
         var _loc12_:Number = NaN;
         var _loc4_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:VT = VT.createVT(0);
         if(param3 == -1)
         {
            _loc8_ = 0;
            while(_loc8_ < bagArr.length)
            {
               _loc9_ = bagArr[_loc8_] as Gird;
               if(_loc9_.getGoods() != null)
               {
                  _loc10_ = _loc9_.getGoods();
                  if(_loc8_ != GS.a3 && _loc8_ != GS.a7)
                  {
                     if(_loc10_.getFixAtSx() != null)
                     {
                        _loc4_ = _loc10_.getFixAtSx();
                        _loc6_ = _loc10_.getGdBo();
                        if(_loc8_ != GS.a16)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 if(param1 == 1 || param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5)
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue() + _loc5_.getValue() * _loc10_.getWmLevel() * GS.a5 / GS.a100);
                                 }
                                 else
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 }
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                        else if(_loc10_.getShootSpeed() == -1)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                        else if(_loc10_.getShootSpeed() == GS.a0)
                        {
                           if(GM.levelm.curLevel == null)
                           {
                              _loc11_ = 0;
                              while(_loc11_ < _loc4_.length)
                              {
                                 _loc5_ = _loc4_[_loc11_] as BasicSx;
                                 if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                    break;
                                 }
                                 _loc11_++;
                              }
                           }
                           else
                           {
                              _loc12_ = Number(GM.levelm.curLevel.id);
                              if(_loc12_ >= GS.a1 && _loc12_ <= GS.a21 || _loc12_ >= 1001 && _loc12_ <= 1012 || _loc12_ == 9999 || _loc12_ == 9994 || _loc12_ == 9997 || _loc12_ == 997 || _loc12_ == 998 || _loc12_ >= 3000 && _loc12_ <= 3020 || _loc12_ >= 2001 && _loc12_ <= 2029)
                              {
                                 _loc11_ = 0;
                                 while(_loc11_ < _loc4_.length)
                                 {
                                    _loc5_ = _loc4_[_loc11_] as BasicSx;
                                    if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                                    {
                                       _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                       break;
                                    }
                                    _loc11_++;
                                 }
                              }
                           }
                        }
                        else if(_loc10_.getShootSpeed() == GS.a1)
                        {
                           if(GM.levelm.curLevel == null)
                           {
                              _loc11_ = 0;
                              while(_loc11_ < _loc4_.length)
                              {
                                 _loc5_ = _loc4_[_loc11_] as BasicSx;
                                 if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                    break;
                                 }
                                 _loc11_++;
                              }
                           }
                           else
                           {
                              _loc12_ = Number(GM.levelm.curLevel.id);
                              if(_loc12_ == GS.a9999 - GS.a1)
                              {
                                 _loc11_ = 0;
                                 while(_loc11_ < _loc4_.length)
                                 {
                                    _loc5_ = _loc4_[_loc11_] as BasicSx;
                                    if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                                    {
                                       _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                       break;
                                    }
                                    _loc11_++;
                                 }
                              }
                           }
                        }
                     }
                  }
                  else if(_loc8_ == GS.a3)
                  {
                     if(FlowInterface.getRoleState() == GS.a2 && _loc10_.getFixAtSx() != null)
                     {
                        _loc4_ = _loc10_.getFixAtSx();
                        _loc6_ = _loc10_.getGdBo();
                        _loc11_ = 0;
                        while(_loc11_ < _loc4_.length)
                        {
                           _loc5_ = _loc4_[_loc11_] as BasicSx;
                           if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                           {
                              _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                              break;
                           }
                           _loc11_++;
                        }
                     }
                  }
                  else if(_loc8_ == GS.a7)
                  {
                     if((FlowInterface.getRoleState() == GS.a1 || FlowInterface.getRoleState() == GS.a2) && _loc10_.getFixAtSx() != null)
                     {
                        _loc4_ = _loc10_.getFixAtSx();
                        _loc6_ = _loc10_.getGdBo();
                        _loc11_ = 0;
                        while(_loc11_ < _loc4_.length)
                        {
                           _loc5_ = _loc4_[_loc11_] as BasicSx;
                           if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                           {
                              _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                              break;
                           }
                           _loc11_++;
                        }
                     }
                  }
               }
               _loc8_++;
            }
         }
         else if(param3 == GS.a0)
         {
            _loc8_ = 0;
            while(_loc8_ < bagArr.length)
            {
               _loc9_ = bagArr[_loc8_] as Gird;
               if(_loc9_.getGoods() != null)
               {
                  _loc10_ = _loc9_.getGoods();
                  if(_loc8_ != GS.a3 && _loc8_ != GS.a7)
                  {
                     if(_loc10_.getFixAtSx() != null)
                     {
                        _loc4_ = _loc10_.getFixAtSx();
                        _loc6_ = _loc10_.getGdBo();
                        if(_loc8_ != GS.a16)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 if(param1 == 1 || param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5)
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue() + _loc5_.getValue() * _loc10_.getWmLevel() * GS.a5 / GS.a100);
                                 }
                                 else
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 }
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                        else if(_loc10_.getShootSpeed() == -1 || _loc10_.getShootSpeed() == GS.a1)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                     }
                  }
               }
               _loc8_++;
            }
         }
         else if(param3 == GS.a1)
         {
            _loc8_ = 0;
            while(_loc8_ < bagArr.length)
            {
               _loc9_ = bagArr[_loc8_] as Gird;
               if(_loc9_.getGoods() != null)
               {
                  _loc10_ = _loc9_.getGoods();
                  if(_loc8_ != GS.a3 && _loc8_ != GS.a7)
                  {
                     if(_loc10_.getFixAtSx() != null)
                     {
                        _loc4_ = _loc10_.getFixAtSx();
                        _loc6_ = _loc10_.getGdBo();
                        if(_loc8_ != GS.a16)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 if(param1 == 1 || param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5)
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue() + _loc5_.getValue() * _loc10_.getWmLevel() * GS.a5 / GS.a100);
                                 }
                                 else
                                 {
                                    _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 }
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                        else if(_loc10_.getShootSpeed() == -1 || _loc10_.getShootSpeed() == GS.a1)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                     }
                  }
                  else
                  {
                     if(_loc8_ == GS.a3)
                     {
                        break;
                     }
                     if(_loc8_ == GS.a7)
                     {
                        if(_loc10_.getFixAtSx() != null)
                        {
                           _loc4_ = _loc10_.getFixAtSx();
                           _loc6_ = _loc10_.getGdBo();
                           _loc11_ = 0;
                           while(_loc11_ < _loc4_.length)
                           {
                              _loc5_ = _loc4_[_loc11_] as BasicSx;
                              if(_loc5_.getSxType() == param1 && _loc6_[param1 - 1] == param2)
                              {
                                 _loc7_.setValue(_loc7_.getValue() + _loc5_.getValue());
                                 break;
                              }
                              _loc11_++;
                           }
                        }
                     }
                  }
               }
               _loc8_++;
            }
         }
         return _loc7_.getValue();
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
               if(_loc4_ != GS.a16)
               {
                  if(param1 == 3 && param2 == GS.a0 && _loc6_.getSmallType() == 0 && _loc6_.getSmallType() != 3 && _loc6_.getSmallType() != 7 && _loc6_.isStrengBo() != -1 && _loc6_.getStrengLevel() != 0)
                  {
                     _loc3_.setValue(StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()));
                  }
                  else if(param1 == 4 && param2 == GS.a0 && _loc6_.getSmallType() != 0 && _loc6_.getSmallType() != 3 && _loc6_.getSmallType() != 7 && _loc6_.isStrengBo() != -1 && _loc6_.getStrengLevel() != 0)
                  {
                     _loc3_.setValue(_loc3_.getValue() + StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()));
                  }
               }
            }
            _loc4_++;
         }
         return _loc3_.getValue();
      }
      
      private function getStrValueCH(param1:Number, param2:uint, param3:Number) : Number
      {
         var _loc6_:Goods = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:BasicSx = null;
         var _loc10_:Number = NaN;
         var _loc4_:VT = VT.createVT(0);
         var _loc5_:Gird = bagArr[16] as Gird;
         if(_loc5_.getGoods() != null)
         {
            _loc6_ = _loc5_.getGoods();
            if(_loc6_.isStrengBo() != -1 && _loc6_.getStrengLevel() != 0 && param2 == GS.a0)
            {
               if(_loc6_.getFixAtSx() != null)
               {
                  _loc7_ = _loc6_.getFixAtSx();
                  if(param3 == -1)
                  {
                     if(_loc6_.getShootSpeed() == -1)
                     {
                        _loc8_ = 0;
                        while(_loc8_ < _loc7_.length)
                        {
                           _loc9_ = _loc7_[_loc8_] as BasicSx;
                           if(_loc9_.getSxType() == param1)
                           {
                              _loc4_.setValue(Math.floor(_loc9_.getValue() * StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()) / GS.a10000));
                              break;
                           }
                           _loc8_++;
                        }
                     }
                     else if(_loc6_.getShootSpeed() == 0)
                     {
                        if(GM.levelm.curLevel != null)
                        {
                           _loc10_ = Number(GM.levelm.curLevel.id);
                           if(_loc10_ >= GS.a1 && _loc10_ <= GS.a21 || _loc10_ >= 1001 && _loc10_ <= 1012 || _loc10_ == 9999 || _loc10_ == 9994 || _loc10_ == 9997 || _loc10_ == 997 || _loc10_ == 998 || _loc10_ >= 3000 && _loc10_ <= 3020 || _loc10_ >= 2001 && _loc10_ <= 2029)
                           {
                              _loc8_ = 0;
                              while(_loc8_ < _loc7_.length)
                              {
                                 _loc9_ = _loc7_[_loc8_] as BasicSx;
                                 if(_loc9_.getSxType() == param1)
                                 {
                                    _loc4_.setValue(Math.floor(_loc9_.getValue() * StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()) / GS.a10000));
                                    break;
                                 }
                                 _loc8_++;
                              }
                           }
                        }
                     }
                     else if(_loc6_.getShootSpeed() == 1)
                     {
                        if(GM.levelm.curLevel != null)
                        {
                           _loc10_ = Number(GM.levelm.curLevel.id);
                           if(_loc10_ == GS.a9999 - GS.a1)
                           {
                              _loc8_ = 0;
                              while(_loc8_ < _loc7_.length)
                              {
                                 _loc9_ = _loc7_[_loc8_] as BasicSx;
                                 if(_loc9_.getSxType() == param1)
                                 {
                                    _loc4_.setValue(Math.floor(_loc9_.getValue() * StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()) / GS.a10000));
                                    break;
                                 }
                                 _loc8_++;
                              }
                           }
                        }
                     }
                  }
                  else if(_loc6_.getShootSpeed() == -1 || _loc6_.getShootSpeed() == GS.a1)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc7_.length)
                     {
                        _loc9_ = _loc7_[_loc8_] as BasicSx;
                        if(_loc9_.getSxType() == param1)
                        {
                           _loc4_.setValue(Math.floor(_loc9_.getValue() * StrengthenFactory.getStrengValue(_loc6_.getCreateLevel(),_loc6_.getColor(),_loc6_.getStrengLevel()) / GS.a10000));
                           break;
                        }
                        _loc8_++;
                     }
                  }
               }
            }
         }
         return _loc4_.getValue();
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
         var _loc6_:GoodsSkillData = null;
         var _loc7_:Gird = null;
         var _loc8_:Goods = null;
         var _loc9_:Array = null;
         var _loc10_:uint = 0;
         var _loc3_:VT = VT.createVT(0);
         var _loc4_:uint = 0;
         while(_loc4_ < bagArr.length)
         {
            _loc7_ = bagArr[_loc4_] as Gird;
            if(_loc7_.getGoods() != null)
            {
               _loc8_ = _loc7_.getGoods();
               if(_loc8_.getSkill(0).length != 0)
               {
                  _loc9_ = _loc8_.getSkill(0);
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_.length)
                  {
                     if((_loc9_[_loc10_] as GoodsSkillData).getStype() == param1 && (_loc9_[_loc10_] as GoodsSkillData).getValueType() == param2)
                     {
                        _loc3_.setValue(_loc3_.getValue() + (_loc9_[_loc10_] as GoodsSkillData).getValue());
                     }
                     _loc10_++;
                  }
               }
            }
            _loc4_++;
         }
         var _loc5_:* = GeneData.getSkillByType(GS.a0);
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.getStype() == param1 && _loc6_.getValueType() == param2)
            {
               _loc3_.setValue(_loc3_.getValue() + _loc6_.getValue());
            }
         }
         return _loc3_.getValue();
      }
      
      private function getEquipSkillXg() : void
      {
         var _loc3_:GoodsSkillData = null;
         var _loc4_:Gird = null;
         var _loc5_:Goods = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         this.skillList.length = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < bagArr.length)
         {
            _loc4_ = bagArr[_loc1_] as Gird;
            if(_loc4_.getGoods() != null)
            {
               _loc5_ = _loc4_.getGoods();
               if(_loc5_.getSkill(1).length != 0)
               {
                  _loc6_ = _loc5_.getSkill(1);
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.length)
                  {
                     this.skillList[(_loc6_[_loc7_] as GoodsSkillData).getId()] = _loc6_[_loc7_];
                     _loc7_++;
                  }
               }
            }
            _loc1_++;
         }
         var _loc2_:* = GeneData.getSkillByType(GS.a1);
         for each(_loc3_ in _loc2_)
         {
            this.skillList[_loc3_.getId()] = _loc3_;
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
         return _loc3_.getValue();
      }
      
      private function getJjiaSx(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc6_:Goods = null;
         var _loc7_:Number = NaN;
         var _loc4_:VT = VT.createVT(GS.a0);
         var _loc5_:Gird = bagArr[7] as Gird;
         if(_loc5_.getGoods() != null)
         {
            _loc6_ = _loc5_.getGoods();
            if(param2 == 0)
            {
               if(param1 == 1 || param1 == 12 || param1 == 3 || param1 == 4)
               {
                  _loc7_ = 0;
                  if(param1 == 1)
                  {
                     _loc7_ = Number(_loc6_.getSxByJjia()[0]);
                  }
                  else if(param1 == 12)
                  {
                     _loc7_ = Number(_loc6_.getSxByJjia()[1]);
                  }
                  else if(param1 == 3)
                  {
                     _loc7_ = Number(_loc6_.getSxByJjia()[2]);
                  }
                  else if(param1 == 4)
                  {
                     _loc7_ = Number(_loc6_.getSxByJjia()[3]);
                  }
                  if(param3 == -1)
                  {
                     if(FlowInterface.getRoleState() == GS.a1 || FlowInterface.getRoleState() == GS.a2)
                     {
                        _loc4_.setValue(JjiaFactory.getjjlvSxValue(param1,_loc6_) + JjiaFactory.getQhSxValue(param1,_loc6_.getJQhLv(),_loc6_.getId()) + _loc7_);
                     }
                  }
                  else if(param3 == 1)
                  {
                     _loc4_.setValue(JjiaFactory.getjjlvSxValue(param1,_loc6_) + JjiaFactory.getQhSxValue(param1,_loc6_.getJQhLv(),_loc6_.getId()) + _loc7_);
                  }
               }
            }
            else if(param2 == 1)
            {
               if(param1 == 5)
               {
                  _loc7_ = Number(_loc6_.getSxByJjia()[4]);
                  if(param3 == -1)
                  {
                     if(FlowInterface.getRoleState() == GS.a1 || FlowInterface.getRoleState() == GS.a2)
                     {
                        _loc4_.setValue(JjiaFactory.getjjlvSxValue(param1,_loc6_) + JjiaFactory.getQhSxValue(param1,_loc6_.getJQhLv(),_loc6_.getId()) + _loc7_);
                     }
                  }
                  else if(param3 == 1)
                  {
                     _loc4_.setValue(JjiaFactory.getjjlvSxValue(param1,_loc6_) + JjiaFactory.getQhSxValue(param1,_loc6_.getJQhLv(),_loc6_.getId()) + _loc7_);
                  }
                  _loc4_.setValue(_loc4_.getValue() * GS.a10000);
               }
            }
            return _loc4_.getValue();
         }
         return 0;
      }
      
      private function getAllSx(param1:Number, param2:uint, param3:Number) : Number
      {
         var _loc4_:VT = VT.createVT(0);
         _loc4_.setValue(this.getGdSxValue(param1,param2,param3) + this.getWxKxValue(param1,param2) + this.getStrValue(param1,param2) + this.getStrValueCH(param1,param2,param3) + this.getGemValue(param1,param2) + this.getEquipSkill(param1,param2) + this.getSuitValue(param1,param2) + this.getJjiaSx(param1,param2,param3));
         if(param2 == GS.a1)
         {
            return _loc4_.getValue() / GS.a10000;
         }
         return _loc4_.getValue();
      }
      
      public function jsSx(param1:Number, param2:Number = 0, param3:PlayerZfBag = null, param4:Number = -1) : void
      {
         var _loc19_:VT = null;
         var _loc20_:VT = null;
         var _loc21_:VT = null;
         var _loc22_:VT = null;
         var _loc23_:VT = null;
         var _loc24_:VT = null;
         this.vipPk.setValue(param1);
         this.getEquipSkillXg();
         var _loc5_:VT = VT.createVT(GS.a0);
         var _loc6_:VT = VT.createVT(GS.a0);
         var _loc7_:VT = VT.createVT(GS.a0);
         var _loc8_:VT = VT.createVT(GS.a0);
         var _loc9_:VT = VT.createVT(GS.a0);
         var _loc10_:VT = VT.createVT(GS.a0);
         var _loc11_:VT = VT.createVT(GS.a0);
         if(param3 != null)
         {
            param3.jsSx();
            _loc5_.setValue(param3.getHp(GS.a0));
            _loc6_.setValue(param3.getAtt(GS.a0));
            _loc7_.setValue(param3.getFy(GS.a0));
            _loc8_.setValue(param3.getHp(GS.a1));
            _loc9_.setValue(param3.getAtt(GS.a1));
            _loc10_.setValue(param3.getFy(GS.a1));
            _loc11_.setValue(param3.getBj());
         }
         else
         {
            _loc5_.setValue(GoodsManger.dataList.pzfBag.getHp(GS.a0));
            _loc6_.setValue(GoodsManger.dataList.pzfBag.getAtt(GS.a0));
            _loc7_.setValue(GoodsManger.dataList.pzfBag.getFy(GS.a0));
            _loc8_.setValue(GoodsManger.dataList.pzfBag.getHp(GS.a1));
            _loc9_.setValue(GoodsManger.dataList.pzfBag.getAtt(GS.a1));
            _loc10_.setValue(GoodsManger.dataList.pzfBag.getFy(GS.a1));
            _loc11_.setValue(GoodsManger.dataList.pzfBag.getBj());
         }
         this.hp.setValue(this.getAllHp(GS.a0,param4) + _loc5_.getValue());
         this.nl.setValue(this.getAllNengL(GS.a0,param4) + VipFactory.getNl(param1));
         this.att.setValue(this.getAllAtt(GS.a0,param4) + _loc6_.getValue());
         this.fy.setValue(this.getAllFy(GS.a0,param4) + _loc7_.getValue());
         this.sp.setValue(this.getAllSpeed(GS.a0,param4));
         this.hp_b.setValue(this.getAllHp(GS.a1,param4) + UnionVipFactory.getVipById(param2).getHp() + VipFactory.getHp(param1) + _loc8_.getValue());
         this.nl_b.setValue(this.getAllNengL(GS.a1,param4));
         this.att_b.setValue(this.getAllAtt(GS.a1,param4) + UnionVipFactory.getVipById(param2).getAtt() + VipFactory.getAtt(param1) + _loc9_.getValue());
         this.fy_b.setValue(this.getAllFy(GS.a1,param4) + UnionVipFactory.getVipById(param2).getFy() + VipFactory.getFy(param1) + _loc10_.getValue());
         this.bj_b.setValue(this.getAllBaoJi(GS.a1,param4) + UnionVipFactory.getVipById(param2).getBj() + VipFactory.getBj(param1) + _loc11_.getValue());
         var _loc12_:VT = VT.createVT(UnionVipFactory.getVipById(param2).getFx());
         var _loc13_:VT = VT.createVT(VipFactory.getJin(param1));
         var _loc14_:VT = VT.createVT(VipFactory.getMu(param1));
         var _loc15_:VT = VT.createVT(VipFactory.getShui(param1));
         var _loc16_:VT = VT.createVT(VipFactory.getHuo(param1));
         var _loc17_:VT = VT.createVT(VipFactory.getTu(param1));
         var _loc18_:VT = VT.createVT(VipFactory.getHd(param1));
         if(param4 == -1)
         {
            _loc19_ = VT.createVT(GM.aSaveData.sxiaolevel.getAddJin());
            _loc20_ = VT.createVT(GM.aSaveData.sxiaolevel.getAddMu());
            _loc21_ = VT.createVT(GM.aSaveData.sxiaolevel.getAddShui());
            _loc22_ = VT.createVT(GM.aSaveData.sxiaolevel.getAddHuo());
            _loc23_ = VT.createVT(GM.aSaveData.sxiaolevel.getAddTu());
            _loc24_ = VT.createVT(GM.aSaveData.sxiaolevel.getAddHD() + GM.aSaveData.sxiaolevel.getAddHDB());
            this.jin.setValue(this.getAllJin(GS.a0,param4) + _loc19_.getValue() + (this.getAllJin(GS.a0,param4) + _loc19_.getValue()) * (this.getAllJin(GS.a1,param4) + _loc12_.getValue() + _loc13_.getValue()));
            this.mu.setValue(this.getAllMu(GS.a0,param4) + _loc20_.getValue() + (this.getAllMu(GS.a0,param4) + _loc20_.getValue()) * (this.getAllMu(GS.a1,param4) + _loc12_.getValue() + _loc14_.getValue()));
            this.shui.setValue(this.getAllShui(GS.a0,param4) + _loc21_.getValue() + (this.getAllShui(GS.a0,param4) + _loc21_.getValue()) * (this.getAllShui(GS.a1,param4) + _loc12_.getValue() + _loc15_.getValue()));
            this.huo.setValue(this.getAllHuo(GS.a0,param4) + _loc22_.getValue() + (this.getAllHuo(GS.a0,param4) + _loc22_.getValue()) * (this.getAllHuo(GS.a1,param4) + _loc12_.getValue() + _loc16_.getValue()));
            this.tu.setValue(this.getAllTu(GS.a0,param4) + _loc23_.getValue() + (this.getAllTu(GS.a0,param4) + _loc23_.getValue()) * (this.getAllTu(GS.a1,param4) + _loc12_.getValue() + _loc17_.getValue()));
            this.hd.setValue(this.getAllHd(GS.a0,param4) + _loc24_.getValue() + (this.getAllHd(GS.a0,param4) + _loc24_.getValue()) * (this.getAllHd(GS.a1,param4) + _loc12_.getValue() + _loc18_.getValue()));
         }
         else
         {
            this.jin.setValue(this.getAllJin(GS.a0,param4));
            this.mu.setValue(this.getAllMu(GS.a0,param4));
            this.shui.setValue(this.getAllShui(GS.a0,param4));
            this.huo.setValue(this.getAllHuo(GS.a0,param4));
            this.tu.setValue(this.getAllTu(GS.a0,param4));
            this.hd.setValue(this.getAllHd(GS.a0,param4));
            this.jin_b.setValue(this.getAllJin(GS.a1,param4) + _loc12_.getValue() + _loc13_.getValue());
            this.mu_b.setValue(this.getAllMu(GS.a1,param4) + _loc12_.getValue() + _loc14_.getValue());
            this.shui_b.setValue(this.getAllShui(GS.a1,param4) + _loc12_.getValue() + _loc15_.getValue());
            this.huo_b.setValue(this.getAllHuo(GS.a1,param4) + _loc12_.getValue() + _loc16_.getValue());
            this.tu_b.setValue(this.getAllTu(GS.a1,param4) + _loc12_.getValue() + _loc17_.getValue());
            this.hd_b.setValue(this.getAllHd(GS.a1,param4) + _loc12_.getValue() + _loc18_.getValue());
         }
      }
      
      public function JsZdl() : void
      {
         var _loc1_:VT = VT.createVT((this.hp.getValue() + FlowInterface.getHpByRole()) * (this.hp_b.getValue() + GS.a1));
         var _loc2_:VT = VT.createVT(Math.pow((FlowInterface.getLevelByRole() + 22) * 0.5,1.1));
         var _loc3_:VT = VT.createVT(this.fy.getValue() + FlowInterface.getFyByRole() + (this.fy.getValue() + FlowInterface.getFyByRole()) * this.fy_b.getValue());
         var _loc4_:VT = VT.createVT(_loc3_.getValue() / _loc2_.getValue() * 0.01 / (1 + _loc3_.getValue() / _loc2_.getValue() * 0.01));
         var _loc5_:VT = VT.createVT(this.jin.getValue() + this.mu.getValue() + this.shui.getValue() + this.huo.getValue() + this.tu.getValue());
         var _loc6_:VT = VT.createVT(1 - 1000 / (1000 / (1 - _loc4_.getValue()) / 1000 + (_loc5_.getValue() * 1.4 + this.hd.getValue() * 1.9) / Math.pow(Math.pow(FlowInterface.getLevelByRole(),1.4) + 80,0.5) * 0.028) / 1000);
         var _loc7_:VT = VT.createVT(GM.cp.getFightSocre());
         var _loc8_:VT = VT.createVT((this.att.getValue() + FlowInterface.getAttByRole()) * (1 + this.att_b.getValue()) * (1 + this.bj_b.getValue() + FlowInterface.getBjByRole()) * (1 + (_loc5_.getValue() * 1.4 + this.hd.getValue() * 1.9) / Math.pow(Math.pow(FlowInterface.getLevelByRole(),1.4) + 80,0.5) * 0.008) * _loc7_.getValue());
         if(FlowInterface.getJobByRole() == 1)
         {
            this.zdl.setValue(_loc1_.getValue() / (GS.a1 - _loc6_.getValue()) * _loc8_.getValue() / 100000);
         }
         else if(FlowInterface.getJobByRole() == 2)
         {
            this.zdl.setValue(_loc1_.getValue() / (GS.a1 - _loc6_.getValue()) * _loc8_.getValue() / 100000 / 1.05);
         }
      }
      
      private function getAllHp(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a1,param1,param2);
      }
      
      private function getAllNengL(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a2,param1,param2);
      }
      
      private function getAllAtt(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a3,param1,param2);
      }
      
      private function getAllFy(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a4,param1,param2);
      }
      
      private function getAllBaoJi(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a5,param1,param2);
      }
      
      private function getAllSpeed(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a6,param1,param2);
      }
      
      private function getAllJin(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a7,param1,param2);
      }
      
      private function getAllMu(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a8,param1,param2);
      }
      
      private function getAllShui(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a9,param1,param2);
      }
      
      private function getAllHuo(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a10,param1,param2);
      }
      
      private function getAllTu(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a11,param1,param2);
      }
      
      private function getAllHd(param1:uint, param2:Number) : Number
      {
         return this.getAllSx(GS.a12,param1,param2);
      }
      
      public function getYjNameArr() : Array
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < bagArr.length)
         {
            _loc3_ = bagArr[_loc2_] as Gird;
            if(_loc3_.getGoods() != null)
            {
               _loc4_ = _loc3_.getGoods();
               if(_loc4_.getMcName() != "-1")
               {
                  _loc1_[_loc2_] = _loc4_.getMcName();
               }
               else
               {
                  _loc1_[_loc2_] = "";
               }
            }
            else
            {
               _loc1_[_loc2_] = "";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getZdl() : Number
      {
         return this.zdl.getValue();
      }
   }
}

