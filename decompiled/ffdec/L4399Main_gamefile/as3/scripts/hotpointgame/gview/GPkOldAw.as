package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.ginit.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GPkOldAw
   {
      
      private static var self:GPkOldAw = new GPkOldAw();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var danMc:MovieClip;
      
      private var mcMO:Object;
      
      public function GPkOldAw()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            GoodsManger.allPanelClose();
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
            if(!LoaderManager.isLoadedBySwfname("j_jingjiphjl"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("j_jingjiphjl");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("j_jingjiphjl") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.danMc = this.mc["dan"];
         this.mcMO = new Object();
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.danMc["pkclose"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["lqjl"]));
         this.mcMO["danMcMo"] = _loc1_;
         GM.testapi.getPkRoleInfoByOld();
         this.mc.addEventListener(Event.ENTER_FRAME,this.enterH);
         this.danMc.addEventListener(MouseEvent.CLICK,this.danmcH);
         GM.cbGview.addChild(this.mc);
      }
      
      private function enterH(param1:Event) : void
      {
         if(GM.aSaveData.pksd.oldpkrb != -GS.a1)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterH);
            (this.mc["pktk5"] as MovieClip).visible = false;
            this.initJmData();
         }
      }
      
      private function danmcH(param1:MouseEvent) : void
      {
         var _loc2_:PkOldAwardBD = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(param1.target.name != null && Boolean((this.mcMO["danMcMo"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "pkclose":
                  close();
                  break;
               case "lqjl":
                  if(GM.aSaveData.pksd.oldpkrb < GS.a1 || GM.aSaveData.pksd.oldpkrb > GS.a10000)
                  {
                     GoodsManger.cwTs("榜上无名呢，新赛季好好奋斗吧!");
                     return;
                  }
                  if(GM.aSaveData.pksd.oldawardfb != 0)
                  {
                     GoodsManger.cwTs("已取过奖励，这赛季结束再来吧!");
                     return;
                  }
                  _loc2_ = PkAwardBDManager.getOldAwardByRank(GM.aSaveData.pksd.oldpkrb);
                  if(_loc2_ != null)
                  {
                     _loc3_ = new Array();
                     _loc4_ = new Array();
                     if(FlowInterface.getJobByRole() == GS.a1)
                     {
                        if(_loc2_.awAman != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awAman);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awBman != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awBman);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awCman != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awCman);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awDman != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awDman);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awEman != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awEman);
                           _loc4_.push(GS.a1);
                        }
                        if(BagFactory.isFullBag(_loc3_,_loc4_))
                        {
                           GM.aSaveData.pksd.oldawardfb = GS.a1;
                           GM.aSaveData.pksd.oldawTitleb = _loc2_.id;
                           if(_loc2_.awAman != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awAman,GS.a1,0);
                           }
                           if(_loc2_.awBman != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awBman,GS.a1,_loc2_.awBmanLv);
                           }
                           if(_loc2_.awCman != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awCman,GS.a1,0);
                           }
                           if(_loc2_.awDman != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awDman,GS.a1,0);
                           }
                           if(_loc2_.awEman != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awEman,GS.a1,0);
                           }
                           GoodsManger.cwTs("奖励已进背包了，快去体验吧!");
                        }
                        else
                        {
                           GoodsManger.cwTs("背包已满!");
                        }
                     }
                     else
                     {
                        if(_loc2_.awAwom != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awAwom);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awBwom != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awBwom);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awCwom != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awCwom);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awDwom != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awDwom);
                           _loc4_.push(GS.a1);
                        }
                        if(_loc2_.awEwom != -GS.a1)
                        {
                           _loc3_.push(_loc2_.awEwom);
                           _loc4_.push(GS.a1);
                        }
                        if(BagFactory.isFullBag(_loc3_,_loc4_))
                        {
                           GM.aSaveData.pksd.oldawardfb = GS.a1;
                           GM.aSaveData.pksd.oldawTitleb = _loc2_.id;
                           if(_loc2_.awAwom != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awAwom,GS.a1,0);
                           }
                           if(_loc2_.awBwom != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awBwom,GS.a1,_loc2_.awBwomLv);
                           }
                           if(_loc2_.awCwom != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awCwom,GS.a1,0);
                           }
                           if(_loc2_.awDwom != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awDwom,GS.a1,0);
                           }
                           if(_loc2_.awEwom != -GS.a1)
                           {
                              BagFactory.addInBagById(_loc2_.awEwom,GS.a1,0);
                           }
                           GoodsManger.cwTs("奖励已进背包了，快去体验吧!");
                        }
                        else
                        {
                           GoodsManger.cwTs("背包已满!");
                        }
                     }
                  }
            }
         }
      }
      
      private function initJmData() : void
      {
         var _loc2_:PkOldAwardBD = null;
         (this.mc["pmsza"] as TextField).text = "" + GM.aSaveData.pksd.oldpkrb;
         var _loc1_:int = 1;
         while(_loc1_ < 9)
         {
            _loc2_ = PkAwardBDManager.getOldAwardBD(_loc1_);
            if(FlowInterface.getJobByRole() == GS.a1)
            {
               (this.mc["wjmz" + _loc1_] as TextField).text = "" + _loc2_.awDmans;
            }
            else
            {
               (this.mc["wjmz" + _loc1_] as TextField).text = "" + _loc2_.awDwoms;
            }
            if((this.mc["wjmz" + _loc1_] as TextField).text == "-1")
            {
               (this.mc["wjmz" + _loc1_] as TextField).text = "无";
            }
            _loc1_++;
         }
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["danMcMo"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterH);
            this.danMc.removeEventListener(MouseEvent.CLICK,this.danmcH);
            GM.cbGview.removeChild(this.mc);
            this.danMc = null;
            this.mc = null;
         }
      }
   }
}

