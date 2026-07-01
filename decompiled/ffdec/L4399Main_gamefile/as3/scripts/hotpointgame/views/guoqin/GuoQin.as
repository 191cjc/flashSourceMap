package hotpointgame.views.guoqin
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class GuoQin extends MovieClip
   {
      
      private static var _instance:GuoQin;
      
      private static var cbx:Number = -1;
      
      private var zqmc:MovieClip;
      
      private var needId:VT = VT.createVT(GS.a331119 + GS.a50);
      
      private var neednumArr:Array = [VT.createVT(GS.a1000 + GS.a400),VT.createVT(GS.a1000 + GS.a400),VT.createVT(GS.a50),VT.createVT(GS.a1000 + GS.a400),VT.createVT(GS.a1000 + GS.a400),VT.createVT(GS.a18),VT.createVT(GS.a8)];
      
      private var reawdidArr:Array = [VT.createVT(GS.a141132 + GS.a200 + GS.a3),VT.createVT(GS.a141132 + GS.a200 + GS.a7),VT.createVT(GS.a331100 + GS.a80),VT.createVT(GS.a141132 + GS.a200 + GS.a11),VT.createVT(GS.a141132 + GS.a200 + GS.a15),VT.createVT(GS.a331116),VT.createVT(GS.a331115)];
      
      private var goodsArr:Array = [GoodsFactory.createGoodsById(this.reawdidArr[GS.a0].getValue()),GoodsFactory.createGoodsById(this.reawdidArr[GS.a1].getValue()),GoodsFactory.createGoodsById(this.reawdidArr[GS.a2].getValue()),GoodsFactory.createGoodsById(this.reawdidArr[GS.a3].getValue()),GoodsFactory.createGoodsById(this.reawdidArr[GS.a4].getValue()),GoodsFactory.createGoodsById(this.reawdidArr[GS.a5].getValue()),GoodsFactory.createGoodsById(this.reawdidArr[GS.a6].getValue())];
      
      private var reawdNumArr:Array = [VT.createVT(GS.a1),VT.createVT(GS.a1),VT.createVT(GS.a50),VT.createVT(GS.a1),VT.createVT(GS.a1),VT.createVT(GS.a1),VT.createVT(GS.a1)];
      
      private var allNum:VT = VT.createVT(GS.a0);
      
      private var _sxDisplay:SxPanel;
      
      public function GuoQin()
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
               _loc1_.push("gqhd");
               _loc1_.push("sxpanel");
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
         var _loc2_:uint = 0;
         var _loc3_:CloseBtnX = null;
         var _loc4_:ClickBtnX = null;
         var _loc5_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new GuoQin();
            _loc1_ = LoaderManager.getSwfClass("Gqhd") as Class;
            _instance.zqmc = new _loc1_();
            _instance.addChild(_instance.zqmc);
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               _loc4_ = new ClickBtnX(_instance.zqmc["dh_" + _loc2_],_instance.zqmc["dh_" + _loc2_].x,_instance.zqmc["dh_" + _loc2_].y);
               _instance.zqmc.addChild(_loc4_);
               _loc5_ = new ClickBtnX(_instance.zqmc["over_" + _loc2_],_instance.zqmc["over_" + _loc2_].x,_instance.zqmc["over_" + _loc2_].y);
               _instance.zqmc.addChild(_loc5_);
               _loc2_++;
            }
            _loc3_ = new CloseBtnX(_instance.zqmc.close_btn,_instance.zqmc.close_btn.x,_instance.zqmc.close_btn.y);
            _instance.zqmc.addChild(_loc3_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            _instance.zqmc.addChild(_instance._sxDisplay);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.initDisplay();
         this.addEvent();
      }
      
      private function initDisplay() : void
      {
         this.allNum.setValue(BagFactory.getNumById(this.needId.getValue()));
         this.zqmc.all_num.text = String(this.allNum.getValue());
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            this.zqmc["num_" + _loc1_].text = this.allNum.getValue() + "/" + this.neednumArr[_loc1_].getValue();
            _loc1_++;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         if(param1.name == "over")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this.goodsArr[param1.id]));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "dh")
         {
            if(BagFactory.isFullById(this.reawdidArr[param1.id].getValue(),this.reawdNumArr[param1.id].getValue()))
            {
               if(this.allNum.getValue() >= this.neednumArr[param1.id].getValue())
               {
                  if(BagFactory.otherBag.deleteGoods(this.needId.getValue(),this.neednumArr[param1.id].getValue()))
                  {
                     BagFactory.addInBagById(this.reawdidArr[param1.id].getValue(),this.reawdNumArr[param1.id].getValue(),GS.a0);
                     BagFactory.hdGoodsTs(this.reawdidArr[param1.id].getValue(),this.reawdNumArr[param1.id].getValue());
                  }
                  this.initDisplay();
               }
               else
               {
                  GoodsManger.cwTs("活动金蛋不足");
               }
            }
            else
            {
               GoodsManger.cwTs("背包已满");
            }
         }
      }
   }
}

