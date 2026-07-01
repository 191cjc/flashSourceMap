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
   
   public class GCongSPet
   {
      
      private static var self:GCongSPet = new GCongSPet();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var mcMO:Object;
      
      public function GCongSPet()
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
            if(!LoaderManager.isLoadedBySwfname("j_czscw"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("j_czscw");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("j_czscw") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["pktk5"] as MovieClip).visible = true;
         if(GM.testapi.summerVchongGod < GS.a0)
         {
            GM.testapi.getChongeSummerV();
         }
         this.mcMO = new Object();
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnNoLian(new McBtn(this.mc["lq"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["xx"]));
         this.mcMO["onlybtnz"] = _loc1_;
         this.mc.addEventListener(Event.ENTER_FRAME,this.enterHandle);
         this.mc.addEventListener(MouseEvent.CLICK,this.mcclick);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["onlybtnz"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterHandle);
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcclick);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function showjiemian() : void
      {
         (this.mc["ljcz"] as TextField).text = "" + GM.testapi.summerVchongGod;
         if(Boolean(GM.aSaveData.summervd.isKYDatab()) && GS.a30000 <= GM.testapi.summerVchongGod)
         {
            (this.mcMO["onlybtnz"] as McBtnLianDong).getMcBtnByName("lq").clickCancel();
         }
         else
         {
            (this.mcMO["onlybtnz"] as McBtnLianDong).getMcBtnByName("lq").clickDisable();
         }
      }
      
      private function enterHandle(param1:Event) : void
      {
         if(GM.testapi.summerVchongGod >= GS.a0)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterHandle);
            this.showjiemian();
            (this.mc["pktk5"] as MovieClip).visible = false;
         }
      }
      
      private function mcclick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["onlybtnz"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "lq":
                  if(Boolean(GM.aSaveData.summervd.isKYDatab()) && GS.a30000 <= GM.testapi.summerVchongGod)
                  {
                     if(FlowInterface.isKeYiFangById(GS.a331358 + GS.a40,GS.a1))
                     {
                        BagFactory.addInBagById(GS.a331358 + GS.a40,GS.a1,0);
                        GM.aSaveData.summervd.databSave();
                        GM.testapi.saveDataBefore();
                        this.showjiemian();
                        GoodsManger.cwTs("已领取成功!");
                        return;
                     }
                     GoodsManger.cwTs("背包已满 !");
                     return;
                  }
                  break;
               case "xx":
                  close();
            }
         }
      }
   }
}

