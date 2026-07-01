package hotpointgame.common.basicBtn
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.common.event.*;
   
   public class OverBtn extends BasicBtn
   {
      
      public function OverBtn(param1:MovieClip)
      {
         super(param1);
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

