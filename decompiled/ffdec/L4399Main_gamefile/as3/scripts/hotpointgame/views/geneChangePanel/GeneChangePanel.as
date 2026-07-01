package hotpointgame.views.geneChangePanel
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
   import hotpointgame.repository.geneChange.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.vipPanel.*;
   
   public class GeneChangePanel extends MovieClip
   {
      
      private static var _instance:GeneChangePanel;
      
      private static var cbx:Number = -1;
      
      private var geneMc:MovieClip;
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var typeBtn:SameChangeBtnX;
      
      private var _sxDisplay:SxPanel;
      
      private var currId:VT = VT.createVT(GS.a5);
      
      private var playerId:VT = VT.createVT(-1);
      
      private var tbBoxArr:Array = [];
      
      private var boVt:VT = VT.createVT(-1);
      
      private var testId:VT = VT.createVT(-1);
      
      private var time:Timer;
      
      private var czMc:MovieClip;
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var mbTime:VT = VT.createVT(0);
      
      private var wmzArr:Array = [];
      
      private var czingMc:MovieClip = new MovieClip();
      
      private var goodsX:GoodsBtnX;
      
      private var gsX:Goods = null;
      
      private var gsArr:Array = [];
      
      private var cdMc:MovieClip;
      
      public function GeneChangePanel()
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
               _loc1_.push("genechangepenel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadGeneOver;
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
      
      public static function loadGeneOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ClickBtnX = null;
         var _loc3_:ClickBtnX = null;
         var _loc4_:CloseBtnX = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:MovieClip = null;
         var _loc15_:GoodsBtnX = null;
         var _loc16_:MovieClip = null;
         var _loc17_:ClickBtnX = null;
         var _loc18_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new GeneChangePanel();
            _loc1_ = LoaderManager.getSwfClass("GeneChange") as Class;
            _instance.geneMc = new _loc1_();
            _instance.addChild(_instance.geneMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _instance.typeBtn = SameChangeBtnX.createSameChangeBtn(new Array(_instance.geneMc.t_0,_instance.geneMc.t_1,_instance.geneMc.t_2,_instance.geneMc.t_3,_instance.geneMc.t_4,_instance.geneMc.t_5,_instance.geneMc.t_6));
            _instance.geneMc.addChild(_instance.typeBtn);
            _loc2_ = new ClickBtnX(_instance.geneMc.start_btn,_instance.geneMc.start_btn.x,_instance.geneMc.start_btn.y);
            _instance.geneMc.addChild(_loc2_);
            _loc3_ = new ClickBtnX(_instance.geneMc.time_mc.lkok_btn,_instance.geneMc.time_mc.lkok_btn.x,_instance.geneMc.time_mc.lkok_btn.y);
            _instance.geneMc.time_mc.addChild(_loc3_);
            _loc4_ = new CloseBtnX(_instance.geneMc.close_btn,_instance.geneMc.close_btn.x,_instance.geneMc.close_btn.y);
            _instance.geneMc.addChild(_loc4_);
            _loc5_ = LoaderManager.getSwfClass("Ts_86") as Class;
            _loc6_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc7_ = new _loc6_();
            _loc7_.name = "gsx_0";
            _instance.goodsX = new GoodsBtnX(_loc7_,_instance.geneMc.bd.x,_instance.geneMc.bd.y);
            _instance.geneMc.addChild(_instance.goodsX);
            _loc8_ = 0;
            while(_loc8_ < 3)
            {
               _loc14_ = new _loc6_();
               _loc14_.name = "e_" + _loc8_;
               _loc15_ = new GoodsBtnX(_loc14_,_instance.geneMc.tk_0["td_" + _loc8_].x,_instance.geneMc.tk_0["td_" + _loc8_].y);
               _instance.tbBoxArr.push(_loc15_);
               _instance.geneMc.tk_0.addChild(_loc15_);
               _loc16_ = new _loc5_();
               _loc16_.x = _instance.geneMc.tk_0["td_" + _loc8_].x;
               _loc16_.y = _instance.geneMc.tk_0["td_" + _loc8_].y;
               _instance.wmzArr.push(_loc16_);
               _instance.geneMc.tk_0.addChild(_loc16_);
               _loc8_++;
            }
            _loc8_ = 0;
            while(_loc8_ < 2)
            {
               _loc17_ = new ClickBtnX(_instance.geneMc.tk_0["ok_" + _loc8_],_instance.geneMc.tk_0["ok_" + _loc8_].x,_instance.geneMc.tk_0["ok_" + _loc8_].y);
               _instance.geneMc.tk_0.addChild(_loc17_);
               _loc8_++;
            }
            _loc8_ = 0;
            while(_loc8_ < 2)
            {
               _loc18_ = new ClickBtnX(_instance.geneMc.zr_mc["sur_" + _loc8_],_instance.geneMc.zr_mc["sur_" + _loc8_].x,_instance.geneMc.zr_mc["sur_" + _loc8_].y);
               _instance.geneMc.zr_mc.addChild(_loc18_);
               _loc8_++;
            }
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
            _loc13_ = LoaderManager.getSwfClass("Tm_mc") as Class;
            _instance.cdMc = new _loc13_();
            _instance.upMc.addChild(_instance.cdMc);
            _loc8_ = 0;
            while(_loc8_ < 7)
            {
               _instance.geneMc["h_" + _loc8_].mouseChildren = false;
               _instance.geneMc["h_" + _loc8_].mouseEnabled = false;
               _instance.geneMc.addChild(_instance.geneMc["h_" + _loc8_]);
               _loc8_++;
            }
            _instance.time = new Timer(GS.a100,GS.a0);
            _instance.topMc.addChild(_instance.geneMc.tk_0);
            _instance.topMc.addChild(_instance.geneMc.do_mv);
            _instance.centerMc.addChild(_instance.geneMc.zr_mc);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.textFun();
            _instance.initPanel();
         }
      }
      
      private function textFun() : void
      {
         this.geneMc.name_text.embedFonts = true;
         this.geneMc.name_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.lv_text.embedFonts = true;
         this.geneMc.lv_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.sm_tx.embedFonts = true;
         this.geneMc.sm_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.need_lv.embedFonts = true;
         this.geneMc.need_lv.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.need_gold.embedFonts = true;
         this.geneMc.need_gold.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.need_goods.embedFonts = true;
         this.geneMc.need_goods.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.currMc.curr_sm.embedFonts = true;
         this.geneMc.currMc.curr_sm.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.geneMc.time_mc.time_tx.embedFonts = true;
         this.geneMc.time_mc.time_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,22);
         this.geneMc.time_mc.zawuxingzs.embedFonts = true;
         this.geneMc.time_mc.zawuxingzs.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
      }
      
      public function initPanel() : void
      {
         this.visible = true;
         this.geneMc.p_mc.gotoAndStop(FlowInterface.getJobByRole());
         this.initMc();
         this.initBag();
         this.addEvent();
         this.playerId.setValue(FlowInterface.getJobByRole());
         this.typeBtn.btnOk(this.currId.getValue());
         this.initData();
         if(GeneData.mvBo == false)
         {
            GeneData.mvBo = true;
            this.geneMc.do_mv.visible = true;
         }
         this.initZzData();
      }
      
      public function initData() : void
      {
         var _loc3_:GoodsSkillData = null;
         var _loc4_:GoodsSkillData = null;
         this.initJsmc();
         this.geneMc["m_" + this.currId.getValue()].visible = true;
         var _loc1_:GeneChangeData = GeneChangeFactory.getGeneByData(this.playerId.getValue(),this.currId.getValue());
         var _loc2_:VT = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
         this.geneMc.name_text.text = GeneData.getTypeNameByType(this.currId.getValue());
         if(_loc2_.getValue() == GS.a0)
         {
            this.geneMc.currMc.curr_sm.text = String("无数据");
            this.geneMc.lv_text.text = String(GS.a0);
         }
         else
         {
            this.geneMc.lv_text.text = String(_loc2_.getValue());
            _loc3_ = GoodsSkillFactory.getSkillDataById(_loc1_.getSkillId(_loc2_.getValue()));
            this.geneMc.currMc.curr_sm.text = _loc3_.getSm();
         }
         if(_loc2_.getValue() + GS.a1 <= GeneData.maxLevel.getValue())
         {
            _loc4_ = GoodsSkillFactory.getSkillDataById(_loc1_.getSkillId(_loc2_.getValue() + GS.a1));
            this.geneMc.sm_tx.text = _loc4_.getSm();
            this.geneMc.need_lv.text = String(_loc1_.getPlayerLevel(_loc2_.getValue() + GS.a1));
            this.geneMc.need_gold.text = String(_loc1_.getGold(_loc2_.getValue() + GS.a1));
            this.geneMc.need_goods.text = GoodsFactory.getGoodsById(_loc1_.getGoodsId(_loc2_.getValue() + GS.a1)).getName() + "*" + _loc1_.getGoodsNum(_loc2_.getValue() + GS.a1);
            this.goodsX.getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc1_.getGoodsId(_loc2_.getValue() + GS.a1)).getFrame());
            this.gsX = GoodsFactory.getGoodsById(_loc1_.getGoodsId(_loc2_.getValue() + GS.a1)).createGoods();
         }
         else
         {
            this.geneMc.sm_tx.text = "暂无数据";
            this.geneMc.need_lv.text = "暂无数据";
            this.geneMc.need_gold.text = "暂无数据";
            this.geneMc.need_goods.text = "暂无数据";
            this.goodsX.getSmMc().gotoAndStop(1);
            this.gsX = null;
         }
      }
      
      private function initMc() : void
      {
         this.geneMc.time_mc.visible = false;
         this.geneMc.time_mc.preloader.gotoAndStop(1);
         this.initJsmc();
         this.geneMc.tk_0.visible = false;
         this.geneMc.zr_mc.visible = false;
         this.czMc.visible = false;
         this.czingMc.visible = false;
         this.initTbMc();
         this.goodsX.getSmMc().t_txt.text = "";
         this.goodsX.getSmMc().gotoAndStop(1);
         this.goodsX.getSmMc().mask_mc.gotoAndStop(1);
         this.goodsX.getSmMc().gx_mc.visible = false;
         this.cdMc.visible = false;
         GeneData.tsBo = false;
         this.geneMc.do_mv.visible = false;
         this.geneMc.do_mv.gotoAndStop(1);
         this.initZz();
      }
      
      private function initZzData() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            if(GeneData.isOpen(_loc1_) == GS.a1)
            {
               this.geneMc["h_" + _loc1_].visible = false;
            }
            else
            {
               this.geneMc["h_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function initBag() : void
      {
         this.centerMc.addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.time.addEventListener(TimerEvent.TIMER,this.timeHandle);
         this.time.start();
         addEventListener(MouseEvent.CLICK,this.clickMv);
      }
      
      private function clickMv(param1:MouseEvent) : void
      {
         if(this.geneMc.do_mv.visible)
         {
            if(this.geneMc.do_mv.currentFrame < this.geneMc.do_mv.totalFrames)
            {
               this.geneMc.do_mv.gotoAndStop(this.geneMc.do_mv.currentFrame + 1);
            }
            else
            {
               this.geneMc.do_mv.visible = false;
            }
         }
      }
      
      private function timeHandle(param1:TimerEvent) : void
      {
         var _loc2_:VT = null;
         if(this.testId.getValue() == -1)
         {
            if(GeneData.getLoadState(this.currId.getValue()) == GS.a0)
            {
               if(this.geneMc.time_mc.visible == true)
               {
                  this.geneMc.time_mc.visible = false;
               }
               if(this.geneMc.zr_mc.visible == true)
               {
                  this.geneMc.zr_mc.visible = false;
               }
            }
            else if(GeneData.getLoadState(this.currId.getValue()) == GS.a1)
            {
               if(GeneData.getMbTime(this.currId.getValue()) != -1 && GeneData.getBeForeTime(this.currId.getValue()) != -1)
               {
                  if(this.geneMc.time_mc.visible == false)
                  {
                     this.geneMc.time_mc.visible = true;
                     this.geneMc.zr_mc.visible = false;
                     _loc2_ = VT.createVT(GeneData.getTimes());
                     this.mbTime.setValue(GeneData.getTimebyTimes(_loc2_.getValue()) * GS.a60);
                  }
                  else
                  {
                     this.timeDisplay();
                     this.loadDisplay();
                  }
               }
            }
            else if(GeneData.getLoadState(this.currId.getValue()) == GS.a2)
            {
               if(this.geneMc.zr_mc.visible == false)
               {
                  this.geneMc.zr_mc.visible = true;
                  this.geneMc.time_mc.visible = false;
                  this.loadOver();
               }
            }
         }
         else
         {
            if(this.geneMc.time_mc.visible == true)
            {
               this.geneMc.time_mc.visible = false;
            }
            if(this.geneMc.zr_mc.visible == true)
            {
               this.geneMc.zr_mc.visible = false;
            }
         }
      }
      
      private function timeDisplay() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:Number = Number(GeneData.getXsTime(this.currId.getValue()));
         this.tian = _loc1_ / this.k;
         this.shi = (_loc1_ - this.tian * this.k) / 3600;
         this.fen = (_loc1_ - this.tian * this.k - this.shi * 3600) / 60;
         this.miao = _loc1_ - this.tian * this.k - this.shi * 3600 - this.fen * 60;
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
         this.geneMc.time_mc.time_tx.text = _loc2_ + ":" + _loc3_ + ":" + _loc4_;
      }
      
      private function loadDisplay() : void
      {
         var _loc1_:Number = Number(GeneData.getXsTime(this.currId.getValue()));
         this.geneMc.time_mc.preloader.gotoAndStop(int((this.mbTime.getValue() - _loc1_) / this.mbTime.getValue() * 100));
      }
      
      private function loadOver() : void
      {
         var _loc1_:GeneChangeData = GeneChangeFactory.getGeneByData(this.playerId.getValue(),this.currId.getValue());
         var _loc2_:VT = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
         var _loc3_:VT = VT.createVT(_loc1_.getGl(_loc2_.getValue() + GS.a1));
         var _loc4_:VT = VT.createVT(_loc1_.getDjGl(_loc2_.getValue() + GS.a1));
         var _loc5_:VT = VT.createVT(_loc1_.getDjGold(_loc2_.getValue() + GS.a1));
         if(VipData.vip.getValue() != -1)
         {
            if(VipData.vip.getValue() == GS.a3)
            {
               _loc3_.setValue(_loc3_.getValue() + GS.a10000 * (GS.a2 / GS.a100));
               _loc4_.setValue(_loc4_.getValue() + GS.a10000 * (GS.a2 / GS.a100));
            }
            else if(VipData.vip.getValue() == GS.a4)
            {
               _loc3_.setValue(_loc3_.getValue() + GS.a10000 * (GS.a4 / GS.a100));
               _loc4_.setValue(_loc4_.getValue() + GS.a10000 * (GS.a4 / GS.a100));
            }
            else if(VipData.vip.getValue() >= GS.a5)
            {
               _loc3_.setValue(_loc3_.getValue() + GS.a10000 * (GS.a5 / GS.a100));
               _loc4_.setValue(_loc4_.getValue() + GS.a10000 * (GS.a5 / GS.a100));
            }
         }
         this.geneMc.zr_mc.gold_text.text = String(_loc3_.getValue() / 100 + "%");
         this.geneMc.zr_mc.dj_text.text = "需求星钻:" + _loc5_.getValue() + "\n" + "概率增加至:" + String(_loc4_.getValue() / 100 + "%");
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         var _loc2_:VT = null;
         var _loc3_:GeneChangeData = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         if(param1.name == "t")
         {
            if(GeneData.isOpen(param1.id) == GS.a1)
            {
               this.currId.setValue(param1.id);
               this.typeBtn.btnOk(this.currId.getValue());
               _loc2_ = VT.createVT(GeneData.getLoadState(this.currId.getValue()));
               if(_loc2_.getValue() != GS.a1)
               {
                  if(_loc2_.getValue() == GS.a2)
                  {
                  }
               }
            }
            else
            {
               this.geneMc.tk_0.visible = true;
               this.testId.setValue(param1.id);
               _loc3_ = GeneChangeFactory.getGeneByData(this.playerId.getValue(),param1.id);
               _loc4_ = _loc3_.getOpenId();
               _loc5_ = _loc3_.getOpenNum();
               this.boVt.setValue(GS.a0);
               _loc6_ = 0;
               while(_loc6_ < 3)
               {
                  (this.tbBoxArr[_loc6_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc4_[_loc6_]).getFrame());
                  (this.tbBoxArr[_loc6_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc5_[_loc6_]);
                  if(BagFactory.getNumById(_loc4_[_loc6_]) < _loc5_[_loc6_])
                  {
                     this.boVt.setValue(-1);
                     (this.wmzArr[_loc6_] as MovieClip).visible = true;
                  }
                  this.gsArr[_loc6_] = GoodsFactory.getGoodsById(_loc4_[_loc6_]).createGoods();
                  _loc6_++;
               }
            }
            this.initData();
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "t")
         {
            this.initJsmc();
            this.geneMc["m_" + this.currId.getValue()].visible = true;
         }
         else if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "gsx")
         {
            this.goodsX.getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         if(param1.name == "t")
         {
            this.geneMc["m_" + param1.id].visible = true;
            if(param1.id != this.currId.getValue())
            {
               this.geneMc["m_" + this.currId.getValue()].visible = false;
            }
         }
         else if(param1.name == "e")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.gsArr[param1.id]));
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         else if(param1.name == "gsx")
         {
            if(this.gsX != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.gsX));
               this.goodsX.getSmMc().gx_mc.visible = true;
            }
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:GeneChangeData = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:VT = null;
         var _loc6_:VT = null;
         var _loc7_:VT = null;
         var _loc8_:VT = null;
         var _loc9_:VT = null;
         var _loc10_:VT = null;
         var _loc11_:VT = null;
         var _loc12_:VT = null;
         var _loc13_:VT = null;
         var _loc14_:VT = null;
         var _loc15_:VT = null;
         var _loc16_:VT = null;
         var _loc17_:VT = null;
         var _loc18_:VT = null;
         if(param1.name == "ok")
         {
            this.geneMc.tk_0.visible = false;
            if(param1.id == GS.a0)
            {
               if(this.boVt.getValue() == GS.a0)
               {
                  _loc2_ = GeneChangeFactory.getGeneByData(this.playerId.getValue(),this.testId.getValue());
                  _loc3_ = _loc2_.getOpenId();
                  _loc4_ = _loc2_.getOpenNum();
                  BagFactory.deleteArrGoods(_loc3_,_loc4_);
                  GeneData.openType(this.testId.getValue());
                  this.currId.setValue(this.testId.getValue());
                  GoodsManger.cwTs("已开启新的基因改造部位");
               }
               else
               {
                  GoodsManger.cwTs("满足驱动条件才可开启装置");
               }
            }
            this.typeBtn.btnOk(this.currId.getValue());
            this.initData();
            this.testId.setValue(-1);
            this.initZzData();
         }
         else if(param1.name == "start")
         {
            if(GeneData.getLoadState(this.currId.getValue()) == GS.a0)
            {
               _loc2_ = GeneChangeFactory.getGeneByData(this.playerId.getValue(),this.currId.getValue());
               _loc5_ = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
               if(_loc5_.getValue() + GS.a1 <= GeneData.maxLevel.getValue())
               {
                  _loc6_ = VT.createVT(_loc2_.getPlayerLevel(_loc5_.getValue() + GS.a1));
                  _loc7_ = VT.createVT(_loc2_.getGold(_loc5_.getValue() + GS.a1));
                  _loc8_ = VT.createVT(_loc2_.getGoodsId(_loc5_.getValue() + GS.a1));
                  _loc9_ = VT.createVT(_loc2_.getGoodsNum(_loc5_.getValue() + GS.a1));
                  _loc10_ = VT.createVT(GeneData.getTimes());
                  _loc11_ = VT.createVT(GeneData.getLkGold(_loc10_.getValue()));
                  if(FlowInterface.getLevelByRole() >= _loc6_.getValue())
                  {
                     if(FlowInterface.getGodByRole() >= _loc7_.getValue())
                     {
                        if(BagFactory.getNumById(_loc8_.getValue()) >= _loc9_.getValue())
                        {
                           FlowInterface.redGodByRole(_loc7_.getValue());
                           BagFactory.deteleGoods(_loc8_.getValue(),_loc9_.getValue());
                           GeneData.setLoadState(this.currId.getValue(),GS.a1);
                           this.setBeginimeData();
                           this.geneMc.time_mc.zawuxingzs.text = String(_loc11_.getValue());
                           FlowInterface.saveDataByKai();
                        }
                        else
                        {
                           GoodsManger.cwTs("改造需求物品数量不足");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("晶币不足");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("等级不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("已达改造上限");
               }
            }
            else
            {
               GoodsManger.cwTs("基因正在改造当中……");
            }
         }
         else if(param1.name == "sur")
         {
            _loc2_ = GeneChangeFactory.getGeneByData(this.playerId.getValue(),this.currId.getValue());
            _loc5_ = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
            _loc12_ = VT.createVT(_loc2_.getGl(_loc5_.getValue() + GS.a1));
            _loc13_ = VT.createVT(_loc2_.getDjGl(_loc5_.getValue() + GS.a1));
            _loc14_ = VT.createVT(_loc2_.getSkillId(_loc5_.getValue() + GS.a1));
            _loc15_ = VT.createVT(_loc2_.getDjId(_loc5_.getValue() + GS.a1));
            _loc16_ = VT.createVT(_loc2_.getDjGold(_loc5_.getValue() + GS.a1));
            if(param1.id == 0)
            {
               _loc17_ = VT.createVT(int(Math.random() * GS.a10000));
               if(VipData.vip.getValue() != -1)
               {
                  if(VipData.vip.getValue() == GS.a3)
                  {
                     _loc12_.setValue(_loc12_.getValue() + GS.a10000 * (GS.a2 / GS.a100));
                  }
                  else if(VipData.vip.getValue() == GS.a4)
                  {
                     _loc12_.setValue(_loc12_.getValue() + GS.a10000 * (GS.a4 / GS.a100));
                  }
                  else if(VipData.vip.getValue() >= GS.a5)
                  {
                     _loc12_.setValue(_loc12_.getValue() + GS.a10000 * (GS.a5 / GS.a100));
                  }
               }
               if(_loc17_.getValue() <= _loc12_.getValue())
               {
                  GeneData.setGeneSkill(this.currId.getValue(),_loc14_.getValue());
                  GeneData.addLevelByType(this.currId.getValue());
                  GeneData.clearLoadData(this.currId.getValue());
                  this.cdMc.visible = true;
                  FlowInterface.saveDataByKai(this.goldZrOkMv);
               }
               else if(VipData.vip.getValue() < GS.a6)
               {
                  GeneData.clearLoadData(this.currId.getValue());
                  GeneData.removeLevelByType(this.currId.getValue());
                  _loc5_ = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
                  _loc14_ = VT.createVT(_loc2_.getSkillId(_loc5_.getValue()));
                  GeneData.setGeneSkill(this.currId.getValue(),_loc14_.getValue());
                  this.cdMc.visible = true;
                  FlowInterface.saveDataByKai(this.goldZrLostMv);
               }
               else
               {
                  this.cdMc.visible = true;
                  GeneData.clearLoadData(this.currId.getValue());
                  FlowInterface.saveDataByKai(this.goldZrLostMv);
               }
            }
            else if(param1.id == 1)
            {
               this.czingMc.visible = true;
               FlowInterface.djGouMai(_loc15_.getValue(),GS.a1,_loc16_.getValue(),this.shopGene,GS.a0);
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
         else if(param1.name == "lkok")
         {
            _loc10_ = VT.createVT(GeneData.getTimes());
            _loc18_ = VT.createVT(GeneData.getLkId(_loc10_.getValue()));
            _loc11_ = VT.createVT(GeneData.getLkGold(_loc10_.getValue()));
            this.czingMc.visible = true;
            FlowInterface.djGouMai(_loc18_.getValue(),GS.a1,_loc11_.getValue(),this.shopLk,GS.a0);
         }
      }
      
      public function goldZrOkMv() : void
      {
         this.cdMc.visible = false;
         GoodsManger.movicpStr(0,0,this.goldZrOk,"Ts_80");
      }
      
      public function goldZrOk() : void
      {
         GoodsManger.cwTs("改造成功");
         if(this.visible)
         {
            this.geneMc.zr_mc.visible = false;
            this.initData();
            BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
         }
      }
      
      public function goldZrLostMv() : void
      {
         this.cdMc.visible = false;
         GoodsManger.movicpStr(0,0,this.goldZrLost,"Ts_80");
      }
      
      public function goldZrLost() : void
      {
         GoodsManger.cwTs("改造失败");
         if(this.visible)
         {
            this.geneMc.zr_mc.visible = false;
            this.initData();
            BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
         }
      }
      
      public function djZrOkMv() : void
      {
         this.cdMc.visible = false;
         GoodsManger.movicpStr(0,0,this.djZrOk,"Ts_80");
      }
      
      public function djZrOk() : void
      {
         GoodsManger.cwTs("改造成功");
         if(this.visible)
         {
            this.geneMc.zr_mc.visible = false;
            this.initData();
            BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
         }
      }
      
      public function djZrLostMv() : void
      {
         this.cdMc.visible = false;
         GoodsManger.movicpStr(0,0,this.djZrLost,"Ts_80");
      }
      
      public function djZrLost() : void
      {
         GoodsManger.cwTs("改造失败");
         if(this.visible)
         {
            this.geneMc.zr_mc.visible = false;
            this.initData();
            BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
         }
      }
      
      private function shopLk(param1:Number) : void
      {
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            GeneData.setLoadState(this.currId.getValue(),GS.a2);
            FlowInterface.saveDataByKaiOnlyShop();
         }
         else
         {
            this.czMc.visible = true;
         }
         this.geneMc.time_mc.visible = false;
      }
      
      private function shopGene(param1:Number) : void
      {
         var _loc2_:GeneChangeData = null;
         var _loc3_:VT = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         var _loc6_:VT = null;
         var _loc7_:VT = null;
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            _loc2_ = GeneChangeFactory.getGeneByData(this.playerId.getValue(),this.currId.getValue());
            _loc3_ = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
            _loc4_ = VT.createVT(_loc2_.getGl(_loc3_.getValue() + GS.a1));
            _loc5_ = VT.createVT(_loc2_.getDjGl(_loc3_.getValue() + GS.a1));
            _loc6_ = VT.createVT(_loc2_.getSkillId(_loc3_.getValue() + GS.a1));
            _loc7_ = VT.createVT(int(Math.random() * GS.a10000));
            if(VipData.vip.getValue() == GS.a3)
            {
               _loc5_.setValue(_loc5_.getValue() + GS.a10000 * (GS.a2 / GS.a100));
            }
            else if(VipData.vip.getValue() == GS.a4)
            {
               _loc5_.setValue(_loc5_.getValue() + GS.a10000 * (GS.a4 / GS.a100));
            }
            else if(VipData.vip.getValue() >= GS.a6)
            {
               _loc5_.setValue(_loc5_.getValue() + GS.a10000 * (GS.a5 / GS.a100));
            }
            if(_loc7_.getValue() <= _loc5_.getValue())
            {
               GeneData.setGeneSkill(this.currId.getValue(),_loc6_.getValue());
               GeneData.addLevelByType(this.currId.getValue());
               GeneData.addTimes();
               GeneData.clearLoadData(this.currId.getValue());
               this.cdMc.visible = true;
               FlowInterface.saveDataByKaiOnlyShop(this.djZrOkMv);
            }
            else if(VipData.vip.getValue() < GS.a6)
            {
               GeneData.removeLevelByType(this.currId.getValue());
               GeneData.addTimes();
               GeneData.clearLoadData(this.currId.getValue());
               _loc3_ = VT.createVT(GeneData.getLevelByType(this.currId.getValue()));
               _loc6_ = VT.createVT(_loc2_.getSkillId(_loc3_.getValue()));
               GeneData.setGeneSkill(this.currId.getValue(),_loc6_.getValue());
               this.cdMc.visible = true;
               FlowInterface.saveDataByKaiOnlyShop(this.djZrLostMv);
            }
            else
            {
               GeneData.clearLoadData(this.currId.getValue());
               this.cdMc.visible = true;
               FlowInterface.saveDataByKaiOnlyShop(this.djZrLostMv);
            }
         }
         else
         {
            this.czMc.visible = true;
         }
         this.geneMc.zr_mc.visible = false;
      }
      
      private function setBeginimeData() : void
      {
         GM.testapi.getServerTimerByH(this.setBeginTime);
      }
      
      private function setBeginTime(param1:Number) : void
      {
         var _loc2_:VT = VT.createVT(GeneData.getTimes());
         var _loc3_:VT = VT.createVT(GeneData.getTimebyTimes(_loc2_.getValue()) * GS.a60);
         GeneData.setMbtimeXX(this.currId.getValue(),_loc3_.getValue());
         GeneData.setMbTime(this.currId.getValue(),getTimer() / GS.a1000 + _loc3_.getValue());
         GeneData.setBeForeTime(this.currId.getValue(),param1);
         GeneData.addTimes();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.time.stop();
         this.time.removeEventListener(TimerEvent.TIMER,this.timeHandle);
         removeEventListener(MouseEvent.CLICK,this.clickMv);
      }
      
      private function initJsmc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            this.geneMc["m_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function initZz() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            this.geneMc["h_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function initTbMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.wmzArr[_loc1_] as MovieClip).visible = false;
            (this.wmzArr[_loc1_] as MovieClip).mouseChildren = false;
            (this.wmzArr[_loc1_] as MovieClip).mouseEnabled = false;
            _loc1_++;
         }
      }
   }
}

