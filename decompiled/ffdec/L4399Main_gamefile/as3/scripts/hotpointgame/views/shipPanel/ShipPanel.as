package hotpointgame.views.shipPanel
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
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.ship.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class ShipPanel extends MovieClip
   {
      
      private static var _instance:ShipPanel;
      
      private static var cbx:Number = -1;
      
      private var tbBoxArr:Array = [];
      
      private var gkArr:Array = [];
      
      private var state:VT = VT.createVT(GS.a1);
      
      private var smType:VT = VT.createVT(GS.a0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var spMc:MovieClip = new MovieClip();
      
      private var gk:SameChangeBtnX;
      
      private var _sxDisplay:SxPanel;
      
      private var jtNum:VT = VT.createVT(GS.a1);
      
      private var timeX:VT = VT.createVT(GS.a0);
      
      private var timeGd:VT = VT.createVT(GS.a30);
      
      private var timeAll:VT = VT.createVT(GS.a0);
      
      private var timeSa:VT = VT.createVT(GS.a0);
      
      private var cuJd:VT = VT.createVT(GS.a0);
      
      private var timer:Timer;
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var cdMc:MovieClip;
      
      private var boVT:VT = VT.createVT(GS.a0);
      
      public function ShipPanel()
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
               GM.loaderM.completeF = loadSpOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPanel();
      }
      
      public static function close() : void
      {
         if(_instance != null && Boolean(_instance.visible))
         {
            if(_instance.boVT.getValue() == GS.a1)
            {
               _instance.closeZd(GS.a1);
            }
            _instance.closePanel();
         }
      }
      
      public static function loadSpOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:CloseBtnX = null;
         var _loc5_:ClickBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:ClickBtnX = null;
         var _loc8_:ClickBtnX = null;
         var _loc9_:Object = null;
         var _loc10_:MovieClip = null;
         var _loc11_:GoodsBtnX = null;
         var _loc12_:GoodsBtnX = null;
         var _loc13_:ClickBtnX = null;
         var _loc14_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new ShipPanel();
            _loc1_ = LoaderManager.getSwfClass("ShipMc") as Class;
            _instance.spMc = new _loc1_();
            _instance.addChild(_instance.spMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.upMc);
            _instance.addChild(_instance.topMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 20)
            {
               _loc10_ = new _loc2_();
               _loc10_.name = "e_" + _loc3_;
               _loc11_ = new GoodsBtnX(_loc10_,_instance.spMc["d_" + _loc3_].x,_instance.spMc["d_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc11_);
               _instance.spMc.addChild(_loc11_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               _loc12_ = new GoodsBtnX(_instance.spMc["f_" + _loc3_],_instance.spMc["f_" + _loc3_].x,_instance.spMc["f_" + _loc3_].y);
               _instance.spMc.addChild(_loc12_);
               _instance.gkArr.push(_loc12_);
               _loc13_ = new ClickBtnX(_instance.spMc["fb_" + _loc3_],_instance.spMc["fb_" + _loc3_].x,_instance.spMc["fb_" + _loc3_].y);
               _instance.spMc.addChild(_loc13_);
               _loc3_++;
            }
            _instance.gk = SameChangeBtnX.createSameChangeBtn([new MovieClip(),_instance.spMc.gk_1,_instance.spMc.gk_2,_instance.spMc.gk_3]);
            _instance.spMc.addChild(_instance.gk);
            _loc4_ = new CloseBtnX(_instance.spMc.close_btn,_instance.spMc.close_btn.x,_instance.spMc.close_btn.y);
            _instance.spMc.addChild(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc14_ = new ClickBtnX(_instance.spMc.gj_mc["j_" + _loc3_],_instance.spMc.gj_mc["j_" + _loc3_].x,_instance.spMc.gj_mc["j_" + _loc3_].y);
               _instance.spMc.gj_mc.addChild(_loc14_);
               _loc3_++;
            }
            _loc5_ = new ClickBtnX(_instance.spMc.gj_mc["k_" + 0],_instance.spMc.gj_mc["k_" + 0].x,_instance.spMc.gj_mc["k_" + 0].y);
            _instance.spMc.gj_mc.addChild(_loc5_);
            _loc6_ = new CloseBtnX(_instance.spMc.gj_mc.gjclose_btn,_instance.spMc.gj_mc.gjclose_btn.x,_instance.spMc.gj_mc.gjclose_btn.y);
            _instance.spMc.gj_mc.addChild(_loc6_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _loc7_ = new ClickBtnX(_instance.spMc.gg_mc["st_" + 0],_instance.spMc.gg_mc["st_" + 0].x,_instance.spMc.gg_mc["st_" + 0].y);
            _instance.spMc.gg_mc.addChild(_loc7_);
            _loc8_ = new ClickBtnX(_instance.spMc.ov_mc["su_" + 0],_instance.spMc.ov_mc["su_" + 0].x,_instance.spMc.ov_mc["su_" + 0].y);
            _instance.spMc.ov_mc.addChild(_loc8_);
            _loc9_ = LoaderManager.getSwfClass("Tm_mc") as Class;
            _instance.cdMc = new _loc9_();
            _instance.topMc.addChild(_instance.cdMc);
            _instance.upMc.addChild(_instance.spMc.gj_mc);
            _instance.upMc.addChild(_instance.spMc.gg_mc);
            _instance.upMc.addChild(_instance.spMc.ov_mc);
            _instance.initTextFun();
            _instance.smType.setValue(GS.a0);
            _instance.state.setValue(GS.a1);
            _instance.timer = new Timer(GS.a1000,GS.a0);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      public function closePanel() : void
      {
         cbx = 0;
         this.removeEvent();
         this.visible = false;
      }
      
      private function initTextFun() : void
      {
         var _loc1_:MovieClip = this.spMc.gj_mc;
         _loc1_.tl_tx.embedFonts = true;
         _loc1_.tl_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         _loc1_.time_tx.embedFonts = true;
         _loc1_.time_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         _loc1_.exp_tx.embedFonts = true;
         _loc1_.exp_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         _loc1_.gold_tx.embedFonts = true;
         _loc1_.gold_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         var _loc2_:MovieClip = this.spMc.gg_mc;
         _loc2_.time_tx.embedFonts = true;
         _loc2_.time_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,18);
      }
      
      private function initPanel() : void
      {
         this.centerMc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.spMc.gj_mc.visible = false;
         this.spMc.gg_mc.visible = false;
         this.spMc.ov_mc.visible = false;
         this.cdMc.visible = false;
         this.boVT.setValue(GS.a0);
         this.jtNum.setValue(GS.a1);
         this.addEvent();
         this.gk.btnOk(this.state.getValue());
         this.initFrame();
         this.initJl();
         this.gotoBtnFun();
      }
      
      private function initFrame() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ShipGkBasicData = null;
         this.initMc();
         var _loc1_:Array = ShipFactory.getGkByType(this.state.getValue());
         if(_loc1_.length != 0)
         {
            _loc2_ = 0;
            while(_loc2_ < 10)
            {
               if(_loc1_[_loc2_] != null)
               {
                  _loc3_ = _loc1_[_loc2_] as ShipGkBasicData;
                  (this.gkArr[_loc2_] as GoodsBtnX).getSmMc().visible = true;
                  (this.gkArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc3_.getFrame());
                  if(GM.levelSD.getOverProcess(_loc3_.getGkId()) != -1)
                  {
                     (this.gkArr[_loc2_] as GoodsBtnX).getSmMc().key_mc.visible = false;
                  }
                  else
                  {
                     (this.gkArr[_loc2_] as GoodsBtnX).getSmMc().key_mc.visible = true;
                  }
               }
               else
               {
                  (this.gkArr[_loc2_] as GoodsBtnX).getSmMc().visible = false;
               }
               _loc2_++;
            }
         }
      }
      
      private function initJl() : void
      {
         var _loc2_:ShipGkBasicData = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc1_:Array = ShipFactory.getGkByType(this.state.getValue());
         if(_loc1_[this.smType.getValue()] != null)
         {
            _loc2_ = _loc1_[this.smType.getValue()] as ShipGkBasicData;
            _loc3_ = _loc2_.getGsId();
            _loc4_ = 0;
            while(_loc4_ < 20)
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
         this.timer.addEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "f")
         {
            if(param1.id != this.smType.getValue())
            {
               (this.gkArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(1);
            }
         }
         else if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ShipGkBasicData = null;
         var _loc4_:Array = null;
         var _loc5_:Goods = null;
         if(param1.name == "f")
         {
            if(param1.id != this.smType.getValue())
            {
               (this.gkArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(2);
            }
         }
         else if(param1.name == "e")
         {
            _loc2_ = ShipFactory.getGkByType(this.state.getValue());
            _loc3_ = _loc2_[this.smType.getValue()] as ShipGkBasicData;
            _loc4_ = _loc3_.getGsId();
            _loc5_ = GoodsFactory.createGoodsById(_loc4_[param1.id]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc5_));
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "gjclose")
         {
            this.spMc.gj_mc.visible = false;
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
         var _loc3_:ShipGkBasicData = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         if(param1.name == "f")
         {
            this.smType.setValue(param1.id);
            this.initFrame();
            this.gotoBtnFun();
            this.initJl();
         }
         else if(param1.name == "fb")
         {
            _loc2_ = ShipFactory.getGkByType(this.state.getValue());
            _loc3_ = _loc2_[this.smType.getValue()];
            if(GM.levelSD.getOverProcess(_loc3_.getGkId()) != -1)
            {
               if(ShipData.level.getValue() >= _loc3_.getGkLv())
               {
                  if(ShipData.tl.getValue() >= _loc3_.getNeedTl())
                  {
                     _loc4_ = VT.createVT(int(ShipData.tl.getValue() / _loc3_.getNeedTl()));
                     _loc5_ = VT.createVT(ShipFactory.getDataByShLv(ShipData.xlLevel.getValue()).getCs());
                     if(_loc5_.getValue() <= _loc4_.getValue())
                     {
                        this.jtNum.setValue(_loc5_.getValue());
                        this.timeAll.setValue(this.timeGd.getValue() * GS.a60);
                        this.timeSa.setValue(this.timeGd.getValue());
                        this.timeX.setValue(this.timeGd.getValue());
                     }
                     else
                     {
                        this.jtNum.setValue(_loc4_.getValue());
                        this.timeX.setValue(this.timeGd.getValue() / _loc5_.getValue());
                        this.timeAll.setValue(this.timeX.getValue() * this.jtNum.getValue() * GS.a60);
                        this.timeSa.setValue(this.timeX.getValue() * this.jtNum.getValue());
                     }
                     this.initSdData(_loc3_);
                  }
                  else
                  {
                     GoodsManger.cwTs("亲,战舰体力值太少哦!");
                  }
               }
               else
               {
                  GoodsManger.cwTs("亲,战舰等级过低，请找埃罗管家升级!");
               }
            }
            else
            {
               GoodsManger.cwTs("亲,请先满足前一关卡通关需求!");
            }
         }
         else if(param1.name == "j")
         {
            _loc2_ = ShipFactory.getGkByType(this.state.getValue());
            _loc3_ = _loc2_[this.smType.getValue()];
            _loc4_ = VT.createVT(int(ShipData.tl.getValue() / _loc3_.getNeedTl()));
            _loc5_ = VT.createVT(ShipFactory.getDataByShLv(ShipData.xlLevel.getValue()).getCs());
            if(_loc5_.getValue() < _loc4_.getValue())
            {
               if(param1.id == 0)
               {
                  if(this.jtNum.getValue() - _loc5_.getValue() >= _loc5_.getValue())
                  {
                     this.jtNum.setValue(this.jtNum.getValue() - _loc5_.getValue());
                  }
                  else
                  {
                     this.jtNum.setValue(int(_loc4_.getValue() / _loc5_.getValue()) * _loc5_.getValue());
                  }
               }
               else if(param1.id == 1)
               {
                  if(this.jtNum.getValue() + _loc5_.getValue() <= int(_loc4_.getValue() / _loc5_.getValue()) * _loc5_.getValue())
                  {
                     this.jtNum.setValue(this.jtNum.getValue() + _loc5_.getValue());
                  }
                  else
                  {
                     this.jtNum.setValue(_loc5_.getValue());
                  }
               }
               this.timeAll.setValue(this.timeGd.getValue() * GS.a60 * int(this.jtNum.getValue() / _loc5_.getValue()));
               this.timeSa.setValue(this.timeGd.getValue() * int(this.jtNum.getValue() / _loc5_.getValue()));
               this.initSdData(_loc3_);
            }
         }
         else if(param1.name == "k")
         {
            this.spMc.gj_mc.visible = false;
            GoodsManger.movicpStr(0,0,this.startGj,"Ts_143");
         }
         else if(param1.name == "st")
         {
            this.spMc.gg_mc.visible = false;
            this.timer.stop();
            this.closeZd(GS.a1);
         }
         else if(param1.name == "su")
         {
            this.spMc.ov_mc.visible = false;
            this.closePanel();
         }
      }
      
      private function startGj() : void
      {
         this.spMc.gg_mc.visible = true;
         this.timer.start();
         this.boVT.setValue(GS.a1);
      }
      
      private function timeHandle(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.timeAll.getValue() > GS.a0)
         {
            this.timeAll.setValue(this.timeAll.getValue() - GS.a1);
            this.tian = this.timeAll.getValue() / this.k;
            this.shi = (this.timeAll.getValue() - this.tian * this.k) / 3600;
            this.fen = (this.timeAll.getValue() - this.tian * this.k - this.shi * 3600) / 60;
            this.miao = this.timeAll.getValue() - this.tian * this.k - this.shi * 3600 - this.fen * 60;
            if(this.shi >= 10)
            {
               _loc2_ = String(this.shi);
            }
            else
            {
               _loc2_ = "0" + this.shi;
            }
            if(this.fen >= 10)
            {
               _loc3_ = String(this.fen);
            }
            else
            {
               _loc3_ = "0" + this.fen;
            }
            if(this.miao >= 10)
            {
               _loc4_ = String(this.miao);
            }
            else
            {
               _loc4_ = "0" + this.miao;
            }
            this.spMc.gg_mc.time_tx.text = _loc2_ + ":" + _loc3_ + ":" + _loc4_;
         }
         else
         {
            this.boVT.setValue(GS.a0);
            this.timer.stop();
            this.closeZd(GS.a0);
         }
      }
      
      private function closeZd(param1:Number) : void
      {
         var _loc2_:VT = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:ShipGkBasicData = null;
         var _loc6_:uint = 0;
         var _loc7_:VT = null;
         var _loc8_:Array = null;
         this.cuJd = VT.createVT(GS.a0);
         if(param1 == GS.a0)
         {
            this.cuJd.setValue(this.jtNum.getValue());
         }
         else if(param1 == GS.a1)
         {
            _loc2_ = VT.createVT(ShipFactory.getDataByShLv(ShipData.xlLevel.getValue()).getCs());
            this.cuJd.setValue(int((this.timeSa.getValue() - this.timeAll.getValue() / GS.a60) / this.timeX.getValue()) * _loc2_.getValue());
         }
         if(this.cuJd.getValue() <= GS.a0)
         {
            this.spMc.ov_mc.visible = true;
            this.spMc.ov_mc.g_tx.text = "0";
            this.spMc.ov_mc.e_tx.text = "0";
            return;
         }
         _loc3_ = [];
         _loc4_ = ShipFactory.getGkByType(this.state.getValue());
         _loc5_ = _loc4_[this.smType.getValue()];
         ShipData.deleteNj(this.cuJd.getValue());
         ShipData.deleteTl(int(this.cuJd.getValue() * _loc5_.getNeedTl()));
         FlowInterface.addGodByRole(this.cuJd.getValue() * _loc5_.getGold());
         FlowInterface.addExpByRole(this.cuJd.getValue() * _loc5_.getExp());
         this.cdMc.visible = true;
         _loc6_ = 0;
         while(_loc6_ < this.cuJd.getValue())
         {
            _loc7_ = VT.createVT(int(Math.random() * GS.a10000));
            _loc8_ = ShipFactory.getDlLevel(_loc5_.getId(),_loc7_.getValue());
            if(_loc8_.length != GS.a0)
            {
               _loc3_.push(_loc8_);
            }
            _loc6_++;
         }
         if(_loc3_.length != GS.a0)
         {
            GM.levelm.addDiaoLouByGuaJi(_loc3_);
         }
         GoodsManger.dataList.evData.setJd(GS.a10);
         FlowInterface.saveDataByKai(this.saveFun);
      }
      
      private function saveFun() : void
      {
         this.cdMc.visible = false;
         this.spMc.ov_mc.visible = true;
         var _loc1_:Array = ShipFactory.getGkByType(this.state.getValue());
         var _loc2_:ShipGkBasicData = _loc1_[this.smType.getValue()];
         this.spMc.ov_mc.g_tx.text = String(this.cuJd.getValue() * _loc2_.getGold());
         this.spMc.ov_mc.e_tx.text = String(this.cuJd.getValue() * _loc2_.getExp());
         this.jtNum.setValue(GS.a0);
         this.cuJd.setValue(GS.a0);
         this.timeAll.setValue(GS.a0);
         this.boVT.setValue(GS.a0);
         this.timeSa.setValue(GS.a0);
      }
      
      private function initSdData(param1:ShipGkBasicData) : void
      {
         var _loc2_:MovieClip = this.spMc.gj_mc;
         _loc2_.visible = true;
         _loc2_.f_0.gotoAndStop(param1.getFrame());
         _loc2_.yeTx.text = String(this.jtNum.getValue());
         _loc2_.exp_tx.text = String(param1.getExp() * this.jtNum.getValue());
         _loc2_.gold_tx.text = String(param1.getGold() * this.jtNum.getValue());
         _loc2_.tl_tx.text = "次消耗" + param1.getNeedTl() * this.jtNum.getValue() + "体力值";
         _loc2_.time_tx.text = String((this.timeSa.getValue() / GS.a60).toFixed(1) + "( 小时)");
      }
      
      private function inFbArr() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.gkArr.length)
         {
            (this.gkArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function gotoBtnFun() : void
      {
         this.inFbArr();
         (this.gkArr[this.smType.getValue()] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(3);
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            if(_loc1_ == this.smType.getValue())
            {
               this.spMc["fb_" + _loc1_].visible = true;
            }
            else
            {
               this.spMc["fb_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            (this.gkArr[_loc1_] as GoodsBtnX).getSmMc().key_mc.visible = false;
            (this.gkArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.gotoAndStop(1);
            (this.gkArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 20)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.removeEventListener(TimerEvent.TIMER,this.timeHandle);
      }
   }
}

