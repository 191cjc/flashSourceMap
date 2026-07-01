package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class CASiWangHurtHi extends CASiWang
   {
      
      private var hi:int = 0;
      
      private var hiJi:int = 0;
      
      private var hitFrame:Array;
      
      public function CASiWangHurtHi(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.hitFrame = param1.others.hf;
         this.hi = param1.others.hi;
         super.setData(param1);
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            if(this.hiJi % this.hi == 0)
            {
               for each(_loc3_ in param2)
               {
                  if(_loc3_.bhitByObject(param1.getAhit(),fda,param1) != -1)
                  {
                  }
               }
            }
         }
         ++this.hiJi;
      }
      
      override public function exit() : void
      {
         this.hiJi = 0;
         super.exit();
      }
   }
}

