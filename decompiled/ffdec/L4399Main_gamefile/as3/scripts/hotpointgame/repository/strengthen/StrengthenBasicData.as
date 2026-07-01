package hotpointgame.repository.strengthen
{
   import hotpointgame.common.*;
   
   public class StrengthenBasicData
   {
      
      private var _changeLevel:VT;
      
      private var _color:VT;
      
      private var _strValue:Array;
      
      private var _probability:Array;
      
      private var _gold:Array;
      
      private var _dj:Array;
      
      private var _materialId:Array;
      
      private var _materialNum:Array;
      
      private var _shopId:Array;
      
      public function StrengthenBasicData()
      {
         super();
      }
      
      public static function createStrBasicData(param1:Number, param2:Number, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:String) : StrengthenBasicData
      {
         var _loc10_:StrengthenBasicData = new StrengthenBasicData();
         _loc10_._changeLevel = VT.createVT(param1);
         _loc10_._color = VT.createVT(param2);
         _loc10_._strValue = strToArr(param3);
         _loc10_._probability = strToArr(param4);
         _loc10_._gold = strToArr(param5);
         _loc10_._dj = strToArr(param6);
         _loc10_._materialId = strToArr(param7);
         _loc10_._materialNum = strToArr(param8);
         _loc10_._shopId = strToArr(param9);
         return _loc10_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Number(_loc2_[_loc4_]) is Number)
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
      
      public function getChangeLevel() : Number
      {
         return this._changeLevel.getValue();
      }
      
      public function getColor() : Number
      {
         return this._color.getValue();
      }
      
      public function getStrValue(param1:Number) : Number
      {
         return this._strValue[param1 - 1].getValue();
      }
      
      public function getProbability(param1:Number) : Number
      {
         return this._probability[param1 - 1].getValue();
      }
      
      public function getGold(param1:Number) : Number
      {
         return this._gold[param1 - 1].getValue();
      }
      
      public function getDj(param1:Number) : Number
      {
         return this._dj[param1 - 1].getValue();
      }
      
      public function getMateriaId(param1:Number) : Number
      {
         return this._materialId[param1 - 1].getValue();
      }
      
      public function getMateriaNum(param1:Number) : Number
      {
         return this._materialNum[param1 - 1].getValue();
      }
      
      public function getShopId(param1:Number) : Number
      {
         return this._shopId[param1 - 1].getValue();
      }
   }
}

