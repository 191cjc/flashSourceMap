package hotpointgame.repository.everyDay
{
   import hotpointgame.common.*;
   import hotpointgame.models.everyDay.*;
   
   public class EveryDayBasicData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _type:VT;
      
      private var _allNum:VT;
      
      private var _fs:VT;
      
      public function EveryDayBasicData()
      {
         super();
      }
      
      public static function createEdBasicData(param1:Number, param2:String, param3:Number, param4:Number, param5:Number) : EveryDayBasicData
      {
         var _loc6_:EveryDayBasicData = new EveryDayBasicData();
         _loc6_._id = VT.createVT(param1);
         _loc6_._name = param2;
         _loc6_._type = VT.createVT(param3);
         _loc6_._allNum = VT.createVT(param4);
         _loc6_._fs = VT.createVT(param5);
         return _loc6_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getAllNum() : Number
      {
         return this._allNum.getValue();
      }
      
      public function getFs() : Number
      {
         return this._fs.getValue();
      }
      
      public function createEveryDay() : EveryDay
      {
         return EveryDay.createEveryDay(this._id.getValue());
      }
   }
}

