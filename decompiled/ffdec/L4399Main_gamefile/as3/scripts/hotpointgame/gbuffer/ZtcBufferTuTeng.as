package hotpointgame.gbuffer
{
   import flash.display.MovieClip;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class ZtcBufferTuTeng extends ZtcBuffer
   {
      
      public function ZtcBufferTuTeng(param1:MovieClip, param2:ZtC, param3:Object)
      {
         super(param1,param2,param3);
      }
      
      override public function gmUpdate(param1:ZtC) : int
      {
         ++bhijishi;
         --bnum;
         if((param1 as CMonsterZHBullet).xiaoDeNum() == 0)
         {
            return -1;
         }
         return 100;
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         if(bhijishi % bhi == 0)
         {
            for each(_loc3_ in param2)
            {
               _loc3_.bhitHp(hurt);
            }
         }
      }
   }
}

