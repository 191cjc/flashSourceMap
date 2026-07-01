package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.ginit.*;
   import hotpointgame.glevel.*;
   import hotpointgame.glevel.leveldata.NewLevelShowBD;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.shipPanel.*;
   import hotpointgame.views.sxPanel.*;
   
   public class ClevelChooseNew
   {
      
      private static var self:ClevelChooseNew = new ClevelChooseNew();
      
      private static var curs:int = 0;
      
      private static var curChoose:int = 0;
      
      private static var curpage:int = 1;
      
      private var mc:MovieClip;
      
      private var xgMc:MovieClip;
      
      private var waiweiMc:MovieClip;
      
      private var neibuMc:MovieClip;
      
      private var waiweimax:int = 14;
      
      private var neibuimax:int = 29;
      
      private var mcMO:Object;
      
      private var _sxDisplay:SxPanel;
      
      public function ClevelChooseNew()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            curChoose = 0;
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public static function exitgame() : void
      {
         self.leave();
         curpage = 1;
         curChoose = 0;
      }
      
      public function reset() : void
      {
         var _loc2_:int = 0;
         var _loc6_:Class = null;
         var _loc7_:Array = null;
         var _loc8_:Class = null;
         var _loc9_:MovieClip = null;
         var _loc10_:McBtn = null;
         var _loc11_:McBtn = null;
         if(this.mc == null)
         {
            if(GM.aSaveData.nlevel.maxl == GS.a2)
            {
               GM.levelSD.addAch(GS.a2000 + GS.a2,0,GS.a1);
            }
            if(!LoaderManager.isLoadedBySwfname("j_yxzc"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc7_ = new Array();
                  _loc7_.push("j_yxzc");
                  _loc7_.push("t_box");
                  _loc7_.push("sxpanel");
                  GM.loaderM.setLoadData(_loc7_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc6_ = LoaderManager.getSwfClass("j_yxzc") as Class;
            this.mc = new _loc6_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.mcMO = new Object();
         this.xgMc = this.mc["xg"];
         this.xgMc.visible = false;
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.xgMc["guanbi"]));
         _loc1_.addBtnLianDong(new McBtn(this.xgMc["jinquzhanchang"]));
         this.mcMO["xgMcMo"] = _loc1_;
         _loc2_ = 1;
         while(_loc2_ < 10)
         {
            _loc8_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc9_ = new _loc8_() as MovieClip;
            _loc9_.mouseEnabled = false;
            _loc9_.mouseChildren = false;
            (_loc9_["mask_mc"] as MovieClip).visible = false;
            (_loc9_["d_mc"] as MovieClip).visible = false;
            (_loc9_["gx_mc"] as MovieClip).visible = false;
            _loc9_.name = "T_Box_one";
            _loc9_.gotoAndStop(1);
            (this.xgMc["bd_" + _loc2_] as MovieClip).addChild(_loc9_);
            _loc2_++;
         }
         this._sxDisplay = SxPanel.createSxpanel();
         this.mc.addChild(this._sxDisplay);
         this._sxDisplay.init();
         this.waiweiMc = this.mc["waiwei"];
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.waiweiMc["fanhuijide"]));
         var _loc3_:McBtn = new McBtn(this.waiweiMc["xuanxiang"]);
         if(GM.aSaveData.nlevel.maxl < this.waiweimax)
         {
            _loc3_.clickDisable();
         }
         _loc1_.addBtnLianDong(_loc3_);
         var _loc4_:int = 1;
         while(_loc4_ <= this.waiweimax)
         {
            _loc10_ = new McBtn(this.waiweiMc["yxgk" + _loc4_]);
            if(!GM.aSaveData.nlevel.isKeyJi(_loc4_))
            {
               _loc10_.clickDisable();
            }
            _loc1_.addBtnLianDong(_loc10_);
            _loc4_++;
         }
         this.mcMO["waiweiMcMo"] = _loc1_;
         this.neibuMc = this.mc["neibu"];
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.neibuMc["fanhuijide"]));
         _loc1_.addBtnLianDong(new McBtn(this.neibuMc["huidaowaiwei"]));
         var _loc5_:int = this.waiweimax + 1;
         while(_loc5_ <= this.neibuimax)
         {
            _loc11_ = new McBtn(this.neibuMc["yxgk" + _loc5_]);
            if(!GM.aSaveData.nlevel.isKeyJi(_loc5_))
            {
               _loc11_.clickDisable();
            }
            _loc1_.addBtnLianDong(_loc11_);
            _loc5_++;
         }
         this.mcMO["neibuMcMo"] = _loc1_;
         if(curpage == 1)
         {
            this.waiweiMc.visible = true;
            this.neibuMc.visible = false;
         }
         else
         {
            this.waiweiMc.visible = false;
            this.neibuMc.visible = true;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.xgMc.addEventListener(MouseEvent.CLICK,this.xgMcH);
         this.xgMc.addEventListener(MouseEvent.MOUSE_OVER,this.mcmoveovere);
         this.xgMc.addEventListener(MouseEvent.MOUSE_OUT,this.mcmoveoute);
         this.waiweiMc.addEventListener(MouseEvent.CLICK,this.waiweiMcH);
         this.neibuMc.addEventListener(MouseEvent.CLICK,this.neibuMcH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["xgMcMo"] as McBtnLianDong).remove();
            (this.mcMO["waiweiMcMo"] as McBtnLianDong).remove();
            (this.mcMO["neibuMcMo"] as McBtnLianDong).remove();
            this.mcMO = null;
            if(this._sxDisplay.parent)
            {
               this._sxDisplay.parent.removeChild(this._sxDisplay);
            }
            this._sxDisplay = null;
            this.xgMc.removeEventListener(MouseEvent.CLICK,this.xgMcH);
            this.xgMc.removeEventListener(MouseEvent.MOUSE_OVER,this.mcmoveovere);
            this.xgMc.removeEventListener(MouseEvent.MOUSE_OUT,this.mcmoveoute);
            this.waiweiMc.removeEventListener(MouseEvent.CLICK,this.waiweiMcH);
            this.neibuMc.removeEventListener(MouseEvent.CLICK,this.neibuMcH);
            this.xgMc = null;
            this.waiweiMc = null;
            this.neibuMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function waiweiMcH(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["waiweiMcMo"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            if(_loc2_ == "fanhuijide")
            {
               close();
            }
            else if(_loc2_ == "xuanxiang")
            {
               if(!(GM.aSaveData.nlevel.maxl >= this.waiweimax && (this.mcMO["waiweiMcMo"] as McBtnLianDong).getMcBtnByName(_loc2_).getcurstate() != 4))
               {
                  GoodsManger.cwTs("太危险了，再练练吧!");
               }
            }
            else if(_loc2_.indexOf("yxgk") == 0 && (this.mcMO["waiweiMcMo"] as McBtnLianDong).getMcBtnByName(_loc2_).getcurstate() != 4)
            {
               _loc3_ = int(_loc2_.substr(4));
               if(GM.aSaveData.nlevel.isKeyJi(_loc3_))
               {
                  curChoose = _loc3_;
                  this.flushlevelb();
               }
            }
         }
      }
      
      private function neibuMcH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["neibuMcMo"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "fanhuijide":
                  close();
                  break;
               case "huidaowaiwei":
                  this.waiweiMc.visible = true;
                  this.neibuMc.visible = false;
                  curpage = 1;
            }
         }
      }
      
      private function xgMcH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["xgMcMo"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "guanbi":
                  this.xgMc.visible = false;
                  curChoose = 0;
                  break;
               case "jinquzhanchang":
                  if(GM.aSaveData.nlevel.isKeyJi(curChoose))
                  {
                     if(!GM.loaderM.keYiUse())
                     {
                        GoodsManger.cwTs("加载中请稍后!");
                        return;
                     }
                     if(ShipData.tl.getValue() < GS.a2)
                     {
                        GoodsManger.cwTs("体力值不够了,至少要有2点!");
                        return;
                     }
                     if(curChoose != GS.a1)
                     {
                        if(GM.levelSD.getOverProcess(GS.a2000 + curChoose - GS.a1) < GS.a1)
                        {
                           GM.findCheatMax(GS.a72);
                           return;
                        }
                     }
                     GM.levelm.changeLevelDataByIdAndLs(GS.a2000 + curChoose,GS.a1);
                     this.leave();
                  }
            }
         }
      }
      
      private function flushlevelb() : void
      {
         var _loc1_:NewLevelShowBD = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Goods = null;
         if(GM.aSaveData.nlevel.isKeyJi(curChoose))
         {
            _loc1_ = LevelDataManager.getNewLevelBd(curChoose);
            if(_loc1_ == null)
            {
               GoodsManger.cwTs("暂未开放");
            }
            else
            {
               this.xgMc.visible = true;
               (this.xgMc["tuijzhandouli"] as TextField).text = _loc1_.suggAtt.toString();
               (this.xgMc["guanmc"] as MovieClip).gotoAndStop(curChoose);
               _loc2_ = _loc1_.awardArr;
               _loc3_ = 1;
               while(_loc3_ < 10)
               {
                  if(_loc2_[_loc3_ - 1] != null)
                  {
                     _loc4_ = FlowInterface.getGoodsById(_loc2_[_loc3_ - 1]);
                     (this.xgMc["bd_" + _loc3_].getChildByName("T_Box_one") as MovieClip).gotoAndStop(_loc4_.getFrame());
                  }
                  else
                  {
                     (this.xgMc["bd_" + _loc3_].getChildByName("T_Box_one") as MovieClip).gotoAndStop(1);
                  }
                  _loc3_++;
               }
            }
         }
         else
         {
            this.xgMc.visible = false;
         }
      }
      
      private function mcmoveovere(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:NewLevelShowBD = null;
         if(param1.target.name != null && (param1.target.name as String).indexOf("bg_") == 0)
         {
            _loc2_ = int((param1.target.name as String).slice(3));
            _loc3_ = LevelDataManager.getNewLevelBd(curChoose);
            if(_loc3_ != null)
            {
               if(_loc3_.awardArr[_loc2_ - 1] != null)
               {
                  Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,FlowInterface.getGoodsById(_loc3_.awardArr[_loc2_ - 1])));
               }
            }
         }
      }
      
      private function mcmoveoute(param1:MouseEvent) : void
      {
         if(param1.target.name != null && (param1.target.name as String).indexOf("bg_") == 0)
         {
            Main.self.dispatchEvent(new BtnEvent(BtnEvent.DO_OUT));
         }
      }
   }
}

