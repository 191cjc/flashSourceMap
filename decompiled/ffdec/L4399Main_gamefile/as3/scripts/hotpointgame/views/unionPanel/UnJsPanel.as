package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.unionVip.*;
   import hotpointgame.utils.gameloader.*;
   
   public class UnJsPanel extends MovieClip
   {
      
      private static var _instance:UnJsPanel;
      
      private static var cbx:Number = -1;
      
      private var jsMc:MovieClip;
      
      private var state:VT = VT.createVT(GS.a0);
      
      private var smState:VT = VT.createVT(GS.a0);
      
      private var xtArr:Array = [];
      
      private var data:UnionPanelData;
      
      private var npcBtn:SameChangeBtnX;
      
      public function UnJsPanel()
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
               _loc1_.push("unjsPanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadJsOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initJs();
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
      
      private static function loadJsOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:ClickBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new UnJsPanel();
            _loc1_ = LoaderManager.getSwfClass("JsMc") as Class;
            _instance.jsMc = new _loc1_();
            _instance.addChild(_instance.jsMc);
            _loc2_ = _instance.jsMc;
            _instance.npcBtn = SameChangeBtnX.createSameChangeBtn([_loc2_.b_0,_loc2_.b_1,_loc2_.b_2,_loc2_.b_3]);
            _loc2_.addChild(_instance.npcBtn);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc6_ = new GoodsBtnX(_loc2_["t_" + _loc3_],_loc2_["t_" + _loc3_].x,_loc2_["t_" + _loc3_].y);
               _loc2_.addChild(_loc6_);
               _instance.xtArr.push(_loc6_);
               _loc3_++;
            }
            _loc4_ = new ClickBtnX(_loc2_.sj_btn,_loc2_.sj_btn.x,_loc2_.sj_btn.y);
            _loc2_.addChild(_loc4_);
            _loc5_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc5_);
            GM.bagJm.addChild(_instance);
            _instance.initJs();
         }
      }
      
      private function initJs() : void
      {
         this.data = GoodsManger.dataList.unionData;
         this.visible = false;
         this.addEvent();
         DataIngPanel.open("获取当前军团数据中");
         GM.testapi.getMyselfUnion();
      }
      
      private function unionHandle(param1:UnEvent) : void
      {
         GoodsManger.dataList.unionData.setMyUnion(param1.obj);
         if(this.data.getMyUnion() != null)
         {
            GM.testapi.getVarValue(this.data.getGbId());
         }
         else
         {
            DataIngPanel.close();
            close();
         }
      }
      
      private function getGGbL(param1:UnEvent) : void
      {
         GoodsManger.dataList.unionData.setGgBl(param1.obj as Array);
         GoodsManger.dataList.unShop.isChangeLevel(GoodsManger.dataList.unionData.getGgBl(GS.a9));
         DataIngPanel.close();
         this.initPanel();
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.state.setValue(GS.a0);
         this.smState.setValue(GS.a0);
         this.npcBtn.btnOk(GS.a0);
         this.initFrame();
         this.initText();
      }
      
      private function error(param1:UnEvent) : void
      {
         GoodsManger.cwTs(String(param1.obj));
         DataIngPanel.close();
         close();
      }
      
      private function addEvent() : void
      {
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.addEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.addEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.addEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "t")
         {
            if(param1.id != this.smState.getValue())
            {
               (this.xtArr[param1.id] as GoodsBtnX).getSmMc().gxMc.visible = false;
            }
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         if(param1.name == "t")
         {
            (this.xtArr[param1.id] as GoodsBtnX).getSmMc().gxMc.visible = true;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "b")
         {
            this.state.setValue(param1.id);
            this.smState.setValue(GS.a0);
            this.initFrame();
            this.initText();
         }
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.removeEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.removeEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function getLv(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(this.state.getValue() == GS.a0)
         {
            if(param1 == 0)
            {
               _loc2_.setValue(GoodsManger.dataList.unShop.getLevel());
            }
         }
         return _loc2_.getValue();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:UnionJsData = null;
         if(param1.name == "t")
         {
            this.smState.setValue(param1.id);
            this.initFrame();
            this.initText();
            (this.xtArr[param1.id] as GoodsBtnX).getSmMc().gxMc.visible = true;
         }
         else if(param1.name == "sj")
         {
            if(this.data.getMyUnion().isHz())
            {
               _loc2_ = UnionVipFactory.getDataByNpcAndXt(this.state.getValue(),this.smState.getValue(),this.getLv(this.smState.getValue()));
               if(_loc2_ != null)
               {
                  if(this.getLv(this.smState.getValue()) < UnionVipFactory.getDataNumByNpcAndXt(this.state.getValue(),this.smState.getValue()))
                  {
                     if(_loc2_.getNzj() <= this.data.getNowZj())
                     {
                        if(_loc2_.getNjs() <= this.data.getSyJs())
                        {
                           if(_loc2_.getNlv() <= this.data.getMyUnion().getUnionLevel())
                           {
                              if(this.state.getValue() == GS.a0)
                              {
                                 if(this.smState.getValue() == GS.a0)
                                 {
                                    DataIngPanel.open();
                                    GM.testapi.changeVarValue(GS.a9);
                                 }
                              }
                           }
                           else
                           {
                              GoodsManger.cwTs("军团等级不足");
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("军团建设不足");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("军团资金不足");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("系统等级已满");
                  }
               }
            }
            else
            {
               GoodsManger.cwTs("你的职位太低了，现在只有团长才能使用");
            }
         }
      }
      
      private function setGblHandle(param1:UnEvent) : void
      {
         var _loc2_:UnionJsData = null;
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            _loc2_ = UnionVipFactory.getDataByNpcAndXt(this.state.getValue(),this.smState.getValue(),this.getLv(this.smState.getValue()));
            if(this.state.getValue() == GS.a0 && this.smState.getValue() == GS.a0)
            {
               this.data.addXhZJ(_loc2_.getNzj());
               GoodsManger.cwTs("军团商店等级提升了");
            }
            DataIngPanel.open();
            GM.testapi.getVarValue(this.data.getGbId());
         }
      }
      
      private function initText() : void
      {
         var _loc1_:UnionJsData = null;
         if(UnionVipFactory.getDataByNpcAndXt(this.state.getValue(),this.smState.getValue(),this.getLv(this.smState.getValue())) != null)
         {
            _loc1_ = UnionVipFactory.getDataByNpcAndXt(this.state.getValue(),this.smState.getValue(),this.getLv(this.smState.getValue()));
            this.jsMc.sm_tx.text = _loc1_.getSm();
            this.jsMc.zj_tx.text = _loc1_.getNzj() + "/" + this.data.getNowZj();
            this.jsMc.js_tx.text = _loc1_.getNjs() + "/" + this.data.getSyJs();
            this.jsMc.jt_tx.text = String(_loc1_.getNlv());
            (this.xtArr[this.smState.getValue()] as GoodsBtnX).getSmMc().gxMc.visible = true;
         }
         else
         {
            this.jsMc.sm_tx.text = "";
            this.jsMc.zj_tx.text = "";
            this.jsMc.js_tx.text = "";
            this.jsMc.jt_tx.text = "";
            (this.xtArr[this.smState.getValue()] as GoodsBtnX).getSmMc().gxMc.visible = false;
         }
      }
      
      private function initFrame() : void
      {
         var _loc2_:UnionJsData = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            if(UnionVipFactory.getDataByNpcAndXt(this.state.getValue(),_loc1_,this.getLv(_loc1_)) != null)
            {
               _loc2_ = UnionVipFactory.getDataByNpcAndXt(this.state.getValue(),_loc1_,this.getLv(_loc1_));
               this.jsMc["name_" + _loc1_].text = _loc2_.getName() + " " + "Lv." + this.getLv(_loc1_);
               if(_loc2_.getNzj() <= this.data.getNowZj() && _loc2_.getNjs() <= this.data.getSyJs() && _loc2_.getNlv() <= this.data.getMyUnion().getUnionLevel())
               {
                  this.jsMc["ok_" + _loc1_].text = "可以升级";
               }
               else
               {
                  this.jsMc["ok_" + _loc1_].text = "条件未满足";
               }
               (this.xtArr[_loc1_] as GoodsBtnX).visible = true;
               (this.xtArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(_loc2_.getFrame());
               (this.xtArr[_loc1_] as GoodsBtnX).getSmMc().gxMc.visible = false;
            }
            else
            {
               this.jsMc["name_" + _loc1_].text = "";
               this.jsMc["ok_" + _loc1_].text = "";
               (this.xtArr[_loc1_] as GoodsBtnX).visible = false;
               (this.xtArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               (this.xtArr[_loc1_] as GoodsBtnX).getSmMc().gxMc.visible = false;
            }
            _loc1_++;
         }
      }
   }
}

