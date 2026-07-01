package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class JieShaSdata
   {
      
      private var _kpnum:VT = VT.createVT(0);
      
      private var _kpnumb:VT = VT.createVT(0);
      
      private var _kpgodn:VT = VT.createVT(0);
      
      private var _kpgodnb:VT = VT.createVT(0);
      
      private var _kgodnum:VT = VT.createVT(0);
      
      private var _kgodnumb:VT = VT.createVT(0);
      
      public function JieShaSdata()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : JieShaSdata
      {
         var _loc2_:JieShaSdata = new JieShaSdata();
         if(param1 != null)
         {
            _loc2_.kpnum = param1.pn;
            _loc2_.kpnumb = param1.pnb;
            _loc2_.kpgodn = param1.pgd;
            _loc2_.kpgodnb = param1.pgdb;
            _loc2_.kgodnum = param1.pg;
            _loc2_.kgodnumb = param1.pgb;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.pn = this.kpnum;
         _loc1_.pnb = this.kpnumb;
         _loc1_.pgd = this.kpgodn;
         _loc1_.pgdb = this.kpgodnb;
         _loc1_.pg = this.kgodnum;
         _loc1_.pgb = this.kgodnumb;
         return _loc1_;
      }
      
      public function dataUpdate() : void
      {
         this.kpnum = 0;
         this.kpnumb = 0;
         this.kpgodn = 0;
         this.kpgodnb = 0;
         this.kgodnum = 0;
         this.kgodnumb = 0;
      }
      
      public function actOneIsOk() : Boolean
      {
         var _loc1_:Date = new Date(FlowInterface.getCurrTimer() + GS.a48 * GS.a10 * GS.a60 * GS.a1000);
         var _loc2_:Number = _loc1_.hoursUTC;
         if(_loc2_ >= GS.a12 && _loc2_ < GS.a14)
         {
            if(this.kpnum == 0)
            {
               return true;
            }
            if(this.kpnum > 0 && this.kpgodn == 0 && this.kgodnum == GS.a1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function actTwoIsOk() : Boolean
      {
         var _loc1_:Date = new Date(FlowInterface.getCurrTimer() + GS.a48 * GS.a10 * GS.a60 * GS.a1000);
         var _loc2_:Number = _loc1_.hoursUTC;
         if(_loc2_ >= GS.a18 && _loc2_ < GS.a20)
         {
            if(this.kpnumb == 0)
            {
               return true;
            }
            if(this.kpnumb > 0 && this.kpgodnb == 0 && this.kgodnumb == GS.a1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function killmOneok(param1:int) : Boolean
      {
         if(this.kpnum == param1 || this.kpgodn == param1)
         {
            return true;
         }
         return false;
      }
      
      public function killmTwook(param1:int) : Boolean
      {
         if(this.kpnumb == param1 || this.kpgodnb == param1)
         {
            return true;
         }
         return false;
      }
      
      public function killOverNum(param1:int) : void
      {
         if(param1 >= GS.a1 && param1 <= GS.a10)
         {
            if(param1 % GS.a2 == 0)
            {
               if(this.kpnumb == 0)
               {
                  this.kpnumb = param1;
                  return;
               }
               if(this.kpgodnb == 0)
               {
                  this.kpgodnb = param1;
                  return;
               }
            }
            else
            {
               if(this.kpnum == 0)
               {
                  this.kpnum = param1;
                  return;
               }
               if(this.kpgodn == 0)
               {
                  this.kpgodn = param1;
                  return;
               }
            }
         }
         GM.findCheatMax(GS.a73);
      }
      
      public function actGodIsOk() : Boolean
      {
         var _loc1_:Date = new Date(FlowInterface.getCurrTimer() + GS.a48 * GS.a10 * GS.a60 * GS.a1000);
         var _loc2_:Number = _loc1_.hoursUTC;
         if(_loc2_ >= GS.a12 && _loc2_ < GS.a14)
         {
            if(this.kpnum > 0 && this.kgodnum == GS.a0)
            {
               return true;
            }
         }
         if(_loc2_ >= GS.a18 && _loc2_ < GS.a20)
         {
            if(this.kpnumb > 0 && this.kgodnumb == GS.a0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addGodUseNum() : void
      {
         var _loc1_:Date = new Date(FlowInterface.getCurrTimer() + GS.a48 * GS.a10 * GS.a60 * GS.a1000);
         var _loc2_:Number = _loc1_.hoursUTC;
         if(_loc2_ >= GS.a12 && _loc2_ < GS.a14)
         {
            if(this.kgodnum == GS.a0)
            {
               this.kgodnum = GS.a1;
            }
         }
         if(_loc2_ >= GS.a18 && _loc2_ < GS.a20)
         {
            if(this.kgodnumb == GS.a0)
            {
               this.kgodnumb = GS.a1;
            }
         }
      }
      
      public function get kpnum() : int
      {
         return this._kpnum.getValue();
      }
      
      public function set kpnum(param1:int) : void
      {
         this._kpnum.setValue(param1);
      }
      
      public function get kpnumb() : int
      {
         return this._kpnumb.getValue();
      }
      
      public function set kpnumb(param1:int) : void
      {
         this._kpnumb.setValue(param1);
      }
      
      public function get kgodnum() : int
      {
         return this._kgodnum.getValue();
      }
      
      public function set kgodnum(param1:int) : void
      {
         this._kgodnum.setValue(param1);
      }
      
      public function get kgodnumb() : int
      {
         return this._kgodnumb.getValue();
      }
      
      public function set kgodnumb(param1:int) : void
      {
         this._kgodnumb.setValue(param1);
      }
      
      public function get kpgodn() : int
      {
         return this._kpgodn.getValue();
      }
      
      public function set kpgodn(param1:int) : void
      {
         this._kpgodn.setValue(param1);
      }
      
      public function get kpgodnb() : int
      {
         return this._kpgodnb.getValue();
      }
      
      public function set kpgodnb(param1:int) : void
      {
         this._kpgodnb.setValue(param1);
      }
   }
}

