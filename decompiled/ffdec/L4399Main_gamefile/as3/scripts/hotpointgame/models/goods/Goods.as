package hotpointgame.models.goods
{
   import flash.text.TextFormat;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   import hotpointgame.repository.jjia.*;
   import hotpointgame.repository.strengthen.*;
   
   public class Goods
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _createTime:VT = VT.createVT(0);
      
      private var _obj:Object = new Object();
      
      public function Goods()
      {
         super();
      }
      
      public static function readData(param1:Object) : Goods
      {
         var _loc4_:String = null;
         var _loc2_:Goods = new Goods();
         _loc2_.id = VT.createVT(param1["id"]);
         _loc2_.createTime = VT.createVT(param1["ct"]);
         var _loc3_:Object = param1["ob"];
         if(_loc3_["wm"] == null)
         {
            _loc2_._obj["wm"] = VT.createVT(GS.a0);
         }
         if(param1["id"] == 141072 || param1["id"] == 141080 || param1["id"] == 141088 || param1["id"] == 141255 || param1["id"] == 141263 || param1["id"] == 141271)
         {
            if(_loc3_["Ja"] == null)
            {
               _loc2_._obj.Ja = VT.createVT(GS.a0);
               _loc2_._obj.Jb = VT.createVT(GS.a1);
               _loc2_._obj.Jc = VT.createVT(GS.a0);
               _loc2_._obj.Jd = VT.createVT(GS.a0);
               _loc2_._obj.Je = new Array(GS.a0,GS.a0,GS.a0,GS.a0,GS.a0);
               _loc2_._obj.Jf = VT.createVT(GS.a0);
            }
         }
         for(_loc4_ in _loc3_)
         {
            if(_loc4_ == "gs")
            {
               _loc2_._obj[_loc4_] = EquipGemSlot.readData(_loc3_[_loc4_]);
            }
            else if(_loc4_ == "wq" || _loc4_ == "Je")
            {
               _loc2_._obj[_loc4_] = (_loc3_[_loc4_] as Array).slice();
            }
            else
            {
               _loc2_._obj[_loc4_] = VT.createVT(_loc3_[_loc4_]);
            }
         }
         return _loc2_;
      }
      
      public static function createGoods(param1:Number, param2:Object) : Goods
      {
         var _loc3_:Goods = new Goods();
         _loc3_._id = VT.createVT(param1);
         _loc3_._createTime = VT.createVT(FlowInterface.getCurrTimer());
         _loc3_._obj = param2;
         _loc3_.initJjia();
         return _loc3_;
      }
      
      public function save() : Object
      {
         var _loc3_:String = null;
         var _loc1_:Object = new Object();
         _loc1_["id"] = this.getId();
         _loc1_["ct"] = this.getCreateTime();
         var _loc2_:Object = new Object();
         for(_loc3_ in this._obj)
         {
            if(_loc3_ == "gs")
            {
               if(this._obj[_loc3_] != null)
               {
                  _loc2_[_loc3_] = (this._obj[_loc3_] as EquipGemSlot).save();
               }
            }
            else if(_loc3_ == "wq" || _loc3_ == "Je")
            {
               _loc2_[_loc3_] = (this._obj[_loc3_] as Array).slice();
            }
            else
            {
               _loc2_[_loc3_] = (this._obj[_loc3_] as VT).getValue();
            }
         }
         _loc1_["ob"] = _loc2_;
         return _loc1_;
      }
      
      public function initJjia() : void
      {
         if(this.getType() == GS.a0 && (this.getSmallType() == GS.a7 || this.getSmallType() == GS.a3))
         {
            this._obj.Ja = VT.createVT(GS.a0);
            this._obj.Jb = VT.createVT(GS.a1);
            this._obj.Jc = VT.createVT(GS.a0);
            this._obj.Jd = VT.createVT(GS.a0);
            this._obj.Je = new Array(GS.a0,GS.a0,GS.a0,GS.a0,GS.a0);
            this._obj.Jf = VT.createVT(GS.a0);
         }
      }
      
      public function getSxByJjia() : Array
      {
         var _loc1_:Array = this._obj.Je;
         var _loc2_:Array = [];
         if(FlowInterface.getJobByRole() == 1)
         {
            _loc2_[0] = _loc1_[0] * GS.a10;
            _loc2_[1] = _loc1_[1];
            _loc2_[2] = _loc1_[2] * GS.a75 / GS.a100;
            _loc2_[3] = _loc1_[3] * GS.a20;
            _loc2_[4] = _loc1_[4] * GS.a2 / GS.a10000;
         }
         else if(FlowInterface.getJobByRole() == 2)
         {
            _loc2_[0] = _loc1_[0] * GS.a13;
            _loc2_[1] = _loc1_[1];
            _loc2_[2] = _loc1_[2] * GS.a5 / GS.a10;
            _loc2_[3] = _loc1_[3] * GS.a40;
            _loc2_[4] = _loc1_[4] * GS.a2 / GS.a10000;
         }
         return _loc2_;
      }
      
      public function getJexp() : Number
      {
         return (this._obj.Ja as VT).getValue();
      }
      
      public function addJexp(param1:Number) : void
      {
         var _loc3_:VT = null;
         var _loc2_:VT = VT.createVT(this.getJjLv());
         if(_loc2_.getValue() < GS.a100)
         {
            (this._obj.Ja as VT).setValue(this.getJexp() + param1);
            if(this.getJjLv() > _loc2_.getValue())
            {
               _loc3_ = VT.createVT(this.getJjLv() - _loc2_.getValue());
               this.addJQl(GS.a5 * _loc3_.getValue());
            }
         }
      }
      
      public function setJexp(param1:Number) : void
      {
         (this._obj.Ja as VT).setValue(param1);
      }
      
      public function getJjLv() : Number
      {
         return JjiaFactory.getJjLv(this.getId(),this.getJexp());
      }
      
      public function getJhLv() : Number
      {
         return (this._obj.Jb as VT).getValue();
      }
      
      public function setJhLv(param1:Number) : void
      {
         (this._obj.Jb as VT).setValue(this.getJhLv() + param1);
      }
      
      public function getJQhLv() : Number
      {
         return (this._obj.Jc as VT).getValue();
      }
      
      public function setJQhLv(param1:Number) : void
      {
         (this._obj.Jc as VT).setValue(this.getJQhLv() + param1);
      }
      
      public function getJQl() : Number
      {
         return (this._obj.Jd as VT).getValue();
      }
      
      public function addJQl(param1:Number) : void
      {
         (this._obj.Jd as VT).setValue(this.getJQl() + param1);
      }
      
      public function setjQl(param1:*) : void
      {
         (this._obj.Jd as VT).setValue(param1);
      }
      
      public function deleteJQl(param1:Number) : void
      {
         (this._obj.Jd as VT).setValue(this.getJQl() - param1);
      }
      
      public function getJjhEXP() : Number
      {
         return (this._obj.Jf as VT).getValue();
      }
      
      public function setJjhEXP(param1:Number) : void
      {
         (this._obj.Jf as VT).setValue(this.getJjhEXP() + param1);
      }
      
      public function deleteJJHExp(param1:Number) : void
      {
         (this._obj.Jf as VT).setValue(this.getJjhEXP() - param1);
      }
      
      public function getJqlPoint(param1:Number) : Number
      {
         return this._obj.Je[param1];
      }
      
      public function setJqlPoint(param1:Number, param2:Number) : void
      {
         this._obj.Je[param1] = param2;
      }
      
      public function getAllPoint() : Number
      {
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:Array = this.obj.Je as Array;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_.setValue(_loc1_.getValue() + _loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc1_.getValue();
      }
      
      public function xiPoint() : void
      {
         this._obj.Je = new Array(GS.a0,GS.a0,GS.a0,GS.a0,GS.a0);
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getCreateTime() : Number
      {
         return this._createTime.getValue();
      }
      
      public function getName() : String
      {
         return this.getGoodsById().getName();
      }
      
      public function getWmMax() : Number
      {
         return this.getGoodsById().getWmMax();
      }
      
      public function getWmd() : Number
      {
         return this.getGoodsById().getWmd();
      }
      
      public function getIsWm() : Number
      {
         return this.getGoodsById().getIsWm();
      }
      
      public function getWmId() : Number
      {
         return this.getGoodsById().getWmId();
      }
      
      public function getWmSl() : Number
      {
         return this.getGoodsById().getWmSl();
      }
      
      public function getWmJb() : Number
      {
         return this.getGoodsById().getWmJb();
      }
      
      public function getFrame() : Number
      {
         return this.getGoodsById().getFrame();
      }
      
      public function getOverTimer() : Number
      {
         return this.getGoodsById().getOverTimer();
      }
      
      public function getCurrOverTimer() : Number
      {
         var _loc1_:Date = new Date(FlowInterface.getCurrTimer());
         return Math.round(this.getGoodsById().getOverTimer() - (FlowInterface.getCurrTimer() - this._createTime.getValue()) / 3600000);
      }
      
      public function getColor() : Number
      {
         return this.getGoodsById().getColor();
      }
      
      public function getFixAtSx() : Array
      {
         var _loc1_:Array = this.getGoodsById().getFixSx();
         if(_loc1_.length != 0)
         {
            return _loc1_;
         }
         return [];
      }
      
      public function getQuality() : Number
      {
         return this.getGoodsById().getQuality();
      }
      
      public function getUseLevel() : Number
      {
         return this.getGoodsById().getUseLevel();
      }
      
      public function getCreateLevel() : Number
      {
         return this.getGoodsById().getCreateLevel();
      }
      
      public function getType() : Number
      {
         return this.getGoodsById().getType();
      }
      
      public function getSmallType() : Number
      {
         return this.getGoodsById().getSmallType();
      }
      
      public function getDirections() : String
      {
         return this.getGoodsById().getDirections();
      }
      
      public function getPrice() : Number
      {
         return this.getGoodsById().getPrice();
      }
      
      public function getOverlapping() : Number
      {
         return this.getGoodsById().getOverlapping();
      }
      
      public function getbagNum() : Number
      {
         return this.getGoodsById().getbagNum();
      }
      
      public function getJd() : Number
      {
         return this.getGoodsById().getJd();
      }
      
      public function getHcJg() : Number
      {
         return this.getGoodsById().getHcJg();
      }
      
      public function getHcQj() : Array
      {
         return this.getGoodsById().getHcQj();
      }
      
      public function getShopG() : Number
      {
         return this.getGoodsById().getShopG();
      }
      
      public function isStrengBo() : Number
      {
         return this.getGoodsById().isStrengBo();
      }
      
      public function isAttAlter() : Number
      {
         return this.getGoodsById().isAttAlter();
      }
      
      public function isDefense() : Number
      {
         return this.getGoodsById().isDefense();
      }
      
      public function isCannon() : Number
      {
         return this.getGoodsById().isCannon();
      }
      
      public function getJob() : Number
      {
         return this.getGoodsById().getJob();
      }
      
      public function getGdBo() : Array
      {
         return this.getGoodsById().getGdBo();
      }
      
      public function getWxBo() : Boolean
      {
         return this.getGoodsById().getWxBo();
      }
      
      public function getSuiteId() : Number
      {
         return this.getGoodsById().getSuite();
      }
      
      public function getEquipType() : Number
      {
         return this.getGoodsById().getEquipType();
      }
      
      public function getShootSpeed() : Number
      {
         return this.getGoodsById().getShootSpeed();
      }
      
      public function getBombNum() : Number
      {
         return this.getGoodsById().getBombNum();
      }
      
      public function getBombNumMax() : Number
      {
         return this.getGoodsById().getBombNumMax();
      }
      
      public function getOtherValue() : Number
      {
         return this.getGoodsById().getOtherValue();
      }
      
      public function isBfb() : Boolean
      {
         return this.getGoodsById().isBfb();
      }
      
      public function isSell() : Boolean
      {
         return this.getGoodsById().isSell();
      }
      
      public function isUse() : Boolean
      {
         return this.getGoodsById().isUse();
      }
      
      public function getMcName() : String
      {
         return this.getGoodsById().getMcName();
      }
      
      public function getCj1() : String
      {
         return this.getGoodsById().getCj1();
      }
      
      public function getCj2() : String
      {
         return this.getGoodsById().getCj2();
      }
      
      public function getLwId() : Array
      {
         return this.getGoodsById().getLwId();
      }
      
      public function getLwNum() : Array
      {
         return this.getGoodsById().getLwNum();
      }
      
      public function getNeedId() : Array
      {
         return this.getGoodsById().getNeedId();
      }
      
      public function getNeedNum() : Array
      {
         return this.getGoodsById().getNeedNum();
      }
      
      public function getRewGl() : Array
      {
         return this.getGoodsById().getRewGl();
      }
      
      public function getColorStr() : TextFormat
      {
         return this.getGoodsById().getColorStr();
      }
      
      public function getWmLevel() : Number
      {
         return (this._obj.wm as VT).getValue();
      }
      
      public function addWmLevel() : void
      {
         (this._obj.wm as VT).setValue((this._obj.wm as VT).getValue() + 1);
      }
      
      public function getStrengLevel() : Number
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this.isStrengBo() != -1)
         {
            return (this._obj.qh as VT).getValue();
         }
         return -1;
      }
      
      public function changeStreng() : void
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this.isStrengBo() != -1)
         {
            (this._obj.qh as VT).setValue((this._obj.qh as VT).getValue() + 1);
         }
      }
      
      public function changeStrengByLevel(param1:Number) : void
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this.isStrengBo() != -1)
         {
            (this._obj.qh as VT).setValue(param1);
         }
      }
      
      public function getAttAlterLevel() : Number
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isAttAlter() != -1)
         {
            return (this._obj.gj as VT).getValue();
         }
         return -1;
      }
      
      public function changeAtt() : void
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isAttAlter() != -1)
         {
            (this._obj.gj as VT).setValue((this._obj.gj as VT).getValue() + 1);
         }
      }
      
      public function changeAttByLevel(param1:Number) : void
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isAttAlter() != -1)
         {
            (this._obj.gj as VT).setValue(param1 + 1);
         }
      }
      
      public function getDefenseLevel() : Number
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isDefense() != -1)
         {
            return (this._obj.fy as VT).getValue();
         }
         return -1;
      }
      
      public function changeDefense() : void
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isDefense() != -1)
         {
            (this._obj.fy as VT).setValue((this._obj.fy as VT).getValue() + 1);
         }
      }
      
      public function changeDefenseByLevel(param1:Number) : void
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isDefense() != -1)
         {
            (this._obj.fy as VT).setValue(param1 + 1);
         }
      }
      
      public function getCannonLevel() : Number
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isCannon() != -1)
         {
            return (this._obj.fp as VT).getValue();
         }
         return -1;
      }
      
      public function changeCannon() : void
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isCannon() != -1)
         {
            (this._obj.fp as VT).setValue((this._obj.fp as VT).getValue() + 1);
         }
      }
      
      public function changeCannonByLevel(param1:Number) : void
      {
         if(this.getType() == 0 && (this.getSmallType() == 3 || this.getSmallType() == 7) && this.isCannon() != -1)
         {
            (this._obj.fp as VT).setValue(param1 + 1);
         }
      }
      
      public function getFiveSx() : BasicSx
      {
         var _loc1_:Array = null;
         var _loc2_:BasicSx = null;
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this._obj != null)
         {
            if(this._obj.sx.getValue() != -1)
            {
               _loc1_ = this.getGoodsById().getFiveSx();
               for each(_loc2_ in _loc1_)
               {
                  if(this._obj.sx.getValue() == _loc2_.getSxType())
                  {
                     return _loc2_;
                  }
               }
            }
         }
         return null;
      }
      
      public function changeFiveSx(param1:Number) : void
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this._obj != null)
         {
            this._obj.sx = param1;
         }
      }
      
      public function setSkillZw(param1:Array) : Array
      {
         if(this.getType() == 0 && this.getSmallType() == 0)
         {
            this._obj.wq = param1;
         }
         return null;
      }
      
      public function getSkillzw() : Array
      {
         if(this.getType() == 0 && this.getSmallType() == 0)
         {
            return this._obj.wq;
         }
         return null;
      }
      
      public function getGemSlot() : EquipGemSlot
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this._obj.gs != null)
         {
            return this._obj.gs;
         }
         return null;
      }
      
      public function addSlot(param1:Number) : void
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this._obj.gs != null)
         {
            (this._obj.gs as EquipGemSlot).setSlot(param1);
         }
      }
      
      public function addGemInEquip(param1:Number, param2:Goods) : void
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this._obj.gs != null)
         {
            (this._obj.gs as EquipGemSlot).addGemInEquip(param1,param2);
         }
      }
      
      public function getGem(param1:Number) : Goods
      {
         if(this.getType() == 0 && this.getSmallType() != 3 && this.getSmallType() != 7 && this._obj.gs != null)
         {
            return (this._obj.gs as EquipGemSlot).getGem(param1);
         }
         return null;
      }
      
      private function getGoodsById() : GoodsData
      {
         return GoodsFactory.getGoodsById(this._id.getValue());
      }
      
      public function compareById(param1:Number) : Boolean
      {
         if(this._id.getValue() == param1)
         {
            return true;
         }
         return false;
      }
      
      public function getJobForStr() : String
      {
         if(this.getJob() != -1)
         {
            switch(this.getJob())
            {
               case 0:
                  return "绝影枪手";
               case 1:
                  return "绝影枪手";
               case 2:
                  return "炎蓝炮手";
               case 3:
                  return "枪魂2";
               case 5:
                  return "宠物";
            }
         }
         return null;
      }
      
      public function getSmallTypeForStr() : String
      {
         if(this.getType() == 0)
         {
            switch(this.getSmallType())
            {
               case 0:
                  return "武器";
               case 1:
                  return "铠甲";
               case 2:
                  return "腰带";
               case 3:
                  return "兽型机甲";
               case 4:
                  return "吊坠";
               case 5:
                  return "护腕";
               case 6:
                  return "指环";
               case 7:
                  return "人型机甲";
               case 8:
                  return "时装";
               case 9:
                  return "机甲挂饰";
               case 10:
                  return "肩膀";
               case 11:
                  return "武器时装";
               case 12:
                  return "炫光";
               case 13:
                  return "无";
               case 14:
                  return "浮游机炮";
               case 15:
                  return "无";
               case 25:
                  return "武器";
               case 26:
                  return "手部";
               case 27:
                  return "大脑";
               case 28:
                  return "心脏";
               case 29:
                  return "脚部";
               case 30:
                  return "腰部";
            }
         }
         return null;
      }
      
      public function getQhforStr() : String
      {
         var _loc1_:String = null;
         if(this.getStrengLevel() != -1 && this.getStrengLevel() != 0)
         {
            if(this.getType() == 0)
            {
               if(this.getSmallType() == 0)
               {
                  _loc1_ = "攻击+";
               }
               else
               {
                  if(this.getSmallType() == GS.a16)
                  {
                     _loc1_ = "称号全属性+";
                     return _loc1_ + StrengthenFactory.getStrengValue(this.getCreateLevel(),this.getColor(),this.getStrengLevel()) / GS.a100 + "%";
                  }
                  _loc1_ = "防御+";
               }
            }
            return _loc1_ + StrengthenFactory.getStrengValue(this.getCreateLevel(),this.getColor(),this.getStrengLevel());
         }
         return null;
      }
      
      public function getFixAtSxForStr() : Array
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:BasicSx = null;
         var _loc7_:Number = NaN;
         var _loc1_:String = "";
         var _loc2_:Array = this.getFixAtSx();
         var _loc3_:Array = this.getGdBo();
         if(_loc2_.length != 0)
         {
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc6_ = _loc2_[_loc5_] as BasicSx;
               if(_loc3_[_loc6_.getSxType() - 1] == 0)
               {
                  _loc1_ = "";
                  _loc4_.push(this.getDescription(_loc6_.getSxType(),_loc6_.getValue(),_loc1_));
               }
               else if(_loc3_[_loc6_.getSxType() - 1] == 1)
               {
                  _loc1_ = "%";
                  _loc7_ = _loc6_.getValue() / GS.a100;
                  _loc7_.toFixed(1);
                  _loc4_.push(this.getDescription(_loc6_.getSxType(),_loc7_,_loc1_));
               }
               _loc5_++;
            }
            return _loc4_;
         }
         return null;
      }
      
      private function getDescription(param1:Number, param2:Number, param3:String) : String
      {
         var _loc4_:String = null;
         switch(param1)
         {
            case 1:
               _loc4_ = "生命+" + param2 + param3;
               break;
            case 2:
               _loc4_ = "能量+" + param2 + param3;
               break;
            case 3:
               _loc4_ = "攻击+" + param2 + param3;
               break;
            case 4:
               _loc4_ = "防御+" + param2 + param3;
               break;
            case 5:
               _loc4_ = "暴击+" + param2 + param3;
               break;
            case 6:
               _loc4_ = "速度+" + param2 + param3;
               break;
            case 7:
               _loc4_ = "金+" + param2 + param3;
               break;
            case 8:
               _loc4_ = "木+" + param2 + param3;
               break;
            case 9:
               _loc4_ = "水+" + param2 + param3;
               break;
            case 10:
               _loc4_ = "火+" + param2 + param3;
               break;
            case 11:
               _loc4_ = "土+" + param2 + param3;
               break;
            case 12:
               _loc4_ = "混沌+" + param2 + param3;
               break;
            default:
               throw new Error("物品基础属性不存在的类型:type:" + param1);
         }
         return _loc4_;
      }
      
      public function getFiveSxFstr() : String
      {
         var _loc1_:String = "";
         var _loc2_:BasicSx = this.getFiveSx();
         if(_loc2_ != null)
         {
            if(this.getWxBo() == false)
            {
               _loc1_ = "";
               return this.getDescription(_loc2_.getSxType(),_loc2_.getValue(),_loc1_);
            }
            _loc1_ = "%";
            return this.getDescription(_loc2_.getSxType(),int(_loc2_.getValue() / GS.a10000),_loc1_);
         }
         return null;
      }
      
      public function getGemFstr() : EquipGemSlot
      {
         var _loc1_:Array = [];
         if(this.getType() == 0 && this.getSmallType() != 9 && this._obj.gs != null)
         {
            return this._obj.gs;
         }
         return null;
      }
      
      public function getSkill(param1:Number = 0) : Array
      {
         var _loc5_:uint = 0;
         var _loc6_:GoodsSkillData = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = this.getGoodsById().getSkill();
         if(_loc4_.length != 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc2_.push(GoodsSkillFactory.getSkillDataById(_loc4_[_loc5_]));
               _loc5_++;
            }
            for each(_loc6_ in _loc2_)
            {
               if(_loc6_.getType() == param1)
               {
                  _loc3_.push(_loc6_);
               }
            }
         }
         return _loc3_;
      }
      
      public function getAttChangeFstr() : String
      {
         return null;
      }
      
      public function getDefenseFstr() : Array
      {
         return null;
      }
      
      public function getCannonFstr() : String
      {
         if(this.getType() == 0 && this.getSmallType() == 9 && this.isCannon() != -1)
         {
            return String((this._obj.fp as VT).getValue());
         }
         return null;
      }
      
      public function set id(param1:VT) : void
      {
         this._id = param1;
      }
      
      public function get id() : VT
      {
         return this._id;
      }
      
      public function get createTime() : VT
      {
         return this._createTime;
      }
      
      public function set createTime(param1:VT) : void
      {
         this._createTime = param1;
      }
      
      public function get obj() : Object
      {
         return this._obj;
      }
      
      public function set obj(param1:Object) : void
      {
         this._obj = param1;
      }
   }
}

