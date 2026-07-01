package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.glevel.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.savedatal.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.zppanel.*;
   
   public class Gshiershengxiao
   {
      
      private static var self:Gshiershengxiao = new Gshiershengxiao();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var sedaaMc:MovieClip;
      
      private var sedabMc:MovieClip;
      
      private var sedacMc:MovieClip;
      
      private var setankuangaMc:MovieClip;
      
      private var daxuankuangMc:MovieClip;
      
      private var setankuangcdMc:MovieClip;
      
      private var setankuangceMc:MovieClip;
      
      private var curpage:int = 1;
      
      private var mcMO:Object;
      
      private var curlevelid:int = 0;
      
      private var cursxid:int = 0;
      
      public function Gshiershengxiao()
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
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["sedaa"] as McBtnLianDong).remove();
            (this.mcMO["sedab"] as McBtnLianDong).remove();
            (this.mcMO["sedac"] as McBtnLianDong).remove();
            (this.mcMO["setankuanga"] as McBtnLianDong).remove();
            (this.mcMO["daxuankuang"] as McBtnLianDong).remove();
            (this.mcMO["setankuangcd"] as McBtnLianDong).remove();
            (this.mcMO["setankuangce"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.sedaaMc.removeEventListener(MouseEvent.CLICK,this.sedaaMcclick);
            this.sedabMc.removeEventListener(MouseEvent.CLICK,this.sedabMcclick);
            this.sedacMc.removeEventListener(MouseEvent.CLICK,this.sedacMcclick);
            this.setankuangaMc.removeEventListener(MouseEvent.CLICK,this.setankuangaMcclick);
            this.daxuankuangMc.removeEventListener(MouseEvent.CLICK,this.daxuankuangMcclick);
            this.daxuankuangMc.removeEventListener(MouseEvent.MOUSE_OVER,this.daxuankuangMcOver);
            this.daxuankuangMc.removeEventListener(MouseEvent.MOUSE_OUT,this.daxuankuangMcOut);
            this.setankuangcdMc.removeEventListener(MouseEvent.CLICK,this.setankuangcdMcclick);
            this.setankuangceMc.removeEventListener(MouseEvent.CLICK,this.setankuangceMcclick);
            this.sedaaMc = null;
            this.sedabMc = null;
            this.sedacMc = null;
            this.setankuangaMc = null;
            this.daxuankuangMc = null;
            this.setankuangcdMc = null;
            this.setankuangceMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      public function reset() : void
      {
         var _loc8_:Class = null;
         var _loc9_:Array = null;
         var _loc10_:TwelveDuiHuanBaseData = null;
         var _loc11_:Class = null;
         var _loc12_:MovieClip = null;
         var _loc13_:ShengxiaoDouHun = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("j_shiershengxiao"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc9_ = new Array();
                  _loc9_.push("j_shiershengxiao");
                  _loc9_.push("t_box");
                  GM.loaderM.setLoadData(_loc9_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc8_ = LoaderManager.getSwfClass("j_shiershengxiao") as Class;
            this.mc = new _loc8_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.mcMO = new Object();
         this.sedaaMc = this.mc["sedaa"];
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.sedaaMc["segw1"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedaaMc["segw2"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedaaMc["segw3"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedaaMc["segw4"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedaaMc["segw5"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedaaMc["segw6"]));
         this.mcMO["sedaa"] = _loc1_;
         this.sedabMc = this.mc["sedab"];
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.sedabMc["scclose"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedabMc["sefanyeshang"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedabMc["sefanyexia"]));
         _loc1_.addBtnLianDong(new McBtn(this.sedabMc["sxzp"]));
         this.mcMO["sedab"] = _loc1_;
         this.sedacMc = this.mc["sedac"];
         _loc1_ = new McBtnLianDong();
         var _loc2_:int = 1;
         while(_loc2_ <= TwelveShengXiaoMangager.getDHGeNum())
         {
            _loc10_ = TwelveShengXiaoMangager.getDHBaseNumById(_loc2_);
            _loc1_.addBtnLianDong(new McBtn(this.sedacMc["seduihuan" + _loc2_]));
            _loc11_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc12_ = new _loc11_() as MovieClip;
            _loc12_.mouseEnabled = false;
            _loc12_.mouseChildren = false;
            (_loc12_["mask_mc"] as MovieClip).visible = false;
            (_loc12_["d_mc"] as MovieClip).visible = false;
            (_loc12_["gx_mc"] as MovieClip).visible = false;
            _loc12_.gotoAndStop(_loc10_.pfnum);
            (this.mc["seduihuan" + _loc2_]["sek0"] as MovieClip).addChild(_loc12_);
            (this.mc["seduihuan" + _loc2_]["sesu"] as TextField).text = "" + _loc10_.pgod;
            _loc2_++;
         }
         var _loc3_:int = TwelveShengXiaoMangager.getDHGeNum() + 1;
         while(_loc3_ <= 6)
         {
            (this.sedacMc["seduihuan" + _loc3_] as MovieClip).visible = false;
            (this.mc["seduihuan" + _loc3_] as MovieClip).visible = false;
            _loc3_++;
         }
         this.mcMO["sedac"] = _loc1_;
         this.setankuangaMc = this.mc["setankuanga"];
         this.setankuangaMc.visible = false;
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.setankuangaMc["seok"]));
         _loc1_.addBtnLianDong(new McBtn(this.setankuangaMc["senook"]));
         this.mcMO["setankuanga"] = _loc1_;
         this.daxuankuangMc = this.mc["daxuankuang"];
         _loc1_ = new McBtnLianDong();
         var _loc4_:int = 1;
         while(_loc4_ <= TwelveShengXiaoMangager.getDouHuanNum())
         {
            _loc13_ = GM.aSaveData.sxiaolevel.getsxDataByid(_loc4_);
            _loc1_.addBtnLianDong(new McBtn(this.daxuankuangMc["sexuanzhong" + _loc4_]));
            _loc4_++;
         }
         var _loc5_:int = TwelveShengXiaoMangager.getDouHuanNum() + GS.a1;
         while(_loc5_ <= GS.a12)
         {
            (this.daxuankuangMc["sexuanzhong" + _loc5_] as MovieClip).visible = false;
            _loc5_++;
         }
         this.flushDouHuan();
         this.mcMO["daxuankuang"] = _loc1_;
         this.setankuangcdMc = this.mc["setankuangcd"];
         this.setankuangcdMc.visible = false;
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.setankuangcdMc["sccloseb"]));
         _loc1_.addBtnLianDong(new McBtn(this.setankuangcdMc["jinfeng"]));
         _loc1_.addBtnLianDong(new McBtn(this.setankuangcdMc["ronghuadouhun"]));
         _loc1_.addBtnLianDong(new McBtn(this.setankuangcdMc["shengjie"]));
         var _loc6_:Class = LoaderManager.getSwfClass("T_Box") as Class;
         var _loc7_:MovieClip = new _loc6_() as MovieClip;
         _loc7_.name = "tu1345i";
         _loc7_.mouseEnabled = false;
         _loc7_.mouseChildren = false;
         (_loc7_["mask_mc"] as MovieClip).visible = false;
         (_loc7_["d_mc"] as MovieClip).visible = false;
         (_loc7_["gx_mc"] as MovieClip).visible = false;
         _loc7_.gotoAndStop(1346);
         (this.setankuangcdMc["sek1"] as MovieClip).addChild(_loc7_);
         _loc7_ = new _loc6_() as MovieClip;
         _loc7_.mouseEnabled = false;
         _loc7_.mouseChildren = false;
         (_loc7_["mask_mc"] as MovieClip).visible = false;
         (_loc7_["d_mc"] as MovieClip).visible = false;
         (_loc7_["gx_mc"] as MovieClip).visible = false;
         _loc7_.gotoAndStop(1707);
         (this.setankuangcdMc["sek2"] as MovieClip).addChild(_loc7_);
         this.mcMO["setankuangcd"] = _loc1_;
         this.setankuangceMc = this.mc["setankuangce"];
         this.setankuangceMc.visible = false;
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.setankuangceMc["seok"]));
         _loc1_.addBtnLianDong(new McBtn(this.setankuangceMc["senook"]));
         this.mcMO["setankuangce"] = _loc1_;
         (this.mc["seyeshubddd"] as TextField).text = "" + GM.aSaveData.sxiaodata.getkeyiusenum();
         (this.mc["seyeshubddd"] as TextField).embedFonts = true;
         (this.mc["seyeshubddd"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,20,16777215));
         (this.mc["setishi"] as MovieClip).visible = GM.aSaveData.sxiaodata.getkeyiusenum() == 0 ? true : false;
         (this.mc["scyeshu"] as TextField).text = "" + GM.aSaveData.sxiaodata.sxvalue;
         (this.mc["setankuangb"] as MovieClip).visible = false;
         (this.mc["semiaoshu"] as MovieClip).visible = false;
         (this.mc["sexzkc"] as MovieClip).visible = false;
         this.showpageConent();
         this.sedaaMc.addEventListener(MouseEvent.CLICK,this.sedaaMcclick);
         this.sedabMc.addEventListener(MouseEvent.CLICK,this.sedabMcclick);
         this.sedacMc.addEventListener(MouseEvent.CLICK,this.sedacMcclick);
         this.setankuangaMc.addEventListener(MouseEvent.CLICK,this.setankuangaMcclick);
         this.daxuankuangMc.addEventListener(MouseEvent.CLICK,this.daxuankuangMcclick);
         this.daxuankuangMc.addEventListener(MouseEvent.MOUSE_OVER,this.daxuankuangMcOver);
         this.daxuankuangMc.addEventListener(MouseEvent.MOUSE_OUT,this.daxuankuangMcOut);
         this.setankuangcdMc.addEventListener(MouseEvent.CLICK,this.setankuangcdMcclick);
         this.setankuangceMc.addEventListener(MouseEvent.CLICK,this.setankuangceMcclick);
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         GM.cbGview.addChild(this.mc);
      }
      
      private function flushDouHuan() : void
      {
         var _loc3_:ShengxiaoDouHun = null;
         var _loc1_:int = 1;
         while(_loc1_ <= TwelveShengXiaoMangager.getDouHuanNum())
         {
            _loc3_ = GM.aSaveData.sxiaolevel.getsxDataByid(_loc1_);
            (this.mc["sedh" + _loc1_] as TextField).text = "Lv." + _loc3_.curlevel;
            (this.mc["sedh" + _loc1_] as TextField).embedFonts = true;
            (this.mc["sedh" + _loc1_] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,11,DiaoLouGoods.cArr[_loc3_.curColor]));
            (this.mc["douhun" + _loc1_] as MovieClip).gotoAndStop(_loc3_.curColor + 3);
            (this.mc["shanguang" + _loc1_] as MovieClip).visible = _loc3_.isKeYiAddExp();
            _loc1_++;
         }
         var _loc2_:int = TwelveShengXiaoMangager.getDouHuanNum() + GS.a1;
         while(_loc2_ <= GS.a12)
         {
            (this.mc["sedh" + _loc2_] as TextField).text = "";
            (this.mc["douhun" + _loc2_] as MovieClip).gotoAndStop(1);
            (this.mc["shanguang" + _loc2_] as MovieClip).visible = false;
            _loc2_++;
         }
      }
      
      private function showpageConent() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         (this.mc["seyeshu"] as TextField).text = "" + this.curpage + "/2";
         var _loc1_:int = 1;
         while(_loc1_ <= 6)
         {
            _loc2_ = _loc1_;
            if(this.curpage == 2)
            {
               _loc2_ += 6;
            }
            _loc3_ = int(GM.levelSD.getOverProcess(1000 + _loc2_));
            if(_loc3_ == -1)
            {
               this.showLevelConent(this.mc["se" + _loc1_],13,0,999999,0);
               (this.sedaaMc["segw" + _loc1_] as MovieClip).visible = false;
            }
            else
            {
               this.showLevelConent(this.mc["se" + _loc1_],_loc2_,GM.levelSD.getAchByid(1000 + _loc2_),LevelDataManager.getLevelBD(1000 + _loc2_).maxach,LevelDataManager.getLevelBD(1000 + _loc2_).passach);
               (this.sedaaMc["segw" + _loc1_] as MovieClip).visible = true;
            }
            _loc1_++;
         }
      }
      
      private function showLevelConent(param1:MovieClip, param2:int, param3:int, param4:int, param5:int) : void
      {
         (param1["gwjsgwtx"] as MovieClip).gotoAndStop(param2);
         (param1["gwjsdianshuzi"] as TextField).text = "" + param3 + "/" + param4;
         (param1["gwjsxgxiaotiao"]["xgxiaotiaoa"] as MovieClip).scaleX = param3 / param4;
         (param1["jinguanquanxian"] as MovieClip).x = 65 + 110 * param5 / param4;
      }
      
      private function showXianZhuan() : void
      {
         this.setankuangaMc.visible = true;
         (this.setankuangaMc["sezia"] as TextField).text = "消耗" + GM.aSaveData.sxiaodata.nextShopvalue() + "星钻可获得再次挑战机会，并且掉落物品奖励提升";
         (this.setankuangaMc["sezia"] as TextField).embedFonts = true;
         (this.setankuangaMc["sezia"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,17,16777215));
      }
      
      private function initDuiHuanGood() : void
      {
      }
      
      private function sedaaMcclick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["sedaa"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(4));
            if(this.curpage == 2)
            {
               _loc3_ += 6;
            }
            _loc3_ += 1000;
            this.curlevelid = _loc3_;
            if(GM.levelSD.getOverProcess(_loc3_) == -GS.a1)
            {
               return;
            }
            if(GM.aSaveData.sxiaodata.getkeyiusenum() > 0)
            {
               if(!GM.loaderM.keYiUse())
               {
                  return;
               }
               GM.levelm.changeLevelDataByIdAndLs(_loc3_,GS.a1);
               this.leave();
            }
            else
            {
               this.showXianZhuan();
            }
         }
      }
      
      private function sedabMcclick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["sedab"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "scclose":
                  this.leave();
                  break;
               case "sxzp":
                  this.leave();
                  Zppanel.open();
                  break;
               case "sefanyeshang":
                  if(this.curpage == 1)
                  {
                     this.curpage = 2;
                  }
                  else
                  {
                     this.curpage = 1;
                  }
                  this.showpageConent();
                  break;
               case "sefanyexia":
                  if(this.curpage == 1)
                  {
                     this.curpage = 2;
                  }
                  else
                  {
                     this.curpage = 1;
                  }
                  this.showpageConent();
            }
         }
      }
      
      private function sedacMcclick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:TwelveDuiHuanBaseData = null;
         if(param1.target.name != null && Boolean((this.mcMO["sedac"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(9));
            _loc4_ = TwelveShengXiaoMangager.getDHBaseNumById(_loc3_);
            if(_loc4_.pgod > GM.aSaveData.sxiaodata.sxvalue)
            {
               GoodsManger.cwTs("生肖幻灵不足!");
               return;
            }
            if(!FlowInterface.isKeYiFangById(_loc4_.pid,GS.a1))
            {
               GoodsManger.cwTs("背包已满!");
               return;
            }
            GM.aSaveData.sxiaodata.redsxvalue(_loc4_.pgod);
            BagFactory.addInBagById(_loc4_.pid,GS.a1,0);
            (this.mc["scyeshu"] as TextField).text = "" + GM.aSaveData.sxiaodata.sxvalue;
         }
      }
      
      private function setankuangaMcclick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["setankuanga"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "seok":
                  if(GM.aSaveData.sxiaodata.nextShopvalue() > GameShangChengC.self.dgMoney)
                  {
                     GoodsManger.cwTs("星钻不足!");
                     return;
                  }
                  if(!GM.loaderM.keYiUse())
                  {
                     return;
                  }
                  this.setankuangaMc.visible = false;
                  (this.mc["sexzkc"] as MovieClip).visible = true;
                  GM.testapi.getStateAndBuyShopProp(GM.aSaveData.sxiaodata.nextShopPid(),GS.a1,GM.aSaveData.sxiaodata.nextShopvalue(),this.buyShopOver,GS.a0);
                  return;
                  break;
               case "senook":
                  this.setankuangaMc.visible = false;
            }
         }
      }
      
      private function buyShopOver(param1:int) : void
      {
         if((this.mc["sexzkc"] as MovieClip).visible)
         {
            if(param1 == 0)
            {
               (this.mc["sexzkc"] as MovieClip).visible = false;
               return;
            }
            GM.aSaveData.sxiaodata.usedgshop();
            GM.testapi.saveDataBeforeNoState();
            (this.mc["sexzkc"] as MovieClip).visible = false;
            if(GM.levelSD.getOverProcess(this.curlevelid) == -GS.a1)
            {
               this.leave();
               return;
            }
            if(!GM.loaderM.keYiUse())
            {
               return;
            }
            GM.levelm.changeLevelDataByIdAndLs(this.curlevelid,GS.a3);
            this.leave();
            return;
         }
         GM.findCheatMax(GS.a48);
      }
      
      private function daxuankuangMcclick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["daxuankuang"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(11));
            this.cursxid = _loc3_;
            this.flushdouhunUpLevel(_loc3_);
            this.setankuangcdMc.visible = true;
         }
      }
      
      private function flushdouhunUpLevel(param1:int) : void
      {
         var _loc2_:ShengxiaoDouHun = GM.aSaveData.sxiaolevel.getsxDataByid(param1);
         (this.setankuangcdMc["sename"] as TextField).text = _loc2_.getName();
         (this.setankuangcdMc["seziblv"] as TextField).text = "" + _loc2_.curlevel;
         (this.setankuangcdMc["sezibdouhui"] as TextField).text = "" + _loc2_.curExp + "/" + _loc2_.getNextExp();
         if(param1 == 8)
         {
            (this.setankuangcdMc["sezibcuratt"] as TextField).text = "" + _loc2_.getAttBName() + ":" + Number(_loc2_.getAddatt() / 100).toFixed(2) + "%";
            (this.setankuangcdMc["sezibnexatt"] as TextField).text = "" + _loc2_.getAttBName() + ":" + Number(_loc2_.getNextAddatt() / 100).toFixed(2) + "%";
         }
         else
         {
            (this.setankuangcdMc["sezibcuratt"] as TextField).text = "" + _loc2_.getAttBName() + ":" + _loc2_.getAddatt().toFixed(2);
            (this.setankuangcdMc["sezibnexatt"] as TextField).text = "" + _loc2_.getAttBName() + ":" + _loc2_.getNextAddatt().toFixed(2);
         }
         ((this.setankuangcdMc["sek1"] as MovieClip).getChildByName("tu1345i") as MovieClip).gotoAndStop(1345 + param1);
         (this.setankuangcdMc["sename"] as TextField).embedFonts = true;
         (this.setankuangcdMc["seziblv"] as TextField).embedFonts = true;
         (this.setankuangcdMc["sezibdouhui"] as TextField).embedFonts = true;
         (this.setankuangcdMc["sezibcuratt"] as TextField).embedFonts = true;
         (this.setankuangcdMc["sezibnexatt"] as TextField).embedFonts = true;
         (this.setankuangcdMc["sename"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,20,DiaoLouGoods.cArr[_loc2_.curColor]));
         (this.setankuangcdMc["seziblv"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14,DiaoLouGoods.cArr[_loc2_.curColor]));
         (this.setankuangcdMc["sezibdouhui"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14,DiaoLouGoods.cArr[_loc2_.curColor]));
         (this.setankuangcdMc["sezibcuratt"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14,DiaoLouGoods.cArr[_loc2_.curColor]));
         (this.setankuangcdMc["sezibnexatt"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14,DiaoLouGoods.cArr[_loc2_.curColor]));
         (this.setankuangcdMc["sejngbi"] as TextField).text = "" + BagFactory.getNumById(_loc2_.getUpPid()) + "/1";
         (this.setankuangcdMc["sedouhunshu"] as TextField).text = "" + _loc2_.getUpGod();
         (this.setankuangcdMc["sejngbi"] as TextField).embedFonts = true;
         (this.setankuangcdMc["sedouhunshu"] as TextField).embedFonts = true;
         (this.setankuangcdMc["sejngbi"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14,DiaoLouGoods.cArr[_loc2_.curColor]));
         (this.setankuangcdMc["sedouhunshu"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14,DiaoLouGoods.cArr[_loc2_.curColor]));
         if(_loc2_.isKeYiChColor())
         {
            (this.setankuangcdMc["jinfeng"] as MovieClip).visible = true;
         }
         else
         {
            (this.setankuangcdMc["jinfeng"] as MovieClip).visible = false;
         }
         if(_loc2_.isDaoLeLevelUP())
         {
            if(_loc2_.isKeYiUpLimit())
            {
               (this.setankuangcdMc["shengjie"] as MovieClip).visible = true;
            }
            else
            {
               (this.setankuangcdMc["shengjie"] as MovieClip).visible = false;
            }
         }
         else
         {
            (this.setankuangcdMc["shengjie"] as MovieClip).visible = false;
         }
      }
      
      private function daxuankuangMcOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:ShengxiaoDouHun = null;
         if(param1.target.name != null && Boolean((this.mcMO["daxuankuang"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(11));
            _loc4_ = GM.aSaveData.sxiaolevel.getsxDataByid(_loc3_);
            (this.mc["semiaoshu"]["sname"] as TextField).text = "" + _loc4_.getName() + " Lv." + _loc4_.curlevel;
            (this.mc["semiaoshu"]["wux"] as TextField).text = "" + _loc4_.getAttBName() + ":" + _loc4_.getAddatt();
            (this.mc["semiaoshu"]["cdcd"] as TextField).text = "" + _loc4_.curExp + "/" + _loc4_.getNextExp();
            (this.mc["semiaoshu"]["sname"] as TextField).embedFonts = true;
            (this.mc["semiaoshu"]["wux"] as TextField).embedFonts = true;
            (this.mc["semiaoshu"]["cdcd"] as TextField).embedFonts = true;
            (this.mc["semiaoshu"]["sname"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,11,DiaoLouGoods.cArr[_loc4_.curColor]));
            (this.mc["semiaoshu"]["wux"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,11,DiaoLouGoods.cArr[_loc4_.curColor]));
            (this.mc["semiaoshu"]["cdcd"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,11,DiaoLouGoods.cArr[_loc4_.curColor]));
            (this.mc["semiaoshu"] as MovieClip).visible = true;
         }
      }
      
      private function daxuankuangMcOut(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["daxuankuang"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mc["semiaoshu"] as MovieClip).visible = false;
         }
      }
      
      private function setankuangcdMcclick(param1:MouseEvent) : void
      {
         var _loc2_:ShengxiaoDouHun = null;
         var _loc3_:ShengxiaoDouHun = null;
         var _loc4_:ShengxiaoDouHun = null;
         if(param1.target.name != null && Boolean((this.mcMO["setankuangcd"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "sccloseb":
                  this.setankuangcdMc.visible = false;
                  this.flushDouHuan();
                  break;
               case "jinfeng":
                  _loc2_ = GM.aSaveData.sxiaolevel.getsxDataByid(this.cursxid);
                  if(!_loc2_.isKeYiChColor())
                  {
                     return;
                  }
                  if(BagFactory.getNumById(_loc2_.getChColorXuPid()) < GS.a1)
                  {
                     if(_loc2_.getChColorXuPid() == 331088)
                     {
                        GoodsManger.cwTs("拥有低级斗魂石才可升阶斗魂品质!");
                     }
                     else if(_loc2_.getChColorXuPid() == 331089)
                     {
                        GoodsManger.cwTs("拥有中级斗魂石才可升阶斗魂品质!");
                     }
                     else if(_loc2_.getChColorXuPid() == 331090)
                     {
                        GoodsManger.cwTs("拥有高级斗魂石才可升阶斗魂品质!");
                     }
                     return;
                  }
                  if(FlowInterface.redInBagDL(_loc2_.getChColorXuPid(),GS.a1))
                  {
                     _loc2_.addColor();
                     this.flushdouhunUpLevel(this.cursxid);
                  }
                  break;
               case "ronghuadouhun":
                  _loc3_ = GM.aSaveData.sxiaolevel.getsxDataByid(this.cursxid);
                  if(_loc3_.isDaoLeLevelUP())
                  {
                     GoodsManger.cwTs("已达等级上限无法继续提升等级!");
                     return;
                  }
                  if(_loc3_.getUpGod() > GM.cp.getGodByRole())
                  {
                     GoodsManger.cwTs("晶币不足!");
                     return;
                  }
                  if(BagFactory.getNumById(_loc3_.getUpPid()) < GS.a1)
                  {
                     GoodsManger.cwTs("需求道具不足!");
                     return;
                  }
                  if(FlowInterface.redInBagDL(_loc3_.getUpPid(),GS.a1))
                  {
                     GM.cp.redGodByRole(_loc3_.getUpGod());
                     _loc3_.addExp();
                     this.flushdouhunUpLevel(this.cursxid);
                  }
                  break;
               case "shengjie":
                  _loc4_ = GM.aSaveData.sxiaolevel.getsxDataByid(this.cursxid);
                  if(!_loc4_.isKeYiUpLimit())
                  {
                     GoodsManger.cwTs("已达等级上限无法继续提升等级!");
                     return;
                  }
                  this.fulshsetankuangceMc(_loc4_.getUpLimitXuMoney());
                  this.setankuangceMc.visible = true;
            }
         }
      }
      
      private function fulshsetankuangceMc(param1:int) : void
      {
         (this.setankuangceMc["sezib"] as TextField).text = "" + "是否消耗" + param1 + "星钻提升等级上限";
         (this.setankuangceMc["sezib"] as TextField).embedFonts = true;
         (this.setankuangceMc["sezib"] as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,16,16777215));
      }
      
      private function setankuangceMcclick(param1:MouseEvent) : void
      {
         var _loc2_:ShengxiaoDouHun = null;
         if(param1.target.name != null && Boolean((this.mcMO["setankuangce"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "seok":
                  _loc2_ = GM.aSaveData.sxiaolevel.getsxDataByid(this.cursxid);
                  if(!_loc2_.isKeYiUpLimit())
                  {
                     GoodsManger.cwTs("已达等级上限无法继续提升等级!");
                     return;
                  }
                  if(_loc2_.getUpLimitXuMoney() > GameShangChengC.self.dgMoney)
                  {
                     GoodsManger.cwTs("星钻不足!");
                     return;
                  }
                  this.setankuangceMc.visible = false;
                  (this.mc["sexzkc"] as MovieClip).visible = true;
                  GM.testapi.getStateAndBuyShopProp(_loc2_.getUpLimitXuPId(),GS.a1,_loc2_.getUpLimitXuMoney(),this.buyShopOverb,GS.a0);
                  break;
               case "senook":
                  this.setankuangceMc.visible = false;
            }
         }
      }
      
      private function buyShopOverb(param1:int) : void
      {
         var _loc2_:ShengxiaoDouHun = null;
         if((this.mc["sexzkc"] as MovieClip).visible)
         {
            if(param1 == 0)
            {
               (this.mc["sexzkc"] as MovieClip).visible = false;
            }
            else
            {
               _loc2_ = GM.aSaveData.sxiaolevel.getsxDataByid(this.cursxid);
               _loc2_.addUplimitOk();
               GM.testapi.saveDataBeforeNoState();
               this.flushdouhunUpLevel(this.cursxid);
               (this.mc["sexzkc"] as MovieClip).visible = false;
            }
            return;
         }
         GM.findCheatMax(GS.a48);
      }
   }
}

