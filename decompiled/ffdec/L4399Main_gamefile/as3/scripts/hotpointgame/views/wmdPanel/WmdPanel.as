package hotpointgame.views.wmdPanel
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
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class WmdPanel extends MovieClip
   {
      
      private static var _instance:WmdPanel;
      
      private static var cbx:Number = -1;
      
      private var state:VT = VT.createVT(0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var wmMc:MovieClip = new MovieClip();
      
      private var slotBoxArr:Array = [];
      
      private var _bagDisplay:BagDisplay;
      
      private var _sxDisplay:SxPanel;
      
      private var slot:WmSlot;
      
      private var goodsTb:GoodsBtnX;
      
      private var tf:TextFormat = new TextFormat();
      
      public function WmdPanel()
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
               _loc1_.push("wmPanel");
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
      
      public static function close() : void
      {
         cbx = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance.closeData();
            _instance._bagDisplay.close();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      private static function loadWmOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:ClickBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new WmdPanel();
            _loc1_ = LoaderManager.getSwfClass("Wm_Panel") as Class;
            _instance.wmMc = new _loc1_();
            _loc2_ = _instance.wmMc;
            _instance.addChild(_loc2_);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc3_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc7_ = new _loc3_();
               _loc7_.name = "wms_" + _loc4_;
               _loc8_ = new GoodsBtnX(_loc7_,_loc2_["d2_" + _loc4_].x,_loc2_["d2_" + _loc4_].y);
               _instance.slotBoxArr.push(_loc8_);
               _loc2_.addChild(_loc8_);
               _loc4_++;
            }
            _loc5_ = new ClickBtnX(_loc2_.wmok_0,_loc2_.wmok_0.x,_loc2_.wmok_0.y);
            _loc2_.addChild(_loc5_);
            _loc6_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc6_);
            _instance._bagDisplay = BagDisplay.createBagDisplay(568.7,93.15);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function closeData() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            if(this.slot.getGoods(_loc1_) != null)
            {
               if(BagFactory.isFullBagOnlyOne(this.slot.getGoods(_loc1_),GS.a1))
               {
                  BagFactory.addInBagByGoods(this.slot.deleteBagBack(_loc1_,GS.a1),GS.a1,false);
               }
            }
            _loc1_++;
         }
      }
      
      private function initPanel() : void
      {
         this.slot = BagFactory.wmSlot;
         this.visible = true;
         this.addEvent();
         this.initBag();
         this.initFrame();
      }
      
      private function initFrame() : void
      {
         var _loc2_:String = null;
         var _loc3_:Goods = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            if(this.slot.getGoods(_loc1_) != null)
            {
               _loc3_ = this.slot.getGoods(_loc1_);
               (this.slotBoxArr[_loc1_] as GoodsBtnX).visible = true;
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(_loc3_.getFrame());
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               if(_loc1_ == GS.a0)
               {
                  (this.slotBoxArr[2] as GoodsBtnX).visible = true;
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().t_txt.text = _loc3_.getWmSl() + "/" + BagFactory.getNumById(_loc3_.getWmId());
                  if(BagFactory.getNumById(_loc3_.getWmId()) >= _loc3_.getWmSl())
                  {
                     this.tf.color = "0xFFFFFF";
                  }
                  else
                  {
                     this.tf.color = "0xFF0000";
                  }
                  ((this.slotBoxArr[2] as GoodsBtnX).getSmMc().t_txt as TextField).setTextFormat(this.tf);
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc3_.getWmId()).getFrame());
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().gx_mc.visible = false;
                  this.wmMc.wmGod_tx.text = String(_loc3_.getWmJb());
               }
            }
            else
            {
               (this.slotBoxArr[_loc1_] as GoodsBtnX).visible = false;
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               if(_loc1_ == GS.a0)
               {
                  (this.slotBoxArr[2] as GoodsBtnX).visible = false;
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().t_txt.text = "";
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().gotoAndStop(1);
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                  (this.slotBoxArr[2] as GoodsBtnX).getSmMc().gx_mc.visible = false;
                  this.wmMc.wmGod_tx.text = "";
               }
            }
            _loc1_++;
         }
         if(this.slot.getGoods(GS.a0) != null)
         {
            if(this.slot.getGoods(GS.a1) != null)
            {
               _loc2_ = "请点击提升完美度按钮";
            }
            else
            {
               _loc2_ = "请放入与主物品相同属性的装备（不包括强化、镶嵌）";
            }
         }
         else
         {
            _loc2_ = "请选择需要放入的装备或时装";
         }
         this.wmMc.ts_text.text = _loc2_;
         GoodsManger.tsFunction("Ts_48",104,502);
         this._bagDisplay.tbMastMc();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(GoodsEvent.DO_WM,this.wmHandle);
      }
      
      private function wmHandle(param1:GoodsEvent) : void
      {
         var _loc2_:Goods = param1.goods;
         if(this.slot.getGoods(GS.a0) == null)
         {
            if(this.slot.getGoods(GS.a1) != null)
            {
               if(_loc2_.getId() == this.slot.getGoods(GS.a1).getId())
               {
                  this.slot.addToBag(_loc2_,GS.a0,GS.a1);
               }
               else if(BagFactory.isFullBagOnlyOne(this.slot.getGoods(GS.a1),GS.a1))
               {
                  this.slot.addToBag(_loc2_,GS.a0,GS.a1);
                  BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a1,GS.a1),1,true);
               }
               else
               {
                  BagFactory.addInBagByGoods(_loc2_,1,true);
                  GoodsManger.cwTs("背包已满");
               }
            }
            else
            {
               this.slot.addToBag(_loc2_,GS.a0,GS.a1);
            }
         }
         else if(this.slot.getGoods(GS.a1) == null)
         {
            if(_loc2_.getId() == this.slot.getGoods(GS.a0).getId())
            {
               this.slot.addToBag(_loc2_,GS.a1,GS.a1);
            }
            else
            {
               BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a0,GS.a1),1,true);
               this.slot.addToBag(_loc2_,GS.a0,GS.a1);
               GoodsManger.cwTs("主、辅助物品相同才能提升");
            }
         }
         else if(_loc2_.getId() == this.slot.getGoods(GS.a0).getId())
         {
            BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a1,GS.a1),1,true);
            this.slot.addToBag(_loc2_,GS.a1,GS.a1);
         }
         else if(BagFactory.isFullBagOnlyOne(this.slot.getGoods(GS.a0),GS.a2))
         {
            BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a0,GS.a1),1,true);
            BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a1,GS.a1),1,true);
            this.slot.addToBag(_loc2_,GS.a0,GS.a1);
            GoodsManger.cwTs("主、辅助物品相同才能提升");
         }
         else
         {
            BagFactory.addInBagByGoods(_loc2_,1,true);
            GoodsManger.cwTs("背包已满");
         }
         this.initFrame();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(GoodsEvent.DO_WM,this.wmHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "wms")
         {
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "wms")
         {
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            if(param1.id != GS.a2)
            {
               _loc2_ = this.slot.getGoods(param1.id);
            }
            else
            {
               _loc2_ = GoodsFactory.createGoodsById(this.slot.getGoods(GS.a0).getWmId());
            }
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
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
         var _loc2_:Goods = null;
         if(param1.name == "wms")
         {
            if(param1.id != GS.a2)
            {
               if(param1.id == GS.a0)
               {
                  if(this.slot.getGoods(GS.a1) != null)
                  {
                     if(BagFactory.isFullBagOnlyOne(this.slot.getGoods(GS.a0),GS.a2))
                     {
                        BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a0,GS.a1),1,true);
                        BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a1,GS.a1),1,true);
                     }
                     else
                     {
                        GoodsManger.cwTs("背包已满");
                     }
                  }
                  else if(BagFactory.isFullBagOnlyOne(this.slot.getGoods(GS.a0),GS.a1))
                  {
                     BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a0,GS.a1),1,true);
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
               else if(param1.id == GS.a1)
               {
                  BagFactory.addInBagByGoods(this.slot.deleteBagBack(GS.a1,GS.a1),1,true);
               }
               this.initFrame();
            }
         }
         else if(param1.name == "wmok")
         {
            if(this.slot.getGoods(GS.a0) != null && this.slot.getGoods(GS.a1) != null)
            {
               _loc2_ = this.slot.getGoods(GS.a0);
               if(BagFactory.getNumById(_loc2_.getWmId()) >= _loc2_.getWmSl())
               {
                  if(_loc2_.getWmLevel() < _loc2_.getWmMax())
                  {
                     if(FlowInterface.getGodByRole() >= _loc2_.getWmJb())
                     {
                        FlowInterface.redGodByRole(_loc2_.getWmJb());
                        _loc2_.addWmLevel();
                        this.slot.bfBag();
                        this.slot.deleteBag(GS.a1,GS.a1);
                        BagFactory.deteleGoods(_loc2_.getWmId(),_loc2_.getWmSl());
                        GoodsManger.movicpStr(this.wmMc.d2_0.x,this.wmMc.d2_0.y,this.wmOk);
                     }
                     else
                     {
                        GoodsManger.cwTs("晶币不足");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("这个物品太高端了无法继续提升");
                     this.closeData();
                     this.initFrame();
                  }
               }
               else
               {
                  GoodsManger.cwTs("完美宝石好像还不够");
               }
            }
            else
            {
               GoodsManger.cwTs("你还没收集到需求的装备哦");
            }
         }
      }
      
      private function wmCdOk() : void
      {
      }
      
      private function wmOk() : void
      {
         GoodsManger.cwTs("恭喜！完美度成功+1");
         GoodsManger.dataList.evData.setJd(GS.a9);
         this._bagDisplay.getGoldTx();
         this.initFrame();
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
      
      public function getSlotg() : Goods
      {
         return this.slot.getGoods(GS.a0);
      }
   }
}

