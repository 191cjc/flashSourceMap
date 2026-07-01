package hotpointgame.grole
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.pet.*;
   import hotpointgame.utils.gameloader.*;
   
   public class MPlayer
   {
      
      private var _job:VT = VT.createVT(0);
      
      private var _level:VT = VT.createVT(1);
      
      private var _gunSlotNum:VT = VT.createVT(0);
      
      private var _expCur:VT = VT.createVT(0);
      
      private var _god:VT = VT.createVT(0);
      
      private var _dianJuan:VT = VT.createVT(0);
      
      private var levelData:RoleLevelData;
      
      private var _hpCur:VT = VT.createVT(0);
      
      private var _mpCur:VT = VT.createVT(0);
      
      private var _mpJi:VT = VT.createVT(0);
      
      private var _pkAddHp:VT = VT.createVT(0);
      
      public function MPlayer()
      {
         super();
      }
      
      public static function readData(param1:Object) : MPlayer
      {
         var _loc2_:MPlayer = new MPlayer();
         _loc2_.job = param1["job"];
         _loc2_.level = param1["lv"];
         _loc2_.gunSlotNum = param1["sn"];
         _loc2_.expCur = param1["ec"];
         _loc2_.god = param1["g"];
         _loc2_.dianJuan = param1["d"];
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["job"] = this.job;
         _loc1_["lv"] = this.level;
         _loc1_["sn"] = GM.cp.getOpenSlotNum();
         _loc1_["ec"] = this.expCur;
         _loc1_["g"] = this.god;
         _loc1_["d"] = this.dianJuan;
         return _loc1_;
      }
      
      public function remove() : void
      {
         this.levelData = null;
      }
      
      public function initAfterXml() : void
      {
         this.levelData = RoleActionManger.getLevelData(this.level);
         this.hpCur = this.hpMax;
         this.mpCur = this.mpMax;
         Czhujiemian.self.updateRoleLevel(this.level);
         Czhujiemian.self.updateRoleHpAndMp(this.hpCur,this.hpMax,this.mpCur,this.mpMax,this.expCur,this.levelData.nextexp);
      }
      
      public function gmUpdate() : void
      {
         ++this.mpJi;
         if(this.mpJi % GS.a30 == 0)
         {
            this.addMp(GS.a100);
         }
         Czhujiemian.self.updateRoleHpAndMp(this.hpCur,this.hpMax,this.mpCur,this.mpMax,this.expCur,this.levelData.nextexp);
      }
      
      public function addExp(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a1);
            return;
         }
         if(this.level == PetManager.levelMax)
         {
            return;
         }
         this.expCur += param1;
         if(this.expCur > this.levelData.nextexp)
         {
            while(this.expCur > this.levelData.nextexp)
            {
               this.expCur -= this.levelData.nextexp;
               this.level += GS.a1;
               _loc2_ = new (LoaderManager.getSwfClass("shengjixiaoguo"))() as MovieClip;
               _loc2_.x = GM.cp.getZx();
               _loc2_.y = GM.cp.getZy();
               GM.levelm.addMcInMoveMc(_loc2_);
               XiaoXiaoManager.addCGX(new CGXFrame(_loc2_,null));
               Czhujiemian.self.updateRoleLevel(this.level);
               this.levelData = RoleActionManger.getLevelData(this.level);
               this.hpCur = this.hpMax;
               this.mpCur = this.mpMax;
               if(this.level == PetManager.levelMax)
               {
                  this.expCur = 0;
                  break;
               }
            }
         }
      }
      
      public function redHp(param1:int) : void
      {
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a6);
            return;
         }
         this.hpCur -= param1;
         if(this.hpCur < 0)
         {
            this.hpCur = 0;
         }
      }
      
      public function addHp(param1:int) : void
      {
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a3);
            return;
         }
         this.hpCur += param1;
         if(this.hpCur > this.hpMax)
         {
            this.hpCur = this.hpMax;
         }
      }
      
      public function addMp(param1:int) : void
      {
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a4);
            return;
         }
         this.mpCur += param1;
         if(this.mpCur > this.mpMax)
         {
            this.mpCur = this.mpMax;
         }
      }
      
      public function redMp(param1:int) : void
      {
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a7);
            return;
         }
         this.mpCur -= param1;
         if(this.mpCur < 0)
         {
            this.mpCur = 0;
         }
      }
      
      public function addGod(param1:int) : void
      {
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a2);
            return;
         }
         var _loc2_:int = this.god + param1;
         if(_loc2_ >= this.levelData.maxGod)
         {
            this.god = this.levelData.maxGod;
         }
         else
         {
            this.god = _loc2_;
         }
      }
      
      public function redGod(param1:int) : void
      {
         if(param1 < 0)
         {
            GM.findCheatMax(GS.a5);
            return;
         }
         var _loc2_:int = this.god - param1;
         if(_loc2_ >= 0)
         {
            this.god = _loc2_;
         }
         else
         {
            this.god = 0;
         }
      }
      
      public function curHpRat() : int
      {
         return this.hpCur / this.hpMax * GS.a100;
      }
      
      public function relive() : void
      {
         this.mpCur = this.mpMax;
         this.hpCur = this.hpMax;
      }
      
      public function getCurLevelData() : RoleLevelData
      {
         return this.levelData;
      }
      
      public function getAttackValue() : Number
      {
         return FlowInterface.getAtt() + this.levelData.rat + GM.aSaveData.sxiaolevel.getAddA() + GM.aSaveData.sxiaolevel.getAddAB();
      }
      
      public function getDefenceValue() : Number
      {
         return (FlowInterface.getFy() + this.levelData.rdf + GM.aSaveData.sxiaolevel.getAddD()) * (GS.a1 + FlowInterface.getFy(GS.a1) + GM.cp.zCd.getTqatt(GS.a2));
      }
      
      public function getBaoji() : Number
      {
         return FlowInterface.getBj() + this.levelData.rbaoji / GS.a10000 + GM.aSaveData.sxiaolevel.getAddBJ() + GM.cp.zCd.getTqatt(GS.a1);
      }
      
      public function getRoleSpeed() : int
      {
         return FlowInterface.getSp() + this.levelData.rspeed;
      }
      
      public function getToMaxLvExp() : uint
      {
         var _loc1_:Number = this.levelData.toMaxLvExp - this.expCur;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      public function get job() : int
      {
         return this._job.getValue();
      }
      
      public function set job(param1:int) : void
      {
         this._job.setValue(param1);
      }
      
      public function get level() : int
      {
         return this._level.getValue();
      }
      
      public function set level(param1:int) : void
      {
         this._level.setValue(param1);
      }
      
      public function get gunSlotNum() : int
      {
         return this._gunSlotNum.getValue();
      }
      
      public function set gunSlotNum(param1:int) : void
      {
         this._gunSlotNum.setValue(param1);
      }
      
      public function get expCur() : int
      {
         return this._expCur.getValue();
      }
      
      public function set expCur(param1:int) : void
      {
         this._expCur.setValue(param1);
      }
      
      public function get hpMax() : int
      {
         var _loc1_:int = (FlowInterface.getHp() + this.levelData.rhp + GM.aSaveData.sxiaolevel.getAddHp() + GM.aSaveData.sxiaolevel.getAddHpB()) * (GS.a1 + FlowInterface.getHp(GS.a1));
         _loc1_ += this.pkAddHp;
         if(_loc1_ < this.hpCur)
         {
            this.hpCur = _loc1_;
         }
         return _loc1_;
      }
      
      public function get hpCur() : int
      {
         return this._hpCur.getValue();
      }
      
      public function set hpCur(param1:int) : void
      {
         this._hpCur.setValue(param1);
      }
      
      public function get mpMax() : int
      {
         var _loc1_:int = (FlowInterface.getNl() + this.levelData.rmp + GM.aSaveData.sxiaolevel.getAddNL()) * (GS.a1 + FlowInterface.getNl(GS.a1));
         if(_loc1_ < this.mpCur)
         {
            this.mpCur = _loc1_;
         }
         return _loc1_;
      }
      
      public function get mpCur() : int
      {
         return this._mpCur.getValue();
      }
      
      public function set mpCur(param1:int) : void
      {
         this._mpCur.setValue(param1);
      }
      
      public function get god() : int
      {
         return this._god.getValue();
      }
      
      public function set god(param1:int) : void
      {
         this._god.setValue(param1);
      }
      
      public function getMaxGod() : int
      {
         return this.levelData.maxGod;
      }
      
      public function get dianJuan() : int
      {
         return this._dianJuan.getValue();
      }
      
      public function set dianJuan(param1:int) : void
      {
         this._dianJuan.setValue(param1);
      }
      
      public function get mpJi() : int
      {
         return this._mpJi.getValue();
      }
      
      public function set mpJi(param1:int) : void
      {
         this._mpJi.setValue(param1);
      }
      
      public function get pkAddHp() : int
      {
         return this._pkAddHp.getValue();
      }
      
      public function set pkAddHp(param1:int) : void
      {
         this._pkAddHp.setValue(param1);
      }
   }
}

