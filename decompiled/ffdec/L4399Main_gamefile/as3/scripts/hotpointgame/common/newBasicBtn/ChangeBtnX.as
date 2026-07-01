package hotpointgame.common.newBasicBtn
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.common.event.*;
   import hotpointgame.utils.gsound.*;
   
   public class ChangeBtnX extends BasicBtnX
   {
      
      public function ChangeBtnX(param1:MovieClip, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override protected function clickFn(param1:MouseEvent) : void
      {
         _btnMc.gotoAndStop(3);
         SoundManager.playOnlySound("mp_anniu");
         _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_CHANGE,this._id,this._name));
         param1.updateAfterEvent();
      }
      
      override protected function rollFn(param1:MouseEvent) : void
      {
         super.rollFn(param1);
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            this.dispatchEvent(new BtnEvent(BtnEvent.DO_OVER,this._id,this._name));
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            this.dispatchEvent(new BtnEvent(BtnEvent.DO_OUT,this._id,this._name));
         }
         param1.updateAfterEvent();
      }
   }
}

