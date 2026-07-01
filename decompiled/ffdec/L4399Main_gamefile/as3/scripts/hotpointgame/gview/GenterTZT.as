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
   
   public class GenterTZT
   {
      
      private static var self:GenterTZT = new GenterTZT();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var pktk3Mc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      public function GenterTZT()
      {
         super();
      }
      
      public static function open() : void
      {
         GoodsManger.allPanelClose();
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
            if(!LoaderManager.isLoadedBySwfname("map_0_0"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("map_0_0");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("j_lfmm") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.pktk3Mc = this.mc["pktk3"];
         this.pktk3Mc.visible = false;
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.pktk3Mc["okk_0"]));
         _loc1_.addBtnLianDong(new McBtn(this.pktk3Mc["nokk_0"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["resure5"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["gwjsclose"]));
         (this.mc["name1"] as TextField).text = "" + GM.aSaveData.tztR.enterNum + "/2次";
         (this.mc["name2"] as TextField).text = "" + GM.aSaveData.tztR.enterNumb + "/1次";
         (this.mc["name3"] as TextField).text = "" + GM.aSaveData.tztR.maxLevel;
         (this.mc["name4"] as TextField).text = "" + BagFactory.getNumById(GS.a331100 + GS.a52) + "/1";
         this.mcMO["pktk3MO"] = _loc1_;
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["pktk3MO"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            this.pktk3Mc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["pktk3MO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "okk_0":
                  if(GM.aSaveData.tztR.enterNumb == 0)
                  {
                     if(FlowInterface.redInBagDL(GS.a331100 + GS.a52,GS.a1))
                     {
                        GM.aSaveData.tztR.addNumb();
                        GM.testapi.saveDataBefore();
                        GM.levelm.changeLevelDataByIdAndLs(GS.a9997,GS.a1);
                        close();
                        return;
                     }
                  }
                  this.pktk3Mc.visible = false;
                  break;
               case "nokk_0":
                  this.pktk3Mc.visible = false;
                  break;
               case "resure5":
                  if(GM.aSaveData.tztR.enterNum >= GS.a2)
                  {
                     if(GM.aSaveData.tztR.enterNumb == 0)
                     {
                        if(BagFactory.getNumById(GS.a331100 + GS.a52) >= GS.a1)
                        {
                           this.pktk3Mc.visible = true;
                        }
                        else
                        {
                           GoodsManger.cwTs("去找一颗 空间宝石 再来试试吧!");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("明天再来试试吧!");
                     }
                  }
                  else
                  {
                     GM.aSaveData.tztR.addNum();
                     GM.levelm.changeLevelDataByIdAndLs(GS.a9997,GS.a1);
                     close();
                  }
                  break;
               case "gwjsclose":
                  close();
            }
         }
      }
   }
}

