package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.ginit.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GChatC
   {
      
      public static var self:GChatC = new GChatC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var fuckMc:MovieClip;
      
      private var t:TextField;
      
      private var mcMO:Object = new Object();
      
      private var chatT:uint = 0;
      
      private var chatMax:int = 45;
      
      private var pageLine:int = 7;
      
      private var showMaxLine:int = 70;
      
      private var delLine:int = 20;
      
      public function GChatC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc2_:Class = null;
         var _loc3_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("j_xuanfu"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("j_xuanfu");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("j_liaotian") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["fuck"]["srwb"] as TextField).text = "";
         this.fuckMc = this.mc["fuck"];
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.fuckMc["enter"]));
         _loc1_.addBtnLianDong(new McBtn(this.fuckMc["up"]));
         _loc1_.addBtnLianDong(new McBtn(this.fuckMc["down1"]));
         _loc1_.addBtnLianDong(new McBtn(this.fuckMc["down2"]));
         this.mcMO["fuckMo"] = _loc1_;
         this.t = this.mc["pfwb"] as TextField;
         this.t.htmlText = "";
         this.fuckMc.addEventListener(MouseEvent.CLICK,this.mcClick);
         this.mc.addEventListener(Event.ENTER_FRAME,this.frameH);
         GM.cb.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.t = null;
            (this.mcMO["fuckMo"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.fuckMc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
            this.fuckMc = null;
            GM.cb.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      public function addChat(param1:String) : void
      {
         var _loc2_:int = 0;
         if(curs == 1)
         {
            this.t.htmlText += param1;
            if(this.t.numLines > this.showMaxLine)
            {
               _loc2_ = int(this.t.getLineOffset(this.delLine));
               this.t.replaceText(0,_loc2_,"");
            }
            if(this.t.numLines > this.pageLine)
            {
               this.t.scrollV = this.t.numLines - this.pageLine + 1;
            }
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["fuckMo"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            switch(param1.target.name)
            {
               case "enter":
                  this.chatFocusF();
                  break;
               case "up":
                  if(this.t.numLines > this.pageLine && this.t.scrollV > 1)
                  {
                     _loc3_ = this.t.scrollV - this.pageLine;
                     if(_loc3_ > 1)
                     {
                        this.t.scrollV = _loc3_;
                     }
                     else
                     {
                        this.t.scrollV = 1;
                     }
                  }
                  break;
               case "down1":
                  if(this.t.numLines > this.pageLine && this.t.bottomScrollV < this.t.numLines)
                  {
                     _loc4_ = this.t.scrollV + this.pageLine;
                     if(_loc4_ >= this.t.numLines - this.pageLine + 1)
                     {
                        this.t.scrollV = this.t.numLines - this.pageLine + 1;
                     }
                     else
                     {
                        this.t.scrollV = _loc4_;
                     }
                  }
                  break;
               case "down2":
                  if(this.t.numLines > this.pageLine)
                  {
                     this.t.scrollV = this.t.numLines - this.pageLine + 1;
                  }
            }
         }
      }
      
      private function frameH(param1:Event) : void
      {
         if(curs == 1)
         {
            if(GM.ckey.isKey("聊天"))
            {
               this.chatFocusF();
            }
         }
      }
      
      private function chatFocusF() : void
      {
         if(Main.sg.focus != this.mc["fuck"]["srwb"])
         {
            Main.sg.focus = this.mc["fuck"]["srwb"];
         }
         else
         {
            if((this.mc["fuck"]["srwb"] as TextField).text != "")
            {
               if(GM.frameTime - this.chatT > this.chatMax)
               {
                  this.chatT = GM.frameTime;
                  GM.onlineM.fChat("" + GM.testapi.userName + ": " + (this.mc["fuck"]["srwb"] as TextField).text);
                  (this.mc["fuck"]["srwb"] as TextField).htmlText = "";
                  (this.mc["fuck"]["srwb"] as TextField).text = "";
               }
               else
               {
                  GoodsManger.cwTs("休息一会会.....");
               }
            }
            Main.sg.focus = Main.self;
         }
      }
   }
}

