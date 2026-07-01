package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.unionVip.*;
   
   public class UnionPanel extends MovieClip
   {
      
      private static var _instance:UnionPanel;
      
      private static var cbx:Number = -1;
      
      private var uMc:MovieClip;
      
      private var cyBtn:SameChangeBtnX;
      
      private var ye:VT = VT.createVT(GS.a1);
      
      private var cuId:VT = VT.createVT(GS.a0);
      
      private var data:UnionPanelData;
      
      private var sqBtn:SameChangeBtnX;
      
      private var sqYe:VT = VT.createVT(GS.a1);
      
      private var sqCuId:VT = VT.createVT(GS.a0);
      
      private var cyBo:Boolean = false;
      
      private var xxBo:Boolean = false;
      
      private var stateSm:VT = VT.createVT(GS.a1);
      
      public function UnionPanel()
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
               _loc1_.push("unionpanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadUnionOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initUnion();
      }
      
      public static function close() : void
      {
         cbx = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance.removeEvent();
            _instance.visible = false;
            _instance.cyBo = false;
            _instance.xxBo = false;
         }
      }
      
      private static function loadUnionOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:CloseBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:ClickBtnX = null;
         var _loc8_:ClickBtnX = null;
         var _loc9_:ClickBtnX = null;
         var _loc10_:ClickBtnX = null;
         var _loc11_:ClickBtnX = null;
         var _loc12_:ClickBtnX = null;
         var _loc13_:ClickBtnX = null;
         var _loc14_:ClickBtnX = null;
         var _loc15_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new UnionPanel();
            _loc1_ = LoaderManager.getSwfClass("UnionMc") as Class;
            _instance.uMc = new _loc1_();
            _instance.addChild(_instance.uMc);
            _loc2_ = 0;
            while(_loc2_ <= 9)
            {
               _loc7_ = new ClickBtnX(_instance.uMc["b_" + _loc2_],_instance.uMc["b_" + _loc2_].x,_instance.uMc["b_" + _loc2_].y);
               _instance.uMc.addChild(_loc7_);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc8_ = new ClickBtnX(_instance.uMc["j_" + _loc2_],_instance.uMc["j_" + _loc2_].x,_instance.uMc["j_" + _loc2_].y);
               _instance.uMc.addChild(_loc8_);
               _loc2_++;
            }
            _loc3_ = _instance.uMc;
            _instance.cyBtn = SameChangeBtnX.createSameChangeBtn(new Array(_loc3_.c_0,_loc3_.c_1,_loc3_.c_2,_loc3_.c_3,_loc3_.c_4,_loc3_.c_5,_loc3_.c_6,_loc3_.c_7,_loc3_.c_8,_loc3_.c_9,_loc3_.c_10));
            _loc3_.addChild(_instance.cyBtn);
            _loc4_ = new CloseBtnX(_loc3_.close_btn,_loc3_.close_btn.x,_loc3_.close_btn.y);
            _loc3_.addChild(_loc4_);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc9_ = new ClickBtnX(_loc3_.tr_mc["trk_" + _loc2_],_loc3_.tr_mc["trk_" + _loc2_].x,_loc3_.tr_mc["trk_" + _loc2_].y);
               _loc3_.tr_mc.addChild(_loc9_);
               _loc2_++;
            }
            _loc3_.addChild(_loc3_.tr_mc);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc10_ = new ClickBtnX(_loc3_.tc_mc["tc_" + _loc2_],_loc3_.tc_mc["tc_" + _loc2_].x,_loc3_.tc_mc["tc_" + _loc2_].y);
               _loc3_.tc_mc.addChild(_loc10_);
               _loc2_++;
            }
            _loc3_.addChild(_loc3_.tc_mc);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc11_ = new ClickBtnX(_loc3_.js_mc["js_" + _loc2_],_loc3_.js_mc["js_" + _loc2_].x,_loc3_.js_mc["js_" + _loc2_].y);
               _loc3_.js_mc.addChild(_loc11_);
               _loc2_++;
            }
            _loc3_.addChild(_loc3_.js_mc);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc12_ = new ClickBtnX(_loc3_.gg_mc["gg_" + _loc2_],_loc3_.gg_mc["gg_" + _loc2_].x,_loc3_.gg_mc["gg_" + _loc2_].y);
               _loc3_.gg_mc.addChild(_loc12_);
               _loc2_++;
            }
            _loc3_.gg_mc.gg_tx.maxChars = GS.a100;
            _loc3_.gg_mc.gg_tx.autoSize = TextFieldAutoSize.LEFT;
            _loc3_.addChild(_loc3_.gg_mc);
            _instance.sqBtn = SameChangeBtnX.createSameChangeBtn(new Array(_loc3_.sq_mc.s_0,_loc3_.sq_mc.s_1,_loc3_.sq_mc.s_2,_loc3_.sq_mc.s_3,_loc3_.sq_mc.s_4,_loc3_.sq_mc.s_5));
            _loc3_.sq_mc.addChild(_instance.sqBtn);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc13_ = new ClickBtnX(_loc3_.sq_mc["sy_" + _loc2_],_loc3_.sq_mc["sy_" + _loc2_].x,_loc3_.sq_mc["sy_" + _loc2_].y);
               _loc3_.sq_mc.addChild(_loc13_);
               _loc14_ = new ClickBtnX(_loc3_.sq_mc["sj_" + _loc2_],_loc3_.sq_mc["sj_" + _loc2_].x,_loc3_.sq_mc["sj_" + _loc2_].y);
               _loc3_.sq_mc.addChild(_loc14_);
               _loc2_++;
            }
            _loc5_ = new CloseBtnX(_loc3_.sq_mc.sqclose_btn,_loc3_.sq_mc.sqclose_btn.x,_loc3_.sq_mc.sqclose_btn.y);
            _loc3_.sq_mc.addChild(_loc5_);
            _loc3_.addChild(_loc3_.sq_mc);
            _loc6_ = new CloseBtnX(_loc3_.gx_mc.gxclose_btn,_loc3_.gx_mc.gxclose_btn.x,_loc3_.gx_mc.gxclose_btn.y);
            _loc3_.gx_mc.addChild(_loc6_);
            _loc3_.addChild(_loc3_.gx_mc);
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               _loc15_ = new ClickBtnX(_loc3_["ts_" + _loc2_],_loc3_["ts_" + _loc2_].x,_loc3_["ts_" + _loc2_].y);
               _loc3_.addChild(_loc15_);
               _loc2_++;
            }
            _loc3_.addChild(_loc3_.tss_mc);
            _loc3_.u_name.embedFonts = true;
            _loc3_.u_name.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
            _loc3_.b_1.st_tx.embedFonts = true;
            _loc3_.b_1.st_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
            GM.bagJm.addChild(_instance);
            _instance.initUnion();
         }
      }
      
      private function initUnion() : void
      {
         this.data = GoodsManger.dataList.unionData;
         this.visible = false;
         this.xxBo = false;
         this.cyBo = false;
         this.addEvent();
         DataIngPanel.open("获取当前军团数据中");
         GM.testapi.getMyselfUnion();
      }
      
      private function unionHandle(param1:UnEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         DataIngPanel.close();
         this.data.setMyUnion(param1.obj);
         if(this.data.getMyUnion() != null)
         {
            if(this.xxBo == false)
            {
               if(FlowInterface.getJobByRole() == 1)
               {
                  _loc2_ = "绝影枪手";
               }
               else if(FlowInterface.getJobByRole() == 2)
               {
                  _loc2_ = "炎蓝炮手";
               }
               _loc3_ = FlowInterface.getLevelByRole() + "*" + GM.aSaveData.pksd.scoreb + "*" + _loc2_ + "*" + this.data.getXf();
               GM.testapi.changeChengYun(1,_loc3_,this.data.getMyUnion().getUnionId(),this.data.getMyUnion().getMyUid());
               DataIngPanel.open("获取军团成员数据中");
               GM.testapi.getUnionChengYun(this.data.getMyUnion().getUnionId());
               GM.testapi.getVarValue(this.data.getGbId());
            }
            else
            {
               this.initUnionJsTx();
            }
         }
         else
         {
            this.removeEvent();
            this.data.clearData();
            GoodsManger.cwTs("请到基地左侧寻找军团长•幻加入军团");
         }
      }
      
      private function getGGbLs(param1:UnEvent) : void
      {
         this.data.setGgBl(param1.obj as Array);
         GoodsManger.dataList.unShop.isChangeLevel(this.data.getGgBl(GS.a9));
      }
      
      private function cyHandle(param1:UnEvent) : void
      {
         DataIngPanel.close();
         this.data.setUnionCyList(param1.obj as Array);
         if(this.data.getUnionCyList().length > GS.a0)
         {
            if(this.cyBo == false)
            {
               DataIngPanel.open("获取军团数据中");
               GM.testapi.getGameUList(GS.a1,this.data.getUnionAllNum());
            }
            else
            {
               this.ye.setValue(GS.a1);
               this.cuId.setValue(GS.a0);
               this.initCyTx();
               this.isXsbtn();
            }
         }
      }
      
      private function allUnionHandle(param1:UnEvent) : void
      {
         var _loc2_:Number = NaN;
         DataIngPanel.close();
         this.data.setUnionList(param1.obj);
         if(this.data.getUnionList().length > GS.a0)
         {
            if(this.data.getMyUnion().isHz())
            {
               DataIngPanel.open("获取申请数据中");
               _loc2_ = Number(this.data.getAllSq());
               if(_loc2_ == 0)
               {
                  _loc2_ = 1;
               }
               GM.testapi.getUApplyList(GS.a1,_loc2_);
            }
            else
            {
               this.initPanel();
            }
         }
      }
      
      private function sqlist(param1:UnEvent) : void
      {
         DataIngPanel.close();
         this.data.setShList(param1.obj);
         this.initPanel();
      }
      
      private function outCy(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            GoodsManger.cwTs("成员移除成功");
            DataIngPanel.open("刷新成员数据");
            GM.testapi.getUnionChengYun(this.data.getMyUnion().getUnionId());
         }
      }
      
      private function outMy(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            GoodsManger.cwTs("退出军团成功");
            close();
         }
      }
      
      private function jsUnion(param1:UnEvent) : void
      {
         if(String(param1.obj) != null)
         {
            DataIngPanel.close();
            if(this.data.getMyUnion().getJsBo() == GS.a0)
            {
               this.data.setJs(GS.a1);
               GoodsManger.cwTs("军团将在三天后正式解散");
            }
            else if(this.data.getMyUnion().getJsBo() == GS.a1)
            {
               this.data.setJs(GS.a0);
               GoodsManger.cwTs("军团取消了解散");
            }
            this.btnState();
            FlowInterface.saveDataByKai();
         }
      }
      
      private function gongaotx(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            GoodsManger.cwTs("军团信息修改成功");
            DataIngPanel.open("军团公告刷新中");
            GM.testapi.getMyselfUnion();
         }
      }
      
      private function shState(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            GoodsManger.cwTs("审核信息已经处理");
         }
      }
      
      private function errorHandle(param1:UnEvent) : void
      {
         DataIngPanel.close();
         close();
         GoodsManger.cwTs(String(param1.obj));
      }
      
      private function initPanel() : void
      {
         this.cyBo = true;
         this.xxBo = true;
         this.visible = true;
         this.uMc.tr_mc.visible = false;
         this.uMc.tc_mc.visible = false;
         this.uMc.js_mc.visible = false;
         this.uMc.js_mc.gotoAndStop(GS.a1);
         this.uMc.gg_mc.visible = false;
         this.uMc.sq_mc.visible = false;
         this.uMc.gx_mc.visible = false;
         this.uMc.tss_mc.visible = false;
         this.ye.setValue(GS.a1);
         this.cuId.setValue(GS.a0);
         this.stateSm.setValue(GS.a1);
         this.initDisplay();
      }
      
      private function initDisplay() : void
      {
         this.initBasicText();
         this.initUnionJsTx();
         this.initCyTx();
         this.isXsbtn();
         this.btnState();
      }
      
      private function btnState() : void
      {
         if(this.data.getMyUnion().isHz())
         {
            this.data.getMyUnion().setJsBo(this.data.getIsJs());
            if(this.data.getMyUnion().getJsBo() == GS.a0)
            {
               this.uMc.b_1.st_tx.text = "解散军团";
            }
            else
            {
               this.uMc.b_1.st_tx.text = "取消解散";
            }
            this.uMc.b_3.visible = true;
            this.uMc.sqn_mc.visible = true;
            this.uMc.sqn_mc.sq_tx.text = String(this.data.getAllSq());
         }
         else
         {
            this.uMc.b_1.st_tx.text = "退出军团";
            this.uMc.b_3.visible = false;
            this.uMc.sqn_mc.visible = false;
         }
      }
      
      private function initBasicText() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc1_:MyUnion = this.data.getMyUnion();
         this.uMc.u_name.text = _loc1_.getUnionName();
         this.uMc.u_level.text = String(_loc1_.getUnionLevel());
         this.uMc.u_ex.text = String(_loc1_.getExperience());
         this.uMc.u_p.text = String(_loc1_.getPm());
         switch(_loc1_.getUnionLevel())
         {
            case 1:
               _loc2_ = 4000;
               break;
            case 2:
               _loc2_ = 16000;
               break;
            case 3:
               _loc2_ = 36000;
               break;
            case 4:
               _loc2_ = 72000;
               break;
            case 5:
               _loc2_ = 144000;
               break;
            case 6:
               _loc2_ = 288000;
               break;
            case 7:
               _loc2_ = 576000;
               break;
            case 8:
               _loc2_ = 1152000;
               break;
            case 9:
               _loc2_ = 2304000;
               break;
            case 10:
               _loc2_ = 4608000;
               break;
            case 11:
               _loc2_ = 9216000;
               break;
            case 12:
               _loc2_ = 18432000;
               break;
            case 13:
               _loc2_ = 36864000;
               break;
            case 14:
               _loc2_ = 73728000;
               break;
            case 15:
               _loc2_ = 147456000;
         }
         this.uMc.u_ex.text = String(_loc1_.getExperience() + "/" + _loc2_);
         switch(_loc1_.getUnionLevel())
         {
            case 1:
               _loc3_ = 10;
               break;
            case 2:
               _loc3_ = 13;
               break;
            case 3:
               _loc3_ = 16;
               break;
            case 4:
               _loc3_ = 19;
               break;
            case 5:
               _loc3_ = 22;
               break;
            case 6:
               _loc3_ = 25;
               break;
            case 7:
               _loc3_ = 28;
               break;
            case 8:
               _loc3_ = 31;
               break;
            case 9:
               _loc3_ = 34;
               break;
            case 10:
               _loc3_ = 37;
               break;
            case 11:
               _loc3_ = 40;
               break;
            case 12:
               _loc3_ = 43;
               break;
            case 13:
               _loc3_ = 46;
               break;
            case 14:
               _loc3_ = 49;
               break;
            case 15:
               _loc3_ = 50;
         }
         this.uMc.u_num.text = String(_loc1_.getRs()) + "/" + _loc3_;
         this.uMc.u_js.text = this.data.getShopJs() + "/" + this.data.getAlLJs();
         this.uMc.u_zj.text = String(this.data.getNowZj());
         this.uMc.my_name.text = _loc1_.getMyNickName();
         this.uMc.my_gx.text = this.data.getGxValue() + "/" + _loc1_.getMyContribution();
      }
      
      private function initUnionJsTx() : void
      {
         this.uMc.sm_tx.text = this.data.getMyUnion().getExtra();
      }
      
      private function initCyTx() : void
      {
         var _loc3_:UnioinCy = null;
         this.uMc.smx_mc.gotoAndStop(this.stateSm.getValue());
         var _loc1_:Array = this.data.getCurrCyList(this.ye.getValue());
         var _loc2_:uint = 0;
         while(_loc2_ < 11)
         {
            _loc3_ = _loc1_[_loc2_] as UnioinCy;
            this.uMc["c_" + _loc2_].visible = false;
            if(_loc3_ != null)
            {
               this.uMc["c_" + _loc2_].visible = true;
               if(this.stateSm.getValue() == GS.a1)
               {
                  this.uMc["c_" + _loc2_].n_tx.text = _loc3_.getNickName();
                  this.uMc["c_" + _loc2_].zw_tx.text = _loc3_.getZw();
                  this.uMc["c_" + _loc2_].lv_tx.text = String(_loc3_.getLv());
                  this.uMc["c_" + _loc2_].pm_tx.text = String(_loc3_.getJjFs());
                  this.uMc["c_" + _loc2_].gx_tx.text = String(_loc3_.getContribution());
                  this.uMc["c_" + _loc2_].t_tx.text = _loc3_.getJob();
               }
               else if(this.stateSm.getValue() == GS.a2)
               {
                  this.uMc["c_" + _loc2_].n_tx.text = _loc3_.getNickName();
                  this.uMc["c_" + _loc2_].zw_tx.text = String(_loc3_.getXf());
                  this.uMc["c_" + _loc2_].lv_tx.text = "";
                  this.uMc["c_" + _loc2_].pm_tx.text = "";
                  this.uMc["c_" + _loc2_].gx_tx.text = "";
                  this.uMc["c_" + _loc2_].t_tx.text = "";
               }
            }
            _loc2_++;
         }
         this.uMc.ye_tx.text = this.ye.getValue() + "/" + this.data.getAllYeCy();
      }
      
      private function initSQTx() : void
      {
         var _loc3_:UnionSq = null;
         var _loc1_:Array = this.data.getCurrSqList(this.sqYe.getValue());
         var _loc2_:uint = 0;
         while(_loc2_ < 6)
         {
            _loc3_ = _loc1_[_loc2_] as UnionSq;
            this.uMc.sq_mc["s_" + _loc2_].visible = false;
            if(_loc3_ != null)
            {
               this.uMc.sq_mc["s_" + _loc2_].visible = true;
               this.uMc.sq_mc["s_" + _loc2_].n_tx.text = _loc3_.getNickName();
               this.uMc.sq_mc["s_" + _loc2_].lv_tx.text = String(_loc3_.getLv());
               this.uMc.sq_mc["s_" + _loc2_].jj_tx.text = String(_loc3_.getJjFs());
               this.uMc.sq_mc["s_" + _loc2_].job_tx.text = _loc3_.getJob();
            }
            _loc2_++;
         }
         this.uMc.sq_mc.sn_tx.text = this.sqYe.getValue() + "/" + this.data.getAllYeSq();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:VT = null;
         var _loc3_:VT = null;
         var _loc4_:UnionSq = null;
         var _loc5_:VT = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         if(param1.name == "b")
         {
            if(param1.id == 0)
            {
               this.uMc.gx_mc.visible = true;
               this.uMc.gx_mc.sj_0.text = TaskData.jtTimes.getValue() * GS.a20 + "/" + "200";
               this.uMc.gx_mc.sj_1.text = this.data.getZjGx() * GS.a13 + "/" + "260";
               this.uMc.gx_mc.sj_2.text = this.data.getJSGx() * GS.a20 + "/" + "200";
            }
            else if(param1.id == 1)
            {
               if(this.data.getMyUnion().isHz())
               {
                  this.uMc.js_mc.visible = true;
                  if(this.data.getMyUnion().getJsBo() == GS.a0)
                  {
                     this.uMc.js_mc.gotoAndStop(1);
                  }
                  else if(this.data.getMyUnion().getJsBo() == GS.a1)
                  {
                     this.uMc.js_mc.gotoAndStop(2);
                  }
               }
               else
               {
                  this.uMc.tc_mc.visible = true;
               }
            }
            else if(param1.id == 2)
            {
               UnionSqPanel.open(GS.a1);
            }
            else if(param1.id == 3)
            {
               if(this.data.getSqList().length > GS.a0)
               {
                  this.uMc.sq_mc.visible = true;
                  this.sqCuId.setValue(GS.a0);
                  this.sqYe.setValue(GS.a1);
                  this.initSQTx();
                  this.isShbtn();
               }
               else
               {
                  GoodsManger.cwTs("还没玩家申请加入军团");
               }
            }
            else if(param1.id == 4)
            {
               _loc2_ = VT.createVT(this.cuId.getValue() - (this.ye.getValue() - 1) * 11);
               this.uMc.tr_mc.visible = true;
               this.uMc.tr_mc.n_tx.text = this.data.getCurrCy(_loc2_.getValue()).getUserName();
            }
            else if(param1.id == 5)
            {
               if(this.data.getMyUnion().isHz())
               {
                  this.uMc.gg_mc.visible = true;
               }
               else
               {
                  GoodsManger.cwTs("只有团长有权限");
               }
            }
            else if(param1.id == 6)
            {
               GM.levelm.changeLevelDataByIdAndLs(GS.a9997 - GS.a2,1);
            }
            else if(param1.id == 7)
            {
               UnionVip.open();
            }
            else if(param1.id == 8)
            {
               if(this.stateSm.getValue() == 1)
               {
                  this.stateSm.setValue(GS.a2);
               }
               else
               {
                  this.stateSm.setValue(GS.a1);
               }
               this.initCyTx();
            }
            else if(param1.id == 9)
            {
               UnionZpanel.open();
            }
         }
         else if(param1.name == "sy")
         {
            DataIngPanel.open("数据处理中");
            _loc3_ = VT.createVT(this.sqCuId.getValue() - (this.sqYe.getValue() - 1) * 6);
            _loc4_ = this.data.getSqCyByKey(_loc3_.getValue());
            if(param1.id == 0)
            {
               GM.testapi.auditChengYun(_loc4_.getUid(),_loc4_.getIndex(),GS.a1);
            }
            else if(param1.id == 1)
            {
               GM.testapi.auditChengYun(_loc4_.getUid(),_loc4_.getIndex(),GS.a0);
            }
         }
         else if(param1.name == "trk")
         {
            if(param1.id == 0)
            {
               DataIngPanel.open("数据处理中");
               _loc5_ = VT.createVT(this.cuId.getValue() - (this.ye.getValue() - 1) * 11);
               GM.testapi.delChengYun(this.data.getCurrCy(_loc5_.getValue()).getId(),this.data.getCurrCy(_loc5_.getValue()).getCd());
            }
            this.uMc.tr_mc.visible = false;
            this.uMc.tr_mc.n_tx.text = "";
         }
         else if(param1.name == "tc")
         {
            if(param1.id == 0)
            {
               DataIngPanel.open("数据处理中");
               GM.testapi.exitUnion();
            }
            this.uMc.tc_mc.visible = false;
         }
         else if(param1.name == "js")
         {
            if(param1.id == 0)
            {
               DataIngPanel.open("数据处理中");
               if(this.data.getMyUnion().getJsBo() == GS.a0)
               {
                  GM.testapi.dissolveCurUnion(GS.a1);
               }
               else if(this.data.getMyUnion().getJsBo() == GS.a1)
               {
                  GM.testapi.dissolveCurUnion(GS.a0);
               }
            }
            this.uMc.js_mc.visible = false;
         }
         else if(param1.name == "gg")
         {
            if(param1.id == 0)
            {
               DataIngPanel.open("数据处理中");
               _loc6_ = this.uMc.gg_mc.gg_tx.text;
               _loc7_ = String(this.data.getZj());
               _loc8_ = _loc6_ + "*" + _loc7_;
               GM.testapi.changeUnionExtra(GS.a1,_loc8_,this.data.getMyUnion().getUnionId());
            }
            this.uMc.gg_mc.visible = false;
         }
         else if(param1.name == "j")
         {
            if(param1.id == 0)
            {
               if(this.ye.getValue() > 1)
               {
                  this.ye.setValue(this.ye.getValue() - GS.a1);
               }
               else
               {
                  this.ye.setValue(this.data.getAllYeCy());
               }
            }
            else if(param1.id == 1)
            {
               if(this.ye.getValue() < this.data.getAllYeCy())
               {
                  this.ye.setValue(this.ye.getValue() + GS.a1);
               }
               else
               {
                  this.ye.setValue(GS.a1);
               }
            }
            this.initCyTx();
            this.isXsbtn();
         }
         else if(param1.name == "sj")
         {
            if(param1.id == 0)
            {
               if(this.sqYe.getValue() > 1)
               {
                  this.sqYe.setValue(this.sqYe.getValue() - GS.a1);
               }
               else
               {
                  this.sqYe.setValue(this.data.getAllYeSq());
               }
            }
            else if(param1.id == 1)
            {
               if(this.sqYe.getValue() < this.data.getAllYeSq())
               {
                  this.sqYe.setValue(this.sqYe.getValue() + GS.a1);
               }
               else
               {
                  this.sqYe.setValue(GS.a1);
               }
            }
            this.initSQTx();
            this.isShbtn();
         }
      }
      
      private function isXsbtn() : void
      {
         this.cyBtn.czArr();
         this.uMc.b_4.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 11)
         {
            if(this.cuId.getValue() == (this.ye.getValue() - 1) * 11 + _loc1_)
            {
               this.cyBtn.btnOk(_loc1_);
               if(Boolean(this.data.getMyUnion().isHz()) && this.data.getCurrCy(_loc1_).getZw() != "团长")
               {
                  this.uMc.b_4.visible = true;
                  this.uMc.b_4.y = this.uMc["c_" + _loc1_].y;
               }
               break;
            }
            _loc1_++;
         }
      }
      
      private function isShbtn() : void
      {
         this.sqBtn.czArr();
         this.uMc.sq_mc.sy_0.visible = false;
         this.uMc.sq_mc.sy_1.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 6)
         {
            if(this.sqCuId.getValue() == (this.sqYe.getValue() - 1) * 6 + _loc1_)
            {
               this.sqBtn.btnOk(_loc1_);
               this.uMc.sq_mc.sy_0.visible = true;
               this.uMc.sq_mc.sy_1.visible = true;
               this.uMc.sq_mc.sy_0.y = this.uMc.sq_mc["s_" + _loc1_].y;
               this.uMc.sq_mc.sy_1.y = this.uMc.sq_mc["s_" + _loc1_].y;
               break;
            }
            _loc1_++;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "c")
         {
            this.cuId.setValue(param1.id + (this.ye.getValue() - 1) * 11);
            this.isXsbtn();
         }
         else if(param1.name == "s")
         {
            this.sqCuId.setValue(param1.id + (this.sqYe.getValue() - 1) * 6);
            this.isShbtn();
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
         else if(param1.name == "sqclose")
         {
            this.uMc.sq_mc.visible = false;
         }
         else if(param1.name == "gxclose")
         {
            this.uMc.gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:String = null;
         if(param1.name == "ts")
         {
            this.uMc.tss_mc.visible = true;
            this.uMc.tss_mc.x = mouseX;
            this.uMc.tss_mc.y = mouseY;
            switch(param1.id)
            {
               case 0:
                  _loc2_ = "提升后可增加成员上限、获得开启更多的军团新功能" + "\n" + "军团加成" + "\n" + "人物经验加成=军团等级*1%" + "\n" + "宠物经验加成=军团等级*1%" + "\n" + "晶币获取加成=3%+军团等级*2%" + "\n" + "稀有物品掉落加成=50%+军团等级*10%。";
                  break;
               case 1:
                  _loc2_ = "每获得1点贡献点军团经验+1。";
                  break;
               case 2:
                  _loc2_ = "军团在整个游戏内的排名情况。";
                  break;
               case 3:
                  _loc2_ = "军团每升一级可增加3个成员上限";
                  break;
               case 4:
                  _loc2_ = "建设值越高，可以开放的军团新功能越多（进入军团营地寻找建设师霍雷增加建设值）。";
                  break;
               case 5:
                  _loc2_ = "整个军团的公用资金，主要用来升级、开放军团新功能（进入营地寻找军团长·幻募捐军团资金）。";
                  break;
               case 6:
                  _loc2_ = "用来升级军团技能、进入军团贡献点商店购买道具";
            }
            this.uMc.tss_mc.tsxx_ts.text = _loc2_;
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "ts")
         {
            this.uMc.tss_mc.visible = false;
         }
      }
      
      private function addEvent() : void
      {
         Main.self.addEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.addEventListener(UnEvent.LIST_UNION,this.allUnionHandle);
         Main.self.addEventListener(UnEvent.LIST_UNION_CY,this.cyHandle);
         Main.self.addEventListener(UnEvent.OUT_UNION_CY,this.outCy);
         Main.self.addEventListener(UnEvent.OUT_UNION_MY,this.outMy);
         Main.self.addEventListener(UnEvent.OUT_UNION_ALL,this.jsUnion);
         Main.self.addEventListener(UnEvent.GONGAO_TX,this.gongaotx);
         Main.self.addEventListener(UnEvent.SQ_LIST,this.sqlist);
         Main.self.addEventListener(UnEvent.SH_CY,this.shState);
         Main.self.addEventListener(UnEvent.GET_GG_BL,this.getGGbLs);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.removeEventListener(UnEvent.LIST_UNION,this.allUnionHandle);
         Main.self.removeEventListener(UnEvent.LIST_UNION_CY,this.cyHandle);
         Main.self.removeEventListener(UnEvent.OUT_UNION_CY,this.outCy);
         Main.self.removeEventListener(UnEvent.OUT_UNION_MY,this.outMy);
         Main.self.removeEventListener(UnEvent.OUT_UNION_ALL,this.jsUnion);
         Main.self.removeEventListener(UnEvent.GONGAO_TX,this.gongaotx);
         Main.self.removeEventListener(UnEvent.SQ_LIST,this.sqlist);
         Main.self.removeEventListener(UnEvent.SH_CY,this.shState);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbLs);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
      }
   }
}

