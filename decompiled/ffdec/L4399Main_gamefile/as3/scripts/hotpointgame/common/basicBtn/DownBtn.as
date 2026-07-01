package hotpointgame.common.basicBtn
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import hotpointgame.common.event.*;
   
   public class DownBtn extends BasicBtn
   {
      
      public function DownBtn(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function downFn(param1:MouseEvent) : void
      {
         _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_DOWN,this._id,this._name));
         param1.updateAfterEvent();
      }
   }
}

