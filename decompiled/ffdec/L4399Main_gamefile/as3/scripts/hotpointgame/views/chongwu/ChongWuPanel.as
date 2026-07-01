package hotpointgame.views.chongwu
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.pet.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class ChongWuPanel extends MovieClip
   {
      
      private static var _instance:ChongWuPanel;
      
      private static var cbx:Number = -1;
      
      private var _bagDisplay:BagDisplay;
      
      private var _sxDisplay:SxPanel;
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var state:VT = VT.createVT(GS.a0);
      
      private var aPanel:MovieClip;
      
      private var tbBoxArrcw:Array = [];
      
      private var czBtn:SameChangeBtnX;
      
      private var jcBtn:SameChangeBtnX;
      
      private var cwStateBtn:SameChangeBtnX;
      
      private var xzcwBtn:SameChangeBtnX;
      
      private var rxBtn:SameChangeBtnX;
      
      private var sjBtn:ClickBtnX;
      
      private var rhBtn:ClickBtnX;
      
      private var jhBtn:ClickBtnX;
      
      private var rhsBtn:ClickBtnX;
      
      private var ye:VT = VT.createVT(GS.a0);
      
      private var cuCwId:VT = VT.createVT(GS.a1);
      
      private var cwMsg:PetManager;
      
      private var timer:Timer = new Timer(GS.a1000,GS.a0);
      
      private var cwList:Array = [];
      
      private var jnArr:Array = [];
      
      private var zbjnArr:Array = [];
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var czingMc:MovieClip;
      
      private var czMc:MovieClip;
      
      private var numVT:VT = VT.createVT(GS.a1);
      
      private var sjgoodsId:VT = VT.createVT(GS.a331098);
      
      private var sjgs:Goods = GoodsFactory.createGoodsById(this.sjgoodsId.getValue());
      
      private var cuRh:VT = VT.createVT(-1);
      
      private var tfArr:Array = [];
      
      private var fomeName:String;
      
      private var fomrId:VT = VT.createVT(-1);
      
      private var toName:String;
      
      private var toId:VT = VT.createVT(-1);
      
      private var sktype:VT = VT.createVT(-1);
      
      public var cdMc:MovieClip;
      
      private var pox:VT = VT.createVT(-1);
      
      private var sjg:GoodsBtnX;
      
      private var jblwBtnArr:Array = [];
      
      private var djlwBtnArr:Array = [];
      
      private var fsBtnx:ClickBtnX;
      
      private var maxLv:VT = VT.createVT(GS.a65);
      
      public function ChongWuPanel()
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
               _loc1_.push("chongwupanel");
               _loc1_.push("bagpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadChongWuOver;
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
            _instance._bagDisplay.close();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      private static function loadChongWuOver() : void
      {
         var _loc1_:Object = null;
         if(cbx == -1)
         {
            _instance = new ChongWuPanel();
            _loc1_ = LoaderManager.getSwfClass("ChongWu") as Class;
            _instance.aPanel = new _loc1_();
            _instance.addChild(_instance.aPanel);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _instance.allFun();
            _instance.state0Fun();
            _instance.state1Fun();
            _instance.state2Fun();
            _instance._bagDisplay = BagDisplay.createBagDisplay(570.7,96.15);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.ye.setValue(GS.a0);
            _instance.cuCwId.setValue(GS.a1);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      public static function wdFun() : void
      {
         _instance.initCwData();
      }
      
      public static function closeData() : void
      {
         if(_instance != null)
         {
            _instance.cwList.length = 0;
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.cwList.length = 0;
         this.cwMsg = GM.aSaveData.petm;
         this.initMc();
         this.initBag();
         this.addEvent();
         this.state.setValue(GS.a0);
         this.jcBtn.btnOk(GS.a0);
         this.cwStateBtn.btnOk(GS.a0);
         this.xzcwBtn.btnOk(GS.a0);
         this.stateDisplay();
         this.initCwData();
         this.petDataDisplay();
         this.yeMa();
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            if(this.cuCwId.getValue() - 1 == this.ye.getValue() * 4 + _loc1_)
            {
               this.xzcwBtn.btnOk(_loc1_);
               break;
            }
            _loc1_++;
         }
      }
      
      private function yeMa() : void
      {
         this.aPanel.yeTx.text = this.ye.getValue() + 1 + "/3";
      }
      
      private function initCwData() : void
      {
         var _loc2_:TextFormat = null;
         this.cwList = this.cwMsg.getPetList(this.ye.getValue());
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a4)
         {
            if(this.ye.getValue() * 4 + _loc1_ < this.cwMsg.opennum)
            {
               if(this.cwList[_loc1_] != null)
               {
                  if(this.cwList[_loc1_] is PetR)
                  {
                     this.aPanel["cwlan_" + _loc1_].gotoAndStop((this.cwList[_loc1_] as PetR).getPetFrame());
                     this.aPanel["cwlan_" + _loc1_].cw.gotoAndStop((this.cwList[_loc1_] as PetR).curPot + GS.a1);
                     this.aPanel["lj_" + _loc1_].visible = false;
                     this.aPanel["cwlan_" + _loc1_].cw_time.text = "";
                     this.aPanel["cwlan_" + _loc1_].cw_name.text = (this.cwList[_loc1_] as PetR).getname();
                     this.aPanel["cwlan_" + _loc1_].cw_lv.text = "Lv." + (this.cwList[_loc1_] as PetR).lv;
                     _loc2_ = new TextFormat();
                     switch((this.cwList[_loc1_] as PetR).getpColor())
                     {
                        case 0:
                           _loc2_.color = "0xffffff";
                           break;
                        case 1:
                           _loc2_.color = "0x0066ff";
                           break;
                        case 2:
                           _loc2_.color = "0xFF33FF";
                           break;
                        case 3:
                           _loc2_.color = "0xffcc00";
                     }
                     (this.aPanel["cwlan_" + _loc1_].cw_name as TextField).setTextFormat(_loc2_);
                     if(this.cwMsg.fightPet - 1 == this.ye.getValue() * 4 + _loc1_)
                     {
                        this.aPanel["cwlan_" + _loc1_].cwzt1.visible = true;
                     }
                     else
                     {
                        this.aPanel["cwlan_" + _loc1_].cwzt1.visible = false;
                     }
                  }
                  else if(this.cwList[_loc1_] is EggR)
                  {
                     this.aPanel["cwlan_" + _loc1_].gotoAndStop(2);
                     this.aPanel["cwlan_" + _loc1_].cw.gotoAndStop((this.cwList[_loc1_] as EggR).pcolor + GS.a1);
                     this.aPanel["cwlan_" + _loc1_].cwzt1.visible = false;
                     if((this.cwList[_loc1_] as EggR).countTime() > GS.a0)
                     {
                        this.aPanel["lj_" + _loc1_].visible = true;
                     }
                     this.aPanel["cwlan_" + _loc1_].cw_name.text = "";
                     this.aPanel["cwlan_" + _loc1_].cw_lv.text = "";
                  }
               }
               else
               {
                  this.aPanel["cwlan_" + _loc1_].gotoAndStop(3);
                  this.aPanel["lj_" + _loc1_].visible = false;
                  this.aPanel["cwlan_" + _loc1_].cwzt1.visible = false;
                  this.aPanel["cwlan_" + _loc1_].cw_time.text = "";
                  this.aPanel["cwlan_" + _loc1_].cw_name.text = "";
                  this.aPanel["cwlan_" + _loc1_].cw_lv.text = "";
               }
            }
            else
            {
               this.aPanel["cwlan_" + _loc1_].gotoAndStop(1);
               this.aPanel["lj_" + _loc1_].visible = false;
               this.aPanel["cwlan_" + _loc1_].cwzt1.visible = false;
               this.aPanel["cwlan_" + _loc1_].cw_time.text = "";
               this.aPanel["cwlan_" + _loc1_].cw_name.text = "";
               this.aPanel["cwlan_" + _loc1_].cw_lv.text = "";
            }
            _loc1_++;
         }
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         if(this.cwList.length > GS.a0)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               if(this.cwList[_loc2_] != null && this.cwList[_loc2_] is EggR)
               {
                  if((this.cwList[_loc2_] as EggR).countTime() > GS.a0)
                  {
                     this.aPanel["cwlan_" + _loc2_].cw_time.text = this.timeDisplay((this.cwList[_loc2_] as EggR).countTime() / 1000);
                  }
                  else
                  {
                     this.initCwData();
                     this.petDataDisplay();
                  }
               }
               _loc2_++;
            }
         }
      }
      
      private function timeDisplay(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.tian = param1 / this.k;
         this.shi = (param1 - this.tian * this.k) / 3600;
         this.fen = (param1 - this.tian * this.k - this.shi * 3600) / 60;
         this.miao = param1 - this.tian * this.k - this.shi * 3600 - this.fen * 60;
         if(this.shi >= 10)
         {
            _loc2_ = String(this.shi);
         }
         else
         {
            _loc2_ = "0" + this.shi;
         }
         if(this.fen >= 10)
         {
            _loc3_ = String(this.fen);
         }
         else
         {
            _loc3_ = "0" + this.fen;
         }
         if(this.miao >= 10)
         {
            _loc4_ = String(this.miao);
         }
         else
         {
            _loc4_ = "0" + this.miao;
         }
         return _loc3_ + ":" + _loc4_;
      }
      
      private function petDataDisplay() : void
      {
         var _loc1_:PetR = null;
         if(this.state.getValue() == GS.a0)
         {
            this.initState0();
            this.jcBtn.btnOk(GS.a0);
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc1_ = this.cwMsg.getPetEggById(this.cuCwId.getValue()) as PetR;
               this.petEquip(_loc1_);
               this.petDataXX(_loc1_);
               this._bagDisplay.initGoodsDisplay(this._bagDisplay._bagState);
            }
            else if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is EggR)
            {
               this.aPanel.s_0.cwmx.gotoAndStop((this.cwMsg.getPetEggById(this.cuCwId.getValue()) as EggR).pcolor);
            }
         }
         else if(this.state.getValue() == GS.a1)
         {
            this.initState1();
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc1_ = this.cwMsg.getPetEggById(this.cuCwId.getValue()) as PetR;
               this.petRh(_loc1_);
               this.petJh(_loc1_);
            }
         }
         else if(this.state.getValue() == GS.a2)
         {
            this.initState2();
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc1_ = this.cwMsg.getPetEggById(this.cuCwId.getValue()) as PetR;
               this.petSkillFrame(_loc1_);
            }
         }
      }
      
      private function petSkillFrame(param1:PetR) : void
      {
         var _loc6_:PetSkillShowSaveD = null;
         var _loc2_:MovieClip = this.aPanel.s_2;
         var _loc3_:Array = param1.getlwDaoSkillArr();
         var _loc4_:uint = 0;
         while(_loc4_ < 16)
         {
            if(_loc3_[_loc4_] != null)
            {
               _loc6_ = _loc3_[_loc4_] as PetSkillShowSaveD;
               (this.jnArr[_loc4_] as GoodsBtnX).visible = true;
               (this.jnArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(_loc6_.getFrameNum());
               _loc2_["jnd_" + _loc4_].visible = true;
               (this.jnArr[_loc4_] as GoodsBtnX).getSmMc().tx_0.text = _loc6_.getsname();
               ((this.jnArr[_loc4_] as GoodsBtnX).getSmMc().tx_0 as TextField).setTextFormat(this.tfArr[_loc6_.getscolor()]);
               (this.jnArr[_loc4_] as GoodsBtnX).getSmMc().tx_1.text = "Lv." + _loc6_.curLv;
            }
            _loc4_++;
         }
         _loc4_ = 16;
         while(_loc4_ < 21)
         {
            if(_loc3_[_loc4_] != null)
            {
               _loc6_ = _loc3_[_loc4_] as PetSkillShowSaveD;
               (this.jnArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(_loc6_.getFrameNum());
               (this.jnArr[_loc4_] as GoodsBtnX).getSmMc().tx_0.text = _loc6_.getsname();
               ((this.jnArr[_loc4_] as GoodsBtnX).getSmMc().tx_0 as TextField).setTextFormat(this.tfArr[_loc6_.getscolor()]);
               (this.jnArr[_loc4_] as GoodsBtnX).getSmMc().tx_1.text = "Lv." + _loc6_.curLv;
            }
            _loc4_++;
         }
         var _loc5_:Array = param1.getuseSkillArr();
         _loc4_ = 0;
         while(_loc4_ < 7)
         {
            if(_loc4_ <= param1.curPot - GS.a1)
            {
               if(_loc5_[_loc4_] != null)
               {
                  _loc6_ = _loc5_[_loc4_] as PetSkillShowSaveD;
                  (this.zbjnArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(_loc6_.getFrameNum());
                  (this.zbjnArr[_loc4_] as GoodsBtnX).getSmMc().tx_0.text = _loc6_.getsname();
                  (this.zbjnArr[_loc4_] as GoodsBtnX).getSmMc().tx_1.text = "Lv." + _loc6_.curLv;
                  ((this.zbjnArr[_loc4_] as GoodsBtnX).getSmMc().tx_0 as TextField).setTextFormat(this.tfArr[_loc6_.getscolor()]);
               }
               else
               {
                  (this.zbjnArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(2);
               }
            }
            _loc4_++;
         }
         (this.jblwBtnArr[param1.curLWJieDuan] as ClickBtnX).okBtn = true;
         if(param1.curLWJieDuan == GS.a3)
         {
            (this.djlwBtnArr[GS.a0] as ClickBtnX).okBtn = true;
         }
         else if(param1.curLWJieDuan == GS.a4)
         {
            (this.djlwBtnArr[GS.a1] as ClickBtnX).okBtn = true;
         }
      }
      
      private function petRh(param1:PetR) : void
      {
         var _loc2_:MovieClip = this.aPanel.s_1;
         _loc2_.s1mx_0.gotoAndStop(param1.getPetFrame());
         _loc2_.s1mx_0.cw.gotoAndStop(param1.curPot + GS.a1);
         _loc2_.rhlv_tx.text = String(param1.tolv);
         _loc2_.rhlv_exp.text = String(param1.toExp + "/" + param1.getRHNextExp());
         if(param1.getpotLimit() <= param1.curPot)
         {
            _loc2_.s1mc.gotoAndStop(2);
            _loc2_.rh_sm.text = "已达资质极限" + "\n" + "无法继续进化";
         }
         else
         {
            _loc2_.rh_sm.text = "融合" + (param1.curPot + 1) * GS.a10 + "级" + "\n" + "可进化";
         }
         this.rhBtn.okBtn = true;
      }
      
      private function petJh(param1:PetR) : void
      {
         var _loc2_:MovieClip = this.aPanel.s_1;
         if(param1.getpotLimit() > GS.a0 && param1.curPot < param1.getpotLimit())
         {
            _loc2_.s1mx_1.gotoAndStop(param1.getPetFrame());
            _loc2_.s1mx_1.cw.gotoAndStop(param1.curPot + GS.a2);
         }
         if(param1.isKeYiJinHua())
         {
            this.jhBtn.okBtn = true;
         }
      }
      
      private function petDataXX(param1:PetR) : void
      {
         var _loc5_:String = null;
         var _loc2_:PetBag = param1.pbag;
         _loc2_.jsSx();
         var _loc3_:MovieClip = this.aPanel.s_0;
         _loc3_.cw_name.text = param1.getname();
         var _loc4_:TextFormat = new TextFormat();
         switch(param1.getpColor())
         {
            case 0:
               _loc4_.color = "0xffffff";
               break;
            case 1:
               _loc4_.color = "0x0066ff";
               break;
            case 2:
               _loc4_.color = "0xFF33FF";
               break;
            case 3:
               _loc4_.color = "0xffcc00";
         }
         (_loc3_.cw_name as TextField).setTextFormat(_loc4_);
         _loc3_.cw_lv.text = String("Lv." + param1.lv);
         _loc3_.xxMc.gotoAndStop(param1.getpotLimit() + 1);
         _loc3_.xl_text.text = param1.getType();
         switch(param1.curPot)
         {
            case 0:
               _loc5_ = "幼年形态";
               break;
            case 1:
               _loc5_ = "成长形态";
               break;
            case 2:
               _loc5_ = "成年形态";
               break;
            case 3:
               _loc5_ = "圆满形态";
               break;
            case 4:
               _loc5_ = "超级形态";
               break;
            case 5:
               _loc5_ = "完美形态";
               break;
            case 6:
               _loc5_ = "终极形态";
               break;
            case 7:
               _loc5_ = " 爆裂形态";
         }
         _loc3_.jd_text.text = _loc5_;
         _loc3_.cwmx.gotoAndStop(param1.getPetFrame());
         _loc3_.cwmx.cw.gotoAndStop(param1.curPot + GS.a1);
         _loc3_.exp_tx.text = String(param1.curExp) + "/" + param1.getNextExp();
         (this.aPanel.s_0.jytmc.jyt as MovieClip).width = int(param1.curExp / param1.getNextExp() * this.aPanel.s_0.jytmc.width);
         this.aPanel.s_0.a_text.text = String(int(param1.getHp()));
         this.aPanel.s_0.b_text.text = String(int(param1.getNl()));
         this.aPanel.s_0.c_text.text = String(int(param1.getAtt()));
         this.aPanel.s_0.d_text.text = String(int(param1.getFy()));
         this.aPanel.s_0.e_text.text = String(0);
         this.aPanel.s_0.f_text.text = String((param1.getBj() * GS.a100).toFixed(1) + "%");
         this.czBtn.closeOrOpenBtnById(0,1);
         if(this.cwMsg.isFighting(this.cuCwId.getValue()))
         {
            this.czBtn.setClick(GS.a0,true);
            this.aPanel.s_0.cz_0.cztext.text = "休息";
         }
         else
         {
            this.czBtn.setClick(GS.a0,false);
            this.aPanel.s_0.cz_0.cztext.text = "出战";
         }
         if(param1.lv < this.maxLv.getValue())
         {
            this.sjBtn.okBtn = true;
         }
         this.fsBtnx.okBtn = true;
         this._bagDisplay.tbMastMc();
      }
      
      private function petEquip(param1:PetR) : void
      {
         var _loc5_:Gird = null;
         var _loc6_:Goods = null;
         var _loc2_:Bag = param1.pbag;
         var _loc3_:Array = _loc2_.getBagArr();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(this.tbBoxArrcw[_loc4_] != null)
            {
               _loc5_ = _loc3_[_loc4_] as Gird;
               _loc6_ = _loc5_.getGoods();
               if(_loc6_ != null)
               {
                  (this.tbBoxArrcw[_loc4_] as GoodsBtnX).visible = true;
                  this.aPanel.s_0["tx_" + _loc4_].visible = false;
                  (this.tbBoxArrcw[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(_loc6_.getFrame());
                  if(_loc5_.getGoodsNum() > 1)
                  {
                     (this.tbBoxArrcw[_loc4_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc5_.getGoodsNum());
                  }
               }
            }
            _loc4_++;
         }
      }
      
      private function tuoHandle(param1:BtnEvent) : void
      {
         var _loc2_:PetR = null;
         var _loc3_:Bag = null;
         var _loc4_:Goods = null;
         if(param1.name == "ce")
         {
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc2_ = this.cwMsg.getPetById(this.cuCwId.getValue());
               _loc3_ = _loc2_.pbag;
               if(BagFactory.equipBag.getAirGirdNum() > 0 && BagFactory.clothesBag.getAirGirdNum() > 0)
               {
                  _loc4_ = _loc3_.getGoods(param1.id);
                  if(_loc4_ != null)
                  {
                     _loc3_.deleteBag(param1.id,GS.a1);
                     Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc4_,-1));
                     this.petDataDisplay();
                  }
               }
               else
               {
                  GoodsManger.cwTs("背包已满");
               }
            }
         }
      }
      
      private function petHandle(param1:GoodsEvent) : void
      {
         var _loc6_:PetR = null;
         var _loc7_:Bag = null;
         var _loc8_:Goods = null;
         var _loc2_:Goods = param1.goods;
         var _loc3_:Number = param1.id;
         var _loc4_:Number = _loc2_.getType();
         var _loc5_:Number = _loc2_.getSmallType();
         if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
         {
            _loc6_ = this.cwMsg.getPetById(this.cuCwId.getValue());
            _loc7_ = _loc6_.pbag;
            if(_loc4_ == 0)
            {
               if(_loc7_.getGoods(_loc5_) != null)
               {
                  _loc8_ = DeepCopyUtil.clone(_loc7_.getGoods(_loc5_));
                  _loc7_.deleteBag(_loc5_,GS.a1);
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc8_,_loc3_));
               }
               _loc7_.addToBag(_loc2_,_loc5_,GS.a1);
               this.petDataDisplay();
            }
            this.sxJs(0);
         }
         else
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_BACK,_loc2_,_loc3_));
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.tuoHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         addEventListener(GoodsEvent.DO_PETWEAR,this.petHandle);
         addEventListener(BtnEvent.DO_MOUSEMOVE,this.moveHandle);
         addEventListener(BtnEvent.DO_MOUSEUP_TOW,this.changeJnHandle);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer.start();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.tuoHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
         removeEventListener(GoodsEvent.DO_PETWEAR,this.petHandle);
         removeEventListener(BtnEvent.DO_MOUSEMOVE,this.moveHandle);
         removeEventListener(BtnEvent.DO_MOUSEUP_TOW,this.changeJnHandle);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      private function changeJnHandle(param1:BtnEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:PetR = null;
         if(this.fomeName != null && this.fomrId.getValue() != -1)
         {
            _loc2_ = this.aPanel.moveMc;
            _loc2_.visible = false;
            this.toName = null;
            this.toId.setValue(-1);
            _loc3_ = 0;
            while(_loc3_ < 21)
            {
               if(Boolean((this.jnArr[_loc3_] as GoodsBtnX).hitTestPoint(this.mouseX,this.mouseY,true)) && Boolean((this.jnArr[_loc3_] as GoodsBtnX).visible))
               {
                  this.toName = "j";
                  this.toId.setValue(_loc3_);
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               if((this.zbjnArr[_loc3_] as GoodsBtnX).hitTestPoint(this.mouseX,this.mouseY,true))
               {
                  this.toName = "zj";
                  this.toId.setValue(_loc3_);
               }
               _loc3_++;
            }
            if(this.fomeName == this.toName && this.fomrId.getValue() == this.toId.getValue())
            {
               this.fomeName = null;
               this.fomrId.setValue(-1);
               this.petDataDisplay();
               return;
            }
            if(this.toName != null && this.toId.getValue() != -1)
            {
               _loc4_ = this.cwMsg.getPetById(this.cuCwId.getValue()) as PetR;
               if(this.fomeName == "j")
               {
                  if(this.toName == "j")
                  {
                     this.sktype.setValue(GS.a1);
                     if(_loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue()) == "不用弹框")
                     {
                        this.skillHc();
                     }
                     else
                     {
                        this.aPanel.jnhc_mc.visible = true;
                        this.aPanel.jnhc_mc.jnhc_tx.text = _loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue());
                     }
                  }
                  else if(this.toName == "zj")
                  {
                     if(this.isOPen(this.toId.getValue()))
                     {
                        this.sktype.setValue(GS.a3);
                        if(_loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue()) == "不用弹框")
                        {
                           this.skillHc();
                        }
                        else
                        {
                           this.aPanel.jnhc_mc.visible = true;
                           this.aPanel.jnhc_mc.jnhc_tx.text = _loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue());
                        }
                     }
                     else
                     {
                        this.fomeName = null;
                        this.fomrId.setValue(-1);
                        this.toName = null;
                        this.toId.setValue(-1);
                        this.petDataDisplay();
                     }
                  }
               }
               else if(this.fomeName == "zj")
               {
                  if(this.toName == "j")
                  {
                     this.sktype.setValue(GS.a4);
                     if(_loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue()) == "不用弹框")
                     {
                        this.skillHc();
                     }
                     else
                     {
                        this.aPanel.jnhc_mc.visible = true;
                        this.aPanel.jnhc_mc.jnhc_tx.text = _loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue());
                     }
                  }
                  else if(this.toName == "zj")
                  {
                     this.sktype.setValue(GS.a2);
                     if(this.isOPen(this.toId.getValue()))
                     {
                        if(_loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue()) == "不用弹框")
                        {
                           this.skillHc();
                        }
                        else
                        {
                           this.aPanel.jnhc_mc.visible = true;
                           this.aPanel.jnhc_mc.jnhc_tx.text = _loc4_.wangjieShowFun(this.sktype.getValue(),this.fomrId.getValue(),this.toId.getValue());
                        }
                     }
                     else
                     {
                        this.fomeName = null;
                        this.fomrId.setValue(-1);
                        this.toName = null;
                        this.toId.setValue(-1);
                        this.petDataDisplay();
                     }
                  }
               }
            }
            else
            {
               this.fomeName = null;
               this.fomrId.setValue(-1);
               this.toName = null;
               this.toId.setValue(-1);
               this.petDataDisplay();
            }
         }
      }
      
      public function isOPen(param1:Number) : Boolean
      {
         if(param1 < this.cwMsg.getPetById(this.cuCwId.getValue()).curPot)
         {
            return true;
         }
         return false;
      }
      
      private function skillHc() : void
      {
         var _loc1_:String = "";
         if(this.sktype.getValue() == 1)
         {
            _loc1_ = this.cwMsg.saveToSaveDrag(this.cuCwId.getValue(),this.fomrId.getValue(),this.toId.getValue());
         }
         else if(this.sktype.getValue() == 2)
         {
            _loc1_ = this.cwMsg.useToUseDrag(this.cuCwId.getValue(),this.fomrId.getValue(),this.toId.getValue());
         }
         else if(this.sktype.getValue() == 3)
         {
            _loc1_ = this.cwMsg.saveToUseDrag(this.cuCwId.getValue(),this.fomrId.getValue(),this.toId.getValue());
         }
         else if(this.sktype.getValue() == 4)
         {
            _loc1_ = this.cwMsg.useToSaveDrag(this.cuCwId.getValue(),this.fomrId.getValue(),this.toId.getValue());
         }
         if(_loc1_ != "成功")
         {
            GoodsManger.cwTs(_loc1_);
         }
         this.fomeName = null;
         this.fomrId.setValue(-1);
         this.toName = null;
         this.toId.setValue(-1);
         this.petDataDisplay();
      }
      
      private function moveHandle(param1:BtnEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:PetSkillShowSaveD = null;
         var _loc4_:Number = NaN;
         if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
         {
            _loc2_ = this.aPanel.moveMc;
            if(param1.name == "j" || param1.name == "zj")
            {
               if(param1.name == "j")
               {
                  _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue()).getlwDaoSkillArrByid(param1.id);
               }
               else if(param1.name == "zj")
               {
                  _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue()).getuseSkillArrByid(param1.id);
               }
               if(_loc3_ != null)
               {
                  if(param1.name == "j")
                  {
                     if(param1.id < 16)
                     {
                        this.aPanel.s_2["jnd_" + param1.id].visible = false;
                     }
                     (this.jnArr[param1.id] as GoodsBtnX).visible = false;
                  }
                  else if(param1.name == "zj")
                  {
                     (this.zbjnArr[param1.id] as GoodsBtnX).visible = false;
                  }
                  _loc2_.visible = true;
                  _loc2_.x = mouseX - _loc2_.width / 2;
                  _loc2_.y = mouseY - _loc2_.height / 2;
                  _loc2_.gotoAndStop(_loc3_.getFrameNum());
                  _loc2_.tx_0.text = _loc3_.getsname();
                  _loc4_ = _loc3_.getscolor();
                  (_loc2_.tx_0 as TextField).setTextFormat(this.tfArr[_loc4_]);
                  _loc2_.tx_1.text = "Lv." + _loc3_.curLv;
                  this.fomeName = param1.name;
                  this.fomrId.setValue(param1.id);
               }
            }
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "ce")
         {
            (this.tbBoxArrcw[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "j" || param1.name == "zj")
         {
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               this.aPanel.jnts.visible = false;
               this.aPanel.jnts.x = 0;
               this.aPanel.jnts.y = 0;
               if(param1.name == "j")
               {
                  (this.jnArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               }
               else if(param1.name == "zj")
               {
                  (this.zbjnArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
                  this.aPanel.cwxzlwts.visible = false;
               }
            }
         }
         else if(param1.name == "gg")
         {
            (this.sjg as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "lw")
         {
            this.aPanel.cwxzlwts.visible = false;
            this.aPanel.cwxzlwts.x = 0;
            this.aPanel.cwxzlwts.y = 0;
         }
         else if(param1.name == "xzlw" || param1.name == "xxxmcc")
         {
            this.aPanel.xzlwtsxx.visible = false;
            this.aPanel.xzlwtsxx.x = 0;
            this.aPanel.xzlwtsxx.y = 0;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:PetR = null;
         var _loc3_:PetBag = null;
         var _loc4_:Goods = null;
         var _loc5_:PetSkillShowSaveD = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param1.name == "ce")
         {
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc2_ = this.cwMsg.getPetById(this.cuCwId.getValue());
               _loc3_ = _loc2_.pbag;
               _loc4_ = _loc3_.getGoods(param1.id);
               if(_loc4_ != null)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc4_,0,0,1,true,this.cuCwId.getValue()));
                  (this.tbBoxArrcw[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
               }
            }
         }
         else if(param1.name == "j" || param1.name == "zj")
         {
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               if(param1.name == "j")
               {
                  _loc5_ = this.cwMsg.getPetById(this.cuCwId.getValue()).getlwDaoSkillArrByid(param1.id);
                  (this.jnArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
               }
               else if(param1.name == "zj")
               {
                  _loc5_ = this.cwMsg.getPetById(this.cuCwId.getValue()).getuseSkillArrByid(param1.id);
                  (this.zbjnArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
                  if(this.isOPen(param1.id) == false)
                  {
                     this.aPanel.cwxzlwts.visible = true;
                     this.aPanel.cwxzlwts.x = mouseX;
                     this.aPanel.cwxzlwts.y = mouseY;
                     _loc6_ = param1.id + 1;
                     this.aPanel.cwxzlwts.goldTx.text = "进化" + _loc6_ + "次后可开启";
                  }
               }
               if(_loc5_ != null)
               {
                  this.aPanel.jnts.visible = true;
                  this.aPanel.jnts.x = mouseX;
                  this.aPanel.jnts.y = mouseY;
                  this.aPanel.jnts.name_tx.text = _loc5_.getsname() + "Lv." + _loc5_.curLv;
                  _loc7_ = _loc5_.getscolor();
                  (this.aPanel.jnts.name_tx as TextField).setTextFormat(this.tfArr[_loc7_]);
                  this.aPanel.jnts.lv_tx.text = "技能经验:" + _loc5_.curExp + "/" + _loc5_.getNextLvExp();
                  this.aPanel.jnts.sm_tx.text = _loc5_.getsshuomi();
               }
            }
         }
         else if(param1.name == "gg")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.sjgs));
            (this.sjg as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         else if(param1.name == "lw")
         {
            this.aPanel.cwxzlwts.visible = true;
            this.aPanel.cwxzlwts.x = mouseX;
            this.aPanel.cwxzlwts.y = 530;
            this.aPanel.cwxzlwts.goldTx.text = "消耗" + this.cwMsg.getPetById(this.cuCwId.getValue()).curLWXuYaoGod(param1.id) + "晶币领悟技能";
         }
         else if(param1.name == "xzlw")
         {
            this.aPanel.xzlwtsxx.visible = true;
            this.aPanel.xzlwtsxx.x = mouseX;
            this.aPanel.xzlwtsxx.y = mouseY;
            if(param1.id == 0)
            {
               this.aPanel.xzlwtsxx.xzlw_tx.text = "消耗200星钻领悟技能" + "\n" + "获得稀有技能概率提高数倍";
            }
            else if(param1.id == 1)
            {
               this.aPanel.xzlwtsxx.xzlw_tx.text = "消耗400星钻领悟技能" + "\n" + "获得稀有技能概率提高数倍";
            }
         }
         else if(param1.name == "xxxmcc")
         {
            this.aPanel.xzlwtsxx.visible = true;
            this.aPanel.xzlwtsxx.x = this.aPanel.s_0.x + 60;
            this.aPanel.xzlwtsxx.y = mouseY;
            this.aPanel.xzlwtsxx.xzlw_tx.text = "资质星级代表了宠物可以进化的次数";
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "rhclose")
         {
            this.aPanel.rhtk_mc.visible = false;
         }
      }
      
      private function loadCzOver() : void
      {
         if(this.pox.getValue() != -1)
         {
            this.cwMsg.joinFight(this.pox.getValue());
            this.aPanel.s_0.cz_0.cztext.text = "休息";
            this.pox.setValue(-1);
            this.initCwData();
            this.cwMsg.getPetById(this.cuCwId.getValue()).pbag.jsSx(this.cwMsg.getPetById(this.cuCwId.getValue()));
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         if(param1.name == "cw")
         {
            this.state.setValue(param1.id);
            this.stateDisplay();
            this.petDataDisplay();
            this._bagDisplay.getGoldTx();
         }
         else if(param1.name == "xz")
         {
            this.xzCwFun(param1.id);
         }
         else if(param1.name == "sb")
         {
            this.sxJs(param1.id);
         }
         else if(param1.name == "cz")
         {
            if(this.cwMsg.getPetById(this.cuCwId.getValue()).curHp > GS.a0)
            {
               if(this.czBtn.getClick(GS.a0))
               {
                  if(LoaderManager.isLoadedByMcname(this.cwMsg.getPetById(this.cuCwId.getValue()).getpetEle()))
                  {
                     this.pox.setValue(-1);
                     this.cwMsg.joinFight(this.cuCwId.getValue());
                     this.aPanel.s_0.cz_0.cztext.text = "休息";
                     this.initCwData();
                     this.cwMsg.getPetById(this.cuCwId.getValue()).pbag.jsSx(this.cwMsg.getPetById(this.cuCwId.getValue()));
                  }
                  else
                  {
                     if(GM.loaderM.keYiUse())
                     {
                        this.pox.setValue(this.cuCwId.getValue());
                        _loc2_ = new Array();
                        _loc2_.push(this.cwMsg.getPetById(this.cuCwId.getValue()).getpetEle());
                        GM.loaderM.setLoadData(_loc2_);
                        GM.loaderM.completeF = this.loadCzOver;
                        GM.loaderM.startLoadDataJieM();
                        return;
                     }
                     GoodsManger.cwTs("装备信息加载中……");
                  }
               }
               else
               {
                  this.cwMsg.stopFight(this.cuCwId.getValue());
                  this.aPanel.s_0.cz_0.cztext.text = "出战";
                  this.initCwData();
               }
            }
            else
            {
               GoodsManger.cwTs("该宠物已经阵亡");
            }
         }
         else if(param1.name == "rhxz")
         {
            this.cuRh.setValue(param1.id);
            if(this.cwMsg.getPetById(param1.id) is PetR && this.cuRh.getValue() != this.cuCwId.getValue())
            {
               this.rhsBtn.okBtn = true;
               this.aPanel.rhtk_mc.rhexp.text = String(this.cwMsg.getPetById(param1.id).toExp + this.cwMsg.getPetById(this.cuCwId.getValue()).toExp);
            }
            else
            {
               this.rhsBtn.okBtn = false;
               this.aPanel.rhtk_mc.rhexp.text = "";
            }
         }
      }
      
      private function sxJs(param1:Number) : void
      {
         var _loc2_:PetR = null;
         if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
         {
            _loc2_ = this.cwMsg.getPetById(this.cuCwId.getValue());
            if(param1 == 0)
            {
               this.aPanel.s_0.a_text.text = String(int(_loc2_.getHp()));
               this.aPanel.s_0.b_text.text = String(int(_loc2_.getNl()));
               this.aPanel.s_0.c_text.text = String(int(_loc2_.getAtt()));
               this.aPanel.s_0.d_text.text = String(int(_loc2_.getFy()));
               this.aPanel.s_0.e_text.text = String(0);
               this.aPanel.s_0.f_text.text = String((_loc2_.getBj() * GS.a100).toFixed(1) + "%");
               this.aPanel.s_0.type_mc.gotoAndStop(1);
            }
            else if(param1 == 1)
            {
               this.aPanel.s_0.a_text.text = String(int(_loc2_.getJin()));
               this.aPanel.s_0.b_text.text = String(int(_loc2_.getMu()));
               this.aPanel.s_0.c_text.text = String(int(_loc2_.getShui()));
               this.aPanel.s_0.d_text.text = String(int(_loc2_.getHuo()));
               this.aPanel.s_0.e_text.text = String(int(_loc2_.getTu()));
               this.aPanel.s_0.f_text.text = String(int(_loc2_.getHd()));
               this.aPanel.s_0.type_mc.gotoAndStop(2);
            }
         }
      }
      
      private function xzCwFun(param1:Number) : void
      {
         this.cuCwId.setValue(this.ye.getValue() * GS.a4 + param1 + GS.a1);
         if(this.ye.getValue() * 4 + param1 + 1 > this.cwMsg.opennum)
         {
            this.aPanel.openTs.visible = true;
         }
         this.petDataDisplay();
      }
      
      private function shopingOpenX(param1:int) : void
      {
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            this.cwMsg.addOpenNum();
            FlowInterface.saveDataByKaiOnlyShop();
            this.initCwData();
            this.petDataDisplay();
            this.aPanel.openTs.visible = false;
            GoodsManger.cwTs("宠物栏解锁成功");
         }
         else
         {
            this.czMc.visible = true;
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:VT = null;
         var _loc3_:PetR = null;
         var _loc4_:VT = null;
         var _loc5_:URLRequest = null;
         if(param1.name == "op")
         {
            if(param1.id == 0)
            {
               this.czingMc.visible = true;
               FlowInterface.djGouMai(GS.a834,GS.a1,GS.a500,this.shopingOpenX,GS.a0);
            }
            else if(param1.id == 1)
            {
               this.aPanel.openTs.visible = false;
            }
         }
         else if(param1.name == "qh")
         {
            this.qhFun(param1.id);
         }
         else if(param1.name == "ok")
         {
            if(param1.id == 0)
            {
               this.czingMc.visible = true;
               FlowInterface.djGouMai(GS.a776,GS.a1,GS.a50,this.shopingLj,GS.a0);
            }
            this.aPanel.ts_mc.visible = false;
         }
         else if(param1.name == "lj")
         {
            this.cuCwId.setValue(this.ye.getValue() * GS.a4 + param1.id + GS.a1);
            this.xzcwBtn.btnOk(param1.id);
            this.petDataDisplay();
            this.aPanel.ts_mc.visible = true;
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
         else if(param1.name == "jyjt")
         {
            _loc2_ = VT.createVT(GS.a1);
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue());
               if(BagFactory.getNumById(this.sjgoodsId.getValue()) >= _loc3_.getNumByLvLimit())
               {
                  _loc2_.setValue(_loc3_.getNumByLvLimit());
               }
               else
               {
                  _loc2_.setValue(BagFactory.getNumById(this.sjgoodsId.getValue()));
                  if(_loc2_.getValue() == GS.a0)
                  {
                     _loc2_.setValue(GS.a1);
                  }
               }
               if(param1.id == 0)
               {
                  if(this.numVT.getValue() > GS.a1)
                  {
                     this.numVT.setValue(this.numVT.getValue() - GS.a1);
                  }
                  else
                  {
                     this.numVT.setValue(_loc2_.getValue());
                  }
               }
               else if(param1.id == 1)
               {
                  if(this.numVT.getValue() < _loc2_.getValue())
                  {
                     this.numVT.setValue(this.numVT.getValue() + GS.a1);
                  }
                  else
                  {
                     this.numVT.setValue(GS.a1);
                  }
               }
               this.textFun(this.numVT.getValue());
            }
         }
         else if(param1.name == "sj")
         {
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               this.aPanel.jy_mc.visible = true;
               this.numVT.setValue(GS.a1);
               this.textFun(this.numVT.getValue());
               this.aPanel.jy_mc.num_tx.restrict = "0-9";
               this.aPanel.jy_mc.num_tx.maxChars = GS.a4;
            }
         }
         else if(param1.name == "jys")
         {
            if(param1.id == 0)
            {
               if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
               {
                  _loc4_ = VT.createVT(GS.a1);
                  if(BagFactory.getNumById(this.sjgoodsId.getValue()) >= this.cwMsg.getPetById(this.cuCwId.getValue()).getNumByLvLimit())
                  {
                     _loc4_.setValue(this.cwMsg.getPetById(this.cuCwId.getValue()).getNumByLvLimit());
                  }
                  else
                  {
                     _loc4_.setValue(BagFactory.getNumById(this.sjgoodsId.getValue()));
                     if(_loc4_.getValue() == GS.a0)
                     {
                        _loc4_.setValue(GS.a1);
                     }
                  }
                  if(this.aPanel.jy_mc.num_tx.text == GS.a0)
                  {
                     this.numVT.setValue(GS.a1);
                  }
                  else if(this.aPanel.jy_mc.num_tx.text > _loc4_.getValue())
                  {
                     this.numVT.setValue(_loc4_.getValue());
                  }
                  else
                  {
                     this.numVT.setValue(Number(this.aPanel.jy_mc.num_tx.text));
                  }
                  if(this.numVT.getValue() <= GS.a0)
                  {
                     return;
                  }
                  if(BagFactory.getNumById(this.sjgoodsId.getValue()) >= this.numVT.getValue())
                  {
                     _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue());
                     if(BagFactory.deteleGoods(this.sjgoodsId.getValue(),this.numVT.getValue()))
                     {
                        _loc3_.addExp(this.numVT.getValue() * GS.a10000 * GS.a10);
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("物品数量不足");
                  }
               }
               this.petDataDisplay();
            }
            this.aPanel.jy_mc.visible = false;
         }
         else if(param1.name == "rh")
         {
            if(param1.id == GS.a0)
            {
               this.rhFun();
            }
            else if(param1.id == GS.a1)
            {
               GoodsManger.movicpStr(0,0,this.jinhuaOk,"Ts_800");
            }
         }
         else if(param1.name == "resure")
         {
            if(this.cuRh.getValue() == -1)
            {
               GoodsManger.cwTs("请选择你要融合的宠物");
            }
            else if(this.cwMsg.getPetById(this.cuCwId.getValue()).isRHLvLimit() == false)
            {
               if(this.cwMsg.getPetById(this.cuRh.getValue()).pbag.isEquip() == false)
               {
                  if(this.cwMsg.getPetById(this.cuRh.getValue()).isYoulwWeiZhi())
                  {
                     this.cwMsg.petRongHe(this.cuRh.getValue(),this.cuCwId.getValue());
                     this.initCwData();
                     this.petDataDisplay();
                     this.aPanel.rhtk_mc.visible = false;
                  }
                  else
                  {
                     GoodsManger.cwTs("领悟技能空间不足无法将被融合宠物技能经验全部保留");
                  }
               }
               else
               {
                  GoodsManger.cwTs("被融合宠物得先卸下装备才能融合");
               }
            }
            else
            {
               GoodsManger.cwTs("融合等级已达上限");
            }
         }
         else if(param1.name == "lw")
         {
            _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue()) as PetR;
            if(_loc3_.curPot > GS.a0)
            {
               if(_loc3_.isYoulwWeiZhi())
               {
                  if(FlowInterface.getGodByRole() >= _loc3_.curLWXuYaoGod(param1.id))
                  {
                     if(_loc3_.petlWSkillByGod(param1.id))
                     {
                        FlowInterface.redGodByRole(_loc3_.curLWXuYaoGod(param1.id));
                        this.petDataDisplay();
                        GoodsManger.cwTs("领悟成功");
                        GoodsManger.dataList.evData.setJd(GS.a13);
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("领悟经验栏已满");
               }
            }
            else
            {
               GoodsManger.cwTs("开启技能栏后才可领悟");
            }
         }
         else if(param1.name == "xzlw")
         {
            _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue()) as PetR;
            if(_loc3_.isYoulwWeiZhi())
            {
               this.czingMc.visible = true;
               if(param1.id == GS.a0)
               {
                  FlowInterface.djGouMai(GS.a830,GS.a1,GS.a200,this.shopingLw0,GS.a0);
               }
               else if(param1.id == GS.a1)
               {
                  FlowInterface.djGouMai(GS.a831,GS.a1,GS.a400,this.shopingLw1,GS.a0);
               }
            }
            else
            {
               GoodsManger.cwTs("领悟经验栏已满");
            }
         }
         else if(param1.name == "allxs")
         {
            if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
            {
               _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue()) as PetR;
               _loc3_.intoOne();
               this.petDataDisplay();
            }
         }
         else if(param1.name == "jnok")
         {
            if(param1.id == 0)
            {
               this.skillHc();
            }
            else
            {
               this.petDataDisplay();
               this.fomeName = null;
               this.fomrId.setValue(-1);
               this.toName = null;
               this.toId.setValue(-1);
            }
            this.aPanel.jnhc_mc.visible = false;
         }
         else if(param1.name == "ltbtn")
         {
            _loc5_ = new URLRequest("http://my.4399.com/forums-thread-tagid-81881-id-37094156.html");
            navigateToURL(_loc5_,"_blank");
         }
         else if(param1.name == "fq")
         {
            this.aPanel.fqTs.visible = false;
            if(param1.id == GS.a0)
            {
               if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
               {
                  _loc3_ = this.cwMsg.getPetById(this.cuCwId.getValue()) as PetR;
                  if(_loc3_.pbag.isEquip() == false)
                  {
                     this.cwMsg.delPetByFangsheng(this.cuCwId.getValue());
                     this.initCwData();
                     this.petDataDisplay();
                  }
                  else
                  {
                     GoodsManger.cwTs("穿戴装备的宠物无法放生");
                  }
               }
            }
         }
         else if(param1.name == "fsBtn")
         {
            this.aPanel.fqTs.visible = true;
         }
      }
      
      private function jinhuaOk() : void
      {
         this.cwMsg.petJinHuaByFighting(this.cuCwId.getValue());
         this.initCwData();
         this.petDataDisplay();
         GoodsManger.cwTs("进化成功");
      }
      
      private function shopingLw0(param1:Number) : void
      {
         var _loc2_:PetR = null;
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            _loc2_ = this.cwMsg.getPetById(this.cuCwId.getValue());
            _loc2_.petlWSkillByXin(GS.a0);
            FlowInterface.saveDataByKaiOnlyShop();
            GoodsManger.cwTs("领悟成功");
            this.petDataDisplay();
         }
         else
         {
            this.czMc.visible = true;
         }
      }
      
      private function shopingLw1(param1:Number) : void
      {
         var _loc2_:PetR = null;
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            _loc2_ = this.cwMsg.getPetById(this.cuCwId.getValue());
            _loc2_.petlWSkillByXin(GS.a1);
            FlowInterface.saveDataByKaiOnlyShop();
            GoodsManger.cwTs("领悟成功");
            this.petDataDisplay();
         }
         else
         {
            this.czMc.visible = true;
         }
      }
      
      private function rhFun() : void
      {
         var _loc4_:TextFormat = null;
         this.cuRh.setValue(-1);
         this.rxBtn.czArr();
         this.aPanel.rhtk_mc.visible = true;
         var _loc1_:Array = this.cwMsg.getKeRHPetList(this.cuCwId.getValue());
         var _loc2_:MovieClip = this.aPanel.rhtk_mc;
         var _loc3_:uint = 1;
         while(_loc3_ <= 12)
         {
            if(_loc1_[_loc3_] != null)
            {
               _loc2_["rhcw_" + _loc3_].gotoAndStop((_loc1_[_loc3_] as PetR).getPetFrame());
               _loc2_["rhcw_" + _loc3_].cw.gotoAndStop((_loc1_[_loc3_] as PetR).curPot + GS.a1);
               _loc2_["rhcw_" + _loc3_].cw_name.text = (_loc1_[_loc3_] as PetR).getname();
               _loc2_["rhcw_" + _loc3_].cw_lv.text = "Lv." + (_loc1_[_loc3_] as PetR).lv;
               _loc4_ = new TextFormat();
               switch((_loc1_[_loc3_] as PetR).getpColor())
               {
                  case 0:
                     _loc4_.color = "0xffffff";
                     break;
                  case 1:
                     _loc4_.color = "0x0066ff";
                     break;
                  case 2:
                     _loc4_.color = "0xFF33FF";
                     break;
                  case 3:
                     _loc4_.color = "0xffcc00";
               }
               (_loc2_["rhcw_" + _loc3_].cw_name as TextField).setTextFormat(_loc4_);
            }
            else
            {
               _loc2_["rhcw_" + _loc3_].gotoAndStop(1);
               _loc2_["rhcw_" + _loc3_].cw_name.text = "";
               _loc2_["rhcw_" + _loc3_].cw_lv.text = "";
            }
            _loc3_++;
         }
         this.aPanel.rhtk_mc.rhexp.text = "";
      }
      
      private function textFun(param1:Number) : void
      {
         this.aPanel.jy_mc.num_tx.text = String(param1);
         this.aPanel.jy_mc.needText.text = String(param1 * GS.a10000 * GS.a10);
         (this.sjg as GoodsBtnX).getSmMc().gotoAndStop(this.sjgs.getFrame());
         (this.sjg as GoodsBtnX).getSmMc().t_txt.text = String(BagFactory.getNumById(this.sjgoodsId.getValue()));
      }
      
      private function shopingLj(param1:Number) : void
      {
         this.czingMc.visible = false;
         if(param1 == GS.a1)
         {
            this.cwMsg.eggChangPet(this.cuCwId.getValue());
            FlowInterface.saveDataByKaiOnlyShop();
            this.initCwData();
            this.petDataDisplay();
            GoodsManger.cwTs("孵化成功");
         }
         else
         {
            this.czMc.visible = true;
         }
      }
      
      private function qhFun(param1:Number) : void
      {
         if(param1 == GS.a0)
         {
            if(this.ye.getValue() > GS.a0)
            {
               this.ye.setValue(this.ye.getValue() - GS.a1);
            }
            else
            {
               this.ye.setValue(GS.a2);
            }
         }
         else if(param1 == GS.a1)
         {
            if(this.ye.getValue() < GS.a2)
            {
               this.ye.setValue(this.ye.getValue() + GS.a1);
            }
            else
            {
               this.ye.setValue(GS.a0);
            }
         }
         this.initCwData();
         this.xzcwBtn.czArr();
         var _loc2_:uint = 0;
         while(_loc2_ < 4)
         {
            if(this.cuCwId.getValue() - 1 == this.ye.getValue() * 4 + _loc2_)
            {
               this.xzcwBtn.btnOk(_loc2_);
               break;
            }
            _loc2_++;
         }
         this.yeMa();
      }
      
      private function stateDisplay() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            this.aPanel["s_" + _loc1_].visible = false;
            _loc1_++;
         }
         this._bagDisplay.visible = false;
         if(this.state.getValue() == GS.a0)
         {
            this._bagDisplay.visible = true;
            this._sxDisplay.visible = true;
         }
         this.aPanel["s_" + this.state.getValue()].visible = true;
      }
      
      private function initBag() : void
      {
         this.centerMc.addChild(this._bagDisplay);
         this._bagDisplay.init();
         this._bagDisplay._parentMc = this;
         this.centerMc.addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function allFun() : void
      {
         var _loc8_:ClickBtnX = null;
         var _loc9_:ClickBtnX = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         this.cwStateBtn = SameChangeBtnX.createSameChangeBtn(new Array(this.aPanel.cw_0,this.aPanel.cw_1,this.aPanel.cw_2));
         this.aPanel.addChild(this.cwStateBtn);
         this.xzcwBtn = SameChangeBtnX.createSameChangeBtn(new Array(this.aPanel.xz_0,this.aPanel.xz_1,this.aPanel.xz_2,this.aPanel.xz_3));
         this.aPanel.addChild(this.xzcwBtn);
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            _loc8_ = new ClickBtnX(this.aPanel["qh_" + _loc1_],this.aPanel["qh_" + _loc1_].x,this.aPanel["qh_" + _loc1_].y);
            this.aPanel.addChild(_loc8_);
            _loc9_ = new ClickBtnX(this.aPanel.jnhc_mc["jnok_" + _loc1_],this.aPanel.jnhc_mc["jnok_" + _loc1_].x,this.aPanel.jnhc_mc["jnok_" + _loc1_].y);
            this.aPanel.jnhc_mc.addChild(_loc9_);
            _loc1_++;
         }
         this.upMc.addChild(this.aPanel.jnhc_mc);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc10_ = new ClickBtnX(this.aPanel["lj_" + _loc1_],this.aPanel["lj_" + _loc1_].x,this.aPanel["lj_" + _loc1_].y);
            this.aPanel.addChild(_loc10_);
            this.aPanel["cwlan_" + _loc1_].cw_time.embedFonts = true;
            this.aPanel["cwlan_" + _loc1_].cw_time.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
            _loc1_++;
         }
         var _loc2_:CloseBtnX = new CloseBtnX(this.aPanel.close_btn,this.aPanel.close_btn.x,this.aPanel.close_btn.y);
         this.aPanel.addChild(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            _loc11_ = new ClickBtnX(this.aPanel.openTs["op_" + _loc1_],this.aPanel.openTs["op_" + _loc1_].x,this.aPanel.openTs["op_" + _loc1_].y);
            this.aPanel.openTs.addChild(_loc11_);
            _loc1_++;
         }
         this.upMc.addChild(this.aPanel.openTs);
         var _loc3_:Object = LoaderManager.getSwfClass("Ts_74");
         this.czingMc = new _loc3_();
         this.upMc.addChild(this.czingMc);
         var _loc4_:Object = LoaderManager.getSwfClass("Ts_69") as Class;
         this.czMc = new _loc4_();
         this.upMc.addChild(this.czMc);
         var _loc5_:ClickBtnX = new ClickBtnX(this.czMc.cz_0,this.czMc.cz_0.x,this.czMc.cz_0.y);
         this.czMc.addChild(_loc5_);
         var _loc6_:ClickBtnX = new ClickBtnX(this.czMc.sure_0,this.czMc.sure_0.x,this.czMc.sure_0.y);
         this.czMc.addChild(_loc6_);
         this.textFormatFun();
         var _loc7_:Object = LoaderManager.getSwfClass("Tm_mc") as Class;
         this.cdMc = new _loc7_();
         this.upMc.addChild(this.cdMc);
         this.aPanel.rhtk_mc.rhexp.embedFonts = true;
         this.aPanel.rhtk_mc.rhexp.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         this.aPanel.jnhc_mc.jnhc_tx.embedFonts = true;
         this.aPanel.jnhc_mc.jnhc_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         this.aPanel.addChild(this.aPanel.cwxzlwts);
         (this.aPanel.cwxzlwts as MovieClip).mouseChildren = false;
         (this.aPanel.cwxzlwts as MovieClip).mouseEnabled = false;
         this.aPanel.addChild(this.aPanel.xzlwtsxx);
         (this.aPanel.xzlwtsxx as MovieClip).mouseChildren = false;
         (this.aPanel.xzlwtsxx as MovieClip).mouseEnabled = false;
      }
      
      private function state0Fun() : void
      {
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         var _loc9_:ClickBtnX = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:ClickBtnX = null;
         var _loc1_:Object = LoaderManager.getSwfClass("T_Box") as Class;
         var _loc2_:uint = 0;
         while(_loc2_ < 16)
         {
            if(this.aPanel.s_0["bd_" + _loc2_] != null)
            {
               _loc7_ = new _loc1_();
               _loc7_.name = "ce_" + _loc2_;
               _loc8_ = new GoodsBtnX(_loc7_,this.aPanel.s_0["bd_" + _loc2_].x,this.aPanel.s_0["bd_" + _loc2_].y);
               this.tbBoxArrcw[_loc2_] = _loc8_;
               this.aPanel.s_0.addChild(_loc8_);
            }
            _loc2_++;
         }
         var _loc3_:MovieClip = new _loc1_();
         _loc3_.name = "gg_0";
         this.sjg = new GoodsBtnX(_loc3_,this.aPanel.jy_mc.gxxx.x,this.aPanel.jy_mc.gxxx.y);
         this.aPanel.jy_mc.addChild(this.sjg);
         this.czBtn = SameChangeBtnX.createSameChangeBtn(new Array(this.aPanel.s_0.cz_0));
         this.czBtn.type = GS.a1;
         this.aPanel.s_0.addChild(this.czBtn);
         this.jcBtn = SameChangeBtnX.createSameChangeBtn(new Array(this.aPanel.s_0.sb_0,this.aPanel.s_0.sb_1));
         this.aPanel.s_0.addChild(this.jcBtn);
         this.sjBtn = new ClickBtnX(this.aPanel.s_0.sj_btn,this.aPanel.s_0.sj_btn.x,this.aPanel.s_0.sj_btn.y);
         this.aPanel.s_0.addChild(this.sjBtn);
         this.fsBtnx = new ClickBtnX(this.aPanel.s_0.fsBtn_0,this.aPanel.s_0.fsBtn_0.x,this.aPanel.s_0.fsBtn_0.y);
         this.aPanel.s_0.addChild(this.fsBtnx);
         var _loc4_:ClickBtnX = new ClickBtnX(this.aPanel.s_0.xxxmcc_0,this.aPanel.s_0.xxxmcc_0.x,this.aPanel.s_0.xxxmcc_0.y);
         _loc4_.buttonMode = false;
         this.aPanel.s_0.addChild(_loc4_);
         var _loc5_:uint = 0;
         while(_loc5_ < 2)
         {
            _loc9_ = new ClickBtnX(this.aPanel.ts_mc["ok_" + _loc5_],this.aPanel.ts_mc["ok_" + _loc5_].x,this.aPanel.ts_mc["ok_" + _loc5_].y);
            this.aPanel.ts_mc.addChild(_loc9_);
            _loc5_++;
         }
         this.upMc.addChild(this.aPanel.ts_mc);
         _loc5_ = 0;
         while(_loc5_ < 2)
         {
            _loc10_ = new ClickBtnX(this.aPanel.jy_mc["jys_" + _loc5_],this.aPanel.jy_mc["jys_" + _loc5_].x,this.aPanel.jy_mc["jys_" + _loc5_].y);
            this.aPanel.jy_mc.addChild(_loc10_);
            _loc11_ = new ClickBtnX(this.aPanel.jy_mc["jyjt_" + _loc5_],this.aPanel.jy_mc["jyjt_" + _loc5_].x,this.aPanel.jy_mc["jyjt_" + _loc5_].y);
            this.aPanel.jy_mc.addChild(_loc11_);
            _loc12_ = new ClickBtnX(this.aPanel.fqTs["fq_" + _loc5_],this.aPanel.fqTs["fq_" + _loc5_].x,this.aPanel.fqTs["fq_" + _loc5_].y);
            this.aPanel.fqTs.addChild(_loc12_);
            _loc5_++;
         }
         this.upMc.addChild(this.aPanel.jy_mc);
         this.upMc.addChild(this.aPanel.jnts);
         this.upMc.addChild(this.aPanel.fqTs);
         (this.aPanel.jnts as MovieClip).mouseChildren = false;
         (this.aPanel.jnts as MovieClip).mouseEnabled = false;
         var _loc6_:MovieClip = this.aPanel.s_0;
         _loc6_.cw_name.embedFonts = true;
         _loc6_.cw_name.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
         _loc6_.cw_lv.embedFonts = true;
         _loc6_.cw_lv.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
         _loc6_.xl_text.embedFonts = true;
         _loc6_.xl_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
         _loc6_.jd_text.embedFonts = true;
         _loc6_.jd_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
         _loc6_.a_text.embedFonts = true;
         _loc6_.a_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc6_.b_text.embedFonts = true;
         _loc6_.b_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc6_.c_text.embedFonts = true;
         _loc6_.c_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc6_.d_text.embedFonts = true;
         _loc6_.d_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc6_.e_text.embedFonts = true;
         _loc6_.e_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc6_.f_text.embedFonts = true;
         _loc6_.f_text.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         _loc6_.cz_0.cztext.embedFonts = true;
         _loc6_.cz_0.cztext.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
      }
      
      private function state1Fun() : void
      {
         this.rhBtn = new ClickBtnX(this.aPanel.s_1["rh_" + 0],this.aPanel.s_1["rh_" + 0].x,this.aPanel.s_1["rh_" + 0].y);
         this.aPanel.s_1.addChild(this.rhBtn);
         this.jhBtn = new ClickBtnX(this.aPanel.s_1["rh_" + 1],this.aPanel.s_1["rh_" + 1].x,this.aPanel.s_1["rh_" + 1].y);
         this.aPanel.s_1.addChild(this.jhBtn);
         var _loc1_:MovieClip = this.aPanel.rhtk_mc;
         this.rxBtn = SameChangeBtnX.createSameChangeBtn(new Array(new MovieClip(),_loc1_.rhxz_1,_loc1_.rhxz_2,_loc1_.rhxz_3,_loc1_.rhxz_4,_loc1_.rhxz_5,_loc1_.rhxz_6,_loc1_.rhxz_7,_loc1_.rhxz_8,_loc1_.rhxz_9,_loc1_.rhxz_10,_loc1_.rhxz_11,_loc1_.rhxz_12));
         this.aPanel.rhtk_mc.addChild(this.rxBtn);
         this.upMc.addChild(this.aPanel.rhtk_mc);
         var _loc2_:CloseBtnX = new CloseBtnX(_loc1_.rhclose_btn,_loc1_.rhclose_btn.x,_loc1_.rhclose_btn.y);
         _loc1_.addChild(_loc2_);
         this.rhsBtn = new ClickBtnX(_loc1_.resure_0,_loc1_.resure_0.x,_loc1_.resure_0.y);
         _loc1_.addChild(this.rhsBtn);
         this.aPanel.s_1.rhlv_tx.embedFonts = true;
         this.aPanel.s_1.rhlv_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         this.aPanel.s_1.rhlv_exp.embedFonts = true;
         this.aPanel.s_1.rhlv_exp.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         this.aPanel.s_1.rh_sm.embedFonts = true;
         this.aPanel.s_1.rh_sm.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
      }
      
      private function state2Fun() : void
      {
         var _loc5_:GoodsBtnX = null;
         var _loc6_:GoodsBtnX = null;
         var _loc7_:ClickBtnX = null;
         var _loc8_:ClickBtnX = null;
         var _loc1_:MovieClip = this.aPanel.s_2;
         var _loc2_:uint = 0;
         while(_loc2_ < 21)
         {
            _loc5_ = new GoodsBtnX(_loc1_["j_" + _loc2_],_loc1_["j_" + _loc2_].x,_loc1_["j_" + _loc2_].y);
            _loc1_.addChild(_loc5_);
            this.jnArr.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc6_ = new GoodsBtnX(_loc1_["zj_" + _loc2_],_loc1_["zj_" + _loc2_].x,_loc1_["zj_" + _loc2_].y);
            _loc1_.addChild(_loc6_);
            this.zbjnArr.push(_loc6_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc7_ = new ClickBtnX(_loc1_["lw_" + _loc2_],_loc1_["lw_" + _loc2_].x,_loc1_["lw_" + _loc2_].y);
            this.jblwBtnArr.push(_loc7_);
            _loc1_.addChild(_loc7_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            _loc8_ = new ClickBtnX(_loc1_["xzlw_" + _loc2_],_loc1_["xzlw_" + _loc2_].x,_loc1_["xzlw_" + _loc2_].y);
            this.djlwBtnArr.push(_loc8_);
            _loc1_.addChild(_loc8_);
            _loc2_++;
         }
         var _loc3_:ClickBtnX = new ClickBtnX(_loc1_.allxs_0,_loc1_.allxs_0.x,_loc1_.allxs_0.y);
         _loc1_.addChild(_loc3_);
         this.aPanel.addChild(this.aPanel.moveMc);
         var _loc4_:ClickBtnX = new ClickBtnX(_loc1_.ltbtn_0,_loc1_.ltbtn_0.x,_loc1_.ltbtn_0.y);
         _loc1_.addChild(_loc4_);
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            this.aPanel["cwlan_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.aPanel.ts_mc.visible = false;
         this.czingMc.visible = false;
         this.czMc.visible = false;
         this.aPanel.jy_mc.visible = false;
         this.aPanel.rhtk_mc.visible = false;
         this.aPanel.jnts.visible = false;
         this.aPanel.jnhc_mc.visible = false;
         this.cdMc.visible = false;
         this.aPanel.cwxzlwts.visible = false;
         this.aPanel.xzlwtsxx.visible = false;
         this.aPanel.openTs.visible = false;
         this.aPanel.fqTs.visible = false;
         this.pox.setValue(-1);
         this.initState0();
         this.initState1();
         this.initState2();
      }
      
      private function initState0() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.tbBoxArrcw.length)
         {
            if(this.tbBoxArrcw[_loc1_] != null)
            {
               (this.tbBoxArrcw[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.tbBoxArrcw[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               (this.tbBoxArrcw[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.tbBoxArrcw[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               this.aPanel.s_0["tx_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
         (this.sjg as GoodsBtnX).getSmMc().t_txt.text = "";
         (this.sjg as GoodsBtnX).getSmMc().gotoAndStop(1);
         (this.sjg as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
         (this.sjg as GoodsBtnX).getSmMc().gx_mc.visible = false;
         this.aPanel.s_0.cw_name.text = "";
         this.aPanel.s_0.cw_lv.text = "";
         this.aPanel.s_0.cwmx.gotoAndStop(1);
         this.aPanel.s_0.type_mc.gotoAndStop(1);
         this.aPanel.s_0.xxMc.gotoAndStop(1);
         this.aPanel.s_0.a_text.text = "";
         this.aPanel.s_0.b_text.text = "";
         this.aPanel.s_0.c_text.text = "";
         this.aPanel.s_0.d_text.text = "";
         this.aPanel.s_0.e_text.text = "";
         this.aPanel.s_0.f_text.text = "";
         this.aPanel.s_0.xl_text.text = "";
         this.aPanel.s_0.jd_text.text = "";
         this.aPanel.s_0.exp_tx.text = "";
         this.czBtn.closeOrOpenBtnById(0,0);
         this.aPanel.s_0.cz_0.cztext.text = "出战";
         this.sjBtn.okBtn = false;
         this.fsBtnx.okBtn = false;
         (this.aPanel.s_0.jytmc.jyt as MovieClip).width = GS.a0;
      }
      
      private function initState1() : void
      {
         var _loc1_:MovieClip = this.aPanel.s_1;
         _loc1_.s1mx_0.gotoAndStop(1);
         _loc1_.s1mx_1.gotoAndStop(1);
         _loc1_.s1mc.gotoAndStop(1);
         _loc1_.rhlv_tx.text = "";
         _loc1_.rhlv_exp.text = "";
         _loc1_.rh_sm.text = "";
         this.rhBtn.okBtn = false;
         this.jhBtn.okBtn = false;
      }
      
      private function initState2() : void
      {
         var _loc1_:MovieClip = this.aPanel.s_2;
         var _loc2_:uint = 0;
         while(_loc2_ < 16)
         {
            _loc1_["jnd_" + _loc2_].visible = false;
            (this.jnArr[_loc2_] as GoodsBtnX).visible = false;
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().tx_0.text = "";
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().tx_1.text = "";
            _loc2_++;
         }
         _loc2_ = 16;
         while(_loc2_ < 21)
         {
            (this.jnArr[_loc2_] as GoodsBtnX).visible = true;
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(2);
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().tx_0.text = "";
            (this.jnArr[_loc2_] as GoodsBtnX).getSmMc().tx_1.text = "";
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            (this.zbjnArr[_loc2_] as GoodsBtnX).visible = true;
            (this.zbjnArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.zbjnArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.zbjnArr[_loc2_] as GoodsBtnX).getSmMc().tx_0.text = "";
            (this.zbjnArr[_loc2_] as GoodsBtnX).getSmMc().tx_1.text = "";
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            (this.jblwBtnArr[_loc2_] as ClickBtnX).okBtn = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            (this.djlwBtnArr[_loc2_] as ClickBtnX).okBtn = false;
            _loc2_++;
         }
         _loc1_.allxs_0.visible = true;
         this.aPanel.moveMc.visible = false;
      }
      
      private function textFormatFun() : void
      {
         var _loc2_:TextFormat = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new TextFormat();
            switch(_loc1_)
            {
               case 0:
                  _loc2_.color = "0xffffff";
                  break;
               case 1:
                  _loc2_.color = "0x0066ff";
                  break;
               case 2:
                  _loc2_.color = "0xFF33FF";
                  break;
               case 3:
                  _loc2_.color = "0xffcc00";
            }
            this.tfArr.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function isPetById() : PetR
      {
         if(this.cwMsg.getPetEggById(this.cuCwId.getValue()) is PetR)
         {
            return this.cwMsg.getPetById(this.cuCwId.getValue());
         }
         return null;
      }
   }
}

