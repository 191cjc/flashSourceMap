package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.*;
   
   public class CMonsterRoleFollowMe extends CMonster
   {
      
      public function CMonsterRoleFollowMe(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
         _forth = 1;
         ztType = GS.a1;
         _vm.changeColor();
      }
      
      override public function setForth(param1:int) : void
      {
         _forth = param1;
         _vm.changeForth(_forth);
      }
      
      override public function moveByNoEnemy() : void
      {
         if(getZx() - GM.cp.getZx() > 150)
         {
            this.setForth(-1);
            _zCd.zou = cradom * fzouB + fzouA;
            changeActionByNameAndUpdateAndNo(MAZou.name);
         }
         else if(getZx() - GM.cp.getZx() < -150)
         {
            this.setForth(1);
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
               this.setForth(_forth * -1);
            }
            _zCd.zou = cradom * fzouB + fzouA;
            changeActionByNameAndUpdateAndNo(MAZou.name);
         }
      }
   }
}

