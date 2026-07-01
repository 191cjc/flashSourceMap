package hotpointgame.datapk
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.*;
   
   public class TopData
   {
      
      private var _uid:VT = VT.createVT(0);
      
      private var _sindex:VT = VT.createVT(0);
      
      private var _rank:VT = VT.createVT(0);
      
      private var _score:VT = VT.createVT(0);
      
      private var _nickn:String = "";
      
      private var _extO:Object = new Object();
      
      private var _pwin:VT = VT.createVT(0);
      
      private var _plost:VT = VT.createVT(0);
      
      private var _pwinwin:VT = VT.createVT(0);
      
      public function TopData()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : TopData
      {
         var _loc2_:TopData = new TopData();
         if(param1 != null)
         {
            _loc2_.uid = param1.id;
            _loc2_.sindex = param1.sin;
            _loc2_.rank = param1.rk;
            _loc2_.score = param1.se;
            if(param1.newnn != null)
            {
               _loc2_.nickn = DeepCopyUtil.decode(param1.newnn);
            }
            else
            {
               _loc2_.nickn = param1.nn;
            }
            _loc2_.extO = param1.eo;
         }
         return _loc2_;
      }
      
      public static function createS(param1:Object) : TopData
      {
         var _loc2_:TopData = new TopData();
         _loc2_.uid = uint(param1.uId);
         _loc2_.sindex = int(param1.index);
         _loc2_.rank = param1.rank;
         _loc2_.score = param1.score;
         _loc2_.nickn = param1.userName;
         _loc2_.extO = param1.extra;
         _loc2_.pwin = param1.extra.qsl;
         _loc2_.plost = param1.extra.qsb;
         _loc2_.pwinwin = param1.extra.qls;
         return _loc2_;
      }
      
      public static function createZero() : TopData
      {
         var _loc1_:TopData = new TopData();
         _loc1_.uid = GM.testapi.userId;
         _loc1_.sindex = GM.testapi.dataIndex;
         _loc1_.rank = 0;
         _loc1_.score = GS.a1;
         _loc1_.nickn = GM.testapi.userName;
         var _loc2_:Object = GoodsManger.pkDisplaySave();
         _loc2_.qsl = 0;
         _loc2_.qsb = 0;
         _loc2_.qls = 0;
         _loc1_.extO = _loc2_;
         return _loc1_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.id = this.uid;
         _loc1_.sin = this.sindex;
         _loc1_.rk = this.rank;
         _loc1_.se = this.score;
         _loc1_.newnn = DeepCopyUtil.encode(this.nickn);
         _loc1_.eo = this.extO;
         return _loc1_;
      }
      
      public function addScore(param1:int) : void
      {
         if(param1 > 0)
         {
            this.pwin += GS.a1;
            this.pwinwin += GS.a1;
         }
         else
         {
            this.plost += GS.a1;
            this.pwinwin = 0;
         }
         this.score += param1;
         if(this.score < GS.a1)
         {
            this.score = GS.a1;
         }
         GM.aSaveData.pksd.scoreb = this.score;
      }
      
      public function getFl() : int
      {
         return this.score / GS.a50;
      }
      
      public function getWinRate() : Number
      {
         if(this.pwin + this.plost == 0)
         {
            return 0;
         }
         return Number((this.pwin / (this.pwin + this.plost) * GS.a100).toFixed(2));
      }
      
      public function getTrank() : int
      {
         if(this.rank <= GS.a0 || this.rank > GS.a10000)
         {
            return GS.a10000 + GS.a1;
         }
         return this.rank;
      }
      
      public function getMpSpeed() : int
      {
         var _loc1_:int = this.getTrank();
         if(_loc1_ <= GS.a500)
         {
            return GS.a110 + GS.a101 * Math.random();
         }
         if(_loc1_ <= GS.a1000 * GS.a2)
         {
            return GS.a100 + GS.a21 * Math.random();
         }
         if(_loc1_ <= GS.a1000 * GS.a5)
         {
            return GS.a80 + GS.a21 * Math.random();
         }
         return GS.a60 + GS.a21 * Math.random();
      }
      
      public function get uid() : int
      {
         return this._uid.getValue();
      }
      
      public function set uid(param1:int) : void
      {
         this._uid.setValue(param1);
      }
      
      public function get sindex() : int
      {
         return this._sindex.getValue();
      }
      
      public function set sindex(param1:int) : void
      {
         this._sindex.setValue(param1);
      }
      
      public function get rank() : int
      {
         return this._rank.getValue();
      }
      
      public function set rank(param1:int) : void
      {
         this._rank.setValue(param1);
      }
      
      public function get score() : int
      {
         return this._score.getValue();
      }
      
      public function set score(param1:int) : void
      {
         this._score.setValue(param1);
      }
      
      public function get nickn() : String
      {
         return this._nickn;
      }
      
      public function set nickn(param1:String) : void
      {
         this._nickn = param1;
      }
      
      public function get extO() : Object
      {
         return this._extO;
      }
      
      public function set extO(param1:Object) : void
      {
         this._extO = param1;
      }
      
      public function get pwin() : int
      {
         return this._pwin.getValue();
      }
      
      public function set pwin(param1:int) : void
      {
         this._pwin.setValue(param1);
      }
      
      public function get plost() : int
      {
         return this._plost.getValue();
      }
      
      public function set plost(param1:int) : void
      {
         this._plost.setValue(param1);
      }
      
      public function get pwinwin() : int
      {
         return this._pwinwin.getValue();
      }
      
      public function set pwinwin(param1:int) : void
      {
         this._pwinwin.setValue(param1);
      }
   }
}

