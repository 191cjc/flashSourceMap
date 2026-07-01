package hotpointgame.views.petGj
{
   import flash.display.*;
   import flash.text.*;
   import flash.utils.Timer;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.pet.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.ship.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class PetGjPanel extends MovieClip
   {
      
      private static var _instance:PetGjPanel;
      
      private static var cbx:Number = -1;
      
      private var tbBoxArr:Array = [];
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var timer:Timer;
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var pMc:MovieClip = new MovieClip();
      
      private var rxBtn:SameChangeBtnX;
      
      private var _sxDisplay:SxPanel;
      
      private var goodsBtnx:GoodsBtnX;
      
      private var btnArr:Array = [];
      
      private var cwMsg:PetManager;
      
      private var eetXX:VT = VT.createVT(-1);
      
      public function PetGjPanel()
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
               _loc1_.push("petGj");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadPetOver;
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
      
      public static function loadPetOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:ClickBtnX = null;
         var _loc4_:Object = null;
         var _loc5_:MovieClip = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:uint = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:CloseBtnX = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:MovieClip = null;
         var _loc12_:CloseBtnX = null;
         var _loc13_:ClickBtnX = null;
         var _loc14_:ClickBtnX = null;
         var _loc15_:MovieClip = null;
         var _loc16_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new PetGjPanel();
            _loc1_ = LoaderManager.getSwfClass("Pet_Mc") as Class;
            _instance.pMc = new _loc1_();
            _instance.addChild(_instance.pMc);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.upMc);
            _instance.addChild(_instance.topMc);
            _loc2_ = _instance.pMc.ts_mc;
            _loc3_ = new ClickBtnX(_loc2_.sure_0,_loc2_.sure_0.x,_loc2_.sure_0.y);
            _loc2_.addChild(_loc3_);
            _instance.upMc.addChild(_loc2_);
            _loc4_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc5_ = new _loc4_();
            _loc5_.name = "ex_" + _loc7_;
            _instance.goodsBtnx = new GoodsBtnX(_loc5_,_instance.pMc["d_" + 0].x,_instance.pMc["d_" + 0].y);
            _instance.pMc.addChild(_instance.goodsBtnx);
            _loc6_ = new CloseBtnX(_instance.pMc.close_btn,_instance.pMc.close_btn.x,_instance.pMc.close_btn.y);
            _instance.pMc.addChild(_loc6_);
            _loc7_ = 0;
            while(_loc7_ < 5)
            {
               _loc14_ = new ClickBtnX(_instance.pMc["xz_" + _loc7_],_instance.pMc["xz_" + _loc7_].x,_instance.pMc["xz_" + _loc7_].y);
               _instance.pMc.addChild(_loc14_);
               _instance.btnArr.push(_loc14_);
               _loc7_++;
            }
            _loc8_ = _instance.pMc.rhtk_mc;
            _instance.rxBtn = SameChangeBtnX.createSameChangeBtn(new Array(new MovieClip(),_loc8_.rhxz_1,_loc8_.rhxz_2,_loc8_.rhxz_3,_loc8_.rhxz_4,_loc8_.rhxz_5,_loc8_.rhxz_6,_loc8_.rhxz_7,_loc8_.rhxz_8,_loc8_.rhxz_9,_loc8_.rhxz_10,_loc8_.rhxz_11,_loc8_.rhxz_12));
            _loc8_.addChild(_instance.rxBtn);
            _instance.upMc.addChild(_loc8_);
            _loc9_ = new CloseBtnX(_loc8_.rhclose_btn,_loc8_.rhclose_btn.x,_loc8_.rhclose_btn.y);
            _loc8_.addChild(_loc9_);
            _loc10_ = new ClickBtnX(_loc8_.resure_0,_loc8_.resure_0.x,_loc8_.resure_0.y);
            _loc8_.addChild(_loc10_);
            _loc11_ = _instance.pMc.kl_mc;
            _loc12_ = new CloseBtnX(_loc11_.xlclose_btn,_loc11_.xlclose_btn.x,_loc11_.xlclose_btn.y);
            _loc11_.addChild(_loc12_);
            _loc13_ = new ClickBtnX(_loc11_.sur_0,_loc11_.sur_0.x,_loc11_.sur_0.y);
            _loc11_.addChild(_loc13_);
            _instance.upMc.addChild(_loc11_);
            _loc7_ = 0;
            while(_loc7_ < 3)
            {
               _loc15_ = new _loc4_();
               _loc15_.name = "e_" + _loc7_;
               _loc16_ = new GoodsBtnX(_loc15_,_loc11_["d_" + _loc7_].x,_loc11_["d_" + _loc7_].y);
               _instance.tbBoxArr.push(_loc16_);
               _loc11_.addChild(_loc16_);
               _loc7_++;
            }
            _instance.initTextFun();
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initTextFun() : void
      {
         var _loc1_:MovieClip = this.pMc.xz_2;
         _loc1_.be_tx.embedFonts = true;
         _loc1_.be_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
      }
      
      private function initPanel() : void
      {
         this.cwMsg = GM.aSaveData.petm;
         this.initMc();
         this.topMc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.pMc.kl_mc.visible = false;
         this.pMc.rhtk_mc.visible = false;
         this.pMc.ts_mc.visible = false;
         if(PetGjData.getIsBo() == GS.a1 && PetGjData.getGjTime() <= GS.a0 && Boolean(PetGjData.eatBo))
         {
            PetGjData.closePanelData();
            FlowInterface.saveDataByKai();
         }
         this.addEvent();
         this.initData();
      }
      
      private function initData() : void
      {
         var _loc2_:PetR = null;
         var _loc3_:TextFormat = null;
         var _loc4_:VT = null;
         this.pMc.name_tx.text = "";
         this.pMc.lv_tx.text = "";
         this.pMc.exp_tx.text = "";
         this.pMc.cwmx.gotoAndStop(1);
         this.pMc.jt_tx.text = "0";
         this.pMc.time_tx.text = "0";
         this.pMc.exp0_tx.text = "0";
         this.pMc.exp1_tx.text = "0";
         this.goodsBtnx.getSmMc().gotoAndStop(1);
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            (this.btnArr[_loc1_] as ClickBtnX).okBtn = false;
            _loc1_++;
         }
         (this.btnArr[0] as ClickBtnX).okBtn = true;
         (this.btnArr[2] as ClickBtnX).okBtn = true;
         if(PetGjData.getCurrPetId() != -1 && this.cwMsg.getPetById(PetGjData.getCurrPetId()) != null)
         {
            _loc2_ = this.cwMsg.getPetById(PetGjData.getCurrPetId());
            this.pMc.name_tx.text = _loc2_.getname();
            _loc3_ = new TextFormat();
            switch(_loc2_.getpColor())
            {
               case 0:
                  _loc3_.color = "0xffffff";
                  break;
               case 1:
                  _loc3_.color = "0x0066ff";
                  break;
               case 2:
                  _loc3_.color = "0xFF33FF";
                  break;
               case 3:
                  _loc3_.color = "0xffcc00";
            }
            (this.pMc.name_tx as TextField).setTextFormat(_loc3_);
            this.pMc.lv_tx.text = String(_loc2_.lv);
            this.pMc.exp_tx.text = String(_loc2_.curExp + "/" + _loc2_.getNextExp());
            this.pMc.cwmx.gotoAndStop(_loc2_.getPetFrame());
            this.pMc.cwmx.cw.gotoAndStop(_loc2_.curPot + GS.a1);
            _loc4_ = PetGjData.eatArr[PetGjData.getLsId()];
            this.goodsBtnx.getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc4_.getValue()).getFrame());
            (this.btnArr[1] as ClickBtnX).okBtn = true;
            if(BagFactory.getNumById(_loc4_.getValue()) > GS.a0)
            {
               _loc1_ = 2;
               while(_loc1_ < 5)
               {
                  (this.btnArr[_loc1_] as ClickBtnX).okBtn = true;
                  _loc1_++;
               }
               this.pMc.jt_tx.text = String(PetGjData.getPxLsNum() + "/" + BagFactory.getNumById(_loc4_.getValue()));
               this.pMc.time_tx.text = PetGjData.getPxLsNum() * PetGjData.gdTime.getValue() / 60 + "小时";
               this.pMc.exp0_tx.text = String(GoodsFactory.getGoodsById(_loc4_.getValue()).getOtherValue() * PetGjData.getPxLsNum() + "*" + PetGjData.getExpBs().toFixed(1));
               this.pMc.exp1_tx.text = String(GoodsFactory.getGoodsById(_loc4_.getValue()).getLwId()[0] * PetGjData.getPxLsNum() + "*" + PetGjData.getExpBs().toFixed(1));
            }
         }
         this.btnKey();
      }
      
      private function btnKey() : void
      {
         var _loc1_:uint = 0;
         if(PetGjData.isBo.getValue() == 1)
         {
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               if(_loc1_ != 2)
               {
                  (this.btnArr[_loc1_] as ClickBtnX).okBtn = false;
               }
               _loc1_++;
            }
            this.pMc.xz_2.be_tx.text = "结束培训";
         }
         else
         {
            this.pMc.xz_2.be_tx.text = "开始培训";
         }
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
         this.goodsBtnx.getSmMc().t_txt.text = "";
         this.goodsBtnx.getSmMc().gotoAndStop(1);
         this.goodsBtnx.getSmMc().mask_mc.gotoAndStop(1);
         this.goodsBtnx.getSmMc().gx_mc.visible = false;
         this.goodsBtnx.getSmMc().d_mc.visible = false;
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "e")
         {
            if(param1.id != PetGjData.getLsId())
            {
               (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            }
         }
         else if(param1.name == "ex")
         {
            this.goodsBtnx.getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            _loc2_ = GoodsFactory.createGoodsById(PetGjData.eatArr[param1.id].getValue());
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
         }
         else if(param1.name == "ex")
         {
            this.goodsBtnx.getSmMc().gx_mc.visible = true;
            _loc2_ = GoodsFactory.createGoodsById(PetGjData.eatArr[PetGjData.getLsId()].getValue());
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "rhclose")
         {
            this.pMc.rhtk_mc.visible = false;
         }
         else if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "xlclose")
         {
            this.pMc.kl_mc.visible = false;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "rhxz")
         {
            if(this.cwMsg.getPetById(param1.id) != null)
            {
               if(PetGjData.getPetHosLv() < this.cwMsg.getPetById(param1.id).lv)
               {
                  GoodsManger.cwTs("宠物屋等级过低，请寻找艾罗管家升级");
               }
               else
               {
                  PetGjData.setCurrPetId(param1.id);
               }
            }
            else
            {
               GoodsManger.cwTs("请选择宠物");
            }
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:TextFormat = null;
         if(param1.name == "xz")
         {
            if(param1.id == 0)
            {
               this.rxBtn.czArr();
               this.pMc.rhtk_mc.visible = true;
               _loc2_ = this.cwMsg.getAllPet();
               _loc3_ = this.pMc.rhtk_mc;
               _loc4_ = 1;
               while(_loc4_ <= 12)
               {
                  if(_loc2_[_loc4_] != null)
                  {
                     _loc3_["rhcw_" + _loc4_].gotoAndStop((_loc2_[_loc4_] as PetR).getPetFrame());
                     _loc3_["rhcw_" + _loc4_].cw.gotoAndStop((_loc2_[_loc4_] as PetR).curPot + GS.a1);
                     _loc3_["rhcw_" + _loc4_].cw_name.text = (_loc2_[_loc4_] as PetR).getname();
                     _loc3_["rhcw_" + _loc4_].cw_lv.text = "Lv." + (_loc2_[_loc4_] as PetR).lv;
                     _loc5_ = new TextFormat();
                     switch((_loc2_[_loc4_] as PetR).getpColor())
                     {
                        case 0:
                           _loc5_.color = "0xffffff";
                           break;
                        case 1:
                           _loc5_.color = "0x0066ff";
                           break;
                        case 2:
                           _loc5_.color = "0xFF33FF";
                           break;
                        case 3:
                           _loc5_.color = "0xffcc00";
                     }
                     (_loc3_["rhcw_" + _loc4_].cw_name as TextField).setTextFormat(_loc5_);
                  }
                  else
                  {
                     _loc3_["rhcw_" + _loc4_].gotoAndStop(1);
                     _loc3_["rhcw_" + _loc4_].cw_name.text = "";
                     _loc3_["rhcw_" + _loc4_].cw_lv.text = "";
                  }
                  _loc4_++;
               }
            }
            else if(param1.id == 1)
            {
               this.pMc.kl_mc.visible = true;
               _loc4_ = 0;
               while(_loc4_ < 3)
               {
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(PetGjData.eatArr[_loc4_].getValue()).getFrame());
                  _loc4_++;
               }
            }
            else if(param1.id == 3)
            {
               if(PetGjData.getPxLsNum() > GS.a1)
               {
                  PetGjData.setPxLsNum(PetGjData.getPxLsNum() - GS.a1);
               }
               else
               {
                  PetGjData.setPxLsNum(BagFactory.getNumById(PetGjData.eatArr[PetGjData.getLsId()].getValue()));
               }
               this.initData();
            }
            else if(param1.id == 4)
            {
               if(PetGjData.getPxLsNum() < BagFactory.getNumById(PetGjData.eatArr[PetGjData.getLsId()].getValue()))
               {
                  PetGjData.setPxLsNum(PetGjData.getPxLsNum() + GS.a1);
               }
               else
               {
                  PetGjData.setPxLsNum(GS.a1);
               }
               this.initData();
            }
            else if(param1.id == 2)
            {
               if(PetGjData.getIsBo() == GS.a0)
               {
                  if(PetGjData.getCurrPetId() != -1 && this.cwMsg.getPetById(PetGjData.getCurrPetId()) != null)
                  {
                     if(BagFactory.getNumById(PetGjData.eatArr[PetGjData.getLsId()].getValue()) > GS.a0)
                     {
                        PetGjData.setIsBo(GS.a1);
                        PetGjData.setGjTime(PetGjData.getPxLsNum() * PetGjData.gdTime.getValue() * GS.a60);
                        this.btnKey();
                        FlowInterface.saveDataByKai();
                        close();
                     }
                     else
                     {
                        GoodsManger.cwTs("亲,宠物口粮数量不足哦!");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("亲,请选择挂机的宠物哦!");
                  }
               }
               else
               {
                  this.pMc.ts_mc.visible = true;
                  PetGjData.addExp();
                  PetGjData.deleteGs();
                  this.pMc.ts_mc.zx_tx.text = String(PetGjData.getZxExp());
                  this.pMc.ts_mc.lx_tx.text = String(PetGjData.getLxExp());
                  PetGjData.closePanelData();
                  this.initData();
                  FlowInterface.saveDataByKai();
               }
            }
         }
         else if(param1.name == "resure")
         {
            this.pMc.rhtk_mc.visible = false;
            PetGjData.setLsId(GS.a2);
            PetGjData.setPxLsNum(GS.a1);
            this.initData();
         }
         else if(param1.name == "e")
         {
            this.eetXX = VT.createVT(param1.id);
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               if(param1.id == _loc4_)
               {
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
               }
               else
               {
                  (this.tbBoxArr[_loc4_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               }
               _loc4_++;
            }
         }
         else if(param1.name == "sur")
         {
            if(this.eetXX.getValue() != -1)
            {
               PetGjData.setLsId(this.eetXX.getValue());
               PetGjData.setPxLsNum(GS.a1);
               this.initData();
            }
            this.pMc.kl_mc.visible = false;
         }
         else if(param1.name == "sure")
         {
            this.pMc.ts_mc.visible = false;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
   }
}

