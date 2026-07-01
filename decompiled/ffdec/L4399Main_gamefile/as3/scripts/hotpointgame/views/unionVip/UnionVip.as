package hotpointgame.views.unionVip
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.unionVip.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.unionPanel.*;
   
   public class UnionVip extends MovieClip
   {
      
      private static var _instance:UnionVip;
      
      private static var cbx:Number = -1;
      
      private var vipmc:MovieClip;
      
      private var vitBtn:SameChangeBtnX;
      
      private var tbBoxArr:Array = [];
      
      private var lqBtn:ClickBtnX;
      
      private var _sxDisplay:SxPanel;
      
      private var currVip:VT = VT.createVT(GS.a0);
      
      private var vipData:UnVipData;
      
      private var unionData:UnionPanelData;
      
      private var gxArr:Array = [VT.createVT(GS.a0),VT.createVT(GS.a10),VT.createVT(GS.a15),VT.createVT(GS.a22),VT.createVT(GS.a30),VT.createVT(GS.a40),VT.createVT(GS.a55),VT.createVT(GS.a75),VT.createVT(GS.a100)];
      
      private var djvt:VT = VT.createVT(GS.a1200 - GS.a2);
      
      private var djNum:VT = VT.createVT(GS.a1000);
      
      public function UnionVip()
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
               _loc1_.push("unionvipanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadVipOver;
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
      
      public static function loadVipOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ClickBtnX = null;
         var _loc3_:CloseBtnX = null;
         var _loc4_:ClickBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:GoodsBtnX = null;
         var _loc11_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new UnionVip();
            _loc1_ = LoaderManager.getSwfClass("UnionVip") as Class;
            _instance.vipmc = new _loc1_();
            _instance.addChild(_instance.vipmc);
            _instance.vitBtn = SameChangeBtnX.createSameChangeBtn(new Array(new MovieClip(),_instance.vipmc.vb_1,_instance.vipmc.vb_2,_instance.vipmc.vb_3,_instance.vipmc.vb_4,_instance.vipmc.vb_5,_instance.vipmc.vb_6,_instance.vipmc.vb_7,_instance.vipmc.vb_8));
            _instance.vipmc.addChild(_instance.vitBtn);
            _instance.lqBtn = new ClickBtnX(_instance.vipmc.lq_btn,_instance.vipmc.lq_btn.x,_instance.vipmc.lq_btn.y);
            _instance.vipmc.addChild(_instance.lqBtn);
            _loc2_ = new ClickBtnX(_instance.vipmc.cz_btn,_instance.vipmc.cz_btn.x,_instance.vipmc.cz_btn.y);
            _instance.vipmc.addChild(_loc2_);
            _loc3_ = new CloseBtnX(_instance.vipmc.close_btn,_instance.vipmc.close_btn.x,_instance.vipmc.close_btn.y);
            _instance.vipmc.addChild(_loc3_);
            _loc4_ = new ClickBtnX(_instance.vipmc.cz_mc.su_0,_instance.vipmc.cz_mc.su_0.x,_instance.vipmc.cz_mc.su_0.y);
            _instance.vipmc.cz_mc.addChild(_loc4_);
            _loc5_ = new CloseBtnX(_instance.vipmc.cz_mc.sclose_btn,_instance.vipmc.cz_mc.sclose_btn.x,_instance.vipmc.cz_mc.sclose_btn.y);
            _instance.vipmc.cz_mc.addChild(_loc5_);
            _loc6_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc7_ = 0;
            while(_loc7_ < 7)
            {
               _loc9_ = new _loc6_();
               _loc9_.name = "e_" + _loc7_;
               _loc10_ = new GoodsBtnX(_loc9_,_instance.vipmc["tb_" + _loc7_].x,_instance.vipmc["tb_" + _loc7_].y);
               _instance.tbBoxArr.push(_loc10_);
               _instance.vipmc.addChild(_loc10_);
               _loc7_++;
            }
            _instance.vipmc.addChild(_instance.vipmc.cz_mc);
            _loc8_ = _instance.vipmc.sur_mc;
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               _loc11_ = new ClickBtnX(_loc8_["y_" + _loc7_],_loc8_["y_" + _loc7_].x,_loc8_["y_" + _loc7_].y);
               _loc8_.addChild(_loc11_);
               _loc7_++;
            }
            _instance.vipmc.addChild(_loc8_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.vipData = GoodsManger.dataList.uVipData;
         this.unionData = GoodsManger.dataList.unionData;
         this.vipmc.addChild(_instance._sxDisplay);
         this.vipmc.cz_mc.visible = false;
         this.vipmc.sur_mc.visible = false;
         this.visible = true;
         this.addEvent();
         this.initData();
         this.currVip.setValue(this.vipData.getVip());
         this.initFrame(this.currVip.getValue());
         this.vitBtn.btnOk(this.vipData.getVip());
      }
      
      private function initData() : void
      {
         var _loc2_:VT = null;
         var _loc1_:VT = VT.createVT(this.unionData.getGgBl(GS.a6));
         if(this.vipData.getVip() != GS.a0)
         {
            if(this.vipData.getVip() < GS.a8)
            {
               _loc2_ = VT.createVT(UnionVipFactory.getVipById(this.vipData.getVip() + GS.a1).getNeedNum());
               this.vipmc.bossxuetiao1.gotoAndStop(int(_loc1_.getValue() / _loc2_.getValue() * GS.a100));
               this.vipmc.vtext0.text = "再提交" + (_loc2_.getValue() - _loc1_.getValue()) + "荣耀经验,军团即可升级为";
               this.vipmc.vtext1.text = "VIP" + (this.vipData.getVip() + GS.a1);
               this.vipmc.vimc.gotoAndStop(this.vipData.getVip() + GS.a1);
               this.vipmc.vtXX.text = _loc1_.getValue() + "/" + _loc2_.getValue();
            }
            else
            {
               this.vipmc.vtXX.text = String(_loc1_.getValue());
               this.vipmc.bossxuetiao1.gotoAndStop(100);
               this.vipmc.vtext0.text = "";
               this.vipmc.vtext1.text = "";
               this.vipmc.vimc.gotoAndStop(this.vipData.getVip() + GS.a1);
            }
         }
         else
         {
            this.vipmc.vtext0.text = "再提交" + (UnionVipFactory.getVipById(GS.a1).getNeedNum() - _loc1_.getValue()) + "荣耀经验,军团即可升级为";
            this.vipmc.bossxuetiao1.gotoAndStop(int(_loc1_.getValue() / UnionVipFactory.getVipById(GS.a1).getNeedNum() * GS.a100));
            this.vipmc.vtext1.text = "VIP1";
            this.vipmc.vimc.gotoAndStop(1);
            this.vipmc.vtXX.text = "";
         }
      }
      
      private function initFrame(param1:Number) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         this.initMc();
         if(param1 != GS.a0)
         {
            this.vipmc.jsmc.gotoAndStop(param1 + GS.a1);
            _loc2_ = UnionVipFactory.getVipById(param1).getGoodsId();
            _loc3_ = UnionVipFactory.getVipById(param1).getGoodsNum();
            _loc4_ = 0;
            while(_loc4_ < 7)
            {
               if(_loc2_[_loc4_] != null)
               {
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc2_[_loc4_]).getFrame());
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_[_loc4_]);
               }
               _loc4_++;
            }
            if(param1 == this.vipData.getVip())
            {
               if(this.vipData.getEvLq() == GS.a0)
               {
                  this.lqBtn.okBtn = true;
               }
            }
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         Main.self.addEventListener(UnEvent.GET_GG_BL,this.getGGbLHandle);
         Main.self.addEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.addEventListener(UnEvent.DUI_HUANG,this.duihuangHandle);
         Main.self.addEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHandlex);
      }
      
      private function errorHandlex(param1:UnEvent) : void
      {
         DataIngPanel.close();
         GoodsManger.cwTs(String(param1.obj));
      }
      
      private function jtTaskHandlex(param1:UnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            _loc2_ = UnionVipFactory.getVipById(this.vipData.getVip()).getGoodsId();
            _loc3_ = UnionVipFactory.getVipById(this.vipData.getVip()).getGoodsNum();
            BagFactory.addBagArr(_loc2_,_loc3_);
            this.vipData.setEvLq(GS.a1);
            this.lqBtn.okBtn = false;
            GoodsManger.dataList.unionData.addGxValue(this.gxArr[this.currVip.getValue()].getValue());
            GoodsManger.cwTs("VIP:" + this.currVip.getValue() + " 军团增加了" + this.gxArr[this.currVip.getValue()].getValue() + "贡献");
            FlowInterface.saveDataByKai();
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         if(param1.name == "e")
         {
            if(this.currVip.getValue() != GS.a0)
            {
               _loc2_ = UnionVipFactory.getVipById(this.currVip.getValue()).getGoodsId();
               if(_loc2_[param1.id] != null)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,GoodsFactory.createGoodsById(_loc2_[param1.id])));
               }
            }
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
      }
      
      private function initMc() : void
      {
         this.vipmc.jsmc.gotoAndStop(1);
         this.lqBtn.okBtn = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "vb")
         {
            this.currVip.setValue(param1.id);
            this.initFrame(param1.id);
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "sclose")
         {
            this.vipmc.cz_mc.visible = false;
            UnionVip.open();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         if(param1.name == "lq")
         {
            _loc2_ = UnionVipFactory.getVipById(this.vipData.getVip()).getGoodsId();
            _loc3_ = UnionVipFactory.getVipById(this.vipData.getVip()).getGoodsNum();
            _loc4_ = String(UnionVipFactory.getVipById(this.vipData.getVip()).getGx());
            if(BagFactory.isFullBag(_loc2_,_loc3_))
            {
               if(this.vipData.getEvLq() == GS.a0)
               {
                  DataIngPanel.open("领取中...");
                  GM.testapi.overTask(_loc4_);
               }
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
         else if(param1.name == "cz")
         {
            this.vipmc.cz_mc.visible = true;
            this.vipmc.cz_mc.dj_tx.text = String(FlowInterface.getDianJuanByRole());
         }
         else if(param1.name == "su")
         {
            this.vipmc.sur_mc.visible = true;
         }
         else if(param1.name == "y")
         {
            this.vipmc.sur_mc.visible = false;
            if(param1.id == 0)
            {
               if(FlowInterface.getDianJuanByRole() >= this.djNum.getValue())
               {
                  DataIngPanel.open("点卷扣除中");
                  GM.testapi.changeMoneyByU(this.djNum.getValue());
               }
               else
               {
                  GoodsManger.cwTs("点卷不足");
               }
            }
         }
      }
      
      private function duihuangHandle(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            GoodsManger.dataList.unionData.addGxValue(GS.a1000);
            GM.testapi.changeVarValue(GS.a6);
         }
      }
      
      private function setGblHandle(param1:UnEvent) : void
      {
         var _loc2_:Array = null;
         if(String(param1.obj) == "true")
         {
            this.unionData.setXf(this.unionData.getXf() + GS.a1);
            _loc2_ = this.unionData.getGbId();
            GM.testapi.getVarValue(_loc2_);
         }
      }
      
      private function getGGbLHandle(param1:UnEvent) : void
      {
         GoodsManger.dataList.unionData.setGgBl(param1.obj as Array);
         GoodsManger.dataList.uVipData.setVip(UnionVipFactory.getDataByCz(GoodsManger.dataList.unionData.getGgBl(GS.a6)));
         DataIngPanel.close();
         GoodsManger.cwTs("增加了1000贡献,荣誉增加了1");
         FlowInterface.redDianJuan(this.djNum.getValue());
         this.vipmc.cz_mc.dj_tx.text = String(FlowInterface.getDianJuanByRole());
         FlowInterface.saveDataByKai();
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHandlex);
         Main.self.removeEventListener(UnEvent.DUI_HUANG,this.duihuangHandle);
         Main.self.removeEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbLHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
      }
   }
}

