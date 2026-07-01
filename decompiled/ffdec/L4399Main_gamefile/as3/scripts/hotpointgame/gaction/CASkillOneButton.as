package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class CASkillOneButton extends CAction
   {
      
      private var stopFram:int = 0;
      
      private var startFram:int = 0;
      
      private var curframState:int = 0;
      
      private var hitFrame:Array;
      
      public function CASkillOneButton(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.stopFram = param1.others.ting;
         this.startFram = param1.others.qiehuan;
         this.hitFrame = param1.others.hf;
         super.setData(param1);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(this.curframState == 0)
         {
            if(GM.ckey.isKey("机甲技能3"))
            {
               if(currentFrameNum == this.stopFram)
               {
                  param1.gotoAndStopFrame(param1.getCurrentFrameNum());
               }
               if(currentFrameNum > this.stopFram)
               {
                  currentFrameNum = this.stopFram + GS.a1;
               }
               return false;
            }
            this.curframState = GS.a1;
            currentFrameNum = this.stopFram + GS.a1;
            param1.gotoAndPlayFrame(this.startFram);
            return false;
         }
         if(param1.getFrameLabel() != flaFrameName)
         {
            return true;
         }
         return false;
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         if(this.curframState == GS.a1)
         {
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
         }
      }
      
      override public function exit() : void
      {
         this.curframState = 0;
         super.exit();
      }
   }
}

