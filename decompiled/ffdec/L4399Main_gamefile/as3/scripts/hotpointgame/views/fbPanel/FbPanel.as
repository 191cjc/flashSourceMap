package hotpointgame.views.fbPanel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.fb.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.chHao.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class FbPanel extends MovieClip
   {
      
      private static var _instance:FbPanel;
      
      private static var cbx:Number = -1;
      
      private static var mvBo:Boolean = false;
      
      private var tbBoxArr:Array = [];
      
      private var state:VT = VT.createVT(GS.a1);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var fbMc:MovieClip = new MovieClip();
      
      private var fbArr:Array = [];
      
      private var _sxDisplay:SxPanel;
      
      private var chBtn:GoodsBtnX;
      
      private var smType:VT = VT.createVT(GS.a0);
      
      private var gk:SameChangeBtnX;
      
      public function FbPanel()
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
               _loc1_.push("fbpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadFbOver;
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
      
      public static function loadFbOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:ClickBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         var _loc9_:GoodsBtnX = null;
         var _loc10_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new FbPanel();
            _loc1_ = LoaderManager.getSwfClass("Fb") as Class;
            _instance.fbMc = new _loc1_();
            _instance.addChild(_instance.fbMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = new _loc2_();
            _loc3_.name = "ch_" + 0;
            _instance.chBtn = new GoodsBtnX(_loc3_,_instance.fbMc.ch_0.x,_instance.fbMc.ch_0.y);
            _instance.fbMc.addChild(_instance.chBtn);
            _loc4_ = 0;
            while(_loc4_ < 12)
            {
               _loc7_ = new _loc2_();
               _loc7_.name = "e_" + _loc4_;
               _loc8_ = new GoodsBtnX(_loc7_,_instance.fbMc["d_" + _loc4_].x,_instance.fbMc["d_" + _loc4_].y);
               _instance.tbBoxArr.push(_loc8_);
               _instance.fbMc.addChild(_loc8_);
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               _loc9_ = new GoodsBtnX(_instance.fbMc["f_" + _loc4_],_instance.fbMc["f_" + _loc4_].x,_instance.fbMc["f_" + _loc4_].y);
               _instance.fbMc.addChild(_loc9_);
               _instance.fbArr.push(_loc9_);
               _loc10_ = new ClickBtnX(_instance.fbMc["fb_" + _loc4_],_instance.fbMc["fb_" + _loc4_].x,_instance.fbMc["fb_" + _loc4_].y);
               _instance.fbMc.addChild(_loc10_);
               _loc4_++;
            }
            _instance.gk = SameChangeBtnX.createSameChangeBtn([new MovieClip(),_instance.fbMc.gk_1,_instance.fbMc.gk_2,_instance.fbMc.gk_3]);
            _instance.fbMc.addChild(_instance.gk);
            _loc5_ = new ClickBtnX(_instance.fbMc.cBtn_0,_instance.fbMc.cBtn_0.x,_instance.fbMc.cBtn_0.y);
            _instance.fbMc.addChild(_loc5_);
            _loc6_ = new CloseBtnX(_instance.fbMc.close_btn,_instance.fbMc.close_btn.x,_instance.fbMc.close_btn.y);
            _instance.fbMc.addChild(_loc6_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.smType.setValue(GS.a0);
            _instance.state.setValue(GS.a1);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["mv"] = mvBo;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         mvBo = param1["mv"];
      }
      
      private function initPanel() : void
      {
         this.centerMc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.mvfun();
         this.addEvent();
         this.gk.btnOk(this.state.getValue());
         this.initFrame();
         this.gotoBtnFun();
         this.initJl();
         this.initChTx();
      }
      
      public function mvfun() : void
      {
         if(mvBo == false)
         {
            mvBo = true;
            GoodsManger.tsFunction("Ts_141",0.1,0);
         }
      }
      
      private function initChTx() : void
      {
         (this.fbMc.sm_tx as TextField).htmlText = ChHaoFactory.getDataById(FbData.chLevel.getValue()).getSm();
         var _loc1_:Number = Number(ChHaoFactory.getDataById(FbData.chLevel.getValue()).getFbId());
         (this.fbMc.time_tx as TextField).text = String(FbData.getFinishTimeById(_loc1_));
         (this.chBtn as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(ChHaoFactory.getDataById(FbData.chLevel.getValue()).getJlGoodsId()).getFrame());
      }
      
      private function initFrame() : void
      {
         var _loc3_:Fb = null;
         this.initMc();
         var _loc1_:Array = FbData.getFbById(this.state.getValue());
         var _loc2_:uint = 0;
         while(_loc2_ < 10)
         {
            if(_loc1_[_loc2_] != null)
            {
               _loc3_ = _loc1_[_loc2_] as Fb;
               (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().visible = true;
               (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc3_.getFrame());
               if(_loc3_.getKeyId() == -1)
               {
                  (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().key_mc.visible = false;
               }
               else if(FbData.isKey(_loc3_.getKeyId()))
               {
                  (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().key_mc.visible = false;
               }
               else
               {
                  (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().key_mc.visible = true;
               }
               if(_loc3_.getState() == GS.a0)
               {
                  (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().cg_mc.visible = false;
               }
               else if(_loc3_.getState() == GS.a1)
               {
                  (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().cg_mc.visible = true;
               }
               this.fbMc["fb_" + _loc2_].visible = true;
            }
            else
            {
               (this.fbArr[_loc2_] as GoodsBtnX).getSmMc().visible = false;
               this.fbMc["fb_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private function initJl() : void
      {
         var _loc2_:Fb = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc1_:Array = FbData.getFbById(this.state.getValue());
         if(_loc1_[this.smType.getValue()] != null)
         {
            _loc2_ = _loc1_[this.smType.getValue()] as Fb;
            _loc3_ = _loc2_.getGoodsId();
            _loc4_ = 0;
            while(_loc4_ < 12)
            {
               if(_loc3_[_loc4_] != null)
               {
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).visible = true;
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc3_[_loc4_]).getFrame());
               }
               else
               {
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).visible = false;
               }
               _loc4_++;
            }
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "f")
         {
            if(param1.id != this.smType.getValue())
            {
               (this.fbArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(1);
            }
         }
         else if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "ch")
         {
            (this.chBtn as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Fb = null;
         var _loc4_:Array = null;
         var _loc5_:Goods = null;
         if(param1.name == "f")
         {
            if(param1.id != this.smType.getValue())
            {
               (this.fbArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(2);
            }
         }
         else if(param1.name == "e")
         {
            _loc2_ = FbData.getFbById(this.state.getValue());
            _loc3_ = _loc2_[this.smType.getValue()] as Fb;
            _loc4_ = _loc3_.getGoodsId();
            _loc5_ = GoodsFactory.createGoodsById(_loc4_[param1.id]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc5_));
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         else if(param1.name == "ch")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,GoodsFactory.createGoodsById(ChHaoFactory.getDataById(FbData.chLevel.getValue()).getJlGoodsId())));
            (this.chBtn as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "gk")
         {
            this.state.setValue(param1.id);
            this.smType.setValue(GS.a0);
            this.initFrame();
            this.gotoBtnFun();
            this.initJl();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Fb = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         var _loc6_:VT = null;
         var _loc7_:Goods = null;
         if(param1.name == "f")
         {
            this.smType.setValue(param1.id);
            this.initFrame();
            this.gotoBtnFun();
            this.initJl();
         }
         else if(param1.name == "fb")
         {
            _loc2_ = FbData.getFbById(this.state.getValue());
            _loc3_ = _loc2_[param1.id] as Fb;
            if(_loc3_.getState() == GS.a1)
            {
               GoodsManger.cwTs("每天只能挑战一次");
               return;
            }
            if(_loc3_.getKeyId() == -1)
            {
               if(_loc3_.getNeedId() == -1)
               {
                  if(GM.levelSD.isHasMaxAch(_loc3_.getGkId()))
                  {
                     GM.levelm.changeLevelDataByIdAndLs(_loc3_.getFbId(),1);
                  }
                  else
                  {
                     GoodsManger.cwTs("此关成就点达100%才可挑战");
                  }
               }
               else if(BagFactory.getNumById(_loc3_.getNeedId()) > GS.a0)
               {
                  if(GM.levelSD.isHasMaxAch(_loc3_.getGkId()))
                  {
                     if(BagFactory.deteleGoods(_loc3_.getNeedId(),GS.a1))
                     {
                        GM.testapi.saveDataBefore();
                        GM.levelm.changeLevelDataByIdAndLs(_loc3_.getFbId(),1);
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("此关成就点达100%才可挑战");
                  }
               }
               else
               {
                  GoodsManger.cwTs(GoodsFactory.getGoodsById(_loc3_.getNeedId()).getName() + "不足");
               }
            }
            else if(FbData.isKey(_loc3_.getKeyId()))
            {
               if(_loc3_.getNeedId() == -1)
               {
                  if(GM.levelSD.isHasMaxAch(_loc3_.getGkId()))
                  {
                     GM.levelm.changeLevelDataByIdAndLs(_loc3_.getFbId(),1);
                  }
                  else
                  {
                     GoodsManger.cwTs("此关成就点达100%才可挑战");
                  }
               }
               else if(BagFactory.getNumById(_loc3_.getNeedId()) > GS.a0)
               {
                  if(GM.levelSD.isHasMaxAch(_loc3_.getGkId()))
                  {
                     if(BagFactory.deteleGoods(_loc3_.getNeedId(),GS.a1))
                     {
                        GM.testapi.saveDataBefore();
                        GM.levelm.changeLevelDataByIdAndLs(_loc3_.getFbId(),1);
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("此关成就点达100%才可挑战");
                  }
               }
               else
               {
                  GoodsManger.cwTs(GoodsFactory.getGoodsById(_loc3_.getNeedId()).getName() + "不足");
               }
            }
            else
            {
               GoodsManger.cwTs("请先通关前一关卡");
            }
         }
         else if(param1.name == "cBtn")
         {
            if(FbData.getLq(FbData.chLevel.getValue()) == GS.a0)
            {
               if(FbData.getFinishTimeById(ChHaoFactory.getDataById(FbData.chLevel.getValue()).getFbId()) >= ChHaoFactory.getDataById(FbData.chLevel.getValue()).getTimes())
               {
                  _loc4_ = VT.createVT(ChHaoFactory.getDataById(FbData.chLevel.getValue()).getDeGoodsId());
                  _loc5_ = VT.createVT(ChHaoFactory.getDataById(FbData.chLevel.getValue()).getJlGoodsId());
                  if(_loc4_.getValue() == -1)
                  {
                     if(BagFactory.isFullById(_loc5_.getValue(),GS.a1))
                     {
                        BagFactory.addInBagById(_loc5_.getValue(),GS.a1,GS.a0);
                        BagFactory.hdGoodsTs(_loc5_.getValue(),GS.a1);
                        FbData.setLq(FbData.chLevel.getValue());
                        FbData.addChLevel();
                        this.initChTx();
                     }
                     else
                     {
                        GoodsManger.cwTs("背包已满");
                     }
                  }
                  else if(BagFactory.isFullById(_loc5_.getValue(),GS.a1))
                  {
                     _loc6_ = VT.createVT(GS.a0);
                     _loc7_ = BagFactory.deleteGoodsByAll(_loc4_.getValue(),GS.a1);
                     if(_loc7_ != null)
                     {
                        BagFactory.addInBagById(_loc5_.getValue(),GS.a1,_loc7_.getStrengLevel());
                     }
                     else
                     {
                        BagFactory.addInBagById(_loc5_.getValue(),GS.a1,GS.a0);
                     }
                     BagFactory.hdGoodsTs(_loc5_.getValue(),GS.a1);
                     FbData.setLq(FbData.chLevel.getValue());
                     FbData.addChLevel();
                     this.initChTx();
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
               else
               {
                  GoodsManger.cwTs("通关次数未满足");
               }
            }
            else
            {
               GoodsManger.cwTs("已领取");
            }
         }
      }
      
      private function inFbArr() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.fbArr.length)
         {
            (this.fbArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function gotoBtnFun() : void
      {
         this.inFbArr();
         (this.fbArr[this.smType.getValue()] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(3);
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            if(_loc1_ == this.smType.getValue())
            {
               this.fbMc["fb_" + _loc1_].visible = true;
            }
            else
            {
               this.fbMc["fb_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            (this.fbArr[_loc1_] as GoodsBtnX).getSmMc().key_mc.visible = false;
            (this.fbArr[_loc1_] as GoodsBtnX).getSmMc().cg_mc.visible = false;
            (this.fbArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(1);
            (this.fbArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
         (this.chBtn as GoodsBtnX).getSmMc().t_txt.text = "";
         (this.chBtn as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
         (this.chBtn as GoodsBtnX).getSmMc().gx_mc.visible = false;
         (this.chBtn as GoodsBtnX).getSmMc().d_mc.visible = false;
      }
   }
}

