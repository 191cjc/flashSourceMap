package hotpointgame.repository.everyDay
{
   import hotpointgame.common.*;
   
   public class EveryDayJl
   {
      
      private var _id:VT;
      
      private var _jd:VT;
      
      private var _fs:VT;
      
      private var goodsId:Array = [];
      
      private var goodsNum:Array = [];
      
      private var _jlName:String;
      
      public function EveryDayJl()
      {
         super();
      }
      
      public static function createEvJl(param1:Number, param2:Number, param3:Number, param4:String, param5:String, param6:String) : EveryDayJl
      {
         var _loc7_:EveryDayJl = new EveryDayJl();
         _loc7_._id = VT.createVT(param1);
         _loc7_._jd = VT.createVT(param2);
         _loc7_._fs = VT.createVT(param3);
         _loc7_.goodsId = strToArr(param4);
         _loc7_.goodsNum = strToArr(param5);
         _loc7_._jlName = param6;
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
      
      public function getJd() : Number
      {
         return this._jd.getValue();
      }
      
      public function getFs() : Number
      {
         return this._fs.getValue();
      }
      
      public function getGoodsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.goodsId.length)
         {
            _loc1_.push(this.goodsId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getJlName() : String
      {
         return this._jlName;
      }
      
      public function getGoodsNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.goodsId.length)
         {
            _loc1_.push(this.goodsNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

