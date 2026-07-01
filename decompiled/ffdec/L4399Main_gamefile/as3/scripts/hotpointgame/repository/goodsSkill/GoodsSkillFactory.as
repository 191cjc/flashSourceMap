package hotpointgame.repository.goodsSkill
{
   public class GoodsSkillFactory
   {
      
      private static var skillList:Array = [];
      
      private static var skillDataList:Array = [];
      
      public function GoodsSkillFactory()
      {
         super();
      }
      
      public static function creteGoodsSkillFactory(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:GoodsSkillData = null;
         for each(_loc2_ in param1.技能)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.名字);
            _loc5_ = Number(_loc2_.大类型);
            _loc6_ = Number(_loc2_.小类型);
            _loc7_ = Number(_loc2_.概率);
            _loc8_ = Number(_loc2_.持续时间);
            _loc9_ = Number(_loc2_.值);
            _loc10_ = Number(_loc2_.间隔);
            _loc11_ = Number(_loc2_.值类型);
            _loc12_ = Number(_loc2_.怪物类型);
            _loc13_ = Number(_loc2_.怪物级别分类);
            _loc14_ = String(_loc2_.出现子弹);
            _loc15_ = String(_loc2_.说明);
            _loc16_ = GoodsSkillData.createGoodsSkillData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_);
            skillDataList[_loc3_] = _loc16_;
         }
      }
      
      public static function getSkillDataById(param1:Number) : GoodsSkillData
      {
         var _loc2_:GoodsSkillData = null;
         for each(_loc2_ in skillDataList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         throw new Error("没有此id 装备技能" + param1);
      }
   }
}

