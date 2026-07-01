package hotpointgame.pet
{
   import hotpointgame.common.*;
   
   public class PetSkillShowBD
   {
      
      private var _sid:VT = VT.createVT(0);
      
      private var _sname:String = "";
      
      private var _sshuomi:Array;
      
      private var _scolor:VT = VT.createVT(0);
      
      private var _sfid:String = "";
      
      private var _initexp:VT = VT.createVT(0);
      
      private var _frameNum:VT = VT.createVT(0);
      
      private var _hurtIshu:VT = VT.createVT(0);
      
      private var _hurtIxishu:VT = VT.createVT(0);
      
      private var _potlimitv:VT = VT.createVT(0);
      
      public function PetSkillShowBD()
      {
         super();
      }
      
      public function get sid() : int
      {
         return this._sid.getValue();
      }
      
      public function set sid(param1:int) : void
      {
         this._sid.setValue(param1);
      }
      
      public function get sname() : String
      {
         return this._sname;
      }
      
      public function set sname(param1:String) : void
      {
         this._sname = param1;
      }
      
      public function get sshuomi() : Array
      {
         return this._sshuomi;
      }
      
      public function set sshuomi(param1:Array) : void
      {
         this._sshuomi = param1;
      }
      
      public function get scolor() : int
      {
         return this._scolor.getValue();
      }
      
      public function set scolor(param1:int) : void
      {
         this._scolor.setValue(param1);
      }
      
      public function get sfid() : String
      {
         return this._sfid;
      }
      
      public function set sfid(param1:String) : void
      {
         this._sfid = param1;
      }
      
      public function get initexp() : int
      {
         return this._initexp.getValue();
      }
      
      public function set initexp(param1:int) : void
      {
         this._initexp.setValue(param1);
      }
      
      public function get frameNum() : int
      {
         return this._frameNum.getValue();
      }
      
      public function set frameNum(param1:int) : void
      {
         this._frameNum.setValue(param1);
      }
      
      public function get hurtIshu() : Number
      {
         return this._hurtIshu.getValue();
      }
      
      public function set hurtIshu(param1:Number) : void
      {
         this._hurtIshu.setValue(param1);
      }
      
      public function get hurtIxishu() : Number
      {
         return this._hurtIxishu.getValue();
      }
      
      public function set hurtIxishu(param1:Number) : void
      {
         this._hurtIxishu.setValue(param1);
      }
      
      public function get potlimitv() : int
      {
         return this._potlimitv.getValue();
      }
      
      public function set potlimitv(param1:int) : void
      {
         this._potlimitv.setValue(param1);
      }
   }
}

