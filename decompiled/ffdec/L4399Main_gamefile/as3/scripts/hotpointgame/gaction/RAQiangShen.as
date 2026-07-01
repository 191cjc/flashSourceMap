package hotpointgame.gaction
{
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class RAQiangShen extends CABulletSelect
   {
      
      private var hitFrame:Array;
      
      private var hitFrameB:Array;
      
      private var fdb:FightData;
      
      public function RAQiangShen(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.hitFrame = param1.others.hf;
         this.hitFrameB = param1.others.hfb;
         this.fdb = param1.fdb;
         super.setData(param1);
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         var _loc4_:ZhangDouT = null;
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            for each(_loc3_ in param2)
            {
               if(hitEnemy.indexOf(_loc3_) == -1)
               {
                  if(_loc3_.bhitByObject(param1.getAhit(),fda,param1) != -1)
                  {
                     hitEnemy[hitEnemy.length] = _loc3_;
                  }
               }
            }
         }
         if(currentFrameNum == this.hitFrame[1])
         {
            hitEnemy.length = 0;
         }
         if(currentFrameNum >= this.hitFrameB[0] && currentFrameNum <= this.hitFrameB[1])
         {
            for each(_loc4_ in param2)
            {
               if(hitEnemy.indexOf(_loc4_) == -1)
               {
                  if(_loc4_.bhitByObject(param1.getAhit(),this.fdb,param1) != -1)
                  {
                     hitEnemy[hitEnemy.length] = _loc4_;
                  }
               }
            }
         }
      }
   }
}

