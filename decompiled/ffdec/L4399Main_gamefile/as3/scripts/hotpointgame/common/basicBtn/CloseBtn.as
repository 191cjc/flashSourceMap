package hotpointgame.common.basicBtn
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import hotpointgame.common.event.*;
   import hotpointgame.utils.gsound.*;
   
   public class CloseBtn extends BasicBtn
   {
      
      public function CloseBtn(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function clickFn(param1:MouseEvent) : void
      {
         SoundManager.playOnlySound("mp_anniu");
         this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLOSE,this._id,this._name));
         param1.updateAfterEvent();
      }
   }
}

