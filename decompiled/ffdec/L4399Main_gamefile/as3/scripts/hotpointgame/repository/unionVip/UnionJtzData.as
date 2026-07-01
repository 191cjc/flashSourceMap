package hotpointgame.repository.unionVip
{
   import hotpointgame.common.*;
   
   public class UnionJtzData
   {
      
      private var _id:VT;
      
      private var _gsArr:Array = [];
      
      private var _gsNum:Array = [];
      
      public function UnionJtzData()
      {
         super();
      }
      
      public static function createJtzData(param1:Number, param2:String, param3:String) : UnionJtzData
      {
         var _loc4_:UnionJtzData = new UnionJtzData();
         _loc4_._id = VT.createVT(param1);
         _loc4_._gsArr = strToArr(param2);
         _loc4_._gsNum = strToArr(param3);
         return _loc4_;
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
         while(_loc2_ < this._gsArr.length)
         {
            _loc1_[_loc2_] = this._gsArr[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGoodsNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._gsArr.length)
         {
            _loc1_[_loc2_] = this._gsNum[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

