package hotpointgame.views.signPanel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class SignPanel extends MovieClip
   {
      
      private static var _instance:SignPanel;
      
      private static var cbx:Number = -1;
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var sign:MovieClip = new MovieClip();
      
      private var qdBtnArr:Array = [];
      
      private var lqBtnArr:Array = [];
      
      private var jtBtnArr:Array = [];
      
      private var dateBtnArr:Array = [];
      
      private var qdArr:Array = [];
      
      private var bqNum:VT = VT.createVT(GS.a1);
      
      private var czingMc:MovieClip = new MovieClip();
      
      private var czMc:MovieClip = new MovieClip();
      
      private var data:SignData;
      
      public function SignPanel()
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
               _loc1_.push("signpanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadSignOver;
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
      
      public static function loadSignOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:CloseBtnX = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:ClickBtnX = null;
         var _loc8_:ClickBtnX = null;
         var _loc9_:TextField = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:ClickBtnX = null;
         var _loc13_:ClickBtnX = null;
         var _loc14_:MovieClip = null;
         var _loc15_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new SignPanel();
            _loc1_ = LoaderManager.getSwfClass("Sign") as Class;
            _instance.sign = new _loc1_();
            _instance.addChild(_instance.sign);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc10_ = new ClickBtnX(_instance.sign["q_" + _loc2_],_instance.sign["q_" + _loc2_].x,_instance.sign["q_" + _loc2_].y);
               _instance.qdBtnArr.push(_loc10_);
               _instance.sign.addChild(_loc10_);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc11_ = new ClickBtnX(_instance.sign["l_" + _loc2_],_instance.sign["l_" + _loc2_].x,_instance.sign["l_" + _loc2_].y);
               _instance.lqBtnArr.push(_loc11_);
               _instance.sign.addChild(_loc11_);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _loc12_ = new ClickBtnX(_instance.sign.ts_mc["jt_" + _loc2_],_instance.sign.ts_mc["jt_" + _loc2_].x,_instance.sign.ts_mc["jt_" + _loc2_].y);
               _instance.jtBtnArr.push(_loc12_);
               _instance.sign.ts_mc.addChild(_loc12_);
               _loc2_++;
            }
            _loc3_ = new CloseBtnX(_instance.sign.close_btn,_instance.sign.close_btn.x,_instance.sign.close_btn.y);
            _instance.endMc.addChild(_loc3_);
            _loc4_ = LoaderManager.getSwfClass("Sm_mc") as Class;
            (_instance.sign.gx_mc as MovieClip).mouseChildren = false;
            (_instance.sign.gx_mc as MovieClip).mouseEnabled = false;
            _instance.sign.addChild(_instance.sign.gx_mc);
            _loc2_ = 0;
            while(_loc2_ < 42)
            {
               _loc13_ = new ClickBtnX(_instance.sign["d_" + _loc2_],_instance.sign["d_" + _loc2_].x,_instance.sign["d_" + _loc2_].y);
               _instance.dateBtnArr.push(_loc13_);
               _instance.sign.addChild(_loc13_);
               (_instance.sign["num_" + _loc2_] as MovieClip).mouseChildren = false;
               (_instance.sign["num_" + _loc2_] as MovieClip).mouseEnabled = false;
               _instance.sign.addChild(_instance.sign["num_" + _loc2_]);
               _loc14_ = new _loc4_();
               _loc14_.x = _instance.sign["d_" + _loc2_].x;
               _loc14_.y = _instance.sign["d_" + _loc2_].y;
               _loc14_.mouseChildren = false;
               _loc14_.mouseEnabled = false;
               _instance.qdArr.push(_loc14_);
               _instance.sign.addChild(_loc14_);
               _loc2_++;
            }
            _instance.sign.addChild(_instance.sign.ts_mc);
            _loc5_ = LoaderManager.getSwfClass("Ts_74");
            _instance.czingMc = new _loc5_();
            _instance.upMc.addChild(_instance.czingMc);
            _loc6_ = LoaderManager.getSwfClass("Ts_69") as Class;
            _instance.czMc = new _loc6_();
            _instance.upMc.addChild(_instance.czMc);
            _loc7_ = new ClickBtnX(_instance.czMc.cz_0,_instance.czMc.cz_0.x,_instance.czMc.cz_0.y);
            _instance.czMc.addChild(_loc7_);
            _loc8_ = new ClickBtnX(_instance.czMc.sure_0,_instance.czMc.sure_0.x,_instance.czMc.sure_0.y);
            _instance.czMc.addChild(_loc8_);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc15_ = new ClickBtnX(_instance.sign["liwu_" + _loc2_],_instance.sign["liwu_" + _loc2_].x,_instance.sign["liwu_" + _loc2_].y);
               _instance.sign.addChild(_loc15_);
               _loc2_++;
            }
            _instance.upMc.addChild(_instance.sign.liwu_tx);
            GM.bagJm.addChild(_instance);
            _instance.ztFun();
            _instance.initPanel();
            _loc9_ = new TextField();
            _loc9_.mouseEnabled = false;
            _loc9_.defaultTextFormat = new TextFormat("宋体",16,16711680);
            _loc9_.text = "适当娱乐，理性消费";
            _loc9_.width = 300;
            _loc9_.selectable = false;
            _loc9_.x = 425;
            _loc9_.y = 320;
            _instance.sign.ts_mc.addChild(_loc9_);
         }
      }
      
      private function initPanel() : void
      {
         this.data = GoodsManger.dataList.sgnData;
         this.data.initDisplay();
         this.initMc();
         this.addEvent();
         this.initFrame();
         this.initState();
         this.isQdBtn();
         this.isLqOk();
         this.txFun();
         this.mcGo();
      }
      
      private function mcGo() : void
      {
         var _loc1_:Number = GM.serverDateC.sMonth + GS.a1;
         this.sign.qd_mc.gotoAndStop(_loc1_);
         this.sign.date_tx.text = GM.serverDateC.sYear + "年" + _loc1_ + "月";
      }
      
      private function isLqOk() : void
      {
         if(this.data.getrewdState()[0].getValue() == -1)
         {
            if(this.data.getQdNum() < GS.a5)
            {
               (this.lqBtnArr[0] as ClickBtnX).okBtn = false;
            }
            else
            {
               (this.lqBtnArr[0] as ClickBtnX).okBtn = true;
            }
            this.sign["l_" + 0].s_tx.text = "领取";
         }
         else
         {
            this.sign["l_" + 0].s_tx.text = "已领";
            (this.lqBtnArr[0] as ClickBtnX).okBtn = false;
         }
         if(this.data.getrewdState()[1].getValue() == -1)
         {
            if(this.data.getQdNum() < GS.a15)
            {
               (this.lqBtnArr[1] as ClickBtnX).okBtn = false;
            }
            else
            {
               (this.lqBtnArr[1] as ClickBtnX).okBtn = true;
            }
            this.sign["l_" + 1].s_tx.text = "领取";
         }
         else
         {
            this.sign["l_" + 1].s_tx.text = "已领";
            (this.lqBtnArr[1] as ClickBtnX).okBtn = false;
         }
         if(this.data.getrewdState()[2].getValue() == -1)
         {
            if(this.data.getQdNum() < GS.a26)
            {
               (this.lqBtnArr[2] as ClickBtnX).okBtn = false;
            }
            else
            {
               (this.lqBtnArr[2] as ClickBtnX).okBtn = true;
            }
            this.sign["l_" + 2].s_tx.text = "领取";
         }
         else
         {
            this.sign["l_" + 2].s_tx.text = "已领";
            (this.lqBtnArr[2] as ClickBtnX).okBtn = false;
         }
      }
      
      private function txFun() : void
      {
         this.sign.bq_num.text = String(this.data.getbqNum());
         this.sign.qd_num.text = String(this.data.getQdNum());
      }
      
      private function isQdBtn() : void
      {
         if(this.data.getStateArr()[this.data.getQdId()].getValue() == GS.a0)
         {
            (this.qdBtnArr[0] as ClickBtnX).okBtn = true;
         }
         else
         {
            (this.qdBtnArr[0] as ClickBtnX).okBtn = false;
         }
         if(this.data.getbqNum() > GS.a0)
         {
            (this.qdBtnArr[1] as ClickBtnX).okBtn = true;
         }
         else
         {
            (this.qdBtnArr[1] as ClickBtnX).okBtn = false;
         }
      }
      
      private function initState() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a42)
         {
            if(_loc1_ < this.data.getQdId())
            {
               if(this.data.getDateArr()[_loc1_].getValue() != -1)
               {
                  this.qdArr[_loc1_].visible = true;
                  if(this.data.getStateArr()[_loc1_].getValue() == GS.a0)
                  {
                     this.qdArr[_loc1_].gotoAndStop(2);
                  }
                  else if(this.data.getStateArr()[_loc1_].getValue() == GS.a1)
                  {
                     this.qdArr[_loc1_].gotoAndStop(1);
                  }
               }
            }
            else if(_loc1_ == this.data.getQdId())
            {
               if(this.data.getStateArr()[_loc1_].getValue() == GS.a1)
               {
                  this.qdArr[_loc1_].visible = true;
                  this.qdArr[_loc1_].gotoAndStop(1);
               }
            }
            _loc1_++;
         }
      }
      
      private function initFrame() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a42)
         {
            if(this.data.getDateArr()[_loc1_].getValue() != -1)
            {
               this.sign["num_" + _loc1_].gotoAndStop(this.data.getDateArr()[_loc1_].getValue());
            }
            else
            {
               this.sign["num_" + _loc1_].gotoAndStop(GS.a1);
            }
            if(this.data.getQdId() == _loc1_)
            {
               this.sign.gx_mc.x = this.sign["num_" + _loc1_].x;
               this.sign.gx_mc.y = this.sign["num_" + _loc1_].y;
            }
            _loc1_++;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         if(param1.name == "liwu")
         {
            this.sign.liwu_tx.visible = true;
            this.sign.liwu_tx.x = 250;
            if(param1.id == 0)
            {
               this.sign.liwu_tx.y = 190;
               this.sign.liwu_tx.liwutx.text = "天使币*2、10W晶币袋*1、梦魇之戒（神农之影）*1";
            }
            else if(param1.id == 1)
            {
               this.sign.liwu_tx.y = 310;
               this.sign.liwu_tx.liwutx.text = "天使币*3、20W晶币袋*1、梦魇之戒（亚丁湾）*1、合成宝石*1";
            }
            else if(param1.id == 2)
            {
               this.sign.liwu_tx.y = 435;
               this.sign.liwu_tx.liwutx.text = "天使币*5、30W晶币袋*1、梦魇之戒（永恒国度）*1合成宝石*2、超级合成宝石*2、银河海盗的财宝箱*30、低级斗魂石*2";
            }
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "liwu")
         {
            this.sign.liwu_tx.visible = false;
            this.sign.liwu_tx.x = 0;
            this.sign.liwu_tx.y = 0;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "d")
         {
            if(param1.id == this.data.getQdId())
            {
               if(this.data.getStateArr()[param1.id].getValue() == GS.a0 && this.data.getDateArr()[param1.id].getValue() != -1)
               {
                  if(BagFactory.isFullById(this.data.qdGoodsId.getValue(),GS.a1))
                  {
                     BagFactory.addInBagById(this.data.qdGoodsId.getValue(),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(this.data.qdGoodsId.getValue(),GS.a1);
                     this.data.qdFun(param1.id);
                     GoodsManger.dataList.evData.setJd(GS.a0);
                     this.initState();
                     this.isQdBtn();
                     this.isLqOk();
                     this.txFun();
                     FlowInterface.saveDataByKai();
                     GoodsManger.cwTs("签到成功获得银河海盗财宝箱一个");
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
            }
            else if(param1.id < this.data.getQdId() && this.data.getStateArr()[param1.id].getValue() == GS.a0)
            {
               if(this.data.getbqNum() > GS.a0)
               {
                  this.bqNum.setValue(GS.a1);
                  this.sign.ts_mc.visible = true;
                  GoodsManger.dataList.evData.setJd(GS.a0);
                  this.sign.ts_mc.num_tx.text = String(GS.a1);
                  this.sign.ts_mc.needText.text = "补领" + this.bqNum.getValue() + "天" + "需要" + this.bqNum.getValue() * GS.a100 + "星钻";
               }
            }
         }
         else if(param1.name == "q" && param1.id == GS.a1)
         {
            this.bqNum.setValue(GS.a1);
            this.sign.ts_mc.visible = true;
            this.sign.ts_mc.num_tx.text = String(GS.a1);
            this.sign.ts_mc.needText.text = "补领" + this.bqNum.getValue() + "天" + "需要" + this.bqNum.getValue() * GS.a100 + "星钻";
         }
         else if(param1.name == "q" && param1.id == GS.a0)
         {
            if(this.data.getStateArr()[this.data.getQdId()].getValue() == GS.a0)
            {
               if(BagFactory.isFullById(this.data.qdGoodsId.getValue(),GS.a1))
               {
                  BagFactory.addInBagById(this.data.qdGoodsId.getValue(),GS.a1,GS.a0);
                  this.data.qdFun(this.data.getQdId());
                  BagFactory.hdGoodsTs(this.data.qdGoodsId.getValue(),GS.a1);
                  this.initState();
                  this.isQdBtn();
                  this.isLqOk();
                  this.txFun();
                  GoodsManger.dataList.evData.setJd(GS.a0);
                  FlowInterface.saveDataByKai();
                  GoodsManger.cwTs("签到成功获得银河海盗财宝箱一个");
               }
               else
               {
                  GoodsManger.cwTs("背包已满");
               }
            }
         }
         else if(param1.name == "jt")
         {
            if(param1.id == GS.a0)
            {
               this.sign.ts_mc.visible = false;
               this.czingMc.visible = true;
               FlowInterface.djGouMai(GS.a650,this.bqNum.getValue(),GS.a100,this.shopingBq,GS.a0);
            }
            else if(param1.id == GS.a1)
            {
               this.sign.ts_mc.visible = false;
            }
            else if(param1.id == GS.a2)
            {
               if(this.bqNum.getValue() > GS.a1)
               {
                  this.bqNum.setValue(this.bqNum.getValue() - GS.a1);
               }
               else
               {
                  this.bqNum.setValue(this.data.getbqNum());
               }
               this.sign.ts_mc.num_tx.text = String(this.bqNum.getValue());
               this.sign.ts_mc.needText.text = "补领" + this.bqNum.getValue() + "天" + "需要" + this.bqNum.getValue() * GS.a100 + "星钻";
            }
            else if(param1.id == GS.a3)
            {
               if(this.bqNum.getValue() < this.data.getbqNum())
               {
                  this.bqNum.setValue(this.bqNum.getValue() + GS.a1);
               }
               else
               {
                  this.bqNum.setValue(GS.a1);
               }
               this.sign.ts_mc.num_tx.text = String(this.bqNum.getValue());
               this.sign.ts_mc.needText.text = "补领" + this.bqNum.getValue() + "天" + "需要" + this.bqNum.getValue() * GS.a100 + "星钻";
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
         else if(param1.name == "l")
         {
            if(param1.id == 0)
            {
               if(this.data.getrewdState()[GS.a0].getValue() == -1 && this.data.getQdNum() >= GS.a5)
               {
                  if(BagFactory.isFullById(this.data.getReadGoods(GS.a0),GS.a1))
                  {
                     BagFactory.addInBagById(this.data.getReadGoods(GS.a0),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(this.data.getReadGoods(GS.a0),GS.a1);
                     this.data.setRewdState(GS.a0);
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
            }
            else if(param1.id == 1)
            {
               if(this.data.getrewdState()[GS.a1].getValue() == -1 && this.data.getQdNum() >= GS.a15)
               {
                  if(BagFactory.isFullById(this.data.getReadGoods(GS.a1),GS.a1))
                  {
                     BagFactory.addInBagById(this.data.getReadGoods(GS.a1),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(this.data.getReadGoods(GS.a1),GS.a1);
                     this.data.setRewdState(GS.a1);
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
            }
            else if(param1.id == 2)
            {
               if(this.data.getrewdState()[GS.a2].getValue() == -1 && this.data.getQdNum() >= GS.a26)
               {
                  if(BagFactory.isFullById(this.data.getReadGoods(GS.a2),GS.a1))
                  {
                     BagFactory.addInBagById(this.data.getReadGoods(GS.a2),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(this.data.getReadGoods(GS.a2),GS.a1);
                     this.data.setRewdState(GS.a2);
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
            }
            this.isLqOk();
         }
      }
      
      private function shopingBq(param1:Number) : void
      {
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            this.data.bqFun(this.bqNum.getValue());
            FlowInterface.saveDataByKaiOnlyShop();
            GoodsManger.cwTs("补签成功");
            this.initState();
            this.isQdBtn();
            this.isLqOk();
            this.txFun();
         }
         else
         {
            this.czMc.visible = true;
         }
      }
      
      private function initMc() : void
      {
         this.visible = true;
         this.sign.ts_mc.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 42)
         {
            this.qdArr[_loc1_].visible = false;
            _loc1_++;
         }
         this.czingMc.visible = false;
         this.czMc.visible = false;
         this.sign.liwu_tx.visible = false;
      }
      
      private function ztFun() : void
      {
         this.sign.date_tx.embedFonts = true;
         this.sign.date_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,22);
         this.sign.bq_num.embedFonts = true;
         this.sign.bq_num.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         this.sign.qd_num.embedFonts = true;
         this.sign.qd_num.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            this.sign["l_" + _loc1_].s_tx.embedFonts = true;
            this.sign["l_" + _loc1_].s_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
            _loc1_++;
         }
         this.sign.ts_mc.needText.embedFonts = true;
         this.sign.ts_mc.needText.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
      }
   }
}

