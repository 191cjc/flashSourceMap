package hotpointgame.repository.ship
{
   import hotpointgame.common.*;
   
   public class ShipLvBasicData
   {
      
      private var _lv:VT;
      
      private var _gsArr:Array = [];
      
      private var _gsNum:Array = [];
      
      private var _gx:VT;
      
      private var _gold:VT;
      
      public function ShipLvBasicData()
      {
         super();
      }
      
      public static function createShLvData(param1:Number, param2:String, param3:String, param4:Number, param5:Number) : ShipLvBasicData
      {
         var _loc6_:ShipLvBasicData = new ShipLvBasicData();
         _loc6_._lv = VT.createVT(param1);
         _loc6_._gsArr = strToArr(param2);
         _loc6_._gsNum = strToArr(param3);
         _loc6_._gx = VT.createVT(param4);
         _loc6_._gold = VT.createVT(param5);
         return _loc6_;
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
      
      public function getGx() : Number
      {
         return this._gx.getValue();
      }
      
      public function getGold() : Number
      {
         return this._gold.getValue();
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

