package hotpointgame.repository.ship
{
   import hotpointgame.common.*;
   
   public class ShipXlBasicData
   {
      
      private var _lv:VT;
      
      private var _time:VT;
      
      private var _gsArr:Array = [];
      
      private var _gsNum:Array = [];
      
      private var _cs:VT;
      
      private var _gold:VT;
      
      public function ShipXlBasicData()
      {
         super();
      }
      
      public static function createShipXlData(param1:Number, param2:Number, param3:String, param4:String, param5:Number, param6:Number) : ShipXlBasicData
      {
         var _loc7_:ShipXlBasicData = new ShipXlBasicData();
         _loc7_._lv = VT.createVT(param1);
         _loc7_._time = VT.createVT(param2);
         _loc7_._gsArr = strToArr(param3);
         _loc7_._gsNum = strToArr(param4);
         _loc7_._cs = VT.createVT(param5);
         _loc7_._gold = VT.createVT(param6);
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
      
      public function getLv() : Number
      {
         return this._lv.getValue();
      }
      
      public function getTime() : Number
      {
         return this._time.getValue();
      }
      
      public function getCs() : Number
      {
         return this._cs.getValue();
      }
      
      public function getGold() : Number
      {
         return this._gold.getValue();
      }
      
      public function getGsIdArr() : Array
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
      
      public function getGsNumArr() : Array
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

