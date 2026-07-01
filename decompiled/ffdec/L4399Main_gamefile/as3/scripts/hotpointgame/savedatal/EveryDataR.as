package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class EveryDataR
   {
      
      private var _kpmonth:VT = VT.createVT(0);
      
      private var _kpdata:VT = VT.createVT(0);
      
      public function EveryDataR()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : EveryDataR
      {
         var _loc2_:EveryDataR = new EveryDataR();
         if(param1 != null)
         {
            _loc2_.kpmonth = param1.km;
            _loc2_.kpdata = param1.kd;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.km = this.kpmonth;
         _loc1_.kd = this.kpdata;
         return _loc1_;
      }
      
      public function isNewDay() : Boolean
      {
         if(GM.serverDateC != null)
         {
            if(GM.serverDateC.timeIsCorr())
            {
               if(this.kpmonth == GM.serverDateC.sMonth && this.kpdata == GM.serverDateC.sDate)
               {
                  return false;
               }
               return true;
            }
            GM.findCheatMax(GS.a53);
         }
         else
         {
            GM.findCheatMax(GS.a53);
         }
         return false;
      }
      
      public function updateNewDay() : void
      {
         if(GM.serverDateC != null)
         {
            if(GM.serverDateC.timeIsCorr())
            {
               if(!(this.kpmonth == GM.serverDateC.sMonth && this.kpdata == GM.serverDateC.sDate))
               {
                  this.kpmonth = GM.serverDateC.sMonth;
                  this.kpdata = GM.serverDateC.sDate;
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
   }
}

