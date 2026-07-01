package hotpointgame.views.vipPanel
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.vip.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class VipPanel extends MovieClip
   {
      
      private static var _instance:VipPanel;
      
      private static var cbx:Number = -1;
      
      private var vipmc:MovieClip;
      
      private var vitBtn:SameChangeBtnX;
      
      private var tbBoxArr:Array = [];
      
      private var lqBtn:ClickBtnX;
      
      private var _sxDisplay:SxPanel;
      
      private var currVip:VT = VT.createVT(GS.a0);
      
      public function VipPanel()
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
               _loc1_.push("vippanel");
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
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new VipPanel();
            _loc1_ = LoaderManager.getSwfClass("Vip") as Class;
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
            _loc4_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc5_ = 0;
            while(_loc5_ < 7)
            {
               _loc6_ = new _loc4_();
               _loc6_.name = "e_" + _loc5_;
               _loc7_ = new GoodsBtnX(_loc6_,_instance.vipmc["tb_" + _loc5_].x,_instance.vipmc["tb_" + _loc5_].y);
               _instance.tbBoxArr.push(_loc7_);
               _instance.vipmc.addChild(_loc7_);
               _loc5_++;
            }
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.vipmc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.addEvent();
         this.initData();
         this.currVip.setValue(VipData.vip.getValue());
         this.initFrame(this.currVip.getValue());
         this.vitBtn.btnOk(VipData.vip.getValue());
      }
      
      private function initData() : void
      {
         var _loc1_:VT = null;
         var _loc2_:VT = null;
         if(VipData.vip.getValue() != -1)
         {
            if(VipData.vip.getValue() < GS.a8)
            {
               _loc1_ = VT.createVT(GM.testapi.vipChongGod);
               _loc2_ = VT.createVT(VipFactory.getVipById(VipData.vip.getValue() + GS.a1).getNeedXz());
               this.vipmc.bossxuetiao1.gotoAndStop(int(_loc1_.getValue() / _loc2_.getValue() * GS.a100));
               this.vipmc.vtext0.text = "再充值" + (_loc2_.getValue() - _loc1_.getValue()) + "星钻,即可永久升级为";
               this.vipmc.vtext1.text = "VIP" + (VipData.vip.getValue() + GS.a1);
               this.vipmc.vimc.gotoAndStop(VipData.vip.getValue() + GS.a1);
               this.vipmc.vtXX.text = _loc1_.getValue() + "/" + _loc2_.getValue();
            }
            else
            {
               this.vipmc.vtXX.text = String(GM.testapi.vipChongGod);
               this.vipmc.bossxuetiao1.gotoAndStop(100);
               this.vipmc.vtext0.text = "";
               this.vipmc.vtext1.text = "";
               this.vipmc.vimc.gotoAndStop(VipData.vip.getValue() + GS.a1);
            }
         }
         else
         {
            this.vipmc.vtext0.text = "再充值" + (VipFactory.getVipById(GS.a1).getNeedXz() - GM.testapi.vipChongGod) + "星钻,即可永久升级为";
            this.vipmc.bossxuetiao1.gotoAndStop(int(GM.testapi.vipChongGod / VipFactory.getVipById(GS.a1).getNeedXz() * GS.a100));
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
         if(param1 != -GS.a1)
         {
            this.vipmc.jsmc.gotoAndStop(param1 + GS.a1);
            _loc2_ = VipFactory.getVipById(param1).getjlId();
            _loc3_ = VipFactory.getVipById(param1).getjlNum();
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
            if(param1 == VipData.vip.getValue())
            {
               if(VipData.getEvLq() == GS.a0)
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
         Main.self.addEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHandlex);
      }
      
      private function errorHandlex(param1:UnEvent) : void
      {
         GoodsManger.cwTs(String(param1.obj));
      }
      
      private function jtTaskHandlex(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            if(VipData.vip.getValue() == GS.a7)
            {
               GoodsManger.dataList.unionData.addGxValue(GS.a50);
               GoodsManger.cwTs("军团增加了50贡献");
            }
            else if(VipData.vip.getValue() == GS.a8)
            {
               GoodsManger.dataList.unionData.addGxValue(GS.a100);
               GoodsManger.cwTs("军团增加了100贡献");
            }
            FlowInterface.saveDataByKai();
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         if(param1.name == "e")
         {
            if(this.currVip.getValue() != -1)
            {
               _loc2_ = VipFactory.getVipById(this.currVip.getValue()).getjlId();
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
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(param1.name == "lq")
         {
            _loc2_ = VipFactory.getVipById(VipData.vip.getValue()).getjlId();
            _loc3_ = VipFactory.getVipById(VipData.vip.getValue()).getjlNum();
            if(BagFactory.isFullBag(_loc2_,_loc3_))
            {
               if(VipData.getEvLq() == GS.a0)
               {
                  BagFactory.addBagArr(_loc2_,_loc3_);
                  VipData.setEvLq(GS.a1);
                  this.lqBtn.okBtn = false;
                  FlowInterface.saveDataByKai();
                  if(VipData.vip.getValue() == GS.a7)
                  {
                     GM.testapi.overTask("9");
                  }
                  else if(VipData.vip.getValue() == GS.a8)
                  {
                     GM.testapi.overTask("10");
                  }
               }
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
         if(param1.name == "cz")
         {
            FlowInterface.gotoShopPanel();
         }
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHandlex);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
      }
   }
}

