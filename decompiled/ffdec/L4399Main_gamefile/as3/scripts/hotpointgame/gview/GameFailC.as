package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import hotpointgame.Control.*;
   import hotpointgame.ginit.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GameFailC
   {
      
      private static var self:GameFailC = new GameFailC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var s:Sound;
      
      private var sc:SoundChannel;
      
      private var hcbtn:McBtn;
      
      private var conbtn:McBtn;
      
      public function GameFailC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
            curs = 1;
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc1_:String = null;
         var _loc2_:Class = null;
         if(this.mc == null)
         {
            if(FlowInterface.getJobByRole() == 1)
            {
               _loc1_ = "shibaijiemian";
            }
            else
            {
               _loc1_ = "wshibaijiemian";
            }
            _loc2_ = LoaderManager.getSwfClass(_loc1_) as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["shibai"] as MovieClip).gotoAndPlay(1);
         this.s = new (LoaderManager.getSwfClass("mp_wuya"))() as Sound;
         this.sc = this.s.play(0,3);
         GM.cbGview.addChild(this.mc);
         this.hcbtn = new McBtn(this.mc["fanhuijidi"]);
         this.conbtn = new McBtn(this.mc["jixutiaozhan"]);
         this.mc.addEventListener(MouseEvent.CLICK,this.clickH);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.sc.stop();
            this.sc = null;
            this.s = null;
            this.hcbtn.remove();
            this.hcbtn = null;
            this.conbtn.remove();
            this.conbtn = null;
            this.mc.removeEventListener(MouseEvent.CLICK,this.clickH);
            GM.cbGview.removeChild(this.mc);
         }
      }
      
      private function clickH(param1:MouseEvent) : void
      {
         if(param1.target.name != null)
         {
            if(param1.target.name == "fanhuijidi")
            {
               GM.levelm.changeLevelBackCity();
               this.leave();
               return;
            }
            if(param1.target.name == "jixutiaozhan")
            {
               GM.levelm.changeLevelBySelf();
               this.leave();
               return;
            }
         }
      }
   }
}

