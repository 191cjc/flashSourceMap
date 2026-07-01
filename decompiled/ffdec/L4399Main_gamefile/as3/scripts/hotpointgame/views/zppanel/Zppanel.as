package hotpointgame.views.zppanel
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.zhanpan.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.shopPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class Zppanel extends MovieClip
   {
      
      private static var _instance:Zppanel;
      
      private static var cbx:Number = -1;
      
      private var zpmc:MovieClip;
      
      private var _sxDisplay:SxPanel;
      
      private var stBtn:ClickBtnX;
      
      private var speed:Number = 1;
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var rMc:MovieClip = new MovieClip();
      
      private var tbBoxArr:Array = [];
      
      private var ranNum:VT = VT.createVT(GS.a10);
      
      private var nowRan:VT = VT.createVT(GS.a0);
      
      private var currTb:Number = -1;
      
      private var nowBo:Boolean = false;
      
      private var timer:Timer;
      
      private var timeNum:Number = 0;
      
      private var jlId:VT = VT.createVT(GS.a0);
      
      private var sxGs:VT = VT.createVT(GS.a331106 + GS.a50);
      
      private var cdMc:MovieClip;
      
      private var zpClose:CloseBtnX;
      
      private var ranxx:Number = 0.5;
      
      public function Zppanel()
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
               _loc1_.push("zppanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadZpOver;
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
      
      public static function loadZpOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:MovieClip = null;
         var _loc6_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new Zppanel();
            _loc1_ = LoaderManager.getSwfClass("Zpmc") as Class;
            _instance.zpmc = new _loc1_();
            _instance.addChild(_instance.zpmc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 12)
            {
               _loc5_ = new _loc2_();
               _loc5_.name = "e_" + _loc3_;
               _loc6_ = new GoodsBtnX(_loc5_,_instance.zpmc["d_" + _loc3_].x,_instance.zpmc["d_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc6_);
               _instance.centerMc.addChild(_loc6_);
               _instance.topMc.addChild(_instance.zpmc["zz_" + _loc3_]);
               _loc3_++;
            }
            _instance.stBtn = new ClickBtnX(_instance.zpmc.z_0,_instance.zpmc.z_0.x,_instance.zpmc.z_0.y);
            _instance.endMc.addChild(_instance.stBtn);
            _instance.zpClose = new CloseBtnX(_instance.zpmc.close_btn,_instance.zpmc.close_btn.x,_instance.zpmc.close_btn.y);
            _instance.zpmc.addChild(_instance.zpClose);
            _loc4_ = LoaderManager.getSwfClass("Tm_mc") as Class;
            _instance.cdMc = new _loc4_();
            _instance.upMc.addChild(_instance.cdMc);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.timer = new Timer(0);
            _instance.initPanel();
         }
      }
      
      private function tetboxClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://my.4399.com/forums/thread-56790904");
         navigateToURL(_loc2_,"_blank");
      }
      
      private function initPanel() : void
      {
         this.upMc.addChild(_instance._sxDisplay);
         this.cdMc.visible = false;
         this.visible = true;
         this.initzz();
         this.addEvent();
         this.initFrame();
         this.textFun();
         this.stBtn.okBtn = true;
         this.zpClose.okBtn = true;
         var _loc1_:TextField = new TextField();
         _loc1_.defaultTextFormat = new TextFormat("宋体",16,16711680);
         _loc1_.text = "详细规则点这里";
         _loc1_.width = 300;
         _loc1_.selectable = false;
         _loc1_.x = 525;
         _loc1_.y = 380;
         _loc1_.name = "textBoxname";
         _loc1_.addEventListener(MouseEvent.CLICK,this.tetboxClick);
         _instance.zpmc.addChild(_loc1_);
      }
      
      private function initFrame() : void
      {
         var _loc3_:VT = null;
         this.initMc();
         var _loc1_:Array = ZpFactory.getDataByJd(ShopData.getJd());
         var _loc2_:uint = 0;
         while(_loc2_ < 12)
         {
            if((_loc1_[_loc2_] as ZpBasicData).getWz() == _loc2_ + 1)
            {
               _loc3_ = VT.createVT((_loc1_[_loc2_] as ZpBasicData).getGoodsId());
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc3_.getValue()).getFrame());
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String((_loc1_[_loc2_] as ZpBasicData).getGoodsNum());
            }
            _loc2_++;
         }
      }
      
      private function textFun() : void
      {
         this.zpmc.need_tx.text = String(ZpData.tims.getValue());
         this.zpmc.all_tx.text = String(BagFactory.getNumById(this.sxGs.getValue()));
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.addEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            if(this.stBtn.okBtn == true)
            {
               (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            }
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:ZpBasicData = null;
         var _loc3_:Goods = null;
         if(param1.name == "e")
         {
            if(this.stBtn.okBtn == true)
            {
               _loc2_ = ZpFactory.getDataByJdAndWz(ShopData.getJd(),param1.id + GS.a1);
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
         var _loc2_:VT = null;
         var _loc3_:ZpBasicData = null;
         if(param1.name == "z")
         {
            if(BagFactory.onlyBagOne())
            {
               if(BagFactory.getNumById(this.sxGs.getValue()) >= ZpData.tims.getValue())
               {
                  if(BagFactory.deteleGoods(this.sxGs.getValue(),ZpData.tims.getValue()))
                  {
                     this.ranNum.setValue(GS.a5);
                     this.nowRan.setValue(GS.a0);
                     this.speed = 1;
                     this.ranxx = 0.5;
                     _loc2_ = VT.createVT(int(Math.random() * GS.a10000));
                     _loc3_ = ZpFactory.getDataByRanNum(ShopData.getJd(),_loc2_.getValue());
                     this.jlId.setValue(_loc3_.getWz() - GS.a1);
                     if(ZpData.tims.getValue() < GS.a10)
                     {
                        ZpData.tims.setValue(ZpData.tims.getValue() + GS.a1);
                     }
                     BagFactory.addInBagById(_loc3_.getGoodsId(),_loc3_.getGoodsNum(),GS.a0);
                     this.goosbtnvs(-1);
                     this.cdMc.visible = true;
                     this.stBtn.okBtn = false;
                     this.zpClose.okBtn = false;
                     GoodsManger.dataList.evData.setJd(GS.a12);
                     FlowInterface.saveDataByKai(this.saveFun);
                  }
               }
               else
               {
                  GoodsManger.cwTs("生肖之沙不足!");
               }
            }
            else
            {
               GoodsManger.cwTs("亲,背包至少需要一个格子哦!");
            }
         }
      }
      
      private function saveFun() : void
      {
         this.cdMc.visible = false;
         this.timer.start();
      }
      
      private function initzz() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 12)
         {
            this.zpmc["zz_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function timeHandle(param1:TimerEvent) : void
      {
         var _loc2_:ZpBasicData = null;
         if(this.nowRan.getValue() <= this.ranNum.getValue())
         {
            if(this.timeNum < this.ranxx)
            {
               this.timeNum += this.speed;
            }
            else
            {
               if(this.nowRan.getValue() < this.ranNum.getValue())
               {
                  if(this.speed > 0.2)
                  {
                     this.speed -= 0.01;
                  }
               }
               else if(this.speed > 0.05)
               {
                  this.speed -= 0.01;
               }
               ++this.currTb;
               this.zzVi(this.currTb);
               this.timeNum = 0;
               if(this.nowRan.getValue() < this.ranNum.getValue())
               {
                  if(this.currTb > 11)
                  {
                     this.ranxx += 0.2;
                     if(this.speed > 0.2)
                     {
                        this.speed -= 0.1;
                     }
                     this.currTb = -1;
                     this.nowRan.setValue(this.nowRan.getValue() + GS.a1);
                  }
               }
               else if(this.currTb == this.jlId.getValue())
               {
                  this.timer.stop();
                  this.initzz();
                  this.goosbtnvs(this.currTb);
                  _loc2_ = ZpFactory.getDataByJdAndWz(ShopData.getJd(),this.jlId.getValue() + GS.a1);
                  BagFactory.hdGoodsTs(_loc2_.getGoodsId(),_loc2_.getGoodsNum());
                  this.textFun();
                  this.stBtn.okBtn = true;
                  this.zpClose.okBtn = true;
               }
            }
         }
      }
      
      private function gotoRan() : void
      {
         this.nowBo = false;
      }
      
      private function zzVi(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 12)
         {
            if(_loc2_ == param1)
            {
               this.zpmc["zz_" + _loc2_].visible = true;
            }
            else
            {
               this.zpmc["zz_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private function removeEvent() : void
      {
         _instance.zpmc.getChildByName("textBoxname").removeEventListener(MouseEvent.CLICK,this.tetboxClick);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         this.timer.removeEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 12)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
      }
      
      private function goosbtnvs(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 12)
         {
            if(param1 == _loc2_)
            {
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            }
            else
            {
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            }
            _loc2_++;
         }
      }
   }
}

