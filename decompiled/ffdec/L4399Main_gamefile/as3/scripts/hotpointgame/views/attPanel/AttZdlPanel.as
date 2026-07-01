package hotpointgame.views.attPanel
{
   import flash.display.MovieClip;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.chongwu.*;
   import hotpointgame.views.geneChangePanel.*;
   import hotpointgame.views.insertPanel.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.vipPanel.*;
   import hotpointgame.views.wmdPanel.*;
   
   public class AttZdlPanel extends MovieClip
   {
      
      public static var _instance:AttZdlPanel;
      
      private static var bx1:int = 0;
      
      public var attMc:MovieClip;
      
      private var _playerChangeMc:PlayerChange;
      
      private var data:AttJsData;
      
      private var ye:Number = 1;
      
      private var bo:Boolean = false;
      
      public function AttZdlPanel()
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
               bx1 = -1;
               _loc1_ = new Array();
               _loc1_.push("attPanel");
               if(FlowInterface.getJobByRole() == 1)
               {
                  _loc1_.push("pmodes1");
               }
               else if(FlowInterface.getJobByRole() == 2)
               {
                  _loc1_.push("pmodes2");
               }
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadPanAttOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.visible = true;
         _instance.initData();
      }
      
      private static function loadPanAttOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:ClickBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:ClickBtnX = null;
         var _loc7_:ClickBtnX = null;
         if(bx1 != 0)
         {
            bx1 = 0;
            _instance = new AttZdlPanel();
            _loc1_ = LoaderManager.getSwfClass("Att_mc") as Class;
            _instance.attMc = new _loc1_();
            _instance.addChild(_instance.attMc);
            _instance._playerChangeMc = PlayerChange.createPlayerChange();
            _loc2_ = _instance.attMc;
            _loc3_ = 0;
            while(_loc3_ < 11)
            {
               _loc6_ = new ClickBtnX(_loc2_["b_" + _loc3_],_loc2_["b_" + _loc3_].x,_loc2_["b_" + _loc3_].y);
               _loc2_.addChild(_loc6_);
               _loc3_++;
            }
            _loc4_ = new ClickBtnX(_loc2_.tj_btn,_loc2_.tj_btn.x,_loc2_.tj_btn.y);
            _loc2_.addChild(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc7_ = new ClickBtnX(_loc2_["j_" + _loc3_],_loc2_["j_" + _loc3_].x,_loc2_["j_" + _loc3_].y);
               _loc2_.addChild(_loc7_);
               _loc3_++;
            }
            _loc5_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc5_);
            GM.bagJm.addChild(_instance);
            _instance.initData();
         }
      }
      
      public static function close() : void
      {
         bx1 = 0;
         if(_instance != null && _instance.visible)
         {
            _instance.bo = false;
            _instance._playerChangeMc.close();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      private function initData() : void
      {
         this.addEvent();
         this.visible = false;
         this.data = GoodsManger.dataList.attZdl;
         DataIngPanel.open("获取我的战斗力信息");
         GM.testapi.getFightScoreInfo();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         Main.self.addEventListener(AttEvent.MY_ATT,this.myAttHandle);
         Main.self.addEventListener(AttEvent.ATT_LIST,this.attListHandle);
         Main.self.addEventListener(AttEvent.TJ_OK,this.okHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         Main.self.removeEventListener(AttEvent.MY_ATT,this.myAttHandle);
         Main.self.removeEventListener(AttEvent.ATT_LIST,this.attListHandle);
         Main.self.removeEventListener(AttEvent.TJ_OK,this.okHandle);
      }
      
      private function okHandle(param1:AttEvent) : void
      {
         if(param1.obj == "true")
         {
            GM.testapi.getFightScoreInfo();
            GoodsManger.dataList.evData.setJd(GS.a8);
         }
      }
      
      private function myAttHandle(param1:AttEvent) : void
      {
         DataIngPanel.close();
         this.data.setMyData(param1.obj);
         DataIngPanel.open("获取战斗力列表");
         GM.testapi.getFicthScoreList();
      }
      
      private function attListHandle(param1:AttEvent) : void
      {
         this.data.setCyList(param1.obj as Array);
         DataIngPanel.close();
         this.initPanel();
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.data.jsZdl();
         if(!this.bo)
         {
            this.bo = true;
            this.attMc.addChild(this._playerChangeMc);
            this._playerChangeMc.initChange(200,215);
         }
         this.initText();
         this.initDisplay();
      }
      
      private function initDisplay() : void
      {
         var _loc3_:AttCyData = null;
         var _loc1_:Array = this.data.getCurrCyList(this.ye);
         var _loc2_:uint = 0;
         while(_loc2_ < 10)
         {
            if(_loc1_[_loc2_] != null)
            {
               _loc3_ = _loc1_[_loc2_] as AttCyData;
               this.attMc["c_" + _loc2_].t_0.text = String(_loc3_.getRank());
               this.attMc["c_" + _loc2_].t_1.text = String(_loc3_.getUseName());
               this.attMc["c_" + _loc2_].t_2.text = String(_loc3_.getJob());
               this.attMc["c_" + _loc2_].t_3.text = String(_loc3_.getLevel());
               this.attMc["c_" + _loc2_].t_4.text = String(_loc3_.getScore());
            }
            else
            {
               this.attMc["c_" + _loc2_].t_0.text = "";
               this.attMc["c_" + _loc2_].t_1.text = "";
               this.attMc["c_" + _loc2_].t_2.text = "";
               this.attMc["c_" + _loc2_].t_3.text = "";
               this.attMc["c_" + _loc2_].t_4.text = "";
            }
            _loc2_++;
         }
         this.attMc.j_tx.text = this.ye + "/" + this.data.getAllYeCy();
      }
      
      private function initText() : void
      {
         if(this.data.getMyData() != null)
         {
            this.attMc.name_tx.text = GM.testapi.userName;
            this.attMc.myzdl_tx.text = String(this.data.getMyData().getRank());
            this.attMc.job_tx.text = FlowInterface.getJobxx();
            this.attMc.lv_tx.text = "Lv." + String(FlowInterface.getLevelByRole());
            this.attMc.zdl_tx.text = String(Math.floor(BagFactory.equipSlot.getZdl() + GM.aSaveData.petm.getFightgAtt()));
         }
         else
         {
            this.attMc.name_tx.text = GM.testapi.userName;
            this.attMc.myzdl_tx.text = String(10001);
            this.attMc.job_tx.text = FlowInterface.getJobxx();
            this.attMc.lv_tx.text = "Lv." + String(FlowInterface.getLevelByRole());
            this.attMc.zdl_tx.text = String(Math.floor(BagFactory.equipSlot.getZdl() + GM.aSaveData.petm.getFightgAtt()));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "b")
         {
            switch(param1.id)
            {
               case 0:
                  VipPanel.open();
                  break;
               case 1:
                  StrengthenPanel.open();
                  break;
               case 2:
                  WmdPanel.open();
                  break;
               case 3:
                  UnionSqPanel.open(0);
                  break;
               case 4:
                  InsertPanel.open();
                  break;
               case 5:
                  Gshiershengxiao.open();
                  break;
               case 6:
                  SkillGoUpC.open();
                  break;
               case 7:
                  if(GM.levelSD.getOverProcess(GS.a6) != -1)
                  {
                     GeneChangePanel.open();
                  }
                  else
                  {
                     GoodsManger.cwTs("获得第6关曼德海岸进入权限后开启");
                  }
                  break;
               case 8:
                  GdataPK.open();
                  break;
               case 9:
                  UnionSqPanel.open(1);
                  break;
               case 10:
                  ChongWuPanel.open();
            }
         }
         else if(param1.name == "j")
         {
            if(param1.id == 0)
            {
               if(this.ye > 1)
               {
                  --this.ye;
               }
               else
               {
                  this.ye = this.data.getAllYeCy();
               }
            }
            else if(param1.id == 1)
            {
               if(this.ye < this.data.getAllYeCy())
               {
                  ++this.ye;
               }
               else
               {
                  this.ye = 1;
               }
            }
            this.initDisplay();
         }
         else if(param1.name == "tj")
         {
            if(this.data.getZdl() > GS.a0)
            {
               DataIngPanel.open();
               GM.testapi.submitFightScore(this.data.getZdl());
            }
            else
            {
               GoodsManger.cwTs("亲,你没有战斗力-_-!");
            }
         }
      }
   }
}

