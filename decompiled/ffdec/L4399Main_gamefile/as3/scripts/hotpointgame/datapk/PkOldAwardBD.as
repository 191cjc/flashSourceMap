package hotpointgame.datapk
{
   import hotpointgame.common.*;
   
   public class PkOldAwardBD
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _lmin:VT = VT.createVT(0);
      
      private var _lmax:VT = VT.createVT(0);
      
      private var _awAman:VT = VT.createVT(0);
      
      private var _awAmans:String = "";
      
      private var _awBman:VT = VT.createVT(0);
      
      private var _awBmanLv:VT = VT.createVT(0);
      
      private var _awBmans:String = "";
      
      private var _awCman:VT = VT.createVT(0);
      
      private var _awCmans:String = "";
      
      private var _awDman:VT = VT.createVT(0);
      
      private var _awDmans:String = "";
      
      private var _awEman:VT = VT.createVT(0);
      
      private var _awEmans:String = "";
      
      private var _awAwom:VT = VT.createVT(0);
      
      private var _awAwoms:String = "";
      
      private var _awBwom:VT = VT.createVT(0);
      
      private var _awBwomLv:VT = VT.createVT(0);
      
      private var _awBwoms:String = "";
      
      private var _awCwom:VT = VT.createVT(0);
      
      private var _awCwoms:String = "";
      
      private var _awDwom:VT = VT.createVT(0);
      
      private var _awDwoms:String = "";
      
      private var _awEwom:VT = VT.createVT(0);
      
      private var _awEwoms:String = "";
      
      public function PkOldAwardBD()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get lmin() : int
      {
         return this._lmin.getValue();
      }
      
      public function set lmin(param1:int) : void
      {
         this._lmin.setValue(param1);
      }
      
      public function get lmax() : int
      {
         return this._lmax.getValue();
      }
      
      public function set lmax(param1:int) : void
      {
         this._lmax.setValue(param1);
      }
      
      public function get awAman() : int
      {
         return this._awAman.getValue();
      }
      
      public function set awAman(param1:int) : void
      {
         this._awAman.setValue(param1);
      }
      
      public function get awAmans() : String
      {
         return this._awAmans;
      }
      
      public function set awAmans(param1:String) : void
      {
         this._awAmans = param1;
      }
      
      public function get awBman() : int
      {
         return this._awBman.getValue();
      }
      
      public function set awBman(param1:int) : void
      {
         this._awBman.setValue(param1);
      }
      
      public function get awBmanLv() : int
      {
         return this._awBmanLv.getValue();
      }
      
      public function set awBmanLv(param1:int) : void
      {
         this._awBmanLv.setValue(param1);
      }
      
      public function get awBmans() : String
      {
         return this._awBmans;
      }
      
      public function set awBmans(param1:String) : void
      {
         this._awBmans = param1;
      }
      
      public function get awCman() : int
      {
         return this._awCman.getValue();
      }
      
      public function set awCman(param1:int) : void
      {
         this._awCman.setValue(param1);
      }
      
      public function get awCmans() : String
      {
         return this._awCmans;
      }
      
      public function set awCmans(param1:String) : void
      {
         this._awCmans = param1;
      }
      
      public function get awDman() : int
      {
         return this._awDman.getValue();
      }
      
      public function set awDman(param1:int) : void
      {
         this._awDman.setValue(param1);
      }
      
      public function get awDmans() : String
      {
         return this._awDmans;
      }
      
      public function set awDmans(param1:String) : void
      {
         this._awDmans = param1;
      }
      
      public function get awEman() : int
      {
         return this._awEman.getValue();
      }
      
      public function set awEman(param1:int) : void
      {
         this._awEman.setValue(param1);
      }
      
      public function get awEmans() : String
      {
         return this._awEmans;
      }
      
      public function set awEmans(param1:String) : void
      {
         this._awEmans = param1;
      }
      
      public function get awAwom() : int
      {
         return this._awAwom.getValue();
      }
      
      public function set awAwom(param1:int) : void
      {
         this._awAwom.setValue(param1);
      }
      
      public function get awAwoms() : String
      {
         return this._awAwoms;
      }
      
      public function set awAwoms(param1:String) : void
      {
         this._awAwoms = param1;
      }
      
      public function get awBwom() : int
      {
         return this._awBwom.getValue();
      }
      
      public function set awBwom(param1:int) : void
      {
         this._awBwom.setValue(param1);
      }
      
      public function get awBwomLv() : int
      {
         return this._awBwomLv.getValue();
      }
      
      public function set awBwomLv(param1:int) : void
      {
         this._awBwomLv.setValue(param1);
      }
      
      public function get awBwoms() : String
      {
         return this._awBwoms;
      }
      
      public function set awBwoms(param1:String) : void
      {
         this._awBwoms = param1;
      }
      
      public function get awCwom() : int
      {
         return this._awCwom.getValue();
      }
      
      public function set awCwom(param1:int) : void
      {
         this._awCwom.setValue(param1);
      }
      
      public function get awCwoms() : String
      {
         return this._awCwoms;
      }
      
      public function set awCwoms(param1:String) : void
      {
         this._awCwoms = param1;
      }
      
      public function get awDwom() : int
      {
         return this._awDwom.getValue();
      }
      
      public function set awDwom(param1:int) : void
      {
         this._awDwom.setValue(param1);
      }
      
      public function get awDwoms() : String
      {
         return this._awDwoms;
      }
      
      public function set awDwoms(param1:String) : void
      {
         this._awDwoms = param1;
      }
      
      public function get awEwom() : int
      {
         return this._awEwom.getValue();
      }
      
      public function set awEwom(param1:int) : void
      {
         this._awEwom.setValue(param1);
      }
      
      public function get awEwoms() : String
      {
         return this._awEwoms;
      }
      
      public function set awEwoms(param1:String) : void
      {
         this._awEwoms = param1;
      }
   }
}

