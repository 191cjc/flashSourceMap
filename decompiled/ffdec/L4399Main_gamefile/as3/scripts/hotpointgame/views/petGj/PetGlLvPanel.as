package hotpointgame.views.petGj
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.petGj.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class PetGlLvPanel extends MovieClip
   {
      
      private static var _instance:PetGlLvPanel;
      
      private static var cbx:Number = -1;
      
      public static var state:Number = 0;
      
      private var _sxDisplay:SxPanel;
      
      private var spMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var gsx:GoodsBtnX;
      
      private var gsx1:GoodsBtnX;
      
      public function PetGlLvPanel()
      {
         super();
      }
      
      public static function open(param1:Number) : void
      {
         var _loc2_:Array = null;
         state = param1;
         GoodsManger.allPanelClose();
         if(_instance == null)
         {
            if(GM.loaderM.keYiUse())
            {
               cbx = -1;
               _loc2_ = new Array();
               _loc2_.push("petGj");
               _loc2_.push("sxpanel");
               _loc2_.push("t_box");
               _loc2_.push("ts44");
               GM.loaderM.setLoadData(_loc2_);
               GM.loaderM.completeF = loadWxGtOver;
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
      
      public static function loadWxGtOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:ClickBtnX = null;
         var _loc6_:ClickBtnX = null;
         var _loc7_:CloseBtnX = null;
         var _loc8_:CloseBtnX = null;
         if(cbx == -1)
         {
            _instance = new PetGlLvPanel();
            _loc1_ = LoaderManager.getSwfClass("GjLv") as Class;
            _instance.spMc = new _loc1_();
            _instance.addChild(_instance.spMc);
            _instance.addChild(_instance.centerMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = new _loc2_();
            _loc3_.name = "e_" + 0;
            _instance.gsx = new GoodsBtnX(_loc3_,_instance.spMc.p_0["d_" + 0].x,_instance.spMc.p_0["d_" + 0].y);
            _instance.spMc.p_0.addChild(_instance.gsx);
            _loc4_ = new _loc2_();
            _loc4_.name = "ei_" + 0;
            _instance.gsx1 = new GoodsBtnX(_loc4_,_instance.spMc.p_1["d_" + 0].x,_instance.spMc.p_1["d_" + 0].y);
            _instance.spMc.p_1.addChild(_instance.gsx1);
            _loc5_ = new ClickBtnX(_instance.spMc.p_0.dj_btn,_instance.spMc.p_0.dj_btn.x,_instance.spMc.p_0.dj_btn.y);
            _instance.spMc.p_0.addChild(_loc5_);
            _loc6_ = new ClickBtnX(_instance.spMc.p_1.xl_btn,_instance.spMc.p_1.xl_btn.x,_instance.spMc.p_1.xl_btn.y);
            _instance.spMc.p_1.addChild(_loc6_);
            _loc7_ = new CloseBtnX(_instance.spMc.p_0.djclose_btn,_instance.spMc.p_0.djclose_btn.x,_instance.spMc.p_0.djclose_btn.y);
            _instance.spMc.p_0.addChild(_loc7_);
            _loc8_ = new CloseBtnX(_instance.spMc.p_1.xlclose_btn,_instance.spMc.p_1.xlclose_btn.x,_instance.spMc.p_1.xlclose_btn.y);
            _instance.spMc.p_1.addChild(_loc8_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.centerMc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.initMc();
         this.addEvent();
         this.initPanvs();
      }
      
      private function initPanvs() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            if(_loc1_ == state)
            {
               this.spMc["p_" + _loc1_].visible = true;
            }
            else
            {
               this.spMc["p_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.initFrame(state);
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            this.gsx.getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "ei")
         {
            this.gsx1.getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:PetExpData = null;
         var _loc3_:Goods = null;
         var _loc4_:PetHosData = null;
         if(param1.name == "e")
         {
            _loc2_ = PetGjFactory.getExpDataByLv(PetGjData.getExpLv());
            this.gsx.getSmMc().gx_mc.visible = true;
            _loc3_ = GoodsFactory.createGoodsById(_loc2_.getGsId()[0]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
         }
         else if(param1.name == "ei")
         {
            _loc4_ = PetGjFactory.getHosDataByLv(PetGjData.getPetHosLv());
            this.gsx1.getSmMc().gx_mc.visible = true;
            _loc3_ = GoodsFactory.createGoodsById(_loc4_.getGsId()[0]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "djclose" || param1.name == "xlclose")
         {
            close();
         }
      }
      
      private function sjOk() : void
      {
         GoodsManger.cwTs("宠物培训经验升级成功");
         this.initFrame(0);
      }
      
      private function xlOk() : void
      {
         GoodsManger.cwTs("宠物屋升级成功");
         this.initFrame(1);
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:PetExpData = null;
         var _loc3_:PetHosData = null;
         if(param1.name == "dj")
         {
            if(PetGjData.getExpLv() < PetGjData.expMax.getValue())
            {
               _loc2_ = PetGjFactory.getExpDataByLv(PetGjData.getExpLv());
               if(BagFactory.getNumById(_loc2_.getGsId()[0]) >= _loc2_.getGsNum()[0])
               {
                  if(FlowInterface.getGodByRole() >= _loc2_.getGold())
                  {
                     BagFactory.deteleGoods(_loc2_.getGsId()[0],_loc2_.getGsNum()[0]);
                     FlowInterface.redGodByRole(_loc2_.getGold());
                     PetGjData.addExpLv();
                     GoodsManger.movicpStr(0,0,this.sjOk,"Ts_142");
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("物品不足");
               }
            }
            else
            {
               GoodsManger.cwTs("宠物培训经验等级已满");
            }
         }
         else if(param1.name == "xl")
         {
            _loc3_ = PetGjFactory.getHosDataByLv(PetGjData.getPetHosLv());
            if(PetGjData.getPetHosLv() < PetGjData.hosMax.getValue())
            {
               if(BagFactory.getNumById(_loc3_.getGsId()[0]) >= _loc3_.getGsNum()[0])
               {
                  if(FlowInterface.getGodByRole() >= _loc3_.getGold())
                  {
                     if(GM.aSaveData.pksd.gongScore >= _loc3_.getGx())
                     {
                        BagFactory.deleteArrGoods(_loc3_.getGsId(),_loc3_.getGsNum());
                        FlowInterface.redGodByRole(_loc3_.getGold());
                        GM.aSaveData.pksd.redGong(_loc3_.getGx());
                        PetGjData.addPetHosLv();
                        GoodsManger.movicpStr(0,0,this.xlOk,"Ts_142");
                     }
                     else
                     {
                        GoodsManger.cwTs("功勋不足");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("物品不足");
               }
            }
            else
            {
               GoodsManger.cwTs("宠物屋等级已满");
            }
         }
      }
      
      private function initFrame(param1:Number) : void
      {
         var _loc2_:PetExpData = null;
         var _loc3_:PetExpData = null;
         var _loc4_:PetHosData = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         this.initMc();
         if(param1 == 0)
         {
            _loc2_ = PetGjFactory.getExpDataByLv(PetGjData.getExpLv());
            this.gsx.getSmMc().t_txt.text = String(_loc2_.getGsNum()[0]);
            this.gsx.getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc2_.getGsId()[0]).getFrame());
            this.spMc.p_0.gold_tx.text = String(_loc2_.getGold());
            this.spMc.p_0.xl_tx.text = "每30分钟获得的培训经验提升" + _loc2_.getXg().toFixed(1) + "倍";
            if(PetGjData.getExpLv() < PetGjData.expMax.getValue())
            {
               _loc3_ = PetGjFactory.getExpDataByLv(PetGjData.getExpLv() + GS.a1);
               this.spMc.p_0.nx_tx.text = "每30分钟获得的培训经验提升" + _loc3_.getXg().toFixed(1) + "倍";
            }
            else
            {
               this.spMc.p_0.nx_tx.text = "每30分钟获得的培训经验提升" + _loc2_.getXg().toFixed(1) + "倍";
            }
         }
         else if(param1 == 1)
         {
            _loc4_ = PetGjFactory.getHosDataByLv(PetGjData.getPetHosLv());
            _loc5_ = _loc4_.getGsId();
            _loc6_ = _loc4_.getGsNum();
            this.gsx1.getSmMc().t_txt.text = String(_loc6_[0]);
            this.gsx1.getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc5_[0]).getFrame());
            this.spMc.p_1.gold_tx.text = String(_loc4_.getGold());
            this.spMc.p_1.gx_tx.text = String(_loc4_.getGx());
            this.spMc.p_1.xl_tx.text = String(PetGjData.getPetHosLv());
         }
      }
      
      private function initMc() : void
      {
         this.gsx.getSmMc().visible = true;
         this.gsx.getSmMc().t_txt.text = "";
         this.gsx.getSmMc().gotoAndStop(1);
         this.gsx.getSmMc().mask_mc.gotoAndStop(1);
         this.gsx.getSmMc().gx_mc.visible = false;
         this.gsx.getSmMc().d_mc.visible = false;
         this.gsx1.getSmMc().visible = true;
         this.gsx1.getSmMc().t_txt.text = "";
         this.gsx1.getSmMc().gotoAndStop(1);
         this.gsx1.getSmMc().mask_mc.gotoAndStop(1);
         this.gsx1.getSmMc().gx_mc.visible = false;
         this.gsx1.getSmMc().d_mc.visible = false;
      }
   }
}

