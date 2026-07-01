package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZhangDouT;
   
   public class CBombaFrameButton extends CBombaFrame
   {
      
      public function CBombaFrameButton(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         if(runState == 0)
         {
            if(currentFrameNum > 8)
            {
               if(GM.ckey.isKey("阶段1"))
               {
                  runState == GS.a1;
                  enterRunStataOne();
               }
            }
         }
      }
   }
}

