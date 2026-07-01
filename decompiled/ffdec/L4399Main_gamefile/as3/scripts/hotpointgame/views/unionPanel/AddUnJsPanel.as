package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class AddUnJsPanel extends MovieClip
   {
      
      private static var _instance:AddUnJsPanel;
      
      private static var cbx:Number = -1;
      
      private var jsMc:MovieClip;
      
      private var data:UnionPanelData;
      
      private var goodsId:VT = VT.createVT(GS.a331100 + GS.a88 + GS.a100);
      
      private var type:VT = VT.createVT(GS.a1);
      
      private var numvt:VT = VT.createVT(GS.a200 * GS.a100);
      
      private var bo:Boolean = false;
      
      private var typeVt:VT = VT.createVT(GS.a0);
      
      private var timer:Timer = new Timer(GS.a1000,GS.a0);
      
      private var mcNum:Number = 0;
      
      private var xsNum:Number = 2;
      
      private var ztNum:Number = 0;
      
      private var tdNum:Number = 8;
      
      private var mcBo:Boolean;
      
      private var tsArr:Array = ["军团建设值需要每个成员的努力才能增加，如果有团员不能相互配合的话相会影响到整个军团的建设进度,","建筑合金在任意关卡的噩梦难度都能够获得","建设值不足的时，团长可以适当的使用军团资金来购买建设值"];
      
      public function AddUnJsPanel()
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
         var _loc4_:CloseBtnX = null;
         var _loc5_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new AddUnJsPanel();
            _loc1_ = LoaderManager.getSwfClass("AddJs") as Class;
            _instance.jsMc = new _loc1_();
            _instance.addChild(_instance.jsMc);
            _loc2_ = _instance.jsMc;
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc5_ = new ClickBtnX(_loc2_["b_" + _loc3_],_loc2_["b_" + _loc3_].x,_loc2_["b_" + _loc3_].y);
               _loc2_.addChild(_loc5_);
               _loc3_++;
            }
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
         this.bo = false;
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
         this.initText();
         this.jsMc.ts_mc.visible = false;
         this.timer.start();
      }
      
      private function initText() : void
      {
         this.jsMc.js_tx.text = this.data.getJsOver() + "/" + this.data.getAlLJs();
         this.jsMc.sj_tx.text = String(this.data.getNowZj());
         this.jsMc.mc_tx.text = String(BagFactory.getNumById(this.goodsId.getValue()));
         this.jsMc.qk_tx.text = "军团商店:" + this.data.getShopJs();
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
         Main.self.addEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.addEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.addEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         Main.self.addEventListener(UnEvent.GONGAO_TX,this.gongaotx);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandle);
      }
      
      private function timerHandle(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!this.mcBo)
         {
            if(this.mcNum < this.xsNum)
            {
               ++this.mcNum;
            }
            else
            {
               this.jsMc.ts_mc.visible = true;
               _loc2_ = int(Math.random() * this.tsArr.length);
               this.jsMc.ts_mc.ts_tx.text = this.tsArr[_loc2_];
               this.mcBo = true;
            }
         }
         else if(this.ztNum < this.tdNum)
         {
            ++this.ztNum;
         }
         else
         {
            this.jsMc.ts_mc.visible = false;
            this.mcBo = false;
            this.ztNum = 0;
            this.mcNum = 0;
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
            if(param1.id == GS.a0)
            {
               if(this.data.getMyUnion().isHz())
               {
                  if(this.data.getNowZj() >= this.numvt.getValue())
                  {
                     if(this.data.getGgBl(GS.a10) < this.data.getZjMax())
                     {
                        if(this.data.getGgBl(GS.a8) < GS.a200 * GS.a10)
                        {
                           DataIngPanel.open();
                           this.typeVt.setValue(param1.id);
                           GM.testapi.changeVarValue(GS.a8);
                        }
                        else
                        {
                           GoodsManger.cwTs("建设值已满");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("今天的资金兑换已达上限");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("资金不足");
                  }
               }
               else
               {
                  GoodsManger.cwTs("你的职位太低了，现在只有团长才能使用");
               }
            }
            else if(param1.id == GS.a1)
            {
               if(BagFactory.getNumById(this.goodsId.getValue()) > GS.a0)
               {
                  if(this.data.getCurrMc() < this.data.getMcMax())
                  {
                     if(this.data.getGgBl(GS.a8) < GS.a200 * GS.a10)
                     {
                        DataIngPanel.open();
                        this.typeVt.setValue(param1.id);
                        GM.testapi.changeVarValue(GS.a8);
                     }
                     else
                     {
                        GoodsManger.cwTs("建设值已满");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("今天无法再提交了，明天再来吧");
                  }
               }
               else
               {
                  GoodsManger.cwTs("建筑合金不足");
               }
            }
         }
      }
      
      private function jtTaskHandlex(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            this.data.addGxValue(GS.a20);
            this.data.setJSGx(this.data.getJSGx() + GS.a1);
            this.data.addCurrMc(this.data.getCurrMc() + GS.a1);
            BagFactory.deteleGoods(this.goodsId.getValue(),GS.a1);
            GoodsManger.cwTs("建设值购买成功，军团建设值+1,增加了20贡献");
            FlowInterface.saveDataByKai();
            DataIngPanel.open();
            GM.testapi.getVarValue(this.data.getGbId());
         }
      }
      
      private function setGblHandle(param1:UnEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         if(String(param1.obj) == "true")
         {
            if(this.typeVt.getValue() == GS.a0)
            {
               this.typeVt.setValue(GS.a2);
               this.data.addXhZJ(this.numvt.getValue());
               FlowInterface.saveDataByKai();
               GM.testapi.changeVarValue(GS.a10);
            }
            else if(this.typeVt.getValue() == GS.a1)
            {
               GM.testapi.overTask("20");
            }
            else if(this.typeVt.getValue() == GS.a2)
            {
               _loc2_ = this.data.getMyUnion().getExtra();
               _loc3_ = String(this.data.getZj());
               _loc4_ = _loc2_ + "*" + _loc3_;
               GM.testapi.changeUnionExtra(GS.a1,_loc4_,this.data.getMyUnion().getUnionId());
            }
            else if(this.typeVt.getValue() == GS.a3)
            {
            }
         }
      }
      
      private function gongaotx(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            DataIngPanel.close();
            GoodsManger.cwTs("建设值购买成功，军团建设值+1");
            DataIngPanel.open();
            GM.testapi.getMyselfUnion();
         }
      }
      
      private function removeEvent() : void
      {
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.error);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,this.getGGbL);
         Main.self.removeEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.removeEventListener(UnEvent.TASK_OVER,this.jtTaskHandlex);
         Main.self.removeEventListener(UnEvent.SET_GG_BL,this.setGblHandle);
         Main.self.removeEventListener(UnEvent.GONGAO_TX,this.gongaotx);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandle);
      }
   }
}

