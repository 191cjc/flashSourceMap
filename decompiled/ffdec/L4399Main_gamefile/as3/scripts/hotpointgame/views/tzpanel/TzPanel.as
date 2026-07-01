package hotpointgame.views.tzpanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class TzPanel extends MovieClip
   {
      
      private static var _instance:TzPanel;
      
      private static var cbx:Number = -1;
      
      private var zqmc:MovieClip;
      
      private var goodsId:VT = VT.createVT(GS.a331358 + GS.a27);
      
      public function TzPanel()
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
               _loc1_.push("tzpanel");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadZqOver;
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
      
      public static function loadZqOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:ClickBtnX = null;
         var _loc4_:uint = 0;
         var _loc5_:CloseBtnX = null;
         var _loc6_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new TzPanel();
            _loc1_ = LoaderManager.getSwfClass("Tz_mc") as Class;
            _instance.zqmc = new _loc1_();
            _instance.addChild(_instance.zqmc);
            _loc2_ = _instance.zqmc;
            _loc3_ = new ClickBtnX(_loc2_["b_" + 0],_loc2_["b_" + 0].x,_loc2_["b_" + 0].y);
            _loc2_.addChild(_loc3_);
            _loc4_ = 0;
            while(_loc4_ < 2)
            {
               _loc6_ = new ClickBtnX(_loc2_.ts_mc["ok_" + _loc4_],_loc2_.ts_mc["ok_" + _loc4_].x,_loc2_.ts_mc["ok_" + _loc4_].y);
               _loc2_.ts_mc.addChild(_loc6_);
               _loc4_++;
            }
            _loc5_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc5_);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.addEvent();
         this.visible = true;
         this.zqmc.ts_mc.visible = false;
         this.initText();
      }
      
      private function initText() : void
      {
         var _loc1_:VT = VT.createVT(GM.aSaveData.surmd.smNum);
         if(_loc1_.getValue() == GS.a0)
         {
            this.zqmc.t_1.text = "0/1";
            this.zqmc.t_2.text = "0/5";
         }
         else
         {
            this.zqmc.t_1.text = "1/1";
            this.zqmc.t_2.text = _loc1_.getValue() - GS.a1 + "/5";
         }
         this.zqmc.t_3.text = String(BagFactory.getNumById(this.goodsId.getValue()));
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "b")
         {
            if(GM.levelSD.getOverProcess(GS.a15) == -GS.a1)
            {
               GoodsManger.cwTs("通过极夜之殿后，才能开启幽灵海盗船的进入权限");
               return;
            }
            if(GM.aSaveData.surmd.smNum == GS.a0)
            {
               close();
               GM.levelm.changeLevelDataByIdAndLs(GS.a9994,1);
            }
            else if(GM.aSaveData.surmd.smNum < GS.a6)
            {
               if(BagFactory.getNumById(this.goodsId.getValue()) > GS.a0)
               {
                  this.zqmc.ts_mc.visible = true;
               }
               else
               {
                  GoodsManger.cwTs("物品不足");
               }
            }
            else
            {
               GoodsManger.cwTs("挑战次数已满");
            }
         }
         else if(param1.name == "ok")
         {
            this.zqmc.ts_mc.visible = false;
            if(param1.id == 0)
            {
               close();
               BagFactory.deteleGoods(this.goodsId.getValue(),GS.a1);
               GM.levelm.changeLevelDataByIdAndLs(GS.a9994,1);
            }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
      }
   }
}

