package hotpointgame.ginit
{
   import flash.display.*;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.*;
   
   public class WaitingJieC
   {
      
      private static var self:WaitingJieC = new WaitingJieC();
      
      private var mc:MovieClip;
      
      private var isupdate:Boolean = true;
      
      public function WaitingJieC()
      {
         super();
         var _loc1_:Class = ClassGet.getClassByName("chushihua");
         this.mc = new _loc1_() as MovieClip;
         this.mc.stop();
         this.mc.x = 19563;
         this.mc.y = 29563;
      }
      
      public static function open() : void
      {
         self.reset();
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.addEventListener(Event.ENTER_FRAME,this.FrameH);
         GM.fone.addChild(this.mc);
      }
      
      public function leave() : void
      {
         this.mc.x = 19563;
         this.mc.y = 29563;
         this.mc.removeEventListener(Event.ENTER_FRAME,this.FrameH);
         GM.fone.removeChild(this.mc);
         this.mc = null;
      }
      
      private function FrameH(param1:Event = null) : void
      {
         if(this.isupdate)
         {
            if(GM.serverDateC != null)
            {
               if(GM.serverDateC.timeIsCorr())
               {
                  this.isupdate = false;
                  this.leave();
                  GM.enterGameInitc();
               }
               else
               {
                  GM.findCheatMax(GS.a15);
               }
            }
         }
      }
   }
}

