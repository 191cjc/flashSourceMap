package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class CAbeida extends CAction
   {
      
      public function CAbeida(param1:String)
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         param1.gotoAndStopFrame(flaFrameName);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         return false;
      }
   }
}

