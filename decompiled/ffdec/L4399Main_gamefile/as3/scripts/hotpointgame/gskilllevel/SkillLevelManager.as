package hotpointgame.gskilllevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gzhujiemian.*;
   
   public class SkillLevelManager
   {
      
      private var baseSkill:Vector.<SkillLevel> = new Vector.<SkillLevel>();
      
      private var wuxinSkill:Vector.<SkillLevel> = new Vector.<SkillLevel>();
      
      private var wuxinflase:Boolean = false;
      
      public function SkillLevelManager()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : SkillLevelManager
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:SkillLevelManager = new SkillLevelManager();
         if(param1 != null)
         {
            _loc3_ = param1["bs"];
            _loc4_ = 0;
            while(_loc4_ < int(GS.a7))
            {
               _loc2_.baseSkill[_loc4_] = new SkillLevel(_loc4_ + GS.a1,_loc3_[_loc4_]);
               _loc4_++;
            }
            _loc5_ = param1["wid"];
            _loc6_ = param1["wlv"];
            _loc7_ = 0;
            while(_loc7_ < int(GS.a4))
            {
               _loc2_.wuxinSkill[_loc7_] = new SkillLevel(_loc5_[_loc7_],_loc6_[_loc7_]);
               _loc7_++;
            }
         }
         else
         {
            _loc8_ = 0;
            while(_loc8_ < int(GS.a2))
            {
               _loc2_.baseSkill[_loc8_] = new SkillLevel(_loc8_ + GS.a1,GS.a1);
               _loc8_++;
            }
            _loc9_ = int(GS.a2);
            while(_loc9_ < int(GS.a7))
            {
               _loc2_.baseSkill[_loc9_] = new SkillLevel(_loc9_ + GS.a1,GS.a0);
               _loc9_++;
            }
            _loc10_ = 0;
            while(_loc10_ < int(GS.a4))
            {
               _loc2_.wuxinSkill[_loc10_] = new SkillLevel(GS.a0,GS.a0);
               _loc10_++;
            }
         }
         return _loc2_;
      }
      
      public function remove() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < int(GS.a7))
         {
            this.baseSkill[_loc1_].remove();
            _loc1_++;
         }
         this.baseSkill = null;
         var _loc2_:int = 0;
         while(_loc2_ < int(GS.a4))
         {
            this.wuxinSkill[_loc2_].remove();
            _loc2_++;
         }
         this.wuxinSkill = null;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            _loc2_[_loc3_] = this.baseSkill[_loc3_].curLevel;
            _loc3_++;
         }
         _loc1_["bs"] = _loc2_;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < 4)
         {
            _loc4_[_loc6_] = this.wuxinSkill[_loc6_].id;
            _loc5_[_loc6_] = this.wuxinSkill[_loc6_].curLevel;
            _loc6_++;
         }
         _loc1_["wid"] = _loc4_;
         _loc1_["wlv"] = _loc5_;
         return _loc1_;
      }
      
      public function upToNextNoCon(param1:int, param2:int) : Boolean
      {
         var _loc3_:SkillLevel = this.getBSkillLevelById(param1);
         if(_loc3_.getslbd().lvlimit < param2 || param2 < 1)
         {
            return false;
         }
         _loc3_.modLevel(param2);
         Czhujiemian.self.skillTiaoInit(param1 - GS.a1);
         GM.cp.skillUp(param1,_loc3_.curLevel);
         return true;
      }
      
      public function hasIsUp() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < GS.a7)
         {
            if(this.baseSkill[_loc1_].isUp())
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function upToNextBaseSkill(param1:int) : Boolean
      {
         var _loc2_:SkillLevel = this.getBSkillLevelById(param1);
         if(_loc2_.getslbd().upach > GM.levelSD.getTotalAchAllLevel())
         {
            return false;
         }
         if(_loc2_.getslbd().upgod > GM.cp.getGodByRole())
         {
            return false;
         }
         if(_loc2_.getslbd().upplv > GM.cp.getZtLevel())
         {
            return false;
         }
         if(_loc2_.getslbd().lvlimit <= _loc2_.curLevel)
         {
            return false;
         }
         GM.cp.redGodByRole(_loc2_.getslbd().upgod);
         _loc2_.upLevel();
         Czhujiemian.self.skillTiaoInit(param1 - GS.a1);
         GM.cp.skillUp(param1,_loc2_.curLevel);
         if(_loc2_.curLevel == 1)
         {
            FlowInterface.isXtOk(3);
         }
         else
         {
            FlowInterface.isXtOk(2);
         }
         return true;
      }
      
      public function getBaseSkillLevel() : Array
      {
         var _loc4_:SkillLevel = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < GS.a7)
         {
            _loc1_[_loc2_] = this.baseSkill[_loc2_].curLevel;
            _loc2_++;
         }
         var _loc3_:int = 1;
         while(_loc3_ < 5)
         {
            _loc4_ = this.getWXSkillLevelById(_loc3_);
            if(_loc4_ == null)
            {
               _loc1_[GS.a6 + _loc3_] = [0,0,0,0];
            }
            else
            {
               _loc1_[GS.a6 + _loc3_] = [_loc4_.id,_loc4_.curLevel,_loc4_.getslbd().name,_loc4_.getslbd().tubiaoF];
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getBSkillLevelById(param1:int) : SkillLevel
      {
         return this.baseSkill[param1 - GS.a1];
      }
      
      public function youXueWX() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            if(this.wuxinSkill[_loc2_].id > 0)
            {
               _loc1_.push(_loc2_ + 1);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getWXSkillLevelById(param1:int) : SkillLevel
      {
         if(this.wuxinSkill[param1 - GS.a1].id == 0)
         {
            return null;
         }
         return this.wuxinSkill[param1 - GS.a1];
      }
      
      public function upToNextWXSkill(param1:int) : Boolean
      {
         var _loc2_:SkillLevel = this.getWXSkillLevelById(param1);
         if(_loc2_ == null)
         {
            GM.findCheatMax(GS.a29);
         }
         if(_loc2_.getslbd().upach > GM.levelSD.getTotalAchAllLevel())
         {
            return false;
         }
         if(_loc2_.getslbd().upgod > GM.cp.getGodByRole())
         {
            return false;
         }
         if(_loc2_.getslbd().upplv > GM.cp.getZtLevel())
         {
            return false;
         }
         if(_loc2_.getslbd().lvlimit <= _loc2_.curLevel)
         {
            return false;
         }
         GM.cp.redGodByRole(_loc2_.getslbd().upgod);
         _loc2_.upLevel();
         Czhujiemian.self.skillTiaoInitByWX(param1,_loc2_.getslbd().tubiaoF);
         GM.cp.skillUpByWuXin(param1,_loc2_.getslbd().name,_loc2_.curLevel);
         FlowInterface.isXtOk(3);
         return true;
      }
      
      public function keyXueXiWxByJD(param1:int) : Boolean
      {
         var _loc2_:SkillLevel = this.getWXSkillLevelById(param1);
         if(_loc2_ == null)
         {
            return true;
         }
         return false;
      }
      
      public function useSkillBook(param1:int, param2:int) : void
      {
         var _loc3_:SkillLevel = this.wuxinSkill[param1 - GS.a1];
         _loc3_.id = param2;
         _loc3_.curLevel = GS.a1;
         _loc3_.resercachebd();
         Czhujiemian.self.skillTiaoInitByWX(param1,_loc3_.getslbd().tubiaoF);
         GM.cp.skillUpByWuXin(param1,_loc3_.getslbd().name,_loc3_.curLevel);
         FlowInterface.isXtOk(2);
      }
      
      public function useSkillBookRester(param1:int) : Boolean
      {
         var _loc2_:SkillLevel = this.wuxinSkill[param1 - GS.a1];
         if(_loc2_.id == 0)
         {
            return false;
         }
         _loc2_.resertInit();
         Czhujiemian.self.skillTiaoInitWXByClear(param1);
         GM.cp.skillUpWuXinByClear(param1);
         return true;
      }
   }
}

