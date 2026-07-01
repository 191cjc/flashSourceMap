package hotpointgame.repository.chHd
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ChHdData
   {
      
      private var _id:VT;
      
      private var _needNum:VT;
      
      private var _goodsId:Array;
      
      private var _goodsNum:VT;
      
      public function ChHdData()
      {
         super();
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Boolean(Number(_loc2_[_loc4_])) || _loc2_[_loc4_] == 0)
            {
               _loc3_.push(VT.createVT(Number(_loc2_[_loc4_])));
            }
            else
            {
               _loc3_.push(String(_loc2_[_loc4_]));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function createHdData(param1:Number, param2:Number, param3:String, param4:Number) : ChHdData
      {
         var _loc5_:ChHdData = new ChHdData();
         _loc5_._id = VT.createVT(param1);
         _loc5_._needNum = VT.createVT(param2);
         _loc5_._goodsId = strToArr(param3);
         _loc5_._goodsNum = VT.createVT(param4);
         return _loc5_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getNeedNum() : Number
      {
         return this._needNum.getValue();
      }
      
      public function getGoodsId() : Number
      {
         return this._goodsId[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getGoodsNum() : Number
      {
         return this._goodsNum.getValue();
      }
   }
}

