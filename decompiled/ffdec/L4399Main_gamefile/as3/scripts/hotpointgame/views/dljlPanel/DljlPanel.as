package hotpointgame.views.dljlPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.dljl.*;
   import hotpointgame.utils.gameloader.*;
   
   public class DljlPanel extends MovieClip
   {
      
      private static var _instance:DljlPanel;
      
      private static var cbx:Number = -1;
      
      private var dlmc:MovieClip;
      
      private var data:DljlData;
      
      private var btnArr:Array = [];
      
      public function DljlPanel()
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
               _loc1_.push("lxdlpanel");
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
         var _loc3_:uint = 0;
         var _loc4_:CloseBtnX = null;
         var _loc5_:ClickBtnX = null;
         if(cbx == -1)
         {
            _instance = new DljlPanel();
            _loc1_ = LoaderManager.getSwfClass("Lxdl_mc") as Class;
            _instance.dlmc = new _loc1_();
            _instance.addChild(_instance.dlmc);
            _loc2_ = _instance.dlmc;
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               _loc5_ = new ClickBtnX(_loc2_["b_" + _loc3_],_loc2_["b_" + _loc3_].x,_loc2_["b_" + _loc3_].y);
               _loc2_.addChild(_loc5_);
               _instance.btnArr.push(_loc5_);
               _loc3_++;
            }
            _loc4_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc4_);
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.addEvent();
         this.data = GoodsManger.dataList.dljl;
         this.visible = true;
         this.initDisplay();
      }
      
      private function initDisplay() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 7)
         {
            if(this.data.getCs() >= this.data.getBtnCs(_loc1_))
            {
               if(this.data.isLq(_loc1_))
               {
                  (this.btnArr[_loc1_] as ClickBtnX).okBtn = false;
                  this.dlmc["b_" + _loc1_].btn_tx.text = "已领取";
               }
               else
               {
                  (this.btnArr[_loc1_] as ClickBtnX).okBtn = true;
                  this.dlmc["b_" + _loc1_].btn_tx.text = "未领取";
               }
            }
            else
            {
               (this.btnArr[_loc1_] as ClickBtnX).okBtn = false;
               this.dlmc["b_" + _loc1_].btn_tx.text = "未领取";
            }
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
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
         var _loc2_:VT = null;
         if(param1.name == "b")
         {
            if(this.data.getCs() >= this.data.getBtnCs(param1.id))
            {
               if(!this.data.isLq(param1.id))
               {
                  if(BagFactory.otherBag.getAirGirdNum() > GS.a0)
                  {
                     _loc2_ = VT.createVT(DlJlFactory.getDataByCs(this.data.getBtnCs(param1.id)).getGsId());
                     BagFactory.addInBagById(_loc2_.getValue(),GS.a1,GS.a0);
                     BagFactory.hdGoodsTs(_loc2_.getValue(),GS.a1);
                     this.data.setLq(param1.id);
                     this.initDisplay();
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
            }
         }
      }
   }
}

