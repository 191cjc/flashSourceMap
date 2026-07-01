package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class CASkillOneHiWom extends CASkillOneHi
   {
      
      public function CASkillOneHiWom(param1:String)
      {
         super(param1);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(param1.getFrameLabel() != flaFrameName)
         {
            return true;
         }
         if(param1.skyType == 0)
         {
            return true;
         }
         return false;
      }
   }
}

