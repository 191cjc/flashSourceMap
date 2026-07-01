package hotpointgame.pet
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.models.bag.*;
   
   public class PetManager
   {
      
      private static var _levelMax:VT = VT.createVT(GS.a65);
      
      private static var _petLevelMax:VT = VT.createVT(GS.a65);
      
      private var _opennum:VT = VT.createVT(GS.a3);
      
      private var _numlimit:VT = VT.createVT(GS.a12);
      
      private var petArr:Array = new Array();
      
      private var eggArr:Array = new Array();
      
      private var _fightPet:VT = VT.createVT(0);
      
      private var _petRHPFlag:VT = VT.createVT(0);
      
      public function PetManager()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : PetManager
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc2_:PetManager = new PetManager();
         if(param1 != null)
         {
            _loc2_.opennum = param1.onum;
            _loc3_ = param1.parr;
            _loc4_ = new Array();
            for(_loc5_ in _loc3_)
            {
               _loc9_ = _loc3_[_loc5_];
               if(_loc9_ != null && int(_loc9_.id) != 0)
               {
                  _loc4_[Number(_loc5_)] = PetR.readData(_loc3_[_loc5_]);
               }
            }
            _loc2_.petArr = _loc4_;
            _loc6_ = param1.earr;
            _loc7_ = new Array();
            for(_loc8_ in _loc6_)
            {
               _loc10_ = _loc6_[_loc8_];
               if(_loc10_ != null && int(_loc10_.id) != 0)
               {
                  _loc7_[Number(_loc8_)] = EggR.readData(_loc6_[_loc8_]);
               }
            }
            _loc2_.eggArr = _loc7_;
         }
         return _loc2_;
      }
      
      public static function get levelMax() : int
      {
         return _levelMax.getValue();
      }
      
      public static function set levelMax(param1:int) : void
      {
         _levelMax.setValue(param1);
      }
      
      public static function get petLevelMax() : int
      {
         return _petLevelMax.getValue();
      }
      
      public static function set petLevelMax(param1:int) : void
      {
         _petLevelMax.setValue(param1);
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.onum = this.opennum;
         _loc1_.fp = this.fightPet;
         var _loc2_:Object = new Object();
         var _loc3_:int = int(GS.a1);
         while(_loc3_ <= this.opennum)
         {
            if(this.petArr[_loc3_] != null)
            {
               _loc2_[_loc3_] = (this.petArr[_loc3_] as PetR).save();
            }
            _loc3_++;
         }
         _loc1_.parr = _loc2_;
         var _loc4_:Object = new Object();
         var _loc5_:int = int(GS.a1);
         while(_loc5_ <= this.opennum)
         {
            if(this.eggArr[_loc5_] != null)
            {
               _loc4_[_loc5_] = (this.eggArr[_loc5_] as EggR).save();
            }
            _loc5_++;
         }
         _loc1_.earr = _loc4_;
         return _loc1_;
      }
      
      public function getPetEggById(param1:int) : Object
      {
         if(this.petArr[param1] !== null)
         {
            return this.petArr[param1];
         }
         if(this.eggArr[param1] != null)
         {
            return this.eggArr[param1];
         }
         return null;
      }
      
      public function get opennum() : int
      {
         return this._opennum.getValue();
      }
      
      public function set opennum(param1:int) : void
      {
         this._opennum.setValue(param1);
      }
      
      public function addOpenNum() : void
      {
         this.opennum += GS.a1;
         if(this.opennum > this.numlimit)
         {
            this.opennum = this.numlimit;
         }
      }
      
      public function getPetById(param1:int) : PetR
      {
         return this.petArr[param1];
      }
      
      public function saveAfterCount() : void
      {
         var _loc1_:int = int(GS.a1);
         while(_loc1_ <= this.opennum)
         {
            if(this.petArr[_loc1_] != null)
            {
               (this.petArr[_loc1_] as PetR).pbag.jsSx();
               (this.petArr[_loc1_] as PetR).saveAfter();
            }
            _loc1_++;
         }
      }
      
      public function getEggById(param1:int) : PetR
      {
         return this.eggArr[param1];
      }
      
      public function isKeyiUseEgg() : Boolean
      {
         var _loc1_:int = int(GS.a1);
         while(_loc1_ <= this.opennum)
         {
            if(this.petArr[_loc1_] == null && this.eggArr[_loc1_] == null)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function useEgg(param1:Number, param2:Number, param3:int) : Boolean
      {
         var _loc5_:EggR = null;
         var _loc4_:int = int(GS.a1);
         while(_loc4_ <= this.opennum)
         {
            if(this.petArr[_loc4_] == null && this.eggArr[_loc4_] == null)
            {
               _loc5_ = new EggR();
               _loc5_.pid = param1;
               _loc5_.pcolor = param3;
               _loc5_.datelimit = param2;
               this.eggArr[_loc4_] = _loc5_;
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function getAllPet() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = int(GS.a1);
         while(_loc2_ <= this.numlimit)
         {
            if(this.petArr[_loc2_] != null)
            {
               _loc1_[_loc2_] = this.petArr[_loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPetList(param1:int) : Array
      {
         var _loc4_:int = 0;
         this.autoUpdate();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < GS.a4)
         {
            _loc4_ = param1 * GS.a4 + _loc3_ + GS.a1;
            if(this.petArr[_loc4_] != null)
            {
               _loc2_[_loc3_] = this.petArr[_loc4_];
            }
            else if(this.eggArr[_loc4_] != null)
            {
               _loc2_[_loc3_] = this.eggArr[_loc4_];
            }
            else
            {
               _loc2_[_loc3_] = null;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function autoUpdate() : void
      {
         var _loc2_:EggR = null;
         var _loc3_:PetR = null;
         var _loc1_:int = int(GS.a1);
         while(_loc1_ <= this.numlimit)
         {
            if(this.eggArr[_loc1_] != null)
            {
               _loc2_ = this.eggArr[_loc1_];
               if(_loc2_.countTime() <= 0)
               {
                  this.eggArr[_loc1_] = null;
                  _loc3_ = new PetR();
                  _loc3_.initBid(_loc2_.pid);
                  this.petArr[_loc1_] = _loc3_;
               }
            }
            _loc1_++;
         }
      }
      
      public function eggChangPet(param1:int) : void
      {
         var _loc2_:EggR = null;
         var _loc3_:PetR = null;
         if(this.eggArr[param1] != null)
         {
            _loc2_ = this.eggArr[param1];
            this.eggArr[param1] = null;
            _loc3_ = new PetR();
            _loc3_.initBid(_loc2_.pid);
            this.petArr[param1] = _loc3_;
         }
      }
      
      public function delPetByFangsheng(param1:int) : void
      {
         if(this.petArr[param1] != null)
         {
            if(this.fightPet == param1)
            {
               GM.levelm.removeAllPet();
               this.fightPet = 0;
               Czhujiemian.self.petHeadNoShow();
            }
            this.petArr[param1] = null;
         }
      }
      
      public function joinFight(param1:int) : Boolean
      {
         if(this.fightPet != param1 && this.petArr[param1] != null && (this.petArr[param1] as PetR).curHp > 0)
         {
            GM.levelm.removeAllPet();
            this.fightPet = param1;
            this.createFightPet();
            return true;
         }
         return false;
      }
      
      public function stopFight(param1:int) : Boolean
      {
         if(this.fightPet == param1)
         {
            GM.levelm.removeAllPet();
            this.fightPet = 0;
            Czhujiemian.self.petHeadNoShow();
            return true;
         }
         return false;
      }
      
      public function get fightPet() : int
      {
         return this._fightPet.getValue();
      }
      
      public function restAllHpAndFight() : void
      {
         var _loc1_:int = 0;
         if(this.petRHPFlag != 0)
         {
            _loc1_ = int(GS.a1);
            while(_loc1_ <= this.opennum)
            {
               if(this.petArr[_loc1_] != null)
               {
                  (this.petArr[_loc1_] as PetR).resetHp();
               }
               _loc1_++;
            }
            this.createFightPet();
            this.petRHPFlag = 0;
         }
      }
      
      public function createFightPet() : void
      {
         var _loc1_:PetR = null;
         var _loc2_:PetFight = null;
         if(GM.levelm.getgaPetNum() == 0 && this.fightPet != 0)
         {
            _loc1_ = this.petArr[this.fightPet];
            if(_loc1_ != null && _loc1_.curHp > 0)
            {
               _loc2_ = new PetFight(_loc1_,GM.cp.getZx(),GM.cp.getZy());
               GM.levelm.addPet(_loc2_);
            }
         }
      }
      
      public function set fightPet(param1:int) : void
      {
         this._fightPet.setValue(param1);
      }
      
      public function fightingpetAddExp(param1:int) : void
      {
         var _loc2_:PetR = null;
         if(this.fightPet != 0)
         {
            _loc2_ = this.petArr[this.fightPet];
            if(_loc2_ != null && _loc2_.curHp > 0)
            {
               _loc2_.addExp(param1);
            }
         }
      }
      
      public function fightingpetAddExpByVip(param1:int) : void
      {
         var _loc2_:PetR = null;
         if(this.fightPet != 0)
         {
            _loc2_ = this.petArr[this.fightPet];
            if(_loc2_ != null && _loc2_.curHp > 0)
            {
               _loc2_.addExp(param1 * (GS.a1 + VipDataManager.vself.getaddpetexpR()));
            }
         }
      }
      
      public function getFightingPet() : PetR
      {
         if(this.fightPet != 0)
         {
            return this.petArr[this.fightPet];
         }
         return null;
      }
      
      public function getFightgAtt() : Number
      {
         if(this.fightPet != 0)
         {
            return (this.petArr[this.fightPet] as PetR).pbag.getZdl();
         }
         return 0;
      }
      
      public function getFightSkillScore() : Number
      {
         if(this.fightPet != 0)
         {
            return (this.petArr[this.fightPet] as PetR).getFightScore();
         }
         return 0;
      }
      
      public function petReliveing() : void
      {
         var _loc1_:PetR = null;
         if(this.fightPet != 0 && GM.levelm.getgaPetNum() == 0)
         {
            _loc1_ = this.petArr[this.fightPet];
            if(_loc1_ != null && _loc1_.curHp == 0)
            {
               if(GM.ckey.isKey("宠物复活"))
               {
                  if(BagFactory.otherBag.deleteGoods(GS.a331101 + GS.a2,GS.a1))
                  {
                     _loc1_.resetHp();
                     this.createFightPet();
                  }
                  else
                  {
                     GoodsManger.cwTs("宠物复活币不足!");
                  }
               }
            }
         }
      }
      
      public function petJinHuaByFighting(param1:int) : Boolean
      {
         if(this.petArr[param1] != null)
         {
            if((this.petArr[param1] as PetR).petJinHua())
            {
               if(this.fightPet == param1)
               {
                  GM.levelm.removeAllPet();
                  this.createFightPet();
               }
               return true;
            }
         }
         return false;
      }
      
      public function saveToSaveDrag(param1:int, param2:int, param3:int) : String
      {
         if(this.petArr[param1] != null)
         {
            return (this.petArr[param1] as PetR).lwDaoSkillDrag(param2,param3);
         }
         return "errorsaveT";
      }
      
      public function useToUseDrag(param1:int, param2:int, param3:int) : String
      {
         var _loc4_:String = null;
         if(this.petArr[param1] != null)
         {
            _loc4_ = (this.petArr[param1] as PetR).useskillDrag(param2,param3);
            if(this.fightPet == param1 && _loc4_ == "成功")
            {
               GM.levelm.removeAllPet();
               this.createFightPet();
            }
            return _loc4_;
         }
         return "erroruseT";
      }
      
      public function saveToUseDrag(param1:int, param2:int, param3:int) : String
      {
         var _loc4_:String = null;
         if(this.petArr[param1] != null)
         {
            _loc4_ = (this.petArr[param1] as PetR).lwdaoDraguse(param2,param3);
            if(this.fightPet == param1 && _loc4_ == "成功")
            {
               GM.levelm.removeAllPet();
               this.createFightPet();
            }
            return _loc4_;
         }
         return "errorsavetu";
      }
      
      public function useToSaveDrag(param1:int, param2:int, param3:int) : String
      {
         var _loc4_:String = null;
         if(this.petArr[param1] != null)
         {
            _loc4_ = (this.petArr[param1] as PetR).useDraglwdao(param2,param3);
            if(this.fightPet == param1 && _loc4_ == "成功")
            {
               GM.levelm.removeAllPet();
               this.createFightPet();
            }
            return _loc4_;
         }
         return "errorusets";
      }
      
      public function isFighting(param1:int) : Boolean
      {
         return this.fightPet == param1;
      }
      
      public function petRongHe(param1:int, param2:int) : Boolean
      {
         var _loc3_:PetR = null;
         var _loc4_:PetR = null;
         var _loc5_:PetSkillShowSaveD = null;
         if(param1 != param2 && this.petArr[param1] != null && this.petArr[param2] != null)
         {
            _loc3_ = this.petArr[param1];
            _loc4_ = this.petArr[param2];
            if(_loc4_.isRHLvLimit())
            {
               return false;
            }
            if(!_loc4_.isYoulwWeiZhi())
            {
               return false;
            }
            _loc4_.addRHexp(_loc3_.toExp);
            _loc5_ = _loc3_.sexpMove();
            if(_loc5_ != null)
            {
               _loc4_.lwDaoSkillArrAdd(_loc5_);
            }
            this.petArr[param1] = null;
            this.stopFight(param1);
            return true;
         }
         return false;
      }
      
      public function getKeRHPetList(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = int(GS.a1);
         while(_loc3_ <= this.numlimit)
         {
            if(_loc3_ != param1 && this.petArr[_loc3_] != null)
            {
               _loc2_[_loc3_] = this.petArr[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addPetBypid(param1:int) : void
      {
         var _loc2_:PetR = new PetR();
         _loc2_.initBid(param1);
         var _loc3_:int = int(GS.a1);
         while(_loc3_ <= this.opennum)
         {
            if(this.petArr[_loc3_] == null && this.eggArr[_loc3_] == null)
            {
               this.petArr[_loc3_] = _loc2_;
               return;
            }
            _loc3_++;
         }
      }
      
      public function addRHexpBypid(param1:int, param2:int) : void
      {
         if(this.petArr[param1] != null)
         {
            (this.petArr[param1] as PetR).addRHexp(param2);
         }
      }
      
      public function addPetSkillBypid(param1:int, param2:int) : void
      {
         var _loc3_:PetSkillShowSaveD = null;
         if(this.petArr[param1] != null)
         {
            _loc3_ = new PetSkillShowSaveD();
            _loc3_.initBDid(param2);
            (this.petArr[param1] as PetR).lwDaoSkillArrAdd(_loc3_);
         }
      }
      
      public function get numlimit() : int
      {
         return this._numlimit.getValue();
      }
      
      public function set numlimit(param1:int) : void
      {
         this._numlimit.setValue(param1);
      }
      
      public function get petRHPFlag() : int
      {
         return this._petRHPFlag.getValue();
      }
      
      public function set petRHPFlag(param1:int) : void
      {
         this._petRHPFlag.setValue(param1);
      }
   }
}

