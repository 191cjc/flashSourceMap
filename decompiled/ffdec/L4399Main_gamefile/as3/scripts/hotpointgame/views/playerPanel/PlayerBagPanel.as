package hotpointgame.views.playerPanel
{
   import flash.display.*;
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
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.vipPanel.*;
   
   public class PlayerBagPanel extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      public static var _instance:PlayerBagPanel;
      
      private static var bx1:int = 0;
      
      private static var expMc:MovieClip = new MovieClip();
      
      private var _bagDisplay:BagDisplay;
      
      private var _playerChangeMc:PlayerChange;
      
      private var _sxDisplay:SxPanel;
      
      private var _slotState:Number = 0;
      
      private var _slot:EquipSlot;
      
      private var _typeBtn:SameChangeBtn;
      
      private var _smallType:SameChangeBtn;
      
      private var _closeBtn:CloseBtn;
      
      private var _timer:Timer;
      
      private var _timerNum:Number = 0;
      
      private var _bwType:Number;
      
      private var _tbArr:Array = [];
      
      private var tyValue:Number = 0;
      
      private var currnetRoleMc:MovieClip;
      
      private var gouXbtn:SameChangeBtn;
      
      private var xnMc:MovieClip = new MovieClip();
      
      private var tbBoxArr:Array = [];
      
      private var upMc:MovieClip = new MovieClip();
      
      private var enMc:MovieClip = new MovieClip();
      
      private var dMc:MovieClip = new MovieClip();
      
      private var exMaxNum:VT = VT.createVT(GS.a0);
      
      private var exGoods:Goods;
      
      private var currExNum:VT = VT.createVT(GS.a0);
      
      private var euEx:VT = VT.createVT(GS.a0);
      
      private var exexArr:Array = [];
      
      public var cdMc:MovieClip = new MovieClip();
      
      private var posStrArr:Array = ["武器","铠甲","腰带","机甲兽型","吊坠","护腕","指环","机甲人型","时装","肩膀","武器时装","炫光","机甲挂饰","浮游机炮","暂未开放","暂未开放","称号"];
      
      public function PlayerBagPanel()
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
               bx1 = -1;
               _loc1_ = new Array();
               _loc1_.push("playerpanel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               if(FlowInterface.getJobByRole() == 1)
               {
                  _loc1_.push("e_chushitao");
                  _loc1_.push("WuqiB_xinshouqiang");
                  _loc1_.push("pmodes1");
               }
               else if(FlowInterface.getJobByRole() == 2)
               {
                  _loc1_.push("e_wchushitao");
                  _loc1_.push("WuqiB_xinshoupao");
                  _loc1_.push("pmodes2");
               }
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadPanBagOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.visible = true;
         _instance.initPanel();
         _instance.x = 0;
      }
      
      private static function loadPanBagOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:Class = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         var _loc9_:MovieClip = null;
         var _loc10_:GoodsBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:ClickBtnX = null;
         if(bx1 != 0)
         {
            bx1 = 0;
            _loc1_ = LoaderManager.getSwfClass("Player_panel") as Class;
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = new _loc1_();
            operatingMc = _loc3_;
            _instance = new PlayerBagPanel();
            _instance._playerChangeMc = PlayerChange.createPlayerChange();
            _instance.addChild(operatingMc);
            GM.bagJm.addChild(_instance);
            _instance.initMcBtn();
            _loc4_ = 0;
            for(; _loc4_ < 17; _instance.tbBoxArr.push(_loc10_),_instance.addChild(_loc10_),_loc4_++)
            {
               _loc9_ = new _loc2_();
               _loc9_.name = "e_" + _loc4_;
               if(_loc4_ < 8)
               {
                  _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + _loc4_].x,operatingMc["d_" + _loc4_].y);
                  continue;
               }
               switch(_loc4_)
               {
                  case 8:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 0].x,operatingMc["d_" + 0].y);
                     break;
                  case 9:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 4].x,operatingMc["d_" + 4].y);
                     break;
                  case 10:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 1].x,operatingMc["d_" + 1].y);
                     break;
                  case 11:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 2].x,operatingMc["d_" + 2].y);
                     break;
                  case 12:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 3].x,operatingMc["d_" + 3].y);
                     break;
                  case 13:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 6].x,operatingMc["d_" + 6].y);
                     break;
                  case 14:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 5].x,operatingMc["d_" + 5].y);
                     break;
                  case 15:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 7].x,operatingMc["d_" + 7].y);
                     break;
                  case 16:
                     _loc10_ = new GoodsBtnX(_loc9_,operatingMc["d_" + 16].x,operatingMc["d_" + 16].y);
               }
            }
            _instance.addChild(_instance.dMc);
            _instance.addChild(_instance.enMc);
            _instance.addChild(_instance.upMc);
            _loc5_ = LoaderManager.getSwfClass("Ts_0") as Class;
            expMc = new _loc5_();
            _instance.upMc.addChild(expMc);
            _loc6_ = LoaderManager.getSwfClass("Tm_mc") as Class;
            _instance.cdMc = new _loc6_();
            _instance.upMc.addChild(_instance.cdMc);
            _loc7_ = new _loc2_();
            _loc7_.name = "exex_0";
            _loc8_ = new GoodsBtnX(_loc7_,expMc["d_" + 0].x,expMc["d_" + 0].y);
            expMc.addChild(_loc8_);
            _instance.exexArr.push(_loc8_);
            _loc4_ = 0;
            while(_loc4_ < 2)
            {
               _loc11_ = new ClickBtnX(expMc["ex_" + _loc4_],expMc["ex_" + _loc4_].x,expMc["ex_" + _loc4_].y);
               expMc.addChild(_loc11_);
               _loc12_ = new ClickBtnX(expMc["exjt_" + _loc4_],expMc["exjt_" + _loc4_].x,expMc["exjt_" + _loc4_].y);
               expMc.addChild(_loc12_);
               _loc4_++;
            }
            _instance._bagDisplay = BagDisplay.createBagDisplay(568.7,93.15);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.visible = true;
            _instance.initPanel();
            _instance.x = 0;
         }
      }
      
      public static function close() : void
      {
         bx1 = 0;
         if(_instance != null && _instance.visible)
         {
            BagFactory.isXgBo();
            _instance._bagDisplay.close();
            _instance._playerChangeMc.close();
            _instance.removeEvent();
            _instance.visible = false;
            _instance.x = 5000;
         }
      }
      
      private function initPanel() : void
      {
         this.cdMc.visible = false;
         this.expPanel(false);
         this.initBag();
         this._slot = BagFactory.equipSlot;
         this._slotState = 0;
         this.tyValue = 0;
         this.initGoodsDisplay();
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(GoodsEvent.DO_WEAR,this.goodsHandle);
         addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         this._timer = new Timer(0);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._smallType.btnOk(0);
         this._slot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
         GoodsManger.dataList.attZdl.jsZdl();
         this.sxText();
         this.initTextOther();
         this.ggVisble();
         this.ycBofun();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "exjt")
         {
            if(param1.id == 0)
            {
               if(this.currExNum.getValue() > GS.a1)
               {
                  this.currExNum.setValue(this.currExNum.getValue() - GS.a1);
               }
               else
               {
                  this.currExNum.setValue(this.exMaxNum.getValue());
               }
            }
            else if(param1.id == 1)
            {
               if(this.currExNum.getValue() < this.exMaxNum.getValue())
               {
                  this.currExNum.setValue(this.currExNum.getValue() + GS.a1);
               }
               else
               {
                  this.currExNum.setValue(GS.a1);
               }
            }
            expMc.num_tx.text = String(this.currExNum.getValue());
            expMc.needText.text = String(this.currExNum.getValue() * this.euEx.getValue());
         }
         else if(param1.name == "ex")
         {
            if(param1.id == 0)
            {
               FlowInterface.addExpByRole(this.currExNum.getValue() * this.euEx.getValue());
               BagFactory.deteleGoods(this.exGoods.getId(),this.currExNum.getValue());
               this._bagDisplay.initGoodsDisplay(4);
               operatingMc.level_tx.text = "LV." + String(FlowInterface.getLevelByRole());
            }
            this.expPanel(false);
         }
      }
      
      public function expPanel(param1:Boolean, param2:Number = 1, param3:Goods = null) : void
      {
         (this.exexArr[0] as GoodsBtnX).getSmMc().t_txt.text = "";
         (this.exexArr[0] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
         (this.exexArr[0] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         expMc.visible = param1;
         this.exMaxNum.setValue(GS.a0);
         this.currExNum.setValue(GS.a1);
         this.euEx.setValue(GS.a0);
         expMc.num_tx.text = "";
         expMc.needText.text = "";
         this.exGoods = null;
         if(param1)
         {
            if(BagFactory.getNumById(param3.getId()) >= param2)
            {
               this.exMaxNum.setValue(param2);
            }
            else
            {
               this.exMaxNum.setValue(BagFactory.getNumById(param3.getId()));
            }
            this.exGoods = param3;
            this.euEx.setValue(param3.getOtherValue());
            expMc.num_tx.text = String(this.currExNum.getValue());
            expMc.needText.text = String(this.currExNum.getValue() * this.euEx.getValue());
            (this.exexArr[0] as GoodsBtnX).getSmMc().gotoAndStop(param3.getFrame());
         }
      }
      
      private function ycBofun() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ <= 15)
         {
            if(_loc1_ > 7)
            {
               this.gouXbtn.setClick(_loc1_,this._slot.getYc(_loc1_));
            }
            _loc1_++;
         }
      }
      
      private function ggVisble() : void
      {
         var _loc1_:uint = 0;
         if(this._slotState == 0)
         {
            _loc1_ = 8;
            while(_loc1_ <= 15)
            {
               operatingMc["gao_" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else if(this._slotState == 1)
         {
            _loc1_ = 8;
            while(_loc1_ <= 15)
            {
               if(this._slot.getGoods(_loc1_) != null)
               {
                  operatingMc["gao_" + _loc1_].visible = true;
               }
               else
               {
                  operatingMc["gao_" + _loc1_].visible = false;
               }
               _loc1_++;
            }
         }
      }
      
      private function initBag() : void
      {
         this.dMc.addChild(this._playerChangeMc);
         this._playerChangeMc.initChange(257,178);
         this.enMc.addChild(this._bagDisplay);
         this._bagDisplay.init();
         this._bagDisplay._parentMc = this;
         this._bagDisplay.tbMastMc();
         addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function initTextOther() : void
      {
         var _loc1_:String = null;
         operatingMc.level_tx.text = "LV." + String(FlowInterface.getLevelByRole());
         if(FlowInterface.getJobByRole() == 1)
         {
            _loc1_ = "绝影枪手";
         }
         else if(FlowInterface.getJobByRole() == 2)
         {
            _loc1_ = "炎蓝炮手";
         }
         operatingMc.job_tx.text = _loc1_;
         (operatingMc.name_tx as TextField).htmlText = GM.testapi.userName;
         (operatingMc.name_tx as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,13,16777215));
         operatingMc.exp_tx.text = String(FlowInterface.getCurExpByRole() + "/" + FlowInterface.getExpByRole());
      }
      
      private function sxText() : void
      {
         if(this.tyValue == 0)
         {
            operatingMc.a_text.text = String(Math.floor(this._slot.getHp(0) + FlowInterface.getHpByRole() + (this._slot.getHp(0) + FlowInterface.getHpByRole()) * this._slot.getHp(1)));
            operatingMc.b_text.text = String(Math.floor(this._slot.getNl(0) + FlowInterface.getNlByRole() + (this._slot.getNl(0) + FlowInterface.getNlByRole()) * this._slot.getNl(1)));
            operatingMc.c_text.text = String(Math.floor(this._slot.getAtt(0) + FlowInterface.getAttByRole() + (this._slot.getAtt(0) + FlowInterface.getAttByRole()) * this._slot.getAtt(1)));
            operatingMc.d_text.text = String(Math.floor(this._slot.getFy(0) + FlowInterface.getFyByRole() + (this._slot.getFy(0) + FlowInterface.getFyByRole()) * this._slot.getFy(1)));
            operatingMc.e_text.text = String(Math.floor(this._slot.getSp() + FlowInterface.getSpByRole()));
            operatingMc.f_text.text = String(((this._slot.getBj() + FlowInterface.getBjByRole()) * 100).toFixed(1) + "%");
            operatingMc.type_mc.gotoAndStop(1);
         }
         else if(this.tyValue == 1)
         {
            operatingMc.a_text.text = String(Math.floor(this._slot.getJin()));
            operatingMc.b_text.text = String(Math.floor(this._slot.getMu()));
            operatingMc.c_text.text = String(Math.floor(this._slot.getShui()));
            operatingMc.d_text.text = String(Math.floor(this._slot.getHuo()));
            operatingMc.e_text.text = String(Math.floor(this._slot.getTu()));
            operatingMc.f_text.text = String(Math.floor(this._slot.getHd()));
            operatingMc.type_mc.gotoAndStop(2);
         }
         operatingMc.exp_mc.gotoAndStop(int(FlowInterface.getCurExpByRole() / FlowInterface.getExpByRole() * 100));
         operatingMc.zdl_tx.text = String(GoodsManger.dataList.attZdl.getZdl());
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this._timerNum <= 100)
         {
            ++this._timerNum;
         }
         else
         {
            (this.tbBoxArr[this._bwType] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            this._bwType = 0;
            this._timerNum = 0;
            this._timer.stop();
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "exex")
         {
            (this.exexArr[0] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         operatingMc.btnTs.visible = false;
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(GoodsEvent.DO_WEAR,this.goodsHandle);
         removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:String = null;
         if(param1.name == "e")
         {
            _loc2_ = this._slot.getGoods(param1.id);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         else if(param1.name == "exex")
         {
            if(this.exGoods != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.exGoods));
               (this.exexArr[0] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            }
         }
         else if(param1.name == "ts")
         {
            _loc3_ = "";
            switch(param1.id)
            {
               case 0:
                  _loc3_ = "克制木与无属性";
                  break;
               case 1:
                  _loc3_ = "克制土与无属性";
                  break;
               case 2:
                  _loc3_ = "克制火与无属性";
                  break;
               case 3:
                  _loc3_ = "克制金与无属性";
                  break;
               case 4:
                  _loc3_ = "克制水与无属性";
                  break;
               case 5:
                  _loc3_ = "克制所有属性";
                  break;
               case 6:
                  _loc3_ = "被所有属性克制";
            }
            operatingMc.btnTs.visible = true;
            operatingMc.btnTs.jn_3.text = _loc3_;
            operatingMc.btnTs.x = mouseX + 20;
            operatingMc.btnTs.y = mouseY;
            this.addChildAt(operatingMc.btnTs,numChildren - 1);
         }
         else if(param1.name == "ys")
         {
            if(this.tyValue == 1)
            {
               switch(param1.id)
               {
                  case 0:
                     _loc3_ = "同木属性与无属性敌人战斗时将额外" + "\n" + "获得大幅度的攻防加成";
                     break;
                  case 1:
                     _loc3_ = "同土属性与无属性敌人战斗时将额外" + "\n" + "获得大幅度的攻防加成";
                     break;
                  case 2:
                     _loc3_ = "同火属性与无属性敌人战斗时将额外" + "\n" + "获得大幅度的攻防加成";
                     break;
                  case 3:
                     _loc3_ = "同金属性与无属性敌人战斗时将额外" + "\n" + "获得大幅度的攻防加成";
                     break;
                  case 4:
                     _loc3_ = "同水属性与无属性敌人战斗时将额外" + "\n" + "获得大幅度的攻防加成";
                     break;
                  case 5:
                     _loc3_ = "同任意属性敌人战斗时获得的额外" + "\n" + "攻防加成高于其他所有属性";
                     break;
                  case 6:
                     _loc3_ = "";
               }
               operatingMc.btnTs.visible = true;
               operatingMc.btnTs.jn_3.text = _loc3_;
               operatingMc.btnTs.x = mouseX + 20;
               operatingMc.btnTs.y = mouseY;
               this.addChildAt(operatingMc.btnTs,numChildren - 1);
            }
         }
      }
      
      private function wearGoodsHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "e")
         {
            if(BagFactory.equipBag.getAirGirdNum() > 0 && BagFactory.clothesBag.getAirGirdNum() > 0)
            {
               _loc2_ = this._slot.getGoods(param1.id);
               if(_loc2_.getSmallType() == GS.a7)
               {
                  if(FlowInterface.getRoleState() == GS.a1 || FlowInterface.getRoleState() == GS.a2)
                  {
                     return;
                  }
               }
               else if(_loc2_.getSmallType() == GS.a3)
               {
                  if(FlowInterface.getRoleState() == GS.a2)
                  {
                     return;
                  }
               }
               this._slot.deleteBag(param1.id,GS.a1);
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1));
               this.initGoodsDisplay();
               this._slot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
               GoodsManger.dataList.attZdl.jsZdl();
               this.sxText();
               FlowInterface.changeByEquipSlot(param1.id,1,"");
               if(param1.id != 16)
               {
                  if(param1.id > GS.a07)
                  {
                     this._slot.setYcid(param1.id,false);
                     this.gouXbtn.setClick(param1.id,false);
                  }
               }
               this.ggVisble();
               this._playerChangeMc.changeRoleMc();
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
      }
      
      public function mcPoint() : void
      {
         var _loc1_:uint = 0;
         if(this._slotState == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 16)
            {
               if(_loc1_ < 8)
               {
                  if(this._slot.getGoods(_loc1_) != null)
                  {
                     (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
                  }
               }
               else
               {
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
               }
               _loc1_++;
            }
         }
         else if(this._slotState == 1)
         {
            _loc1_ = 0;
            while(_loc1_ < 16)
            {
               if(_loc1_ < 8)
               {
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
               }
               else if(this._slot.getGoods(_loc1_) != null)
               {
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
               }
               _loc1_++;
            }
         }
      }
      
      private function initGoodsDisplay() : void
      {
         this._typeBtn.btnOk(this._slotState);
         this.initFrame();
         this.mcPoint();
         this.posNameFun();
      }
      
      private function initFrame() : void
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:Array = this._slot.getBagArr();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as Gird;
            _loc4_ = _loc3_.getGoods();
            (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            if(_loc4_ != null)
            {
               (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = true;
               if(_loc3_.getGoodsNum() > 1)
               {
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
               }
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
            }
            _loc2_++;
         }
      }
      
      private function goodsHandle(param1:GoodsEvent) : void
      {
         var _loc5_:Goods = null;
         var _loc2_:Goods = param1.goods;
         var _loc3_:Number = param1.id;
         var _loc4_:Number = _loc2_.getType();
         this._bwType = _loc2_.getSmallType();
         if(_loc4_ == 0)
         {
            if(this._bwType != 16)
            {
               if(this._bwType == 8 || this._bwType == 9 || this._bwType == 10 || this._bwType == 11 || this._bwType == 12 || this._bwType == 13 || this._bwType == 14 || this._bwType == 15)
               {
                  this._slotState = 1;
                  this._slot.setYcid(this._bwType,true);
                  this.gouXbtn.setClick(this._bwType,true);
               }
               else
               {
                  this._slotState = 0;
               }
            }
            if(this._slot.getGoods(this._bwType) != null)
            {
               _loc5_ = DeepCopyUtil.clone(this._slot.getGoods(this._bwType));
               this._slot.deleteBag(this._bwType,GS.a1);
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc5_,_loc3_));
            }
            this._slot.addToBag(_loc2_,this._bwType,GS.a1);
            this.initGoodsDisplay();
            this._timer.start();
            this._timerNum = 0;
            this.gxDisplay(this._bwType);
            this._slot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
            GoodsManger.dataList.attZdl.jsZdl();
            this.sxText();
            FlowInterface.changeByEquipSlot(this._bwType,this._slot.getGoods(this._bwType).getFrame(),this._slot.getGoods(this._bwType).getMcName());
            this.ggVisble();
            this._playerChangeMc.changeRoleMc();
         }
      }
      
      private function gxDisplay(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 16)
         {
            if(_loc2_ == param1)
            {
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            }
            else
            {
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "s")
         {
            this._slotState = param1.id;
            this.initGoodsDisplay();
            if(this._slotState == 0)
            {
               this._bagDisplay._bagState = 0;
               this._bagDisplay.initGoodsDisplay(0);
            }
            else if(this._slotState == 1)
            {
               this._bagDisplay._bagState = 3;
               this._bagDisplay.initGoodsDisplay(3);
            }
            this.ggVisble();
         }
         else if(param1.name == "b")
         {
            this.tyValue = param1.id;
            this.sxText();
         }
         else if(param1.name == "gao")
         {
            this._slot.setYcArr(this.gouXbtn.getClickArr());
            if(this._slot.getYc(param1.id))
            {
               FlowInterface.showAndHSzType(param1.id,true);
            }
            else
            {
               FlowInterface.showAndHSzType(param1.id,false);
            }
            this._playerChangeMc.changeRoleMc();
         }
      }
      
      private function posNameFun() : void
      {
         var _loc2_:Goods = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 17)
         {
            operatingMc["txt_" + _loc1_].text = "";
            _loc1_++;
         }
         if(this._slot.getGoods(16) == null)
         {
            operatingMc["txt_" + 16].text = this.posStrArr[16];
         }
         else
         {
            operatingMc["txt_" + 16].text = "";
         }
         if(this._slotState == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 8)
            {
               operatingMc["txt_" + _loc1_].text = this.posStrArr[_loc1_];
               if(this._slot.getGoods(_loc1_) == null)
               {
                  operatingMc["txt_" + _loc1_].defaultTextFormat = new TextFormat(GM.fzfont.fontName,15,3430284);
               }
               else
               {
                  operatingMc["txt_" + _loc1_].text = "";
               }
               _loc1_++;
            }
         }
         else if(this._slotState == 1)
         {
            _loc1_ = 8;
            while(_loc1_ < 16)
            {
               operatingMc["txt_" + _loc1_].text = this.posStrArr[_loc1_];
               if(this._slot.getGoods(_loc1_) == null)
               {
                  if(_loc1_ == 14 || _loc1_ == 15)
                  {
                     operatingMc["txt_" + _loc1_].defaultTextFormat = new TextFormat(GM.fzfont.fontName,15,15918801);
                  }
                  else
                  {
                     operatingMc["txt_" + _loc1_].defaultTextFormat = new TextFormat(GM.fzfont.fontName,15,3430284);
                  }
               }
               else
               {
                  _loc2_ = this._slot.getGoods(_loc1_);
                  _loc3_ = _loc2_.getSmallTypeForStr();
                  _loc4_ = 8;
                  while(_loc4_ < 16)
                  {
                     if(_loc3_ == operatingMc["txt_" + _loc4_].text)
                     {
                        operatingMc["txt_" + _loc4_].text = "";
                        break;
                     }
                     _loc4_++;
                  }
               }
               _loc1_++;
            }
         }
      }
      
      private function initMcBtn() : void
      {
         var _loc2_:TextField = null;
         var _loc3_:OverBtn = null;
         var _loc4_:OverBtn = null;
         operatingMc.type_mc.stop();
         operatingMc.exp_mc.gotoAndStop(1);
         operatingMc.btnTs.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 17)
         {
            _loc2_ = new TextField();
            _loc2_ = operatingMc["txt_" + _loc1_] as TextField;
            _loc2_.embedFonts = true;
            if(_loc1_ == 14 || _loc1_ == 15)
            {
               _loc2_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15,15918801);
            }
            else
            {
               _loc2_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15,3430284);
            }
            _loc1_++;
         }
         this._typeBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.s_0,operatingMc.s_1));
         addChild(this._typeBtn);
         this._smallType = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.b_0,operatingMc.b_1));
         addChild(this._smallType);
         this._closeBtn = new CloseBtn(operatingMc.close_btn);
         addChild(this._closeBtn);
         (operatingMc.level_tx as TextField).embedFonts = true;
         (operatingMc.level_tx as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
         (operatingMc.job_tx as TextField).embedFonts = true;
         (operatingMc.job_tx as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
         (operatingMc.name_tx as TextField).embedFonts = true;
         (operatingMc.name_tx as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
         (operatingMc.exp_tx as TextField).embedFonts = true;
         (operatingMc.exp_tx as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         operatingMc.a_text.embedFonts = true;
         operatingMc.a_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.b_text.embedFonts = true;
         operatingMc.b_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.c_text.embedFonts = true;
         operatingMc.c_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.d_text.embedFonts = true;
         operatingMc.d_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.e_text.embedFonts = true;
         operatingMc.e_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.f_text.embedFonts = true;
         operatingMc.f_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc3_ = new OverBtn(operatingMc["ts_" + _loc1_]);
            addChild(_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc4_ = new OverBtn(operatingMc["ys_" + _loc1_]);
            addChild(_loc4_);
            _loc1_++;
         }
         this.gouXbtn = SameChangeBtn.createSameChangeBtn(new Array(this.xnMc,this.xnMc,this.xnMc,this.xnMc,this.xnMc,this.xnMc,this.xnMc,this.xnMc,operatingMc["gao_" + 8],operatingMc["gao_" + 9],operatingMc["gao_" + 10],operatingMc["gao_" + 11],operatingMc["gao_" + 12],operatingMc["gao_" + 13],operatingMc["gao_" + 14],operatingMc["gao_" + 15]));
         this.gouXbtn.type = 1;
         addChild(this.gouXbtn);
      }
   }
}

