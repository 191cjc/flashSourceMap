package hotpointgame.glevel.leveldata
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class LevelBDList
   {
      
      private var allBD:Array = new Array();
      
      public function LevelBDList()
      {
         super();
      }
      
      public function addBD(param1:LevelBD) : void
      {
         this.allBD[param1.id] = param1;
      }
      
      public function getBD(param1:int) : LevelBD
      {
         if(this.allBD[param1] == null)
         {
            GM.findCheatMax(GS.a22);
         }
         return this.allBD[param1] as LevelBD;
      }
      
      public function getTotalMaxAch(param1:Array) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(this.allBD[_loc3_] != null)
            {
               _loc2_ += (this.allBD[_loc3_] as LevelBD).maxach;
            }
         }
         return _loc2_;
      }
      
      public function getBeforeId(param1:int) : int
      {
         return this.getBD(param1).enterlid;
      }
      
      public function getLidByName(param1:String) : int
      {
         var _loc2_:int = int(this.allBD.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.allBD[_loc3_] != null)
            {
               if((this.allBD[_loc3_] as LevelBD).lname == param1)
               {
                  return (this.allBD[_loc3_] as LevelBD).id;
               }
            }
            _loc3_++;
         }
         GM.findCheatMax(GS.a23);
         return 0;
      }
   }
}

