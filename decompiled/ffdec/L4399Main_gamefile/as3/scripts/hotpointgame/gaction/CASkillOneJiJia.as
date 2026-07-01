package hotpointgame.gaction
{
   import hotpointgame.common.*;
   
   public class CASkillOneJiJia extends CASkillOne
   {
      
      private var stopfn:int = 0;
      
      public function CASkillOneJiJia(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.stopfn = param1.others.tingzhi;
         super.setData(param1);
      }
      
      override public function useKeyDaDuan() : int
      {
         if(currentFrameNum > this.stopfn)
         {
            return ActionConstant.KeyDaDuanYB;
         }
         return ActionConstant.KeyDaDuanYA;
      }
   }
}

