package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.gview.*;
   
   public class PkEnemy
   {
      
      private var _kpmonth:VT = VT.createVT(0);
      
      private var _kpdata:VT = VT.createVT(0);
      
      private var _usenum:VT = VT.createVT(0);
      
      private var _fightnum:VT = VT.createVT(0);
      
      private var enemyArr:Array = new Array();
      
      private var iswinArr:Array = new Array();
      
      private var attUpArr:Array = new Array();
      
      private var _gAward:VT = VT.createVT(0);
      
      private var _newpkf:VT = VT.createVT(0);
      
      public function PkEnemy()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : PkEnemy
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc2_:PkEnemy = new PkEnemy();
         if(param1 != null)
         {
            _loc2_.kpmonth = param1.sxm;
            _loc2_.kpdata = param1.sxd;
            _loc2_.usenum = param1.un;
            _loc2_.fightnum = param1.fn;
            _loc3_ = param1.ea;
            for each(_loc4_ in _loc3_)
            {
               _loc2_.enemyArr.push(TopData.readData(_loc4_));
            }
            _loc5_ = param1.wa;
            for each(_loc6_ in _loc5_)
            {
               _loc2_.iswinArr.push(VT.createVT(_loc6_));
            }
            _loc7_ = param1.gup;
            for each(_loc8_ in _loc7_)
            {
               _loc2_.attUpArr.push(VT.createVT(_loc8_));
            }
            _loc2_.gAward = param1.gaw;
            if(param1.pkfb != null)
            {
               _loc2_.newpkf = param1.pkfb;
            }
         }
         _loc2_.dataUpdate();
         _loc2_.newpkClear();
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc3_:TopData = null;
         var _loc4_:Array = null;
         var _loc5_:VT = null;
         var _loc6_:Array = null;
         var _loc7_:VT = null;
         var _loc1_:Object = new Object();
         _loc1_.sxm = this.kpmonth;
         _loc1_.sxd = this.kpdata;
         _loc1_.un = this.usenum;
         _loc1_.fn = this.fightnum;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.enemyArr)
         {
            _loc2_.push(_loc3_.save());
         }
         _loc1_.ea = _loc2_;
         _loc4_ = new Array();
         for each(_loc5_ in this.iswinArr)
         {
            _loc4_.push(_loc5_.getValue());
         }
         _loc1_.wa = _loc4_;
         _loc6_ = new Array();
         for each(_loc7_ in this.attUpArr)
         {
            _loc6_.push(_loc7_.getValue());
         }
         _loc1_.gup = _loc6_;
         _loc1_.gaw = this.gAward;
         _loc1_.pkfb = this.newpkf;
         return _loc1_;
      }
      
      private function newpkClear() : void
      {
         if(this.getEnemyNum() > 0 && this.newpkf == 0)
         {
            this.enemyArr.length = 0;
            this.usenum = 0;
            this.fightnum = 0;
            this.gAward = 0;
         }
         this.newpkf = GS.a1;
      }
      
      private function dataUpdate() : void
      {
         if(GM.serverDateC != null)
         {
            if(GM.serverDateC.timeIsCorr())
            {
               if(!(this.kpmonth == GM.serverDateC.sMonth && this.kpdata == GM.serverDateC.sDate))
               {
                  this.kpmonth = GM.serverDateC.sMonth;
                  this.kpdata = GM.serverDateC.sDate;
                  this.usenum = 0;
                  this.fightnum = 0;
               }
            }
            else
            {
               GM.findCheatMax(GS.a53);
            }
         }
         else
         {
            GM.findCheatMax(GS.a53);
         }
      }
      
      public function getAllEnemy() : Array
      {
         return this.enemyArr;
      }
      
      public function getEnemyNum() : int
      {
         return this.enemyArr.length;
      }
      
      public function getEnemyByid(param1:int) : TopData
      {
         return this.enemyArr[param1 - GS.a1];
      }
      
      public function getisWinArr() : Array
      {
         return this.iswinArr;
      }
      
      public function flushEnemy(param1:Array) : void
      {
         if(this.enemyArr.length != 0)
         {
            GM.findCheatMax(GS.a63);
            return;
         }
         this.enemyArr = param1;
         var _loc2_:int = 0;
         while(_loc2_ < GS.a10)
         {
            this.iswinArr[_loc2_] = VT.createVT(0);
            this.attUpArr[_loc2_] = VT.createVT(int(Math.random() * GS.a20 + GS.a10));
            _loc2_++;
         }
      }
      
      public function flushTenEnemy(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(this.getFlushEnemyn() > 0)
         {
            this.enemyArr = param1;
            _loc2_ = 0;
            while(_loc2_ < GS.a10)
            {
               this.iswinArr[_loc2_] = VT.createVT(0);
               this.attUpArr[_loc2_] = VT.createVT(int(Math.random() * GS.a20 + GS.a10));
               _loc2_++;
            }
            this.gAward = 0;
            this.usenum += GS.a1;
            GdataPK.self.flushTenEnemyListH();
         }
      }
      
      public function getAttUpByid(param1:int) : Number
      {
         return (this.attUpArr[param1 - GS.a1] as VT).getValue();
      }
      
      public function getShengxiaFn() : int
      {
         return GS.a10 - this.fightnum;
      }
      
      public function redShengxiaN() : void
      {
         this.fightnum += GS.a1;
      }
      
      public function addwinother() : void
      {
         this.iswinArr[GdataPK.self.fightId - GS.a1] = VT.createVT(GS.a2);
      }
      
      public function getFlushEnemyn() : int
      {
         var _loc1_:int = 0;
         if(this.isAllWin())
         {
            _loc1_ = GS.a2 - this.usenum;
         }
         else
         {
            _loc1_ = GS.a1 - this.usenum;
         }
         if(_loc1_ > 0)
         {
            return GS.a1;
         }
         return GS.a0;
      }
      
      public function isAllWin() : Boolean
      {
         var _loc1_:VT = null;
         for each(_loc1_ in this.iswinArr)
         {
            if(_loc1_.getValue() != GS.a2)
            {
               return false;
            }
         }
         return true;
      }
      
      public function getWinNum() : int
      {
         var _loc2_:VT = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.iswinArr)
         {
            if(_loc2_.getValue() == GS.a2)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function isWinByid(param1:int) : Boolean
      {
         if((this.iswinArr[param1 - GS.a1] as VT).getValue() == GS.a2)
         {
            return true;
         }
         return false;
      }
      
      public function leadAward(param1:int) : void
      {
         if(param1 == GS.a3)
         {
            this.gAward += GS.a4;
         }
         else
         {
            this.gAward += param1;
         }
      }
      
      public function getStateAward(param1:int) : int
      {
         switch(param1)
         {
            case GS.a1:
               if([GS.a1,GS.a3,GS.a5,GS.a7].indexOf(this.gAward) == -GS.a1)
               {
                  if(this.getWinNum() >= GS.a5)
                  {
                     return 0;
                  }
                  return GS.a1;
               }
               break;
            case GS.a2:
               if([GS.a2,GS.a3,GS.a6,GS.a7].indexOf(this.gAward) == -GS.a1)
               {
                  if(this.getWinNum() >= GS.a8)
                  {
                     return 0;
                  }
                  return GS.a1;
               }
               break;
            case GS.a3:
               if([GS.a4,GS.a5,GS.a6,GS.a7].indexOf(this.gAward) == -GS.a1)
               {
                  if(this.getWinNum() >= GS.a10)
                  {
                     return 0;
                  }
                  return GS.a1;
               }
         }
         return GS.a2;
      }
      
      public function get kpmonth() : int
      {
         return this._kpmonth.getValue();
      }
      
      public function set kpmonth(param1:int) : void
      {
         this._kpmonth.setValue(param1);
      }
      
      public function get kpdata() : int
      {
         return this._kpdata.getValue();
      }
      
      public function set kpdata(param1:int) : void
      {
         this._kpdata.setValue(param1);
      }
      
      public function get usenum() : int
      {
         return this._usenum.getValue();
      }
      
      public function set usenum(param1:int) : void
      {
         this._usenum.setValue(param1);
      }
      
      public function get fightnum() : int
      {
         return this._fightnum.getValue();
      }
      
      public function set fightnum(param1:int) : void
      {
         this._fightnum.setValue(param1);
      }
      
      public function get gAward() : int
      {
         return this._gAward.getValue();
      }
      
      public function set gAward(param1:int) : void
      {
         this._gAward.setValue(param1);
      }
      
      public function get newpkf() : int
      {
         return this._newpkf.getValue();
      }
      
      public function set newpkf(param1:int) : void
      {
         this._newpkf.setValue(param1);
      }
   }
}

