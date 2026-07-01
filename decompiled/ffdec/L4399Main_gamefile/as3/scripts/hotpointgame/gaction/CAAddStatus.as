package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.CMonster;
   import hotpointgame.gameobj.ZtC;
   
   public class CAAddStatus extends CAction
   {
      
      private var fanum:int;
      
      private var fvalue:Object;
      
      public function CAAddStatus(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.fanum = param1.others.fanum;
         this.fvalue = param1.othersvt;
         super.setData(param1);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Vector.<CMonster> = null;
         var _loc3_:CMonster = null;
         if(currentFrameNum == this.fanum)
         {
            if((this.fvalue.type as VT).getValue() <= GS.a3)
            {
               param1.addSkillStatus(this.fvalue);
            }
            else
            {
               _loc2_ = GM.levelm.getGB();
               for each(_loc3_ in _loc2_)
               {
                  if(_loc3_.bhitTestByObject(param1.getAhit()))
                  {
                     _loc3_.addSkillStatus(this.fvalue);
                  }
               }
            }
         }
      }
   }
}

