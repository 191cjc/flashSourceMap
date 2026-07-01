package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.ZhangDouT;
   
   public class CBGenZongFeiLun extends CBGenZong
   {
      
      private var hi:int = 0;
      
      private var hiJi:int = 0;
      
      public function CBGenZongFeiLun(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:ZhangDouT, param5:int = 0)
      {
         this.hi = param3.others.hi;
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function bombaAttack(param1:Vector.<ZhangDouT>) : void
      {
         if(targetZt.isLive())
         {
            if(this.hiJi % this.hi == 0)
            {
               targetZt.bhit(fda,this);
            }
            ++this.hiJi;
         }
         else
         {
            enterRunStataTwo();
         }
      }
      
      override protected function afterUpdate() : void
      {
         if(runState == 1)
         {
            mc.x = targetZt.getZx();
            mc.y = targetZt.getZy() - 70;
         }
      }
   }
}

