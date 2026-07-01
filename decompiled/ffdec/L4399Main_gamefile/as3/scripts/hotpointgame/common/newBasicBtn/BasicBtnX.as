package hotpointgame.common.newBasicBtn
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.utils.gsound.*;
   
   public class BasicBtnX extends MovieClip
   {
      
      protected var _id:Number;
      
      protected var _name:String;
      
      protected var _isClick:Boolean;
      
      protected var _btnMc:MovieClip;
      
      protected var _okBtn:Boolean = true;
      
      public function BasicBtnX(param1:MovieClip, param2:Number = 0, param3:Number = 0)
      {
         super();
         this._btnMc = param1;
         this._btnMc.gotoAndStop(1);
         this._btnMc.focusRect = false;
         this._btnMc.mouseChildren = false;
         this._btnMc.x = param2;
         this._btnMc.y = param3;
         addChild(this._btnMc);
         this.init();
         this.setbuttonMode();
         this.addEvent();
      }
      
      public function getSmMc() : MovieClip
      {
         return this._btnMc;
      }
      
      protected function addEvent() : void
      {
         this._btnMc.addEventListener(MouseEvent.ROLL_OUT,this.rollFn,false,0,true);
         this._btnMc.addEventListener(MouseEvent.ROLL_OVER,this.rollFn,false,0,true);
         this._btnMc.addEventListener(MouseEvent.CLICK,this.clickFn,false,0,true);
         this._btnMc.addEventListener(MouseEvent.MOUSE_DOWN,this.downFn,false,0,true);
      }
      
      protected function removeEvent() : void
      {
         this._btnMc.removeEventListener(MouseEvent.ROLL_OUT,this.rollFn);
         this._btnMc.removeEventListener(MouseEvent.ROLL_OVER,this.rollFn);
         this._btnMc.removeEventListener(MouseEvent.CLICK,this.clickFn);
         this._btnMc.removeEventListener(MouseEvent.MOUSE_DOWN,this.downFn);
      }
      
      protected function setbuttonMode() : void
      {
         this._btnMc.buttonMode = true;
      }
      
      public function set isClick(param1:Boolean) : void
      {
         this._isClick = param1;
         if(this._okBtn)
         {
            if(!this._isClick)
            {
               return this._btnMc.gotoAndStop(1);
            }
            if(this._isClick)
            {
               return this._btnMc.gotoAndStop(3);
            }
         }
      }
      
      public function set okBtn(param1:Boolean) : void
      {
         this._okBtn = param1;
         if(this._okBtn)
         {
            this.addEvent();
            this.setbuttonMode();
            if(!this._isClick)
            {
               this._btnMc.gotoAndStop(1);
            }
            else
            {
               this._btnMc.gotoAndStop(3);
            }
         }
         else
         {
            this.removeEvent();
            this._btnMc.buttonMode = false;
            this._btnMc.gotoAndStop(4);
         }
      }
      
      public function get okBtn() : Boolean
      {
         return this._okBtn;
      }
      
      public function getIsClick() : Boolean
      {
         return this._isClick;
      }
      
      private function init() : void
      {
         this._id = parseInt(this._btnMc.name.substring(this._btnMc.name.lastIndexOf("_") + 1,this._btnMc.name.length));
         this._name = this._btnMc.name.substring(0,this._btnMc.name.lastIndexOf("_"));
      }
      
      protected function rollFn(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OUT && this._isClick == false)
         {
            this._btnMc.gotoAndStop(1);
         }
         if(param1.type == MouseEvent.ROLL_OUT && this._isClick == true)
         {
            this._btnMc.gotoAndStop(3);
         }
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            this._btnMc.gotoAndStop(2);
            SoundManager.addOnlySound("mp_chupeng");
         }
         param1.updateAfterEvent();
      }
      
      protected function clickFn(param1:MouseEvent) : void
      {
      }
      
      protected function downFn(param1:MouseEvent) : void
      {
      }
   }
}

