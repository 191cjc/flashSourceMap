package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   
   public class CMonsterRoleMc extends CMonster
   {
      
      public function CMonsterRoleMc(param1:MovieClip, param2:Number, param3:Number, param4:Object)
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
   }
}

