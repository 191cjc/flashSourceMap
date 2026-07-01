package hotpointgame.repository.petGj
{
   import hotpointgame.common.*;
   
   public class PetHosData
   {
      
      public var _lv:VT;
      
      public var _gsId:Array = [];
      
      public var _gsNum:Array = [];
      
      public var _gold:VT;
      
      public var _gx:VT;
      
      public function PetHosData()
      {
         super();
      }
      
      public static function createPetHosData(param1:Number, param2:String, param3:String, param4:Number, param5:Number) : PetHosData
      {
         var _loc6_:PetHosData = new PetHosData();
         _loc6_._lv = VT.createVT(param1);
         _loc6_._gsId = strToArr(param2);
         _loc6_._gsNum = strToArr(param3);
         _loc6_._gold = VT.createVT(param4);
         _loc6_._gx = VT.createVT(param5);
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
      
      public function getGsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._gsId.length)
         {
            _loc1_[_loc2_] = this._gsId[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGsNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._gsId.length)
         {
            _loc1_[_loc2_] = this._gsNum[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGold() : Number
      {
         return this._gold.getValue();
      }
      
      public function getGx() : Number
      {
         return this._gx.getValue();
      }
   }
}

