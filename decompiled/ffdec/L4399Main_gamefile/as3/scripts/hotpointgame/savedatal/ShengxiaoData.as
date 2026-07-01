package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ShengxiaoData
   {
      
      private var _kpmonth:VT = VT.createVT(0);
      
      private var _kpdata:VT = VT.createVT(0);
      
      private var _usenum:VT = VT.createVT(0);
      
      private var _dgnum:VT = VT.createVT(0);
      
      private var _sxvalue:VT = VT.createVT(0);
      
      private var tempValue:Array = [GS.a100,GS.a110,GS.a100 + GS.a20,GS.a100 + GS.a50,GS.a200];
      
      public function ShengxiaoData()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : ShengxiaoData
      {
         var _loc2_:ShengxiaoData = new ShengxiaoData();
         if(param1 != null)
         {
            _loc2_.kpmonth = param1.sxm;
            _loc2_.kpdata = param1.sxd;
            _loc2_.usenum = param1.un;
            _loc2_.sxvalue = param1.sxv;
            _loc2_.dgnum = param1.dgn;
         }
         _loc2_.dataUpdate();
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.sxm = this.kpmonth;
         _loc1_.sxd = this.kpdata;
         _loc1_.un = this.usenum;
         _loc1_.sxv = this.sxvalue;
         _loc1_.dgn = this.dgnum;
         return _loc1_;
      }
      
      public function getkeyiusenum() : int
      {
         var _loc1_:int = GS.a8 - this.usenum;
         return _loc1_ > 0 ? _loc1_ : 0;
      }
      
      public function nextShopvalue() : int
      {
         var _loc1_:int = this.dgnum > GS.a4 ? int(GS.a4) : this.dgnum;
         return this.tempValue[_loc1_];
      }
      
      public function nextShopPid() : int
      {
         var _loc1_:int = this.dgnum > GS.a4 ? int(GS.a4) : this.dgnum;
         return GS.a650 + GS.a1 + _loc1_;
      }
      
      public function usedgshop() : void
      {
         this.dgnum += GS.a1;
      }
      
      public function addOne() : void
      {
         this.usenum += GS.a1;
         this.sxvalue += GS.a2;
      }
      
      public function redsxvalue(param1:int) : void
      {
         if(param1 < 0 || this.sxvalue < param1)
         {
            GM.findCheatMax(GS.a57);
         }
         else
         {
            this.sxvalue -= param1;
         }
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
                  this.dgnum = 0;
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
      
      public function get sxvalue() : int
      {
         return this._sxvalue.getValue();
      }
      
      public function set sxvalue(param1:int) : void
      {
         this._sxvalue.setValue(param1);
      }
      
      public function get dgnum() : int
      {
         return this._dgnum.getValue();
      }
      
      public function set dgnum(param1:int) : void
      {
         this._dgnum.setValue(param1);
      }
   }
}

