package hotpointgame.online
{
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.utils.*;
   
   public class OnlineData
   {
      
      private var _curHp:VT = VT.createVT(0);
      
      private var _curMp:VT = VT.createVT(0);
      
      private var _mpSppeed:VT = VT.createVT(0);
      
      private var _rjob:VT = VT.createVT(0);
      
      private var _rlevel:VT = VT.createVT(0);
      
      private var _userid:VT = VT.createVT(0);
      
      private var _userName:String = "";
      
      private var _saveindex:VT = VT.createVT(0);
      
      private var _oldawTitle:int = 0;
      
      private var curatt:PkAttCount;
      
      private var _rOrJ:VT = VT.createVT(0);
      
      private var ratt:PkAttCount;
      
      private var rattJijia:PkAttCount;
      
      private var zbframeArr:Array;
      
      private var skillArr:Array;
      
      private var _groupname:String = "";
      
      private var _curx:VT = VT.createVT(0);
      
      private var _cury:VT = VT.createVT(0);
      
      private var _levelId:VT = VT.createVT(0);
      
      private var _cunFlag:VT = VT.createVT(0);
      
      private var _verFlag:VT = VT.createVT(0);
      
      public function OnlineData()
      {
         super();
         this.curHp = 1000;
         this.curMp = 1000;
      }
      
      public static function createTemp(param1:String) : OnlineData
      {
         var _loc2_:ByteArray = Base64.decodeToByteArray(param1);
         _loc2_.uncompress();
         var _loc3_:Object = _loc2_.readObject();
         var _loc4_:OnlineData = new OnlineData();
         _loc4_.rjob = _loc3_.j;
         _loc4_.rlevel = _loc3_.l;
         _loc4_.userid = _loc3_.i;
         _loc4_.userName = _loc3_.n;
         _loc4_.oldawTitle = _loc3_.o;
         _loc4_.curatt = new PkAttCount();
         _loc4_.ratt = new PkAttCount();
         _loc4_.rattJijia = new PkAttCount();
         _loc4_.zbframeArr = _loc3_.za;
         _loc4_.skillArr = _loc3_.so;
         _loc4_.groupname = _loc3_.gn;
         if(_loc3_.cx != null)
         {
            _loc4_.curx = _loc3_.cx;
            _loc4_.cury = _loc3_.cy;
            _loc4_.levelId = _loc3_.lid;
            _loc4_.cunFlag = _loc3_.lf;
            _loc4_.verFlag = _loc3_.ver;
         }
         return _loc4_;
      }
      
      public static function getonlineObj(param1:int = 0) : String
      {
         var _loc2_:Object = new Object();
         _loc2_.j = FlowInterface.getJobByRole();
         _loc2_.l = GM.cp.getZtLevel();
         _loc2_.i = GM.testapi.userId;
         _loc2_.n = GM.testapi.userName;
         _loc2_.o = GM.aSaveData.pksd.oldawTitleb;
         _loc2_.za = ["","","","","","","","","","","","","","","","",FlowInterface.getEquipMcName(GS.a16),"","",""];
         _loc2_.so = GM.skillLvM.getBaseSkillLevel();
         _loc2_.gn = GoodsManger.dataList.unionData.getUname();
         _loc2_.cx = GM.cp.getZx();
         _loc2_.cy = GM.cp.getZy();
         if(GM.levelm.curLevel != null)
         {
            _loc2_.lid = GM.levelm.curLevel.id;
         }
         else
         {
            _loc2_.lid = 0;
         }
         _loc2_.lf = param1;
         _loc2_.ver = GS.a1;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(_loc2_);
         _loc3_.compress();
         _loc3_.position = 0;
         return Base64.encodeByteArray(_loc3_);
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
         return this.skillArr;
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
      
      public function get userid() : uint
      {
         return this._userid.getValue();
      }
      
      public function set userid(param1:uint) : void
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
      
      public function get groupname() : String
      {
         return this._groupname;
      }
      
      public function set groupname(param1:String) : void
      {
         this._groupname = param1;
      }
      
      public function get curx() : Number
      {
         return this._curx.getValue();
      }
      
      public function set curx(param1:Number) : void
      {
         this._curx.setValue(param1);
      }
      
      public function get cury() : Number
      {
         return this._cury.getValue();
      }
      
      public function set cury(param1:Number) : void
      {
         this._cury.setValue(param1);
      }
      
      public function get levelId() : int
      {
         return this._levelId.getValue();
      }
      
      public function set levelId(param1:int) : void
      {
         this._levelId.setValue(param1);
      }
      
      public function get cunFlag() : int
      {
         return this._cunFlag.getValue();
      }
      
      public function set cunFlag(param1:int) : void
      {
         this._cunFlag.setValue(param1);
      }
      
      public function get verFlag() : int
      {
         return this._verFlag.getValue();
      }
      
      public function set verFlag(param1:int) : void
      {
         this._verFlag.setValue(param1);
      }
   }
}

