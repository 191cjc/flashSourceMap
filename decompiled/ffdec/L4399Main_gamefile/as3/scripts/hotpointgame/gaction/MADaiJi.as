package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class MADaiJi extends CAction
   {
      
      public static var name:String = "待机";
      
      private var nameA:String = "待机1";
      
      private var nameB:String = "待机2";
      
      private var currentName:String = this.nameA;
      
      public function MADaiJi(param1:String)
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         currentFrameNum = 0;
         if(Math.random() * 100 > 40)
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
         if(param1.getFrameLabel() != this.currentName)
         {
            this.enter(param1);
            currentFrameNum = 1;
         }
         return false;
      }
   }
}

