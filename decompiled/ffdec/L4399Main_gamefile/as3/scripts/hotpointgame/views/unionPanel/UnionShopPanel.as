package hotpointgame.views.unionPanel
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
   import hotpointgame.models.unionShop.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class UnionShopPanel extends MovieClip
   {
      
      private static var _instance:UnionShopPanel;
      
      private static var cbx:Number = -1;
      
      private var tbBoxArr:Array = [];
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var shMc:MovieClip = new MovieClip();
      
      private var _sxDisplay:SxPanel;
      
      private var data:UnPanelShopData;
      
      private var ye:VT = VT.createVT(GS.a1);
      
      private var timer:Timer = new Timer(GS.a1000,GS.a0);
      
      private var mcNum:Number = 0;
      
      private var xsNum:Number = 2;
      
      private var ztNum:Number = 0;
      
      private var tdNum:Number = 8;
      
      private var mcBo:Boolean;
      
      private var tsArr:Array = ["商店等级只有军团团长才能够提升，想要提升商店等级的话就快联系他吧！","商店等级提升后不仅可以增加出售物品的种类，还能够提升物品的每日出售限额数量","尽量提交更多的建筑合金给建设师，才能够更快的提升商店等级"];
      
      public function UnionShopPanel()
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
               _loc1_.push("unshoppanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadShOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initShLv();
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
      
      public static function loadShOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:CloseBtnX = null;
         var _loc6_:MovieClip = null;
         var _loc7_:GoodsBtnX = null;
         var _loc8_:ClickBtnX = null;
         var _loc9_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new UnionShopPanel();
            _loc1_ = LoaderManager.getSwfClass("ShopMc") as Class;
            _instance.shMc = new _loc1_();
            _instance.addChild(_instance.shMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = new _loc2_();
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               _loc6_ = new _loc2_();
               _loc6_.name = "e_" + _loc4_;
               _loc7_ = new GoodsBtnX(_loc6_,_instance.shMc["t_" + _loc4_].d_0.x,_instance.shMc["t_" + _loc4_].d_0.y);
               _instance.tbBoxArr.push(_loc7_);
               _instance.shMc["t_" + _loc4_].addChild(_loc7_);
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               _loc8_ = new ClickBtnX(_instance.shMc["b_" + _loc4_],_instance.shMc["b_" + _loc4_].x,_instance.shMc["b_" + _loc4_].y);
               _instance.shMc.addChild(_loc8_);
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 2)
            {
               _loc9_ = new ClickBtnX(_instance.shMc["j_" + _loc4_],_instance.shMc["j_" + _loc4_].x,_instance.shMc["j_" + _loc4_].y);
               _instance.shMc.addChild(_loc9_);
               _loc4_++;
            }
            _loc5_ = new CloseBtnX(_instance.shMc.close_btn,_instance.shMc.close_btn.x,_instance.shMc.close_btn.y);
            _instance.shMc.addChild(_loc5_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initShLv();
         }
      }
      
      private function initShLv() : void
      {
         this.data = GoodsManger.dataList.unShop;
         this.addEvent();
         DataIngPanel.open();
         GM.testapi.getMyselfUnion();
      }
      
      private function unionHandle(param1:UnEvent) : void
      {
         var _loc2_:Array = null;
         GoodsManger.dataList.unionData.setMyUnion(param1.obj);
         if(GoodsManger.dataList.unionData.getMyUnion() != null)
         {
            _loc2_ = GoodsManger.dataList.unionData.getGbId();
            GM.testapi.getVarValue(_loc2_);
         }
         else
         {
            DataIngPanel.close();
            close();
         }
      }
      
      private function getGGbL(param1:UnEvent) : void
      {
         GoodsManger.dataList.unionData.setGgBl(param1.obj as Array);
         this.data.isChangeLevel(GoodsManger.dataList.unionData.getGgBl(GS.a9));
         DataIngPanel.close();
         this.initPanel();
      }
      
      private function initPanel() : void
      {
         this.centerMc.addChild(this._sxDisplay);
         this.visible = true;
         this.ye.setValue(GS.a1);
         this.initFrame();
         this.initText();
         this.shMc.ts_mc.visible = false;
         this.timer.start();
      }
      
      private function initText() : void
      {
         this.shMc.lv_tx.text = String(this.data.getLevel());
         this.shMc.gx_tx.text = String(GoodsManger.dataList.unionData.getGxValue());
      }
      
      private function initFrame() : void
      {
         var _loc3_:UnionShop = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         this.initMc();
         var _loc1_:Array = this.data.getCurrShopList(this.ye.getValue());
         var _loc2_:uint = 0;
         while(_loc2_ < GS.a6)
         {
            _loc3_ = _loc1_[_loc2_] as UnionShop;
            if(_loc3_ != null)
            {
               _loc4_ = VT.createVT(_loc3_.getGsId());
               _loc5_ = VT.createVT(_loc3_.getGsNum());
               (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = true;
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc4_.getValue()).getFrame());
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc5_.getValue());
               this.shMc["t_" + _loc2_].name_tx.text = _loc3_.getName();
               (this.shMc["t_" + _loc2_].name_tx as TextField).setTextFormat(GoodsFactory.getGoodsById(_loc4_.getValue()).getColorStr());
               this.shMc["t_" + _loc2_].gold_tx.text = String(_loc3_.getNeedGold());
               this.shMc["t_" + _loc2_].gx_tx.text = String(_loc3_.getNeedGx());
               this.shMc["t_" + _loc2_].cs_tx.text = String(_loc3_.getGsSl() - _loc3_.getTimes());
               this.shMc["t_" + _loc2_].sm_tx.text = _loc3_.getSm();
               this.shMc["b_" + _loc2_].visible = true;
            }
            else
            {
               this.shMc["b_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         this.shMc.j_tx.text = String(this.ye.getValue() + "/" + this.data.getAllYe());
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
            this.shMc["t_" + _loc1_].name_tx.text = "";
            this.shMc["t_" + _loc1_].gold_tx.text = "";
            this.shMc["t_" + _loc1_].gx_tx.text = "";
            this.shMc["t_" + _loc1_].cs_tx.text = "";
            this.shMc["t_" + _loc1_].sm_tx.text = "";
            _loc1_++;
         }
      }
      
      private function addEvent() : void
      {
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.addEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.addEventListener(UnEvent.MY_UNION,this.unionHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandle);
      }
      
      private function error(param1:UnEvent) : void
      {
         DataIngPanel.close();
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:UnionShop = null;
         var _loc3_:int = 0;
         if(param1.name == "j")
         {
            if(param1.id == 0)
            {
               if(this.ye.getValue() > GS.a1)
               {
                  this.ye.setValue(this.ye.getValue() - GS.a1);
               }
               else
               {
                  this.ye.setValue(this.data.getAllYe());
               }
            }
            else if(param1.id == 1)
            {
               if(this.ye.getValue() < this.data.getAllYe())
               {
                  this.ye.setValue(this.ye.getValue() + GS.a1);
               }
               else
               {
                  this.ye.setValue(GS.a1);
               }
            }
            this.initFrame();
         }
         else if(param1.name == "b")
         {
            _loc2_ = this.data.getShopByKey(param1.id);
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getSm().indexOf("级");
               if(this.data.getLevel() >= Number(_loc2_.getSm().substr(0,_loc3_)))
               {
                  if(FlowInterface.getGodByRole() >= _loc2_.getNeedGold())
                  {
                     if(GoodsManger.dataList.unionData.getGxValue() >= _loc2_.getNeedGx())
                     {
                        if(_loc2_.getGsSl() - _loc2_.getTimes() > GS.a0)
                        {
                           if(BagFactory.isFullById(_loc2_.getGsId(),_loc2_.getGsNum()))
                           {
                              GoodsManger.dataList.unionData.deleteValue(_loc2_.getNeedGx());
                              FlowInterface.redGodByRole(_loc2_.getNeedGold());
                              _loc2_.setTimes(_loc2_.getTimes() + GS.a1);
                              BagFactory.addInBagById(_loc2_.getGsId(),_loc2_.getGsNum(),GS.a0);
                              BagFactory.hdGoodsTs(_loc2_.getGsId(),_loc2_.getGsNum());
                              GoodsManger.dataList.evData.setJd(GS.a15);
                              FlowInterface.saveDataByKai();
                              this.initFrame();
                              this.initText();
                           }
                           else
                           {
                              GoodsManger.cwTs("背包已满");
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("今天的存货已经卖光了");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("贡献点不够可别来忽悠了");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("商店等级太低，快叫团长去找建设师升级吧");
               }
            }
         }
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
         var _loc2_:UnionShop = null;
         var _loc3_:Goods = null;
         if(param1.name == "e")
         {
            _loc2_ = this.data.getShopByKey(param1.id);
            _loc3_ = GoodsFactory.createGoodsById(_loc2_.getGsId());
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.removeEventListener(UnEvent.MY_UNION,this.unionHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandle);
      }
      
      private function timerHandle(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!this.mcBo)
         {
            if(this.mcNum < this.xsNum)
            {
               ++this.mcNum;
            }
            else
            {
               this.shMc.ts_mc.visible = true;
               _loc2_ = int(Math.random() * this.tsArr.length);
               this.shMc.ts_mc.ts_tx.text = this.tsArr[_loc2_];
               this.mcBo = true;
            }
         }
         else if(this.ztNum < this.tdNum)
         {
            ++this.ztNum;
         }
         else
         {
            this.shMc.ts_mc.visible = false;
            this.mcBo = false;
            this.ztNum = 0;
            this.mcNum = 0;
         }
      }
   }
}

