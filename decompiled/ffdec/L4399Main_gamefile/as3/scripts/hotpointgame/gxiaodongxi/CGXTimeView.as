package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXTimeView extends CGX
   {
      
      private var cn:int = 30;
      
      public function CGXTimeView(param1:MovieClip, param2:MovieClip = null, param3:int = 30)
      {
         super(param1,param2);
      }
      
      override public function gmUpdate() : Boolean
      {
         --this.cn;
         if(this.cn <= 0)
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

