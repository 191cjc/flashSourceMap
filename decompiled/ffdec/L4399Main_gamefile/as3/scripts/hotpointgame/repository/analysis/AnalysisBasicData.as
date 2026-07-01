package hotpointgame.repository.analysis
{
   import hotpointgame.common.*;
   
   public class AnalysisBasicData
   {
      
      private var _id:VT;
      
      private var _level:VT;
      
      private var _color:VT;
      
      private var _idArr:Array;
      
      private var _glArr:Array;
      
      private var _numArr:Array;
      
      public function AnalysisBasicData()
      {
         super();
      }
      
      public static function createAnalysisBasicData(param1:Number, param2:Number, param3:Number, param4:String, param5:String, param6:String) : AnalysisBasicData
      {
         var _loc7_:AnalysisBasicData = new AnalysisBasicData();
         _loc7_._id = VT.createVT(param1);
         _loc7_._level = VT.createVT(param2);
         _loc7_._color = VT.createVT(param3);
         _loc7_._idArr = strToArr(param4);
         _loc7_._glArr = strToArr(param5);
         _loc7_._numArr = strToArr(param6);
         return _loc7_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Number(_loc2_[_loc4_]))
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
      
      public function getLevel() : Number
      {
         return this._level.getValue();
      }
      
      public function getColor() : Number
      {
         return this._color.getValue();
      }
      
      public function getIdArr() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._idArr.length)
         {
            _loc1_.push(this._idArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGlArr() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._glArr.length)
         {
            _loc1_.push(this._glArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._numArr.length)
         {
            _loc1_.push(this._numArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

