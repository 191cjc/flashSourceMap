package hotpointgame.common.basicBtn
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import hotpointgame.common.event.*;
   import hotpointgame.utils.gsound.*;
   
   public class SlideChangeBtn extends BasicBtn
   {
      
      public function SlideChangeBtn(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function clickFn(param1:MouseEvent) : void
      {
         _btnMc.gotoAndStop(3);
         SoundManager.playOnlySound("mp_anniu");
         _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_CHANGE,this._id,this._name));
         param1.updateAfterEvent();
      }
   }
}

