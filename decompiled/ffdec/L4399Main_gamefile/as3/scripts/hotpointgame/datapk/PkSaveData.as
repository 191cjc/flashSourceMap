package hotpointgame.datapk
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.grole.*;
   import hotpointgame.gskilllevel.*;
   import hotpointgame.savedatal.*;
   import hotpointgame.utils.*;
   
   public class PkSaveData
   {
      
      private var _curHp:VT;
      
      private var _curMp:VT;
      
      private var _mpSppeed:VT;
      
      private var _rjob:VT;
      
      private var _rlevel:VT;
      
      private var _userid:VT;
      
      private var _userName:String = "";
      
      private var _saveindex:VT;
      
      private var _oldawTitle:int = 0;
      
      private var curatt:PkAttCount;
      
      private var _rOrJ:VT;
      
      private var ratt:PkAttCount;
      
      private var rattJijia:PkAttCount;
      
      private var zbframeArr:Array;
      
      private var skillLM:SkillLevelManager;
      
      public function PkSaveData(param1:Object)
      {
         var _loc6_:ShengxiaoDouHunList = null;
         this._curHp = VT.createVT(0);
         this._curMp = VT.createVT(0);
         this._mpSppeed = VT.createVT(0);
         this._rjob = VT.createVT(0);
         this._rlevel = VT.createVT(0);
         this._userid = VT.createVT(0);
         this._saveindex = VT.createVT(0);
         this._rOrJ = VT.createVT(0);
         super();
         this.rlevel = param1.jxrole.lv;
         this.userid = param1.jxid;
         if(param1.newnn != null)
         {
            this.userName = DeepCopyUtil.decode(param1.newnn);
         }
         else
         {
            this.userName = param1.jxname;
         }
         if(param1.asaved.pks.oldt != null)
         {
            this.oldawTitle = param1.asaved.pks.oldt;
         }
         this.rjob = param1.jxv;
         var _loc2_:RoleLevelData = RoleActionManger.getLevelData(this.rlevel);
         var _loc3_:PkKaiZong = FlowInterface.countValueBysave(param1.jxkaizhong);
         var _loc4_:PkAttKZ = _loc3_.roleAtt;
         var _loc5_:PkAttKZ = _loc3_.roleAttAndJiJia;
         this.zbframeArr = _loc3_.zbArr;
         if(param1.asaved)
         {
            _loc6_ = ShengxiaoDouHunList.readData(param1.asaved.sxlv);
         }
         else
         {
            _loc6_ = ShengxiaoDouHunList.readData();
         }
         this.ratt = new PkAttCount();
         this.rattJijia = new PkAttCount();
         this.ratt.hp = (_loc4_.hp + _loc2_.rhp + _loc6_.getAddHp() + _loc6_.getAddHpB()) * (GS.a1 + _loc4_.hpPrce) * GS.a2;
         this.ratt.nl = (_loc4_.nl + _loc2_.rmp + _loc6_.getAddNL()) * (GS.a1 + _loc4_.nlPrce);
         this.ratt.gj = (_loc4_.gj + _loc2_.rat + _loc6_.getAddA() + _loc6_.getAddAB()) * (GS.a1 + _loc4_.gjPrce);
         this.ratt.fy = (_loc4_.fy + _loc2_.rdf + _loc6_.getAddD()) * (GS.a1 + _loc4_.fyPrce);
         this.ratt.bj = _loc4_.bj + _loc2_.rbaoji / GS.a10000 + _loc6_.getAddBJ();
         this.ratt.sd = _loc4_.sd + _loc2_.rspeed;
         this.ratt.jin = (_loc4_.jin + _loc6_.getAddJin()) * (GS.a1 + _loc4_.jinPrce);
         this.ratt.mu = (_loc4_.mu + _loc6_.getAddMu()) * (GS.a1 + _loc4_.muPrce);
         this.ratt.shui = (_loc4_.shui + _loc6_.getAddShui()) * (GS.a1 + _loc4_.shuiPrce);
         this.ratt.huo = (_loc4_.huo + _loc6_.getAddHuo()) * (GS.a1 + _loc4_.huoPrce);
         this.ratt.tu = (_loc4_.tu + _loc6_.getAddTu()) * (GS.a1 + _loc4_.tuPrce);
         this.ratt.hd = (_loc4_.hd + _loc6_.getAddHD() + _loc6_.getAddHDB()) * (GS.a1 + _loc4_.hdPrce);
         this.rattJijia.hp = (_loc5_.hp + _loc2_.rhp + _loc6_.getAddHp() + _loc6_.getAddHpB()) * (GS.a1 + _loc5_.hpPrce) * GS.a2;
         this.rattJijia.nl = (_loc5_.nl + _loc2_.rmp + _loc6_.getAddNL()) * (GS.a1 + _loc5_.nlPrce);
         this.rattJijia.gj = (_loc5_.gj + _loc2_.rat + _loc6_.getAddA() + _loc6_.getAddAB()) * (GS.a1 + _loc5_.gjPrce);
         this.rattJijia.fy = (_loc5_.fy + _loc2_.rdf + _loc6_.getAddD()) * (GS.a1 + _loc5_.fyPrce);
         this.rattJijia.bj = _loc5_.bj + _loc2_.rbaoji / GS.a10000 + _loc6_.getAddBJ();
         this.rattJijia.sd = _loc5_.sd + _loc2_.rspeed;
         this.rattJijia.jin = (_loc5_.jin + _loc6_.getAddJin()) * (GS.a1 + _loc5_.jinPrce);
         this.rattJijia.mu = (_loc5_.mu + _loc6_.getAddMu()) * (GS.a1 + _loc5_.muPrce);
         this.rattJijia.shui = (_loc5_.shui + _loc6_.getAddShui()) * (GS.a1 + _loc5_.shuiPrce);
         this.rattJijia.huo = (_loc5_.huo + _loc6_.getAddHuo()) * (GS.a1 + _loc5_.huoPrce);
         this.rattJijia.tu = (_loc5_.tu + _loc6_.getAddTu()) * (GS.a1 + _loc5_.tuPrce);
         this.rattJijia.hd = _loc5_.hd * (GS.a1 + _loc5_.hdPrce);
         this.skillLM = SkillLevelManager.readData(param1.jxjinenglv);
      }
      
      public function initrole() : void
      {
         this.rOrJ = 0;
         this.curatt = this.ratt;
         this.curHp = this.maxHp;
         this.curMp = 0;
      }
      
      public function reEnterrole() : void
      {
         this.rOrJ = 0;
         this.curatt = this.ratt;
      }
      
      public function reEnterJiJia() : void
      {
         this.rOrJ = GS.a1;
         this.curatt = this.rattJijia;
      }
      
      public function getZtype() : int
      {
         return 0;
      }
      
      public function getZgroup() : int
      {
         return 0;
      }
      
      public function getGv() : int
      {
         return GS.a2;
      }
      
      public function getjingJie() : CMJingJie
      {
         return new CMJingJie(-10000,10000,-1000,1000);
      }
      
      public function gettraceJuLi() : TraceJuLi
      {
         if(this.rjob == GS.a1)
         {
            return new TraceJuLi(170,250,-100,100);
         }
         return new TraceJuLi(0,100,-150,20);
      }
      
      public function getSkillList() : Array
      {
         return this.skillLM.getBaseSkillLevel();
      }
      
      public function getZBArr() : Array
      {
         return this.zbframeArr;
      }
      
      public function isYouJiJia() : Boolean
      {
         if(this.zbframeArr[GS.a7] != "" && this.rOrJ == GS.a0)
         {
            return true;
         }
         return false;
      }
      
      public function hpCountRJ() : int
      {
         return this.rattJijia.hp - this.ratt.hp;
      }
      
      public function getZtLevel() : int
      {
         return this.rlevel;
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
         if(this.curHp > this.maxHp)
         {
            this.curHp = this.maxHp;
         }
      }
      
      public function redMp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         this.curMp -= param1;
         if(this.curMp < 0)
         {
            this.curMp = 0;
         }
      }
      
      public function addMp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         this.curMp += param1;
         if(this.curMp > this.maxMp)
         {
            this.curMp = this.maxMp;
         }
      }
      
      public function getRoleSpeed() : int
      {
         return this.curatt.sd;
      }
      
      public function getAttackValue() : Number
      {
         return this.curatt.gj;
      }
      
      public function getDefenceValue() : Number
      {
         return this.curatt.fy;
      }
      
      public function getWuxinSX(param1:int) : int
      {
         return 0;
      }
      
      public function getJin() : Number
      {
         return this.curatt.jin;
      }
      
      public function getMu() : Number
      {
         return this.curatt.mu;
      }
      
      public function getShui() : Number
      {
         return this.curatt.shui;
      }
      
      public function getHuo() : Number
      {
         return this.curatt.huo;
      }
      
      public function getTu() : Number
      {
         return this.curatt.tu;
      }
      
      public function getHd() : Number
      {
         return this.curatt.hd;
      }
      
      public function getBaojiJL() : Number
      {
         return this.curatt.bj;
      }
      
      public function get curHp() : int
      {
         return this._curHp.getValue();
      }
      
      public function set curHp(param1:int) : void
      {
         this._curHp.setValue(param1);
      }
      
      public function get maxHp() : int
      {
         return this.curatt.hp;
      }
      
      public function get curMp() : int
      {
         return this._curMp.getValue();
      }
      
      public function set curMp(param1:int) : void
      {
         this._curMp.setValue(param1);
      }
      
      public function get mpSppeed() : int
      {
         return this._mpSppeed.getValue();
      }
      
      public function set mpSppeed(param1:int) : void
      {
         if(this.mpSppeed == 0)
         {
            this._mpSppeed.setValue(param1);
         }
      }
      
      public function get maxMp() : int
      {
         return this.curatt.nl;
      }
      
      public function get rOrJ() : int
      {
         return this._rOrJ.getValue();
      }
      
      public function set rOrJ(param1:int) : void
      {
         this._rOrJ.setValue(param1);
      }
      
      public function get rlevel() : int
      {
         return this._rlevel.getValue();
      }
      
      public function set rlevel(param1:int) : void
      {
         this._rlevel.setValue(param1);
      }
      
      public function get userid() : int
      {
         return this._userid.getValue();
      }
      
      public function set userid(param1:int) : void
      {
         this._userid.setValue(param1);
      }
      
      public function get saveindex() : int
      {
         return this._saveindex.getValue();
      }
      
      public function set saveindex(param1:int) : void
      {
         this._saveindex.setValue(param1);
      }
      
      public function get userName() : String
      {
         return this._userName;
      }
      
      public function set userName(param1:String) : void
      {
         this._userName = param1;
      }
      
      public function get rjob() : int
      {
         return this._rjob.getValue();
      }
      
      public function set rjob(param1:int) : void
      {
         this._rjob.setValue(param1);
      }
      
      public function get oldawTitle() : int
      {
         return this._oldawTitle;
      }
      
      public function set oldawTitle(param1:int) : void
      {
         this._oldawTitle = param1;
      }
   }
}

