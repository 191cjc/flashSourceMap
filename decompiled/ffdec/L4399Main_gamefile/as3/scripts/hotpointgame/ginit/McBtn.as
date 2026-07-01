package hotpointgame.ginit
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.utils.gsound.*;
   
   public class McBtn
   {
      
      private var bmc:MovieClip;
      
      private var curstate:int = 1;
      
      private var _bname:String = "";
      
      public function McBtn(param1:MovieClip, param2:int = 1)
      {
         super();
         this.bmc = param1;
         this.bmc.buttonMode = true;
         this.bmc.mouseChildren = false;
         this._bname = param1.name;
         this.curstate = param2;
         this.bmc.gotoAndStop(this.curstate);
         this.bmc.addEventListener(MouseEvent.ROLL_OVER,this.rollOverH);
         this.bmc.addEventListener(MouseEvent.ROLL_OUT,this.rollOutH);
         this.bmc.addEventListener(MouseEvent.CLICK,this.clickH);
      }
      
      private function clickH(param1:MouseEvent) : void
      {
         SoundManager.playOnlySoundByMain("mp_anniua");
      }
      
      private function rollOverH(param1:MouseEvent) : void
      {
         if(this.curstate != 4)
         {
            SoundManager.playOnlySoundByMain("mp_chupenga");
            this.bmc.gotoAndStop(2);
         }
      }
      
      private function rollOutH(param1:MouseEvent) : void
      {
         this.bmc.gotoAndStop(this.curstate);
      }
      
      private function removeStageH(param1:MouseEvent) : void
      {
         if(this.bmc != null)
         {
            this.bmc.removeEventListener(MouseEvent.ROLL_OVER,this.rollOverH);
            this.bmc.removeEventListener(MouseEvent.ROLL_OUT,this.rollOutH);
            this.bmc.removeEventListener(MouseEvent.CLICK,this.clickH);
            this.bmc = null;
         }
      }
      
      public function remove() : void
      {
         this.bmc.removeEventListener(MouseEvent.ROLL_OVER,this.rollOverH);
         this.bmc.removeEventListener(MouseEvent.ROLL_OUT,this.rollOutH);
         this.bmc.removeEventListener(MouseEvent.CLICK,this.clickH);
         this.bmc = null;
      }
      
      public function clickBy() : void
      {
         this.curstate = 3;
         this.bmc.gotoAndStop(this.curstate);
      }
      
      public function clickCancel() : void
      {
         this.curstate = 1;
         this.bmc.gotoAndStop(this.curstate);
      }
      
      public function clickDisable() : void
      {
         this.curstate = 4;
         this.bmc.gotoAndStop(this.curstate);
      }
      
      public function getcurstate() : int
      {
         return this.curstate;
      }
      
      public function get bname() : String
      {
         return this._bname;
      }
   }
}

