package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.ZhangDouT;
   
   public class CBombaFrame extends CBomba
   {
      
      private var hi:int = 0;
      
      private var hiJi:int = 0;
      
      public function CBombaFrame(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.hi = param1.others.hi;
         super.dataInit(param1);
      }
      
      override protected function bombaAttack(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         if(this.hiJi % this.hi == 0)
         {
            for each(_loc2_ in param1)
            {
               _loc2_.bhitByObject(getAhit(),fda,this);
            }
         }
         ++this.hiJi;
      }
   }
}

