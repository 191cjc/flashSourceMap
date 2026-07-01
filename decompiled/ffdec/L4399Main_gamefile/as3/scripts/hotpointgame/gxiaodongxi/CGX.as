package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGX
   {
      
      protected var mc:MovieClip;
      
      public function CGX(param1:MovieClip, param2:MovieClip = null)
      {
         super();
         this.mc = param1;
         if(param2 != null)
         {
            param2.addChild(this.mc);
         }
      }
      
      public function gmUpdate() : Boolean
      {
         this.movemc();
         return this.isover();
      }
      
      public function movemc() : void
      {
      }
      
      public function isover() : Boolean
      {
         return false;
      }
      
      public function remove() : void
      {
         this.mc.stop();
         if(this.mc.parent)
         {
            this.mc.parent.removeChild(this.mc);
         }
         this.mc = null;
      }
   }
}

