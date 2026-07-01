package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class CAjidao extends CAction
   {
      
      public function CAjidao(param1:String)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:ZtC) : Boolean
      {
         ++currentFrameNum;
         if(currentFrameNum > 1)
         {
            if(param1.zCd.resetjidao == 1)
            {
               param1.gotoAndPlayFrame(flaFrameName);
               param1.gotoAndPlayFrame(param1.getCurrentFrameNum() + 8);
               currentFrameNum = 9;
               param1.zCd.resetjidao = 0;
            }
         }
         if(currentFrameNum == 37)
         {
            param1.gotoAndStopFrame(param1.getCurrentFrameNum());
         }
         return false;
      }
   }
}

