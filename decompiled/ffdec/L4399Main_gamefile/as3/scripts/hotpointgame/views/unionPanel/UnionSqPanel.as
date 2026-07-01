package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.utils.gameloader.*;
   
   public class UnionSqPanel extends MovieClip
   {
      
      private static var _instance:UnionSqPanel;
      
      private static var cbx:Number = -1;
      
      private static var type:Number = 0;
      
      private var sMc:MovieClip;
      
      private var uBtn:SameChangeBtnX;
      
      private var data:UnionPanelData;
      
      private var ye:VT = VT.createVT(GS.a1);
      
      private var cuId:VT = VT.createVT(GS.a0);
      
      public function UnionSqPanel()
      {
         super();
      }
      
      public static function open(param1:Number) : void
      {
         var _loc2_:Array = null;
         type = param1;
         GoodsManger.allPanelClose();
         if(_instance == null)
         {
            if(GM.loaderM.keYiUse())
            {
               cbx = -1;
               _loc2_ = new Array();
               _loc2_.push("unionpanel");
               GM.loaderM.setLoadData(_loc2_);
               GM.loaderM.completeF = loadsqUnionOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         type = param1;
         _instance.initUnion();
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
      
      private static function loadsqUnionOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:ClickBtnX = null;
         var _loc5_:ClickBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new UnionSqPanel();
            _loc1_ = LoaderManager.getSwfClass("UnionSq") as Class;
            _instance.sMc = new _loc1_();
            _instance.addChild(_instance.sMc);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc7_ = new ClickBtnX(_instance.sMc["j_" + _loc2_],_instance.sMc["j_" + _loc2_].x,_instance.sMc["j_" + _loc2_].y);
               _instance.sMc.addChild(_loc7_);
               _loc2_++;
            }
            _loc3_ = _instance.sMc;
            _instance.uBtn = SameChangeBtnX.createSameChangeBtn(new Array(_loc3_.u_0,_loc3_.u_1,_loc3_.u_2,_loc3_.u_3,_loc3_.u_4,_loc3_.u_5,_loc3_.u_6,_loc3_.u_7,_loc3_.u_8,_loc3_.u_9));
            _loc3_.addChild(_instance.uBtn);
            _loc4_ = new ClickBtnX(_instance.sMc["sq_" + 0],_instance.sMc["sq_" + 0].x,_instance.sMc["sq_" + 0].y);
            _instance.sMc.addChild(_loc4_);
            _loc5_ = new ClickBtnX(_instance.sMc["ts_" + 0],_instance.sMc["ts_" + 0].x,_instance.sMc["ts_" + 0].y);
            _instance.sMc.addChild(_loc5_);
            _instance.sMc.addChild(_instance.sMc.tss_mc);
            GM.bagJm.addChild(_instance);
            _instance.initUnion();
            _loc6_ = new CloseBtnX(_loc3_.close_btn,_loc3_.close_btn.x,_loc3_.close_btn.y);
            _loc3_.addChild(_loc6_);
         }
      }
      
      private function initUnion() : void
      {
         this.visible = false;
         this.addEvent();
         this.data = GoodsManger.dataList.unionData;
         DataIngPanel.open("获取所有军团数据中");
         GM.testapi.getGameUList(GS.a1,this.data.getUnionAllNum());
      }
      
      private function allUnionHandle(param1:UnEvent) : void
      {
         DataIngPanel.close();
         this.data.setUnionList(param1.obj);
         if(this.data.getUnionList().length > GS.a0)
         {
            this.initPanel();
         }
         else
         {
            this.removeEvent();
            GoodsManger.cwTs("没有任何公会可以加入");
         }
      }
      
      private function sqHandle(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            GoodsManger.cwTs("申请成功");
            FlowInterface.saveDataByKai();
         }
      }
      
      private function errorHandle(param1:UnEvent) : void
      {
         DataIngPanel.close();
         GoodsManger.cwTs(String(param1.obj));
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.sMc.tss_mc.visible = false;
         if(type == 0)
         {
            this.sMc.txmc.visible = true;
            this.sMc.sq_0.visible = true;
         }
         else if(type == 1)
         {
            this.sMc.txmc.visible = false;
            this.sMc.sq_0.visible = false;
         }
         this.ye.setValue(GS.a1);
         this.cuId.setValue(GS.a0);
         this.initUnTx();
         this.isXsbtn();
      }
      
      private function addEvent() : void
      {
         Main.self.addEventListener(UnEvent.LIST_UNION,this.allUnionHandle);
         Main.self.addEventListener(UnEvent.SY_ING,this.sqHandle);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:String = null;
         if(param1.name == "ts")
         {
            this.sMc.tss_mc.visible = true;
            this.sMc.tss_mc.x = mouseX;
            this.sMc.tss_mc.y = mouseY;
            switch(param1.id)
            {
               case 0:
                  _loc2_ = "军团等级相同时，根据建立时间早晚决定";
            }
            this.sMc.tss_mc.tsxx_ts.text = _loc2_;
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "ts")
         {
            this.sMc.tss_mc.visible = false;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "u")
         {
            this.cuId.setValue(param1.id + (this.ye.getValue() - 1) * 10);
            this.isXsbtn();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:VT = null;
         var _loc3_:UnionData = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1.name == "j")
         {
            if(param1.id == 0)
            {
               if(this.ye.getValue() > 1)
               {
                  this.ye.setValue(this.ye.getValue() - GS.a1);
               }
               else
               {
                  this.ye.setValue(this.data.getAllYeUn());
               }
            }
            else if(param1.id == 1)
            {
               if(this.ye.getValue() < this.data.getAllYeUn())
               {
                  this.ye.setValue(this.ye.getValue() + GS.a1);
               }
               else
               {
                  this.ye.setValue(GS.a1);
               }
            }
            this.initUnTx();
            this.isXsbtn();
         }
         else if(param1.name == "sq")
         {
            DataIngPanel.open("申请中");
            _loc2_ = VT.createVT(this.cuId.getValue() - (this.ye.getValue() - 1) * 10);
            _loc3_ = this.data.getUnionByKey(_loc2_.getValue());
            if(FlowInterface.getJobByRole() == 1)
            {
               _loc4_ = "绝影枪手";
            }
            else if(FlowInterface.getJobByRole() == 2)
            {
               _loc4_ = "炎蓝炮手";
            }
            _loc5_ = FlowInterface.getLevelByRole() + "*" + GM.aSaveData.pksd.scoreb + "*" + _loc4_;
            GM.testapi.shengQiUnion(_loc3_.getId(),_loc5_);
         }
      }
      
      private function initUnTx() : void
      {
         var _loc3_:UnionData = null;
         var _loc4_:Number = NaN;
         var _loc1_:Array = this.data.getCurrUnionList(this.ye.getValue());
         var _loc2_:uint = 0;
         while(_loc2_ < 10)
         {
            _loc3_ = _loc1_[_loc2_] as UnionData;
            this.sMc["u_" + _loc2_].visible = false;
            if(_loc3_ != null)
            {
               this.sMc["u_" + _loc2_].visible = true;
               this.sMc["u_" + _loc2_].ph_tx.text = _loc3_.getPm();
               this.sMc["u_" + _loc2_].n_tx.text = _loc3_.getUnionName();
               this.sMc["u_" + _loc2_].lv_tx.text = String(_loc3_.getLevel());
               switch(_loc3_.getLevel())
               {
                  case 1:
                     _loc4_ = 10;
                     break;
                  case 2:
                     _loc4_ = 13;
                     break;
                  case 3:
                     _loc4_ = 16;
                     break;
                  case 4:
                     _loc4_ = 19;
                     break;
                  case 5:
                     _loc4_ = 22;
                     break;
                  case 6:
                     _loc4_ = 25;
                     break;
                  case 7:
                     _loc4_ = 28;
                     break;
                  case 8:
                     _loc4_ = 31;
                     break;
                  case 9:
                     _loc4_ = 34;
                     break;
                  case 10:
                     _loc4_ = 37;
                     break;
                  case 11:
                     _loc4_ = 40;
                     break;
                  case 12:
                     _loc4_ = 43;
                     break;
                  case 13:
                     _loc4_ = 46;
                     break;
                  case 14:
                     _loc4_ = 49;
                     break;
                  case 15:
                     _loc4_ = 50;
               }
               this.sMc["u_" + _loc2_].rs_tx.text = _loc3_.getCount() + "/" + _loc4_;
               this.sMc["u_" + _loc2_].tz_tx.text = String(_loc3_.getUseName());
            }
            _loc2_++;
         }
         this.sMc.num_tx.text = this.ye.getValue() + "/" + this.data.getAllYeUn();
      }
      
      private function isXsbtn() : void
      {
         this.uBtn.czArr();
         this.sMc.sq_0.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            if(this.cuId.getValue() == (this.ye.getValue() - 1) * 10 + _loc1_)
            {
               this.uBtn.btnOk(_loc1_);
               if(type == GS.a0)
               {
                  this.sMc.sq_0.visible = true;
                  this.sMc.sq_0.y = this.sMc["u_" + _loc1_].y;
               }
               break;
            }
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.LIST_UNION,this.allUnionHandle);
         Main.self.removeEventListener(UnEvent.SY_ING,this.sqHandle);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
   }
}

