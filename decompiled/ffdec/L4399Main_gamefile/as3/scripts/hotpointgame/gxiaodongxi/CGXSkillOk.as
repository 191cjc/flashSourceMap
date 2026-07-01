package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXSkillOk extends CGX
   {
      
      public function CGXSkillOk(param1:MovieClip, param2:MovieClip = null)
      {
         super(param1);
         mc.visible = true;
         mc.gotoAndPlay(1);
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
         mc.visible = false;
         mc = null;
      }
   }
}

