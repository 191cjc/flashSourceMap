package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class CASkillOnePoint extends CASkillOne
   {
      
      private var hitFrame:Array;
      
      public function CASkillOnePoint(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.hitFrame = param1.others.hf;
         super.setData(param1);
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            for each(_loc3_ in param2)
            {
               if(hitEnemy.indexOf(_loc3_) == -1)
               {
                  if(_loc3_.bhitByObjectAndPoint(param1.getAhit(),fda,param1) != -1)
                  {
                     hitEnemy[hitEnemy.length] = _loc3_;
                  }
               }
            }
         }
      }
   }
}

