package hotpointgame.views.gxShop
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.gxShop.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class GxShopPanel extends MovieClip
   {
      
      private static var _instance:GxShopPanel;
      
      private static var cbx:Number = -1;
      
      private var gxMc:MovieClip;
      
      private var tbBoxArr:Array = [];
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var rMc:MovieClip = new MovieClip();
      
      private var _sxDisplay:SxPanel;
      
      private var ye:VT = VT.createVT(GS.a0);
      
      public function GxShopPanel()
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
               _loc1_.push("gxpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadGxOver;
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
      
      public static function loadGxOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:CloseBtnX = null;
         var _loc5_:MovieClip = null;
         var _loc6_:GoodsBtnX = null;
         var _loc7_:ClickBtnX = null;
         var _loc8_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new GxShopPanel();
            _loc1_ = LoaderManager.getSwfClass("GxShop") as Class;
            _instance.gxMc = new _loc1_();
            _instance.addChild(_instance.gxMc);
            _instance.addChild(_instance.rMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               _loc5_ = new _loc2_();
               _loc5_.name = "e_" + _loc3_;
               _loc6_ = new GoodsBtnX(_loc5_,_instance.gxMc["d_" + _loc3_].x,_instance.gxMc["d_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc6_);
               _instance.gxMc.addChild(_loc6_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               _loc7_ = new ClickBtnX(_instance.gxMc["b_" + _loc3_],_instance.gxMc["b_" + _loc3_].x,_instance.gxMc["b_" + _loc3_].y);
               _instance.gxMc.addChild(_loc7_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc8_ = new ClickBtnX(_instance.gxMc["j_" + _loc3_],_instance.gxMc["j_" + _loc3_].x,_instance.gxMc["j_" + _loc3_].y);
               _instance.gxMc.addChild(_loc8_);
               _loc3_++;
            }
            _loc4_ = new CloseBtnX(_instance.gxMc.close_btn,_instance.gxMc.close_btn.x,_instance.gxMc.close_btn.y);
            _instance.gxMc.addChild(_loc4_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.initSxPanel();
         this.addEvent();
         this.initData(GS.a0);
         this.textFun();
      }
      
      private function initData(param1:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:GxShopBasicData = null;
         var _loc5_:GoodsData = null;
         this.initMc();
         this.ye.setValue(param1);
         var _loc2_:Array = GxShopData.gxArr[this.ye.getValue()];
         if(_loc2_ != null && _loc2_.length != 0)
         {
            _loc3_ = 0;
            while(_loc3_ < GS.a6)
            {
               if(_loc2_[_loc3_] != null)
               {
                  _loc4_ = _loc2_[_loc3_] as GxShopBasicData;
                  _loc5_ = GoodsFactory.getGoodsById(_loc4_.getGoodsId());
                  this.gxMc["s_" + _loc3_].n_tx.text = _loc5_.getName();
                  (this.gxMc["s_" + _loc3_].n_tx as TextField).setTextFormat(_loc5_.getColorStr());
                  this.gxMc["s_" + _loc3_].need_0.text = String("排名:" + _loc4_.getPmNum());
                  this.gxMc["s_" + _loc3_].need_1.text = String("功勋:" + _loc4_.getGxNum());
                  (this.tbBoxArr[_loc3_] as GoodsBtnX).visible = true;
                  (this.tbBoxArr[_loc3_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc4_.getGoodsNum());
                  (this.tbBoxArr[_loc3_] as GoodsBtnX).getSmMc().gotoAndStop(_loc5_.getFrame());
                  this.gxMc["b_" + _loc3_].visible = true;
               }
               _loc3_++;
            }
         }
         this.gxMc.j_tx.text = this.ye.getValue() + GS.a1 + "/" + GxShopData.gxArr.length;
      }
      
      private function textFun() : void
      {
         this.gxMc.pm_tx.text = String(GM.testapi.pkDataself.getTrank());
         this.gxMc.gx_tx.text = String(GM.aSaveData.pksd.gongScore);
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:GxShopBasicData = null;
         var _loc3_:Goods = null;
         if(param1.name == "e")
         {
            _loc2_ = GxShopData.gxArr[this.ye.getValue()][param1.id];
            if(_loc2_ != null)
            {
               _loc3_ = GoodsFactory.createGoodsById(_loc2_.getGoodsId());
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
               (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            }
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
         var _loc2_:GxShopBasicData = null;
         if(param1.name == "j")
         {
            if(param1.id == 0)
            {
               if(this.ye.getValue() > 0)
               {
                  this.ye.setValue(this.ye.getValue() - GS.a1);
               }
               else
               {
                  this.ye.setValue(GxShopData.gxArr.length - 1);
               }
            }
            else if(param1.id == 1)
            {
               if(this.ye.getValue() < GxShopData.gxArr.length - 1)
               {
                  this.ye.setValue(this.ye.getValue() + GS.a1);
               }
               else
               {
                  this.ye.setValue(GS.a0);
               }
            }
            this.initData(this.ye.getValue());
         }
         else if(param1.name == "b")
         {
            _loc2_ = GxShopData.gxArr[this.ye.getValue()][param1.id];
            if(BagFactory.isFullById(_loc2_.getGoodsId(),_loc2_.getGoodsNum()))
            {
               if(GM.testapi.pkDataself.getTrank() <= _loc2_.getPmNum())
               {
                  if(GM.aSaveData.pksd.gongScore >= _loc2_.getGxNum())
                  {
                     GM.aSaveData.pksd.redGong(_loc2_.getGxNum());
                     if(BagFactory.addInBagById(_loc2_.getGoodsId(),_loc2_.getGoodsNum(),GS.a0))
                     {
                        BagFactory.hdGoodsTs(_loc2_.getGoodsId(),_loc2_.getGoodsNum());
                     }
                     this.textFun();
                  }
                  else
                  {
                     GoodsManger.cwTs("亲!您的功勋不足哦!");
                  }
               }
               else
               {
                  GoodsManger.cwTs("亲!您的排名没达到要求哦!");
               }
            }
            else
            {
               GoodsManger.cwTs("亲!您的背包满了哦!");
            }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 6)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            this.gxMc["s_" + _loc1_].n_tx.text = "";
            this.gxMc["s_" + _loc1_].need_0.text = "";
            this.gxMc["s_" + _loc1_].need_1.text = "";
            this.gxMc["b_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function initSxPanel() : void
      {
         this.centerMc.addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
   }
}

