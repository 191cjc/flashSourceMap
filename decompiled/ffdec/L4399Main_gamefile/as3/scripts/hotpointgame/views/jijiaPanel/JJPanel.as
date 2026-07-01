package hotpointgame.views.jijiaPanel
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.BasicSx;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.jjia.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.unionPanel.*;
   
   public class JJPanel extends MovieClip
   {
      
      private static var _instance:JJPanel;
      
      private static var cbx:Number = -1;
      
      private var state:VT = VT.createVT(0);
      
      private var smState:VT = VT.createVT(0);
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var jjMc:MovieClip = new MovieClip();
      
      private var jjgoods:Goods;
      
      private var goodsQLD:VT = VT.createVT(GS.a0);
      
      private var tsType:VT = VT.createVT(1);
      
      private var maxLv:VT = VT.createVT(GS.a100);
      
      private var qldArr:Array = [VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0)];
      
      private var needGs:VT = VT.createVT(GS.a331357);
      
      private var jhNGS:VT = VT.createVT(GS.a331358);
      
      private var jhArr:Array = [0,VT.createVT(GS.a25),VT.createVT(GS.a50),VT.createVT(GS.a75),VT.createVT(GS.a100)];
      
      private var shopId:VT = VT.createVT(GS.a1200 + GS.a400 + GS.a40);
      
      private var shopGod:VT = VT.createVT(GS.a1000);
      
      private var tsNrArr:* = [["每点潜力值增加10点生命","每点潜力值增加1点混沌","每点潜力值增加0.75点攻击","每点潜力值增加20点防御","每点潜力值增加0.02%暴击"],["每点潜力值增加13点生命","每点潜力值增加1点混沌","每点潜力值增加0.5点攻击","每点潜力值增加40点防御","每点潜力值增加0.02%暴击"]];
      
      private var typeBtn:SameChangeBtnX;
      
      private var smtypeBtn:SameChangeBtnX;
      
      public function JJPanel()
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
               _loc1_.push("jjpanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadjjOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPanel();
      }
      
      private static function loadjjOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:uint = 0;
         var _loc7_:ClickBtnX = null;
         var _loc8_:ClickBtnX = null;
         var _loc9_:CloseBtnX = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:ClickBtnX = null;
         var _loc13_:ClickBtnX = null;
         var _loc14_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new JJPanel();
            _loc1_ = LoaderManager.getSwfClass("Jjia_mc") as Class;
            _instance.jjMc = new _loc1_();
            _loc2_ = _instance.jjMc;
            _loc3_ = _loc2_.s_0;
            _loc4_ = _loc2_.s_1;
            _loc5_ = _loc2_.s_2;
            _instance.addChild(_loc2_);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _instance.typeBtn = SameChangeBtnX.createSameChangeBtn([_loc2_.b_0,_loc2_.b_1]);
            _loc2_.addChild(_instance.typeBtn);
            _instance.smtypeBtn = SameChangeBtnX.createSameChangeBtn([_loc2_.sb_0,_loc2_.sb_1,_loc2_.sb_2]);
            _loc2_.addChild(_instance.smtypeBtn);
            _loc6_ = 0;
            while(_loc6_ < 10)
            {
               _loc10_ = new ClickBtnX(_loc3_["j_" + _loc6_],_loc3_["j_" + _loc6_].x,_loc3_["j_" + _loc6_].y);
               _loc3_.addChild(_loc10_);
               _loc6_++;
            }
            _loc6_ = 0;
            while(_loc6_ < 2)
            {
               _loc11_ = new ClickBtnX(_loc3_["su_" + _loc6_],_loc3_["su_" + _loc6_].x,_loc3_["su_" + _loc6_].y);
               _loc3_.addChild(_loc11_);
               _loc12_ = new ClickBtnX(_loc2_.tsx_p["ok_" + _loc6_],_loc2_.tsx_p["ok_" + _loc6_].x,_loc2_.tsx_p["ok_" + _loc6_].y);
               _loc2_.tsx_p.addChild(_loc12_);
               _loc6_++;
            }
            _loc7_ = new ClickBtnX(_loc4_["qh_" + 0],_loc4_["qh_" + 0].x,_loc4_["qh_" + 0].y);
            _loc4_.addChild(_loc7_);
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
               _loc13_ = new ClickBtnX(_loc5_["x_" + _loc6_],_loc5_["x_" + _loc6_].x,_loc5_["x_" + _loc6_].y);
               _loc5_.addChild(_loc13_);
               _loc6_++;
            }
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
               _loc14_ = new ClickBtnX(_loc3_["tmk_" + _loc6_],_loc3_["tmk_" + _loc6_].x,_loc3_["tmk_" + _loc6_].y);
               _loc3_.addChild(_loc14_);
               _loc6_++;
            }
            _loc8_ = new ClickBtnX(_loc2_.tmkjy_0,_loc2_.tmkjy_0.x,_loc2_.tmkjy_0.y);
            _loc2_.addChild(_loc8_);
            _loc9_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc9_);
            _loc2_.addChild(_loc2_.tsk_mc);
            _loc2_.addChild(_loc2_.tsx_p);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
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
      
      private function initPanel() : void
      {
         this.visible = true;
         this.jjMc.tsx_p.visible = false;
         this.jjMc.tsk_mc.visible = false;
         this.jjMc.tsx_p.ccmc.gotoAndStop(1);
         this.qldArr = [VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0)];
         this.addEvent();
         this.state.setValue(0);
         this.smState.setValue(0);
         this.typeBtn.btnOk(0);
         this.smtypeBtn.btnOk(0);
         this.initDisplay();
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
         if(param1.name == "tmk" || param1.name == "tmkjy")
         {
            this.jjMc.tsk_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.name == "tmk")
         {
            this.jjMc.tsk_mc.visible = true;
            this.jjMc.tsk_mc.x = mouseX + 20;
            this.jjMc.tsk_mc.y = mouseY;
            _loc2_ = FlowInterface.getJobByRole() - 1;
            this.jjMc.tsk_mc.wb.text = this.tsNrArr[_loc2_][param1.id];
         }
         else if(param1.name == "tmkjy")
         {
            this.jjMc.tsk_mc.visible = true;
            this.jjMc.tsk_mc.x = mouseX + 20;
            this.jjMc.tsk_mc.y = mouseY;
            this.jjMc.tsk_mc.wb.text = "机甲变身状态下打怪，才可获得经验，获得的数值与人物一致";
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
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "b")
         {
            this.state.setValue(param1.id);
            this.smState.setValue(GS.a0);
            this.closeData();
            this.initDisplay();
         }
         else if(param1.name == "sb")
         {
            this.smState.setValue(param1.id);
            this.sTxInit();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:VT = null;
         var _loc3_:VT = null;
         if(this.jjgoods != null)
         {
            if(param1.name == "j")
            {
               if(param1.id == 0)
               {
                  this.changePoint(GS.a0,GS.a0);
               }
               else if(param1.id == 1)
               {
                  this.changePoint(GS.a0,GS.a1);
               }
               else if(param1.id == 2)
               {
                  this.changePoint(GS.a1,GS.a0);
               }
               else if(param1.id == 3)
               {
                  this.changePoint(GS.a1,GS.a1);
               }
               else if(param1.id == 4)
               {
                  this.changePoint(GS.a2,GS.a0);
               }
               else if(param1.id == 5)
               {
                  this.changePoint(GS.a2,GS.a1);
               }
               else if(param1.id == 6)
               {
                  this.changePoint(GS.a3,GS.a0);
               }
               else if(param1.id == 7)
               {
                  this.changePoint(GS.a3,GS.a1);
               }
               else if(param1.id == 8)
               {
                  this.changePoint(GS.a4,GS.a0);
               }
               else if(param1.id == 9)
               {
                  this.changePoint(GS.a4,GS.a1);
               }
               this.s0QlQlTx();
            }
            else if(param1.name == "su")
            {
               if(param1.id == 0)
               {
                  if(this.getAllPoint() > GS.a0)
                  {
                     this.jjMc.tsx_p.visible = true;
                     this.tsType.setValue(GS.a1);
                     this.jjMc.tsx_p.ccmc.gotoAndStop(1);
                  }
                  else
                  {
                     GoodsManger.cwTs("没有分配点数..");
                  }
               }
               else if(param1.id == 1)
               {
                  if(this.jjgoods.getAllPoint() > GS.a0)
                  {
                     this.jjMc.tsx_p.visible = true;
                     this.tsType.setValue(GS.a2);
                     this.jjMc.tsx_p.ccmc.gotoAndStop(2);
                  }
                  else
                  {
                     GoodsManger.cwTs("没有点数可洗");
                  }
               }
            }
            else if(param1.name == "ok")
            {
               this.jjMc.tsx_p.visible = false;
               if(this.tsType.getValue() == GS.a1)
               {
                  if(param1.id == 0)
                  {
                     this.addPoint();
                     BagFactory.equipSlot.bfBag();
                     this.closeData();
                     this.sTxInit();
                  }
               }
               else if(this.tsType.getValue() == GS.a2)
               {
                  if(param1.id == 0)
                  {
                     DataIngPanel.open("购买中..");
                     FlowInterface.djGouMai(this.shopId.getValue(),GS.a1,this.shopGod.getValue(),this.djScOkone,GS.a0);
                  }
               }
            }
            else if(param1.name == "qh")
            {
               if(this.jjgoods != null)
               {
                  if(this.jjgoods.getJQhLv() < GS.a100)
                  {
                     if(param1.id == 0)
                     {
                        if(this.jjgoods.getJQhLv() < this.jjgoods.getJjLv())
                        {
                           _loc2_ = VT.createVT(JjiaFactory.getQhDataByIdAndLv(this.jjgoods.getId(),this.jjgoods.getJQhLv() + GS.a1).getGsNum());
                           if(BagFactory.getNumById(this.needGs.getValue()) >= _loc2_.getValue())
                           {
                              BagFactory.deteleGoods(this.needGs.getValue(),_loc2_.getValue());
                              this.jjgoods.setJQhLv(GS.a1);
                              BagFactory.equipSlot.bfBag();
                           }
                           else
                           {
                              GoodsManger.cwTs("物品不足");
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("强化等级必须小于机甲等级");
                        }
                     }
                     this.initDisplay();
                  }
                  else
                  {
                     GoodsManger.cwTs("强化满");
                  }
               }
            }
            else if(param1.name == "x")
            {
               if(this.jjgoods != null)
               {
                  if(param1.id == GS.a0)
                  {
                     if(this.jjgoods.getJhLv() < GS.a4)
                     {
                        if(BagFactory.getNumById(this.jhNGS.getValue()) >= GS.a1)
                        {
                           BagFactory.deteleGoods(this.jhNGS.getValue(),GS.a1);
                           this.jjgoods.setJjhEXP(GS.a1);
                           BagFactory.equipSlot.bfBag();
                        }
                        else
                        {
                           GoodsManger.cwTs("物品不足");
                        }
                     }
                  }
                  else if(param1.id == GS.a1)
                  {
                     if(this.jjgoods.getJhLv() < GS.a4)
                     {
                        _loc3_ = VT.createVT(BagFactory.getNumById(this.jhNGS.getValue()));
                        if(_loc3_.getValue() > GS.a0)
                        {
                           BagFactory.deteleGoods(this.jhNGS.getValue(),_loc3_.getValue());
                           this.jjgoods.setJjhEXP(_loc3_.getValue());
                           BagFactory.equipSlot.bfBag();
                        }
                        else
                        {
                           GoodsManger.cwTs("物品不足");
                        }
                     }
                  }
                  else if(param1.id == GS.a2)
                  {
                     if(this.jjgoods.getJhLv() < GS.a4)
                     {
                        if(this.jjgoods.getJjLv() == this.jhArr[this.jjgoods.getJhLv()].getValue())
                        {
                           if(this.jjgoods.getJjhEXP() >= JjiaFactory.getJhDataByLv(this.jjgoods.getJhLv() + GS.a1).getExp())
                           {
                              this.jjgoods.deleteJJHExp(JjiaFactory.getJhDataByLv(this.jjgoods.getJhLv() + GS.a1).getExp());
                              this.jjgoods.setJhLv(GS.a1);
                              BagFactory.equipSlot.bfBag();
                           }
                           else
                           {
                              GoodsManger.cwTs("机甲进化经验不足");
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("机甲等级不足");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("进化满");
                     }
                  }
                  this.initDisplay();
               }
            }
         }
      }
      
      private function djScOkone(param1:Number) : void
      {
         DataIngPanel.close();
         if(param1 == GS.a1)
         {
            DataIngPanel.open("存档中..");
            this.xiPoint();
            BagFactory.equipSlot.bfBag();
            FlowInterface.saveDataByKaiOnlyShop(this.saveing);
         }
         else
         {
            GoodsManger.cwTs("点卷不足");
         }
      }
      
      private function saveing() : void
      {
         DataIngPanel.close();
         this.sTxInit();
      }
      
      private function addPoint() : void
      {
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:uint = 0;
         while(_loc2_ < 5)
         {
            _loc1_.setValue(_loc1_.getValue() + this.qldArr[_loc2_].getValue());
            this.jjgoods.setJqlPoint(_loc2_,this.jjgoods.getJqlPoint(_loc2_) + this.qldArr[_loc2_].getValue());
            _loc2_++;
         }
         this.jjgoods.deleteJQl(_loc1_.getValue());
         this.goodsQLD.setValue(this.jjgoods.getJQl());
      }
      
      private function changePoint(param1:Number, param2:Number) : void
      {
         if(param2 == 0)
         {
            if(this.goodsQLD.getValue() > GS.a0)
            {
               this.qldArr[param1].setValue(this.qldArr[param1].getValue() + GS.a1);
               this.goodsQLD.setValue(this.goodsQLD.getValue() - GS.a1);
            }
         }
         else if(param2 == 1)
         {
            if(this.qldArr[param1].getValue() > 0)
            {
               this.qldArr[param1].setValue(this.qldArr[param1].getValue() - GS.a1);
               this.goodsQLD.setValue(this.goodsQLD.getValue() + GS.a1);
            }
         }
      }
      
      private function mcVisible() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            this.jjMc["s_" + _loc1_].visible = false;
            _loc1_++;
         }
         this.jjMc["s_" + this.smState.getValue()].visible = true;
      }
      
      private function initDisplay() : void
      {
         if(this.state.getValue() == 0)
         {
            this.jjgoods = BagFactory.equipSlot.getGoods(GS.a7);
         }
         else if(this.state.getValue() == 1)
         {
            this.jjgoods = BagFactory.equipSlot.getGoods(GS.a3);
         }
         this.initSxTx();
         this.sTxInit();
      }
      
      private function initSxTx() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.jjgoods != null)
         {
            if(this.state.getValue() == 0)
            {
               this.jjMc.type_tx.text = "人型";
            }
            else if(this.state.getValue() == 1)
            {
               this.jjMc.type_tx.text = "兽型";
            }
            this.s0init();
            this.jjMc.lv_tx.text = String(this.jjgoods.getJjLv());
            this.jjMc.jhlv_tx.text = String(this.jjgoods.getJhLv());
            this.jjMc.qhlv_tx.text = String(this.jjgoods.getJQhLv());
            this.jjMc.cz_tx.text = String(25 * int((this.jjgoods.getJjLv() - 1) / 25) + 23 + this.jjgoods.getJjLv());
            this.jjMc.mx.gotoAndStop(this.jjgoods.getFrame());
            if(this.jjgoods.getJjLv() < this.maxLv.getValue())
            {
               if(this.jjgoods.getJjLv() < GS.a1)
               {
                  _loc3_ = 0;
                  _loc4_ = Number(JjiaFactory.getDataByIdAndLv(this.jjgoods.getId(),this.jjgoods.getJjLv() + GS.a1).getNeedExp());
               }
               else
               {
                  _loc3_ = Number(JjiaFactory.getDataByIdAndLv(this.jjgoods.getId(),this.jjgoods.getJjLv()).getNeedExp());
                  _loc4_ = Number(JjiaFactory.getDataByIdAndLv(this.jjgoods.getId(),this.jjgoods.getJjLv() + GS.a1).getNeedExp());
               }
               _loc1_ = this.jjgoods.getJexp() - _loc3_;
               _loc2_ = _loc4_ - _loc3_;
               this.jjMc.exp_tx.text = String(_loc1_ + "/" + _loc2_);
               this.jjMc.loadmc.gotoAndStop(int(_loc1_ / _loc2_ * GS.a100));
            }
            else
            {
               this.jjMc.exp_tx.text = "";
               this.jjMc.loadmc.gotoAndStop(100);
            }
            this.goodsQLD.setValue(this.jjgoods.getJQl());
         }
         else
         {
            this.s0init();
         }
      }
      
      private function s0init() : void
      {
         this.jjMc.type_tx.text = "";
         this.jjMc.lv_tx.text = "";
         this.jjMc.jhlv_tx.text = "";
         this.jjMc.qhlv_tx.text = "";
         this.jjMc.cz_tx.text = "";
         this.jjMc.exp_tx.text = "";
         this.goodsQLD.setValue(0);
         this.jjMc.loadmc.gotoAndStop(1);
         this.jjMc.mx.gotoAndStop(1);
      }
      
      private function sTxInit() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         this.mcVisible();
         if(this.jjgoods != null)
         {
            if(this.smState.getValue() == 0)
            {
               this.initS0text();
               this.s0SxDisplay();
               this.s0QlQlTx();
               _loc1_ = JjiaFactory.getDataByIdAndLv(this.jjgoods.getId(),1).getSkFrame();
               _loc2_ = 3;
               if(this.jjgoods.getJhLv() < 3)
               {
                  _loc2_ = 4;
               }
               else if(this.jjgoods.getJhLv() == 3)
               {
                  _loc2_ = 5;
               }
               else if(this.jjgoods.getJhLv() == 4)
               {
                  _loc2_ = 6;
               }
               _loc3_ = 0;
               while(_loc3_ < 6)
               {
                  if(_loc3_ < _loc2_)
                  {
                     this.jjMc.s_0["tb_" + _loc3_].gotoAndStop(_loc1_[_loc3_]);
                  }
                  else
                  {
                     this.jjMc.s_0["tb_" + _loc3_].gotoAndStop(1);
                  }
                  _loc3_++;
               }
            }
            else if(this.smState.getValue() == 1)
            {
               this.initS1text();
               if(this.jjgoods.getJQhLv() < GS.a100)
               {
                  this.jjMc.s_1.gs_tx.text = BagFactory.getNumById(this.needGs.getValue()) + "/" + JjiaFactory.getQhDataByIdAndLv(this.jjgoods.getId(),this.jjgoods.getJQhLv() + GS.a1).getGsNum();
               }
               else
               {
                  this.jjMc.s_1.gs_tx.text = "";
               }
               this.s1SxDisplay();
            }
            else if(this.smState.getValue() == 2)
            {
               this.initS2text();
               if(this.jjgoods.getJhLv() < GS.a4)
               {
                  this.jjMc.s_2.jexp_tx.text = this.jjgoods.getJjhEXP() + "/" + JjiaFactory.getJhDataByLv(this.jjgoods.getJhLv() + GS.a1).getExp();
               }
               this.jjMc.s_2.cz0_tx.text = String(25 * int((this.jjgoods.getJjLv() - 1) / 25) + 23 + this.jjgoods.getJjLv());
               if(this.jjgoods.getJhLv() == 1)
               {
                  _loc4_ = 74;
               }
               else if(this.jjgoods.getJhLv() == 2)
               {
                  _loc4_ = 124;
               }
               else if(this.jjgoods.getJhLv() == 3)
               {
                  _loc4_ = 174;
               }
               else
               {
                  _loc4_ = 198;
               }
               this.jjMc.s_2.cz1_tx.text = String(_loc4_);
               this.jjMc.s_2.jhnum_tx.text = String(BagFactory.getNumById(this.jhNGS.getValue()));
            }
         }
         else if(this.smState.getValue() == 0)
         {
            this.initS0text();
         }
         else if(this.smState.getValue() == 1)
         {
            this.initS1text();
         }
         else if(this.smState.getValue() == 2)
         {
            this.initS2text();
         }
      }
      
      private function initS0text() : void
      {
         this.jjMc.s_0.a_tx.text = "";
         this.jjMc.s_0.b_tx.text = "";
         this.jjMc.s_0.c_tx.text = "";
         this.jjMc.s_0.d_tx.text = "";
         this.jjMc.s_0.e_tx.text = "";
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            this.jjMc.s_0["tx_" + _loc1_].text = "";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this.jjMc.s_0["tb_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.jjMc.s_0.ql_tx.text = "";
      }
      
      private function initS1text() : void
      {
         this.jjMc.s_1.gs_tx.text = "";
         this.jjMc.s_1.a_tx.text = "";
         this.jjMc.s_1.b_tx.text = "";
         this.jjMc.s_1.c_tx.text = "";
         this.jjMc.s_1.d_tx.text = "";
         this.jjMc.s_1.e_tx.text = "";
      }
      
      private function initS2text() : void
      {
         this.jjMc.s_2.jexp_tx.text = "";
         this.jjMc.s_2.cz0_tx.text = "";
         this.jjMc.s_2.cz1_tx.text = "";
         this.jjMc.s_2.jhnum_tx.text = "";
      }
      
      private function s0SxDisplay() : void
      {
         this.jjMc.s_0.a_tx.text = String(this.getjcSxValue(GS.a1) + JjiaFactory.getjjlvSxValue(GS.a1,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a1,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[0]);
         this.jjMc.s_0.b_tx.text = String(this.getjcSxValue(GS.a12) + JjiaFactory.getjjlvSxValue(GS.a12,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a12,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[1]);
         this.jjMc.s_0.c_tx.text = String(this.getjcSxValue(GS.a3) + JjiaFactory.getjjlvSxValue(GS.a3,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a3,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[2]);
         this.jjMc.s_0.d_tx.text = String(this.getjcSxValue(GS.a4) + JjiaFactory.getjjlvSxValue(GS.a4,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a4,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[3]);
         this.jjMc.s_0.e_tx.text = String(((this.getjcSxValue(GS.a5) + JjiaFactory.getjjlvSxValue(GS.a5,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a5,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[4]) * 100).toFixed(1) + "%");
      }
      
      private function s1SxDisplay() : void
      {
         var _loc1_:Array = [0,0,0,0,0];
         if(this.jjgoods.getJQhLv() < GS.a100)
         {
            _loc1_[0] = JjiaFactory.getQhSxValue(GS.a1,this.jjgoods.getJQhLv() + GS.a1,this.jjgoods.getId()) - JjiaFactory.getQhSxValue(GS.a1,this.jjgoods.getJQhLv(),this.jjgoods.getId());
            _loc1_[1] = JjiaFactory.getQhSxValue(GS.a12,this.jjgoods.getJQhLv() + GS.a1,this.jjgoods.getId()) - JjiaFactory.getQhSxValue(GS.a12,this.jjgoods.getJQhLv(),this.jjgoods.getId());
            _loc1_[2] = JjiaFactory.getQhSxValue(GS.a3,this.jjgoods.getJQhLv() + GS.a1,this.jjgoods.getId()) - JjiaFactory.getQhSxValue(GS.a3,this.jjgoods.getJQhLv(),this.jjgoods.getId());
            _loc1_[3] = JjiaFactory.getQhSxValue(GS.a4,this.jjgoods.getJQhLv() + GS.a1,this.jjgoods.getId()) - JjiaFactory.getQhSxValue(GS.a4,this.jjgoods.getJQhLv(),this.jjgoods.getId());
            _loc1_[4] = JjiaFactory.getQhSxValue(GS.a5,this.jjgoods.getJQhLv() + GS.a1,this.jjgoods.getId()) - JjiaFactory.getQhSxValue(GS.a5,this.jjgoods.getJQhLv(),this.jjgoods.getId());
         }
         this.jjMc.s_1.a_tx.text = String(this.getjcSxValue(GS.a1) + JjiaFactory.getjjlvSxValue(GS.a1,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a1,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[0]) + "(+" + _loc1_[0] + ")";
         this.jjMc.s_1.b_tx.text = String(this.getjcSxValue(GS.a12) + JjiaFactory.getjjlvSxValue(GS.a12,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a12,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[1]) + "(+" + _loc1_[1] + ")";
         this.jjMc.s_1.c_tx.text = String(this.getjcSxValue(GS.a3) + JjiaFactory.getjjlvSxValue(GS.a3,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a3,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[2]) + "(+" + _loc1_[2] + ")";
         this.jjMc.s_1.d_tx.text = String(this.getjcSxValue(GS.a4) + JjiaFactory.getjjlvSxValue(GS.a4,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a4,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[3]) + "(+" + _loc1_[3] + ")";
         this.jjMc.s_1.e_tx.text = String(((this.getjcSxValue(GS.a5) + JjiaFactory.getjjlvSxValue(GS.a5,this.jjgoods) + JjiaFactory.getQhSxValue(GS.a5,this.jjgoods.getJQhLv(),this.jjgoods.getId()) + this.jjgoods.getSxByJjia()[4]) * 100).toFixed(1) + "%") + "(+" + _loc1_[4].toFixed(1) + "%)";
      }
      
      private function s0QlQlTx() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            this.jjMc.s_0["tx_" + _loc1_].text = String(this.qldArr[_loc1_].getValue());
            _loc1_++;
         }
         this.jjMc.s_0.ql_tx.text = this.goodsQLD.getValue();
      }
      
      private function xiPoint() : void
      {
         this.jjgoods.addJQl(this.jjgoods.getAllPoint());
         this.jjgoods.xiPoint();
         this.closeData();
         this.goodsQLD.setValue(this.jjgoods.getJQl());
      }
      
      private function closeData() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            this.qldArr[_loc1_].setValue(GS.a0);
            _loc1_++;
         }
      }
      
      private function getjcSxValue(param1:Number) : Number
      {
         var _loc3_:BasicSx = null;
         var _loc2_:* = this.jjgoods.getFixAtSx();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getSxType() == param1)
            {
               if(param1 != GS.a5)
               {
                  return _loc3_.getValue();
               }
               return _loc3_.getValue() / GS.a10000;
            }
         }
         return 0;
      }
      
      private function getAllPoint() : Number
      {
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:uint = 0;
         while(_loc2_ < this.qldArr.length)
         {
            _loc1_.setValue(_loc1_.getValue() + this.qldArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_.getValue();
      }
   }
}

