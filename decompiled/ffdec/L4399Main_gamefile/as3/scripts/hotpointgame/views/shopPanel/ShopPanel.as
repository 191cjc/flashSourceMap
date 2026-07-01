package hotpointgame.views.shopPanel
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
   import hotpointgame.models.shop.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.taskPanel.*;
   
   public class ShopPanel extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      private static var _instance:ShopPanel;
      
      private var goldDataList:Array = [];
      
      private var djDataList:Array = [];
      
      private var timer:Timer;
      
      private var tNum1:Number = 0;
      
      private var tNum2:Number = 0;
      
      private var bo:Boolean;
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var cName:String;
      
      private var cId:Number;
      
      private var currentShop:Shop;
      
      private var currentGoods:Goods;
      
      private var shopArr:Array = [];
      
      private var shopId:VT = VT.createVT(0);
      
      private var shopNum:VT = VT.createVT(0);
      
      private var _sxDisplay:SxPanel;
      
      private var czMc:MovieClip;
      
      private var sxbtn:BasicClickBtn;
      
      private var sxvipbtn:BasicClickBtn;
      
      private var tm_mc:MovieClip;
      
      private var jsBaxArr:Array = [];
      
      private var dsBaxArr:Array = [];
      
      private var tsGoodsBtn:GoodsBtnX;
      
      private var tsArr:Array = ["本店的个别物品购买后，品质将随机生成，购买时请注意哟！","没看到心仪的商品么？不要灰心，上架商品每30分钟刷新一次的哦！","商品刷新时记得早点过来看看哦，可别让好东西都让其他小朋友给抢走了!","商品刷新时记得早点过来看看哦，可别让好东西都让其他小朋友给抢走了!"];
      
      public function ShopPanel()
      {
         super();
      }
      
      public static function open() : void
      {
         var _loc1_:Array = null;
         GoodsManger.allPanelClose();
         if(_instance == null)
         {
            if(_instance == null)
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc1_ = new Array();
                  _loc1_.push("shoppanel");
                  _loc1_.push("sxpanel");
                  _loc1_.push("t_box");
                  GM.loaderM.setLoadData(_loc1_);
                  GM.loaderM.completeF = loadShoOver;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
         }
         else
         {
            _instance.visible = true;
            _instance.x = 0;
            _instance.initPanel();
         }
      }
      
      private static function loadShoOver() : void
      {
         var _loc4_:MovieClip = null;
         var _loc10_:GoodsBtnX = null;
         var _loc11_:GoodsBtnX = null;
         var _loc1_:Object = LoaderManager.getSwfClass("Shop_Panel") as Class;
         var _loc2_:Object = LoaderManager.getSwfClass("T_Box") as Class;
         var _loc3_:MovieClip = new _loc1_();
         operatingMc = _loc3_;
         _instance = new ShopPanel();
         _instance.addChild(operatingMc);
         GM.bagJm.addChild(ShopPanel._instance);
         var _loc5_:uint = 0;
         while(_loc5_ < 9)
         {
            _loc4_ = new _loc2_();
            _loc4_.name = "js_" + _loc5_;
            _loc10_ = new GoodsBtnX(_loc4_,operatingMc["zz_" + _loc5_].x + 4,operatingMc["zz_" + _loc5_].y);
            _instance.addChild(_loc10_);
            _instance.jsBaxArr.push(_loc10_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < 3)
         {
            _loc4_ = new _loc2_();
            _loc4_.name = "js_" + _loc5_;
            _loc11_ = new GoodsBtnX(_loc4_,operatingMc["zd_" + _loc5_].x + 4,operatingMc["zd_" + _loc5_].y);
            _instance.addChild(_loc11_);
            _instance.dsBaxArr.push(_loc11_);
            _loc5_++;
         }
         _loc4_ = new _loc2_();
         _instance.tsGoodsBtn = new GoodsBtnX(_loc4_,460,267);
         operatingMc.hd_mc.addChild(_instance.tsGoodsBtn);
         var _loc6_:Object = LoaderManager.getSwfClass("Ts_69") as Class;
         _instance.czMc = new _loc6_();
         _instance.addChild(_instance.czMc);
         var _loc7_:Object = LoaderManager.getSwfClass("Tm_mc") as Class;
         _instance.tm_mc = new _loc7_();
         _instance.addChild(_instance.tm_mc);
         _instance.initMcBtn();
         _instance._sxDisplay = SxPanel.createSxpanel();
         _instance.visible = true;
         _instance.x = 0;
         _instance.initPanel();
         var _loc8_:TextField = new TextField();
         _loc8_.mouseEnabled = false;
         _loc8_.defaultTextFormat = new TextFormat("宋体",16,16711680);
         _loc8_.text = "适当娱乐，理性消费";
         _loc8_.width = 300;
         _loc8_.selectable = false;
         _loc8_.x = 425;
         _loc8_.y = 325;
         var _loc9_:TextField = new TextField();
         _loc9_.mouseEnabled = false;
         _loc9_.defaultTextFormat = new TextFormat("宋体",16,16711680);
         _loc9_.text = "适当娱乐，理性消费";
         _loc9_.width = 300;
         _loc9_.selectable = false;
         _loc9_.x = 425;
         _loc9_.y = 320;
         operatingMc.hd_mc.addChild(_loc8_);
         operatingMc.sure_mc.addChild(_loc9_);
      }
      
      public static function close() : void
      {
         if(_instance != null)
         {
            if(_instance.visible)
            {
               _instance.inMcDisplay();
               _instance.removeEvent();
               _instance.visible = false;
               _instance.x = 5000;
            }
         }
      }
      
      private function initPanel() : void
      {
         this.initSxDisplay();
         this.inMcDisplay();
         this.addEvent();
         if(ShopData.dataArr1.length == GS.a0)
         {
            ShopData.initData();
         }
         this.tbXXX();
         this.initData();
         this.initFrame();
         operatingMc.npcts_mc.visible = false;
         this.goldTx();
         ShopData.newShopBo = false;
         this.bo = false;
         this.tNum1 = 0;
         this.tNum2 = 0;
         this.czMc.visible = false;
         this.sxbtn.okBtn = true;
         this.tm_mc.visible = false;
         this.djDisXs();
      }
      
      private function tbXXX() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 9)
         {
            (this.jsBaxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.jsBaxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.jsBaxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            (this.jsBaxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.jsBaxArr[_loc1_] as GoodsBtnX).mouseEnabled = false;
            (this.jsBaxArr[_loc1_] as GoodsBtnX).mouseChildren = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            (this.dsBaxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.dsBaxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.dsBaxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            (this.dsBaxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.dsBaxArr[_loc1_] as GoodsBtnX).mouseEnabled = false;
            (this.dsBaxArr[_loc1_] as GoodsBtnX).mouseChildren = false;
            _loc1_++;
         }
         this.tsGoodsBtn.getSmMc().gx_mc.visible = false;
         this.tsGoodsBtn.getSmMc().mask_mc.gotoAndStop(1);
         this.tsGoodsBtn.getSmMc().d_mc.visible = false;
      }
      
      private function initSxDisplay() : void
      {
         addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function goldTx() : void
      {
         operatingMc.j_tx.text = String(FlowInterface.getGodByRole());
         operatingMc.d_tx.text = String(FlowInterface.getDianJuanByRole());
      }
      
      private function updateHandle(param1:UpdateBagEvent) : void
      {
         this.initData();
         this.initFrame();
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.tian = ShopData.timerNum.getValue() / this.k;
         this.shi = (ShopData.timerNum.getValue() - this.tian * this.k) / 3600;
         this.fen = (ShopData.timerNum.getValue() - this.tian * this.k - this.shi * 3600) / 60;
         this.miao = ShopData.timerNum.getValue() - this.tian * this.k - this.shi * 3600 - this.fen * 60;
         if(this.fen >= 10)
         {
            _loc2_ = String(this.fen);
         }
         else
         {
            _loc2_ = "0" + this.fen;
         }
         if(this.miao >= 10)
         {
            _loc3_ = String(this.miao);
         }
         else
         {
            _loc3_ = "0" + this.miao;
         }
         operatingMc.time_text.text = _loc2_ + ":" + _loc3_;
         this.th3();
      }
      
      private function th3() : void
      {
         var _loc1_:Number = NaN;
         if(!this.bo)
         {
            if(this.tNum1 < 10)
            {
               ++this.tNum1;
            }
            else
            {
               operatingMc.npcts_mc.visible = true;
               _loc1_ = Math.floor(Math.random() * this.tsArr.length);
               operatingMc.npcts_mc.npcts_txt.text = this.tsArr[_loc1_];
               this.bo = true;
               this.tNum1 = 0;
            }
         }
         else if(this.tNum2 < 30)
         {
            ++this.tNum2;
         }
         else
         {
            operatingMc.npcts_mc.visible = false;
            this.bo = false;
            this.tNum2 = 0;
         }
      }
      
      private function addEvent() : void
      {
         this.timer = new Timer(500,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer.start();
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         Main.self.addEventListener(UpdateBagEvent.D0_UPDATE_SHOP,this.updateHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         Main.self.removeEventListener(UpdateBagEvent.D0_UPDATE_SHOP,this.updateHandle);
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:VT = null;
         if((param1.name == "j" || param1.name == "js") && this.goldDataList[param1.id] != null && (ShopData.gArr1[param1.id] as VT).getValue() == 0)
         {
            operatingMc.sure_mc.visible = true;
            addChildAt(operatingMc.sure_mc,numChildren - 1);
            this.currentShop = this.goldDataList[param1.id];
            this.cName = "j";
            this.cId = param1.id;
         }
         else if((param1.name == "d" || param1.name == "ds") && this.djDataList[param1.id] != null && (ShopData.gArr2[param1.id] as VT).getValue() == 0)
         {
            operatingMc.sure_mc.visible = true;
            addChildAt(operatingMc.sure_mc,numChildren - 1);
            this.currentShop = this.djDataList[param1.id];
            this.cName = "d";
            this.cId = param1.id;
         }
         else if(param1.name == "ok")
         {
            operatingMc.sure_mc.visible = false;
            this.shopArr.length = 0;
            if(param1.id == 0)
            {
               if(!this.currentShop.isId() || Boolean(this.currentShop.isId()) && this.currentShop.getIdArr.length > 1)
               {
                  if(BagFactory.equipBag.getAirGirdNum() > 0 && BagFactory.gemBag.getAirGirdNum() > 0 && BagFactory.otherBag.getAirGirdNum() > 0 && BagFactory.clothesBag.getAirGirdNum() > 0)
                  {
                     if(this.currentShop.isDj() == false)
                     {
                        if(FlowInterface.getGodByRole() >= this.currentShop.getGold())
                        {
                           _loc2_ = Math.floor(GS.a10000 * Math.random());
                           this.shopArr = this.currentShop.getGoodsId(_loc2_);
                           if(this.shopArr.length != 0 && Boolean(this.addInBag(this.shopArr[0],this.shopArr[1])))
                           {
                              this.shopId.setValue(this.shopArr[0]);
                              this.shopNum.setValue(this.shopArr[1]);
                              this.tm_mc.visible = true;
                              addChildAt(this.tm_mc,numChildren - 1);
                              GoodsManger.dataList.evData.setJd(GS.a2);
                              FlowInterface.saveDataByKai(this.okFjMv);
                           }
                           else
                           {
                              GoodsManger.cwTs("背包已满");
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("晶币不足");
                        }
                     }
                     else
                     {
                        _loc2_ = Math.floor(GS.a10000 * Math.random());
                        this.shopArr = this.currentShop.getGoodsId(_loc2_);
                        if(this.shopArr.length != 0 && Boolean(BagFactory.isFullById(this.shopArr[0],this.shopArr[1])))
                        {
                           this.shopId.setValue(this.shopArr[0]);
                           this.shopNum.setValue(this.shopArr[1]);
                           this.tm_mc.visible = true;
                           addChildAt(this.tm_mc,numChildren - 1);
                           GoodsManger.dataList.evData.setJd(GS.a2);
                           FlowInterface.djGouMai(this.currentShop.getShopId(),GS.a1,this.currentShop.getGold(),this.djScOk,GS.a0);
                        }
                        else
                        {
                           GoodsManger.cwTs("背包已满");
                        }
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
               else if(this.currentShop.isDj() == false)
               {
                  if(FlowInterface.getGodByRole() >= this.currentShop.getGold())
                  {
                     if(this.addInBag(this.currentShop.getIdArr()[0],this.currentShop.getNumArr()[0],false))
                     {
                        BagFactory.hdGoodsTs(this.currentShop.getIdArr()[0],this.currentShop.getNumArr()[0]);
                        TaskData.isGoodsOk(this.currentShop.getIdArr()[0]);
                        TaskData.isXtOk(1);
                        GoodsManger.dataList.evData.setJd(GS.a2);
                     }
                     else
                     {
                        GoodsManger.cwTs("背包已满");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
               }
               else if(BagFactory.isFullById(this.currentShop.getIdArr()[0],this.currentShop.getNumArr()[0]))
               {
                  this.shopId.setValue(this.currentShop.getIdArr()[0]);
                  this.shopNum.setValue(this.currentShop.getNumArr()[0]);
                  this.tm_mc.visible = true;
                  addChildAt(this.tm_mc,numChildren - 1);
                  GoodsManger.dataList.evData.setJd(GS.a2);
                  FlowInterface.djGouMai(this.currentShop.getShopId(),GS.a1,this.currentShop.getGold(),this.djScOkone,GS.a0);
               }
               else
               {
                  GoodsManger.cwTs("背包已满");
               }
            }
            this.goldTx();
         }
         else if(param1.name == "okk")
         {
            operatingMc.hd_mc.visible = false;
         }
         else if(param1.name == "sx")
         {
            this.tm_mc.visible = true;
            addChildAt(this.tm_mc,numChildren - 1);
            _loc3_ = VT.createVT(ShopData.sxTimes.getValue());
            this.sxbtn.okBtn = false;
            FlowInterface.djGouMai(ShopData.getShopId(_loc3_.getValue()),GS.a1,ShopData.getShopGold(_loc3_.getValue()),this.djGmOkSx,GS.a0);
            this.djDisXs();
         }
         else if(param1.name == "sxvip")
         {
            if(BagFactory.getNumById(GS.a331115) > GS.a0)
            {
               if(BagFactory.deteleGoods(GS.a331115,GS.a1))
               {
                  ShopData.initData();
                  this.tm_mc.visible = true;
                  addChildAt(this.tm_mc,numChildren - 1);
                  GoodsManger.dataList.evData.setJd(GS.a3);
                  FlowInterface.saveDataByKai(this.vipSxOne);
               }
            }
            else
            {
               GoodsManger.cwTs("VIP刷新道具不足");
            }
         }
         else if(param1.name == "npc")
         {
            this.tNum2 = 0;
            operatingMc.npcts_mc.visible = false;
            this.bo = false;
            this.tNum1 = 10;
         }
         else if(param1.name != "t")
         {
            if(param1.name == "cz")
            {
               FlowInterface.gotoShopPanel();
               this.czMc.visible = false;
            }
            else if(param1.name == "sure")
            {
               this.czMc.visible = false;
            }
         }
      }
      
      private function djScOk(param1:Number) : void
      {
         this.tm_mc.visible = false;
         if(param1 == GS.a1)
         {
            this.tm_mc.visible = true;
            addChildAt(this.tm_mc,numChildren - 1);
            this.addInBag(this.shopId.getValue(),this.shopNum.getValue());
            FlowInterface.saveDataByKaiOnlyShop(this.okFjMv);
            this.goldTx();
         }
         else
         {
            this.czMc.visible = true;
            addChildAt(this.czMc,numChildren - 1);
         }
      }
      
      private function djScOkone(param1:Number) : void
      {
         this.tm_mc.visible = false;
         if(param1 == GS.a1)
         {
            this.tm_mc.visible = true;
            addChildAt(this.tm_mc,numChildren - 1);
            this.addInBag(this.shopId.getValue(),this.shopNum.getValue());
            FlowInterface.saveDataByKaiOnlyShop(this.onelyOk);
         }
         else
         {
            this.czMc.visible = true;
            addChildAt(this.czMc,numChildren - 1);
         }
      }
      
      private function onelyOk() : void
      {
         this.okFj();
         this.tm_mc.visible = false;
      }
      
      private function djGmOkSx(param1:Number) : void
      {
         if(param1 == GS.a1)
         {
            ShopData.initData();
            this.initData();
            GoodsManger.dataList.evData.setJd(GS.a3);
            if(ShopData.sxTimes.getValue() < ShopData.sxAllTimes.getValue())
            {
               ShopData.sxTimes.setValue(ShopData.sxTimes.getValue() + GS.a1);
            }
            else
            {
               ShopData.sxTimes.setValue(ShopData.sxAllTimes.getValue());
            }
            FlowInterface.saveDataByKaiOnlyShop();
            GoodsManger.saveMoviclip(this.sxOne,"Ts_50");
            this.goldTx();
            this.tm_mc.visible = false;
         }
         else
         {
            this.czMc.visible = true;
            addChildAt(this.czMc,numChildren - 1);
            this.tm_mc.visible = false;
         }
         this.sxbtn.okBtn = true;
      }
      
      private function vipSxOne() : void
      {
         this.tm_mc.visible = false;
         GoodsManger.saveMoviclip(this.sxOne,"Ts_50");
      }
      
      private function sxOne() : void
      {
         if(this.visible)
         {
            this.initFrame();
         }
      }
      
      private function addInBag(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         if(BagFactory.addInBagById(param1,param2,GS.a0))
         {
            if(this.currentShop.isDj() != true)
            {
               FlowInterface.redGodByRole(this.currentShop.getGold());
            }
            if(this.cName == "j")
            {
               ShopData.gArr1[this.cId] = VT.createVT(1);
            }
            else if(this.cName == "d")
            {
               ShopData.gArr2[this.cId] = VT.createVT(1);
            }
            this.initFrame();
            return true;
         }
         return false;
      }
      
      private function okFjMv() : void
      {
         this.tm_mc.visible = false;
         GoodsManger.saveMoviclip(this.okFj,"Ts_53");
      }
      
      private function okFj() : void
      {
         this.goldTx();
         if(!this.currentShop.isId() || Boolean(this.currentShop.isId()) && this.currentShop.getIdArr.length > 1)
         {
            operatingMc.hd_mc.visible = true;
            addChildAt(operatingMc.hd_mc,numChildren - 1);
            this.currentGoods = GoodsFactory.createGoodsById(this.shopId.getValue());
            this.tsGoodsBtn.getSmMc().gotoAndStop(this.currentGoods.getFrame());
            operatingMc.hd_mc.name_text.text = this.currentGoods.getName();
            (operatingMc.hd_mc.name_text as TextField).setTextFormat(this.currentGoods.getColorStr());
            operatingMc.hd_mc.num_text.text = String(this.shopNum.getValue());
         }
         BagFactory.hdGoodsTs(this.shopId.getValue(),this.shopNum.getValue());
         TaskData.isGoodsOk(this.shopId.getValue());
         TaskData.isXtOk(1);
         this.currentShop = null;
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         operatingMc.sm_mc.visible = false;
         operatingMc.btnTs.visible = false;
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Shop = null;
         var _loc3_:Goods = null;
         if(param1.name == "j")
         {
            operatingMc["j_" + param1.id].gotoAndStop(2);
            if(this.goldDataList[param1.id] != null && (ShopData.gArr1[param1.id] as VT).getValue() == 0)
            {
               _loc2_ = this.goldDataList[param1.id];
               if(_loc2_.isId() && _loc2_.getIdArr().length == 1)
               {
                  _loc3_ = GoodsFactory.createGoodsById(_loc2_.getIdArr()[0]);
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
               }
               else
               {
                  operatingMc.sm_mc.visible = true;
                  operatingMc.sm_mc.x = this.parent.mouseX;
                  operatingMc.sm_mc.y = this.parent.mouseY;
                  operatingMc.sm_mc.name_text.text = _loc2_.getSm();
               }
            }
         }
         else if(param1.name == "d")
         {
            operatingMc["d_" + param1.id].gotoAndStop(2);
            if(this.djDataList[param1.id] != null && (ShopData.gArr2[param1.id] as VT).getValue() == 0)
            {
               _loc2_ = this.djDataList[param1.id];
               if(_loc2_.isId() && _loc2_.getIdArr().length == 1)
               {
                  _loc3_ = GoodsFactory.createGoodsById(_loc2_.getIdArr()[0]);
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
               }
               else
               {
                  operatingMc.sm_mc.visible = true;
                  operatingMc.sm_mc.x = this.parent.mouseX;
                  operatingMc.sm_mc.y = this.parent.mouseY;
                  operatingMc.sm_mc.name_text.text = _loc2_.getSm();
               }
            }
         }
         else if(param1.name == "xx")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.currentGoods));
         }
         else if(param1.name == "t")
         {
            operatingMc.btnTs.visible = true;
            operatingMc.btnTs.jn_3.text = "商店内所有商品每30分钟刷新一次!" + "\n" + "注意:下线后倒计时将被重置";
            operatingMc.btnTs.x = mouseX + 20;
            operatingMc.btnTs.y = mouseY;
         }
      }
      
      private function djDisXs() : void
      {
         var _loc1_:VT = VT.createVT(ShopData.sxTimes.getValue());
         operatingMc.sxMcXX.sxTx.text = String("刷新需求星钻:" + ShopData.getShopGold(_loc1_.getValue()));
      }
      
      public function initData() : void
      {
         this.goldDataList = ShopData.dataArr1;
         this.djDataList = ShopData.dataArr2;
      }
      
      private function initFrame() : void
      {
         var _loc1_:Shop = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.goldDataList.length)
         {
            operatingMc["jt_" + _loc2_].name_text.text = "";
            operatingMc["jt_" + _loc2_].lv_text.text = "";
            operatingMc["jt_" + _loc2_].gold_text.text = "";
            (this.jsBaxArr[_loc2_] as GoodsBtnX).visible = false;
            operatingMc["zz_" + _loc2_].visible = false;
            (this.jsBaxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = "";
            if(this.goldDataList[_loc2_] != null)
            {
               _loc1_ = this.goldDataList[_loc2_] as Shop;
               if((ShopData.gArr1[_loc2_] as VT).getValue() == 0)
               {
                  (this.jsBaxArr[_loc2_] as GoodsBtnX).visible = true;
                  (this.jsBaxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc1_.getFrame());
                  if(_loc1_.getShopNum() != "1")
                  {
                     (this.jsBaxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc1_.getShopNum());
                  }
                  operatingMc["jt_" + _loc2_].name_text.htmlText = String(_loc1_.getName());
                  operatingMc["jt_" + _loc2_].lv_text.text = _loc1_.getLevel();
                  operatingMc["jt_" + _loc2_].gold_text.text = _loc1_.getGold();
               }
               else
               {
                  operatingMc["zz_" + _loc2_].visible = true;
               }
            }
            else
            {
               operatingMc["zz_" + _loc2_].visible = true;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.djDataList.length)
         {
            (this.dsBaxArr[_loc2_] as GoodsBtnX).visible = false;
            operatingMc["dt_" + _loc2_].name_text.text = "";
            operatingMc["dt_" + _loc2_].lv_text.text = "";
            operatingMc["dt_" + _loc2_].gold_text.text = "";
            operatingMc["zd_" + _loc2_].visible = false;
            if(this.djDataList[_loc2_] != null)
            {
               _loc1_ = this.djDataList[_loc2_] as Shop;
               if((ShopData.gArr2[_loc2_] as VT).getValue() == 0)
               {
                  (this.dsBaxArr[_loc2_] as GoodsBtnX).visible = true;
                  (this.dsBaxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc1_.getFrame());
                  if(_loc1_.getShopNum() != "1")
                  {
                     (this.dsBaxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc1_.getShopNum());
                  }
                  operatingMc["dt_" + _loc2_].name_text.htmlText = _loc1_.getName();
                  operatingMc["dt_" + _loc2_].lv_text.text = _loc1_.getLevel();
                  operatingMc["dt_" + _loc2_].gold_text.text = _loc1_.getGold();
               }
               else
               {
                  operatingMc["zd_" + _loc2_].visible = true;
               }
            }
            else
            {
               operatingMc["zd_" + _loc2_].visible = true;
            }
            _loc2_++;
         }
      }
      
      private function initMcBtn() : void
      {
         var _loc10_:BasicClickBtn = null;
         var _loc11_:BasicClickBtn = null;
         var _loc12_:BasicClickBtn = null;
         var _loc1_:BasicBtn = new BasicClickBtn(operatingMc.t_btn);
         addChild(_loc1_);
         var _loc2_:uint = 0;
         while(_loc2_ < 9)
         {
            operatingMc["jt_" + _loc2_].goldmc.gotoAndStop(1);
            _loc10_ = new BasicClickBtn(operatingMc["j_" + _loc2_]);
            addChild(_loc10_);
            operatingMc["zz_" + _loc2_].visible = false;
            (operatingMc["zz_" + _loc2_] as MovieClip).mouseEnabled = false;
            (operatingMc["zz_" + _loc2_] as MovieClip).mouseChildren = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            operatingMc["dt_" + _loc2_].goldmc.gotoAndStop(2);
            _loc11_ = new BasicClickBtn(operatingMc["d_" + _loc2_]);
            addChild(_loc11_);
            operatingMc["zd_" + _loc2_].visible = false;
            (operatingMc["zd_" + _loc2_] as MovieClip).mouseEnabled = false;
            (operatingMc["zd_" + _loc2_] as MovieClip).mouseChildren = false;
            _loc2_++;
         }
         var _loc3_:CloseBtn = new CloseBtn(operatingMc.close_btn);
         addChild(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            _loc12_ = new BasicClickBtn(operatingMc.sure_mc["ok_" + _loc2_]);
            addChild(_loc12_);
            _loc2_++;
         }
         var _loc4_:BasicClickBtn = new BasicClickBtn(operatingMc.hd_mc["okk_" + 0]);
         addChild(_loc4_);
         this.sxbtn = new BasicClickBtn(operatingMc.sx_btn);
         addChild(this.sxbtn);
         this.sxvipbtn = new BasicClickBtn(operatingMc.sxvip_btn);
         addChild(this.sxvipbtn);
         var _loc5_:BasicClickBtn = new BasicClickBtn(operatingMc.list_btn);
         addChild(_loc5_);
         var _loc6_:BasicClickBtn = new BasicClickBtn(operatingMc.npc_btn);
         addChild(_loc6_);
         operatingMc.gxx_mc.mouseEnabled = false;
         operatingMc.gxx_mc.mouseChildren = false;
         var _loc7_:TextField = new TextField();
         _loc7_ = operatingMc.npcts_mc.npcts_txt;
         _loc7_.embedFonts = true;
         _loc7_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         this.addChildAt(operatingMc.sm_mc,numChildren - 1);
         operatingMc.time_text.embedFonts = true;
         operatingMc.time_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,22);
         operatingMc.d_tx.embedFonts = true;
         operatingMc.d_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.j_tx.embedFonts = true;
         operatingMc.j_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         (operatingMc.time_text as TextField).mouseEnabled = false;
         operatingMc.btnTs.visible = false;
         this.addChildAt(operatingMc.btnTs,numChildren - 1);
         var _loc8_:BasicClickBtn = new BasicClickBtn(this.czMc.cz_0);
         addChild(_loc8_);
         var _loc9_:BasicClickBtn = new BasicClickBtn(this.czMc.sure_0);
         addChild(_loc9_);
      }
      
      private function inMcDisplay() : void
      {
         operatingMc.sm_mc.visible = false;
         operatingMc.sm_mc.mouseEnabled = false;
         operatingMc.sure_mc.visible = false;
         operatingMc.hd_mc.visible = false;
         this.czMc.visible = false;
      }
   }
}

