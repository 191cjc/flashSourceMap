package hotpointgame.repository.goods
{
   import hotpointgame.common.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   
   public class SuitEquipFactory
   {
      
      private static var suitList:Array = [];
      
      public function SuitEquipFactory()
      {
         super();
      }
      
      public static function creatSuitFactory(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:XMLList = null;
         var _loc6_:XMLList = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc11_:SuitEquipBasicData = null;
         for each(_loc2_ in param1.套装)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.名字);
            _loc5_ = _loc2_.套装属性;
            _loc6_ = _loc2_.套装技能;
            _loc7_ = [];
            _loc8_ = [];
            for each(_loc9_ in _loc6_)
            {
               if(_loc9_.技能a != -1)
               {
                  _loc8_.push(new Array(strToNum(_loc9_.技能a,1),strToNum(_loc9_.技能a,2)));
               }
               if(_loc9_.技能b != -1)
               {
                  _loc8_.push(new Array(strToNum(_loc9_.技能b,1),strToNum(_loc9_.技能b,2)));
               }
               if(_loc9_.技能c != -1)
               {
                  _loc8_.push(new Array(strToNum(_loc9_.技能c,1),strToNum(_loc9_.技能c,2)));
               }
               if(_loc9_.技能d != -1)
               {
                  _loc8_.push(new Array(strToNum(_loc9_.技能d,1),strToNum(_loc9_.技能d,2)));
               }
            }
            for each(_loc10_ in _loc5_)
            {
               if(_loc10_.生命 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(1,strToNum(_loc10_.生命,1)),strToNum(_loc10_.生命,2),strToNum(_loc10_.生命,3)));
               }
               if(_loc10_.能量 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(2,strToNum(_loc10_.能量,1)),strToNum(_loc10_.能量,2),strToNum(_loc10_.能量,3)));
               }
               if(_loc10_.攻击 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(3,strToNum(_loc10_.攻击,1)),strToNum(_loc10_.攻击,2),strToNum(_loc10_.攻击,3)));
               }
               if(_loc10_.防御 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(4,strToNum(_loc10_.防御,1)),strToNum(_loc10_.防御,2),strToNum(_loc10_.防御,3)));
               }
               if(_loc10_.暴击 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(5,strToNum(_loc10_.暴击,1)),strToNum(_loc10_.暴击,2),strToNum(_loc10_.暴击,3)));
               }
               if(_loc10_.速度 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(6,strToNum(_loc10_.速度,1)),strToNum(_loc10_.速度,2),strToNum(_loc10_.速度,3)));
               }
               if(_loc10_.金 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(7,strToNum(_loc10_.金,1)),strToNum(_loc10_.金,2),strToNum(_loc10_.金,3)));
               }
               if(_loc10_.木 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(8,strToNum(_loc10_.木,1)),strToNum(_loc10_.木,2),strToNum(_loc10_.木,3)));
               }
               if(_loc10_.水 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(9,strToNum(_loc10_.水,1)),strToNum(_loc10_.水,2),strToNum(_loc10_.水,3)));
               }
               if(_loc10_.火 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(10,strToNum(_loc10_.火,1)),strToNum(_loc10_.火,2),strToNum(_loc10_.火,3)));
               }
               if(_loc10_.土 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(11,strToNum(_loc10_.土,1)),strToNum(_loc10_.土,2),strToNum(_loc10_.土,3)));
               }
               if(_loc10_.混沌 != -1)
               {
                  _loc7_.push(new Array(BasicSx.creatBasicSx(12,strToNum(_loc10_.混沌,1)),strToNum(_loc10_.混沌,2),strToNum(_loc10_.混沌,3)));
               }
            }
            _loc11_ = SuitEquipBasicData.createSuitEquip(_loc3_,_loc4_,_loc8_,_loc7_);
            suitList[_loc3_] = _loc11_;
         }
      }
      
      private static function strToNum(param1:String, param2:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = param1.lastIndexOf("*");
         var _loc5_:int = param1.lastIndexOf("$");
         if(param2 == 1)
         {
            _loc3_ = Number(param1.substr(0,_loc4_));
         }
         else if(param2 == 2)
         {
            _loc3_ = Number(param1.substr(_loc4_ + 1,1));
         }
         else if(param2 == 3)
         {
            _loc3_ = Number(param1.substr(_loc5_ + 1,1));
         }
         return _loc3_;
      }
      
      public static function getSuitById(param1:Number) : SuitEquipBasicData
      {
         if(suitList[param1] != null)
         {
            return suitList[param1];
         }
         throw new Error("不存在此套装" + param1);
      }
      
      public static function getSuitSxByIdAndNum(param1:Number, param2:Number) : Array
      {
         var _loc4_:SuitEquipBasicData = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:Array = [];
         if(getSuitById(param1) != null)
         {
            _loc4_ = getSuitById(param1);
            _loc5_ = _loc4_.getBasicSx();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_][1] <= param2)
               {
                  _loc3_.push(_loc5_[_loc6_][0]);
               }
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public static function getSuitBfb(param1:Number, param2:Number) : Array
      {
         var _loc4_:SuitEquipBasicData = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:Array = [];
         if(getSuitById(param1) != null)
         {
            _loc4_ = getSuitById(param1);
            _loc5_ = _loc4_.getBasicSx();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_][1] <= param2)
               {
                  _loc3_.push(_loc5_[_loc6_][2]);
               }
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public static function getSkillByIdAndNum(param1:Number, param2:Number) : Array
      {
         var _loc3_:SuitEquipBasicData = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         if(getSuitById(param1) != null)
         {
            _loc3_ = getSuitById(param1);
            _loc4_ = _loc3_.getSkillSx();
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(_loc4_[_loc6_][1] <= param2)
               {
                  _loc5_.push(_loc4_[_loc6_][0]);
               }
               _loc6_++;
            }
         }
         if(_loc5_.length == 0)
         {
            return null;
         }
         return _loc5_;
      }
      
      public static function getSxSm(param1:Number, param2:Number) : Array
      {
         var _loc5_:SuitEquipBasicData = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:BasicSx = null;
         var _loc3_:Array = [];
         var _loc4_:String = "";
         if(getSuitById(param1) != null)
         {
            _loc5_ = getSuitById(param1);
            _loc6_ = _loc5_.getBasicSx();
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_][1] == param2)
               {
                  _loc3_.push(_loc6_[_loc7_]);
               }
               _loc7_++;
            }
         }
         if(_loc3_.length == 0)
         {
            return null;
         }
         _loc8_ = [];
         _loc9_ = 0;
         while(_loc9_ < _loc3_.length)
         {
            _loc10_ = _loc3_[_loc9_][0] as BasicSx;
            param2 = Number(_loc3_[_loc9_][1]);
            if(_loc3_[_loc9_][2] == 0)
            {
               _loc4_ = "";
               _loc8_.push(getDescription(_loc10_.getSxType(),_loc10_.getValue(),param2,_loc4_));
            }
            else
            {
               _loc4_ = "%";
               _loc8_.push(getDescription(_loc10_.getSxType(),Math.round(_loc10_.getValue() / GS.a100 / 0.1) * 0.1,param2,_loc4_));
            }
            _loc9_++;
         }
         return _loc8_;
      }
      
      public static function getJnSm(param1:Number, param2:Number) : Array
      {
         var _loc5_:SuitEquipBasicData = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         if(getSuitById(param1) != null)
         {
            _loc5_ = getSuitById(param1);
            _loc6_ = _loc5_.getSkillSx();
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_][1] == param2)
               {
                  _loc3_.push(_loc6_[_loc7_]);
               }
               _loc7_++;
            }
         }
         if(_loc3_.length != 0)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc3_.length)
            {
               _loc4_.push(GoodsSkillFactory.getSkillDataById(_loc3_[_loc8_][0]).getSm() + "(" + param2 + "件)");
               _loc8_++;
            }
         }
         return _loc4_;
      }
      
      private static function getDescription(param1:uint, param2:uint, param3:Number, param4:String) : String
      {
         var _loc5_:String = null;
         switch(param1)
         {
            case 1:
               _loc5_ = "生命+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 2:
               _loc5_ = "能量+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 3:
               _loc5_ = "攻击+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 4:
               _loc5_ = "防御+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 5:
               _loc5_ = "暴击+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 6:
               _loc5_ = "速度+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 7:
               _loc5_ = "金+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 8:
               _loc5_ = "木+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 9:
               _loc5_ = "水+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 10:
               _loc5_ = "火+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 11:
               _loc5_ = "土+" + param2 + param4 + "(" + param3 + "件)";
               break;
            case 12:
               _loc5_ = "混沌+" + param2 + param4 + "(" + param3 + "件)";
               break;
            default:
               throw new Error("物品基础属性不存在的类型:type:" + param1);
         }
         return _loc5_;
      }
      
      public static function getName(param1:Number) : String
      {
         return getSuitById(param1).getName();
      }
   }
}

