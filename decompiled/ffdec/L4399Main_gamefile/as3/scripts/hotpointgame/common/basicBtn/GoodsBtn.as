package hotpointgame.common.basicBtn
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.common.event.*;
   
   public class GoodsBtn extends BasicBtn
   {
      
      private var _downBo:Boolean;
      
      private var _moveBo:Boolean;
      
      private var moveNum:Number = 0;
      
      public function GoodsBtn(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function setbuttonMode() : void
      {
         _btnMc.buttonMode = false;
      }
      
      override protected function rollFn(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_OVER,this._id,this._name));
            param1.updateAfterEvent();
         }
         if(param1.type == MouseEvent.ROLL_OUT)
         {
            _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_OUT,this._id,this._name));
            param1.updateAfterEvent();
         }
      }
      
      override protected function downFn(param1:MouseEvent) : void
      {
         this._downBo = true;
         Main.self.addEventListener(MouseEvent.MOUSE_UP,this.upHandle);
         Main.self.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandle);
         _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_DOWN,this._id,this._name));
         param1.updateAfterEvent();
      }
      
      private function moveHandle(param1:MouseEvent) : void
      {
         this._moveBo = true;
         _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_MOUSEMOVE,this._id,this._name));
         param1.updateAfterEvent();
      }
      
      private function upHandle(param1:MouseEvent) : void
      {
         if(Boolean(this._downBo) && !this._moveBo)
         {
            _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_MOUSEUP_ONE,this._id,this._name));
            param1.updateAfterEvent();
         }
         else if(Boolean(this._downBo) && Boolean(this._moveBo))
         {
            _btnMc.dispatchEvent(new BtnEvent(BtnEvent.DO_MOUSEUP_TOW,this._id,this._name));
            param1.updateAfterEvent();
         }
         this._downBo = false;
         this._moveBo = false;
         this.moveNum = 0;
         Main.self.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandle);
         Main.self.removeEventListener(MouseEvent.MOUSE_UP,this.upHandle);
      }
      
      override protected function clickFn(param1:MouseEvent) : void
      {
         this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLICK,this._id,this._name));
         param1.updateAfterEvent();
      }
   }
}

