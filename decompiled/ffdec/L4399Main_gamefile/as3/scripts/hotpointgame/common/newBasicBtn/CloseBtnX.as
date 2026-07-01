package hotpointgame.common.newBasicBtn
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import hotpointgame.common.event.*;
   import hotpointgame.utils.gsound.*;
   
   public class CloseBtnX extends BasicBtnX
   {
      
      public function CloseBtnX(param1:MovieClip, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override protected function clickFn(param1:MouseEvent) : void
      {
         SoundManager.playOnlySound("mp_anniu");
         this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLOSE,this._id,this._name));
         param1.updateAfterEvent();
      }
   }
}

