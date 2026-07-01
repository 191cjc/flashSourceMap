package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class AddUnZJPanel extends MovieClip
   {
      
      private static var _instance:AddUnZJPanel;
      
      private static var cbx:Number = -1;
      
      private var zJMc:MovieClip;
      
      private var data:UnionPanelData;
      
      private var goldVt:VT = VT.createVT(GS.a10000);
      
      public function AddUnZJPanel()
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
         var _loc3_:ClickBtnX = null;
         var _loc4_:CloseBtnX = null;
         if(cbx == -1)
         {
            _instance = new AddUnZJPanel();
            _loc1_ = LoaderManager.getSwfClass("AddZjMc") as Class;
            _instance.zJMc = new _loc1_();
            _instance.addChild(_instance.zJMc);
            _loc2_ = _instance.zJMc;
            _loc3_ = new ClickBtnX(_loc2_.ok_Btn,_loc2_.ok_Btn.x,_loc2_.ok_Btn.y);
            _loc2_.addChild(_loc3_);
            _loc4_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc4_);
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
         DataIngPanel.close();
         this.initPanel();
      }
      
      private function error(param1:UnEvent) : void
      {
         GoodsManger.cwTs(String(param1.obj));
         DataIngPanel.close();
         close();
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.zJMc.zj_tx.text = String(this.data.getNowZj());
      }
      
      private function addEvent() : void
      {
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.addEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.addEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.addEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.addEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
      }
      
      private function setGblHandle(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            GM.testapi.overTask("21");
         }
      }
      
      private function jtTaskHandlex(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            this.data.addGxValue(GS.a13);
            this.data.setZJgX(this.data.getZjGx() + GS.a1);
            FlowInterface.redGodByRole(this.goldVt.getValue());
            GoodsManger.cwTs("资金增加成功,军团增加了13贡献");
            FlowInterface.saveDataByKai();
            DataIngPanel.open();
            GM.testapi.getVarValue(this.data.getGbId());
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "ok")
         {
            if(FlowInterface.getGodByRole() >= this.goldVt.getValue())
            {
               if(this.data.getNowZj() < GS.a200 * GS.a10 * GS.a10000)
               {
                  DebugOutPut.self.apptext("拥有资金:\n" + this.data.getNowZj());
                  DataIngPanel.open();
                  GM.testapi.changeVarValue(GS.a13);
               }
               else
               {
                  GoodsManger.cwTs("资金已满不能在兑换");
               }
            }
            else
            {
               GoodsManger.cwTs("晶币不足");
            }
         }
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.removeEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.removeEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.removeEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
      }
   }
}

