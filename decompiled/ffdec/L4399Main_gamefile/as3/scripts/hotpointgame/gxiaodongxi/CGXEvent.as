package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXEvent extends CGX
   {
      
      private var mfun:Function;
      
      public function CGXEvent(param1:MovieClip, param2:MovieClip, param3:Function)
      {
         super(param1,param2);
         this.mfun = param3;
      }
      
      override public function gmUpdate() : Boolean
      {
         if(mc.currentFrame == mc.totalFrames)
         {
            this.mfun();
            return true;
         }
         return false;
      }
      
      override public function remove() : void
      {
         this.mfun = null;
         super.remove();
      }
   }
}

