package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.ginit.*;
   import hotpointgame.utils.*;
   
   public class ManHuaKaiC
   {
      
      private static var self:ManHuaKaiC = new ManHuaKaiC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var mhMc:MovieClip;
      
      private var manhuaanniuMc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      private var curnum:int = 1;
      
      public function ManHuaKaiC()
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
         var _loc1_:Class = ClassGet.getClassByName("kaichanmanhua");
         this.mc = new _loc1_() as MovieClip;
         this.mhMc = this.mc["manhuadonghua"];
         this.manhuaanniuMc = this.mc["manhuaanniu"];
         var _loc2_:McBtnLianDong = new McBtnLianDong();
         _loc2_.addBtnNoLian(new McBtn(this.manhuaanniuMc["manhuaanniub1"]));
         _loc2_.addBtnNoLian(new McBtn(this.manhuaanniuMc["manhuaanniub2"]));
         _loc2_.addBtnNoLian(new McBtn(this.manhuaanniuMc["manhuaanniub3"]));
         this.mcMO["manhuaanniu"] = _loc2_;
         this.manhuaanniuMc.visible = false;
         this.mc.x = 0;
         this.mc.y = 0;
         this.manhuaanniuMc.addEventListener(MouseEvent.CLICK,this.manhuaanniuMcH);
         this.mc.addEventListener(Event.ENTER_FRAME,this.enterH);
         GM.fone.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.curnum = 1;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["manhuaanniu"] as McBtnLianDong).remove();
            this.manhuaanniuMc.removeEventListener(MouseEvent.CLICK,this.manhuaanniuMcH);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterH);
            this.mcMO = new Object();
            this.mhMc = null;
            this.manhuaanniuMc = null;
            GM.fone.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function enterH(param1:Event) : void
      {
         if(this.mhMc.currentLabel == "man" + this.curnum + "over")
         {
            this.mhMc.stop();
            this.manhuaanniuMc.visible = true;
         }
      }
      
      private function manhuaanniuMcH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["manhuaanniu"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            this.manhuaanniuMc.visible = false;
            if(param1.target.name == "manhuaanniub1")
            {
               if(this.curnum > 1)
               {
                  --this.curnum;
                  this.mhMc.gotoAndPlay("man" + this.curnum);
               }
            }
            if(param1.target.name == "manhuaanniub2")
            {
               if(this.curnum < 7)
               {
                  ++this.curnum;
                  this.mhMc.gotoAndPlay("man" + this.curnum);
               }
               else
               {
                  this.leave();
                  GM.enterCunFlag = false;
                  GM.enterGame();
               }
            }
            if(param1.target.name == "manhuaanniub3")
            {
               this.leave();
               GM.enterCunFlag = false;
               GM.enterGame();
            }
         }
      }
   }
}

