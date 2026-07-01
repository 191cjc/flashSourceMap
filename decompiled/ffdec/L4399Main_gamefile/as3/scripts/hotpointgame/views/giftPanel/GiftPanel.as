package hotpointgame.views.giftPanel
{
   import com.adobeadobe.crypto.*;
   import com.adobeadobe.serialization.json.JSON;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.gift.Gift;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class GiftPanel extends MovieClip
   {
      
      private static var _instance:GiftPanel;
      
      private static var cbx:Number = -1;
      
      private var _sxDisplay:SxPanel;
      
      private var state:VT = VT.createVT(0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var gMc:MovieClip = new MovieClip();
      
      private var jfYe:VT = VT.createVT(GS.a0);
      
      private var jfId:VT = VT.createVT(GS.a0);
      
      private var ptYe:VT = VT.createVT(GS.a0);
      
      private var ptId:VT = VT.createVT(GS.a0);
      
      private var jtArr:Array = [];
      
      private var jbArr:Array = [];
      
      private var lqArr:Array = [];
      
      private var tbBoxArr:Array = [];
      
      private var tqMc:MovieClip;
      
      private var urlLoader:URLLoader = new URLLoader();
      
      private var phpUrl:URLRequest = new URLRequest("http://my.4399.com/jifen/activation");
      
      private var urlLoader2:URLLoader = new URLLoader();
      
      private var phpUrl2:URLRequest = new URLRequest("http://huodong2.4399.com/2014/millionpack/api.php");
      
      private var urlLoader3:URLLoader = new URLLoader();
      
      private var phpUrl3:URLRequest = new URLRequest("http://huodong2.4399.com/2014/millionpack/api.php");
      
      private var urlLoader4:URLLoader = new URLLoader();
      
      private var phpUrl4:URLRequest = new URLRequest("http://huodong2.4399.com/2014/4399_10years/api.php");
      
      private var sTime:Array = [VT.createVT(GS.a2013),VT.createVT(GS.a12),VT.createVT(GS.a12)];
      
      private var oTime:Array = [VT.createVT(GS.a2013 + GS.a1),VT.createVT(GS.a2),VT.createVT(GS.a15)];
      
      public function GiftPanel()
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
               _loc1_.push("giftpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadGiftOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.isGetCz();
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
      
      public static function loadGiftOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:CloseBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         var _loc9_:ClickBtnX = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new GiftPanel();
            _loc1_ = LoaderManager.getSwfClass("Gift") as Class;
            _instance.gMc = new _loc1_();
            _instance.addChild(_instance.gMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc7_ = new _loc2_();
               _loc7_.name = "e_" + _loc3_;
               _loc8_ = new GoodsBtnX(_loc7_,_instance.gMc["d_" + _loc3_].x,_instance.gMc["d_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc8_);
               _instance.gMc.addChild(_loc8_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               _loc9_ = new ClickBtnX(_instance.gMc["jb_" + _loc3_],_instance.gMc["jb_" + _loc3_].x,_instance.gMc["jb_" + _loc3_].y);
               _instance.gMc.addChild(_loc9_);
               _instance.jbArr.push(_loc9_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc10_ = new ClickBtnX(_instance.gMc["jt_" + _loc3_],_instance.gMc["jt_" + _loc3_].x,_instance.gMc["jt_" + _loc3_].y);
               _instance.gMc.addChild(_loc10_);
               _instance.jtArr.push(_loc10_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc11_ = new ClickBtnX(_instance.gMc["lq_" + _loc3_],_instance.gMc["lq_" + _loc3_].x,_instance.gMc["lq_" + _loc3_].y);
               _instance.gMc.addChild(_loc11_);
               _instance.lqArr.push(_loc11_);
               _loc3_++;
            }
            _loc4_ = new CloseBtnX(_instance.gMc.close_btn,_instance.gMc.close_btn.x,_instance.gMc.close_btn.y);
            _instance.gMc.addChild(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc12_ = new ClickBtnX(_instance.gMc.tk_mc["g_" + _loc3_],_instance.gMc.tk_mc["g_" + _loc3_].x,_instance.gMc.tk_mc["g_" + _loc3_].y);
               _instance.gMc.tk_mc.addChild(_loc12_);
               _loc3_++;
            }
            _loc5_ = new CloseBtnX(_instance.gMc.tk_mc.tkClose_btn,_instance.gMc.tk_mc.tkClose_btn.x,_instance.gMc.tk_mc.tkClose_btn.y);
            _instance.gMc.tk_mc.addChild(_loc5_);
            _instance.centerMc.addChild(_instance.gMc.tk_mc);
            _loc6_ = LoaderManager.getSwfClass("Ts_113") as Class;
            _instance.tqMc = new _loc6_();
            _instance.upMc.addChild(_instance.tqMc);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.ztFun();
            _instance.isGetCz();
         }
      }
      
      private function isGetCz() : void
      {
         this.tqMc.visible = true;
         if(GiftData.CzBo == false)
         {
            GiftData.CzBo = true;
            if(GM.testapi.allChongGod < GS.a0)
            {
               GM.testapi.getAllChongeMoney();
            }
         }
         addEventListener(Event.ENTER_FRAME,this.czNumFun);
      }
      
      private function czNumFun(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(GM.testapi.allChongGod >= GS.a0)
         {
            removeEventListener(Event.ENTER_FRAME,this.czNumFun);
            if(GM.testapi.dateInChongGod < GS.a0)
            {
               _loc2_ = new Object();
               _loc2_["sDate"] = this.sTime[0].getValue() + "-" + this.sTime[1].getValue() + "-" + this.sTime[2].getValue() + "|" + "00:00:00";
               _loc2_["eDate"] = this.oTime[0].getValue() + "-" + GS.a0 + this.oTime[1].getValue() + "-" + this.oTime[2].getValue() + "|" + "00:00:00";
               GM.testapi.getAllChongeMoney(_loc2_);
            }
            addEventListener(Event.ENTER_FRAME,this.czNumFunTow);
         }
      }
      
      private function czNumFunTow(param1:Event) : void
      {
         if(GM.testapi.dateInChongGod >= GS.a0)
         {
            removeEventListener(Event.ENTER_FRAME,this.czNumFunTow);
            this.tqMc.visible = false;
            this.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.initMc();
         this.addEvent();
         this.initFrame();
         this.initPtFrame();
      }
      
      private function initFrame() : void
      {
         var _loc2_:Gift = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 6)
         {
            if(GiftData.getJfByCuYe(this.jfYe.getValue(),_loc1_) != null)
            {
               _loc2_ = GiftData.getJfByCuYe(this.jfYe.getValue(),_loc1_);
               this.gMc["m_" + _loc1_].gotoAndStop(_loc2_.getFrame());
               if(_loc2_.getState() == GS.a0)
               {
                  (this.jbArr[_loc1_] as ClickBtnX).okBtn = true;
               }
               else
               {
                  (this.jbArr[_loc1_] as ClickBtnX).okBtn = false;
               }
            }
            else
            {
               this.gMc["m_" + _loc1_].gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      private function initPtFrame() : void
      {
         var _loc2_:Gift = null;
         this.initTbMc();
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            if(GiftData.getPtByCuYe(this.ptYe.getValue(),_loc1_) != null)
            {
               _loc2_ = GiftData.getPtByCuYe(this.ptYe.getValue(),_loc1_);
               this.gMc["name_" + _loc1_].text = _loc2_.getName();
               (this.gMc["name_" + _loc1_] as TextField).setTextFormat(GoodsFactory.getGoodsById(_loc2_.getRewardId()).getColorStr());
               this.gMc["sm_" + _loc1_].text = _loc2_.getSm();
               (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc2_.getRewardId()).getFrame());
               if(_loc2_.getState() == GS.a1)
               {
                  (this.lqArr[_loc1_] as ClickBtnX).okBtn = false;
               }
               else if(_loc2_.getState() == GS.a0)
               {
                  if(_loc2_.getNeed() != -1)
                  {
                     if(_loc2_.getSt() == "-1")
                     {
                        if(_loc2_.getNeed() <= GM.testapi.allChongGod)
                        {
                           (this.lqArr[_loc1_] as ClickBtnX).okBtn = true;
                        }
                        else
                        {
                           (this.lqArr[_loc1_] as ClickBtnX).okBtn = false;
                        }
                     }
                     else
                     {
                        (this.lqArr[_loc1_] as ClickBtnX).okBtn = true;
                     }
                  }
                  else
                  {
                     (this.lqArr[_loc1_] as ClickBtnX).okBtn = true;
                  }
               }
            }
            else
            {
               this.gMc["name_" + _loc1_].text = "";
               this.gMc["sm_" + _loc1_].text = "";
               (this.lqArr[_loc1_] as ClickBtnX).okBtn = false;
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
         removeEventListener(Event.ENTER_FRAME,this.czNumFun);
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
         var _loc2_:Gift = null;
         var _loc3_:Goods = null;
         if(param1.name == "e")
         {
            _loc2_ = GiftData.getPtByCuYe(this.ptYe.getValue(),param1.id);
            if(_loc2_ != null)
            {
               (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
               _loc3_ = GoodsFactory.createGoodsById(_loc2_.getRewardId());
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc3_));
            }
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "tkClose")
         {
            this.gMc.tk_mc.visible = false;
            this.gMc.tk_mc.sr_tx.text = "输入激活码";
         }
         else if(param1.name == "close")
         {
            close();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Gift = null;
         var _loc3_:Gift = null;
         var _loc4_:URLVariables = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:URLRequest = null;
         var _loc11_:VT = null;
         if(param1.name == "jb")
         {
            this.jfId = VT.createVT(param1.id);
            _loc2_ = GiftData.getJfByCuYe(this.jfYe.getValue(),this.jfId.getValue());
            if(_loc2_ != null && _loc2_.getState() == GS.a0)
            {
               this.gMc.tk_mc.visible = true;
               this.gMc.tk_mc.gxx_mc.gotoAndStop(_loc2_.getFrame());
            }
         }
         else if(param1.name == "g")
         {
            if(param1.id == GS.a0)
            {
               if(BagFactory.otherBag.getAirGirdNum() > GS.a0)
               {
                  _loc3_ = GiftData.getJfByCuYe(this.jfYe.getValue(),this.jfId.getValue());
                  if(_loc3_.getSmType() == GS.a0)
                  {
                     if(this.gMc.tk_mc.sr_tx.text != "" && this.gMc.tk_mc.sr_tx.text != "输入激活码")
                     {
                        this.phpUrl.method = URLRequestMethod.POST;
                        _loc4_ = new URLVariables();
                        _loc4_.activation = this.gMc.tk_mc.sr_tx.text;
                        _loc4_.uid = GM.testapi.userId;
                        _loc4_.uniqueId = GS.a64;
                        _loc5_ = _loc4_.activation + "-" + _loc4_.uid + "-" + _loc4_.uniqueId + "-" + "4ad36ed9b307b3c2df1df380fb2b0df3";
                        _loc6_ = MD5.hash(_loc5_);
                        _loc4_.token = _loc6_;
                        this.phpUrl.data = _loc4_;
                        this.urlLoader.load(this.phpUrl);
                        this.urlLoader.addEventListener(Event.COMPLETE,this.completeHandler_All);
                        this.gMc.tk_mc.visible = false;
                     }
                     else
                     {
                        GoodsManger.cwTs("请输入激活码");
                     }
                  }
                  else if(_loc3_.getId() == GS.a34 && _loc3_.getSmType() == GS.a1)
                  {
                     if(_loc3_.getState() == GS.a0)
                     {
                        this.phpUrl2.method = URLRequestMethod.GET;
                        _loc7_ = this.gMc.tk_mc.sr_tx.text;
                        this.phpUrl2.data = "game=11" + "&code=" + _loc7_ + "&type=1";
                        this.urlLoader2.load(this.phpUrl2);
                        this.urlLoader2.addEventListener(Event.COMPLETE,this.completeHandler2);
                     }
                  }
                  else if(_loc3_.getId() == GS.a35 && _loc3_.getSmType() == GS.a1)
                  {
                     if(_loc3_.getState() == GS.a0)
                     {
                        this.phpUrl3.method = URLRequestMethod.GET;
                        _loc8_ = this.gMc.tk_mc.sr_tx.text;
                        this.phpUrl3.data = "game=11" + "&code=" + _loc8_ + "&type=2";
                        this.urlLoader3.load(this.phpUrl3);
                        this.urlLoader3.addEventListener(Event.COMPLETE,this.completeHandler3);
                     }
                  }
                  else if(_loc3_.getId() == GS.a33 && _loc3_.getSmType() == GS.a1)
                  {
                     this.phpUrl4.method = URLRequestMethod.GET;
                     _loc9_ = this.gMc.tk_mc.sr_tx.text;
                     this.phpUrl4.data = "game=18" + "&code=" + _loc9_;
                     this.urlLoader4.load(this.phpUrl4);
                     this.urlLoader4.addEventListener(Event.COMPLETE,this.completeHandler4);
                  }
               }
               else
               {
                  GoodsManger.cwTs("背包已满");
               }
            }
            else if(param1.id == GS.a1)
            {
               if(GiftData.getJfByCuYe(this.jfYe.getValue(),this.jfId.getValue()) != null)
               {
                  _loc2_ = GiftData.getJfByCuYe(this.jfYe.getValue(),this.jfId.getValue());
                  _loc10_ = new URLRequest(_loc2_.getHttp());
                  navigateToURL(_loc10_,"_blank");
               }
            }
         }
         else if(param1.name == "jt")
         {
            if(param1.id == GS.a0)
            {
               if(this.jfYe.getValue() > GS.a0)
               {
                  this.jfYe.setValue(this.jfYe.getValue() - GS.a1);
               }
               else
               {
                  this.jfYe.setValue(GiftData.jfLength.getValue() - GS.a1);
               }
               this.initFrame();
            }
            else if(param1.id == GS.a1)
            {
               if(this.jfYe.getValue() < GiftData.jfLength.getValue() - GS.a1)
               {
                  this.jfYe.setValue(this.jfYe.getValue() + GS.a1);
               }
               else
               {
                  this.jfYe.setValue(GS.a0);
               }
               this.initFrame();
            }
            else if(param1.id == GS.a2)
            {
               if(this.ptYe.getValue() > GS.a0)
               {
                  this.ptYe.setValue(this.ptYe.getValue() - GS.a1);
               }
               else
               {
                  this.ptYe.setValue(GiftData.ptLength.getValue() - GS.a1);
               }
               this.initPtFrame();
            }
            else if(param1.id == GS.a3)
            {
               if(this.ptYe.getValue() < GiftData.ptLength.getValue() - GS.a1)
               {
                  this.ptYe.setValue(this.ptYe.getValue() + GS.a1);
               }
               else
               {
                  this.ptYe.setValue(GS.a0);
               }
               this.initPtFrame();
            }
         }
         else if(param1.name == "lq")
         {
            this.ptId = VT.createVT(param1.id);
            _loc2_ = GiftData.getPtByCuYe(this.ptYe.getValue(),this.ptId.getValue());
            if(_loc2_ != null && _loc2_.getState() == GS.a0)
            {
               _loc11_ = VT.createVT(_loc2_.getNeed());
               if(BagFactory.otherBag.getAirGirdNum() > GS.a0)
               {
                  if(_loc11_.getValue() == -1)
                  {
                     _loc2_.setState();
                     BagFactory.addInBagById(_loc2_.getRewardId(),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(_loc2_.getRewardId(),GS.a1);
                     this.initPtFrame();
                     GoodsManger.cwTs("领取成功");
                  }
                  else if(_loc2_.getSt() == "-1")
                  {
                     if(GM.testapi.allChongGod != -1 && GM.testapi.allChongGod >= _loc11_.getValue())
                     {
                        _loc2_.setState();
                        BagFactory.addInBagById(_loc2_.getRewardId(),GS.a1,GS.a0);
                        BagFactory.hdGoodsTs(_loc2_.getRewardId(),GS.a1);
                        this.initPtFrame();
                        GoodsManger.cwTs("领取成功");
                     }
                  }
                  else if(GM.testapi.dateInChongGod >= _loc11_.getValue())
                  {
                     _loc2_.setState();
                     BagFactory.addInBagById(_loc2_.getRewardId(),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(_loc2_.getRewardId(),GS.a1);
                     this.initPtFrame();
                     GoodsManger.cwTs("领取成功");
                  }
                  else
                  {
                     GoodsManger.cwTs("条件未满足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("背包已满");
               }
            }
         }
      }
      
      private function completeHandler4(param1:Event) : void
      {
         var _loc3_:Gift = null;
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         if(_loc2_ == "1")
         {
            _loc3_ = GiftData.getGiftById(GS.a33);
            if(_loc3_.getSave() == -1)
            {
               if(_loc3_.getState() == GS.a0)
               {
                  _loc3_.setState();
                  BagFactory.addInBagById(_loc3_.getRewardId(),GS.a1,GS.a0);
                  BagFactory.hdGoodsTs(_loc3_.getRewardId(),GS.a1);
                  FlowInterface.saveDataByKai();
                  GoodsManger.cwTs("领取成功");
               }
            }
            this.initFrame();
         }
         else
         {
            switch(_loc2_)
            {
               case "0|003":
                  _loc2_ = "未登录";
                  break;
               case "0|004":
                  _loc2_ = "兑换码无效";
                  break;
               case "0|005":
                  _loc2_ = "参数有误";
                  break;
               case "0|006":
                  _loc2_ = "未知错误";
            }
            GoodsManger.cwTs(_loc2_);
         }
      }
      
      private function completeHandler3(param1:Event) : void
      {
         var _loc3_:Gift = null;
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         if(_loc2_ == "2")
         {
            _loc3_ = GiftData.getGiftById(35);
            BagFactory.addInBagById(_loc3_.getRewardId(),GS.a1,GS.a0);
            BagFactory.hdGoodsTs(_loc3_.getRewardId(),GS.a1);
            FlowInterface.saveDataByKai();
            GoodsManger.cwTs("领取成功");
            this.initFrame();
         }
         else
         {
            switch(_loc2_)
            {
               case "0|001":
                  _loc2_ = "活动还没开始";
                  break;
               case "0|002":
                  _loc2_ = "活动已经结束";
                  break;
               case "0|003":
                  _loc2_ = "未登录";
                  break;
               case "0|004":
                  _loc2_ = "兑换码无效";
                  break;
               case "0|005":
                  _loc2_ = "参数有误";
                  break;
               case "0|006":
                  _loc2_ = "未知错误";
            }
            GoodsManger.cwTs(_loc2_);
         }
      }
      
      private function completeHandler2(param1:Event) : void
      {
         var _loc3_:Gift = null;
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         if(_loc2_ == "1")
         {
            _loc3_ = GiftData.getGiftById(34);
            BagFactory.addInBagById(_loc3_.getRewardId(),GS.a1,GS.a0);
            BagFactory.hdGoodsTs(_loc3_.getRewardId(),GS.a1);
            FlowInterface.saveDataByKai();
            GoodsManger.cwTs("领取成功");
            this.initFrame();
         }
         else
         {
            switch(_loc2_)
            {
               case "0|001":
                  _loc2_ = "活动还没开始";
                  break;
               case "0|002":
                  _loc2_ = "活动已经结束";
                  break;
               case "0|003":
                  _loc2_ = "未登录";
                  break;
               case "0|004":
                  _loc2_ = "兑换码无效";
                  break;
               case "0|005":
                  _loc2_ = "参数有误";
                  break;
               case "0|006":
                  _loc2_ = "未知错误";
            }
            GoodsManger.cwTs(_loc2_);
         }
      }
      
      private function completeHandler_All(param1:Event) : void
      {
         var _loc3_:Object = null;
         var _loc5_:Gift = null;
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         _loc3_ = com.adobeadobe.serialization.json.JSON.decode(_loc2_,true);
         var _loc4_:Number = Number(_loc3_.code);
         switch(_loc4_)
         {
            case 100:
               _loc5_ = GiftData.getGiftByReslutId(_loc3_.result);
               if(_loc5_.getSave() == -1)
               {
                  if(_loc5_.getState() == GS.a0)
                  {
                     _loc5_.setState();
                     BagFactory.addInBagById(_loc5_.getRewardId(),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(_loc5_.getRewardId(),GS.a1);
                     FlowInterface.saveDataByKai();
                     GoodsManger.cwTs("领取成功");
                  }
               }
               else if(_loc5_.getSave() == 0)
               {
                  BagFactory.addInBagById(_loc5_.getRewardId(),GS.a1,GS.a0);
                  BagFactory.hdGoodsTs(_loc5_.getRewardId(),GS.a1);
                  FlowInterface.saveDataByKai();
                  GoodsManger.cwTs("领取成功");
               }
               this.initFrame();
               break;
            case 99:
               GoodsManger.cwTs("参数错误");
               break;
            case 101:
               GoodsManger.cwTs("参数错误");
               break;
            case 102:
               GoodsManger.cwTs("验证码不存在");
               break;
            case 103:
               GoodsManger.cwTs("验证码还没被兑换");
               break;
            case 104:
               GoodsManger.cwTs("验证码被使用过");
               break;
            case 105:
               GoodsManger.cwTs("验证码只能被领取者使用");
               break;
            case 106:
               GoodsManger.cwTs("您的账号已经使用此礼包的激活码");
         }
      }
      
      private function initMc() : void
      {
         this.visible = true;
         this.topMc.addChild(this._sxDisplay);
         this.gMc.tk_mc.visible = false;
         this.gMc.tk_mc.sr_tx.text = "输入激活码";
      }
      
      private function initTbMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
      }
      
      private function ztFun() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            this.gMc["name_" + _loc1_].embedFonts = true;
            this.gMc["name_" + _loc1_].defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
            _loc1_++;
         }
      }
   }
}

