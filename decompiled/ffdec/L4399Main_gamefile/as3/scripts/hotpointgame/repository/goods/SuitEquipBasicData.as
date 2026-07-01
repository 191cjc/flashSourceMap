package hotpointgame.repository.goods
{
   import hotpointgame.common.*;
   
   public class SuitEquipBasicData
   {
      
      private var _suitId:VT;
      
      private var _name:String;
      
      private var _skillSx:Array = [];
      
      private var _basicSx:Array = [];
      
      public function SuitEquipBasicData()
      {
         super();
      }
      
      public static function createSuitEquip(param1:Number, param2:String, param3:Array, param4:Array) : SuitEquipBasicData
      {
         var _loc5_:SuitEquipBasicData = new SuitEquipBasicData();
         _loc5_._suitId = VT.createVT(param1);
         _loc5_._name = param2;
         _loc5_._skillSx = param3;
         _loc5_._basicSx = param4;
         return _loc5_;
      }
      
      public function getSuitId() : Number
      {
         return this._suitId.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getBasicSx() : Array
      {
         return this._basicSx;
      }
      
      public function getSkillSx() : Array
      {
         return this._skillSx;
      }
      
      public function getSkillDirections() : Array
      {
         return [];
      }
   }
}

