package hotpointgame.gskilllevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class SkillLevelBDataManager
   {
      
      private static var gunList:Array = new Array();
      
      private static var womgunList:Array = new Array();
      
      public function SkillLevelBDataManager()
      {
         super();
      }
      
      public static function createManGunSkill(param1:XML) : void
      {
         createSkillLevel(param1,gunList);
      }
      
      public static function createWomGunSkill(param1:XML) : void
      {
         createSkillLevel(param1,womgunList);
      }
      
      public static function createSkillLevel(param1:XML, param2:Array) : void
      {
         var _loc4_:XML = null;
         var _loc5_:SkillLevelBData = null;
         var _loc3_:Object = new Object();
         for each(_loc4_ in param1.技能界面)
         {
            _loc5_ = new SkillLevelBData();
            _loc5_.id = Number(_loc4_.技能id);
            if(!_loc3_.hasOwnProperty(_loc5_.id))
            {
               _loc3_[_loc5_.id] = "";
               param2[_loc5_.id] = new Array();
            }
            _loc5_.tubiaoF = Number(_loc4_.图标帧数);
            _loc5_.donghuaF = Number(_loc4_.展示动画);
            _loc5_.name = String(_loc4_.技能名称);
            _loc5_.namealv = String(_loc4_.配有等级说明的技能名称);
            _loc5_.wuxinn = String(_loc4_.技能五行);
            if(String(_loc4_.对应职业的精通) != "null")
            {
               _loc5_.wuxinnb = String(_loc4_.对应职业的精通);
            }
            else
            {
               _loc5_.wuxinnb = "";
            }
            _loc5_.cdcd = "" + int(Number(_loc4_.CD冷却) / 30) + "秒冷却时间";
            _loc5_.mpmp = "消耗" + Number(_loc4_.消耗能量) + "能量";
            _loc5_.skylimit = String(_loc4_.释放说明);
            _loc5_.keyc = String(_loc4_.技能快捷键);
            _loc5_.miaoshu = String(_loc4_.技能真实说明);
            _loc5_.npca = String(_loc4_.技能NPC处说明);
            _loc5_.npcb = String(_loc4_.技能NPC处说明2);
            _loc5_.npcc = String(_loc4_.技能NPC处说明3);
            _loc5_.lv = Number(_loc4_.技能等级);
            _loc5_.lvlimit = Number(_loc4_.技能等级上限);
            _loc5_.upach = Number(_loc4_.升级需求关卡成就点数);
            _loc5_.upgod = Number(_loc4_.升级需求金币);
            _loc5_.upplv = Number(_loc4_.升级需求角色等级);
            param2[_loc5_.id][_loc5_.lv] = _loc5_;
         }
      }
      
      public static function getSkillLevelBData(param1:int, param2:int) : SkillLevelBData
      {
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            return gunList[param1][param2] as SkillLevelBData;
         }
         if(FlowInterface.getJobByRole() == GS.a2)
         {
            return womgunList[param1][param2] as SkillLevelBData;
         }
         return null;
      }
   }
}

