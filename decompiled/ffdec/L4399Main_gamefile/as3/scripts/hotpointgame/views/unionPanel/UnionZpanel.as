package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.unionVip.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class UnionZpanel extends MovieClip
   {
      
      private static var _instance:UnionZpanel;
      
      private static var cbx:Number = -1;
      
      private var uzMc:MovieClip;
      
      private var jtBtn:SameChangeBtnX;
      
      private var jdata:UnionPanelData;
      
      private var tbArr:Array = [];
      
      private var okbtnArr:Array = [];
      
      private var lqbtnx:ClickBtnX;
      
      private var keyID:Number = 0;
      
      private var listKeyID:Number = 0;
      
      private var tjKeyId:Number = 0;
      
      private var jdid:VT = VT.createVT(GS.a0);
      
      private var nameArr:Array = ["天龙座","英仙座","小熊座","仙王座","摩羯座","大熊座","猎户座"];
      
      private var ggblType:VT = VT.createVT(GS.a0);
      
      private var _sxDisplay:SxPanel;
      
      public function UnionZpanel()
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
               _loc1_.push("jtzPanel");
               _loc1_.push("t_box");
               _loc1_.push("sxpanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadUnionjtOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPhData();
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
      
      private static function loadUnionjtOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:CloseBtnX = null;
         var _loc5_:Object = null;
         var _loc6_:ClickBtnX = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new UnionZpanel();
            _loc1_ = LoaderManager.getSwfClass("Jtz_mc") as Class;
            _instance.uzMc = new _loc1_();
            _instance.addChild(_instance.uzMc);
            _loc2_ = _instance.uzMc;
            _instance.jtBtn = SameChangeBtnX.createSameChangeBtn(new Array(_loc2_.b_0,_loc2_.b_1,_loc2_.b_2,_loc2_.b_3,_loc2_.b_4,_loc2_.b_5,_loc2_.b_6));
            _loc2_.addChild(_instance.jtBtn);
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc6_ = new ClickBtnX(_loc2_["ok_" + _loc3_],_loc2_["ok_" + _loc3_].x,_loc2_["ok_" + _loc3_].y);
               _loc2_.addChild(_loc6_);
               _instance.okbtnArr.push(_loc6_);
               _loc3_++;
            }
            _instance.lqbtnx = new ClickBtnX(_loc2_.lq_btn,_loc2_.lq_btn.x,_loc2_.lq_btn.y);
            _loc2_.addChild(_instance.lqbtnx);
            _loc4_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc4_);
            _loc5_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 8)
            {
               _loc7_ = new _loc5_();
               _loc7_.name = "jtz_" + _loc3_;
               _loc8_ = new GoodsBtnX(_loc7_,_loc2_["tb_" + _loc3_].x,_loc2_["tb_" + _loc3_].y);
               _instance.tbArr.push(_loc8_);
               _loc2_.addChild(_loc8_);
               _loc3_++;
            }
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPhData();
         }
      }
      
      private function addEven() : void
      {
         Main.self.addEventListener(AttEvent.UNTION_THREE,this.listHandle);
         Main.self.addEventListener(AttEvent.TJ_UNTION_FS,this.okHandle);
         Main.self.addEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.addEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.error);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
      }
      
      private function error(param1:UnEvent) : void
      {
         GoodsManger.cwTs(String(param1.obj));
         DataIngPanel.close();
      }
      
      private function initPhData() : void
      {
         this.jdata = GoodsManger.dataList.unionData;
         this.visible = false;
         this.addEven();
         DataIngPanel.open("获取军团战况");
         this.listKeyID = GS.a0;
         GM.testapi.getGFRankListData(this.jdata.getPhbId(this.listKeyID));
      }
      
      private function okHandle(param1:AttEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            if(this.tjKeyId == 0)
            {
               this.tjKeyId = 1;
               this.jdata.tjPhb(4,6);
            }
            else if(this.tjKeyId == 1)
            {
               DataIngPanel.close();
               GoodsManger.cwTs("据点积分提交完成,重新打开面板刷新排行");
            }
         }
      }
      
      private function listHandle(param1:AttEvent) : void
      {
         if(this.listKeyID < GS.a6)
         {
            this.jdata.setJtzList(param1.obj as Array,this.listKeyID);
            ++this.listKeyID;
            GM.testapi.getGFRankListData(this.jdata.getPhbId(this.listKeyID));
         }
         else
         {
            this.jdata.setJtzList(param1.obj as Array,GS.a6);
            DataIngPanel.close();
            this.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.uzMc.addChild(this._sxDisplay);
         this.visible = true;
         this.jdid.setValue(GS.a0);
         this.jtBtn.btnOk(0);
         this.initDisplay();
      }
      
      private function textFun() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:GhzData = null;
         this.uzMc.name_tx.text = this.nameArr[this.jdid.getValue()];
         if(this.jdata.getjtzArr(this.jdid.getValue()) != null)
         {
            _loc1_ = this.jdata.getjtzArr(this.jdid.getValue());
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc3_ = _loc1_[_loc2_] as GhzData;
               if(_loc3_ != null)
               {
                  this.uzMc["pm_" + _loc2_].text = String(_loc3_.getRank() + "." + _loc3_.getUnName() + ":" + _loc3_.getScore());
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               this.uzMc["pm_" + _loc2_].text = "";
               _loc2_++;
            }
         }
         if(this.jdata.getMyPmData(this.jdid.getValue()) != null)
         {
            this.uzMc.mypm_tx.text = this.jdata.getMyPmData(this.jdid.getValue()).getScore().toString();
         }
         else
         {
            this.uzMc.mypm_tx.text = "积分太小";
         }
         this.uzMc.cx_tx.text = this.jdata.getJdCs(this.jdid.getValue()).toString();
      }
      
      private function openBtn() : void
      {
         if(this.jdata.getMyUnion().isHz())
         {
            this.uzMc.ok_0.visible = true;
            this.uzMc.ok_2.visible = true;
            if(this.jdata.getJtzJgTime())
            {
               if(this.jdata.getJdOpen(this.jdid.getValue()) == GS.a1)
               {
                  (this.okbtnArr[0] as ClickBtnX).okBtn = true;
               }
               else
               {
                  (this.okbtnArr[0] as ClickBtnX).okBtn = false;
               }
            }
            else
            {
               (this.okbtnArr[0] as ClickBtnX).okBtn = false;
            }
            if(this.jdata.getJtzJgTime())
            {
               (this.okbtnArr[2] as ClickBtnX).okBtn = true;
            }
            else
            {
               (this.okbtnArr[2] as ClickBtnX).okBtn = false;
            }
         }
         else
         {
            this.uzMc.ok_0.visible = false;
            this.uzMc.ok_2.visible = false;
         }
         if(this.jdata.getJtzJgTime())
         {
            (this.okbtnArr[1] as ClickBtnX).okBtn = true;
         }
         else
         {
            (this.okbtnArr[1] as ClickBtnX).okBtn = false;
         }
      }
      
      private function lqbtn() : void
      {
      }
      
      private function jgXs() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            if(this.jdata.getJdOpen(_loc1_) == GS.a1)
            {
               this.uzMc["xs_" + _loc1_].text = "";
            }
            else if(this.jdata.getJdOpen(_loc1_) == GS.a0)
            {
               this.uzMc["xs_" + _loc1_].text = "已开启";
            }
            _loc1_++;
         }
      }
      
      private function initDisplay() : void
      {
         this.textFun();
         this.openBtn();
         this.lqbtn();
         this.jgXs();
         this.initFrame();
      }
      
      private function initFrame() : void
      {
         this.initmc();
         var _loc1_:UnionJtzData = UnionVipFactory.getjtzjl(this.jdid.getValue());
         var _loc2_:Array = _loc1_.getGoodsId();
         var _loc3_:Array = _loc1_.getGoodsNum();
         var _loc4_:uint = 0;
         while(_loc4_ < 8)
         {
            if(_loc2_[_loc4_] != null)
            {
               (this.tbArr[_loc4_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc2_[_loc4_]).getFrame());
               (this.tbArr[_loc4_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:GhzData = null;
         var _loc3_:UnionJtzData = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(param1.name == "ok")
         {
            if(param1.id == 0 && Boolean(this.jdata.getMyUnion().isHz()))
            {
               if(this.jdata.getJdOpen(this.jdid.getValue()) == GS.a1)
               {
                  if(this.jdata.getNowZj() >= GS.a500 * GS.a1000)
                  {
                     this.ggblType.setValue(GS.a0);
                     DataIngPanel.open("据点开启中");
                     GM.testapi.changeVarValue(this.jdata.getkqiD(this.jdid.getValue()));
                  }
                  else
                  {
                     GoodsManger.cwTs("资金不足");
                  }
               }
            }
            else if(param1.id == 1)
            {
               if(this.jdata.getOVERcs() < GS.a2)
               {
                  if(this.jdata.getJdOpen(this.jdid.getValue()) == GS.a0)
                  {
                     if(this.jdata.getJdCs(this.jdid.getValue()) > GS.a0)
                     {
                        DataIngPanel.open("查询本人进攻次数");
                        this.ggblType.setValue(GS.a1);
                        GM.testapi.changeVarValue(this.jdata.getOverCsId(this.jdid.getValue()));
                     }
                     else
                     {
                        GoodsManger.cwTs("军团进攻次数已经到达上限");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("未开启");
                  }
               }
               else
               {
                  GoodsManger.cwTs("本周进攻次数已经上限");
               }
            }
            else if(param1.id == 2)
            {
               if(this.jdata.getJtzJgTime())
               {
                  DataIngPanel.open("提交据点积分");
                  this.tjKeyId = 0;
                  this.jdata.tjPhb(0,3);
               }
            }
         }
         else if(param1.name == "lq")
         {
            _loc2_ = this.jdata.getMyPmData(this.jdid.getValue());
            if(!this.jdata.getJtzJgTime())
            {
               if(this.jdata.getNbOne(this.jdid.getValue()))
               {
                  if(this.jdata.getJtLq(this.jdid.getValue()) == GS.a0)
                  {
                     _loc3_ = UnionVipFactory.getjtzjl(this.jdid.getValue());
                     _loc4_ = _loc3_.getGoodsId();
                     _loc5_ = _loc3_.getGoodsNum();
                     if(BagFactory.isFullBag(_loc4_,_loc5_))
                     {
                        this.jdata.setJtLq(this.jdid.getValue(),GS.a1);
                        BagFactory.addBagArr(_loc4_,_loc5_);
                        this.initDisplay();
                     }
                     else
                     {
                        GoodsManger.cwTs("背包已满");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("已领取");
                  }
               }
               else
               {
                  GoodsManger.cwTs("第一名才能领取");
               }
            }
            else
            {
               GoodsManger.cwTs("星期天才能领奖励");
            }
         }
      }
      
      private function setGblHandle(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            if(this.ggblType.getValue() == GS.a0)
            {
               this.jdata.addXhZJ(GS.a500 * GS.a1000);
               GM.testapi.getVarValue(this.jdata.getGbId());
            }
            else if(this.ggblType.getValue() == GS.a1)
            {
               DataIngPanel.close();
               this.jdata.addOverCs();
               GM.levelm.changeLevelDataByIdAndLs(this.jdata.gotoGk(this.jdid.getValue()),1);
               close();
            }
         }
      }
      
      private function getGGbL(param1:UnEvent) : void
      {
         DataIngPanel.close();
         this.jdata.setGgBl(param1.obj as Array);
         this.initDisplay();
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         this.jdid.setValue(param1.id);
         this.initDisplay();
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:UnionJtzData = null;
         var _loc3_:Array = null;
         if(param1.name == "jtz")
         {
            _loc2_ = UnionVipFactory.getjtzjl(this.jdid.getValue());
            _loc3_ = _loc2_.getGoodsId();
            if(_loc3_[param1.id] != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,GoodsFactory.createGoodsById(_loc3_[param1.id])));
            }
         }
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(AttEvent.UNTION_THREE,this.listHandle);
         Main.self.removeEventListener(AttEvent.TJ_UNTION_FS,this.okHandle);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.removeEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.error);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
      }
      
      private function initmc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 8)
         {
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc1_++;
         }
      }
   }
}

