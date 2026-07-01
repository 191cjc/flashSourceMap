package hotpointgame.views.wareroomPanel
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
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class WareroomPanel extends MovieClip
   {
      
      private static var _instance:WareroomPanel;
      
      private static var cbx:Number = -1;
      
      private var state:VT = VT.createVT(0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var rMc:MovieClip = new MovieClip();
      
      private var tbBoxArr:Array = [];
      
      private var _bagDisplay:BagDisplay;
      
      private var _sxDisplay:SxPanel;
      
      private var currentNum:VT = VT.createVT(0);
      
      private var movecurrentNum:VT = VT.createVT(-1);
      
      private var roomSlot:WareroomSlot;
      
      private var smallBag:Array = [];
      
      private var moveMc:MovieClip;
      
      private var moveId:Number;
      
      private var zlBtn:ClickBtnX;
      
      private var changeBtn:SameChangeBtnX;
      
      private var tkMc:MovieClip;
      
      private var xfGoods:GoodsBtnX;
      
      private var gouBtn:SameChangeBtnX;
      
      private var shopingState:VT = VT.createVT(-1);
      
      private var jtBtnArr:Array = [];
      
      private var goodsXX:Goods = GoodsFactory.createGoodsById(GS.a511091);
      
      private var czMc:MovieClip = new MovieClip();
      
      private var czingMc:MovieClip = new MovieClip();
      
      private var shNum:VT = VT.createVT(1);
      
      public function WareroomPanel()
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
               _loc1_.push("wareroomPanel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadRoomOver;
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
            _instance._bagDisplay.close();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      public static function loadRoomOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:ClickBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:CloseBtnX = null;
         var _loc9_:Object = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:Object = null;
         var _loc13_:MovieClip = null;
         var _loc14_:GoodsBtnX = null;
         var _loc15_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new WareroomPanel();
            _loc1_ = LoaderManager.getSwfClass("Room") as Class;
            _instance.rMc = new _loc1_();
            _instance.addChild(_instance.rMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _instance.moveMc = new _loc2_();
            _instance.upMc.addChild(_instance.moveMc);
            _loc3_ = 0;
            while(_loc3_ < 30)
            {
               _loc13_ = new _loc2_();
               _loc13_.name = "e_" + _loc3_;
               _loc14_ = new GoodsBtnX(_loc13_,_instance.rMc["bd_" + _loc3_].x,_instance.rMc["bd_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc14_);
               _instance.endMc.addChild(_loc14_);
               _loc3_++;
            }
            _instance.changeBtn = SameChangeBtnX.createSameChangeBtn(new Array(_instance.rMc.c_0,_instance.rMc.c_1,_instance.rMc.c_2,_instance.rMc.c_3,_instance.rMc.c_4));
            _instance.endMc.addChild(_instance.changeBtn);
            _instance.zlBtn = new ClickBtnX(_instance.rMc.zl_0,_instance.rMc.zl_0.x,_instance.rMc.zl_0.y);
            _instance.endMc.addChild(_instance.zlBtn);
            _loc4_ = new ClickBtnX(_instance.rMc.out_0,_instance.rMc.out_0.x,_instance.rMc.out_0.y);
            _instance.endMc.addChild(_loc4_);
            _loc5_ = new CloseBtnX(_instance.rMc.close_btn,_instance.rMc.close_btn.x,_instance.rMc.close_btn.y);
            _instance.endMc.addChild(_loc5_);
            _loc6_ = LoaderManager.getSwfClass("Ts_73");
            _instance.tkMc = new _loc6_();
            _instance.upMc.addChild(_instance.tkMc);
            _loc7_ = new _loc2_();
            _loc7_.name = "xftb_" + 0;
            _instance.xfGoods = new GoodsBtnX(_loc7_,_instance.tkMc.dd_mc.x,_instance.tkMc.dd_mc.y);
            _instance.tkMc.addChild(_instance.xfGoods);
            _instance.gouBtn = SameChangeBtnX.createSameChangeBtn(new Array(_instance.tkMc.gao_0,_instance.tkMc.gao_1));
            _instance.gouBtn.state = true;
            _instance.tkMc.addChild(_instance.gouBtn);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc15_ = new ClickBtnX(_instance.tkMc["jt_" + _loc3_],_instance.tkMc["jt_" + _loc3_].x,_instance.tkMc["jt_" + _loc3_].y);
               _instance.jtBtnArr.push(_loc15_);
               _instance.tkMc.addChild(_loc15_);
               _loc3_++;
            }
            _loc8_ = new CloseBtnX(_instance.tkMc.clo_0,_instance.tkMc.clo_0.x,_instance.tkMc.clo_0.y);
            _instance.tkMc.addChild(_loc8_);
            _loc9_ = LoaderManager.getSwfClass("Ts_69") as Class;
            _instance.czMc = new _loc9_();
            _instance.upMc.addChild(_instance.czMc);
            _loc10_ = new ClickBtnX(_instance.czMc.cz_0,_instance.czMc.cz_0.x,_instance.czMc.cz_0.y);
            _instance.czMc.addChild(_loc10_);
            _loc11_ = new ClickBtnX(_instance.czMc.sure_0,_instance.czMc.sure_0.x,_instance.czMc.sure_0.y);
            _instance.czMc.addChild(_loc11_);
            _loc12_ = LoaderManager.getSwfClass("Ts_74");
            _instance.czingMc = new _loc12_();
            _instance.upMc.addChild(_instance.czingMc);
            _instance._bagDisplay = BagDisplay.createBagDisplay(568.7,93.15);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.roomSlot = BagFactory.roomSlot;
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["op"] = BagFactory.roomSlot.getGoldCurr();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         BagFactory.roomSlot.readGoldCurr(param1["op"]);
      }
      
      public function initPanel() : void
      {
         _instance.visible = true;
         BagFactory.deleteTimeRoom();
         this.initMc();
         this.initBag();
         this.addEvent();
         this.state.setValue(GS.a0);
         this.initDate();
         this.initFrame();
      }
      
      private function initMc() : void
      {
         this.moveMc.visible = false;
         this.tkMc.visible = false;
         this.zlBtn.okBtn = true;
         this.xfGoods.getSmMc().t_txt.text = "";
         this.xfGoods.getSmMc().gotoAndStop(1);
         this.xfGoods.getSmMc().mask_mc.gotoAndStop(1);
         this.xfGoods.getSmMc().gx_mc.visible = false;
         this.czMc.visible = false;
         this.czingMc.visible = false;
      }
      
      private function initDate() : void
      {
         this.changeBtn.btnOk(this.state.getValue());
         this.roomSlot.initSmallBag();
         this.smallBag = this.roomSlot.getSmallBagByState(this.state.getValue());
      }
      
      private function initFrame() : void
      {
         var _loc2_:Gird = null;
         var _loc3_:Goods = null;
         var _loc4_:Number = NaN;
         this.initTbMc();
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a30)
         {
            _loc2_ = this.smallBag[_loc1_] as Gird;
            if(_loc2_.getKey() == GS.a0)
            {
               if(_loc2_.getGoods() != null)
               {
                  _loc3_ = _loc2_.getGoods();
                  _loc4_ = _loc2_.getGoodsNum();
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(_loc3_.getFrame());
                  if(_loc4_ > GS.a1)
                  {
                     (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc4_);
                  }
               }
            }
            else
            {
               (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(GS.a4);
            }
            _loc1_++;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.roomClick);
         addEventListener(BtnEvent.DO_MOUSEMOVE,this.roomMove);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(GoodsEvent.DO_ROOM,this.roomListener);
         addEventListener(BtnEvent.DO_MOUSEUP_TOW,this.changeGird);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.roomClick);
         removeEventListener(BtnEvent.DO_MOUSEMOVE,this.roomMove);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(GoodsEvent.DO_ROOM,this.roomListener);
         removeEventListener(BtnEvent.DO_MOUSEUP_TOW,this.changeGird);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            this.currentNum.setValue(this.state.getValue() * GS.a30 + param1.id);
            (this.tbBoxArr[this.currentNum.getValue() - this.state.getValue() * GS.a30] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         if(param1.name == "xftb")
         {
            this.xfGoods.getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "e")
         {
            this.currentNum.setValue(this.state.getValue() * GS.a30 + param1.id);
            (this.tbBoxArr[this.currentNum.getValue() - this.state.getValue() * GS.a30] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            _loc2_ = this.roomSlot.getGoods(this.currentNum.getValue());
            if(_loc2_ != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
            }
         }
         else if(param1.name == "xftb")
         {
            this.xfGoods.getSmMc().gx_mc.visible = true;
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.goodsXX));
         }
      }
      
      private function changeGird(param1:BtnEvent) : void
      {
         var _loc2_:Gird = null;
         var _loc3_:Goods = null;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:Gird = null;
         var _loc7_:Gird = null;
         var _loc8_:VT = null;
         var _loc9_:VT = null;
         if(this.movecurrentNum.getValue() != -1)
         {
            _loc2_ = this.roomSlot.getGird(this.movecurrentNum.getValue());
            _loc3_ = this.roomSlot.getGoods(this.movecurrentNum.getValue());
            this.moveMc.x = 0;
            this.moveMc.y = 0;
            this.moveMc.visible = false;
            if(_loc2_.getKey() == GS.a0 && _loc3_ != null)
            {
               _loc4_ = -1;
               _loc5_ = 0;
               while(_loc5_ < 30)
               {
                  if(MovieClip(this.rMc["bd_" + _loc5_]).hitTestPoint(mouseX,mouseY,true))
                  {
                     _loc4_ = this.state.getValue() * 30 + _loc5_;
                  }
                  _loc5_++;
               }
               if(_loc4_ == this.movecurrentNum.getValue())
               {
                  _loc4_ = -1;
               }
               if(_loc4_ != -1)
               {
                  _loc3_ = this.roomSlot.getGoods(this.movecurrentNum.getValue());
                  _loc6_ = this.roomSlot.getGird(this.movecurrentNum.getValue());
                  if(_loc3_.getOverlapping() == -1)
                  {
                     this.roomSlot.changeGird(_loc6_,this.movecurrentNum.getValue(),_loc4_);
                  }
                  else
                  {
                     _loc7_ = this.roomSlot.getGird(_loc4_);
                     if(_loc7_.compareById(_loc3_.getId()))
                     {
                        if(_loc7_.getGirdNum(_loc3_) >= _loc6_.getGoodsNum())
                        {
                           _loc8_ = VT.createVT(_loc6_.getGoodsNum());
                           this.roomSlot.addToBag(_loc3_,_loc4_,_loc6_.getGoodsNum());
                           this.roomSlot.deleteBag(this.movecurrentNum.getValue(),_loc8_.getValue());
                        }
                        else if(_loc7_.getGirdNum(_loc3_) > GS.a0)
                        {
                           _loc9_ = VT.createVT(_loc7_.getGirdNum(_loc3_));
                           this.roomSlot.addToBag(_loc3_,_loc4_,_loc7_.getGirdNum(_loc3_));
                           this.roomSlot.deleteBag(this.movecurrentNum.getValue(),_loc9_.getValue());
                        }
                     }
                     else
                     {
                        this.roomSlot.changeGird(_loc6_,this.movecurrentNum.getValue(),_loc4_);
                     }
                  }
               }
            }
            this.initDate();
            this.initFrame();
            _loc4_ = -1;
            this.movecurrentNum.setValue(-1);
         }
      }
      
      private function roomListener(param1:GoodsEvent) : void
      {
         var _loc2_:Number = Number(this.roomSlot.addInBag(param1.goods,param1.goodsNum));
         if(_loc2_ <= 29)
         {
            this.state.setValue(GS.a0);
         }
         else if(_loc2_ > 29 && _loc2_ <= 59)
         {
            this.state.setValue(GS.a1);
         }
         else if(_loc2_ > 59 && _loc2_ <= 89)
         {
            this.state.setValue(GS.a2);
         }
         this.initDate();
         this.initFrame();
      }
      
      private function roomMove(param1:BtnEvent) : void
      {
         var _loc2_:Gird = null;
         var _loc3_:Goods = null;
         var _loc4_:VT = null;
         if(param1.name == "e")
         {
            _loc2_ = this.roomSlot.getGird(this.currentNum.getValue());
            if(_loc2_.getKey() == GS.a0)
            {
               this.currentNum.setValue(this.state.getValue() * GS.a30 + param1.id);
               _loc3_ = this.roomSlot.getGoods(this.currentNum.getValue());
               _loc4_ = VT.createVT(this.roomSlot.getGoodsNum(this.currentNum.getValue()));
               if(_loc3_ != null)
               {
                  this.movecurrentNum.setValue(this.currentNum.getValue());
                  this.moveId = this.currentNum.getValue();
                  (this.tbBoxArr[this.currentNum.getValue() - this.state.getValue() * GS.a30] as GoodsBtnX).visible = false;
                  this.moveMc.visible = true;
                  this.moveMc.gotoAndStop(_loc3_.getFrame());
                  this.moveMc.mask_mc.gotoAndStop(1);
                  this.moveMc.gx_mc.visible = true;
                  this.moveMc.t_txt.text = String(_loc4_.getValue());
                  if(_loc4_.getValue() == 1)
                  {
                     this.moveMc.t_txt.text = "";
                  }
                  this.moveMc.x = mouseX - this.moveMc.width / 2;
                  this.moveMc.y = mouseY - this.moveMc.height / 2;
               }
            }
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "clo")
         {
            this.tkMc.visible = false;
            this.shopingState.setValue(-1);
         }
      }
      
      private function roomClick(param1:BtnEvent) : void
      {
         var _loc2_:Gird = null;
         var _loc3_:Goods = null;
         var _loc4_:VT = null;
         var _loc5_:uint = 0;
         if(param1.name == "e")
         {
            this.currentNum.setValue(this.state.getValue() * GS.a30 + param1.id);
            _loc2_ = this.roomSlot.getGird(this.currentNum.getValue());
            if(_loc2_.getKey() == GS.a0)
            {
               _loc3_ = this.roomSlot.getGoods(this.currentNum.getValue());
               _loc4_ = VT.createVT(this.roomSlot.getGoodsNum(this.currentNum.getValue()));
               if(_loc3_ != null)
               {
                  if(BagFactory.isFullBagOnlyOne(_loc3_,_loc4_.getValue()))
                  {
                     Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc3_,-1,0,_loc4_.getValue()));
                     this.roomSlot.deleteBag(this.currentNum.getValue(),_loc4_.getValue());
                     this.initDate();
                     this.initFrame();
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
            }
            else
            {
               this.tkMc.visible = true;
               this.gouBtn.czArr();
               this.tkMc.max_tx.text = "(最多开启" + this.roomSlot.getGoldMax() + "个," + "剩余:" + this.roomSlot.getGoldSx() + ")";
               this.tkMc.gold_tx.text = String(GS.a30000);
               this.tkMc.goodsnum_tx.text = String(GS.a40);
               this.tkMc.num_text.text = String(GS.a1);
               this.tkMc.dj_tx.text = String(GS.a200);
               this.shNum.setValue(GS.a1);
               this.xfGoods.getSmMc().gotoAndStop(this.goodsXX.getFrame());
               _loc5_ = 0;
               while(_loc5_ < 4)
               {
                  (this.jtBtnArr[_loc5_] as ClickBtnX).okBtn = true;
                  _loc5_++;
               }
               this.gouBtn.closeOrOpenBtnById(GS.a0,GS.a1);
               this.gouBtn.closeOrOpenBtnById(GS.a1,GS.a1);
               if(this.roomSlot.getGoldSx() > GS.a0)
               {
                  this.gouBtn.btnOk(GS.a0);
                  this.shopingState.setValue(GS.a0);
               }
               else
               {
                  this.gouBtn.btnOk(GS.a1);
                  this.shopingState.setValue(GS.a1);
                  this.gouBtn.closeOrOpenBtnById(GS.a0,GS.a0);
                  this.tkMc.gold_tx.text = String(GS.a0);
                  this.tkMc.goodsnum_tx.text = String(GS.a0);
               }
               if(this.roomSlot.getNoKey() == GS.a0)
               {
                  _loc5_ = 0;
                  while(_loc5_ < 4)
                  {
                     (this.jtBtnArr[_loc5_] as ClickBtnX).okBtn = false;
                     _loc5_++;
                  }
                  this.gouBtn.closeOrOpenBtnById(GS.a0,GS.a0);
                  this.gouBtn.closeOrOpenBtnById(GS.a1,GS.a0);
               }
            }
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         if(param1.name == "c")
         {
            this.state.setValue(param1.id);
            this.initDate();
            this.initFrame();
         }
         else if(param1.name == "gao")
         {
            _loc2_ = this.gouBtn.getClickArr();
            if(_loc2_[0])
            {
               this.shopingState.setValue(GS.a0);
            }
            else if(_loc2_[1])
            {
               this.shopingState.setValue(GS.a1);
            }
            else
            {
               this.shopingState.setValue(-1);
            }
            if(this.shopingState.getValue() != -1)
            {
               _loc3_ = 0;
               while(_loc3_ < 4)
               {
                  (this.jtBtnArr[_loc3_] as ClickBtnX).okBtn = true;
                  _loc3_++;
               }
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < 4)
               {
                  (this.jtBtnArr[_loc3_] as ClickBtnX).okBtn = false;
                  _loc3_++;
               }
            }
            this.tkMc.num_text.text = String(GS.a1);
            this.shNum.setValue(GS.a1);
            this.shopingDate(VT.createVT(GS.a1));
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Gird = null;
         var _loc7_:Goods = null;
         var _loc8_:Number = NaN;
         var _loc9_:VT = null;
         var _loc10_:VT = null;
         var _loc11_:VT = null;
         if(param1.name == "out")
         {
            _loc2_ = [];
            _loc3_ = [];
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < this.smallBag.length)
            {
               _loc6_ = this.smallBag[_loc5_] as Gird;
               _loc7_ = _loc6_.getGoods();
               _loc8_ = _loc6_.getGoodsNum();
               if(_loc7_ != null)
               {
                  _loc2_.push(_loc7_.getId());
                  _loc3_.push(_loc8_);
                  _loc4_.push(_loc7_);
               }
               _loc5_++;
            }
            if(_loc2_.length != GS.a0)
            {
               if(BagFactory.isFullBag(_loc2_,_loc3_))
               {
                  BagFactory.deleteArrByRoom(_loc2_,_loc3_);
                  BagFactory.addBagArrGoods(_loc4_,_loc3_);
                  this.initDate();
                  this.initFrame();
                  this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
               }
               else
               {
                  GoodsManger.cwTs("背包已满");
               }
            }
         }
         else if(param1.name == "zl")
         {
            this.zlBtn.okBtn = false;
            if(this.roomSlot.zhenliFunction())
            {
               this.state.setValue(GS.a0);
               this.initDate();
               this.initFrame();
               this.zlBtn.okBtn = true;
            }
         }
         else if(param1.name == "jt")
         {
            if(param1.id == 0)
            {
               _loc9_ = VT.createVT(Number(this.tkMc.num_text.text));
               if(_loc9_.getValue() > GS.a1)
               {
                  _loc9_.setValue(_loc9_.getValue() - GS.a1);
               }
               else if(this.shopingState.getValue() == GS.a0)
               {
                  _loc9_.setValue(this.roomSlot.getGoldSx());
               }
               else if(this.shopingState.getValue() == GS.a1)
               {
                  _loc9_.setValue(this.roomSlot.getNoKey());
               }
               this.tkMc.num_text.text = String(_loc9_.getValue());
               this.shNum.setValue(_loc9_.getValue());
               this.shopingDate(_loc9_);
            }
            else if(param1.id == 1)
            {
               _loc10_ = VT.createVT(0);
               _loc11_ = VT.createVT(Number(this.tkMc.num_text.text));
               if(this.shopingState.getValue() == GS.a0)
               {
                  _loc10_.setValue(this.roomSlot.getGoldSx());
               }
               else if(this.shopingState.getValue() == GS.a1)
               {
                  _loc10_.setValue(this.roomSlot.getNoKey());
               }
               if(_loc11_.getValue() < _loc10_.getValue())
               {
                  _loc11_.setValue(_loc11_.getValue() + GS.a1);
               }
               else
               {
                  _loc11_.setValue(GS.a1);
               }
               this.shNum.setValue(_loc11_.getValue());
               this.tkMc.num_text.text = String(_loc11_.getValue());
               this.shopingDate(_loc11_);
            }
            else if(param1.id == 2)
            {
               if(this.shopingState.getValue() == GS.a0)
               {
                  this.tkMc.num_text.text = String(this.roomSlot.getGoldSx());
                  this.shNum.setValue(this.roomSlot.getGoldSx());
               }
               else if(this.shopingState.getValue() == GS.a1)
               {
                  this.tkMc.num_text.text = String(this.roomSlot.getNoKey());
                  this.shNum.setValue(this.roomSlot.getNoKey());
               }
               this.shopingDate(VT.createVT(Number(this.tkMc.num_text.text)));
            }
            else if(param1.id == 3)
            {
               if(this.shopingState.getValue() == GS.a0)
               {
                  if(FlowInterface.getGodByRole() >= GS.a30000 * this.shNum.getValue())
                  {
                     if(BagFactory.getNumById(GS.a511091) >= GS.a40 * this.shNum.getValue())
                     {
                        this.roomSlot.setGoldCurr(this.shNum.getValue());
                        FlowInterface.redGodByRole(GS.a30000 * this.shNum.getValue());
                        BagFactory.deteleGoods(GS.a511091,GS.a40 * this.shNum.getValue());
                        this.roomSlot.openBag(this.shNum.getValue());
                        GoodsManger.cwTs("仓库格子成功开启!");
                     }
                     else
                     {
                        GoodsManger.cwTs("仓库解锁道具数量不足");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
                  this.initDate();
                  this.initFrame();
                  this._bagDisplay.getGoldTx();
                  this.tkMc.visible = false;
                  this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
               }
               else if(this.shopingState.getValue() == GS.a1)
               {
                  this.czingMc.visible = true;
                  this.tkMc.visible = false;
                  FlowInterface.djGouMai(GS.a464,this.shNum.getValue(),GS.a200,this.shopingBag,GS.a0);
               }
            }
         }
         else if(param1.name == "cz")
         {
            this.czMc.visible = false;
            FlowInterface.gotoShopPanel();
         }
         else if(param1.name == "sure")
         {
            this.czMc.visible = false;
         }
      }
      
      private function shopingBag(param1:Number) : void
      {
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            this.roomSlot.openBag(Number(this.tkMc.num_text.text));
            FlowInterface.saveDataByKaiOnlyShop();
            GoodsManger.cwTs("仓库格子成功开启!");
         }
         else
         {
            this.czMc.visible = true;
         }
         this.initDate();
         this.initFrame();
         this._bagDisplay.getGoldTx();
      }
      
      private function shopingDate(param1:VT) : void
      {
         if(this.shopingState.getValue() == GS.a0)
         {
            this.tkMc.gold_tx.text = String(GS.a30000 * param1.getValue());
            this.tkMc.goodsnum_tx.text = String(GS.a40 * param1.getValue());
            this.tkMc.dj_tx.text = String(GS.a0);
         }
         else if(this.shopingState.getValue() == GS.a1)
         {
            this.tkMc.gold_tx.text = String(GS.a0);
            this.tkMc.goodsnum_tx.text = String(GS.a0);
            this.tkMc.dj_tx.text = String(GS.a200 * param1.getValue());
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
      
      private function initTbMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 30)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            _loc1_++;
         }
      }
   }
}

