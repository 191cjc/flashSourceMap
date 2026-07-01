package hotpointgame.views.comPanel
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.taskPanel.*;
   
   public class ComPanel extends MovieClip
   {
      
      private static var _instance:ComPanel;
      
      private static var cbx:int;
      
      public var _state:Number = GS.a0;
      
      private var _stateBtn:SameChangeBtn;
      
      private var jB0:BasicBtn;
      
      private var jB1:BasicBtn;
      
      private var comMc:MovieClip;
      
      private var bagDisplay:BagDisplay;
      
      private var comSlot:ComSlot;
      
      private var goodsBox:MovieClip = new MovieClip();
      
      private var slotBox:MovieClip = new MovieClip();
      
      private var lzBoxBtn:MovieClip = new MovieClip();
      
      public var LzMc:MovieClip = new MovieClip();
      
      private var bgheight:int = 232;
      
      private var okBtn:BasicBtn;
      
      private var ckBtn:BasicBtn;
      
      private var hdGoods:Goods;
      
      private var tk0:MovieClip = new MovieClip();
      
      private var tk1:MovieClip = new MovieClip();
      
      private var hcMv:MovieClip = new MovieClip();
      
      private var _sxDisplay:SxPanel;
      
      private var currGoods:Goods;
      
      private var currPos:Number = 0;
      
      private var currId:Number;
      
      private var jpSlotArr:Array = [];
      
      private var numArr:Array = [];
      
      private var currJpNum:uint = 0;
      
      private var currJpInAllNum:uint;
      
      private var zzMc:MovieClip;
      
      private var xxStr:String;
      
      public function ComPanel()
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
               _loc1_.push("companel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadComOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.visible = true;
         _instance.initPanel();
      }
      
      private static function loadComOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtn = null;
         var _loc9_:uint = 0;
         var _loc10_:MovieClip = null;
         var _loc11_:GoodsBtn = null;
         var _loc12_:MovieClip = null;
         var _loc13_:GoodsBtn = null;
         if(cbx == -1)
         {
            _instance = new ComPanel();
            _loc1_ = LoaderManager.getSwfClass("Com_Panel") as Class;
            _instance.comMc = new _loc1_();
            _instance.addChild(_instance.comMc);
            _instance.addChild(_instance.goodsBox);
            _instance.addChild(_instance.slotBox);
            _instance.addChild(_instance.lzBoxBtn);
            _loc2_ = LoaderManager.getSwfClass("Zz_mc") as Class;
            _instance.zzMc = new _loc2_();
            _instance.addChild(_instance.zzMc);
            _loc3_ = LoaderManager.getSwfClass("Lz_Box") as Class;
            _instance.LzMc = new _loc3_();
            _instance.LzMc.x = 101;
            _instance.LzMc.y = 182;
            _instance.addChild(_instance.LzMc);
            _loc4_ = LoaderManager.getSwfClass("Tk_0") as Class;
            _instance.tk0 = new _loc4_();
            _instance.addChild(_instance.tk0);
            _loc5_ = LoaderManager.getSwfClass("Tk_1") as Class;
            _instance.tk1 = new _loc5_();
            _instance.addChild(_instance.tk1);
            _loc6_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc7_ = new _loc6_();
            _loc7_.name = "wp_" + 0;
            _instance.tk1.wp_mc.addChild(_loc7_);
            _loc8_ = new GoodsBtn(_loc7_);
            _instance.addChild(_loc8_);
            _loc9_ = 0;
            while(_loc9_ < 6)
            {
               _loc10_ = new _loc6_();
               _loc10_.name = "e_" + _loc9_;
               _loc10_.x = _instance.comMc["d1_" + _loc9_].x;
               _loc10_.y = _instance.comMc["d1_" + _loc9_].y;
               _instance.goodsBox.addChild(_loc10_);
               _loc11_ = new GoodsBtn(_loc10_);
               _instance.addChild(_loc11_);
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < 3)
            {
               _loc12_ = new _loc6_();
               _loc12_.name = "s_" + _loc9_;
               _loc12_.x = _instance.comMc["d2_" + _loc9_].x;
               _loc12_.y = _instance.comMc["d2_" + _loc9_].y;
               _instance.slotBox.addChild(_loc12_);
               _loc13_ = new GoodsBtn(_loc12_);
               _instance.addChild(_loc13_);
               _loc9_++;
            }
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.bagDisplay = BagDisplay.createBagDisplay(572,93.15);
            _instance.initBtn();
            _instance.comSlot = BagFactory.comSlot;
            GM.bagJm.addChild(_instance);
            _instance.visible = true;
            _instance.initPanel();
         }
      }
      
      public static function close() : void
      {
         cbx = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance.bagDisplay.close();
            _instance.closeDate();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      private function initPanel() : void
      {
         this.initBag();
         this.addEvent();
         this._state = GS.a0;
         this._stateBtn.btnOk(this._state);
         this.currId = -1;
         this.currGoods = null;
         this.currJpNum = GS.a0;
         this.initMc();
         this.jpFrameDisplay();
         this.czTs();
      }
      
      private function czTs() : void
      {
         if(this._state == GS.a0)
         {
            if(this.isSlotFull())
            {
               this.xxStr = "你可以开始合成了";
            }
            else if(this.comSlot.getGoods(0) == null)
            {
               this.xxStr = "请选择放入主物品";
            }
            else
            {
               this.xxStr = "请选择放入辅助物品";
            }
         }
         else if(this._state == GS.a1)
         {
            if(this.isSlotFull())
            {
               if(this.currPos == 0)
               {
                  this.xxStr = "你可以开始合成了";
               }
               else
               {
                  this.xxStr = "请先满足物品需求的数量";
               }
            }
            else
            {
               this.xxStr = "请选择您要合成的晶片";
            }
         }
         this.comMc.ts_text.text = String(this.xxStr);
         GoodsManger.tsFunction("Ts_48",104,520);
      }
      
      private function initJpFrame() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         this.jpSlotArr = [];
         if(ComData.jpArr.length != 0)
         {
            if(ComData.jpArr[this.currJpNum] == null)
            {
               if(this.currJpNum > GS.a0)
               {
                  this.currJpNum -= GS.a1;
               }
               else
               {
                  this.currJpNum = 0;
               }
            }
            this.jpSlotArr = ComData.jpArr[this.currJpNum];
            if(this.jpSlotArr.length != 0)
            {
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  if(this.goodsBox.getChildAt(_loc1_) as MovieClip)
                  {
                     _loc2_ = this.goodsBox.getChildAt(_loc1_) as MovieClip;
                     _loc2_.gotoAndStop(1);
                     _loc2_.t_txt.text = "";
                     _loc2_.mask_mc.gotoAndStop(1);
                     if(this.jpSlotArr[_loc1_] != null)
                     {
                        _loc2_.gotoAndStop((this.jpSlotArr[_loc1_][0] as Goods).getFrame());
                        _loc2_.t_txt.text = String(this.jpSlotArr[_loc1_][1]);
                        if(this.jpSlotArr[_loc1_][2] == 0)
                        {
                           _loc2_.mask_mc.gotoAndStop(1);
                        }
                        else
                        {
                           _loc2_.mask_mc.gotoAndStop(2);
                        }
                     }
                  }
                  _loc1_++;
               }
            }
            else
            {
               this.initJpSlotFrame();
            }
         }
         else
         {
            this.initJpSlotFrame();
         }
      }
      
      private function addSlot(param1:Goods, param2:Number) : Boolean
      {
         var _loc3_:uint = 0;
         while(_loc3_ < 3)
         {
            if(this.comSlot.getGoods(_loc3_) == null)
            {
               this.comSlot.addToBag(param1,_loc3_,param2);
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function backGoods(param1:Number) : Boolean
      {
         var _loc2_:Goods = null;
         var _loc3_:Number = NaN;
         if(this.comSlot.getGoods(param1) != null)
         {
            _loc2_ = this.comSlot.getGoods(param1);
            _loc3_ = Number(this.comSlot.getGoodsNum(param1));
            if(BagFactory.isFullBagOnlyOne(_loc2_,_loc3_))
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,-1,0,_loc3_));
               this.comSlot.deleteBag(param1,_loc3_);
               return true;
            }
            GoodsManger.cwTs("背包已满");
         }
         return false;
      }
      
      private function isXf(param1:Goods, param2:Number) : Boolean
      {
         var _loc4_:Goods = null;
         var _loc3_:uint = 0;
         while(_loc3_ < 3)
         {
            if(this.comSlot.getGoods(_loc3_) != null)
            {
               _loc4_ = this.comSlot.getGoods(_loc3_);
               if(!(_loc4_.getType() == 1 && _loc4_.getSmallType() == 12))
               {
                  if(_loc4_.getType() == GS.a0)
                  {
                     if(_loc4_.getType() != param1.getType() || _loc4_.getJob() != param1.getJob() || this.isSz(_loc4_) != this.isSz(param1))
                     {
                        if(!this.backGoods(_loc3_))
                        {
                           Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,param1,-1,0,param2));
                           return true;
                        }
                        if(_loc4_.getType() != param1.getType())
                        {
                           GoodsManger.cwTs("只有类型相同的物品才能合成");
                        }
                        else if(this.isSz(_loc4_) != this.isSz(param1))
                        {
                           GoodsManger.cwTs("只有类型相同的物品才能合成");
                        }
                        else
                        {
                           GoodsManger.cwTs("只有职业相同的物品才能合成");
                        }
                     }
                  }
                  else if(_loc4_.getType() != param1.getType() || _loc4_.getSmallType() != param1.getSmallType())
                  {
                     if(!this.backGoods(_loc3_))
                     {
                        Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,param1,-1,0,param2));
                        return true;
                     }
                     GoodsManger.cwTs("只有类型相同的物品才能合成");
                  }
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      private function isSz(param1:Goods) : uint
      {
         if(param1.getSmallType() >= 0 && param1.getSmallType() <= 7)
         {
            return 0;
         }
         if(param1.getSmallType() >= 8 && param1.getSmallType() <= 15)
         {
            return 1;
         }
         return 0;
      }
      
      private function changeSlot(param1:Goods, param2:Number) : void
      {
         var _loc3_:Goods = null;
         if(param1.getType() == GS.a1 && param1.getSmallType() == GS.a12)
         {
            if(this.comSlot.getGoods(GS.a1) == null)
            {
               this.comSlot.addToBag(param1,1,param2);
            }
            else if(this.comSlot.getGoods(2) == null)
            {
               this.comSlot.addToBag(param1,2,param2);
            }
            else
            {
               _loc3_ = this.comSlot.getGoods(2);
               if(this.backGoods(GS.a2))
               {
                  this.comSlot.addToBag(param1,2,param2);
               }
               else
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,param1,-1,0,param2));
               }
            }
         }
         else if(this.isXf(param1,param2) == false)
         {
            if(this.comSlot.getGoods(GS.a0) == null)
            {
               this.addSlot(param1,param2);
            }
            else if(this.addSlot(param1,param2))
            {
               if(this.backGoods(2))
               {
                  this.addSlot(param1,param2);
               }
               else
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,param1,-1,0,param2));
               }
            }
         }
      }
      
      private function initFrame() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Goods = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.slotBox.numChildren)
         {
            _loc2_ = this.slotBox.getChildAt(_loc1_) as MovieClip;
            _loc2_.gotoAndStop(1);
            _loc2_.mask_mc.gotoAndStop(1);
            _loc2_.gx_mc.visible = false;
            _loc2_.t_txt.text = "";
            _loc1_++;
         }
         if(this._state == GS.a0)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               if(this.comSlot.getGoods(_loc1_) != null)
               {
                  _loc3_ = this.comSlot.getGoods(_loc1_);
                  _loc4_ = Number(this.comSlot.getGoodsNum(_loc1_));
                  (this.slotBox.getChildAt(_loc1_) as MovieClip).gotoAndStop(_loc3_.getFrame());
                  if(_loc4_ > 1)
                  {
                     ((this.slotBox.getChildAt(_loc1_) as MovieClip).t_txt as TextField).text = String(_loc4_);
                  }
                  this.comMc["ll_" + _loc1_].visible = false;
               }
               else
               {
                  (this.slotBox.getChildAt(_loc1_) as MovieClip).gotoAndStop(1);
                  ((this.slotBox.getChildAt(_loc1_) as MovieClip).t_txt as TextField).text = "";
                  this.comMc["ll_" + _loc1_].visible = true;
               }
               _loc1_++;
            }
         }
         else if(this._state == GS.a1)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               if(this.comSlot.getGoods(_loc1_) != null)
               {
                  _loc3_ = this.comSlot.getGoods(_loc1_);
                  (this.slotBox.getChildAt(_loc1_) as MovieClip).gotoAndStop(_loc3_.getFrame());
                  _loc5_ = "ffff00";
                  _loc6_ = Number(this.numInBag(_loc3_));
                  if(this.numArr[_loc1_] > _loc6_)
                  {
                     _loc5_ = "ff0000";
                     (this.slotBox.getChildAt(_loc1_) as MovieClip).mask_mc.gotoAndStop(2);
                  }
                  _loc7_ = "<font color=\"#" + _loc5_ + "\">" + String(_loc6_) + "</font>";
                  _loc8_ = "<font>" + String(this.numArr[_loc1_]) + "</font>";
                  ((this.slotBox.getChildAt(_loc1_) as MovieClip).t_txt as TextField).htmlText = _loc7_ + "/" + _loc8_;
                  this.comMc["ll_" + _loc1_].visible = false;
               }
               else
               {
                  (this.slotBox.getChildAt(_loc1_) as MovieClip).gotoAndStop(1);
                  ((this.slotBox.getChildAt(_loc1_) as MovieClip).t_txt as TextField).text = "";
                  this.comMc["ll_" + _loc1_].visible = true;
               }
               _loc1_++;
            }
         }
      }
      
      private function numInBag(param1:Goods) : Number
      {
         return BagFactory.getNumById(param1.getId());
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.sameChangeHandle);
         addEventListener(GoodsEvent.DO_COM,this.comHandle);
         addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         addEventListener(BtnEvent.DO_DOWN,this.downFn);
      }
      
      private function wheelFn(param1:MouseEvent) : void
      {
         if(param1.delta < 0)
         {
            if(this.LzMc["up_2"].y <= this.bgheight - this.LzMc["up_2"].height - this.LzMc["up_1"].height - 12)
            {
               this.LzMc["up_2"].y += 12;
               this.moveHandler(null);
            }
         }
         else if(this.LzMc["up_2"].y >= 12 + this.LzMc["up_0"].height)
         {
            this.LzMc["up_2"].y -= 12;
            this.moveHandler(null);
         }
      }
      
      private function wearGoodsHandle(param1:BtnEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Goods = null;
         if(param1.name == "s")
         {
            if(this._state == GS.a0)
            {
               this.backGoods(param1.id);
               this.initNaxx();
               this.initFrame();
               this.isOKBtn();
               this.comMc.gold_text.text = "";
               this.czTs();
               this.bagDisplay.tbMastMc();
            }
         }
         else if(param1.name == "e")
         {
            if(this.jpSlotArr[param1.id] != null)
            {
               _loc2_ = false;
               if(this._state == GS.a0)
               {
                  this.backComSlotToBag();
                  if(this.comSlot.getGoods(0) == null && this.comSlot.getGoods(1) == null && this.comSlot.getGoods(2) == null)
                  {
                     _loc2_ = true;
                  }
                  this.initFrame();
                  this.isOKBtn();
               }
               else if(this._state == GS.a1)
               {
                  _loc2_ = true;
               }
            }
            if(_loc2_)
            {
               _loc3_ = this.jpSlotArr[param1.id][0] as Goods;
               this.currGoods = _loc3_;
               this.currPos = this.jpSlotArr[param1.id][2];
               this.currId = param1.id;
               dispatchEvent(new GoodsEvent(GoodsEvent.DO_COM,_loc3_,param1.id,GS.a1));
               this.gxFun(this.goodsBox,param1.name,param1.id,true);
               this.gxFunFalse(this.goodsBox,param1.name,param1.id);
               this.currJpInAllNum = this.currId + this.currJpNum * 6;
            }
         }
      }
      
      private function gxFunFalse(param1:MovieClip, param2:String, param3:Number) : void
      {
         var _loc5_:MovieClip = null;
         var _loc4_:uint = 0;
         while(_loc4_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc4_) as MovieClip)
            {
               _loc5_ = param1.getChildAt(_loc4_) as MovieClip;
               if(_loc5_.name != param2 + "_" + param3)
               {
                  _loc5_.gx_mc.visible = false;
               }
            }
            _loc4_++;
         }
      }
      
      private function comHandle(param1:GoodsEvent) : void
      {
         if(param1.typeb == 0)
         {
            if(this._state == GS.a1)
            {
               this.deleteComSlot();
               this.currGoods = null;
               this.currId = -1;
               this.gxFunFalse(this.goodsBox,"e",this.currId);
            }
         }
         else if(param1.typeb == 1)
         {
            if(this._state == GS.a1)
            {
               this.deleteComSlot();
            }
         }
         this._state = param1.typeb;
         this._stateBtn.btnOk(this._state);
         if(this._state == GS.a0)
         {
            this.changeSlot(param1.goods,param1.goodsNum);
         }
         else if(this._state == GS.a1)
         {
            this.addSlotStateTow(param1.goods);
         }
         this.initFrame();
         this.getDataArr();
         this.nameFunXX();
         this.JbFunXX();
         this.isOKBtn();
         this.czTs();
         this.bagDisplay.tbMastMc();
      }
      
      private function addSlotStateTow(param1:Goods) : void
      {
         var _loc2_:Array = param1.getNeedId();
         this.numArr = param1.getNeedNum();
         var _loc3_:uint = 0;
         while(_loc3_ < 3)
         {
            this.comSlot.addToBag(GoodsFactory.createGoodsById(_loc2_[_loc3_]),_loc3_,GS.a1);
            _loc3_++;
         }
      }
      
      private function getDataArr() : Array
      {
         var _loc1_:VT = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         ComData.dataArr.length = 0;
         if(this._state == GS.a0)
         {
            if(this.isSlotFull())
            {
               _loc1_ = VT.createVT(0);
               _loc1_.setValue(Math.floor((this.comSlot.getGoods(GS.a0).getQuality() + this.comSlot.getGoods(GS.a1).getQuality() + this.comSlot.getGoods(GS.a2).getQuality()) / GS.a3));
               ComData.setDataArr(GoodsFactory.getGoodsIdByJz(_loc1_.getValue(),this.comSlot.getGoods(GS.a0)));
            }
         }
         else if(this._state == GS.a1)
         {
            _loc2_ = this.currGoods.getLwId();
            _loc3_ = this.currGoods.getLwNum();
            _loc4_ = this.currGoods.getRewGl();
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               if(!_loc5_[_loc6_])
               {
                  _loc5_[_loc6_] = [];
               }
               _loc5_[_loc6_] = [GoodsFactory.getGoodsById(_loc2_[_loc6_]),_loc4_[_loc6_],_loc3_[_loc6_]];
               _loc6_++;
            }
            ComData.setDataArr(_loc5_);
         }
         return [];
      }
      
      private function nameFunXX() : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc1_:Number = 1;
         this.initNaxx();
         if(this.isSlotFull())
         {
            _loc2_ = ComData.dataArr;
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               if(_loc2_[_loc3_] != null)
               {
                  if(this._state == GS.a1)
                  {
                     _loc1_ = Number(_loc2_[_loc3_][2]);
                  }
                  else
                  {
                     _loc1_ = 1;
                  }
                  this.comMc["nxx_" + _loc3_].text = (_loc2_[_loc3_][0] as GoodsData).getName() + "*" + _loc1_ + "(" + Math.floor(_loc2_[_loc3_][1] / GS.a100) + "%" + ")";
                  (this.comMc["nxx_" + _loc3_] as TextField).setTextFormat((_loc2_[_loc3_][0] as GoodsData).getColorStr());
               }
               _loc3_++;
            }
         }
      }
      
      private function JbFunXX() : void
      {
         var _loc2_:Number = NaN;
         this.comMc.gold_text.text = "";
         var _loc1_:TextFormat = new TextFormat();
         if(this.heGold() != -1)
         {
            _loc2_ = Number(this.heGold());
            this.comMc.gold_text.text = String(_loc2_);
            FlowInterface.getGodByRole();
            if(_loc2_ < FlowInterface.getGodByRole())
            {
               _loc1_.color = "0xFFFFFF";
            }
            else
            {
               _loc1_.color = "0xFF0000";
            }
            (this.comMc.gold_text as TextField).setTextFormat(_loc1_);
         }
      }
      
      private function heGold() : Number
      {
         if(this._state == GS.a0)
         {
            if(this.comSlot.getGoods(0) != null)
            {
               return this.comSlot.getGoods(0).getHcJg();
            }
         }
         else if(this._state == GS.a1)
         {
            if(this.currGoods != null)
            {
               return this.currGoods.getHcJg();
            }
         }
         return -1;
      }
      
      private function initNaxx() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            this.comMc["nxx_" + _loc1_].text = "";
            _loc1_++;
         }
      }
      
      private function isOKBtn() : void
      {
         if(this._state == GS.a0)
         {
            if(this.isSlotFull())
            {
               this.ckBtn.okBtn = true;
               this.okBtn.okBtn = true;
            }
            else
            {
               this.ckBtn.okBtn = false;
               this.okBtn.okBtn = false;
               this.initLzMc();
            }
         }
         else if(this._state == GS.a1)
         {
            this.ckBtn.okBtn = true;
            this.okBtn.okBtn = true;
            if(this.currGoods != null)
            {
               if(this.currPos == 0)
               {
                  this.okBtn.okBtn = true;
               }
               else
               {
                  this.okBtn.okBtn = false;
               }
            }
            else
            {
               this.ckBtn.okBtn = false;
               this.okBtn.okBtn = false;
               this.initLzMc();
            }
         }
      }
      
      private function lzFunction() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:GoodsBtn = null;
         var _loc13_:MovieClip = null;
         this.initLzMc();
         if(ComData.dataArr.length != 0)
         {
            _loc1_ = ComData.dataArr;
            _loc2_ = ComData.getArr(ComData.dataArr,3);
            _loc3_ = this.LzMc.lz_mc.sm_mc;
            _loc4_ = this.LzMc.lz_mc.sm_mc2;
            _loc5_ = LoaderManager.getSwfClass("Hc_mc") as Class;
            _loc6_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc7_ = -1;
            _loc8_ = 0;
            while(_loc8_ < _loc2_.length)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc2_[_loc8_].length)
               {
                  _loc10_ = new _loc5_();
                  _loc10_.x = _loc10_.width * _loc9_ + 20 * _loc9_ + 1;
                  _loc10_.y = _loc10_.height * _loc8_ + 20 * _loc8_ + 1;
                  _loc3_.addChild(_loc10_);
                  _loc11_ = new _loc6_();
                  _loc7_++;
                  _loc11_.name = "lz_" + _loc7_;
                  _loc11_.x = _loc10_.width * _loc9_ + 20 * _loc9_ + 1 + 14;
                  _loc11_.y = _loc10_.height * _loc8_ + 20 * _loc8_ + 1 + 5;
                  _loc4_.addChild(_loc11_);
                  _loc12_ = new GoodsBtn(_loc11_);
                  this.lzBoxBtn.addChild(_loc12_);
                  _loc9_++;
               }
               _loc8_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc3_.numChildren)
            {
               _loc13_ = _loc3_.getChildAt(_loc9_) as MovieClip;
               _loc13_.name_text.text = (_loc1_[_loc9_][0] as GoodsData).getName();
               (_loc13_.name_text as TextField).setTextFormat((_loc1_[_loc9_][0] as GoodsData).getColorStr());
               _loc13_.num_text.text = String(Math.floor(_loc1_[_loc9_][1] / GS.a100)) + "%";
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc4_.numChildren)
            {
               (_loc4_.getChildAt(_loc9_) as MovieClip).gotoAndStop((_loc1_[_loc9_][0] as GoodsData).getFrame());
               (_loc4_.getChildAt(_loc9_) as MovieClip).mask_mc.gotoAndStop(1);
               (_loc4_.getChildAt(_loc9_) as MovieClip).gx_mc.visible = false;
               if(this._state == GS.a0)
               {
                  ((_loc4_.getChildAt(_loc9_) as MovieClip).t_txt as TextField).text = String(GS.a1);
               }
               else if(this._state == GS.a1)
               {
                  ((_loc4_.getChildAt(_loc9_) as MovieClip).t_txt as TextField).text = String(_loc1_[_loc9_][2]);
               }
               _loc9_++;
            }
         }
      }
      
      private function initLzMc() : void
      {
         var _loc1_:MovieClip = this.LzMc.lz_mc.sm_mc;
         var _loc2_:MovieClip = this.LzMc.lz_mc.sm_mc2;
         var _loc3_:uint = uint(_loc2_.numChildren);
         while(_loc3_ > 0)
         {
            _loc2_.removeChild(_loc2_.getChildAt(_loc3_ - 1));
            _loc3_--;
         }
         _loc3_ = uint(_loc1_.numChildren);
         while(_loc3_ > 0)
         {
            _loc1_.removeChild(_loc1_.getChildAt(_loc3_ - 1));
            _loc3_--;
         }
         _loc3_ = uint(this.lzBoxBtn.numChildren);
         while(_loc3_ > 0)
         {
            this.lzBoxBtn.removeChild(this.lzBoxBtn.getChildAt(_loc3_ - 1));
            _loc3_--;
         }
      }
      
      private function isSlotFull() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            if(this.comSlot.getGoods(_loc1_) == null)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function sameChangeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "b")
         {
            if(param1.id == 0)
            {
               if(this._state == GS.a1)
               {
                  this.initStateTow();
               }
               this._state = param1.id;
            }
            else if(param1.id == 1)
            {
               if(this._state == GS.a0)
               {
                  this.backComSlotToBag();
                  if(this.comSlot.getGoods(0) == null && this.comSlot.getGoods(1) == null && this.comSlot.getGoods(2) == null)
                  {
                     this._state = param1.id;
                     this._stateBtn.btnOk(this._state);
                  }
                  else
                  {
                     this._state = GS.a0;
                     this._stateBtn.btnOk(this._state);
                  }
               }
               else if(this._state == GS.a1)
               {
                  this.initStateTow();
               }
            }
            this.isOKBtn();
            this.nameFunXX();
            this.JbFunXX();
            this.initFrame();
            this.czTs();
            this.bagDisplay.tbMastMc();
         }
      }
      
      private function initStateTow() : void
      {
         this.deleteComSlot();
         this.currGoods = null;
         this.currId = -1;
         this.currJpNum = 0;
         this.initJpFrame();
         this.gxFunFalse(this.goodsBox,"e",this.currId);
         this.jtBtn();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         if(param1.name == "up")
         {
            if(param1.id == 0)
            {
               if(this.LzMc["up_2"].y >= 6 + this.LzMc["up_0"].height)
               {
                  this.LzMc["up_2"].y -= 6;
                  this.moveHandler(null);
               }
            }
            else if(param1.id == 1)
            {
               if(this.LzMc["up_2"].y <= this.bgheight - this.LzMc["up_2"].height - this.LzMc["up_1"].height - 6)
               {
                  this.LzMc["up_2"].y += 6;
                  this.moveHandler(null);
               }
            }
         }
         else if(param1.name == "ck")
         {
            if(this.bagDisplay._typeState == 0)
            {
               this.lzFunction();
               this.LzMc.visible = true;
               addChildAt(this.LzMc,numChildren - 1);
               addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelFn);
            }
         }
         else if(param1.name == "ok")
         {
            if(BagFactory.bagOnlyGird())
            {
               if(FlowInterface.getGodByRole() >= this.heGold())
               {
                  _loc2_ = Math.floor(Math.random() * GS.a10000);
                  if(ComData.getGoodsByGl(_loc2_).length != 0)
                  {
                     _loc3_ = ComData.getGoodsByGl(_loc2_);
                     if(BagFactory.isFullBagOnlyOne(_loc3_[0],_loc3_[1]))
                     {
                        this.hdGoods = _loc3_[0];
                        FlowInterface.redGodByRole(this.heGold());
                        this.deleteComSlot();
                        this.deleteJp();
                        BagFactory.addInBagByGoods(this.hdGoods,_loc3_[1],true);
                        this.jpFrameDisplay();
                        this.zzMc.visible = true;
                        addChildAt(this.zzMc,numChildren - 1);
                        FlowInterface.saveDataByKai(this.goldComOkMv);
                        this.initFrame();
                        this.nameFunXX();
                        this.JbFunXX();
                        GoodsManger.dataList.evData.setJd(GS.a18);
                     }
                     else
                     {
                        GoodsManger.cwTs("背包不足以放入合成后出现的物品");
                     }
                  }
                  else
                  {
                     FlowInterface.redGodByRole(this.heGold());
                     if(this._state == GS.a0)
                     {
                        _loc4_ = 1;
                        while(_loc4_ < 3)
                        {
                           if(this.comSlot.getGoods(_loc4_) != null)
                           {
                              this.comSlot.deleteBag(_loc4_,GS.a1);
                           }
                           _loc4_++;
                        }
                     }
                     else if(this._state == GS.a1)
                     {
                        this.deleteComSlot();
                     }
                     this.deleteJp();
                     this.zzMc.visible = true;
                     addChildAt(this.zzMc,numChildren - 1);
                     FlowInterface.saveDataByKai(this.goldComLostMv);
                     this.jpFrameDisplay();
                     this.initFrame();
                     this.nameFunXX();
                     this.JbFunXX();
                     GoodsManger.dataList.evData.setJd(GS.a18);
                  }
                  this.isOKBtn();
                  this.bagDisplay.getGoldTx();
               }
               else
               {
                  GoodsManger.cwTs("晶币不足");
               }
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
         else if(param1.name == "okk")
         {
            this.tk0.visible = false;
         }
         else if(param1.name == "okkk")
         {
            this.tk1.visible = false;
            this.hdGoods = null;
         }
         else if(param1.name == "j")
         {
            _loc2_ = 0;
            if(param1.id == 0)
            {
               if(_loc2_ > 0)
               {
                  _loc2_--;
               }
            }
            else if(param1.id == 1)
            {
               if(_loc2_ < ComData.jpNum)
               {
                  _loc2_++;
               }
            }
            this.currJpNum = _loc2_;
            this.initJpFrame();
            this.jtBtn();
            this.gsIsOk();
         }
      }
      
      private function gsIsOk() : void
      {
         if(this.currId != -1)
         {
            if(this.currId + this.currJpNum * 6 == this.currJpInAllNum)
            {
               this.gxFun(this.goodsBox,"e",this.currId,true);
            }
            else
            {
               this.gxFunFalse(this.goodsBox,"e",-1);
            }
         }
      }
      
      private function jtBtn() : void
      {
         if(ComData.jpNum == 0 || ComData.jpNum == GS.a1)
         {
            this.jB0.okBtn = false;
            this.jB1.okBtn = false;
            return;
         }
         if(this.currJpNum <= 0)
         {
            this.jB0.okBtn = false;
            this.jB1.okBtn = true;
         }
         else if(this.currJpNum >= ComData.jpNum - 1)
         {
            this.jB0.okBtn = true;
            this.jB1.okBtn = false;
         }
      }
      
      private function goldComOkMv() : void
      {
         GoodsManger.movicpStr(this.comMc.d2_0.x + this.comMc.d2_0.width / 2,this.comMc.d2_0.y + this.comMc.d2_0.height / 2,this.okComMv,"Hc_Mv");
      }
      
      private function okComMv() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         if(this.visible)
         {
            this.tk1.visible = true;
            addChildAt(this.tk1,numChildren - 1);
            _loc1_ = 0;
            while(_loc1_ < this.tk1.wp_mc.numChildren)
            {
               if(this.tk1.wp_mc.getChildAt(_loc1_) is MovieClip)
               {
                  _loc2_ = this.tk1.wp_mc.getChildAt(_loc1_);
                  _loc2_.gotoAndStop(this.hdGoods.getFrame());
                  _loc2_.mask_mc.gotoAndStop(1);
                  _loc2_.gx_mc.visible = false;
               }
               _loc1_++;
            }
            this.tk1.name_text.text = this.hdGoods.getName();
            (this.tk1.name_text as TextField).setTextFormat(this.hdGoods.getColorStr());
            this.tk1.num_text.text = String(GS.a1);
            this.zzMc.visible = false;
         }
         GoodsManger.cwTs("合成成功");
         BagFactory.hdGoodsTs(this.hdGoods.getId(),GS.a1);
         TaskData.isGoodsOk(this.hdGoods.getId());
      }
      
      private function goldComLostMv() : void
      {
         GoodsManger.movicpStr(this.comMc.d2_0.x + this.comMc.d2_0.width / 2,this.comMc.d2_0.y + this.comMc.d2_0.height / 2,this.lostComMv,"Hc_Mv");
      }
      
      private function lostComMv() : void
      {
         if(this.visible)
         {
            this.tk0.visible = true;
            addChildAt(this.tk0,numChildren - 1);
            this.zzMc.visible = false;
         }
         GoodsManger.cwTs("合成失败");
      }
      
      private function deleteComSlot() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            if(this.comSlot.getGoods(_loc1_) != null)
            {
               this.comSlot.deleteBag(_loc1_,GS.a1);
            }
            _loc1_++;
         }
      }
      
      private function deleteJp() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         if(this._state == GS.a1)
         {
            if(this.currGoods != null)
            {
               _loc1_ = this.currGoods.getNeedId();
               _loc2_ = this.currGoods.getNeedNum();
               BagFactory.deteleGoods(this.currGoods.getId(),GS.a1);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  BagFactory.deteleGoods(_loc1_[_loc3_],_loc2_[_loc3_]);
                  _loc3_++;
               }
               this.currGoods = null;
               this.currId = -1;
               this.gxFunFalse(this.goodsBox,"e",this.currId);
            }
         }
         this.bagDisplay.initGoodsDisplay(this.bagDisplay._bagState);
      }
      
      public function jpFrameDisplay() : void
      {
         ComData.initData();
         this.initJpFrame();
         this.jtBtn();
      }
      
      public function sXForBag() : void
      {
         ComData.initData();
         this.currJpNum = 0;
         this.initJpFrame();
         this.currId = -1;
         this.currGoods = null;
         this.gxFunFalse(this.goodsBox,"e",this.currId);
         if(this._state == GS.a1)
         {
            this.deleteComSlot();
         }
         this.initFrame();
         this.jtBtn();
         this.isOKBtn();
         this.nameFunXX();
         this.JbFunXX();
         this.czTs();
         this.bagDisplay.tbMastMc();
      }
      
      private function backComSlotToBag() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            if(this.comSlot.getGoods(_loc1_) != null)
            {
               this.backGoods(_loc1_);
            }
            _loc1_++;
         }
      }
      
      private function isfullXX() : Boolean
      {
         if(this.comSlot.getGoods(0) != null && this.comSlot.getGoods(1) != null && this.comSlot.getGoods(2) != null)
         {
            return true;
         }
         return false;
      }
      
      private function downFn(param1:BtnEvent) : void
      {
         if(param1.name == "up" && param1.id == 2)
         {
            this.LzMc["up_2"].startDrag(false,new Rectangle(1.5,this.LzMc["up_0"].height,0,this.bgheight - this.LzMc["up_2"].height - 2 * this.LzMc["up_1"].height));
            addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
            addEventListener(MouseEvent.MOUSE_UP,this.upHandler);
         }
      }
      
      private function upHandler(param1:MouseEvent) : void
      {
         this.LzMc["up_2"].stopDrag();
         this.moveHandler(null);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         removeEventListener(MouseEvent.MOUSE_UP,this.upHandler);
      }
      
      private function moveHandler(param1:MouseEvent) : void
      {
         this.LzMc.lz_mc.y = -Math.floor(this.LzMc.lz_mc.height - this.bgheight) * ((this.LzMc["up_2"].y - this.LzMc["up_0"].height) / (this.bgheight - this.LzMc["up_2"].height - 2 * this.LzMc["up_0"].height));
         if(param1 != null)
         {
            param1.updateAfterEvent();
         }
      }
      
      private function gxFun(param1:MovieClip, param2:String, param3:Number, param4:Boolean) : void
      {
         var _loc6_:MovieClip = null;
         var _loc5_:uint = 0;
         while(_loc5_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc5_) as MovieClip)
            {
               _loc6_ = param1.getChildAt(_loc5_) as MovieClip;
               if(_loc6_.name == param2 + "_" + param3)
               {
                  _loc6_.gx_mc.visible = param4;
                  break;
               }
            }
            _loc5_++;
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         if(param1.name == "lz")
         {
            _loc2_ = this.LzMc.lz_mc.sm_mc2;
            this.gxFun(_loc2_,param1.name,param1.id,false);
         }
         else if(param1.name == "s")
         {
            this.gxFun(this.slotBox,param1.name,param1.id,false);
         }
         else if(param1.name == "wp")
         {
            this.gxFun(this.tk1.wp_mc,param1.name,param1.id,false);
         }
         else if(param1.name == "e")
         {
            _loc3_ = this.currJpInAllNum - this.currJpNum * 6;
            if(this.currId != -1)
            {
               if(_loc3_ != param1.id)
               {
                  this.gxFun(this.goodsBox,param1.name,param1.id,false);
               }
            }
            else
            {
               this.gxFun(this.goodsBox,param1.name,param1.id,false);
            }
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:GoodsData = null;
         var _loc4_:Array = null;
         var _loc5_:MovieClip = null;
         if(param1.name == "lz")
         {
            _loc4_ = ComData.dataArr;
            _loc3_ = _loc4_[param1.id][0] as GoodsData;
            _loc2_ = _loc3_.createGoods();
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
            this.LzMc.lz_mc.sm_mc2;
            _loc5_ = this.LzMc.lz_mc.sm_mc2;
            this.gxFun(_loc5_,param1.name,param1.id,true);
         }
         else if(param1.name == "s")
         {
            if(this.comSlot.getGoods(param1.id) != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.comSlot.getGoods(param1.id)));
               this.gxFun(this.slotBox,param1.name,param1.id,true);
            }
         }
         else if(param1.name == "wp")
         {
            if(this.hdGoods != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.hdGoods));
               this.gxFun(this.tk1.wp_mc,param1.name,param1.id,true);
            }
         }
         else if(param1.name == "e")
         {
            if(this.jpSlotArr[param1.id] != null)
            {
               _loc2_ = this.jpSlotArr[param1.id][0] as Goods;
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
               this.gxFun(this.goodsBox,param1.name,param1.id,true);
            }
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "comclose")
         {
            close();
         }
         else if(param1.name == "ckclose")
         {
            this.LzMc.visible = false;
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelFn);
         }
      }
      
      private function closeDate() : void
      {
         if(this._state == GS.a0)
         {
            this.backComSlotToBag();
         }
         else if(this._state == GS.a1)
         {
            this.deleteComSlot();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.sameChangeHandle);
         removeEventListener(GoodsEvent.DO_COM,this.comHandle);
         removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
         removeEventListener(BtnEvent.DO_DOWN,this.downFn);
      }
      
      private function initBtn() : void
      {
         var _loc6_:BasicClickBtn = null;
         var _loc7_:BasicClickBtn = null;
         var _loc8_:BasicClickBtn = null;
         var _loc1_:CloseBtn = new CloseBtn(this.comMc.comclose_btn);
         addChild(_loc1_);
         var _loc2_:CloseBtn = new CloseBtn(this.LzMc.ckclose_btn);
         addChild(_loc2_);
         this._stateBtn = SameChangeBtn.createSameChangeBtn(new Array(this.comMc["b_" + 0],this.comMc["b_" + 1]));
         addChild(this._stateBtn);
         this.jB0 = new BasicClickBtn(this.comMc["j_" + 0]);
         addChild(this.jB0);
         this.jB1 = new BasicClickBtn(this.comMc["j_" + 1]);
         addChild(this.jB1);
         var _loc3_:uint = 0;
         while(_loc3_ < 2)
         {
            _loc6_ = new BasicClickBtn(this.LzMc["up_" + _loc3_]);
            addChild(_loc6_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 1)
         {
            _loc7_ = new BasicClickBtn(this.tk0["okk_" + _loc3_]);
            addChild(_loc7_);
            _loc8_ = new BasicClickBtn(this.tk1["okkk_" + _loc3_]);
            addChild(_loc8_);
            _loc3_++;
         }
         var _loc4_:DownBtn = new DownBtn(this.LzMc["up_" + 2]);
         addChild(_loc4_);
         this.ckBtn = new BasicClickBtn(this.comMc["ck_btn"]);
         addChild(this.ckBtn);
         this.okBtn = new BasicClickBtn(this.comMc["ok_btn"]);
         addChild(this.okBtn);
         var _loc5_:TextField = new TextField();
         _loc5_ = this.comMc.ts_text as TextField;
         _loc5_.embedFonts = true;
         _loc5_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16,16777215);
      }
      
      private function initBag() : void
      {
         addChild(this.bagDisplay);
         this.bagDisplay.init();
         this.bagDisplay._parentMc = this;
         this.bagDisplay.tbMastMc();
         addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function initMc() : void
      {
         this.initJpSlotFrame();
         this.initFrame();
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            this.comMc["j_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.comMc["ck_btn"].gotoAndStop(1);
         this.comMc["ok_btn"].gotoAndStop(1);
         this.LzMc.visible = false;
         this.tk0.visible = false;
         this.tk1.visible = false;
         this.initNaxx();
         this.hcMv.visible = false;
         this.hcMv.gotoAndStop(1);
         this.isOKBtn();
         this.hdGoods = null;
         this.zzMc.visible = false;
         this.comMc.gold_text.text = "";
      }
      
      private function initJpSlotFrame() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.goodsBox.numChildren)
         {
            _loc2_ = this.goodsBox.getChildAt(_loc1_) as MovieClip;
            _loc2_.gotoAndStop(1);
            _loc2_.mask_mc.gotoAndStop(1);
            _loc2_.gx_mc.visible = false;
            _loc2_.t_txt.text = "";
            _loc1_++;
         }
      }
      
      public function getSlot() : ComSlot
      {
         return this.comSlot;
      }
   }
}

