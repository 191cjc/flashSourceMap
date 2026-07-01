package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   
   public class CMonsterNoForth extends CMonster
   {
      
      public function CMonsterNoForth(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function setForth(param1:int) : void
      {
      }
   }
}

