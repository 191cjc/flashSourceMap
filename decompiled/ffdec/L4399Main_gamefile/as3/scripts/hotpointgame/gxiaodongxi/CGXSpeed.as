package hotpointgame.gxiaodongxi
{
   import flash.display.MovieClip;
   
   public class CGXSpeed extends CGX
   {
      
      private var mspeedx:int = 0;
      
      private var mspeedy:int = -20;
      
      private var cn:int = 10;
      
      private var bo:int = 0;
      
      public function CGXSpeed(param1:MovieClip, param2:MovieClip, param3:int, param4:int, param5:int)
      {
         super(param1,param2);
         this.mspeedx = param3;
         this.mspeedy = param4;
         this.cn = param5;
      }
      
      override public function movemc() : void
      {
         mc.x += this.mspeedx;
         mc.y += this.mspeedy;
         --this.cn;
      }
      
      override public function isover() : Boolean
      {
         if(this.cn > 0)
         {
            return false;
         }
         return true;
      }
   }
}

