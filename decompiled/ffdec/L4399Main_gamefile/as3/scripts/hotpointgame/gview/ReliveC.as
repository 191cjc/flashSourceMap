package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class ReliveC
   {
      
      private static var self:ReliveC = new ReliveC();
      
      private var mc:MovieClip;
      
      private var zawuxzkczMC:MovieClip;
      
      private var zawuqwczMC:MovieClip;
      
      private var zawuxzfhMC:MovieClip;
      
      private var zawutsfhMC:MovieClip;
      
      private var fuhuodaojishiMC:MovieClip;
      
      private var scqwczanBtn:McBtn;
      
      private var sctokBtn:McBtn;
      
      private var _curs:VT = VT.createVT(0);
      
      public function ReliveC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(self.curs == 0)
         {
            self.reset();
            self.curs = GS.a1;
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc1_:Class = LoaderManager.getSwfClass("fuhuojiemian") as Class;
         this.mc = new _loc1_() as MovieClip;
         this.mc.stop();
         this.mc.x = 0;
         this.mc.y = 0;
         this.zawuxzkczMC = this.mc["zawuxzkcz"];
         this.zawuqwczMC = this.mc["zawuqwcz"];
         this.zawuxzfhMC = this.mc["zawuxzfh"];
         this.zawutsfhMC = this.mc["zawutsfh"];
         this.fuhuodaojishiMC = this.mc["fuhuodaojishi"];
         this.fuhuodaojishiMC.gotoAndPlay(1);
         if(BagFactory.getFhbNum() > 0)
         {
            this.zawuxzkczMC.visible = false;
            this.zawuqwczMC.visible = false;
            this.zawuxzfhMC.visible = false;
            this.zawutsfhMC.visible = true;
            (this.zawutsfhMC["fuhuobishuliang"] as TextField).text = " * " + BagFactory.getFhbNum();
         }
         else if(GameShangChengC.self.dgMoney >= GS.a100)
         {
            this.zawuxzkczMC.visible = false;
            this.zawuqwczMC.visible = false;
            this.zawuxzfhMC.visible = true;
            this.zawutsfhMC.visible = false;
            (this.zawuxzfhMC["zawuxingzs"] as TextField).text = " * " + GameShangChengC.self.dgMoney;
         }
         else
         {
            this.zawuxzkczMC.visible = false;
            this.zawuqwczMC.visible = true;
            this.zawuxzfhMC.visible = false;
            this.zawutsfhMC.visible = false;
         }
         this.scqwczanBtn = new McBtn(this.zawuqwczMC["scqwczan"]);
         this.sctokBtn = new McBtn(this.zawuqwczMC["sctok"]);
         this.zawuqwczMC.addEventListener(MouseEvent.CLICK,this.zawuqwczClick);
         this.mc.addEventListener(Event.ENTER_FRAME,this.frameH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(this.curs == GS.a1)
         {
            this.curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.zawuqwczMC.removeEventListener(MouseEvent.CLICK,this.zawuqwczClick);
            this.zawuxzkczMC = null;
            this.zawuqwczMC = null;
            this.zawuxzfhMC = null;
            this.zawutsfhMC = null;
            this.fuhuodaojishiMC = null;
            this.scqwczanBtn.remove();
            this.sctokBtn.remove();
            this.scqwczanBtn = null;
            this.sctokBtn = null;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function frameH(param1:Event) : void
      {
         if(this.zawuxzkczMC.visible)
         {
            return;
         }
         if(this.zawutsfhMC.visible)
         {
            if(GM.ckey.isKey("复活"))
            {
               if(GS.a9998 == GM.levelm.curLevel.id)
               {
                  GoodsManger.cwTs("竞技场不可以使用复活!");
                  return;
               }
               if(GS.a9997 == GM.levelm.curLevel.id)
               {
                  GoodsManger.cwTs("挑战塔不可以使用复活!");
                  return;
               }
               if(BagFactory.otherBag.deleteGoods(GS.a511032,GS.a1))
               {
                  this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
                  this.leave();
                  GM.cp.playerStateFull();
               }
               else if(BagFactory.otherBag.deleteGoods(GS.a631000,GS.a1))
               {
                  this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
                  this.leave();
                  GM.cp.playerStateFull();
               }
               else
               {
                  GM.findCheatMax(GS.a46);
               }
               return;
            }
         }
         if(Boolean(this.zawuxzfhMC.visible) && this.fuhuodaojishiMC.totalFrames - this.fuhuodaojishiMC.currentFrame > GS.a30)
         {
            if(GM.ckey.isKey("复活"))
            {
               if(GS.a9998 == GM.levelm.curLevel.id)
               {
                  GoodsManger.cwTs("竞技场不可以使用复活!");
                  return;
               }
               if(GS.a9997 == GM.levelm.curLevel.id)
               {
                  GoodsManger.cwTs("挑战塔不可以使用复活!");
                  return;
               }
               this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
               this.fuhuodaojishiMC.stop();
               this.zawuxzkczMC.visible = true;
               GM.testapi.getStateAndBuyShopProp(GS.a269,GS.a1,GS.a100,this.buyShopOver,GS.a0);
               return;
            }
         }
         if(this.fuhuodaojishiMC.currentFrame == this.fuhuodaojishiMC.totalFrames)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
            this.fuhuodaojishiMC.stop();
            this.leave();
            GameFailC.open();
         }
      }
      
      private function buyShopOver(param1:int) : void
      {
         if(this.zawuxzkczMC.visible)
         {
            if(param1 == 0)
            {
               this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
               this.fuhuodaojishiMC.stop();
               this.leave();
               GameFailC.open();
            }
            else
            {
               this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
               this.leave();
               GM.cp.playerStateFull();
            }
            return;
         }
         GM.findCheatMax(GS.a47);
      }
      
      private function zawuqwczClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null)
         {
            if(param1.target.name == "scqwczan")
            {
               GM.testapi.gameChongMoney(GS.a100);
               this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
               this.fuhuodaojishiMC.stop();
               this.leave();
               GameFailC.open();
               return;
            }
            if(param1.target.name == "sctok")
            {
               this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
               this.fuhuodaojishiMC.stop();
               this.leave();
               GameFailC.open();
               return;
            }
         }
      }
      
      public function get curs() : int
      {
         return this._curs.getValue();
      }
      
      public function set curs(param1:int) : void
      {
         this._curs.setValue(param1);
      }
   }
}

