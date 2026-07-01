package hotpointgame.views.strengPanel
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.strengthen.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.taskPanel.*;
   
   public class StrengthenPanel extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      private static var _instance:StrengthenPanel;
      
      private static var bx2:int = 0;
      
      private var _bagDisplay:BagDisplay;
      
      private var _equipSlot:Bag;
      
      private var _strengSlot:StrengthenSlot;
      
      private var _timer:Timer;
      
      private var _timerNum:Number = 0;
      
      private var _timerNum2:Number = 0;
      
      private var _pos:Number = 0;
      
      private var _pos2:Number = 0;
      
      private var _bo1:Boolean;
      
      private var _bo2:Boolean;
      
      private var needGoods:Goods;
      
      private var needId:VT = VT.createVT(0);
      
      private var needNum:VT = VT.createVT(0);
      
      private var proValue:VT = VT.createVT(0);
      
      private var djNum:VT = VT.createVT(0);
      
      private var goldNum:VT = VT.createVT(0);
      
      private var nextSxValue:VT = VT.createVT(0);
      
      private var shopId:VT = VT.createVT(0);
      
      private var _textF:TextFormat;
      
      private var _textF1:TextFormat;
      
      private var typeState:Number = 0;
      
      private var typeBtn:SameChangeBtn;
      
      private var cgoods:Goods;
      
      private var strBo:Boolean;
      
      private var okBtn:BasicBtn;
      
      private var sxDsiplay:SxPanel;
      
      private var czMc:MovieClip;
      
      private var tbBoxArr:Array = [];
      
      private var slotBoxArr:Array = [];
      
      private var closeBtn:CloseBtn;
      
      public function StrengthenPanel()
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
               bx2 = -1;
               _loc1_ = new Array();
               _loc1_.push("strengpanel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadStrOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.visible = true;
         _instance.initPanel();
         _instance.x = 0;
      }
      
      private static function loadStrOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:GoodsBtnX = null;
         var _loc8_:MovieClip = null;
         var _loc9_:GoodsBtnX = null;
         if(bx2 != 0)
         {
            bx2 = 0;
            _loc1_ = LoaderManager.getSwfClass("Streng_Panel") as Class;
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = new _loc1_();
            operatingMc = _loc3_;
            _instance = new StrengthenPanel();
            _instance.addChild(operatingMc);
            GM.bagJm.addChild(_instance);
            _loc4_ = LoaderManager.getSwfClass("Ts_69") as Class;
            _instance.czMc = new _loc4_();
            _instance.addChild(_instance.czMc);
            _loc5_ = 0;
            while(_loc5_ < 7)
            {
               _loc6_ = new _loc2_();
               _loc6_.name = "e_" + _loc5_;
               if(_loc5_ != 3)
               {
                  _loc7_ = new GoodsBtnX(_loc6_,operatingMc["ed_" + _loc5_].x,operatingMc["ed_" + _loc5_].y);
                  _instance.addChild(_loc7_);
               }
               else
               {
                  _loc7_ = new GoodsBtnX(_loc6_);
               }
               _instance.tbBoxArr.push(_loc7_);
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               _loc8_ = new _loc2_();
               _loc8_.name = "s_" + _loc5_;
               _loc9_ = new GoodsBtnX(_loc8_,operatingMc["wp_" + _loc5_].x,operatingMc["wp_" + _loc5_].y);
               _instance.slotBoxArr.push(_loc9_);
               _instance.addChild(_loc9_);
               _loc5_++;
            }
            _instance.initMcBtn();
            _instance._strengSlot = BagFactory.stSlot;
            _instance._bagDisplay = BagDisplay.createBagDisplay(572,93.15);
            _instance.sxDsiplay = SxPanel.createSxpanel();
            _instance.visible = true;
            _instance.x = 0;
            _instance.initPanel();
         }
      }
      
      public static function close() : void
      {
         bx2 = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance._bagDisplay.close();
            _instance.removeData();
            _instance.removeEvent();
            _instance.visible = false;
            _instance.x = 5000;
         }
      }
      
      private function initPanel() : void
      {
         this._textF = new TextFormat();
         this.initBag();
         this._equipSlot = BagFactory.equipSlot;
         this._timer = new Timer(0);
         this.typeState = 0;
         this.addEvent();
         this.bagDisplay();
         this.slotDisplay();
         this.slotTowVisible();
         this.typeStateDisplay();
         (this.slotBoxArr[1] as GoodsBtnX).getSmMc().gotoAndStop(1);
         this.typeBtn.btnOk(0);
         this._textF = new TextFormat();
         this._textF.color = "0xffffff";
         this._textF1 = new TextFormat();
         this._textF1.color = "0xff0000";
         operatingMc.mask_xx.visible = false;
         this._bagDisplay.maskMcDisplay();
         this.okBtn.okBtn = true;
         this.czMc.visible = false;
         this.closeBtn.okBtn = true;
      }
      
      private function initBag() : void
      {
         addChild(this._bagDisplay);
         this._bagDisplay.init();
         this._bagDisplay._parentMc = this;
         this._bagDisplay.tbMastMc();
         addChild(this.sxDsiplay);
         this.sxDsiplay.init();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         addEventListener(GoodsEvent.DO_WEAR,this.goodsHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(GoodsEvent.DO_STRENGTH,this.strengthHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.sameChangeHandle);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function sameChangeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "st")
         {
            this.typeState = param1.id;
         }
         this.slotTowVisible();
         this.typeStateDisplay();
      }
      
      private function typeStateDisplay() : void
      {
         if(this.typeState == 0)
         {
            operatingMc.w_1.visible = true;
            operatingMc.d_mc.visible = true;
            (this.slotBoxArr[1] as GoodsBtnX).visible = true;
            operatingMc.goldMc.gotoAndStop(1);
            operatingMc.xz_mc.visible = false;
            operatingMc.num_mc.visible = true;
         }
         else if(this.typeState == 1)
         {
            operatingMc.w_1.visible = false;
            operatingMc.xz_mc.visible = true;
            operatingMc.xz_mc.x = operatingMc.d_mc.x;
            operatingMc.xz_mc.y = operatingMc.d_mc.y;
            operatingMc.d_mc.visible = false;
            (this.slotBoxArr[1] as GoodsBtnX).visible = false;
            operatingMc.goldMc.gotoAndStop(2);
            operatingMc.num_mc.visible = false;
            operatingMc.num_text.text = "";
            (this.slotBoxArr[1] as GoodsBtnX).getSmMc().gotoAndStop(1);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         removeEventListener(GoodsEvent.DO_WEAR,this.goodsHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(GoodsEvent.DO_STRENGTH,this.strengthHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.sameChangeHandle);
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function removeData() : void
      {
         var _loc1_:Goods = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._strengSlot.getGoods(0) != null)
         {
            _loc1_ = this._strengSlot.getGoods(0);
            _loc2_ = Number(this._strengSlot.getGoodsNum(0));
            _loc3_ = Number(this._strengSlot.getFromType(0));
            this._strengSlot.deleteBag(GS.a0,_loc2_);
            if(_loc3_ == 0)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc1_,-1,0,_loc2_));
            }
            else if(_loc3_ == 1)
            {
               dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc1_));
            }
         }
         this.czMc.visible = false;
         this.cgoods = null;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this._bo1)
         {
            if(this._timerNum < 100)
            {
               ++this._timerNum;
            }
            else
            {
               (this.slotBoxArr[this._pos] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               this._pos = 0;
               this._timerNum = 0;
               this._bo1 = false;
            }
         }
         if(this._bo2)
         {
            if(this._timerNum2 < 100)
            {
               ++this._timerNum2;
            }
            else
            {
               (this.tbBoxArr[this._pos2] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               this._pos2 = 0;
               this._timerNum2 = 0;
               this._bo2 = false;
            }
         }
         if(!this._bo1 && !this._bo2)
         {
            this._timer.stop();
         }
      }
      
      private function strengthHandle(param1:GoodsEvent) : void
      {
         var _loc2_:Goods = param1.goods;
         var _loc3_:Number = param1.goodsNum;
         var _loc4_:Number = param1.typeb;
         var _loc5_:Number = param1.id;
         if(_loc2_.getType() == 0)
         {
            this.initSlotData(0,_loc2_,_loc3_,_loc5_,_loc4_);
         }
         this.slotDisplay();
         this.slotTowVisible();
         this._timerNum = 0;
         this._timer.start();
         this._bo1 = true;
         this._pos = _loc2_.getType();
         this.gxVisible(this._pos);
      }
      
      private function gxVisible(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 2)
         {
            if(_loc2_ == param1)
            {
               (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            }
            else
            {
               (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function initSlotData(param1:Number, param2:Goods, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Goods = null;
         var _loc7_:Number = NaN;
         if(this._strengSlot.getGoods(param1) != null)
         {
            _loc6_ = DeepCopyUtil.clone(this._strengSlot.getGoods(param1));
            _loc7_ = Number(this._strengSlot.getGoodsNum(param1));
            this._strengSlot.deleteBag(param1,_loc7_);
            this._strengSlot.addToBag(param2,param1,param3);
            if(this._strengSlot.getFromType(param1) == 0)
            {
               if(param5 == 0)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc6_,param4,0,_loc7_));
               }
               else
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc6_,-1,0,_loc7_));
               }
            }
            else if(this._strengSlot.getFromType(param1) == 1)
            {
               dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc6_));
            }
            this._strengSlot.setFromType(param1,param5);
         }
         else
         {
            this._strengSlot.addToBag(param2,param1,param3);
            this._strengSlot.setFromType(param1,param5);
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function goldStrOkMv() : void
      {
         GoodsManger.movicpStr(operatingMc.wp_0.x,operatingMc.wp_0.y,this.goldStrOk);
      }
      
      private function goldStrLostMv() : void
      {
         GoodsManger.movicpStr(operatingMc.wp_0.x,operatingMc.wp_0.y,this.goldStrLost);
      }
      
      private function djStrOkMv() : void
      {
         GoodsManger.movicpStr(operatingMc.wp_0.x,operatingMc.wp_0.y,this.djStrOk);
      }
      
      private function djStrLostMv() : void
      {
         GoodsManger.movicpStr(operatingMc.wp_0.x,operatingMc.wp_0.y,this.djStrLost);
      }
      
      private function goldStrOk() : void
      {
         if(this.visible)
         {
            operatingMc.mask_xx.visible = false;
            this.slotTowVisible();
            this._bagDisplay.getGoldTx();
            this._bagDisplay.maskMcDisplay();
            this.okBtn.okBtn = true;
         }
         this.closeBtn.okBtn = true;
         TaskData.isXtOk(0);
         GoodsManger.cwTs("强化成功");
         SoundManager.playOnlySound("mp_productSuccess");
      }
      
      private function goldStrLost() : void
      {
         if(this.visible)
         {
            operatingMc.mask_xx.visible = false;
            this._bagDisplay.getGoldTx();
            this.slotTowVisible();
            this._bagDisplay.maskMcDisplay();
            this.okBtn.okBtn = true;
         }
         this.closeBtn.okBtn = true;
         GoodsManger.cwTs("强化失败");
         SoundManager.playOnlySound("mp_productFai");
      }
      
      private function djStrOk() : void
      {
         if(this.visible)
         {
            operatingMc.mask_xx.visible = false;
            this.okBtn.okBtn = true;
            this._bagDisplay.maskMcDisplay();
            this._bagDisplay.getGoldTx();
            this.slotTowVisible();
            this.okBtn.okBtn = true;
            this._bagDisplay.maskMcDisplay(0);
         }
         this.closeBtn.okBtn = true;
         TaskData.isXtOk(0);
         GoodsManger.cwTs("强化成功");
         SoundManager.playOnlySound("mp_productSuccess");
      }
      
      private function djStrLost() : void
      {
         if(this.visible)
         {
            operatingMc.mask_xx.visible = false;
            this.okBtn.okBtn = true;
            this._bagDisplay.maskMcDisplay();
            this._bagDisplay.getGoldTx();
            this.slotTowVisible();
            this.okBtn.okBtn = true;
            this._bagDisplay.maskMcDisplay(0);
         }
         this.closeBtn.okBtn = true;
         GoodsManger.cwTs("强化失败");
         SoundManager.playOnlySound("mp_productFai");
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Goods = null;
         var _loc4_:Number = NaN;
         if(param1.name == "ok")
         {
            if(param1.id == 0)
            {
               _loc2_ = int(Math.random() * GS.a100);
               if(this._strengSlot.getGoods(0) != null)
               {
                  _loc3_ = this._strengSlot.getGoods(0);
                  _loc4_ = Number(this._strengSlot.getGoodsNum(0));
                  this.cgoods = _loc3_;
                  if(_loc3_.getStrengLevel() < _loc3_.isStrengBo())
                  {
                     if(this.typeState == 0)
                     {
                        if(this.needNum.getValue() <= BagFactory.otherBag.getGoodsNumById(this.needId.getValue()))
                        {
                           if(FlowInterface.getGodByRole() >= this.goldNum.getValue())
                           {
                              SoundManager.playOnlySound("mp_qianghuadonghua");
                              if(_loc2_ <= this.proValue.getValue())
                              {
                                 this.closeBtn.okBtn = false;
                                 BagFactory.otherBag.deleteGoods(this.needId.getValue(),this.needNum.getValue());
                                 FlowInterface.redGodByRole(this.goldNum.getValue());
                                 this.cgoods.changeStreng();
                                 this._strengSlot.bfBag();
                                 if(this._bagDisplay._bagState == 2)
                                 {
                                    this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
                                 }
                                 this.okBtn.okBtn = false;
                                 this._bagDisplay.maskMcDisplay(1);
                                 operatingMc.mask_xx.visible = true;
                                 addChildAt(operatingMc.mask_xx,numChildren - 1);
                                 GoodsManger.dataList.evData.setJd(GS.a16);
                                 FlowInterface.saveDataByKai(this.goldStrOkMv);
                              }
                              else
                              {
                                 this.closeBtn.okBtn = false;
                                 operatingMc.mask_xx.visible = true;
                                 addChildAt(operatingMc.mask_xx,numChildren - 1);
                                 BagFactory.otherBag.deleteGoods(this.needId.getValue(),this.needNum.getValue());
                                 FlowInterface.redGodByRole(this.goldNum.getValue());
                                 if(this._bagDisplay._bagState == 2)
                                 {
                                    this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
                                 }
                                 this.okBtn.okBtn = false;
                                 this._bagDisplay.maskMcDisplay(1);
                                 GoodsManger.dataList.evData.setJd(GS.a16);
                                 FlowInterface.saveDataByKai(this.goldStrLostMv);
                              }
                           }
                           else
                           {
                              GoodsManger.cwTs("晶币不足");
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("太阳碎片不足");
                        }
                     }
                     else if(this.typeState == 1)
                     {
                        this.okBtn.okBtn = false;
                        this.closeBtn.okBtn = false;
                        this._bagDisplay.maskMcDisplay(1);
                        GoodsManger.dataList.evData.setJd(GS.a16);
                        FlowInterface.djGouMai(this.shopId.getValue(),GS.a1,this.djNum.getValue(),this.djGmOk,GS.a0);
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("强化等级已满");
                     if(this._strengSlot.getFromType(0) == 0)
                     {
                        Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc3_,-1));
                     }
                     else if(this._strengSlot.getFromType(0) == 1)
                     {
                        dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc3_));
                     }
                     this._strengSlot.deleteBag(0,_loc4_);
                     this.slotDisplay();
                     this.slotTowVisible();
                  }
               }
            }
         }
         else if(param1.name == "qx")
         {
            operatingMc.zz_mc.visible = false;
         }
         else if(param1.name == "cz")
         {
            FlowInterface.gotoShopPanel();
         }
         else if(param1.name == "sure")
         {
            this.czMc.visible = false;
            this.okBtn.okBtn = true;
         }
      }
      
      private function djGmOk(param1:Number) : void
      {
         var _loc2_:int = 0;
         if(param1 == GS.a1)
         {
            _loc2_ = int(Math.random() * GS.a100);
            SoundManager.playOnlySound("mp_qianghuadonghua");
            if(_loc2_ <= this.proValue.getValue())
            {
               this.cgoods.changeStreng();
               this._strengSlot.bfBag();
               this.okBtn.okBtn = false;
               this._bagDisplay.maskMcDisplay(1);
               operatingMc.mask_xx.visible = true;
               addChildAt(operatingMc.mask_xx,numChildren - 1);
               FlowInterface.saveDataByKaiOnlyShop(this.djStrOkMv);
            }
            else
            {
               this.okBtn.okBtn = false;
               this._bagDisplay.maskMcDisplay(1);
               operatingMc.mask_xx.visible = true;
               addChildAt(operatingMc.mask_xx,numChildren - 1);
               FlowInterface.saveDataByKaiOnlyShop(this.djStrLostMv);
            }
         }
         else
         {
            this.czMc.visible = true;
            addChildAt(this.czMc,numChildren - 1);
            this.okBtn.okBtn = true;
            this.closeBtn.okBtn = true;
         }
      }
      
      private function goodsHandle(param1:GoodsEvent) : void
      {
         var _loc2_:Goods = param1.goods;
         var _loc3_:Number = _loc2_.getSmallType();
         BagFactory.equipSlot.addToBag(_loc2_,_loc3_,GS.a1);
         this.bagDisplay();
         this._timerNum2 = 0;
         this._bo2 = true;
         this._timer.start();
         this._pos2 = _loc3_;
         this.equipSlotGx(_loc3_);
      }
      
      private function equipSlotGx(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 12)
         {
            if(!(_loc2_ == 3 || _loc2_ == 7 || _loc2_ == 8 || _loc2_ == 9 || _loc2_ == 10 || _loc2_ == 11 || _loc2_ == 12 || _loc2_ == 13 || _loc2_ == 14 || _loc2_ == 15))
            {
               if(_loc2_ == param1)
               {
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
               }
               else
               {
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               }
            }
            _loc2_++;
         }
      }
      
      private function wearGoodsHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:Number = NaN;
         if(param1.name == "s")
         {
            if(param1.id == 0)
            {
               _loc2_ = this._strengSlot.getGoods(param1.id);
               _loc3_ = Number(this._strengSlot.getGoodsNum(param1.id));
               if(this._strengSlot.getFromType(param1.id) == 0)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1));
               }
               else if(this._strengSlot.getFromType(param1.id) == 1)
               {
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc2_));
               }
               this._strengSlot.deleteBag(param1.id,_loc3_);
            }
            this.slotDisplay();
            this.slotTowVisible();
         }
         else if(param1.name == "e")
         {
            _loc2_ = this._equipSlot.getGoods(param1.id);
            if(_loc2_.isStrengBo() != -1)
            {
               if(_loc2_.getStrengLevel() < _loc2_.isStrengBo())
               {
                  this._bagDisplay._bagState = 2;
                  this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
                  this._equipSlot.deleteBag(param1.id,GS.a1);
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_STRENGTH,_loc2_,param1.id,1));
                  this._bagDisplay.tbMastMc();
               }
               else
               {
                  GoodsManger.cwTs("强化等级已满");
               }
            }
            else
            {
               GoodsManger.cwTs("物品无法强化");
            }
            this.bagDisplay();
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "s")
         {
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "e")
         {
            _loc2_ = this._equipSlot.getGoods(param1.id);
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         else if(param1.name == "s")
         {
            if(param1.id == 0)
            {
               _loc2_ = this._strengSlot.getGoods(param1.id);
            }
            else
            {
               _loc2_ = this.needGoods;
            }
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         if(_loc2_ != null)
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
         }
      }
      
      private function slotDisplay() : void
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:Array = this._strengSlot.getBagArr();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as Gird;
            _loc4_ = _loc3_.getGoods();
            (this.slotBoxArr[_loc2_] as GoodsBtnX).visible = false;
            (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            if(_loc4_ != null)
            {
               (this.slotBoxArr[_loc2_] as GoodsBtnX).visible = true;
               if(_loc3_.getGoodsNum() > 1)
               {
                  (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
               }
               (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
            }
            _loc2_++;
         }
      }
      
      private function slotTowVisible() : void
      {
         var _loc1_:Goods = null;
         var _loc2_:Number = NaN;
         var _loc3_:VT = null;
         var _loc4_:Number = NaN;
         var _loc5_:VT = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         if(this._strengSlot.getGoods(0) == null)
         {
            (this.slotBoxArr[1] as GoodsBtnX).visible = false;
            (this.slotBoxArr[1] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.slotBoxArr[1] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            operatingMc.name_text.text = "";
            operatingMc.current_text.text = "";
            operatingMc.current_text.text = "";
            operatingMc.next_text.text = "";
            operatingMc.type_text.text = "";
            operatingMc.pro_text.text = "";
            operatingMc.num_text.text = "";
            operatingMc.gold_text.text = "";
            this.needGoods = null;
            this.needId.setValue(0);
            this.needNum.setValue(0);
            this.djNum.setValue(0);
            this.goldNum.setValue(0);
            this.proValue.setValue(0);
            this.shopId.setValue(0);
            operatingMc["ok_" + 0].visible = false;
            operatingMc.ts_text.text = "请先放入强化物品";
            this.cgoods = null;
         }
         else
         {
            operatingMc.ts_text.text = "你可以开始强化了";
            _loc1_ = this._strengSlot.getGoods(0);
            operatingMc["ok_" + 0].visible = true;
            _loc2_ = _loc1_.isStrengBo();
            if(_loc1_.getStrengLevel() < _loc2_)
            {
               this.needObjData(_loc1_,_loc1_.getStrengLevel() + GS.a1);
            }
            else
            {
               this.needObjData(_loc1_,_loc1_.getStrengLevel());
            }
            _loc3_ = VT.createVT(0);
            if(_loc1_.getStrengLevel() == 0)
            {
               _loc3_.setValue(0);
            }
            else
            {
               _loc3_.setValue(StrengthenFactory.getStrengValue(_loc1_.getCreateLevel(),_loc1_.getColor(),_loc1_.getStrengLevel()));
            }
            _loc4_ = Number(GoodsFactory.getGoodsById(this.needId.getValue()).getFrame());
            _loc5_ = VT.createVT(BagFactory.otherBag.getGoodsNumById(this.needId.getValue()));
            if(this.typeState == 0)
            {
               (this.slotBoxArr[1] as GoodsBtnX).visible = true;
               (this.slotBoxArr[1] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.slotBoxArr[1] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_);
               _loc7_ = "ffff00";
               _loc8_ = String(this.needNum.getValue());
               _loc9_ = String(_loc5_.getValue());
               if(_loc5_.getValue() < this.needNum.getValue())
               {
                  _loc7_ = "ff0000";
               }
               _loc10_ = "<font color=\"#" + _loc7_ + "\">" + _loc5_.getValue() + "</font>";
               _loc11_ = "<font>" + _loc8_ + "</font>";
               (operatingMc.num_text as TextField).htmlText = _loc10_ + "/" + _loc11_;
               (operatingMc.num_text as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14));
            }
            operatingMc.name_text.text = _loc1_.getName() + "+" + _loc1_.getStrengLevel();
            (operatingMc.name_text as TextField).setTextFormat(_loc1_.getColorStr());
            if(_loc1_.getSmallType() == 0)
            {
               _loc6_ = "攻击";
            }
            else if(_loc1_.getSmallType() == GS.a16)
            {
               _loc6_ = "称号全属性+";
            }
            else
            {
               _loc6_ = "防御";
            }
            if(_loc1_.getSmallType() == GS.a16)
            {
               operatingMc.current_text.text = String(_loc3_.getValue() / GS.a100) + "%";
               operatingMc.next_text.text = String(this.nextSxValue.getValue() / GS.a100) + "%";
            }
            else
            {
               operatingMc.current_text.text = String(_loc3_.getValue());
               operatingMc.next_text.text = String(this.nextSxValue.getValue());
            }
            operatingMc.type_text.text = _loc6_;
            operatingMc.pro_text.text = this.proValue.getValue() + "%";
            this.colorFun();
         }
         GoodsManger.tsFunction("Ts_48",104,520);
      }
      
      private function colorFun() : void
      {
         if(this.typeState == 0)
         {
            operatingMc.gold_text.text = String(this.goldNum.getValue());
            if(FlowInterface.getGodByRole() < this.goldNum.getValue())
            {
               (operatingMc.gold_text as TextField).setTextFormat(this._textF1);
            }
            else
            {
               (operatingMc.gold_text as TextField).setTextFormat(this._textF);
            }
         }
         else if(this.typeState == 1)
         {
            operatingMc.gold_text.text = String(this.djNum.getValue());
            if(FlowInterface.getDianJuanByRole() < this.djNum.getValue())
            {
               (operatingMc.gold_text as TextField).setTextFormat(this._textF1);
            }
            else
            {
               (operatingMc.gold_text as TextField).setTextFormat(this._textF);
            }
         }
      }
      
      private function needObjData(param1:Goods, param2:Number) : void
      {
         this.needId.setValue(StrengthenFactory.getMateriaId(param1.getCreateLevel(),param1.getColor(),param2));
         this.needGoods = GoodsFactory.createGoodsById(this.needId.getValue());
         this.needNum.setValue(StrengthenFactory.getMateriaNum(param1.getCreateLevel(),param1.getColor(),param2));
         this.nextSxValue.setValue(StrengthenFactory.getStrengValue(param1.getCreateLevel(),param1.getColor(),param2));
         this.proValue.setValue(StrengthenFactory.getProbability(param1.getCreateLevel(),param1.getColor(),param2));
         this.djNum.setValue(StrengthenFactory.getDj(param1.getCreateLevel(),param1.getColor(),param2));
         this.goldNum.setValue(StrengthenFactory.getGold(param1.getCreateLevel(),param1.getColor(),param2));
         this.shopId.setValue(StrengthenFactory.getShopId(param1.getCreateLevel(),param1.getColor(),param2));
      }
      
      private function bagDisplay() : void
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:Array = this._equipSlot.getBagArr();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(!(_loc2_ == 3 || _loc2_ == 7 || _loc2_ == 8 || _loc2_ == 9 || _loc2_ == 10 || _loc2_ == 11 || _loc2_ == 12 || _loc2_ == 13 || _loc2_ == 14 || _loc2_ == 15 || _loc2_ == 16))
            {
               _loc3_ = _loc1_[_loc2_] as Gird;
               _loc4_ = _loc3_.getGoods();
               (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = false;
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               operatingMc["z_" + _loc2_].visible = true;
               if(_loc4_ != null)
               {
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = true;
                  if(_loc3_.getGoodsNum() > 1)
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
                  }
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
                  if(_loc4_.getType() == 0 && _loc4_.getSmallType() != 3 && _loc4_.getSmallType() != 7 && _loc4_.isStrengBo() != -1 && _loc4_.getStrengLevel() < _loc4_.isStrengBo())
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                  }
                  else
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                  }
                  operatingMc["z_" + _loc2_].visible = false;
               }
            }
            _loc2_++;
         }
      }
      
      private function initMcBtn() : void
      {
         operatingMc.goldMc.gotoAndStop(1);
         operatingMc.zz_mc.visible = false;
         var _loc1_:BasicClickBtn = new BasicClickBtn(operatingMc.zz_mc["qx_" + 0]);
         addChild(_loc1_);
         var _loc2_:BasicClickBtn = new BasicClickBtn(this.czMc.cz_0);
         addChild(_loc2_);
         var _loc3_:BasicClickBtn = new BasicClickBtn(this.czMc.sure_0);
         addChild(_loc3_);
         this.closeBtn = new CloseBtn(operatingMc.close_btn);
         addChild(this.closeBtn);
         this.typeBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc["st_" + 0],operatingMc["st_" + 1]));
         addChild(this.typeBtn);
         this.okBtn = new BasicClickBtn(operatingMc["ok_" + 0]);
         addChild(this.okBtn);
         var _loc4_:TextField = new TextField();
         _loc4_ = operatingMc.ts_text as TextField;
         _loc4_.embedFonts = true;
         _loc4_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         (operatingMc.name_text as TextField).embedFonts = true;
         (operatingMc.name_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         (operatingMc.type_text as TextField).embedFonts = true;
         (operatingMc.type_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         (operatingMc.current_text as TextField).embedFonts = true;
         (operatingMc.current_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         (operatingMc.next_text as TextField).embedFonts = true;
         (operatingMc.next_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         (operatingMc.gold_text as TextField).embedFonts = true;
         (operatingMc.gold_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         (operatingMc.pro_text as TextField).embedFonts = true;
         (operatingMc.pro_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
      }
      
      public function getSlot() : StrengthenSlot
      {
         return this._strengSlot;
      }
   }
}

