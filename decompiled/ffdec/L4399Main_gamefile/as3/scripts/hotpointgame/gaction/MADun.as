package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class MADun extends CAction
   {
      
      private var stopframe:int = 35;
      
      private var randomf:int = 0;
      
      private var randomt:int = 0;
      
      private var jiShustop:int = 0;
      
      public function MADun(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.randomf = param1.others.randomf;
         this.randomt = param1.others.randomt;
         super.setData(param1);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(currentFrameNum == this.stopframe)
         {
            this.jiShustop = this.randomf + Math.random() * this.randomt;
            param1.gotoAndStopFrame(param1.getCurrentFrameNum());
         }
         if(currentFrameNum > this.stopframe && currentFrameNum - this.stopframe > this.jiShustop)
         {
            param1.gotoAndPlayFrame(param1.getCurrentFrameNum());
         }
         if(param1.getFrameLabel() != flaFrameName)
         {
            return true;
         }
         return false;
      }
      
      override public function exit() : void
      {
         this.jiShustop = 0;
         super.exit();
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         if(param2.length > 0)
         {
            if(param2[0].getZx() - param1.getZx() > 0)
            {
               param1.setForth(1);
            }
            else
            {
               param1.setForth(-1);
            }
         }
      }
   }
}

