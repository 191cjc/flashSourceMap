package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.glevel.*;
   import hotpointgame.utils.gameloader.*;
   
   public class ActLevelC
   {
      
      private static var self:ActLevelC = new ActLevelC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var jsjiegeMc:MovieClip;
      
      private var mcMO:Object;
      
      private var _curlv:VT = VT.createVT(GS.a1);
      
      public function ActLevelC()
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
            if(!LoaderManager.isLoadedBySwfname("j_jieshaguaiwu"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("j_jieshaguaiwu");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("j_jieshaguaiwu") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.mcMO = new Object();
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["anniu1"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["anniu2"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["anniu3"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["anniu4"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["gwjsclose"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["gwjslanjie"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["gwjslanjieb"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["resure_0"]));
         this.mcMO["onlybtnz"] = _loc1_;
         this.flushButtonFlag();
         this.jsjiegeMc = this.mc["jsjiege"];
         this.jsjiegeMc.visible = false;
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.jsjiegeMc["jsok"]));
         _loc1_.addBtnLianDong(new McBtn(this.jsjiegeMc["jsnook"]));
         this.mcMO["jsjiegemcm"] = _loc1_;
         (this.mc["jsxzkc"] as MovieClip).visible = false;
         this.jsjiegeMc.addEventListener(MouseEvent.CLICK,this.jsjiegeclick);
         this.mc.addEventListener(MouseEvent.CLICK,this.mcclick);
         GM.cbGview.addChild(this.mc);
      }
      
      public function flushButtonFlag() : void
      {
         var _loc1_:MovieClip = this.mc["gwjsjuanga"];
         (_loc1_["gwjsgwtx"] as MovieClip).gotoAndStop((this.curlv - 1) * 2 + 1);
         var _loc2_:int = int(GM.levelSD.getAchByid(980 + (this.curlv - 1) * 2 + 1));
         var _loc3_:int = int(LevelDataManager.getLevelBD(980 + (this.curlv - 1) * 2 + 1).maxach);
         (_loc1_["gwjsdianshuzi"] as TextField).text = "" + _loc2_ + "/" + _loc3_;
         (_loc1_["gwjsxgxiaotiao"]["xgxiaotiaoa"] as MovieClip).scaleX = _loc2_ / _loc3_;
         _loc1_ = this.mc["gwjsjuangb"];
         (_loc1_["gwjsgwtx"] as MovieClip).gotoAndStop((this.curlv - 1) * 2 + 2);
         _loc2_ = int(GM.levelSD.getAchByid(980 + (this.curlv - 1) * 2 + 2));
         _loc3_ = int(LevelDataManager.getLevelBD(980 + (this.curlv - 1) * 2 + 2).maxach);
         (_loc1_["gwjsdianshuzi"] as TextField).text = "" + _loc2_ + "/" + _loc3_;
         (_loc1_["gwjsxgxiaotiao"]["xgxiaotiaoa"] as MovieClip).scaleX = _loc2_ / _loc3_;
         var _loc4_:McBtnLianDong = this.mcMO["onlybtnz"];
         _loc1_ = this.mc["gwjsjuanga"];
         var _loc5_:Boolean = Boolean(GM.aSaveData.jieshas.actOneIsOk());
         (_loc1_["gwjscgjs"] as MovieClip).visible = GM.aSaveData.jieshas.killmOneok((this.curlv - 1) * 2 + 1);
         if(!_loc5_)
         {
            _loc4_.getMcBtnByName("gwjslanjie").clickDisable();
         }
         else
         {
            _loc4_.getMcBtnByName("gwjslanjie").clickCancel();
         }
         _loc1_ = this.mc["gwjsjuangb"];
         _loc5_ = Boolean(GM.aSaveData.jieshas.actTwoIsOk());
         (_loc1_["gwjscgjs"] as MovieClip).visible = GM.aSaveData.jieshas.killmTwook((this.curlv - 1) * 2 + 2);
         if(!_loc5_)
         {
            _loc4_.getMcBtnByName("gwjslanjieb").clickDisable();
         }
         else
         {
            _loc4_.getMcBtnByName("gwjslanjieb").clickCancel();
         }
         if(GM.aSaveData.jieshas.actGodIsOk())
         {
            _loc4_.getMcBtnByName("resure_0").clickCancel();
         }
         else
         {
            _loc4_.getMcBtnByName("resure_0").clickDisable();
         }
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["onlybtnz"] as McBtnLianDong).remove();
            (this.mcMO["jsjiegemcm"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.jsjiegeMc.removeEventListener(MouseEvent.CLICK,this.jsjiegeclick);
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcclick);
            GM.cbGview.removeChild(this.mc);
            this.jsjiegeMc = null;
            this.mc = null;
         }
      }
      
      private function mcclick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["onlybtnz"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "gwjsclose":
                  close();
                  break;
               case "anniu1":
                  (this.mcMO["onlybtnz"] as McBtnLianDong).btnByClick(param1.target.name);
                  this.curlv = GS.a1;
                  this.flushButtonFlag();
                  break;
               case "anniu2":
                  (this.mcMO["onlybtnz"] as McBtnLianDong).btnByClick(param1.target.name);
                  this.curlv = GS.a2;
                  this.flushButtonFlag();
                  break;
               case "anniu3":
                  (this.mcMO["onlybtnz"] as McBtnLianDong).btnByClick(param1.target.name);
                  this.curlv = GS.a3;
                  this.flushButtonFlag();
                  break;
               case "anniu4":
                  (this.mcMO["onlybtnz"] as McBtnLianDong).btnByClick(param1.target.name);
                  this.curlv = GS.a4;
                  this.flushButtonFlag();
                  break;
               case "gwjslanjie":
                  if(!GM.loaderM.keYiUse())
                  {
                     return;
                  }
                  if(GM.aSaveData.jieshas.actOneIsOk())
                  {
                     GM.levelm.changeLevelDataByIdAndLs(GS.a980 + (this.curlv - GS.a1) * GS.a2 + GS.a1,1);
                     close();
                  }
                  break;
               case "gwjslanjieb":
                  if(!GM.loaderM.keYiUse())
                  {
                     return;
                  }
                  if(GM.aSaveData.jieshas.actTwoIsOk())
                  {
                     GM.levelm.changeLevelDataByIdAndLs(GS.a980 + (this.curlv - GS.a1) * GS.a2 + GS.a2,1);
                     close();
                  }
                  break;
               case "resure_0":
                  if(GM.aSaveData.jieshas.actGodIsOk())
                  {
                     this.jsjiegeMc.visible = true;
                  }
            }
         }
      }
      
      private function jsjiegeclick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["jsjiegemcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "jsok":
                  if(GM.aSaveData.jieshas.actGodIsOk())
                  {
                     this.jsjiegeMc.visible = false;
                     (this.mc["jsxzkc"] as MovieClip).visible = true;
                     GM.testapi.getStateAndBuyShopProp(GS.a800 + GS.a55,GS.a1,GS.a200,this.buyShopOver,GS.a0);
                  }
                  break;
               case "jsnook":
                  this.jsjiegeMc.visible = false;
            }
         }
      }
      
      private function buyShopOver(param1:int) : void
      {
         if((this.mc["jsxzkc"] as MovieClip).visible)
         {
            if(param1 == 0)
            {
               (this.mc["jsxzkc"] as MovieClip).visible = false;
            }
            else
            {
               GM.aSaveData.jieshas.addGodUseNum();
               GM.testapi.saveDataBeforeNoState();
               this.flushButtonFlag();
               (this.mc["jsxzkc"] as MovieClip).visible = false;
            }
            return;
         }
         GM.findCheatMax(GS.a48);
      }
      
      public function get curlv() : int
      {
         return this._curlv.getValue();
      }
      
      public function set curlv(param1:int) : void
      {
         this._curlv.setValue(param1);
      }
   }
}

