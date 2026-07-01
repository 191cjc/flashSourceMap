package hotpointgame.pet
{
   import hotpointgame.common.*;
   import hotpointgame.gMonster.CMJingJie;
   import hotpointgame.gMonster.TraceJuLi;
   
   public class PetR
   {
      
      private static var expArr:Array = initexpAll();
      
      private var _bid:VT = VT.createVT(0);
      
      private var _lv:VT = VT.createVT(GS.a1);
      
      private var _curExp:VT = VT.createVT(0);
      
      private var _toExp:VT = VT.createVT(0);
      
      private var _tolv:VT = VT.createVT(1);
      
      private var _curPot:VT = VT.createVT(0);
      
      private var _pbag:PetBag;
      
      private var lwdaoskillArr:Array = new Array();
      
      private var useskillArr:Array = new Array();
      
      private var _curLWJieDuan:VT = VT.createVT(0);
      
      private var _curHp:VT = VT.createVT(0);
      
      private var _tempPB:PetBaseD;
      
      private var _tempRHBD:PetRongHeAttBD;
      
      private var _tempvHp:VT = VT.createVT(0);
      
      private var _tempvBj:VT = VT.createVT(0);
      
      private var _tempvAtt:VT = VT.createVT(0);
      
      private var _tempvdf:VT = VT.createVT(0);
      
      public function PetR()
      {
         super();
      }
      
      private static function initexpAll() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            _loc1_[_loc2_] = new Array();
            _loc3_ = int(GS.a1);
            while(_loc3_ <= GS.a100)
            {
               if(_loc3_ == 1)
               {
                  _loc1_[_loc2_][_loc3_] = (Math.pow(GS.a2 + _loc3_,GS.a2) + GS.a100) * (_loc2_ * GS.a02 + GS.a08);
               }
               else
               {
                  _loc1_[_loc2_][_loc3_] = (Math.pow(GS.a2 + _loc3_,GS.a2) + GS.a100) * (_loc2_ * GS.a02 + GS.a08) + _loc1_[_loc2_][_loc3_ - 1];
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function readData(param1:Object = null) : PetR
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc2_:PetR = new PetR();
         if(param1 != null)
         {
            _loc2_.bid = param1.id;
            _loc2_.lv = param1.lv;
            _loc2_.curExp = param1.cexp;
            _loc2_.toExp = param1.texp;
            _loc2_.tolv = param1.tlv;
            _loc2_.curPot = param1.cpot;
            _loc2_.pbag = PetBag.readPetBag(param1.pag);
            _loc3_ = param1.lwar;
            _loc4_ = new Array();
            for(_loc5_ in _loc3_)
            {
               _loc4_[Number(_loc5_)] = PetSkillShowSaveD.readData(_loc3_[_loc5_]);
            }
            _loc2_.lwdaoskillArr = _loc4_;
            _loc6_ = param1.uar;
            _loc7_ = new Array();
            for(_loc8_ in _loc6_)
            {
               _loc7_[Number(_loc8_)] = PetSkillShowSaveD.readData(_loc6_[_loc8_]);
            }
            _loc2_.useskillArr = _loc7_;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.id = this.bid;
         _loc1_.lv = this.lv;
         _loc1_.cexp = this.curExp;
         _loc1_.texp = this.toExp;
         _loc1_.tlv = this.tolv;
         _loc1_.cpot = this.curPot;
         _loc1_.pag = this.pbag.save();
         var _loc2_:Object = new Object();
         var _loc3_:int = 0;
         while(_loc3_ < GS.a21)
         {
            if(this.lwdaoskillArr[_loc3_] != null)
            {
               _loc2_[_loc3_] = (this.lwdaoskillArr[_loc3_] as PetSkillShowSaveD).save();
            }
            _loc3_++;
         }
         _loc1_.lwar = _loc2_;
         var _loc4_:Object = new Object();
         var _loc5_:int = 0;
         while(_loc5_ < GS.a7)
         {
            if(this.useskillArr[_loc5_] != null)
            {
               _loc4_[_loc5_] = (this.useskillArr[_loc5_] as PetSkillShowSaveD).save();
            }
            _loc5_++;
         }
         _loc1_.uar = _loc4_;
         return _loc1_;
      }
      
      public function get bid() : int
      {
         return this._bid.getValue();
      }
      
      public function set bid(param1:int) : void
      {
         this._bid.setValue(param1);
      }
      
      public function countCacah() : void
      {
         this.tempvHp = (Math.pow(this.lv * GS.a80,GS.a1 + GS.a001) + GS.a1000) * ((this.getpotLimit() + GS.a1) * GS.a25 / GS.a100) + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.hp;
         this.tempvBj = (this.lv * GS.a01 / GS.a100 - GS.a01 / GS.a100) * ((this.getpotLimit() + GS.a1) * GS.a25 / GS.a100) + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.bj;
         this.tempvAtt = (Math.pow(this.lv * GS.a2,GS.a1 + GS.a001) + GS.a20) * ((this.getpotLimit() + GS.a1) * GS.a25 / GS.a100) + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.att;
         this.tempvdf = (Math.pow((this.lv + GS.a22) * GS.a05,GS.a1 + GS.a001) + GS.a20) * GS.a05 / ((GS.a90 + GS.a5) / GS.a1000) * ((this.getpotLimit() + GS.a1) * GS.a25 / GS.a100) + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.fy;
      }
      
      public function saveAfter() : void
      {
         this.countCacah();
         this.resetHp();
      }
      
      public function resetHp() : void
      {
         this.curHp = this.getHp();
      }
      
      public function initBid(param1:int) : void
      {
         this.bid = param1;
         this.pbag = PetBag.readPetBag();
         this.countCacah();
         this.addRHexp(this.tempPB.pexp);
         this.resetHp();
      }
      
      public function getHp() : Number
      {
         return (this.pbag.getHp() + this.tempvHp) * (GS.a1 + this.pbag.getHp(GS.a1)) * (GS.a1 + GS.a05);
      }
      
      public function getNl() : Number
      {
         return GS.a1000;
      }
      
      public function getAtt() : Number
      {
         return (this.pbag.getAtt() + this.tempvAtt) * (GS.a1 + this.pbag.getAtt(GS.a1));
      }
      
      public function getFy() : Number
      {
         return (this.pbag.getFy() + this.tempvdf) * (GS.a1 + this.pbag.getFy(GS.a1));
      }
      
      public function getBj() : Number
      {
         return this.pbag.getBj() + this.tempvBj;
      }
      
      public function getSp() : Number
      {
         return 0;
      }
      
      public function getJin() : Number
      {
         return this.pbag.getJin() + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.jin;
      }
      
      public function getMu() : Number
      {
         return this.pbag.getMu() + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.mu;
      }
      
      public function getShui() : Number
      {
         return this.pbag.getShui() + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.shui;
      }
      
      public function getHuo() : Number
      {
         return this.pbag.getHuo() + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.huo;
      }
      
      public function getTu() : Number
      {
         return this.pbag.getTu() + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.tu;
      }
      
      public function getHd() : Number
      {
         return this.pbag.getHd() + (this.getpotLimit() * GS.a01 + GS.a06) * this.tempRHBD.hd;
      }
      
      public function getType() : String
      {
         return this.tempPB.ptype;
      }
      
      public function getpColor() : int
      {
         return this.tempPB.pcolor;
      }
      
      public function getname() : String
      {
         return this.tempPB.name;
      }
      
      public function getpetEle() : String
      {
         return this.tempPB.pele;
      }
      
      public function getpetswfEle() : String
      {
         return this.tempPB.pele + this.curPot;
      }
      
      public function get pbag() : PetBag
      {
         return this._pbag;
      }
      
      public function set pbag(param1:PetBag) : void
      {
         this._pbag = param1;
      }
      
      public function getPetFrame() : int
      {
         return this.tempPB.framnum;
      }
      
      public function get tempPB() : PetBaseD
      {
         if(this._tempPB == null)
         {
            this.tempPB = PetDataManager.getPBD(this.bid);
         }
         return this._tempPB;
      }
      
      public function set tempPB(param1:PetBaseD) : void
      {
         this._tempPB = param1;
      }
      
      public function get tempRHBD() : PetRongHeAttBD
      {
         if(this._tempRHBD == null)
         {
            this._tempRHBD = PetDataManager.getRongHeLvBylv(this.tolv);
         }
         return this._tempRHBD;
      }
      
      public function resetRHBD() : void
      {
         this._tempRHBD = PetDataManager.getRongHeLvBylv(this.tolv);
      }
      
      public function set tempRHBD(param1:PetRongHeAttBD) : void
      {
         this._tempRHBD = param1;
      }
      
      public function get curExp() : Number
      {
         return this._curExp.getValue();
      }
      
      public function set curExp(param1:Number) : void
      {
         this._curExp.setValue(param1);
      }
      
      public function getNextExp() : int
      {
         return (Math.pow(this.lv * this.lv * GS.a50,GS.a1 + GS.a03) + GS.a9999) * (this.getpotLimit() * GS.a02 + GS.a04);
      }
      
      public function getNumByLvLimit() : int
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = this.getpotLimit() * GS.a02 + GS.a04;
         var _loc3_:int = this.lv;
         while(_loc3_ < PetManager.petLevelMax)
         {
            _loc1_ += (Math.pow(_loc3_ * _loc3_ * GS.a50,GS.a1 + GS.a03) + GS.a9999) * _loc2_;
            _loc3_++;
         }
         return (_loc1_ - this.curExp) / 100000 + GS.a1;
      }
      
      public function addExp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         if(this.lv == PetManager.petLevelMax)
         {
            return;
         }
         this.curExp += param1;
         if(this.curExp >= this.getNextExp())
         {
            while(this.curExp >= this.getNextExp())
            {
               this.curExp -= this.getNextExp();
               this.lv += GS.a1;
               if(this.lv == PetManager.petLevelMax)
               {
                  this.curExp = 0;
                  break;
               }
            }
            this.countCacah();
            this.resetHp();
         }
      }
      
      public function get lv() : int
      {
         return this._lv.getValue();
      }
      
      public function set lv(param1:int) : void
      {
         this._lv.setValue(param1);
      }
      
      public function get tolv() : int
      {
         return this._tolv.getValue();
      }
      
      public function set tolv(param1:int) : void
      {
         this._tolv.setValue(param1);
      }
      
      public function get toExp() : Number
      {
         return this._toExp.getValue();
      }
      
      public function set toExp(param1:Number) : void
      {
         this._toExp.setValue(param1);
      }
      
      public function getRHNextExp() : int
      {
         return expArr[this.getpotLimit()][this.tolv];
      }
      
      public function isRHLvLimit() : Boolean
      {
         return this.tolv >= PetManager.petLevelMax;
      }
      
      public function addRHexp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         if(this.tolv == PetManager.petLevelMax)
         {
            return;
         }
         this.toExp += param1;
         if(this.toExp >= this.getRHNextExp())
         {
            while(this.toExp >= this.getRHNextExp())
            {
               this.tolv += GS.a1;
               if(this.tolv == PetManager.petLevelMax)
               {
                  break;
               }
            }
            this.resetRHBD();
            this.countCacah();
         }
      }
      
      public function getpotLimit() : int
      {
         return this.tempPB.ppotLimit;
      }
      
      public function get curPot() : int
      {
         return this._curPot.getValue();
      }
      
      public function set curPot(param1:int) : void
      {
         this._curPot.setValue(param1);
      }
      
      public function isKeYiJinHua() : Boolean
      {
         if(this.getpotLimit() <= this.curPot)
         {
            return false;
         }
         if((this.curPot + GS.a1) * GS.a10 <= this.tolv)
         {
            return true;
         }
         return false;
      }
      
      public function lvNextJinHua() : int
      {
         if(this.getpotLimit() <= this.curPot)
         {
            return -1;
         }
         if(this.tolv == PetManager.petLevelMax)
         {
            return -1;
         }
         return (this.curPot + GS.a1) * GS.a10;
      }
      
      public function petJinHua() : Boolean
      {
         if(this.isKeYiJinHua())
         {
            this.curPot += GS.a1;
            return true;
         }
         return false;
      }
      
      public function get curLWJieDuan() : int
      {
         return this._curLWJieDuan.getValue();
      }
      
      public function set curLWJieDuan(param1:int) : void
      {
         this._curLWJieDuan.setValue(param1);
      }
      
      public function curLWXuYaoGod(param1:int) : int
      {
         return (PetDataManager.getLingWuSkillByPetAndLv(this.bid,param1 + GS.a1) as PetLingWuSkillBD).linggod;
      }
      
      public function petlWSkillByGod(param1:int) : Boolean
      {
         if(this.curPot == 0)
         {
            return false;
         }
         if(param1 != this.curLWJieDuan)
         {
            return false;
         }
         if(!this.isYoulwWeiZhi())
         {
            return false;
         }
         var _loc2_:PetSkillShowSaveD = new PetSkillShowSaveD();
         _loc2_.initBDid((PetDataManager.getLingWuSkillByPetAndLv(this.bid,param1 + GS.a1) as PetLingWuSkillBD).bDLWSkill());
         this.lwDaoSkillArrAdd(_loc2_);
         if((PetDataManager.getLingWuSkillByPetAndLv(this.bid,param1 + GS.a1) as PetLingWuSkillBD).lingrate >= Math.random() * GS.a10000)
         {
            this.curLWJieDuan += GS.a1;
            if(this.curLWJieDuan > GS.a4)
            {
               this.curLWJieDuan = 0;
            }
         }
         else
         {
            this.curLWJieDuan = 0;
         }
         return true;
      }
      
      public function petlWSkillByXin(param1:int) : Boolean
      {
         if(this.curPot == 0)
         {
            return false;
         }
         if(param1 + GS.a3 != this.curLWJieDuan)
         {
            return false;
         }
         if(!this.isYoulwWeiZhi())
         {
            return false;
         }
         var _loc2_:PetSkillShowSaveD = new PetSkillShowSaveD();
         _loc2_.initBDid((PetDataManager.getLingWuSkillByPetAndLv(this.bid,param1 + GS.a6) as PetLingWuSkillBD).bDLWSkill());
         this.lwDaoSkillArrAdd(_loc2_);
         if((PetDataManager.getLingWuSkillByPetAndLv(this.bid,param1 + GS.a6) as PetLingWuSkillBD).lingrate >= Math.random() * GS.a10000)
         {
            this.curLWJieDuan += GS.a1;
            if(this.curLWJieDuan > GS.a4)
            {
               this.curLWJieDuan = 0;
            }
         }
         else
         {
            this.curLWJieDuan = 0;
         }
         return true;
      }
      
      public function isYoulwWeiZhi() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < GS.a16)
         {
            if(this.lwdaoskillArr[_loc1_] == null)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function lwDaoSkillArrAdd(param1:PetSkillShowSaveD) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < GS.a16)
         {
            if(this.lwdaoskillArr[_loc2_] == null)
            {
               this.lwdaoskillArr[_loc2_] = param1;
               return;
            }
            _loc2_++;
         }
      }
      
      public function getlwDaoSkillArr() : Array
      {
         return this.lwdaoskillArr;
      }
      
      public function getlwDaoSkillArrByid(param1:int) : PetSkillShowSaveD
      {
         return this.lwdaoskillArr[param1];
      }
      
      public function getuseSkillArr() : Array
      {
         return this.useskillArr;
      }
      
      public function getuseSkillArrByid(param1:int) : PetSkillShowSaveD
      {
         return this.useskillArr[param1];
      }
      
      public function wangjieShowFun(param1:int, param2:int, param3:int) : String
      {
         var _loc4_:PetSkillShowSaveD = null;
         var _loc5_:PetSkillShowSaveD = null;
         switch(param1)
         {
            case 1:
               _loc4_ = this.lwdaoskillArr[param2];
               _loc5_ = this.lwdaoskillArr[param3];
               break;
            case 2:
               _loc4_ = this.useskillArr[param2];
               _loc5_ = this.useskillArr[param3];
               break;
            case 3:
               _loc4_ = this.lwdaoskillArr[param2];
               _loc5_ = this.useskillArr[param3];
               break;
            case 4:
               _loc4_ = this.useskillArr[param2];
               _loc5_ = this.lwdaoskillArr[param3];
               break;
            default:
               return "errora";
         }
         if(_loc4_ == null)
         {
            return "errorb";
         }
         if(_loc5_ == null)
         {
            return "不用弹框";
         }
         if(_loc4_.basedataid >= GS.a10000)
         {
            return _loc4_.getsname() + " 将被 " + _loc5_.getsname() + " 吸收";
         }
         if(_loc5_.basedataid >= GS.a10000)
         {
            return _loc5_.getsname() + " 将被 " + _loc4_.getsname() + " 吸收";
         }
         if(_loc4_.getscolor() > _loc5_.getscolor())
         {
            return _loc5_.getsname() + " 将被 " + _loc4_.getsname() + " 吸收";
         }
         if(_loc4_.getscolor() < _loc5_.getscolor())
         {
            return _loc4_.getsname() + " 将被 " + _loc5_.getsname() + " 吸收";
         }
         if(_loc5_.curLv >= _loc4_.curLv)
         {
            return _loc4_.getsname() + " 将被 " + _loc5_.getsname() + " 吸收";
         }
         return _loc5_.getsname() + " 将被 " + _loc4_.getsname() + " 吸收";
      }
      
      public function lwDaoSkillDrag(param1:int, param2:int) : String
      {
         var _loc3_:PetSkillShowSaveD = null;
         var _loc4_:PetSkillShowSaveD = null;
         if(param1 == param2)
         {
            return "errora";
         }
         if(param1 > GS.a20 || param2 > GS.a20 || param1 < 0 || param2 < 0)
         {
            return "errorb";
         }
         if(this.lwdaoskillArr[param1] == null)
         {
            return "errorc";
         }
         if(this.lwdaoskillArr[param2] == null)
         {
            this.lwdaoskillArr[param2] = this.lwdaoskillArr[param1];
            this.lwdaoskillArr[param1] = null;
            return "成功";
         }
         _loc3_ = this.lwdaoskillArr[param1];
         _loc4_ = this.lwdaoskillArr[param2];
         if(_loc3_.basedataid >= GS.a10000)
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.lwdaoskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.lwdaoskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc4_.basedataid >= GS.a10000)
         {
            if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
            {
               return _loc3_.getsname() + "已到达等级上限";
            }
            this.lwdaoskillArr[param1] = null;
            _loc3_.addSkillExp(_loc4_.curExp);
            this.lwdaoskillArr[param2] = _loc3_;
            return "成功";
         }
         if(_loc3_.getscolor() > _loc4_.getscolor())
         {
            if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
            {
               return _loc3_.getsname() + "已到达等级上限";
            }
            this.lwdaoskillArr[param1] = null;
            _loc3_.addSkillExp(_loc4_.curExp);
            this.lwdaoskillArr[param2] = _loc3_;
            return "成功";
         }
         if(_loc3_.getscolor() < _loc4_.getscolor())
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.lwdaoskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.lwdaoskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc4_.curLv >= _loc3_.curLv)
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.lwdaoskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.lwdaoskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
         {
            return _loc3_.getsname() + "已到达等级上限";
         }
         this.lwdaoskillArr[param1] = null;
         _loc3_.addSkillExp(_loc4_.curExp);
         this.lwdaoskillArr[param2] = _loc3_;
         return "成功";
      }
      
      public function useskillDrag(param1:int, param2:int) : String
      {
         var _loc3_:PetSkillShowSaveD = null;
         var _loc4_:PetSkillShowSaveD = null;
         if(param1 == param2)
         {
            return "errord";
         }
         if(param1 > GS.a6 || param2 > GS.a6 || param1 < 0 || param2 < 0 || this.curPot <= param1 || this.curPot <= param2)
         {
            return "errore";
         }
         if(this.useskillArr[param1] == null)
         {
            return "errorf";
         }
         if(this.useskillArr[param2] == null)
         {
            this.useskillArr[param2] = this.useskillArr[param1];
            this.useskillArr[param1] = null;
            return "成功";
         }
         _loc3_ = this.useskillArr[param1];
         _loc4_ = this.useskillArr[param2];
         if(_loc3_.getscolor() > _loc4_.getscolor())
         {
            if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
            {
               return _loc3_.getsname() + "已到达等级上限";
            }
            this.useskillArr[param1] = null;
            _loc3_.addSkillExp(_loc4_.curExp);
            this.useskillArr[param2] = _loc3_;
            return "成功";
         }
         if(_loc3_.getscolor() < _loc4_.getscolor())
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.useskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.useskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc4_.curLv >= _loc3_.curLv)
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.useskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.useskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
         {
            return _loc3_.getsname() + "已到达等级上限";
         }
         this.useskillArr[param1] = null;
         _loc3_.addSkillExp(_loc4_.curExp);
         this.useskillArr[param2] = _loc3_;
         return "成功";
      }
      
      public function lwdaoDraguse(param1:int, param2:int) : String
      {
         if(param1 > GS.a20 || param1 < 0)
         {
            return "errorg";
         }
         if(param2 > GS.a6 || param2 < 0 || this.curPot <= param2)
         {
            return "errorh";
         }
         if(this.lwdaoskillArr[param1] == null)
         {
            return "errori";
         }
         var _loc3_:PetSkillShowSaveD = this.lwdaoskillArr[param1];
         var _loc4_:PetSkillShowSaveD = this.useskillArr[param2];
         if(this.useskillArr[param2] == null)
         {
            if(_loc3_.basedataid >= GS.a10000)
            {
               return "经验无法装备";
            }
            if(this.isYouTongNameSkill(_loc3_.getsname()))
            {
               return "已装备了技能: " + _loc3_.getsname();
            }
            if(_loc3_.getFightPotLimit() > this.curPot)
            {
               return "宠物进化" + _loc3_.getFightPotLimit() + "次后才可以装备:" + _loc3_.getsname();
            }
            this.useskillArr[param2] = _loc3_;
            this.lwdaoskillArr[param1] = null;
            return "成功";
         }
         if(_loc3_.basedataid >= GS.a10000)
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            _loc4_.addSkillExp(_loc3_.curExp);
            this.lwdaoskillArr[param1] = null;
            return "成功";
         }
         if(_loc3_.getscolor() > _loc4_.getscolor())
         {
            if(_loc3_.getsname() != _loc4_.getsname() && Boolean(this.isYouTongNameSkill(_loc3_.getsname())))
            {
               return "已装备了技能: " + _loc3_.getsname();
            }
            if(_loc3_.getFightPotLimit() > this.curPot)
            {
               return "宠物进化" + _loc3_.getFightPotLimit() + "次后才可以装备:" + _loc3_.getsname();
            }
            if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
            {
               return _loc3_.getsname() + "已到达等级上限";
            }
            _loc3_.addSkillExp(_loc4_.curExp);
            this.useskillArr[param2] = _loc3_;
            this.lwdaoskillArr[param1] = null;
            return "成功";
         }
         if(_loc3_.getscolor() < _loc4_.getscolor())
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            _loc4_.addSkillExp(_loc3_.curExp);
            this.useskillArr[param2] = _loc4_;
            this.lwdaoskillArr[param1] = null;
            return "成功";
         }
         if(_loc4_.curLv >= _loc3_.curLv)
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            _loc4_.addSkillExp(_loc3_.curExp);
            this.useskillArr[param2] = _loc4_;
            this.lwdaoskillArr[param1] = null;
            return "成功";
         }
         if(_loc3_.getsname() != _loc4_.getsname() && Boolean(this.isYouTongNameSkill(_loc3_.getsname())))
         {
            return "已装备了技能: " + _loc3_.getsname();
         }
         if(_loc3_.getFightPotLimit() > this.curPot)
         {
            return "宠物进化" + _loc3_.getFightPotLimit() + "次后才可以装备:" + _loc3_.getsname();
         }
         if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
         {
            return _loc3_.getsname() + "已到达等级上限";
         }
         _loc3_.addSkillExp(_loc4_.curExp);
         this.useskillArr[param2] = _loc3_;
         this.lwdaoskillArr[param1] = null;
         return "成功";
      }
      
      public function useDraglwdao(param1:int, param2:int) : String
      {
         if(param2 > GS.a20 || param2 < 0)
         {
            return "errorj";
         }
         if(param1 > GS.a6 || param1 < 0 || this.curPot <= param1)
         {
            return "errork";
         }
         if(this.useskillArr[param1] == null)
         {
            return "errorl";
         }
         var _loc3_:PetSkillShowSaveD = this.useskillArr[param1];
         var _loc4_:PetSkillShowSaveD = this.lwdaoskillArr[param2];
         if(this.lwdaoskillArr[param2] == null)
         {
            this.lwdaoskillArr[param2] = _loc3_;
            this.useskillArr[param1] = null;
            return "成功";
         }
         if(_loc4_.basedataid >= GS.a10000)
         {
            if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
            {
               return _loc3_.getsname() + "已到达等级上限";
            }
            _loc3_.addSkillExp(_loc4_.curExp);
            this.lwdaoskillArr[param2] = _loc3_;
            this.useskillArr[param1] = null;
            return "成功";
         }
         if(_loc3_.getscolor() > _loc4_.getscolor())
         {
            if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
            {
               return _loc3_.getsname() + "已到达等级上限";
            }
            this.useskillArr[param1] = null;
            _loc3_.addSkillExp(_loc4_.curExp);
            this.lwdaoskillArr[param2] = _loc3_;
            return "成功";
         }
         if(_loc3_.getscolor() < _loc4_.getscolor())
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.useskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.lwdaoskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc4_.curLv >= _loc3_.curLv)
         {
            if(_loc4_.basedataid < GS.a10000 && _loc4_.curLv == GS.a100)
            {
               return _loc4_.getsname() + "已到达等级上限";
            }
            this.useskillArr[param1] = null;
            _loc4_.addSkillExp(_loc3_.curExp);
            this.lwdaoskillArr[param2] = _loc4_;
            return "成功";
         }
         if(_loc3_.basedataid < GS.a10000 && _loc3_.curLv == GS.a100)
         {
            return _loc3_.getsname() + "已到达等级上限";
         }
         this.useskillArr[param1] = null;
         _loc3_.addSkillExp(_loc4_.curExp);
         this.lwdaoskillArr[param2] = _loc3_;
         return "成功";
      }
      
      public function intoOne() : void
      {
         var _loc1_:PetSkillShowSaveD = null;
         var _loc4_:PetSkillShowSaveD = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PetSkillShowSaveD = null;
         var _loc8_:int = 0;
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         for(; _loc3_ < GS.a16; _loc3_++)
         {
            if(this.lwdaoskillArr[_loc3_] != null)
            {
               _loc4_ = this.lwdaoskillArr[_loc3_];
               if(_loc1_ != null)
               {
                  if(_loc4_.basedataid < GS.a10000)
                  {
                     if(_loc1_.basedataid >= GS.a10000)
                     {
                        _loc2_ = _loc3_;
                        _loc1_ = _loc4_;
                     }
                     else if(_loc1_.getscolor() <= _loc4_.getscolor())
                     {
                        if(_loc1_.getscolor() < _loc4_.getscolor())
                        {
                           _loc2_ = _loc3_;
                           _loc1_ = _loc4_;
                        }
                        else
                        {
                           if(_loc1_.curLv >= _loc1_.curLv)
                           {
                              continue;
                           }
                           _loc2_ = _loc3_;
                           _loc1_ = _loc4_;
                        }
                     }
                  }
               }
               else
               {
                  _loc2_ = _loc3_;
                  _loc1_ = _loc4_;
               }
            }
         }
         if(_loc2_ != -1)
         {
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ < GS.a16)
            {
               if(_loc6_ != _loc2_ && this.lwdaoskillArr[_loc6_] != null)
               {
                  _loc5_ += (this.lwdaoskillArr[_loc6_] as PetSkillShowSaveD).curExp;
               }
               _loc6_++;
            }
            _loc7_ = this.lwdaoskillArr[_loc2_];
            _loc7_.addSkillExp(_loc5_);
            this.lwdaoskillArr[0] = _loc7_;
            _loc8_ = int(GS.a1);
            while(_loc8_ < GS.a16)
            {
               this.lwdaoskillArr[_loc8_] = null;
               _loc8_++;
            }
         }
      }
      
      public function sexpMove() : PetSkillShowSaveD
      {
         var _loc1_:PetSkillShowSaveD = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < GS.a7)
         {
            if(this.useskillArr[_loc3_] != null)
            {
               _loc2_ += (this.useskillArr[_loc3_] as PetSkillShowSaveD).curExp;
            }
            _loc3_++;
         }
         if(_loc2_ != 0)
         {
            _loc1_ = new PetSkillShowSaveD();
            _loc1_.initBDid(GS.a10000);
            _loc1_.addSkillExp(_loc2_);
         }
         return _loc1_;
      }
      
      private function isYouTongNameSkill(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.curPot)
         {
            if(this.useskillArr[_loc2_] != null)
            {
               if((this.useskillArr[_loc2_] as PetSkillShowSaveD).getsname() == param1)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getFightScore() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < GS.a7)
         {
            if(this.useskillArr[_loc2_] != null)
            {
               _loc1_ += (this.useskillArr[_loc2_] as PetSkillShowSaveD).curLv;
            }
            _loc2_++;
         }
         return (GS.a4 + GS.a05) / GS.a60 + GS.a01 / GS.a10 * _loc1_;
      }
      
      public function getSkillList() : Array
      {
         var _loc3_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.curPot)
         {
            if(this.useskillArr[_loc2_] != null)
            {
               _loc3_ = new Object();
               _loc3_.sname = "" + this.curPot + (this.useskillArr[_loc2_] as PetSkillShowSaveD).getsfid();
               _loc3_.shurt = (this.useskillArr[_loc2_] as PetSkillShowSaveD).getHurtBi();
               _loc3_.slv = (this.useskillArr[_loc2_] as PetSkillShowSaveD).curLv;
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get curHp() : int
      {
         return this._curHp.getValue();
      }
      
      public function set curHp(param1:int) : void
      {
         this._curHp.setValue(param1);
      }
      
      public function redHp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         this.curHp -= param1;
         if(this.curHp < 0)
         {
            this.curHp = 0;
         }
      }
      
      public function addHp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         this.curHp += param1;
         if(this.curHp > this.getHp())
         {
            this.resetHp();
         }
      }
      
      public function getGv() : Number
      {
         return this.tempPB.gv;
      }
      
      public function getjingJie() : CMJingJie
      {
         return this.tempPB.jingJie;
      }
      
      public function gettraceJuLi() : TraceJuLi
      {
         return this.tempPB.traceJuLi;
      }
      
      public function get tempvHp() : int
      {
         return this._tempvHp.getValue();
      }
      
      public function set tempvHp(param1:int) : void
      {
         this._tempvHp.setValue(param1);
      }
      
      public function get tempvBj() : int
      {
         return this._tempvBj.getValue();
      }
      
      public function set tempvBj(param1:int) : void
      {
         this._tempvBj.setValue(param1);
      }
      
      public function get tempvAtt() : int
      {
         return this._tempvAtt.getValue();
      }
      
      public function set tempvAtt(param1:int) : void
      {
         this._tempvAtt.setValue(param1);
      }
      
      public function get tempvdf() : int
      {
         return this._tempvdf.getValue();
      }
      
      public function set tempvdf(param1:int) : void
      {
         this._tempvdf.setValue(param1);
      }
   }
}

