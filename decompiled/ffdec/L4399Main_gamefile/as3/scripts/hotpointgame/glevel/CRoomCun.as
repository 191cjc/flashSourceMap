package hotpointgame.glevel
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gview.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.utils.*;
   import hotpointgame.views.attPanel.*;
   import hotpointgame.views.openBox.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.threePanel.*;
   
   public class CRoomCun extends CRoom
   {
      
      private var mc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      private var isTouch:Boolean = false;
      
      private var isTouchb:Boolean = false;
      
      private var pArr:Array = new Array(6970,7329,135,892);
      
      private var pArrb:Array = new Array(0,250,135,1000);
      
      private var huanjishi:int = 1;
      
      private var huancur:int = 1;
      
      private var huanmax:int = 3;
      
      public function CRoomCun(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         ++this.huanjishi;
         if(this.huanjishi % 95 == 0)
         {
            if(this.huancur >= this.huanmax)
            {
               this.huancur = 1;
            }
            else
            {
               ++this.huancur;
            }
            (this.mc.getChildByName("huanmcplay") as MovieClip).gotoAndStop(this.huancur);
         }
         (this.mc["npcxinasib"] as MovieClip).gotoAndStop(FlowInterface.npcGoto(1));
         (this.mc["npcleikeb"] as MovieClip).gotoAndStop(FlowInterface.npcGoto(3));
         (this.mc["npcailishab"] as MovieClip).gotoAndStop(FlowInterface.npcGoto(2));
         (this.mc["npcmzszb"] as MovieClip).gotoAndStop(FlowInterface.npcGoto(4));
         (this.mc["npcjtzb"] as MovieClip).gotoAndStop(FlowInterface.npcGoto(9));
         if(GM.frameTime - enterT == 30)
         {
            if(GM.skillLvM.hasIsUp())
            {
               (this.mc["npcleikef"] as MovieClip).gotoAndPlay(1);
            }
            if(GM.cp.getZtLevel() >= 4)
            {
               if(FlowInterface.getNewShop())
               {
                  (this.mc["npcailishaf"] as MovieClip).gotoAndPlay(1);
               }
            }
         }
         if(GM.frameTime - enterT == 5)
         {
            GM.onlineM.isHasRoomCun = 0;
            GM.onlineM.fRoleAttUpEnterCun();
            GM.onlineM.fRoleList();
         }
         if(GM.cp.getZx() > this.pArr[0] && GM.cp.getZx() < this.pArr[1] && GM.cp.getZy() > this.pArr[2] && GM.cp.getZy() < this.pArr[3])
         {
            if(!this.isTouch)
            {
               this.isTouch = true;
               CLevelChoose.open();
            }
         }
         else if(this.isTouch)
         {
            this.isTouch = false;
            CLevelChoose.close();
         }
         if(GM.cp.getZx() > this.pArrb[0] && GM.cp.getZx() < this.pArrb[1] && GM.cp.getZy() > this.pArrb[2] && GM.cp.getZy() < this.pArrb[3])
         {
            if(!this.isTouchb)
            {
               this.isTouchb = true;
               if(GM.levelSD.getOverProcess(GS.a12) == -GS.a1)
               {
                  GoodsManger.cwTs("通过裂缝空间20层后，再来试试吧！");
               }
               else
               {
                  ClevelChooseNew.open();
               }
            }
         }
         else if(this.isTouchb)
         {
            this.isTouchb = false;
            ClevelChooseNew.close();
         }
         var _loc2_:int = 1;
         while(_loc2_ < 6)
         {
            (this.mc["wyhuodong" + _loc2_] as MovieClip).visible = GoodsManger.dataList.three.getLv() == _loc2_;
            _loc2_++;
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         Czhujiemian.self.showBtnOnline();
         this.isTouch = false;
         this.isTouchb = false;
         this.mc = param1.getvs().getNpcMc();
         this.mcInit();
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         GOnlineServerC.close();
         GM.onlineM.removeAllR();
         GM.onlineM.fRoleAttUpLeaveCun();
         GM.onlineM.isHasRoomCun = GS.a1;
         Czhujiemian.self.hideBtnOnline();
         this.remove();
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         GOnlineServerC.close();
         GM.onlineM.removeAllR();
         GM.onlineM.fRoleAttUpLeaveCun();
         GM.onlineM.isHasRoomCun = GS.a1;
         Czhujiemian.self.hideBtnOnline();
         this.remove();
         super.exitLevelClear();
      }
      
      private function mcInit() : void
      {
         this.huancur = 1;
         this.huanjishi = 1;
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcxinasi"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcleike"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcailisha"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["jiazaihaibaochuc"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcmzsze"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcyxm"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npclczbld"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["zlphb"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcjxzsaw"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcjtz"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["haidao"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["wyhuodong1"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["wyhuodong2"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["wyhuodong3"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["wyhuodong4"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["wyhuodong5"]));
         var _loc2_:Class = ClassGet.getClassByName("dsfcz");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_.gotoAndStop(1);
         _loc3_.mouseChildren = false;
         _loc3_.mouseEnabled = false;
         _loc3_.name = "huanmcplay";
         _loc3_.x = (this.mc["jiazaihaibaochuc"] as MovieClip).x;
         _loc3_.y = (this.mc["jiazaihaibaochuc"] as MovieClip).y;
         this.mc.addChild(_loc3_);
         this.mcMO["cnpc"] = _loc1_;
         (this.mc["npcleikef"] as MovieClip).gotoAndStop(1);
         (this.mc["npcailishaf"] as MovieClip).gotoAndStop(1);
         if(GM.flagobj.guiwq == 0)
         {
            NpcGuiWuqi.open();
            GM.flagobj.guiwq = 1;
         }
         if(GM.cp.getZtLevel() >= 4)
         {
            if(GM.flagobj.guisp == 0)
            {
               NpcGuiShop.open();
               GM.flagobj.guisp = 1;
            }
            (this.mc["npcailisha"] as MovieClip).visible = true;
            (this.mc["npcailishab"] as MovieClip).visible = true;
            (this.mc["npcailishae"] as MovieClip).visible = true;
         }
         else
         {
            (this.mc["npcailisha"] as MovieClip).visible = false;
            (this.mc["npcailishab"] as MovieClip).visible = false;
            (this.mc["npcailishae"] as MovieClip).visible = false;
         }
         if(GM.levelSD.getOverProcess(GS.a3) != -1)
         {
            if(GM.flagobj.guist == 0)
            {
               NpcGuiStong.open();
               GM.flagobj.guist = 1;
            }
            (this.mc["npcxinasi"] as MovieClip).visible = true;
            (this.mc["npcxinasib"] as MovieClip).visible = true;
            (this.mc["npcxinasie"] as MovieClip).visible = true;
         }
         else
         {
            (this.mc["npcxinasi"] as MovieClip).visible = false;
            (this.mc["npcxinasib"] as MovieClip).visible = false;
            (this.mc["npcxinasie"] as MovieClip).visible = false;
         }
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["cnpc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "npcxinasi":
                  FlowInterface.openDevoJie();
                  break;
               case "npcleike":
                  FlowInterface.openSkillJie();
                  break;
               case "npcailisha":
                  FlowInterface.openShopJie();
                  break;
               case "jiazaihaibaochuc":
                  this.huanForPage();
                  break;
               case "npcmzsze":
                  NpcTaskPanel.open(4);
                  break;
               case "npcjtz":
                  NpcTaskPanel.open(8);
                  break;
               case "haidao":
                  OpenBox.open();
                  break;
               case "wyhuodong1":
                  TreePanel.open();
                  break;
               case "wyhuodong2":
                  TreePanel.open();
                  break;
               case "wyhuodong3":
                  TreePanel.open();
                  break;
               case "wyhuodong4":
                  TreePanel.open();
                  break;
               case "wyhuodong5":
                  TreePanel.open();
                  break;
               case "npcyxm":
                  NpcTaskPanel.open(5);
                  break;
               case "npclczbld":
                  NpcTaskPanel.open(6);
                  break;
               case "zlphb":
                  AttZdlPanel.open();
                  break;
               case "npcjxzsaw":
                  NpcTaskPanel.open(7);
            }
         }
      }
      
      private function huanForPage() : void
      {
         var _loc1_:String = null;
         switch(this.huancur)
         {
            case 1:
               _loc1_ = UTools.updateUrl1;
               break;
            case 2:
               _loc1_ = UTools.updateUrl2;
               break;
            case 3:
               _loc1_ = UTools.updateUrl3;
               break;
            case 4:
               _loc1_ = "http://my.4399.com/forums-thread-tagid-81881-id-35596968.html";
         }
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         navigateToURL(_loc2_,"_blank");
      }
      
      private function remove() : void
      {
         (this.mcMO["cnpc"] as McBtnLianDong).remove();
         this.mcMO = new Object();
         this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
         this.mc = null;
      }
   }
}

