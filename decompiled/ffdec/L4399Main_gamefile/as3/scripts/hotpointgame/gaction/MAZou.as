package hotpointgame.gaction
{
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZtC;
   
   public class MAZou extends CAction
   {
      
      public static var name:String = "移动";
      
      private var _xspeed:VT = VT.createVT(5);
      
      public function MAZou(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.xspeed = (param1.othersvt.xspeed as VT).getValue();
         super.setData(param1);
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
      
      override public function getRunArr(param1:ZtC) : Array
      {
         if(param1.skyType == 0)
         {
            return [this.xspeed * param1.forth * param1.jiansu * param1.bCd.getAddSpeed(),0];
         }
         return [0,0];
      }
      
      public function get xspeed() : int
      {
         return this._xspeed.getValue();
      }
      
      public function set xspeed(param1:int) : void
      {
         this._xspeed.setValue(param1);
      }
   }
}

