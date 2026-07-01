package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   
   public class CMonsterChangerClocr extends CMonster
   {
      
      public function CMonsterChangerClocr(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
         _vm.changeColor();
      }
   }
}

