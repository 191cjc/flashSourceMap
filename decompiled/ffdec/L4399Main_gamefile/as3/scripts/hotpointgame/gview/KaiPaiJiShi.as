package hotpointgame.gview
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class KaiPaiJiShi
   {
      
      private var _kpmonth:VT = VT.createVT(0);
      
      private var _kpdata:VT = VT.createVT(0);
      
      private var _kpnum:VT = VT.createVT(0);
      
      public function KaiPaiJiShi()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : KaiPaiJiShi
      {
         var _loc2_:KaiPaiJiShi = new KaiPaiJiShi();
         if(param1 != null)
         {
            _loc2_.kpmonth = param1.pm;
            _loc2_.kpdata = param1.pd;
            _loc2_.kpnum = param1.pn;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.pm = this.kpmonth;
         _loc1_.pd = this.kpdata;
         _loc1_.pn = this.kpnum;
         return _loc1_;
      }
      
      public function dataUpdate() : void
      {
         if(GM.serverDateC != null)
         {
            if(GM.serverDateC.timeIsCorr())
            {
               if(!(this.kpmonth == GM.serverDateC.sMonth && this.kpdata == GM.serverDateC.sDate))
               {
                  this.kpmonth = GM.serverDateC.sMonth;
                  this.kpdata = GM.serverDateC.sDate;
                  this.kpnum = 0;
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
      
      public function getCurPrice() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = this.kpnum + GS.a1;
         if(_loc2_ > GS.a15)
         {
            _loc2_ = int(GS.a15);
         }
         _loc1_[0] = GS.a100 * GS.a4 + GS.a44 + _loc2_;
         _loc1_[1] = GS.a100 * GS.a2 + GS.a10 - _loc2_ * GS.a10;
         return _loc1_;
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
      
      public function get kpnum() : int
      {
         return this._kpnum.getValue();
      }
      
      public function set kpnum(param1:int) : void
      {
         this._kpnum.setValue(param1);
      }
   }
}

