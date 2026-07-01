package hotpointgame.repository.goodsSkill
{
   import hotpointgame.common.*;
   
   public class GoodsSkillData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _type:VT;
      
      private var _sType:VT;
      
      private var _pro:VT;
      
      private var _cTimer:VT;
      
      private var _value:VT;
      
      private var _cValue:VT;
      
      private var _valueType:VT;
      
      private var _enemyType:VT;
      
      private var _emyLevelType:VT;
      
      private var _zdStr:String;
      
      private var _sm:String;
      
      public function GoodsSkillData()
      {
         super();
      }
      
      public static function createGoodsSkillData(param1:Number, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:String, param13:String) : GoodsSkillData
      {
         var _loc14_:GoodsSkillData = new GoodsSkillData();
         _loc14_._id = VT.createVT(param1);
         _loc14_._name = param2;
         _loc14_._type = VT.createVT(param3);
         _loc14_._sType = VT.createVT(param4);
         _loc14_._pro = VT.createVT(param5);
         _loc14_._cTimer = VT.createVT(param6);
         _loc14_._value = VT.createVT(param7);
         _loc14_._cValue = VT.createVT(param8);
         _loc14_._valueType = VT.createVT(param9);
         _loc14_._enemyType = VT.createVT(param10);
         _loc14_._emyLevelType = VT.createVT(param11);
         _loc14_._zdStr = param12;
         _loc14_._sm = param13;
         return _loc14_;
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
      
      public function getStype() : Number
      {
         return this._sType.getValue();
      }
      
      public function getPro() : Number
      {
         return this._pro.getValue();
      }
      
      public function getCtime() : Number
      {
         return this._cTimer.getValue();
      }
      
      public function getValue() : Number
      {
         return this._value.getValue();
      }
      
      public function getCvalue() : Number
      {
         return this._cValue.getValue();
      }
      
      public function getValueType() : Number
      {
         return this._valueType.getValue();
      }
      
      public function getEnemyType() : Number
      {
         return this._enemyType.getValue();
      }
      
      public function getEnyLeType() : Number
      {
         return this._emyLevelType.getValue();
      }
      
      public function getZdStr() : String
      {
         return this._zdStr;
      }
      
      public function getSm() : String
      {
         return this._sm;
      }
   }
}

