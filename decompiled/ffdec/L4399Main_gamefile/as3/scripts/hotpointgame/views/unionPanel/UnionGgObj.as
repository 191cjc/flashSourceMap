package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   
   public class UnionGgObj
   {
      
      private var _id:VT;
      
      private var _value:VT;
      
      public function UnionGgObj()
      {
         super();
      }
      
      public static function createGgObj(param1:Object) : UnionGgObj
      {
         var _loc2_:UnionGgObj = new UnionGgObj();
         _loc2_._id = VT.createVT(Number(param1.id));
         _loc2_._value = VT.createVT(Number(param1.value));
         return _loc2_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getValue() : Number
      {
         return this._value.getValue();
      }
   }
}

