package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtB;
   
   public class CBSkillTwo extends ZtB
   {
      
      private var hitEnemy:Array = [];
      
      private var hitFrame:Array;
      
      private var hitFrameB:Array;
      
      private var hi:int = 0;
      
      private var hiJi:int = 0;
      
      private var fdb:FightData;
      
      public function CBSkillTwo(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.hitFrame = param1.others.hf;
         this.hitFrameB = param1.others.hfb;
         this.hi = param1.others.hi;
         this.fdb = param1.fdb;
         super.dataInit(param1);
      }
      
      override protected function moveAndTestHit(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         var _loc3_:ZhangDouT = null;
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            for each(_loc2_ in param1)
            {
               if(this.hitEnemy.indexOf(_loc2_) == -1)
               {
                  if(_loc2_.bhitByObject(getAhit(),fda,this) != -1)
                  {
                     this.hitEnemy[this.hitEnemy.length] = _loc2_;
                  }
               }
            }
         }
         if(currentFrameNum >= this.hitFrameB[0] && currentFrameNum <= this.hitFrameB[1])
         {
            if(this.hiJi % this.hi == 0)
            {
               for each(_loc3_ in param1)
               {
                  _loc3_.bhitByObject(getAhit(),this.fdb,this);
               }
            }
            ++this.hiJi;
         }
      }
      
      override public function remove() : void
      {
         this.hitEnemy.length = 0;
         this.hitFrame = null;
         this.hitFrameB = null;
         this.fdb = null;
         super.remove();
      }
   }
}

