package hotpointgame.repository.openBox
{
   import hotpointgame.common.*;
   
   public class OpenBoxBasicData
   {
      
      private var _id:VT;
      
      private var _gl:VT;
      
      private var _goodsId:VT;
      
      public function OpenBoxBasicData()
      {
         super();
      }
      
      public static function createOpenBoxData(param1:Number, param2:Number, param3:Number) : OpenBoxBasicData
      {
         var _loc4_:OpenBoxBasicData = new OpenBoxBasicData();
         _loc4_._id = VT.createVT(param1);
         _loc4_._gl = VT.createVT(param2);
         _loc4_._goodsId = VT.createVT(param3);
         return _loc4_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getGl() : Number
      {
         return this._gl.getValue();
      }
      
      public function getGoodsId() : Number
      {
         return this._goodsId.getValue();
      }
   }
}

