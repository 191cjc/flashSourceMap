package hotpointgame.datapk
{
   import hotpointgame.common.*;
   
   public class PkAwardBD
   {
      
      private var _type:VT = VT.createVT(0);
      
      private var _lv:VT = VT.createVT(0);
      
      private var _rankMin:VT = VT.createVT(0);
      
      private var _rankMax:VT = VT.createVT(0);
      
      private var _awardtype:VT = VT.createVT(0);
      
      private var _valuea:VT = VT.createVT(0);
      
      private var _valueb:VT = VT.createVT(0);
      
      private var _framenum:VT = VT.createVT(0);
      
      public function PkAwardBD()
      {
         super();
      }
      
      public function get type() : int
      {
         return this._type.getValue();
      }
      
      public function set type(param1:int) : void
      {
         this._type.setValue(param1);
      }
      
      public function get lv() : int
      {
         return this._lv.getValue();
      }
      
      public function set lv(param1:int) : void
      {
         this._lv.setValue(param1);
      }
      
      public function get rankMin() : int
      {
         return this._rankMin.getValue();
      }
      
      public function set rankMin(param1:int) : void
      {
         this._rankMin.setValue(param1);
      }
      
      public function get rankMax() : int
      {
         return this._rankMax.getValue();
      }
      
      public function set rankMax(param1:int) : void
      {
         this._rankMax.setValue(param1);
      }
      
      public function get awardtype() : int
      {
         return this._awardtype.getValue();
      }
      
      public function set awardtype(param1:int) : void
      {
         this._awardtype.setValue(param1);
      }
      
      public function get valuea() : int
      {
         return this._valuea.getValue();
      }
      
      public function set valuea(param1:int) : void
      {
         this._valuea.setValue(param1);
      }
      
      public function get valueb() : int
      {
         return this._valueb.getValue();
      }
      
      public function set valueb(param1:int) : void
      {
         this._valueb.setValue(param1);
      }
      
      public function get framenum() : int
      {
         return this._framenum.getValue();
      }
      
      public function set framenum(param1:int) : void
      {
         this._framenum.setValue(param1);
      }
   }
}

