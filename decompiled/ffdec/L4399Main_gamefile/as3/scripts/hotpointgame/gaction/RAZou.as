package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class RAZou extends CAction
   {
      
      public static var name:String = "走";
      
      public function RAZou(param1:String = "")
      {
         super(param1);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(param1.getFrameLabel() != flaFrameName)
         {
            enter(param1);
            currentFrameNum = 1;
         }
         return false;
      }
   }
}

