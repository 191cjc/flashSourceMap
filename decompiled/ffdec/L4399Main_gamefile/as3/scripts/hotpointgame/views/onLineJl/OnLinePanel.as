package hotpointgame.views.onLineJl
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.timeJl.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.shopPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class OnLinePanel extends MovieClip
   {
      
      private static var _instance:OnLinePanel;
      
      private static var cbx:Number = -1;
      
      private var state:VT = VT.createVT(0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var oLMc:MovieClip = new MovieClip();
      
      private var tbArr:Array = [];
      
      private var _sxDisplay:SxPanel;
      
      private var timer:Timer;
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var lqArr:Array = [];
      
      public function OnLinePanel()
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
               _loc1_.push("online");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadOlOver;
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
      
      private static function loadOlOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:CloseBtnX = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:ClickBtnX = null;
         var _loc9_:MovieClip = null;
         var _loc10_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new OnLinePanel();
            _loc1_ = LoaderManager.getSwfClass("OnLine_mc") as Class;
            _instance.oLMc = new _loc1_();
            _loc2_ = _instance.oLMc;
            _instance.addChild(_loc2_);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc3_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc4_ = 1;
            while(_loc4_ < 5)
            {
               _loc6_ = [];
               _loc7_ = 0;
               while(_loc7_ < 4)
               {
                  _loc9_ = new _loc3_();
                  _loc9_.name = "s_" + _loc4_ + _loc7_;
                  _loc10_ = new GoodsBtnX(_loc9_,_loc2_["data_" + _loc4_]["d_" + _loc7_].x,_loc2_["data_" + _loc4_]["d_" + _loc7_].y);
                  _loc2_["data_" + _loc4_].addChild(_loc10_);
                  _loc6_[_loc7_] = _loc10_;
                  _loc7_++;
               }
               _instance.tbArr[_loc4_] = _loc6_;
               _loc8_ = new ClickBtnX(_loc2_["b_" + _loc4_],_loc2_["b_" + _loc4_].x,_loc2_["b_" + _loc4_].y);
               _loc2_.addChild(_loc8_);
               _instance.lqArr[_loc4_] = _loc8_;
               _loc4_++;
            }
            _loc5_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc5_);
            _instance.timer = new Timer(GS.a1000,GS.a0);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.centerMc.addChild(this._sxDisplay);
         this.addEvent();
         this.initFrame();
         this.initBtn();
         this.timer.start();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.addEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function timeHandle(param1:TimerEvent) : void
      {
         var _loc2_:uint = 1;
         while(_loc2_ < 5)
         {
            this.oLMc["data_" + _loc2_].d_tx.text = this.timeDisplay(GoodsManger.dataList.onLData.getDjs(_loc2_));
            _loc2_++;
         }
      }
      
      private function timeDisplay(param1:Number) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Number = param1;
         this.tian = _loc2_ / this.k;
         this.shi = (_loc2_ - this.tian * this.k) / 3600;
         this.fen = (_loc2_ - this.tian * this.k - this.shi * 3600) / 60;
         this.miao = _loc2_ - this.tian * this.k - this.shi * 3600 - this.fen * 60;
         if(this.shi >= 10)
         {
            _loc3_ = String(this.shi);
         }
         else
         {
            _loc3_ = "0" + this.shi;
         }
         if(this.fen >= 10)
         {
            _loc4_ = String(this.fen);
         }
         else
         {
            _loc4_ = "0" + this.fen;
         }
         if(this.miao >= 10)
         {
            _loc5_ = String(this.miao);
         }
         else
         {
            _loc5_ = "0" + this.miao;
         }
         return _loc3_ + ":" + _loc4_ + ":" + _loc5_;
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1.name == "s")
         {
            _loc2_ = String(param1.id);
            _loc3_ = Number(_loc2_.substr(0,1));
            _loc4_ = Number(_loc2_.substr(1,1));
            (this.tbArr[_loc3_][_loc4_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:TimeJlBasicData = null;
         var _loc6_:Array = null;
         var _loc7_:Goods = null;
         if(param1.name == "s")
         {
            _loc2_ = String(param1.id);
            _loc3_ = Number(_loc2_.substr(0,1));
            _loc4_ = Number(_loc2_.substr(1,1));
            (this.tbArr[_loc3_][_loc4_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            _loc5_ = TimeJlFactory.getDataById(_loc3_,ShopData.getJd());
            _loc6_ = _loc5_.getGsId();
            _loc7_ = GoodsFactory.createGoodsById(_loc6_[_loc4_]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc7_));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:TimeJlBasicData = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(param1.name == "b")
         {
            _loc2_ = TimeJlFactory.getDataById(param1.id,ShopData.getJd());
            _loc3_ = _loc2_.getGsId();
            _loc4_ = _loc2_.getGsNum();
            if(GoodsManger.dataList.onLData.getOver(param1.id) == GS.a1)
            {
               if(GoodsManger.dataList.onLData.getLq(param1.id) == GS.a0)
               {
                  if(BagFactory.isFullBag(_loc3_,_loc4_))
                  {
                     BagFactory.addBagArr(_loc3_,_loc4_);
                     GoodsManger.dataList.onLData.setLq(param1.id,GS.a1);
                     this.initBtn();
                     GoodsManger.dataList.evData.setJd(GS.a11);
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
               else
               {
                  GoodsManger.cwTs("已领取");
               }
            }
            else
            {
               GoodsManger.cwTs("倒计时未结束");
            }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.removeEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function initFrame() : void
      {
         var _loc2_:TimeJlBasicData = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         this.initMc();
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            _loc2_ = TimeJlFactory.getDataById(_loc1_,ShopData.getJd());
            _loc3_ = _loc2_.getGsId();
            _loc4_ = _loc2_.getGsNum();
            this.oLMc["data_" + _loc1_].t_tx.text = String(_loc2_.getTime() + "分钟");
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               (this.tbArr[_loc1_][_loc5_] as GoodsBtnX).visible = true;
               (this.tbArr[_loc1_][_loc5_] as GoodsBtnX).getSmMc().t_txt.text = _loc4_[_loc5_];
               (this.tbArr[_loc1_][_loc5_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc3_[_loc5_]).getFrame());
               _loc5_++;
            }
            _loc1_++;
         }
      }
      
      private function initBtn() : void
      {
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            if(GoodsManger.dataList.onLData.getLq(_loc1_) == GS.a0)
            {
               (this.lqArr[_loc1_] as ClickBtnX).okBtn = true;
            }
            else
            {
               (this.lqArr[_loc1_] as ClickBtnX).okBtn = false;
            }
            _loc1_++;
         }
      }
      
      private function initMc() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               (this.tbArr[_loc1_][_loc2_] as GoodsBtnX).visible = false;
               (this.tbArr[_loc1_][_loc2_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.tbArr[_loc1_][_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               (this.tbArr[_loc1_][_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.tbArr[_loc1_][_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               _loc2_++;
            }
            _loc1_++;
         }
      }
   }
}

