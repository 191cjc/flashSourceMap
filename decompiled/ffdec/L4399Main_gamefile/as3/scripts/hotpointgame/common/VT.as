package hotpointgame.common
{
   public class VT
   {
      
      private var _value:Object = new Object();
      
      public function VT()
      {
         super();
      }
      
      public static function createVT(param1:Number = 0) : VT
      {
         var _loc2_:VT = new VT();
         _loc2_.setValue(param1);
         return _loc2_;
      }
      
      public function getValue() : Number
      {
         return this._value.num - this._value.random;
      }
      
      public function setValue(param1:Number) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.random = Math.round(Math.random() * GSSVT.SVTRandomvt + GSSVT.SVTravt) * (Math.round(Math.random()) * GSSVT.SVTrbvt - GSSVT.SVTrcvt);
         _loc2_.num = param1 + _loc2_.random;
         this._value = _loc2_;
      }
      
      public function get value() : Object
      {
         return this._value;
      }
      
      public function set value(param1:Object) : void
      {
         this._value = param1;
      }
   }
}

