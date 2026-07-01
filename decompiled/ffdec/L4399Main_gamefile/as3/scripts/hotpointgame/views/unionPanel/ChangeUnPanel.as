package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.gameloader.*;
   
   public class ChangeUnPanel extends MovieClip
   {
      
      private static var _instance:ChangeUnPanel;
      
      private static var cbx:Number = -1;
      
      private var chMc:MovieClip;
      
      public function ChangeUnPanel()
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
      
      public static function loadUnionOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new ChangeUnPanel();
            _loc1_ = LoaderManager.getSwfClass("ChangeU") as Class;
            _instance.chMc = new _loc1_();
            _instance.addChild(_instance.chMc);
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc3_ = new ClickBtnX(_instance.chMc["b_" + _loc2_],_instance.chMc["b_" + _loc2_].x,_instance.chMc["b_" + _loc2_].y);
               _instance.chMc.addChild(_loc3_);
               _loc2_++;
            }
            _instance.chMc.unionName.maxChars = GS.a8;
            _instance.chMc.unionName.autoSize = TextFieldAutoSize.LEFT;
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.chMc.unionName.text = "请输入军团名称";
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         Main.self.addEventListener(UnEvent.CH_UNION,this.chHandle);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHanele);
         Main.self.addEventListener(UnEvent.JC_API,this.jcApiHanele);
      }
      
      private function errorHanele(param1:UnEvent) : void
      {
         DataIngPanel.close();
         GoodsManger.cwTs(String(param1.obj));
      }
      
      private function chHandle(param1:UnEvent) : void
      {
         DataIngPanel.close();
         if(String(param1.obj) == "true")
         {
            GoodsManger.cwTs("军团创建成功");
            FlowInterface.redGodByRole(GS.a30 * GS.a10000);
            GoodsManger.dataList.unionData.clearData();
            FlowInterface.saveDataByKai();
            close();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "b")
         {
            if(param1.id == 0)
            {
               if(this.chMc.unionName.text != "请输入军团名称" && this.chMc.unionName.text != "")
               {
                  if(FlowInterface.getGodByRole() >= GS.a30 * GS.a10000)
                  {
                     DataIngPanel.open();
                     if(ApiCheckWord.self.checkWordByapi(this.chMc.unionName.text) == false)
                     {
                        GM.testapi.createUnion(this.chMc.unionName.text,"欢迎加入军团，大家可以加入QQ群:XX!");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("晶币不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("请输入军团名称");
               }
            }
            else
            {
               close();
            }
         }
      }
      
      private function jcApiHanele(param1:UnEvent) : void
      {
         if(param1.obj.code == "10000")
         {
            GM.testapi.createUnion(this.chMc.unionName.text,"欢迎加入军团，大家可以加入QQ群:XX!");
         }
         else
         {
            DataIngPanel.close();
            GoodsManger.cwTs("不能带敏感词");
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         Main.self.removeEventListener(UnEvent.CH_UNION,this.chHandle);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHanele);
         Main.self.removeEventListener(UnEvent.JC_API,this.jcApiHanele);
      }
   }
}

