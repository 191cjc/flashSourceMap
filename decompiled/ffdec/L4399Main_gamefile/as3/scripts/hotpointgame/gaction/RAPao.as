package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZtC;
   
   public class RAPao extends CAction
   {
      
      public static var name:String = "跑";
      
      private var nameA:String = "跑";
      
      private var nameB:String = "跑2";
      
      private var currentName:String = this.nameA;
      
      public function RAPao(param1:String = "")
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         if(GM.cp.gunslot.getCurrentG() == 1 || FlowInterface.getJobByRole() == GS.a2)
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
            gmUpdate(param1);
         }
         return false;
      }
   }
}

