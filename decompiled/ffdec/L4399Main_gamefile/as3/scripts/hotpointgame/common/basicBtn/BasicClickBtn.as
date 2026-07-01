package hotpointgame.common.basicBtn
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.common.event.*;
   import hotpointgame.utils.gsound.*;
   
   public class BasicClickBtn extends BasicBtn
   {
      
      public function BasicClickBtn(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function clickFn(param1:MouseEvent) : void
      {
         SoundManager.playOnlySound("mp_anniu");
         this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLICK,this._id,this._name));
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
      
      override protected function downFn(param1:MouseEvent) : void
      {
         _btnMc.gotoAndStop(3);
         param1.updateAfterEvent();
      }
   }
}

