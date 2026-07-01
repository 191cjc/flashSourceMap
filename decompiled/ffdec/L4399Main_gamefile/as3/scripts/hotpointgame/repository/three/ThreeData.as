package hotpointgame.repository.three
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ThreeData
   {
      
      private var _id:VT;
      
      private var _goodsId:Array = [];
      
      private var _goodsNum:Array = [];
      
      private var _jlId1:Array = [];
      
      private var _jlNum1:Array = [];
      
      private var _jlId2:Array = [];
      
      private var _jlNum2:Array = [];
      
      public function ThreeData()
      {
         super();
      }
      
      public static function createThreeData(param1:Number, param2:String, param3:String, param4:String, param5:String, param6:String) : ThreeData
      {
         var _loc7_:ThreeData = new ThreeData();
         _loc7_._id = VT.createVT(param1);
         _loc7_._goodsId = strToArr(param2);
         _loc7_._goodsNum = strToArr(param3);
         _loc7_._jlId1 = strToArr(param4);
         _loc7_._jlNum1 = strToArr(param5);
         _loc7_._jlId2 = strToArr(param6);
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
      
      public function getGoodsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._goodsId.length)
         {
            _loc1_[_loc2_] = this._goodsId[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGoodsNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._goodsId.length)
         {
            _loc1_[_loc2_] = this._goodsNum[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getJlId() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         if(FlowInterface.getJobByRole() == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < this._jlId1.length)
            {
               _loc1_[_loc2_] = this._jlId1[_loc2_].getValue();
               _loc2_++;
            }
         }
         else if(FlowInterface.getJobByRole() == 2)
         {
            _loc2_ = 0;
            while(_loc2_ < this._jlId2.length)
            {
               _loc1_[_loc2_] = this._jlId2[_loc2_].getValue();
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function getJlNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._jlNum1.length)
         {
            _loc1_[_loc2_] = this._jlNum1[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

