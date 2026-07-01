package hotpointgame.views.threePanel
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
   import hotpointgame.repository.three.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class TreePanel extends MovieClip
   {
      
      private static var _instance:TreePanel;
      
      private static var cbx:Number = -1;
      
      private var topMc:MovieClip = new MovieClip();
      
      private var endMc:MovieClip = new MovieClip();
      
      private var centerMc:MovieClip = new MovieClip();
      
      private var upMc:MovieClip = new MovieClip();
      
      private var trMc:MovieClip = new MovieClip();
      
      private var tbArr:Array = [];
      
      private var _sxDisplay:SxPanel;
      
      private var data:ThData;
      
      public function TreePanel()
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
               _loc1_.push("treepanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadTrOver;
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
      
      private static function loadTrOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:ClickBtnX = null;
         var _loc6_:CloseBtnX = null;
         var _loc7_:MovieClip = null;
         var _loc8_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new TreePanel();
            _loc1_ = LoaderManager.getSwfClass("Tree_xx") as Class;
            _instance.trMc = new _loc1_();
            _loc2_ = _instance.trMc;
            _instance.addChild(_loc2_);
            _instance.addChild(_instance.endMc);
            _instance.addChild(_instance.centerMc);
            _instance.addChild(_instance.topMc);
            _instance.addChild(_instance.upMc);
            _loc3_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               _loc7_ = new _loc3_();
               _loc7_.name = "tr_" + _loc4_;
               _loc8_ = new GoodsBtnX(_loc7_,_loc2_["d_" + _loc4_].x,_loc2_["d_" + _loc4_].y);
               _instance.tbArr.push(_loc8_);
               _loc2_.addChild(_loc8_);
               _loc4_++;
            }
            _loc5_ = new ClickBtnX(_loc2_.lq_btn,_loc2_.lq_btn.x,_loc2_.lq_btn.y);
            _loc2_.addChild(_loc5_);
            _loc6_ = new CloseBtnX(_loc2_.close_btn,_loc2_.close_btn.x,_loc2_.close_btn.y);
            _loc2_.addChild(_loc6_);
            _instance._sxDisplay = SxPanel.createSxpanel();
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this.data = GoodsManger.dataList.three;
         this.initMc();
         this.initBag();
         this.initFrame();
         this.addEvet();
      }
      
      private function addEvet() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:ThreeData = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         if(param1.name == "lq")
         {
            _loc2_ = ThreeFactory.getDataById(this.data.getLv());
            if(this.data.getLv() > this.data.getMaxLv())
            {
               GoodsManger.cwTs("树已经长大了..");
               return;
            }
            _loc3_ = _loc2_.getGoodsId();
            _loc4_ = _loc2_.getGoodsNum();
            _loc5_ = _loc2_.getJlId();
            _loc6_ = _loc2_.getJlNum();
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               if(BagFactory.getNumById(_loc3_[_loc7_]) < _loc4_[_loc7_])
               {
                  GoodsManger.cwTs("需求物品不足");
                  return;
               }
               _loc7_++;
            }
            if(BagFactory.isFullBag(_loc5_,_loc6_))
            {
               BagFactory.deleteArrGoods(_loc3_,_loc4_);
               BagFactory.addBagArr(_loc5_,_loc6_);
               this.data.setLv(this.data.getLv() + GS.a1);
               this.initFrame();
            }
            else
            {
               GoodsManger.cwTs("背包不足");
            }
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:ThreeData = null;
         var _loc3_:Array = null;
         var _loc4_:Goods = null;
         if(param1.name == "tr")
         {
            if(this.data.getLv() <= this.data.getMaxLv())
            {
               _loc2_ = ThreeFactory.getDataById(this.data.getLv());
            }
            else
            {
               _loc2_ = ThreeFactory.getDataById(this.data.getMaxLv());
            }
            _loc3_ = _loc2_.getJlId();
            _loc4_ = GoodsFactory.createGoodsById(_loc3_[param1.id]);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc4_));
            (this.tbArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "tr")
         {
            (this.tbArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         removeEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function initFrame() : void
      {
         var _loc1_:ThreeData = null;
         if(this.data.getLv() <= this.data.getMaxLv())
         {
            _loc1_ = ThreeFactory.getDataById(this.data.getLv());
         }
         else
         {
            _loc1_ = ThreeFactory.getDataById(this.data.getMaxLv());
         }
         this.trMc.pz_mc.gotoAndStop(this.data.getLv());
         this.trMc.jd_mc.gotoAndStop(this.data.getLv());
         var _loc2_:Array = _loc1_.getGoodsId();
         var _loc3_:Array = _loc1_.getGoodsNum();
         var _loc4_:Array = _loc1_.getJlId();
         var _loc5_:Array = _loc1_.getJlNum();
         var _loc6_:uint = 0;
         while(_loc6_ < 3)
         {
            this.trMc["name_" + _loc6_].text = "";
            this.trMc["num_" + _loc6_].text = "";
            if(_loc2_[_loc6_] != null)
            {
               this.trMc["name_" + _loc6_].text = "需求物品:" + GoodsFactory.getGoodsById(_loc2_[_loc6_]).getName();
               this.trMc["num_" + _loc6_].text = "需求数量:" + _loc3_[_loc6_] + "/" + BagFactory.getNumById(_loc2_[_loc6_]);
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 6)
         {
            if(_loc4_[_loc6_] != null)
            {
               (this.tbArr[_loc6_] as GoodsBtnX).visible = true;
               (this.tbArr[_loc6_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc5_[_loc6_]);
               (this.tbArr[_loc6_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc4_[_loc6_]).getFrame());
            }
            else
            {
               (this.tbArr[_loc6_] as GoodsBtnX).visible = false;
               (this.tbArr[_loc6_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.tbArr[_loc6_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            }
            _loc6_++;
         }
      }
      
      private function initBag() : void
      {
         this.centerMc.addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function initMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 6)
         {
            (this.tbArr[_loc1_] as GoodsBtnX).visible = false;
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            _loc1_++;
         }
      }
   }
}

