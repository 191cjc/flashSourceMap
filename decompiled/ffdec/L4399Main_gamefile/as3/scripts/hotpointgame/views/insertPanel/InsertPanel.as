package hotpointgame.views.insertPanel
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
   import hotpointgame.models.goods.EquipGemSlot;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class InsertPanel extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      private static var _instance:InsertPanel;
      
      private static var bx:int = 0;
      
      private var _bagDisplay:BagDisplay;
      
      private var _equipSlot:Bag;
      
      private var _insertSlot:InsertSlot;
      
      public var _state:Number = 0;
      
      private var _typeBtn:SameChangeBtn;
      
      private var _clickFwBtn:SameChangeBtn;
      
      private var _timer:Timer;
      
      private var _timerNum:Number = 0;
      
      private var _timerNum2:Number = 0;
      
      private var _pos:Number = 0;
      
      private var _pos2:Number = 0;
      
      private var _bo1:Boolean;
      
      private var _bo2:Boolean;
      
      private var strText:String;
      
      private var cArr:Array = [];
      
      private var cNum:Number;
      
      private var cGemSlot:EquipGemSlot;
      
      private var cGem:Goods;
      
      private var okBtn1:BasicClickBtn;
      
      private var okBtn2:BasicClickBtn;
      
      private var _sxDisplay:SxPanel;
      
      private var tbBoxArr:Array = [];
      
      private var slotBoxArr:Array = [];
      
      public function InsertPanel()
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
               bx = -1;
               _loc1_ = new Array();
               _loc1_.push("insertpanel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadInsOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.visible = true;
         _instance.x = 0;
         _instance.initPanel();
      }
      
      private static function loadInsOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:GoodsBtnX = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         if(bx != 0)
         {
            bx = 0;
            _loc1_ = LoaderManager.getSwfClass("Insert_Panel") as Class;
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = new _loc1_();
            operatingMc = _loc3_;
            _instance = new InsertPanel();
            _instance.addChild(operatingMc);
            GM.bagJm.addChild(_instance);
            _loc4_ = 0;
            while(_loc4_ < 7)
            {
               _loc5_ = new _loc2_();
               _loc5_.name = "e_" + _loc4_;
               if(_loc4_ != 3)
               {
                  _loc6_ = new GoodsBtnX(_loc5_,operatingMc["ed_" + _loc4_].x,operatingMc["ed_" + _loc4_].y);
                  _instance.addChild(_loc6_);
               }
               else
               {
                  _loc6_ = new GoodsBtnX(_loc5_);
               }
               _instance.tbBoxArr.push(_loc6_);
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc7_ = new _loc2_();
               _loc7_.name = "s_" + _loc4_;
               if(_loc4_ == 0)
               {
                  _loc8_ = new GoodsBtnX(_loc7_,operatingMc["wp_" + 0].x,operatingMc["wp_" + 0].y);
               }
               else
               {
                  _loc8_ = new GoodsBtnX(_loc7_,operatingMc["wp_" + 1].x,operatingMc["wp_" + 1].y);
               }
               _instance.slotBoxArr.push(_loc8_);
               _instance.addChild(_loc8_);
               _loc4_++;
            }
            _instance.initMcBtn();
            _instance._insertSlot = BagFactory.inSlot;
            _instance._bagDisplay = BagDisplay.createBagDisplay(571.8,95.3);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.visible = true;
            _instance.x = 0;
            _instance.initPanel();
         }
      }
      
      public static function close() : void
      {
         bx = 0;
         if(InsertPanel._instance != null && Boolean(InsertPanel._instance.visible))
         {
            InsertPanel._instance._bagDisplay.close();
            InsertPanel._instance.backData();
            InsertPanel._instance.removEvent();
            InsertPanel._instance.visible = false;
            InsertPanel._instance.x = 5000;
         }
      }
      
      private function initPanel() : void
      {
         this.initBag();
         this._equipSlot = BagFactory.equipSlot;
         this._state = 0;
         this._timer = new Timer(0);
         this.addEvent();
         this.bagDisplay();
         this.inserSlotDisplay();
         this._typeBtn.btnOk(this._state);
         this.mcVisible();
         this.slotEquipSlotText();
         operatingMc.mask_xx.visible = false;
      }
      
      private function initBag() : void
      {
         addChild(this._bagDisplay);
         this._bagDisplay.init();
         this._bagDisplay._parentMc = this;
         this._bagDisplay.tbMastMc();
         addChild(this._sxDisplay);
         this._sxDisplay.init();
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
      
      private function bagDisplay() : void
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc5_:EquipGemSlot = null;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
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
               operatingMc["z_" + _loc2_].visible = true;
               if(_loc4_ != null)
               {
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = true;
                  if(_loc3_.getGoodsNum() > 1)
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
                  }
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
                  operatingMc["z_" + _loc2_].visible = false;
                  if(this._state == 0)
                  {
                     if(_loc4_.getType() == 0 && _loc4_.getGemSlot() != null)
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                     }
                     else
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                     }
                  }
                  else if(this._state == 1)
                  {
                     if(_loc4_.getType() == 0 && _loc4_.getGemSlot() != null)
                     {
                        _loc5_ = _loc4_.getGemSlot();
                        _loc6_ = _loc5_.getSlotNum();
                        _loc8_ = 0;
                        while(_loc8_ < _loc6_)
                        {
                           if(_loc5_.getSlot(_loc8_) == 0)
                           {
                              _loc7_ = true;
                           }
                           _loc8_++;
                        }
                        if(_loc7_)
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                        }
                     }
                     else
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(GoodsEvent.DO_INSERT,this.insertHandle);
         addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         addEventListener(GoodsEvent.DO_WEAR,this.goodsHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function backData() : void
      {
         var _loc2_:Goods = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            if(this._insertSlot.getGoods(_loc1_) != null)
            {
               _loc2_ = this._insertSlot.getGoods(_loc1_);
               _loc3_ = Number(this._insertSlot.getGoodsNum(_loc1_));
               _loc4_ = Number(this._insertSlot.getFromType(_loc1_));
               this._insertSlot.deleteBag(_loc1_,_loc3_);
               if(_loc4_ == 0)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1,0,_loc3_));
               }
               else if(_loc4_ == 1)
               {
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc2_));
               }
               (this.slotBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            }
            _loc1_++;
         }
         this.cArr.length = 0;
         this.cGem = null;
         this.cGemSlot = null;
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function removEvent() : void
      {
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(GoodsEvent.DO_INSERT,this.insertHandle);
         removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         removeEventListener(GoodsEvent.DO_WEAR,this.goodsHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         if(param1.name == "ok")
         {
            _loc2_ = this._clickFwBtn.getClickArr();
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_])
               {
                  _loc3_.push(_loc4_);
               }
               _loc4_++;
            }
            if(param1.id == 0)
            {
               this.okFunction(_loc3_,1);
            }
            else if(param1.id == 1)
            {
               this.okFunction(_loc3_,2);
            }
         }
         else if(param1.name == "bb")
         {
            if(this._insertSlot.getGoods(0) != null)
            {
               if(this._state == 0)
               {
                  if(this._insertSlot.getGoods(1) != null)
                  {
                     GoodsManger.cwTs("此星体槽未打孔");
                  }
                  else
                  {
                     GoodsManger.cwTs("请先放入元素水晶");
                  }
               }
               else if(this._state == 1)
               {
                  if(this._insertSlot.getGoods(2) != null)
                  {
                     GoodsManger.cwTs("此星体槽已打孔");
                  }
                  else
                  {
                     GoodsManger.cwTs("请先放入能量晶块");
                  }
               }
            }
         }
      }
      
      private function okFun() : void
      {
         var _loc1_:int = 0;
         if(this.cArr.length != 0 && this.cGem != null && this.cGemSlot != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.cArr.length)
            {
               if(this.cNum == 1)
               {
                  this.cGemSlot.addGemInEquip(this.cArr[_loc1_],this.cGem);
                  this._insertSlot.bfBag();
                  this._insertSlot.deleteBag(GS.a1,GS.a1);
               }
               else if(this.cNum == 2)
               {
                  if(this.cGemSlot.getSlot(this.cArr[_loc1_]) == 0)
                  {
                     this.cGemSlot.setSlot(this.cArr[_loc1_]);
                     this._insertSlot.bfBag();
                     this._insertSlot.deleteBag(GS.a2,GS.a1);
                  }
               }
               _loc1_++;
            }
            if(this.cNum == 1)
            {
               this.okBtn1.okBtn = true;
               this.okBtn2.okBtn = true;
               this._bagDisplay.maskMcDisplay();
               operatingMc.mask_xx.visible = false;
               GoodsManger.cwTs("镶嵌成功");
            }
            else if(this.cNum == 2)
            {
               this.okBtn1.okBtn = true;
               this.okBtn2.okBtn = true;
               this._bagDisplay.maskMcDisplay();
               operatingMc.mask_xx.visible = false;
               GoodsManger.cwTs("打孔成功");
            }
            this.slotEquipSlotText();
            this.inserSlotDisplay();
            this.maskSlot();
            this.cArr.length = 0;
            this.cGem = null;
            this.cGemSlot = null;
         }
         this.okBtn1.okBtn = true;
         this.okBtn2.okBtn = true;
         SoundManager.playOnlySound("mp_productSuccess");
      }
      
      private function okFunction(param1:Array, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc3_:Goods = this._insertSlot.getGoods(0);
         var _loc4_:EquipGemSlot = _loc3_.getGemSlot();
         var _loc5_:Goods = this._insertSlot.getGoods(param2);
         this.cGem = _loc5_;
         this.cArr = param1;
         this.cNum = param2;
         this.cGemSlot = _loc4_;
         if(_loc5_ != null)
         {
            _loc6_ = Number(this._insertSlot.getGoodsNum(param2));
            if(param1.length != 0)
            {
               if(_loc6_ >= param1.length)
               {
                  this.okBtn1.okBtn = false;
                  this.okBtn2.okBtn = false;
                  this._bagDisplay.maskMcDisplay(1);
                  operatingMc.mask_xx.visible = true;
                  addChildAt(operatingMc.mask_xx,numChildren - 1);
                  GoodsManger.movicpStr(operatingMc.wp_0.x,operatingMc.wp_0.y,this.okFun);
                  SoundManager.playOnlySound("mp_qianghuadonghua");
               }
               else if(param2 == 1)
               {
                  GoodsManger.cwTs("元素星体不足");
               }
               else if(param2 == 2)
               {
                  GoodsManger.cwTs("能源晶块不足");
               }
            }
            else if(param2 == 1)
            {
               GoodsManger.cwTs("请先选择星体槽");
            }
            else if(param2 == 2)
            {
               GoodsManger.cwTs("请先选择星体槽");
            }
         }
         else if(param2 == 1)
         {
            GoodsManger.cwTs("请先放入元素水晶");
         }
         else if(param2 == 2)
         {
            GoodsManger.cwTs("请先放入能量晶块");
         }
      }
      
      private function maskSlot() : void
      {
         var _loc1_:Goods = null;
         var _loc2_:Number = NaN;
         var _loc3_:EquipGemSlot = null;
         var _loc4_:uint = 0;
         if(this._insertSlot.getGoods(0) != null)
         {
            _loc1_ = this._insertSlot.getGoods(0);
            if(this._state == 1)
            {
               _loc2_ = 0;
               _loc3_ = _loc1_.getGemSlot();
               _loc4_ = 0;
               while(_loc4_ < _loc3_.getSlotNum())
               {
                  if(_loc3_.getSlot(_loc4_) == 0)
                  {
                     _loc2_++;
                  }
                  _loc4_++;
               }
               if(_loc2_ == 0)
               {
                  (this.slotBoxArr[0] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
               }
               else
               {
                  (this.slotBoxArr[0] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               }
            }
            else if(this._state == 0)
            {
               (this.slotBoxArr[0] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            }
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
         var _loc3_:Goods = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:EquipGemSlot = null;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         if(param1.name == "s")
         {
            _loc2_ = this._insertSlot.getGoods(param1.id);
            if(param1.id == 0)
            {
               if(this._insertSlot.getFromType(param1.id) == 0)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1));
               }
               else if(this._insertSlot.getFromType(param1.id) == 1)
               {
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc2_));
               }
               this._insertSlot.deleteBag(param1.id,GS.a1);
               (this.slotBoxArr[0] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            }
            else if(param1.id == 1 || param1.id == 2)
            {
               _loc5_ = Number(this._insertSlot.getGoodsNum(param1.id));
               this._insertSlot.deleteBag(param1.id,_loc5_);
               if(this._insertSlot.getGoods(0) == null)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1,0,_loc5_,false));
                  this._bagDisplay._bagState = 0;
               }
               else
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1,0,_loc5_));
               }
            }
            this.inserSlotDisplay();
            this.slotEquipSlotText();
         }
         else if(param1.name == "e")
         {
            _loc2_ = this._equipSlot.getGoods(param1.id);
            if(this._state == 0)
            {
               if(_loc2_.getGemSlot() != null)
               {
                  this._equipSlot.deleteBag(param1.id,GS.a1);
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id,1));
                  this._bagDisplay._bagState = 1;
                  if(this._insertSlot.getGoods(1) != null)
                  {
                     _loc3_ = this._insertSlot.getGoods(1);
                     if(_loc3_.getUseLevel() > _loc2_.getUseLevel())
                     {
                        _loc4_ = Number(this._insertSlot.getGoodsNum(1));
                        this._insertSlot.deleteBag(GS.a1,_loc4_);
                        Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc3_,-1,0,_loc4_));
                        this.inserSlotDisplay();
                     }
                  }
               }
               else
               {
                  GoodsManger.cwTs("该物品无法镶嵌");
               }
            }
            else if(this._state == 1)
            {
               if(_loc2_.getGemSlot() != null)
               {
                  _loc6_ = _loc2_.getGemSlot();
                  _loc7_ = _loc6_.getSlotNum();
                  _loc8_ = false;
                  _loc9_ = 0;
                  while(_loc9_ < _loc7_)
                  {
                     if(_loc6_.getSlot(_loc9_) == 0)
                     {
                        _loc8_ = true;
                     }
                     _loc9_++;
                  }
                  if(_loc8_)
                  {
                     this._bagDisplay._bagState = 2;
                     this._equipSlot.deleteBag(param1.id,GS.a1);
                     dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id,1));
                     if(this._insertSlot.getGoods(2) != null)
                     {
                        _loc3_ = this._insertSlot.getGoods(2);
                        if(_loc3_.getUseLevel() < _loc2_.getUseLevel())
                        {
                           _loc4_ = Number(this._insertSlot.getGoodsNum(2));
                           this._insertSlot.deleteBag(2,_loc4_);
                           Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc3_,-1,0,_loc4_));
                           this.inserSlotDisplay();
                        }
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("该物品无法打孔与镶嵌");
                  }
               }
               else
               {
                  GoodsManger.cwTs("该物品无法打孔与镶嵌");
               }
            }
         }
         this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
         this.bagDisplay();
         this._bagDisplay.tbMastMc();
      }
      
      private function backInsertTwo(param1:Goods) : void
      {
         var _loc3_:Goods = null;
         var _loc4_:Number = NaN;
         var _loc2_:Number = this._state + 1;
         if(this._insertSlot.getGoods(_loc2_) != null)
         {
            _loc3_ = this._insertSlot.getGoods(_loc2_);
            _loc4_ = Number(this._insertSlot.getGoodsNum(_loc2_));
            if(this._state == 0)
            {
               if(_loc3_.getUseLevel() > param1.getUseLevel())
               {
                  this._insertSlot.deleteBag(_loc2_,_loc4_);
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc3_,-1,0,_loc4_));
               }
            }
            else if(this._state == 1)
            {
               if(_loc3_.getUseLevel() < param1.getUseLevel())
               {
                  this._insertSlot.deleteBag(_loc2_,_loc4_);
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc3_,-1,0,_loc4_));
               }
            }
         }
      }
      
      private function gxVisible(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 3)
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
      
      private function insertHandle(param1:GoodsEvent) : void
      {
         var _loc6_:Goods = null;
         var _loc2_:Goods = param1.goods;
         var _loc3_:Number = param1.goodsNum;
         var _loc4_:Number = param1.id;
         var _loc5_:Number = param1.typeb;
         if(_loc2_.getType() == 0)
         {
            if(this._insertSlot.getGoods(0) != null)
            {
               _loc6_ = this._insertSlot.getGoods(0);
               this._insertSlot.deleteBag(0,GS.a1);
               this._insertSlot.addToBag(param1.goods,0,GS.a1);
               if(this._insertSlot.getFromType(0) == 0)
               {
                  if(param1.typeb == 0)
                  {
                     Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc6_,_loc4_));
                  }
                  else
                  {
                     Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc6_,-1));
                  }
               }
               else if(this._insertSlot.getFromType(0) == 1)
               {
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc6_));
               }
               this._insertSlot.setFromType(0,param1.typeb);
            }
            else
            {
               this._insertSlot.addToBag(param1.goods,0,GS.a1);
               this._insertSlot.setFromType(0,param1.typeb);
            }
            this.backInsertTwo(_loc2_);
         }
         else if(_loc2_.getType() == 1)
         {
            this.addGemOrOther(_loc2_,_loc3_,1,_loc4_);
         }
         else if(_loc2_.getType() == 2)
         {
            this.addGemOrOther(_loc2_,_loc3_,2,_loc4_);
         }
         this._pos = _loc2_.getType();
         this.gxVisible(this._pos);
         this.inserSlotDisplay();
         this._timerNum = 0;
         this._timer.start();
         this._bo1 = true;
         this.slotEquipSlotText();
      }
      
      private function textColor() : void
      {
         var _loc1_:Goods = null;
         if(this._insertSlot.getGoods(0) != null)
         {
            _loc1_ = this._insertSlot.getGoods(0);
            operatingMc.name_text.setTextFormat(_loc1_.getColorStr());
         }
         if(this._state == 0)
         {
            if(this._insertSlot.getGoods(1) != null)
            {
               _loc1_ = this._insertSlot.getGoods(1);
               operatingMc.num_text.setTextFormat(_loc1_.getColorStr());
            }
         }
         else if(this._state == 1)
         {
            if(this._insertSlot.getGoods(2) != null)
            {
               _loc1_ = this._insertSlot.getGoods(2);
               operatingMc.num_text.setTextFormat(_loc1_.getColorStr());
            }
         }
      }
      
      private function addGemOrOther(param1:Goods, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Goods = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this._insertSlot.getGoods(param3) != null)
         {
            _loc5_ = DeepCopyUtil.clone(this._insertSlot.getGoods(param3));
            _loc6_ = Number(this._insertSlot.getGoodsNum(param3));
            if(param1.compareById(_loc5_.getId()) && param1.getUseLevel() == _loc5_.getUseLevel() && param1.getColor() == _loc5_.getColor())
            {
               _loc7_ = Number(this._insertSlot.getGirdOne(param1,param3));
               if(_loc7_ >= param2)
               {
                  this._insertSlot.addToBag(param1,param3,param2);
               }
               else
               {
                  if(_loc7_ != 0)
                  {
                     this._insertSlot.addToBag(param1,param3,_loc7_);
                  }
                  _loc8_ = param2 - _loc7_;
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc5_,param4,0,_loc8_));
               }
            }
            else
            {
               this._insertSlot.deleteBag(param3,_loc6_);
               this._insertSlot.addToBag(param1,param3,param2);
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc5_,-1,0,_loc6_));
            }
            this._insertSlot.setFromType(param3,0);
         }
         else
         {
            this._insertSlot.addToBag(param1,param3,param2);
            this._insertSlot.setFromType(param3,0);
         }
         this._state = param3 - 1;
         this._typeBtn.btnOk(this._state);
      }
      
      private function inserSlotDisplay() : void
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:Array = this._insertSlot.getBagArr();
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
               if(_loc2_ == 0)
               {
                  (this.slotBoxArr[_loc2_] as GoodsBtnX).visible = true;
                  if(_loc3_.getGoodsNum() > 1)
                  {
                     (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
                  }
                  (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
               }
               else if(_loc2_ == 1)
               {
                  if(this._state == 0)
                  {
                     (this.slotBoxArr[_loc2_] as GoodsBtnX).visible = true;
                     if(_loc3_.getGoodsNum() > 1)
                     {
                        (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
                     }
                     (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
                  }
               }
               else if(_loc2_ == 2)
               {
                  if(this._state == 1)
                  {
                     (this.slotBoxArr[_loc2_] as GoodsBtnX).visible = true;
                     if(_loc3_.getGoodsNum() > 1)
                     {
                        (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
                     }
                     (this.slotBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "s")
         {
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:Number = NaN;
         var _loc4_:Goods = null;
         var _loc5_:Array = null;
         var _loc6_:EquipGemSlot = null;
         var _loc7_:Goods = null;
         var _loc8_:uint = 0;
         var _loc9_:Goods = null;
         if(param1.name == "type")
         {
            this._state = param1.id;
            this._typeBtn.btnOk(this._state);
            this.inserSlotDisplay();
            this.mcVisible();
            this.slotEquipSlotText();
            if(this._insertSlot.getGoods(0) == null)
            {
               this._bagDisplay._bagState = 0;
            }
            else if(this._state == 0)
            {
               if(this._insertSlot.getGoods(1) != null)
               {
                  _loc2_ = this._insertSlot.getGoods(1);
                  if(_loc2_.getUseLevel() > this._insertSlot.getGoods(0).getUseLevel())
                  {
                     _loc3_ = Number(this._insertSlot.getGoodsNum(1));
                     this._insertSlot.deleteBag(1,_loc3_);
                     Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1,0,_loc3_));
                     this.inserSlotDisplay();
                  }
               }
               this._bagDisplay._bagState = 1;
            }
            else if(this._state == 1)
            {
               if(this._insertSlot.getGoods(2) != null)
               {
                  _loc2_ = this._insertSlot.getGoods(2);
                  if(_loc2_.getUseLevel() < this._insertSlot.getGoods(0).getUseLevel())
                  {
                     _loc3_ = Number(this._insertSlot.getGoodsNum(2));
                     this._insertSlot.deleteBag(2,_loc3_);
                     Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1,0,_loc3_));
                     this.inserSlotDisplay();
                  }
               }
               this._bagDisplay._bagState = 2;
            }
            this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
            this._bagDisplay.tbMastMc();
            this.bagDisplay();
            this.maskSlot();
         }
         else if(param1.name == "b")
         {
            _loc5_ = [];
            if(this._state == 0 && this._insertSlot.getGoods(1) != null)
            {
               _loc7_ = this._insertSlot.getGoods(0);
               _loc6_ = _loc7_.getGemSlot();
               _loc4_ = this._insertSlot.getGoods(1);
               _loc5_ = this._clickFwBtn.getClickArr();
               if(_loc5_[param1.id])
               {
                  operatingMc["b_" + param1.id].gem_mc.gotoAndStop(_loc4_.getFrame());
                  _loc5_ = _loc4_.getFixAtSxForStr();
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_.length)
                  {
                     operatingMc["hh_" + param1.id].tx_Mc.jxx.text = _loc5_[_loc8_];
                     if(_loc8_ > 1)
                     {
                     }
                     _loc8_++;
                  }
               }
               else if(_loc6_.getSlot(param1.id) == 1)
               {
                  operatingMc["b_" + param1.id].gem_mc.gotoAndStop(1);
                  operatingMc["hh_" + param1.id].tx_Mc.jxx.text = "已打孔";
               }
               else if(_loc6_.getSlot(param1.id) == 2)
               {
                  _loc9_ = _loc6_.getGem(param1.id);
                  operatingMc["b_" + param1.id].gem_mc.gotoAndStop(_loc9_.getFrame());
                  _loc5_ = _loc9_.getFixAtSxForStr();
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_.length)
                  {
                     operatingMc["hh_" + param1.id].tx_Mc.jxx.text = _loc5_[_loc8_];
                     if(_loc8_ > 1)
                     {
                     }
                     _loc8_++;
                  }
               }
            }
            else if(this._state == 1 && this._insertSlot.getGoods(1) != null)
            {
               _loc5_ = this._clickFwBtn.getClickArr();
               if(_loc5_[param1.id])
               {
                  operatingMc["b_" + param1.id].gem_mc.gotoAndStop(2);
               }
               else
               {
                  operatingMc["b_" + param1.id].gem_mc.gotoAndStop(1);
               }
            }
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
            _loc2_ = this._insertSlot.getGoods(param1.id);
            (this.slotBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         if(_loc2_ != null)
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
         }
      }
      
      private function slotEquipSlotText() : void
      {
         var _loc2_:Goods = null;
         var _loc3_:EquipGemSlot = null;
         var _loc4_:Number = NaN;
         var _loc5_:Goods = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         this._clickFwBtn.czArr();
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            operatingMc["hh_" + _loc1_].visible = false;
            operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = "";
            this._clickFwBtn.closeOrOpenBtnById(_loc1_,0);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            operatingMc["b_" + _loc1_].gem_mc.gotoAndStop(1);
            operatingMc["bb_" + _loc1_].visible = true;
            _loc1_++;
         }
         operatingMc["ok_" + 0].visible = false;
         operatingMc["ok_" + 1].visible = false;
         operatingMc.name_text.text = "";
         operatingMc.num_text.text = "";
         if(this._state == 0)
         {
            if(this._insertSlot.getGoods(0) != null)
            {
               _loc2_ = this._insertSlot.getGoods(0);
               _loc3_ = _loc2_.getGemSlot();
               _loc4_ = _loc3_.getSlotNum();
               operatingMc.name_text.text = String(_loc2_.getName());
               _loc1_ = 0;
               while(_loc1_ < _loc4_)
               {
                  operatingMc["hh_" + _loc1_].visible = true;
                  _loc1_++;
               }
               _loc1_ = 0;
               while(_loc1_ < _loc4_)
               {
                  if(_loc3_.getSlot(_loc1_) == 0)
                  {
                     operatingMc["hh_" + _loc1_].gotoAndStop(2);
                     operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = "未打孔";
                  }
                  else if(_loc3_.getSlot(_loc1_) == 1)
                  {
                     operatingMc["hh_" + _loc1_].gotoAndStop(1);
                     operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = "已打孔";
                  }
                  else if(_loc3_.getSlot(_loc1_) == 2)
                  {
                     _loc5_ = _loc3_.getGem(_loc1_);
                     _loc6_ = _loc5_.getFixAtSxForStr();
                     operatingMc["hh_" + _loc1_].gotoAndStop(1);
                     operatingMc["b_" + _loc1_].gem_mc.gotoAndStop(_loc5_.getFrame());
                     _loc7_ = 0;
                     while(_loc7_ < _loc6_.length)
                     {
                        operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = _loc6_[_loc7_];
                        if(_loc7_ > 1)
                        {
                        }
                        _loc7_++;
                     }
                  }
                  _loc1_++;
               }
               if(this._insertSlot.getGoods(1) != null)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc4_)
                  {
                     if(_loc3_.getSlot(_loc1_) == 0)
                     {
                        this._clickFwBtn.closeOrOpenBtnById(_loc1_,0);
                        operatingMc["bb_" + _loc1_].visible = true;
                     }
                     else if(_loc3_.getSlot(_loc1_) == 1 || _loc3_.getSlot(_loc1_) == 2)
                     {
                        this._clickFwBtn.closeOrOpenBtnById(_loc1_,1);
                        operatingMc["bb_" + _loc1_].visible = false;
                     }
                     _loc1_++;
                  }
                  operatingMc.num_text.text = this._insertSlot.getGoods(1).getName();
                  operatingMc["ok_" + 0].visible = true;
                  this.strText = "请选择你要镶嵌的水晶槽";
               }
               else
               {
                  this.strText = "请先放入元素水晶";
               }
            }
            else
            {
               this.strText = "请先放入装备";
            }
         }
         else if(this._state == 1)
         {
            if(this._insertSlot.getGoods(0) != null)
            {
               _loc2_ = this._insertSlot.getGoods(0);
               operatingMc.name_text.text = String(_loc2_.getName());
               _loc3_ = _loc2_.getGemSlot();
               _loc4_ = _loc3_.getSlotNum();
               _loc1_ = 0;
               while(_loc1_ < _loc4_)
               {
                  operatingMc["hh_" + _loc1_].visible = true;
                  _loc1_++;
               }
               _loc1_ = 0;
               while(_loc1_ < _loc4_)
               {
                  if(_loc3_.getSlot(_loc1_) == 0)
                  {
                     operatingMc["hh_" + _loc1_].gotoAndStop(1);
                     operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = "未打孔";
                  }
                  else if(_loc3_.getSlot(_loc1_) == 1)
                  {
                     operatingMc["hh_" + _loc1_].gotoAndStop(2);
                     operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = "已打孔";
                  }
                  else if(_loc3_.getSlot(_loc1_) == 2)
                  {
                     _loc5_ = _loc3_.getGem(_loc1_);
                     _loc6_ = _loc5_.getFixAtSxForStr();
                     operatingMc["hh_" + _loc1_].gotoAndStop(2);
                     operatingMc["b_" + _loc1_].gem_mc.gotoAndStop(_loc5_.getFrame());
                     _loc7_ = 0;
                     while(_loc7_ < _loc6_.length)
                     {
                        operatingMc["hh_" + _loc1_].tx_Mc.jxx.text = _loc6_[_loc7_];
                        if(_loc7_ > 1)
                        {
                        }
                        _loc7_++;
                     }
                  }
                  _loc1_++;
               }
               if(this._insertSlot.getGoods(2) != null)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc4_)
                  {
                     if(_loc3_.getSlot(_loc1_) == 0)
                     {
                        this._clickFwBtn.closeOrOpenBtnById(_loc1_,1);
                        operatingMc["bb_" + _loc1_].visible = false;
                     }
                     else if(_loc3_.getSlot(_loc1_) == 1 || _loc3_.getSlot(_loc1_) == 2)
                     {
                        this._clickFwBtn.closeOrOpenBtnById(_loc1_,0);
                        operatingMc["bb_" + _loc1_].visible = true;
                     }
                     _loc1_++;
                  }
                  operatingMc.num_text.text = this._insertSlot.getGoods(2).getName();
                  operatingMc["ok_" + 1].visible = true;
                  this.strText = "请选择你要打孔的水晶槽";
               }
               else
               {
                  this.strText = "请先放入矩阵晶块";
               }
            }
            else
            {
               this.strText = "请先放入装备";
            }
         }
         GoodsManger.tsFunction("Ts_48",104,520);
         operatingMc.ts_text.text = this.strText;
         this.textColor();
      }
      
      private function initMcBtn() : void
      {
         var _loc4_:TextField = null;
         var _loc1_:CloseBtn = new CloseBtn(operatingMc.close_btn);
         addChild(_loc1_);
         var _loc2_:uint = 0;
         while(_loc2_ < 3)
         {
            operatingMc["hh_" + _loc2_].gotoAndStop(1);
            _loc4_ = new TextField();
            _loc4_ = operatingMc["hh_" + _loc2_].tx_Mc.jxx as TextField;
            _loc4_.embedFonts = true;
            _loc4_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16,16711680);
            _loc4_.text = "已切割";
            _loc2_++;
         }
         operatingMc.name_text.embedFonts = true;
         operatingMc.name_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         operatingMc.num_text.embedFonts = true;
         operatingMc.num_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this._typeBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.type_0,operatingMc.type_1));
         addChild(this._typeBtn);
         this.okBtn1 = new BasicClickBtn(operatingMc["ok_" + 0]);
         this.okBtn2 = new BasicClickBtn(operatingMc["ok_" + 1]);
         addChild(this.okBtn1);
         addChild(this.okBtn2);
         this._clickFwBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.b_0,operatingMc.b_1,operatingMc.b_2));
         this._clickFwBtn.type = 1;
         addChild(this._clickFwBtn);
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            operatingMc["b_" + _loc2_].gem_mc.gotoAndStop(1);
            _loc2_++;
         }
         var _loc3_:TextField = new TextField();
         _loc3_ = operatingMc.ts_text as TextField;
         _loc3_.embedFonts = true;
         _loc3_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.mask_xx.visible = false;
      }
      
      private function mcVisible() : void
      {
      }
      
      public function getSlot() : InsertSlot
      {
         return this._insertSlot;
      }
   }
}

