package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.gaction.*;
   
   public class CMonsterFollowMe extends CMonster
   {
      
      public function CMonsterFollowMe(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function moveByNoEnemy() : void
      {
         if(getZx() - GM.cp.getZx() > 150)
         {
            setForth(-1);
            _zCd.zou = cradom * fzouB + fzouA;
            changeActionByNameAndUpdateAndNo(MAZou.name);
         }
         else if(getZx() - GM.cp.getZx() < -150)
         {
            setForth(1);
            _zCd.zou = cradom * fzouB + fzouA;
            changeActionByNameAndUpdateAndNo(MAZou.name);
         }
         else if(cradom * 100 > mAzRate)
         {
            _zCd.deiji = fdeiji;
            changeActionByNameAndUpdateAndNo(MADaiJi.name);
         }
         else
         {
            if(cradom * 100 > forthRate)
            {
               setForth(_forth * -1);
            }
            _zCd.zou = cradom * fzouB + fzouA;
            changeActionByNameAndUpdateAndNo(MAZou.name);
         }
      }
   }
}

