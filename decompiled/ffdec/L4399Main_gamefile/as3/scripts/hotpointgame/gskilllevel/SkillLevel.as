package hotpointgame.gskilllevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class SkillLevel
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _curLevel:VT = VT.createVT(0);
      
      private var levelbd:SkillLevelBData;
      
      public function SkillLevel(param1:int, param2:int)
      {
         super();
         this.id = param1;
         this.curLevel = param2;
      }
      
      public function remove() : void
      {
         this._id = null;
         this._curLevel = null;
         this.levelbd = null;
      }
      
      private function cachebd() : void
      {
         if(this.levelbd == null)
         {
            this.levelbd = SkillLevelBDataManager.getSkillLevelBData(this.id,this.curLevel);
         }
      }
      
      public function resercachebd() : void
      {
         this.levelbd = SkillLevelBDataManager.getSkillLevelBData(this.id,this.curLevel);
      }
      
      public function resertInit() : void
      {
         this.id = 0;
         this.curLevel = 0;
         this.levelbd = null;
      }
      
      public function getslbd() : SkillLevelBData
      {
         this.cachebd();
         return this.levelbd;
      }
      
      public function upLevel() : void
      {
         ++this.curLevel;
         this.levelbd = SkillLevelBDataManager.getSkillLevelBData(this.id,this.curLevel);
      }
      
      public function modLevel(param1:int) : void
      {
         this.curLevel = param1;
         this.levelbd = SkillLevelBDataManager.getSkillLevelBData(this.id,this.curLevel);
      }
      
      public function isUp() : Boolean
      {
         if(this.id == 0)
         {
            return false;
         }
         this.cachebd();
         if(this.levelbd.upach > GM.levelSD.getTotalAchAllLevel())
         {
            return false;
         }
         if(this.levelbd.upgod > GM.cp.getGodByRole())
         {
            return false;
         }
         if(this.levelbd.upplv > GM.cp.getZtLevel())
         {
            return false;
         }
         if(this.levelbd.lvlimit <= this.curLevel)
         {
            return false;
         }
         return true;
      }
      
      public function isUpArr() : Array
      {
         if(this.id == 0)
         {
            return [0,0,0,0];
         }
         var _loc1_:Array = new Array(1,1,1,1);
         this.cachebd();
         if(this.levelbd.upach > GM.levelSD.getTotalAchAllLevel())
         {
            _loc1_[0] = 0;
         }
         if(this.levelbd.upgod > GM.cp.getGodByRole())
         {
            _loc1_[1] = 0;
         }
         if(this.levelbd.upplv > GM.cp.getZtLevel())
         {
            _loc1_[2] = 0;
         }
         if(this.levelbd.lvlimit <= this.curLevel)
         {
            _loc1_[3] = 0;
         }
         return _loc1_;
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get curLevel() : int
      {
         return this._curLevel.getValue();
      }
      
      public function set curLevel(param1:int) : void
      {
         this._curLevel.setValue(param1);
      }
   }
}

