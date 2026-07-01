package hotpointgame.repository.goods
{
   import hotpointgame.common.*;
   
   public class GoodsNumBasicData
   {
      
      private var _id:VT;
      
      private var _gid:VT;
      
      private var _num:VT;
      
      public function GoodsNumBasicData()
      {
         super();
      }
      
      public static function createGsnData(param1:Number, param2:Number, param3:Number) : GoodsNumBasicData
      {
         var _loc4_:GoodsNumBasicData = new GoodsNumBasicData();
         _loc4_._id = VT.createVT(param1);
         _loc4_._gid = VT.createVT(param2);
         _loc4_._num = VT.createVT(param3);
         return _loc4_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getGid() : Number
      {
         return this._gid.getValue();
      }
      
      public function getNum() : Number
      {
         return this._num.getValue();
      }
   }
}

