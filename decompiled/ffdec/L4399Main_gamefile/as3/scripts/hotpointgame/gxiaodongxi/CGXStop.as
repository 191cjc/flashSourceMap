package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXStop extends CGX
   {
      
      public function CGXStop(param1:MovieClip, param2:MovieClip)
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
      
      override public function remove() : void
      {
         mc.stop();
         mc = null;
      }
   }
}

