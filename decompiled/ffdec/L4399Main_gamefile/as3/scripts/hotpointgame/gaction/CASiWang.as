package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class CASiWang extends CAction
   {
      
      private var shiNum:int = 0;
      
      private var nameA:String = "死亡1";
      
      private var nameB:String = "死亡2";
      
      private var currentName:String = this.nameA;
      
      public function CASiWang(param1:String)
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         currentFrameNum = 0;
         if(param1.currentFrameName != "倒地")
         {
            param1.gotoAndPlayFrame(this.nameA);
            this.currentName = this.nameA;
         }
         else
         {
            param1.gotoAndPlayFrame(this.nameB);
            this.currentName = this.nameB;
         }
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(param1.getCurrentFrameNum() > this.shiNum)
         {
            this.shiNum = param1.getCurrentFrameNum();
         }
         if(param1.getFrameLabel() != this.currentName)
         {
            param1.gotoAndStopFrame(this.shiNum - 1);
            return true;
         }
         return false;
      }
   }
}

