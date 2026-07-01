package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXTime extends CGX
   {
      
      private var mfun:Function;
      
      private var cn:int = 10;
      
      public function CGXTime(param1:MovieClip, param2:MovieClip, param3:int, param4:Function)
      {
         super(param1,param2);
         this.cn = param3;
         this.mfun = param4;
      }
      
      override public function gmUpdate() : Boolean
      {
         --this.cn;
         if(this.cn <= 0)
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

