package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class RADeiJi extends CAction
   {
      
      public static var name:String = "待机";
      
      private var nameA:String = "待机1";
      
      private var nameB:String = "待机2";
      
      private var nameC:String = "降落";
      
      private var currentName:String = this.nameA;
      
      private var rateB:int = 20;
      
      public function RADeiJi(param1:String = "")
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         if(param1.skyType == 0)
         {
            if(Math.random() * 100 > this.rateB)
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
         else
         {
            param1.gotoAndPlayFrame(this.nameC);
            this.currentName = this.nameC;
         }
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(param1.skyType == 1 && this.currentName != this.nameC)
         {
            this.enter(param1);
            currentFrameNum = 1;
         }
         else if(param1.skyType == 0 && this.currentName == this.nameC)
         {
            this.enter(param1);
            currentFrameNum = 1;
         }
         if(param1.getFrameLabel() != this.currentName)
         {
            this.enter(param1);
            currentFrameNum = 1;
         }
         return false;
      }
   }
}

