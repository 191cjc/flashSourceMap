package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class DataPk
   {
      
      private var _gongScore:VT = VT.createVT(0);
      
      private var awardRarr:Vector.<VT> = new Vector.<VT>();
      
      private var _haoId:VT = VT.createVT(0);
      
      private var _kpmonth:VT = VT.createVT(0);
      
      private var _kpdata:VT = VT.createVT(0);
      
      private var _scoreb:VT = VT.createVT(0);
      
      private var _oldpkrb:VT = VT.createVT(0);
      
      private var _oldawardfb:VT = VT.createVT(0);
      
      private var _oldawTitleb:VT = VT.createVT(0);
      
      public function DataPk()
      {
         super();
         var _loc1_:int = 0;
         while(_loc1_ <= GS.a10)
         {
            this.awardRarr.push(VT.createVT(0));
            _loc1_++;
         }
      }
      
      public static function readData(param1:Object = null) : DataPk
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:DataPk = new DataPk();
         if(param1 != null)
         {
            _loc2_.oldpkrb = -GS.a1;
            _loc2_.gongScore = param1.gs;
            _loc2_.haoId = param1.hid;
            _loc3_ = param1.awr;
            _loc4_ = 0;
            while(_loc4_ <= GS.a10)
            {
               _loc2_.awardRarr[_loc4_].setValue(_loc3_[_loc4_]);
               _loc4_++;
            }
            _loc2_.kpmonth = param1.km;
            _loc2_.kpdata = param1.kd;
            if(param1.sxb != null)
            {
               _loc2_.scoreb = param1.sxb;
            }
            if(param1.oldpkb != null)
            {
               _loc2_.oldpkrb = param1.oldpkb;
            }
            if(param1.oldawb != null)
            {
               _loc2_.oldawardfb = param1.oldawb;
            }
            if(param1.oldatb != null)
            {
               _loc2_.oldawTitleb = param1.oldatb;
            }
         }
         _loc2_.dataUpdate();
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.gs = this.gongScore;
         _loc1_.sxb = this.scoreb;
         _loc1_.hid = this.haoId;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ <= GS.a10)
         {
            _loc2_[_loc3_] = this.awardRarr[_loc3_].getValue();
            _loc3_++;
         }
         _loc1_.awr = _loc2_;
         _loc1_.km = this.kpmonth;
         _loc1_.kd = this.kpdata;
         _loc1_.oldpkb = this.oldpkrb;
         _loc1_.oldawb = this.oldawardfb;
         _loc1_.oldatb = this.oldawTitleb;
         return _loc1_;
      }
      
      private function dataUpdate() : void
      {
         var _loc1_:int = 0;
         if(GM.serverDateC != null)
         {
            if(GM.serverDateC.timeIsCorr())
            {
               if(!(this.kpmonth == GM.serverDateC.sMonth && this.kpdata == GM.serverDateC.sDate))
               {
                  this.kpmonth = GM.serverDateC.sMonth;
                  this.kpdata = GM.serverDateC.sDate;
                  _loc1_ = 0;
                  while(_loc1_ <= GS.a10)
                  {
                     this.awardRarr[_loc1_].setValue(0);
                     _loc1_++;
                  }
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
      
      public function addGong(param1:int) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         this.gongScore += param1;
      }
      
      public function redGong(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         this.gongScore -= param1;
         if(this.gongScore < 0)
         {
            this.gongScore = 0;
         }
      }
      
      public function isGetAward(param1:int) : Boolean
      {
         if(this.awardRarr[param1].getValue() == GS.a1)
         {
            return true;
         }
         return false;
      }
      
      public function recordGetAward(param1:int) : void
      {
         this.awardRarr[param1].setValue(GS.a1);
      }
      
      public function get gongScore() : int
      {
         return this._gongScore.getValue();
      }
      
      public function set gongScore(param1:int) : void
      {
         this._gongScore.setValue(param1);
      }
      
      public function get haoId() : int
      {
         return this._haoId.getValue();
      }
      
      public function set haoId(param1:int) : void
      {
         this._haoId.setValue(param1);
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
      
      public function get scoreb() : int
      {
         return this._scoreb.getValue();
      }
      
      public function set scoreb(param1:int) : void
      {
         this._scoreb.setValue(param1);
      }
      
      public function get oldpkrb() : int
      {
         return this._oldpkrb.getValue();
      }
      
      public function set oldpkrb(param1:int) : void
      {
         this._oldpkrb.setValue(param1);
      }
      
      public function get oldawardfb() : int
      {
         return this._oldawardfb.getValue();
      }
      
      public function set oldawardfb(param1:int) : void
      {
         this._oldawardfb.setValue(param1);
      }
      
      public function get oldawTitleb() : int
      {
         return this._oldawTitleb.getValue();
      }
      
      public function set oldawTitleb(param1:int) : void
      {
         this._oldawTitleb.setValue(param1);
      }
   }
}

