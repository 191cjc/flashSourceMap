package hotpointgame.views.petGj
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.ship.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.shipPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class PetOpenPanel extends MovieClip
   {
      
      private static var _instance:PetOpenPanel;
      
      private static var cbx:Number = -1;
      
      private var tbBoxArr:Array = [];
      
      private var _sxDisplay:SxPanel;
      
      private var spMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      public function PetOpenPanel()
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
               _loc1_.push("petGj");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadSpGtOver;
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
      
      public static function loadSpGtOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:ClickBtnX = null;
         var _loc5_:CloseBtnX = null;
         var _loc6_:MovieClip = null;
         var _loc7_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new PetOpenPanel();
            _loc1_ = LoaderManager.getSwfClass("Pet_Open") as Class;
            _instance.spMc = new _loc1_();
            _instance.addChild(_instance.spMc);
            _instance.addChild(_instance.centerMc);
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc6_ = new _loc2_();
               _loc6_.name = "e_" + _loc3_;
               _loc7_ = new GoodsBtnX(_loc6_,_instance.spMc["d_" + _loc3_].x,_instance.spMc["d_" + _loc3_].y);
               _instance.tbBoxArr.push(_loc7_);
               _instance.spMc.addChild(_loc7_);
               _loc3_++;
            }
            _loc4_ = new ClickBtnX(_instance.spMc["b_" + 0],_instance.spMc["b_" + 0].x,_instance.spMc["b_" + 0].y);
            _instance.spMc.addChild(_loc4_);
            _loc5_ = new CloseBtnX(_instance.spMc.close_btn,_instance.spMc.close_btn.x,_instance.spMc.close_btn.y);
            _instance.spMc.addChild(_loc5_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.centerMc.addChild(_instance._sxDisplay);
         this.visible = true;
         this.addEvent();
         this.initFrame();
      }
      
      private function initFrame() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = String(ShipData.gsNum[_loc1_].getValue());
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(ShipData.gsArr[_loc1_].getValue()).getFrame());
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().d_mc.visible = false;
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
         if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "e")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
            _loc2_ = GoodsFactory.createGoodsById(ShipData.gsArr[param1.id].getValue());
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "close")
         {
            close();
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(param1.name == "b")
         {
            _loc2_ = [];
            _loc3_ = [];
            if(BagFactory.getNumById(ShipData.gsArr[0].getValue()) >= ShipData.gsNum[0].getValue() && BagFactory.getNumById(ShipData.gsArr[1].getValue()) >= ShipData.gsNum[1].getValue())
            {
               if(ShipData.level.getValue() >= GS.a14)
               {
                  PetGjData.opBo = true;
                  PetGjPanel.open();
                  BagFactory.deteleGoods(ShipData.gsArr[0].getValue(),ShipData.gsNum[0].getValue());
                  BagFactory.deteleGoods(ShipData.gsArr[1].getValue(),ShipData.gsNum[1].getValue());
                  FlowInterface.saveDataByKai();
               }
               else
               {
                  GoodsManger.cwTs("战舰等级必须到达14");
               }
            }
            else
            {
               GoodsManger.cwTs("物品不足");
            }
         }
      }
   }
}

