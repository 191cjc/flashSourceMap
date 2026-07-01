package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.utils.gsound.*;
   
   public class CBrunaByKeYiByHit extends CBruna
   {
      
      public function CBrunaByKeYiByHit(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function enterRunStataOne() : void
      {
         runState = GS.a1;
         bSpeed = 0;
         mc.gotoAndPlay("爆炸");
         if(zhendong.fudu != null)
         {
            GM.levelm.setShakeMSpeed(zhendong);
         }
         if(bmSound != "null")
         {
            SoundManager.addOnlySound(bmSound);
         }
         if(bcumonstername != "")
         {
            MonsterManager.creatMonster(bcumonstername,getZx(),getZy() - GS.a50);
         }
      }
      
      override protected function enterRunStataTwo() : void
      {
         mc.stop();
         bSpeed = 0;
         runState = GS.a2;
      }
   }
}

