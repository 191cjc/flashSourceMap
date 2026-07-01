package hotpointgame.views.shipPanel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.ship.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.petGj.*;
   import hotpointgame.views.sxPanel.*;
   
   public class ShipWxPanel extends MovieClip
   {
      
      private static var _instance:ShipWxPanel;
      
      private static var cbx:Number = -1;
      
      private var tbBoxArr:Array = [];
      
      private var tbBoxArr1:Array = [];
      
      private var _sxDisplay:SxPanel;
      
      private var spMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      public function ShipWxPanel()
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
               _loc1_.push("shippanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
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
         var _loc3_:uint = 0;
         var _loc4_:ClickBtnX = null;
         var _loc5_:ClickBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:CloseBtnX = null;
         var _loc8_:CloseBtnX = null;
         var _loc9_:ClickBtnX = null;
         var _loc10_:MovieClip = null;
         var _loc11_:GoodsBtnX = null;
         var _loc12_:GoodsBtnX = null;
         var _loc13_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new ShipWxPanel();
            _loc1_ = LoaderManager.getSwfClass("ShipWxMc") as Class;
            _instance.spMc = new _loc1_();
            _instance.addChild(_instance.spMc);
            _instance.addChild(_instance.centerMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               _loc9_ = new ClickBtnX(_instance.spMc.n_0["b_" + _loc3_],_instance.spMc.n_0["b_" + _loc3_].x,_instance.spMc.n_0["b_" + _loc3_].y);
               _instance.spMc.n_0.addChild(_loc9_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 1)
            {
               _loc10_ = new _loc2_();
               _loc10_.name = "e_" + _loc3_;
               _loc11_ = new GoodsBtnX(_loc10_,_instance.spMc.p_0["d_" + _loc3_].x,_instance.spMc.p_0["d_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc11_);
               _instance.spMc.p_0.addChild(_loc11_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc10_ = new _loc2_();
               _loc10_.name = "ei_" + _loc3_;
               _loc12_ = new GoodsBtnX(_loc10_,_instance.spMc.p_1["d_" + _loc3_].x,_instance.spMc.p_1["d_" + _loc3_].y);
               _instance.tbBoxArr1.push(_loc12_);
               _instance.spMc.p_1.addChild(_loc12_);
               _loc3_++;
            }
            _loc4_ = new ClickBtnX(_instance.spMc.p_0.dj_btn,_instance.spMc.p_0.dj_btn.x,_instance.spMc.p_0.dj_btn.y);
            _instance.spMc.p_0.addChild(_loc4_);
            _loc5_ = new ClickBtnX(_instance.spMc.p_1.xl_btn,_instance.spMc.p_1.xl_btn.x,_instance.spMc.p_1.xl_btn.y);
            _instance.spMc.p_1.addChild(_loc5_);
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc13_ = new ClickBtnX(_instance.spMc.p_2["ok_" + _loc3_],_instance.spMc.p_2["ok_" + _loc3_].x,_instance.spMc.p_2["ok_" + _loc3_].y);
               _instance.spMc.p_2.addChild(_loc13_);
               _loc3_++;
            }
            _loc6_ = new CloseBtnX(_instance.spMc.n_0.close_btn,_instance.spMc.n_0.close_btn.x,_instance.spMc.n_0.close_btn.y);
            _instance.spMc.n_0.addChild(_loc6_);
            _loc7_ = new CloseBtnX(_instance.spMc.p_0.djclose_btn,_instance.spMc.p_0.djclose_btn.x,_instance.spMc.p_0.djclose_btn.y);
            _instance.spMc.p_0.addChild(_loc7_);
            _loc8_ = new CloseBtnX(_instance.spMc.p_1.xlclose_btn,_instance.spMc.p_1.xlclose_btn.x,_instance.spMc.p_1.xlclose_btn.y);
            _instance.spMc.p_1.addChild(_loc8_);
            _instance.initTextFun();
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initTextFun() : void
      {
         var _loc1_:MovieClip = this.spMc.p_0;
         _loc1_.lv_tx.embedFonts = true;
         _loc1_.lv_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,17);
         _loc1_.gold_tx.embedFonts = true;
         _loc1_.gold_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
         _loc1_.gx_tx.embedFonts = true;
         _loc1_.gx_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
         var _loc2_:MovieClip = this.spMc.p_1;
         _loc2_.xl_tx.embedFonts = true;
         _loc2_.xl_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,17);
         _loc2_.nx_tx.embedFonts = true;
         _loc2_.nx_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,17);
         _loc2_.gold_tx.embedFonts = true;
         _loc2_.gold_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
         var _loc3_:MovieClip = this.spMc.p_2;
         _loc3_.wxgold_tx.embedFonts = true;
         _loc3_.wxgold_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,17);
         var _loc4_:MovieClip = this.spMc.n_0;
         _loc4_.tl_tx.embedFonts = true;
         _loc4_.tl_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,18);
      }
      
      private function initPanel() : void
      {
         this.centerMc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.initPanvs();
         this.initMc();
         this.addEvent();
      }
      
      private function initPanvs() : void
      {
         this.spMc.n_0.visible = true;
         this.spMc.n_0.tl_tx.text = "(当前耐久度:" + ShipData.nj.getValue() + ")";
         this.spMc.p_0.visible = false;
         this.spMc.p_1.visible = false;
         this.spMc.p_2.visible = false;
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
            (this.tbBoxArr[0] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "ei")
         {
            (this.tbBoxArr1[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:ShipLvBasicData = null;
         var _loc3_:Goods = null;
         var _loc4_:ShipXlBasicData = null;
         if(param1.name == "e")
         {
            _loc2_ = ShipFactory.getDataByLv(ShipData.level.getValue());
            (this.tbBoxArr[0] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            _loc3_ = GoodsFactory.createGoodsById(_loc2_.getGsIdArr()[0]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
         }
         else if(param1.name == "ei")
         {
            _loc4_ = ShipFactory.getDataByShLv(ShipData.xlLevel.getValue());
            (this.tbBoxArr1[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            _loc3_ = GoodsFactory.createGoodsById(_loc4_.getGsIdArr()[param1.id]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "djclose" || param1.name == "xlclose")
         {
            this.initPanvs();
            this.spMc.n_0.visible = false;
         }
      }
      
      private function sjOk() : void
      {
         GoodsManger.cwTs("战舰等级升级成功");
         this.initFrame(0);
      }
      
      private function xlOk() : void
      {
         GoodsManger.cwTs("战舰效率升级成功");
         this.initFrame(1);
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:ShipLvBasicData = null;
         var _loc3_:ShipXlBasicData = null;
         if(param1.name == "b")
         {
            if(param1.id < GS.a3)
            {
               if(param1.id != GS.a2)
               {
                  this.mcVible(param1.id);
                  this.initFrame(param1.id);
               }
               else if(ShipData.nj.getValue() != GS.a100)
               {
                  this.mcVible(param1.id);
                  this.initFrame(param1.id);
               }
               else
               {
                  GoodsManger.cwTs("耐久满,不需要维修!");
               }
            }
            else if(param1.id == 3)
            {
               PetGlLvPanel.open(1);
            }
            else if(param1.id == 4)
            {
               PetGlLvPanel.open(0);
            }
         }
         else if(param1.name == "dj")
         {
            if(ShipData.level.getValue() < ShipData.levelMax.getValue())
            {
               _loc2_ = ShipFactory.getDataByLv(ShipData.level.getValue());
               if(BagFactory.getNumById(_loc2_.getGsIdArr()[0]) >= _loc2_.getGsNumArr()[0])
               {
                  if(FlowInterface.getGodByRole() >= _loc2_.getGold())
                  {
                     if(GM.aSaveData.pksd.gongScore >= _loc2_.getGx())
                     {
                        BagFactory.deteleGoods(_loc2_.getGsIdArr()[0],_loc2_.getGsNumArr()[0]);
                        FlowInterface.redGodByRole(_loc2_.getGold());
                        GM.aSaveData.pksd.redGong(_loc2_.getGx());
                        ShipData.addLv();
                        GoodsManger.movicpStr(0,0,this.sjOk,"Ts_142");
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
               GoodsManger.cwTs("战舰等级已满");
            }
         }
         else if(param1.name == "xl")
         {
            _loc3_ = ShipFactory.getDataByShLv(ShipData.xlLevel.getValue());
            if(ShipData.xlLevel.getValue() < ShipData.xlMx.getValue())
            {
               if(BagFactory.getNumById(_loc3_.getGsIdArr()[0]) >= _loc3_.getGsNumArr()[0] && BagFactory.getNumById(_loc3_.getGsIdArr()[1]) >= _loc3_.getGsNumArr()[1])
               {
                  if(FlowInterface.getGodByRole() >= _loc3_.getGold())
                  {
                     BagFactory.deleteArrGoods(_loc3_.getGsIdArr(),_loc3_.getGsNumArr());
                     FlowInterface.redGodByRole(_loc3_.getGold());
                     ShipData.addXl();
                     GoodsManger.movicpStr(0,0,this.xlOk,"Ts_142");
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
               GoodsManger.cwTs("战舰效率等级已满");
            }
         }
         else if(param1.name == "ok")
         {
            this.initPanvs();
            if(param1.id == GS.a0)
            {
               if(FlowInterface.getGodByRole() >= (GS.a100 - ShipData.nj.getValue()) * GS.a1000 * GS.a2)
               {
                  FlowInterface.redGodByRole((GS.a100 - ShipData.nj.getValue()) * GS.a1000 * GS.a2);
                  ShipData.addNj();
               }
               else
               {
                  GoodsManger.cwTs("晶币不足");
               }
            }
            else if(param1.id == 1)
            {
               this.spMc.n_0.visible = false;
            }
         }
      }
      
      private function initFrame(param1:Number) : void
      {
         var _loc2_:ShipLvBasicData = null;
         var _loc3_:ShipXlBasicData = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:ShipXlBasicData = null;
         this.initMc();
         if(param1 == 0)
         {
            _loc2_ = ShipFactory.getDataByLv(ShipData.level.getValue());
            (this.tbBoxArr[0] as GoodsBtnX).getSmMc().t_txt.text = String(_loc2_.getGsNumArr()[0]);
            (this.tbBoxArr[0] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc2_.getGsIdArr()[0]).getFrame());
            this.spMc.p_0.gold_tx.text = String(_loc2_.getGold());
            this.spMc.p_0.gx_tx.text = String(_loc2_.getGx());
            this.spMc.p_0.lv_tx.text = String(ShipData.level.getValue());
         }
         else if(param1 == 1)
         {
            _loc3_ = ShipFactory.getDataByShLv(ShipData.xlLevel.getValue());
            _loc4_ = _loc3_.getGsIdArr();
            _loc5_ = _loc3_.getGsNumArr();
            _loc6_ = 0;
            while(_loc6_ < 2)
            {
               (this.tbBoxArr1[_loc6_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc5_[_loc6_]);
               (this.tbBoxArr1[_loc6_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc4_[_loc6_]).getFrame());
               _loc6_++;
            }
            this.spMc.p_1.gold_tx.text = String(_loc3_.getGold());
            this.spMc.p_1.xl_tx.text = String("每30分钟扫荡关卡" + _loc3_.getCs() + "次");
            if(ShipData.xlLevel.getValue() < ShipData.xlMx.getValue())
            {
               _loc7_ = ShipFactory.getDataByShLv(ShipData.xlLevel.getValue() + GS.a1);
               this.spMc.p_1.nx_tx.text = String("每30分钟扫荡关卡" + _loc7_.getCs() + "次");
            }
            else
            {
               this.spMc.p_1.nx_tx.text = String("每30分钟扫荡关卡" + _loc3_.getCs() + "次");
            }
         }
         else if(param1 == 2)
         {
            this.spMc.p_2.wxgold_tx.text = String((GS.a100 - ShipData.nj.getValue()) * GS.a1000 * GS.a2);
         }
      }
      
      private function mcVible(param1:Number) : void
      {
         this.spMc.n_0.visible = false;
         var _loc2_:uint = 0;
         while(_loc2_ < 3)
         {
            if(_loc2_ == param1)
            {
               this.spMc["p_" + _loc2_].visible = true;
            }
            else
            {
               this.spMc["p_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private function initMc() : void
      {
         (this.tbBoxArr[0] as GoodsBtnX).getSmMc().t_txt.text = "";
         (this.tbBoxArr[0] as GoodsBtnX).getSmMc().gotoAndStop(1);
         (this.tbBoxArr[0] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
         (this.tbBoxArr[0] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         (this.tbBoxArr[0] as GoodsBtnX).getSmMc().d_mc.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            (this.tbBoxArr1[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr1[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr1[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr1[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr1[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
      }
   }
}

