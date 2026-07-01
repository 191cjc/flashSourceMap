package hotpointgame.repository.jjia
{
   import hotpointgame.common.*;
   
   public class JjiaJhBasicData
   {
      
      private var _id:VT;
      
      private var _lv:VT;
      
      private var _exp:VT;
      
      public function JjiaJhBasicData()
      {
         super();
      }
      
      public static function createJjiaJhBasicData(param1:Number, param2:Number, param3:Number) : JjiaJhBasicData
      {
         var _loc4_:JjiaJhBasicData = new JjiaJhBasicData();
         _loc4_._id = VT.createVT(param1);
         _loc4_._lv = VT.createVT(param2);
         _loc4_._exp = VT.createVT(param3);
         return _loc4_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getLv() : Number
      {
         return this._lv.getValue();
      }
      
      public function getExp() : Number
      {
         return this._exp.getValue();
      }
   }
}

