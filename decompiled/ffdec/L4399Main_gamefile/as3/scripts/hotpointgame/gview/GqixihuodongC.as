package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GqixihuodongC
   {
      
      private static var self:GqixihuodongC = new GqixihuodongC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var qixianniuMc:MovieClip;
      
      private var mcMO:Object;
      
      public function GqixihuodongC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc2_:Class = null;
         var _loc3_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("j_qixihuodong"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("j_qixihuodong");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("j_qixihuodong") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mcMO = new Object();
         this.qixianniuMc = this.mc["qixianniu"];
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.qixianniuMc["gwjsclose"]));
         _loc1_.addBtnLianDong(new McBtn(this.qixianniuMc["duihuan"]));
         _loc1_.addBtnLianDong(new McBtn(this.qixianniuMc["zhuanhuan"]));
         this.mcMO["qixianniu"] = _loc1_;
         (this.mc["wanjiaxzkcz"] as MovieClip).visible = false;
         this.flushchangenumf();
         this.mc.x = 0;
         this.mc.y = 0;
         this.qixianniuMc.addEventListener(MouseEvent.CLICK,this.qixianniuMcclick);
         GM.cbGview.addChild(this.mc);
      }
      
      public function flushchangenumf() : void
      {
         (this.mc["qxwba"] as TextField).text = "" + BagFactory.getNumById(511098) + "/40";
         (this.mc["qxwbb"] as TextField).text = "" + BagFactory.getNumById(511097) + "/40";
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.qixianniuMc.removeEventListener(MouseEvent.CLICK,this.qixianniuMcclick);
            (this.mcMO["qixianniu"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.qixianniuMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function qixianniuMcclick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["qixianniu"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "gwjsclose":
                  close();
                  break;
               case "duihuan":
                  if(BagFactory.getNumById(GS.a511098) < GS.a40 || BagFactory.getNumById(GS.a511097) < GS.a40)
                  {
                     GoodsManger.cwTs("集齐需求道具才可兑换!");
                     return;
                  }
                  if(!FlowInterface.isKeYiFangById(GS.a441000,GS.a1))
                  {
                     GoodsManger.cwTs("背包已满 !");
                     return;
                  }
                  if(Boolean(FlowInterface.redInBagDL(GS.a511098,GS.a40)) && Boolean(FlowInterface.redInBagDL(GS.a511097,GS.a40)))
                  {
                     BagFactory.addInBagById(GS.a441000,GS.a1,0);
                     this.flushchangenumf();
                     GoodsManger.cwTs("兑换成功!");
                     return;
                  }
                  break;
               case "zhuanhuan":
                  if(BagFactory.getNumById(GS.a441000) < GS.a1)
                  {
                     GoodsManger.cwTs("拥有烂漫之光才可转换!");
                     return;
                  }
                  if(GameShangChengC.self.dgMoney < GS.a100 * GS.a50 + GS.a200)
                  {
                     GoodsManger.cwTs("星钻不足!");
                     return;
                  }
                  if(!FlowInterface.isKeYiFangById(GS.a441001,GS.a1))
                  {
                     GoodsManger.cwTs("背包已满!");
                     return;
                  }
                  (this.mc["wanjiaxzkcz"] as MovieClip).visible = true;
                  GM.testapi.getStateAndBuyShopProp(GS.a600 + GS.a21,GS.a1,GS.a100 * GS.a50 + GS.a200,this.buyShopOver,GS.a0);
            }
         }
      }
      
      private function buyShopOver(param1:int) : void
      {
         if((this.mc["wanjiaxzkcz"] as MovieClip).visible)
         {
            if(param1 == 0)
            {
               (this.mc["wanjiaxzkcz"] as MovieClip).visible = false;
            }
            else
            {
               if(FlowInterface.redInBagDL(GS.a441000,GS.a1))
               {
                  BagFactory.addInBagById(GS.a441001,GS.a1,0);
                  GM.testapi.saveDataBeforeNoState();
                  GoodsManger.cwTs("转换成功!");
               }
               (this.mc["wanjiaxzkcz"] as MovieClip).visible = false;
            }
            return;
         }
         GM.findCheatMax(GS.a48);
      }
   }
}

