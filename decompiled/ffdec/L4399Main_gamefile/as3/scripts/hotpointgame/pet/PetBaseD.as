package hotpointgame.pet
{
   import hotpointgame.common.*;
   import hotpointgame.gMonster.CMJingJie;
   import hotpointgame.gMonster.TraceJuLi;
   
   public class PetBaseD
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _name:String = "";
      
      private var _framnum:VT = VT.createVT(0);
      
      private var _ppotLimit:VT = VT.createVT(0);
      
      private var _pcolor:VT = VT.createVT(0);
      
      private var _ptype:String = "";
      
      private var _pexp:VT = VT.createVT(0);
      
      private var _pele:String = "";
      
      private var _jingJie:CMJingJie;
      
      private var _traceJuLi:TraceJuLi;
      
      private var _gv:VT = VT.createVT(0);
      
      public function PetBaseD()
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
      
      public function get framnum() : int
      {
         return this._framnum.getValue();
      }
      
      public function set framnum(param1:int) : void
      {
         this._framnum.setValue(param1);
      }
      
      public function get pcolor() : int
      {
         return this._pcolor.getValue();
      }
      
      public function set pcolor(param1:int) : void
      {
         this._pcolor.setValue(param1);
      }
      
      public function get ptype() : String
      {
         return this._ptype;
      }
      
      public function set ptype(param1:String) : void
      {
         this._ptype = param1;
      }
      
      public function get pexp() : int
      {
         return this._pexp.getValue();
      }
      
      public function set pexp(param1:int) : void
      {
         this._pexp.setValue(param1);
      }
      
      public function get ppotLimit() : int
      {
         return this._ppotLimit.getValue();
      }
      
      public function set ppotLimit(param1:int) : void
      {
         this._ppotLimit.setValue(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get pele() : String
      {
         return this._pele;
      }
      
      public function set pele(param1:String) : void
      {
         this._pele = param1;
      }
      
      public function get jingJie() : CMJingJie
      {
         return this._jingJie;
      }
      
      public function set jingJie(param1:CMJingJie) : void
      {
         this._jingJie = param1;
      }
      
      public function get traceJuLi() : TraceJuLi
      {
         return this._traceJuLi;
      }
      
      public function set traceJuLi(param1:TraceJuLi) : void
      {
         this._traceJuLi = param1;
      }
      
      public function get gv() : Number
      {
         return this._gv.getValue();
      }
      
      public function set gv(param1:Number) : void
      {
         this._gv.setValue(param1);
      }
   }
}

