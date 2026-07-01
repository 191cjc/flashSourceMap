package hotpointgame.repository.chHao
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ChHaoBasicData
   {
      
      private var _id:VT;
      
      private var _fbId:VT;
      
      private var _times:VT;
      
      private var _deGoodsId:Array;
      
      private var _jlGoodsId:Array;
      
      private var _sm:String;
      
      public function ChHaoBasicData()
      {
         super();
      }
      
      public static function createChHaoBasicData(param1:Number, param2:Number, param3:Number, param4:String, param5:String, param6:String) : ChHaoBasicData
      {
         var _loc7_:ChHaoBasicData = new ChHaoBasicData();
         _loc7_._id = VT.createVT(param1);
         _loc7_._fbId = VT.createVT(param2);
         _loc7_._times = VT.createVT(param3);
         _loc7_._deGoodsId = strToArr(param4);
         _loc7_._jlGoodsId = strToArr(param5);
         _loc7_._sm = param6;
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
      
      public function getFbId() : Number
      {
         return this._fbId.getValue();
      }
      
      public function getTimes() : Number
      {
         return this._times.getValue();
      }
      
      public function getDeGoodsId() : Number
      {
         if(this._deGoodsId[0].getValue() != -1)
         {
            return this._deGoodsId[FlowInterface.getJobByRole() - 1].getValue();
         }
         return -1;
      }
      
      public function getJlGoodsId() : Number
      {
         return this._jlGoodsId[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getSm() : String
      {
         return this._sm;
      }
   }
}

