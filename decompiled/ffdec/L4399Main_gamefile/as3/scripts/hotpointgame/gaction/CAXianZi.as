package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZtC;
   
   public class CAXianZi extends CAction
   {
      
      private var fNum:int = 0;
      
      private var stateName:String;
      
      private var cstate:int = 1;
      
      public function CAXianZi(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.stateName = param1.others.stateName;
         this.fNum = param1.others.fNum;
         super.setData(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         this.cstate = 1;
         param1.gotoAndStopFrame(flaFrameName);
         param1.getXiaZhiMc(this.stateName).stop();
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(this.cstate == 1)
         {
            if(param1.zCd.getValueByName(flaFrameName) < this.fNum)
            {
               this.cstate = 2;
               param1.getXiaZhiMc(this.stateName).gotoAndPlay("爆炸");
            }
         }
         if(this.cstate == 2)
         {
            if(param1.zCd.getValueByName(flaFrameName) > this.fNum)
            {
               param1.getXiaZhiMc(this.stateName).gotoAndStop("飞行");
               this.cstate = 1;
            }
         }
         return false;
      }
   }
}

