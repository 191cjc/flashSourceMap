package hotpointgame.grole
{
   import hotpointgame.common.*;
   
   public class RoleLevelData
   {
      
      private var _level:VT = VT.createVT(0);
      
      private var _rhp:VT = VT.createVT(0);
      
      private var _rmp:VT = VT.createVT(0);
      
      private var _rat:VT = VT.createVT(0);
      
      private var _rdf:VT = VT.createVT(0);
      
      private var _rspeed:VT = VT.createVT(0);
      
      private var _rbaoji:VT = VT.createVT(0);
      
      private var _nextexp:VT = VT.createVT(0);
      
      private var _maxGod:VT = VT.createVT(0);
      
      private var _toMaxLvExp:VT = VT.createVT(0);
      
      public function RoleLevelData()
      {
         super();
      }
      
      public function get level() : Number
      {
         return this._level.getValue();
      }
      
      public function set level(param1:Number) : void
      {
         this._level.setValue(param1);
      }
      
      public function get rhp() : Number
      {
         return this._rhp.getValue();
      }
      
      public function set rhp(param1:Number) : void
      {
         this._rhp.setValue(param1);
      }
      
      public function get rmp() : Number
      {
         return this._rmp.getValue();
      }
      
      public function set rmp(param1:Number) : void
      {
         this._rmp.setValue(param1);
      }
      
      public function get rat() : Number
      {
         return this._rat.getValue();
      }
      
      public function set rat(param1:Number) : void
      {
         this._rat.setValue(param1);
      }
      
      public function get rdf() : Number
      {
         return this._rdf.getValue();
      }
      
      public function set rdf(param1:Number) : void
      {
         this._rdf.setValue(param1);
      }
      
      public function get rspeed() : Number
      {
         return this._rspeed.getValue();
      }
      
      public function set rspeed(param1:Number) : void
      {
         this._rspeed.setValue(param1);
      }
      
      public function get rbaoji() : Number
      {
         return this._rbaoji.getValue();
      }
      
      public function set rbaoji(param1:Number) : void
      {
         this._rbaoji.setValue(param1);
      }
      
      public function get nextexp() : int
      {
         return this._nextexp.getValue();
      }
      
      public function set nextexp(param1:int) : void
      {
         this._nextexp.setValue(param1);
      }
      
      public function get maxGod() : int
      {
         return this._maxGod.getValue();
      }
      
      public function set maxGod(param1:int) : void
      {
         this._maxGod.setValue(param1);
      }
      
      public function get toMaxLvExp() : uint
      {
         return this._toMaxLvExp.getValue();
      }
      
      public function set toMaxLvExp(param1:uint) : void
      {
         this._toMaxLvExp.setValue(param1);
      }
   }
}

