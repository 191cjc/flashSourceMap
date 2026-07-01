package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXFrame extends CGX
   {
      
      public function CGXFrame(param1:MovieClip, param2:MovieClip)
      {
         super(param1,param2);
      }
      
      override public function isover() : Boolean
      {
         if(mc.currentFrame == mc.totalFrames)
         {
            return true;
         }
         return false;
      }
   }
}

