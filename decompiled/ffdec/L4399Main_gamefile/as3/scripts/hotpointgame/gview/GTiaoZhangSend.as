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
   
   public class GTiaoZhangSend
   {
      
      private static var self:GTiaoZhangSend = new GTiaoZhangSend();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var lhjjshiMc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      private var _chooseId:VT = VT.createVT(0);
      
      public function GTiaoZhangSend()
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
            if(!LoaderManager.isLoadedBySwfname("map_0_5"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("map_0_5");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("lfkjnpc") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.chooseId = 0;
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.lhjjshiMc = this.mc["lhjjshi"];
         this.lhjjshiMc.visible = false;
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.lhjjshiMc["okk_0"]));
         _loc1_.addBtnLianDong(new McBtn(this.lhjjshiMc["nokk_0"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["mc_1"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["mc_2"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["close_btn"]));
         this.mcMO["mcMO"] = _loc1_;
         (this.mc["txt"] as TextField).text = "" + GM.aSaveData.tztR.maxLevel;
         if(GM.aSaveData.tztR.maxLevel >= GS.a20)
         {
            (this.mc["mc_1"]["txt1"] as TextField).text = "" + GM.aSaveData.tztR.getSendLvMax();
            (this.mc["mc_1"]["txt2"] as TextField).text = "" + GM.aSaveData.tztR.getPNSendMax();
            (this.mc["mc_1"]["txt3"] as TextField).text = "" + GM.aSaveData.tztR.getSendGodMax();
         }
         else
         {
            (this.mc["mc_1"]["txt1"] as TextField).text = "?";
            (this.mc["mc_1"]["txt2"] as TextField).text = "?";
            (this.mc["mc_1"]["txt3"] as TextField).text = "?";
         }
         if(GM.aSaveData.tztR.maxLevel >= GS.a10)
         {
            (this.mc["mc_2"]["txt1"] as TextField).text = "" + GM.aSaveData.tztR.getSendLvMin();
            (this.mc["mc_2"]["txt2"] as TextField).text = "" + GM.aSaveData.tztR.getPNSendMin();
            (this.mc["mc_2"]["txt3"] as TextField).text = "" + GM.aSaveData.tztR.getSendGodMin();
         }
         else
         {
            (this.mc["mc_2"]["txt1"] as TextField).text = "?";
            (this.mc["mc_2"]["txt2"] as TextField).text = "?";
            (this.mc["mc_2"]["txt3"] as TextField).text = "?";
         }
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
            (this.mcMO["mcMO"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            this.lhjjshiMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.target.name != null && Boolean((this.mcMO["mcMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "okk_0":
                  if(this.chooseId == GS.a1)
                  {
                     if(FlowInterface.redInBagDL(GS.a331100 + GS.a51,GM.aSaveData.tztR.getPNSendMax()))
                     {
                        if(GM.cp.getGodByRole() >= GM.aSaveData.tztR.getSendGodMax())
                        {
                           GM.cp.redGodByRole(GM.aSaveData.tztR.getSendGodMax());
                           _loc2_ = new Object();
                           _loc2_.gqm = "裂缝空间";
                           _loc2_.cjm = "裂缝空间层数" + GM.aSaveData.tztR.getSendLvMax();
                           _loc2_.fjm = "裂缝空间层数" + GM.aSaveData.tztR.getSendLvMax() + "房间1";
                           _loc2_.x = GS.a200;
                           _loc2_.y = GS.a600;
                           _loc2_.ll = GS.a1;
                           GM.levelm.curLevel.changeSceneData(_loc2_);
                           close();
                           return;
                        }
                     }
                  }
                  else if(this.chooseId == GS.a2)
                  {
                     if(FlowInterface.redInBagDL(GS.a331100 + GS.a50,GM.aSaveData.tztR.getPNSendMin()))
                     {
                        if(GM.cp.getGodByRole() >= GM.aSaveData.tztR.getSendGodMin())
                        {
                           GM.cp.redGodByRole(GM.aSaveData.tztR.getSendGodMin());
                           _loc3_ = new Object();
                           _loc3_.gqm = "裂缝空间";
                           _loc3_.cjm = "裂缝空间层数" + GM.aSaveData.tztR.getSendLvMin();
                           _loc3_.fjm = "裂缝空间层数" + GM.aSaveData.tztR.getSendLvMin() + "房间1";
                           _loc3_.x = GS.a200;
                           _loc3_.y = GS.a600;
                           _loc3_.ll = GS.a1;
                           GM.levelm.curLevel.changeSceneData(_loc3_);
                           close();
                           return;
                        }
                     }
                  }
                  this.lhjjshiMc.visible = false;
                  break;
               case "nokk_0":
                  this.lhjjshiMc.visible = false;
                  break;
               case "mc_1":
                  if(GM.aSaveData.tztR.maxLevel >= GS.a20)
                  {
                     if(BagFactory.getNumById(GS.a331100 + GS.a51) >= GM.aSaveData.tztR.getPNSendMax())
                     {
                        if(GM.cp.getGodByRole() >= GM.aSaveData.tztR.getSendGodMax())
                        {
                           this.chooseId = GS.a1;
                           this.lhjjshiMc.visible = true;
                        }
                        else
                        {
                           GoodsManger.cwTs("晶币不够了，一层层打上去吧 !");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("高级空间宝石 数量不够, 一层层打上去吧 ! !");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("最高挑战记录没有达到 20 ");
                  }
                  break;
               case "mc_2":
                  if(GM.aSaveData.tztR.maxLevel >= GS.a10)
                  {
                     if(BagFactory.getNumById(GS.a331100 + GS.a50) >= GM.aSaveData.tztR.getPNSendMin())
                     {
                        if(GM.cp.getGodByRole() >= GM.aSaveData.tztR.getSendGodMin())
                        {
                           this.chooseId = GS.a2;
                           this.lhjjshiMc.visible = true;
                        }
                        else
                        {
                           GoodsManger.cwTs("晶币不够了，一层层打上去吧 !");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("低级空间宝石 数量不够, 一层层打上去吧 ! !");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("最高挑战记录没有达到 10 ");
                  }
                  break;
               case "close_btn":
                  close();
            }
         }
      }
      
      public function get chooseId() : int
      {
         return this._chooseId.getValue();
      }
      
      public function set chooseId(param1:int) : void
      {
         this._chooseId.setValue(param1);
      }
   }
}

