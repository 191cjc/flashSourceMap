package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class RABuGei extends CAction
   {
      
      private var bfvalue:int;
      
      public function RABuGei(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bfvalue = param1.bfvalue;
         super.setData(param1);
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         if(currentFrameNum == this.bfvalue)
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.bhitTestByObject(param1.getAhit()))
               {
                  GM.levelm.addChangeGroup(_loc3_);
                  return;
               }
            }
         }
      }
   }
}

