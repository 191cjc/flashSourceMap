package hotpointgame.views.everyDayPanel
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.everyDay.EveryDay;
   import hotpointgame.repository.everyDay.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.attPanel.*;
   import hotpointgame.views.chongwu.*;
   import hotpointgame.views.comPanel.*;
   import hotpointgame.views.onLineJl.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.shopPanel.*;
   import hotpointgame.views.signPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.wmdPanel.*;
   
   public class EveryDayPanel extends MovieClip
   {
      
      private static var _instance:EveryDayPanel;
      
      private static var cbx:Number = -1;
      
      private var evmc:MovieClip;
      
      private var ye:VT = VT.createVT(GS.a1);
      
      private var btnArr:Array = [];
      
      private var lqBtnArr:Array = [];
      
      private var allBl:VT = VT.createVT(GS.a105);
      
      private var txF:TextField;
      
      private var data:EveryDayData;
      
      public function EveryDayPanel()
      {
         super();
      }
      
      public static function open() : void
      {
         var _loc1_:Array = null;
         GoodsManger.allPanelClose();
         if(_instance == null)
         {
            if(GM.loaderM.keYiUse())
            {
               cbx = -1;
               _loc1_ = new Array();
               _loc1_.push("everydaypanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadEvOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPanel();
      }
      
      public static function close() : void
      {
         cbx = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      public static function loadEvOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:CloseBtnX = null;
         var _loc4_:ClickBtnX = null;
         var _loc5_:ClickBtnX = null;
         var _loc6_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new EveryDayPanel();
            _loc1_ = LoaderManager.getSwfClass("EveryDay") as Class;
            _instance.evmc = new _loc1_();
            _instance.addChild(_instance.evmc);
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc4_ = new ClickBtnX(_instance.evmc["b_" + _loc2_],_instance.evmc["b_" + _loc2_].x,_instance.evmc["b_" + _loc2_].y);
               _instance.evmc.addChild(_loc4_);
               _instance.btnArr.push(_loc4_);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               _loc5_ = new ClickBtnX(_instance.evmc["lq_" + _loc2_],_instance.evmc["lq_" + _loc2_].x,_instance.evmc["lq_" + _loc2_].y);
               _instance.evmc.addChild(_loc5_);
               _instance.lqBtnArr[_loc2_] = _loc5_;
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ <= 1)
            {
               _loc6_ = new ClickBtnX(_instance.evmc["jt_" + _loc2_],_instance.evmc["jt_" + _loc2_].x,_instance.evmc["jt_" + _loc2_].y);
               _instance.evmc.addChild(_loc6_);
               _loc2_++;
            }
            _loc3_ = new CloseBtnX(_instance.evmc.close_btn,_instance.evmc.close_btn.x,_instance.evmc.close_btn.y);
            _instance.evmc.addChild(_loc3_);
            _instance.evmc.addChild(_instance.evmc.ts_mc);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.data = GoodsManger.dataList.evData;
         this.visible = true;
         this.evmc.ts_mc.visible = false;
         this.addEvent();
         this.initFrame();
         this.initAllFs();
      }
      
      private function initAllFs() : void
      {
         this.data.getAllFs();
         this.evmc.loadMc.gotoAndStop(int(this.data.getFs() / this.allBl.getValue() * GS.a100));
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            if(this.data.getLq(_loc1_) == GS.a0)
            {
               this.lqBtnArr[_loc1_].okBtn = true;
            }
            else if(this.data.getLq(_loc1_) == GS.a1)
            {
               this.lqBtnArr[_loc1_].okBtn = false;
            }
            _loc1_++;
         }
      }
      
      private function initFrame() : void
      {
         var _loc3_:EveryDay = null;
         var _loc1_:Array = this.data.getCurrEvList(this.ye.getValue());
         var _loc2_:uint = 0;
         while(_loc2_ < 8)
         {
            _loc3_ = this.data.getDataByKey(_loc2_);
            if(_loc3_ != null)
            {
               this.evmc["mc_" + _loc2_].name_tx.text = _loc3_.getName();
               this.evmc["mc_" + _loc2_].jd_tx.text = _loc3_.getJd() + "/" + _loc3_.getAllNum();
               (this.btnArr[_loc2_] as ClickBtnX).visible = true;
               this.evmc["mc_" + _loc2_].fs_tx.text = String(_loc3_.getCurrFs());
               if(_loc3_.isOk())
               {
                  (this.btnArr[_loc2_] as ClickBtnX).getSmMc().b_tx.text = "已完成";
                  (this.btnArr[_loc2_] as ClickBtnX).okBtn = false;
               }
               else
               {
                  (this.btnArr[_loc2_] as ClickBtnX).getSmMc().b_tx.text = "前去完成";
                  (this.btnArr[_loc2_] as ClickBtnX).okBtn = true;
               }
            }
            else
            {
               this.evmc["mc_" + _loc2_].name_tx.text = "";
               this.evmc["mc_" + _loc2_].jd_tx.text = "";
               this.evmc["mc_" + _loc2_].fs_tx.text = "";
               (this.btnArr[_loc2_] as ClickBtnX).visible = false;
            }
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "lq")
         {
            this.evmc.ts_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:EveryDayJl = null;
         if(param1.name == "lq")
         {
            _loc2_ = EveryDayFactory.getJlByFs(TaskData.getJd(),this.data.getBtnFs(param1.id));
            this.evmc.ts_mc.visible = true;
            this.evmc.ts_mc.liwutx.text = _loc2_.getJlName();
            this.evmc.ts_mc.x = mouseX;
            this.evmc.ts_mc.y = mouseY;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:EveryDayJl = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(param1.name == "jt")
         {
            if(param1.id == 0)
            {
               if(this.ye.getValue() > GS.a1)
               {
                  this.ye.setValue(this.ye.getValue() - GS.a1);
               }
               else
               {
                  this.ye.setValue(this.data.getAllYe());
               }
            }
            else if(param1.id == 1)
            {
               if(this.ye.getValue() < this.data.getAllYe())
               {
                  this.ye.setValue(this.ye.getValue() + GS.a1);
               }
               else
               {
                  this.ye.setValue(GS.a1);
               }
            }
            this.initFrame();
         }
         else if(param1.name == "b")
         {
            switch(this.data.getDataByKey(param1.id).getType())
            {
               case 0:
                  SignPanel.open();
                  break;
               case 1:
                  NpcTaskPanel.open(GS.a3);
                  break;
               case 2:
                  ShopPanel.open();
                  break;
               case 3:
                  ShopPanel.open();
                  break;
               case 4:
                  CLevelChoose.open();
                  break;
               case 5:
                  Gshiershengxiao.open();
                  break;
               case 6:
                  ActLevelC.open();
                  break;
               case 7:
                  ActLevelC.open();
                  break;
               case 8:
                  AttZdlPanel.open();
                  break;
               case 9:
                  WmdPanel.open();
                  break;
               case 10:
                  if(GM.levelSD.getOverProcess(GS.a9) != -1)
                  {
                     GM.levelm.changeLevelDataByIdAndLs(GS.a9997 - GS.a1,1);
                  }
                  else
                  {
                     GoodsManger.cwTs("获得暗黑之海进入权限才可以进入");
                  }
                  break;
               case 11:
                  OnLinePanel.open();
                  break;
               case 12:
                  Gshiershengxiao.open();
                  break;
               case 13:
                  ChongWuPanel.open();
                  break;
               case 14:
                  UnionPanel.open();
                  break;
               case 15:
                  UnionPanel.open();
                  break;
               case 16:
                  StrengthenPanel.open();
                  break;
               case 17:
                  PlayerBagPanel.open();
                  break;
               case 18:
                  ComPanel.open();
            }
         }
         else if(param1.name == "lq")
         {
            if(this.data.getLq(param1.id) == GS.a0)
            {
               if(this.data.getBtnFs(param1.id) <= this.data.getFs())
               {
                  _loc2_ = EveryDayFactory.getJlByFs(TaskData.getJd(),this.data.getBtnFs(param1.id));
                  _loc3_ = _loc2_.getGoodsId();
                  _loc4_ = _loc2_.getGoodsNum();
                  if(BagFactory.isFullBag(_loc3_,_loc4_))
                  {
                     BagFactory.addBagArr(_loc3_,_loc4_);
                     this.data.setLq(param1.id);
                     this.initAllFs();
                     GoodsManger.cwTs("领取成功");
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
               else
               {
                  GoodsManger.cwTs("活跃度不足");
               }
            }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
      }
   }
}

