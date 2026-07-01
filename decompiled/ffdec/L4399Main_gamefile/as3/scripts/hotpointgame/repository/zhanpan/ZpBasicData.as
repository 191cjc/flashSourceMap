package hotpointgame.repository.zhanpan
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ZpBasicData
   {
      
      private var _id:VT;
      
      private var _goodsId:Array;
      
      private var _goodsNum:Array;
      
      private var _gl:VT;
      
      private var _jd:VT;
      
      private var _wz:VT;
      
      public function ZpBasicData()
      {
         super();
      }
      
      public static function createZp(param1:Number, param2:String, param3:String, param4:Number, param5:Number, param6:Number) : ZpBasicData
      {
         var _loc7_:ZpBasicData = new ZpBasicData();
         _loc7_._id = VT.createVT(param1);
         _loc7_._goodsId = strToArr(param2);
         _loc7_._goodsNum = strToArr(param3);
         _loc7_._gl = VT.createVT(param4);
         _loc7_._jd = VT.createVT(param5);
         _loc7_._wz = VT.createVT(param6);
         return _loc7_;
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
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getGoodsId() : Number
      {
         return this._goodsId[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getGoodsNum() : Number
      {
         return this._goodsNum[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getGl() : Number
      {
         return this._gl.getValue();
      }
      
      public function getJd() : Number
      {
         return this._jd.getValue();
      }
      
      public function getWz() : Number
      {
         return this._wz.getValue();
      }
   }
}

