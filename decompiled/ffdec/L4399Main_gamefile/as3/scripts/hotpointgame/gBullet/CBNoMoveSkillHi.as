package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtB;
   
   public class CBNoMoveSkillHi extends ZtB
   {
      
      private var hitFrame:Array;
      
      private var hi:int = 0;
      
      private var hiJi:int = 0;
      
      private var atnum:int = 0;
      
      public function CBNoMoveSkillHi(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.hitFrame = param1.others.hf;
         this.hi = param1.others.hi;
         this.atnum = param1.others.atnum;
         super.dataInit(param1);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            if(this.hiJi % this.hi == 0)
            {
               for each(_loc2_ in param1)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.atnum)
                  {
                     _loc4_ = "bahit";
                     if(_loc3_ != 0)
                     {
                        _loc4_ += _loc3_;
                     }
                     if(getOtherAhit(_loc4_))
                     {
                        _loc2_.bhitByObject(getOtherAhit(_loc4_),fda,this);
                     }
                     _loc3_++;
                  }
               }
            }
            ++this.hiJi;
         }
      }
      
      override public function remove() : void
      {
         this.hitFrame = null;
         super.remove();
      }
   }
}

