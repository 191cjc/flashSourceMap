package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZhangDouT;
   
   public class CMonsterNoForthDaPao extends CMonster
   {
      
      public function CMonsterNoForthDaPao(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function setForth(param1:int) : void
      {
      }
      
      override public function attackEnemy(param1:Vector.<ZhangDouT>) : void
      {
         if(param1.length > 0 && (currentState == GS.a0 || currentState == GS.a1))
         {
            _vm.getMc("zhuantou").rotation = 180 + Math.atan2(param1[0].getZy() - getZy(),param1[0].getZx() - getZx()) * 180 / Math.PI;
         }
         super.attackEnemy(param1);
      }
   }
}

