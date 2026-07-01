package hotpointgame.views.zenfuPanel
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.vipPanel.*;
   
   public class ZenFuPanel extends MovieClip
   {
      
      private static var _instance:ZenFuPanel;
      
      private static var cbx:Number = -1;
      
      private var state:VT = VT.createVT(0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var zfMc:MovieClip = new MovieClip();
      
      private var typeBtn:SameChangeBtnX;
      
      private var _bagDisplay:BagDisplay;
      
      private var _sxDisplay:SxPanel;
      
      private var slot:Bag;
      
      private var slotBoxArr:Array = [];
      
      private var maxArr:Array = [[1753,44626,8,49098],[1753,44626,8,49098]];
      
      public function ZenFuPanel()
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
               _loc1_.push("zenfuPanel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadWmOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPanel();
      }
      
      private static function loadWmOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:CloseBtnX = null;
         var _loc6_:MovieClip = null;
         var _loc7_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new ZenFuPanel();
            _loc1_ = LoaderManager.getSwfClass("ZF_MC") as Class;
            _instance.zfMc = new _loc1_();
            _loc2_ = _instance.zfMc;
            _instance.addChild(_loc2_);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc3_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               _loc6_ = new _loc3_();
               _loc6_.name = "zf_" + _loc4_;
               _loc7_ = new GoodsBtnX(_loc6_,_loc2_["d_" + _loc4_].x,_loc2_["d_" + _loc4_].y);
               _instance.slotBoxArr.push(_loc7_);
               _loc2_.addChild(_loc7_);
               _loc4_++;
            }
            _instance.typeBtn = SameChangeBtnX.createSameChangeBtn([_loc2_.zfb_0,_loc2_.zfb_1]);
            _loc2_.addChild(_instance.typeBtn);
            _loc5_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc5_);
            _instance._bagDisplay = BagDisplay.createBagDisplay(568.7,93.15);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      public static function close() : void
      {
         cbx = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance._bagDisplay.close();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.state.setValue(GS.a0);
         this.typeBtn.btnOk(GS.a0);
         this.addEvent();
         this.initBag();
         this.initSlot();
         this.initFrame();
      }
      
      private function initSlot() : void
      {
         if(this.state.getValue() == GS.a0)
         {
            this.slot = GoodsManger.dataList.pzfBag;
         }
         else if(this.state.getValue() == GS.a1)
         {
            this.slot = GoodsManger.dataList.cwZfBag;
         }
         this.initData();
      }
      
      private function initData() : void
      {
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:VT = VT.createVT(GS.a0);
         var _loc3_:VT = VT.createVT(GS.a0);
         var _loc4_:VT = VT.createVT(GS.a0);
         if(this.state.getValue() == GS.a0)
         {
            (this.slot as PlayerZfBag).jsSx();
            _loc1_.setValue(Math.floor((this.slot as PlayerZfBag).getHp(GS.a0) + (this.slot as PlayerZfBag).getHp(GS.a0) * (this.slot as PlayerZfBag).getHp(GS.a1)));
            _loc2_.setValue(Math.floor((this.slot as PlayerZfBag).getAtt(GS.a0) + (this.slot as PlayerZfBag).getAtt(GS.a0) * (this.slot as PlayerZfBag).getAtt(GS.a1)));
            _loc3_.setValue(Math.floor((this.slot as PlayerZfBag).getFy(GS.a0) + (this.slot as PlayerZfBag).getFy(GS.a0) * (this.slot as PlayerZfBag).getFy(GS.a1)));
            _loc4_.setValue((this.slot as PlayerZfBag).getBj());
         }
         else if(this.state.getValue() == GS.a1)
         {
            (this.slot as PetZfBag).jsSx();
            _loc1_.setValue(Math.floor((this.slot as PetZfBag).getHp(GS.a0) + (this.slot as PetZfBag).getHp(GS.a0) * (this.slot as PetZfBag).getHp(GS.a1)));
            _loc2_.setValue(Math.floor((this.slot as PetZfBag).getAtt(GS.a0) + (this.slot as PetZfBag).getAtt(GS.a0) * (this.slot as PetZfBag).getAtt(GS.a1)));
            _loc3_.setValue(Math.floor((this.slot as PetZfBag).getFy(GS.a0) + (this.slot as PetZfBag).getFy(GS.a0) * (this.slot as PetZfBag).getFy(GS.a1)));
            _loc4_.setValue((this.slot as PetZfBag).getBj());
         }
         this.zfMc.t_0.text = String(_loc2_.getValue());
         this.zfMc.t_1.text = String(_loc3_.getValue());
         this.zfMc.t_2.text = String(Number(_loc4_.getValue() * GS.a100).toFixed(1) + "%");
         this.zfMc.t_3.text = String(_loc1_.getValue());
         var _loc5_:uint = 0;
         while(_loc5_ < 4)
         {
            (this.zfMc["l_" + _loc5_] as MovieClip).gotoAndStop(1);
            _loc5_++;
         }
         (this.zfMc.l_0 as MovieClip).gotoAndStop(int(_loc2_.getValue() / this.maxArr[this.state.getValue()][0] * GS.a100));
         (this.zfMc.l_1 as MovieClip).gotoAndStop(int(_loc3_.getValue() / this.maxArr[this.state.getValue()][1] * GS.a100));
         (this.zfMc.l_2 as MovieClip).gotoAndStop(int(_loc4_.getValue() * GS.a100 / this.maxArr[this.state.getValue()][2] * GS.a100));
         (this.zfMc.l_3 as MovieClip).gotoAndStop(int(_loc1_.getValue() / this.maxArr[this.state.getValue()][3] * GS.a100));
      }
      
      private function initFrame() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 6)
         {
            (this.slotBoxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            this.zfMc["xs_" + _loc1_].visible = true;
            if(this.slot.getGoods(_loc1_) != null)
            {
               (this.slotBoxArr[_loc1_] as GoodsBtnX).visible = true;
               this.zfMc["xs_" + _loc1_].visible = false;
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(this.slot.getGoods(_loc1_).getFrame());
            }
            _loc1_++;
         }
         BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(GoodsEvent.DO_ZENWEAR,this.zfHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(GoodsEvent.DO_ZENWEAR,this.zfHandle);
      }
      
      private function zfHandle(param1:GoodsEvent) : void
      {
         var _loc2_:Goods = param1.goods;
         var _loc3_:VT = VT.createVT(_loc2_.getSmallType() - GS.a25);
         var _loc4_:VT = VT.createVT(_loc2_.getJob());
         if(_loc4_.getValue() == GS.a5)
         {
            this.state.setValue(GS.a1);
         }
         else
         {
            this.state.setValue(GS.a0);
         }
         this.typeBtn.btnOk(this.state.getValue());
         this.initSlot();
         if(this.slot.getGoods(_loc3_.getValue()) != null)
         {
            BagFactory.addInBagByGoods(this.slot.deleteBagBack(_loc3_.getValue(),GS.a1),1,true);
            this.slot.addToBag(_loc2_,_loc3_.getValue(),GS.a1);
         }
         else
         {
            this.slot.addToBag(_loc2_,_loc3_.getValue(),GS.a1);
         }
         this.initData();
         this.initFrame();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "zf")
         {
            if(BagFactory.isFullBagOnlyOne(this.slot.getGoods(param1.id),GS.a1))
            {
               BagFactory.addInBagByGoods(this.slot.deleteBagBack(param1.id,GS.a1),1,true);
               this.initData();
               this.initFrame();
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "zfb")
         {
            this.state.setValue(param1.id);
            this.initSlot();
            this.initFrame();
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "zf")
         {
            _loc2_ = this.slot.getGoods(param1.id);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "zf")
         {
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function initBag() : void
      {
         this.centerMc.addChild(this._bagDisplay);
         this._bagDisplay.init();
         this._bagDisplay._parentMc = this;
         this._bagDisplay.tbMastMc();
         this.centerMc.addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
   }
}

