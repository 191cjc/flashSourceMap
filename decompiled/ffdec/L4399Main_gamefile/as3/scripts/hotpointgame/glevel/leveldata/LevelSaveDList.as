package hotpointgame.glevel.leveldata
{
   import hotpointgame.common.*;
   import hotpointgame.glevel.*;
   
   public class LevelSaveDList
   {
      
      private var sData:Array = new Array();
      
      public function LevelSaveDList()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : LevelSaveDList
      {
         var _loc3_:String = null;
         var _loc2_:LevelSaveDList = new LevelSaveDList();
         if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               _loc2_.sData[int(_loc3_)] = LevelSaveD.readData(param1[_loc3_]);
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:int = int(this.sData.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.sData[_loc3_] != null)
            {
               _loc1_["" + _loc3_] = (this.sData[_loc3_] as LevelSaveD).save();
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function remove() : void
      {
         var _loc1_:int = int(this.sData.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.sData[_loc2_] != null)
            {
               (this.sData[_loc2_] as LevelSaveD).remove();
            }
            _loc2_++;
         }
         this.sData = null;
      }
      
      public function getTotalAchByList(param1:Array) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(this.sData[_loc3_] != null)
            {
               _loc2_ += (this.sData[_loc3_] as LevelSaveD).lAchieve;
            }
         }
         return _loc2_;
      }
      
      public function getTotalAchAllLevel() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this.sData.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.sData[_loc3_] != null)
            {
               _loc1_ += (this.sData[_loc3_] as LevelSaveD).lAchieve;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getOverProcess(param1:int) : int
      {
         var _loc3_:LevelSaveD = null;
         var _loc4_:LevelSaveD = null;
         if(this.sData[param1] != null)
         {
            return (this.sData[param1] as LevelSaveD).lOver;
         }
         var _loc2_:int = int(LevelDataManager.getLevelBD(param1).enterlid);
         if(_loc2_ == 0)
         {
            _loc3_ = new LevelSaveD();
            _loc3_.id = param1;
            this.sData[param1] = _loc3_;
            return 0;
         }
         if(this.sData[_loc2_] != null)
         {
            if((this.sData[_loc2_] as LevelSaveD).hasOver())
            {
               _loc4_ = new LevelSaveD();
               _loc4_.id = param1;
               this.sData[param1] = _loc4_;
               return 0;
            }
         }
         return -GS.a1;
      }
      
      public function addAch(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = this.getOverProcess(param1);
         if(_loc4_ != -1)
         {
            (this.sData[param1] as LevelSaveD).addAchieve(param2);
            (this.sData[param1] as LevelSaveD).addLstar(param3);
         }
      }
      
      public function setAch(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:LevelSaveD = null;
         if(this.sData[param1] != null)
         {
            (this.sData[param1] as LevelSaveD).lOver = param3;
            (this.sData[param1] as LevelSaveD).lAchieve = param2;
            (this.sData[param1] as LevelSaveD).addAchieve(GS.a1);
         }
         else if(LevelDataManager.getLevelBD(param1) != null)
         {
            _loc4_ = new LevelSaveD();
            _loc4_.id = param1;
            _loc4_.lOver = param3;
            _loc4_.lAchieve = param2;
            _loc4_.addAchieve(GS.a1);
            this.sData[param1] = _loc4_;
         }
      }
      
      public function getAchByid(param1:int) : int
      {
         if(this.sData[param1] != null)
         {
            return (this.sData[param1] as LevelSaveD).lAchieve;
         }
         return 0;
      }
      
      public function isHasMaxAch(param1:int) : Boolean
      {
         var _loc2_:LevelBD = LevelDataManager.getLevelBD(param1);
         if(_loc2_.maxach <= this.getAchByid(param1))
         {
            return true;
         }
         return false;
      }
   }
}

