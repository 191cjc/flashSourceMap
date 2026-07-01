package hotpointgame.models.goods
{
   import hotpointgame.common.*;
   
   public class BasicSx
   {
      
      private var _sxType:VT;
      
      private var _value:VT;
      
      public function BasicSx()
      {
         super();
      }
      
      public static function creatBasicSx(param1:Number, param2:Number) : BasicSx
      {
         var _loc3_:BasicSx = new BasicSx();
         _loc3_._sxType = VT.createVT(param1);
         _loc3_._value = VT.createVT(param2);
         return _loc3_;
      }
      
      public function getSxType() : Number
      {
         return this._sxType.getValue();
      }
      
      public function setSxType(param1:Number) : void
      {
         this._sxType.setValue(param1);
      }
      
      public function getValue() : Number
      {
         return this._value.getValue();
      }
      
      public function setValue(param1:Number) : void
      {
         this._value.setValue(param1);
      }
      
      public function getClone() : BasicSx
      {
         return BasicSx.creatBasicSx(this._sxType.getValue(),this._value.getValue());
      }
      
      public function get sxType() : VT
      {
         return this._sxType;
      }
      
      public function set sxType(param1:VT) : void
      {
         this._sxType = param1;
      }
      
      public function get value() : VT
      {
         return this._value;
      }
      
      public function set value(param1:VT) : void
      {
         this._value = param1;
      }
   }
}

