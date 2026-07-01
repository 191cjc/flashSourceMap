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
   import hotpointgame.views.everyDayPanel.*;
   
   public class CLevelChoose
   {
      
      private static var self:CLevelChoose = new CLevelChoose();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var xganniuMc:MovieClip;
      
      private var shennongMc:MovieClip;
      
      private var yonghengMc:MovieClip;
      
      private var guoduMc:MovieClip;
      
      private var aidArr:Array = [1,2,3,4,5];
      
      private var bidArr:Array = [6,7,8,9,10];
      
      private var cidArr:Array = [12,13,14,15,16];
      
      private var mcMO:Object = new Object();
      
      private var arrowObj:Object = new Object();
      
      private var memeda:int = 1;
      
      private var memshennong:int = 1;
      
      private var memshennonglevel:int = 1;
      
      private var memyongheng:int = 6;
      
      private var memyonghenglevel:int = 1;
      
      private var memguodu:int = 12;
      
      private var memguodulevel:int = 1;
      
      public function CLevelChoose()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            EveryDayPanel.close();
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
         self.memeda = 1;
         self.memshennong = 1;
         self.memshennonglevel = 1;
         self.memyongheng = 6;
         self.memyonghenglevel = 1;
         self.memguodu = 12;
         self.memguodulevel = 1;
      }
      
      public function reset() : void
      {
         var _loc6_:Class = null;
         var _loc7_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("xuanzeguanka"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc7_ = new Array();
                  _loc7_.push("xuanzeguanka");
                  GM.loaderM.setLoadData(_loc7_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc6_ = LoaderManager.getSwfClass("xuanzeguanka") as Class;
            this.mc = new _loc6_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         var _loc1_:int = int(GM.levelSD.getTotalAchByList(this.aidArr));
         var _loc2_:int = int(GM.levelSD.getTotalAchByList(this.bidArr));
         var _loc3_:int = int(GM.levelSD.getTotalAchByList(this.cidArr));
         this.arrowObj["shennong"] = new Object();
         this.shennongMc = this.mc["shennong"];
         this.initDaLevel(this.aidArr,this.shennongMc,this.memshennong,this.memshennonglevel,"shennong");
         this.arrowObj["yongheng"] = new Object();
         this.yonghengMc = this.mc["yongheng"];
         this.initDaLevel(this.bidArr,this.yonghengMc,this.memyongheng,this.memyonghenglevel,"yongheng");
         this.arrowObj["guodu"] = new Object();
         this.guoduMc = this.mc["guodu"];
         this.initDaLevel(this.cidArr,this.guoduMc,this.memguodu,this.memguodulevel,"guodu",2);
         this.xganniuMc = this.mc["xganniu"];
         var _loc4_:McBtnLianDong = new McBtnLianDong();
         _loc4_.addBtnNoLian(new McBtn(this.xganniuMc["fanhuijidi"]));
         _loc4_.addBtnLianDong(new McBtn(this.xganniuMc["xganniub"]));
         _loc4_.addBtnLianDong(new McBtn(this.xganniuMc["xganniuc"]));
         _loc4_.addBtnLianDong(new McBtn(this.xganniuMc["xganniud"]));
         (this.xganniuMc["xganniub"]["dianshuzi11"]["dianshuzi12"] as TextField).text = "" + _loc1_ + "/" + LevelDataManager.getTotalMaxAch(this.aidArr);
         (this.xganniuMc["xganniuc"]["dianshuzi11"]["dianshuzi12"] as TextField).text = "" + _loc2_ + "/" + LevelDataManager.getTotalMaxAch(this.bidArr);
         (this.xganniuMc["xganniud"]["dianshuzi11"]["dianshuzi12"] as TextField).text = "" + _loc3_ + "/" + LevelDataManager.getTotalMaxAch(this.cidArr);
         if(GM.levelSD.getOverProcess(6) == -1)
         {
            _loc4_.getMcBtnByName("xganniuc").clickDisable();
         }
         if(GM.levelSD.getOverProcess(12) == -1)
         {
            _loc4_.getMcBtnByName("xganniud").clickDisable();
         }
         switch(this.memeda)
         {
            case 1:
               this.shennongMc.visible = true;
               this.yonghengMc.visible = false;
               this.guoduMc.visible = false;
               _loc4_.btnByClick("xganniub");
               break;
            case 2:
               this.shennongMc.visible = false;
               this.yonghengMc.visible = true;
               this.guoduMc.visible = false;
               _loc4_.btnByClick("xganniuc");
               break;
            case 3:
               this.shennongMc.visible = false;
               this.yonghengMc.visible = false;
               this.guoduMc.visible = true;
               _loc4_.btnByClick("xganniud");
         }
         this.mcMO["xganniu"] = _loc4_;
         var _loc5_:TextField = this.mc["qianwangmudi"]["zhaoa"]["doorname"] as TextField;
         _loc5_.embedFonts = true;
         _loc5_.defaultTextFormat = new TextFormat(GM.fzfont.fontName);
         _loc5_.text = "" + GM.levelSD.getTotalAchAllLevel();
         this.xganniuMc.addEventListener(MouseEvent.CLICK,this.xganniuMcCH);
         this.shennongMc.addEventListener(MouseEvent.CLICK,this.shennongMcCH);
         this.yonghengMc.addEventListener(MouseEvent.CLICK,this.yonghengMcCH);
         this.guoduMc.addEventListener(MouseEvent.CLICK,this.guoduMcCH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.xganniuMc.removeEventListener(MouseEvent.CLICK,this.xganniuMcCH);
            this.shennongMc.removeEventListener(MouseEvent.CLICK,this.shennongMcCH);
            this.yonghengMc.removeEventListener(MouseEvent.CLICK,this.yonghengMcCH);
            this.guoduMc.removeEventListener(MouseEvent.CLICK,this.guoduMcCH);
            this.memshennonglevel = (this.arrowObj["shennong"]["" + this.memshennong] as McBtnArrow).getCur();
            this.memyonghenglevel = (this.arrowObj["yongheng"]["" + this.memyongheng] as McBtnArrow).getCur();
            this.memguodulevel = (this.arrowObj["guodu"]["" + this.memguodu] as McBtnArrow).getCur();
            for each(_loc1_ in this.aidArr)
            {
               (this.arrowObj["shennong"]["" + _loc1_] as McBtnArrow).remove();
            }
            for each(_loc2_ in this.bidArr)
            {
               (this.arrowObj["yongheng"]["" + _loc2_] as McBtnArrow).remove();
            }
            for each(_loc3_ in this.cidArr)
            {
               (this.arrowObj["guodu"]["" + _loc3_] as McBtnArrow).remove();
            }
            this.arrowObj = new Object();
            (this.mcMO["xganniu"] as McBtnLianDong).remove();
            (this.mcMO["shennong"] as McBtnLianDong).remove();
            (this.mcMO["yongheng"] as McBtnLianDong).remove();
            (this.mcMO["guodu"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.xganniuMc = null;
            this.shennongMc = null;
            this.yonghengMc = null;
            this.guoduMc = null;
            GM.cbGview.removeChild(this.mc);
         }
      }
      
      private function xganniuMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["xganniu"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "fanhuijidi":
                  GM.levelm.changeLevelBackCity();
                  this.leave();
                  return;
               case "xganniub":
                  if(this.memeda != 1)
                  {
                     this.memeda = 1;
                     (this.mcMO["xganniu"] as McBtnLianDong).btnByClick(param1.target.name);
                     this.shennongMc.visible = true;
                     this.yonghengMc.visible = false;
                     this.guoduMc.visible = false;
                  }
                  break;
               case "xganniuc":
                  if(this.memeda != 2)
                  {
                     if((this.mcMO["xganniu"] as McBtnLianDong).getMcBtnByName("xganniuc").getcurstate() != 4)
                     {
                        this.memeda = 2;
                        (this.mcMO["xganniu"] as McBtnLianDong).btnByClick(param1.target.name);
                        this.shennongMc.visible = false;
                        this.yonghengMc.visible = true;
                        this.guoduMc.visible = false;
                     }
                     else
                     {
                        GoodsManger.cwTs("满足神农祭坛才可进入!");
                     }
                  }
                  break;
               case "xganniud":
                  if(this.memeda != 3)
                  {
                     if((this.mcMO["xganniu"] as McBtnLianDong).getMcBtnByName("xganniud").getcurstate() != 4)
                     {
                        this.memeda = 3;
                        (this.mcMO["xganniu"] as McBtnLianDong).btnByClick(param1.target.name);
                        this.shennongMc.visible = false;
                        this.yonghengMc.visible = false;
                        this.guoduMc.visible = true;
                     }
                     else
                     {
                        GoodsManger.cwTs("通过裂缝空间20层才能进入");
                     }
                  }
            }
         }
      }
      
      private function initDaLevel(param1:Array, param2:MovieClip, param3:int, param4:int, param5:String, param6:int = 4) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc7_:McBtnLianDong = new McBtnLianDong();
         for each(_loc8_ in param1)
         {
            _loc9_ = int(GM.levelSD.getOverProcess(_loc8_));
            if(_loc9_ == -1)
            {
               (param2["shennong" + _loc8_] as MovieClip).gotoAndStop(4);
               (param2["shennong" + _loc8_ + "b"] as MovieClip).visible = false;
               (param2["shennong" + _loc8_ + "c"] as MovieClip).visible = false;
               (param2["shennong" + _loc8_ + "d"] as MovieClip).visible = false;
               (param2["shennong" + _loc8_ + "e"] as MovieClip).visible = false;
               (param2["shennong" + _loc8_ + "g"] as MovieClip).visible = false;
               (param2["shennong" + _loc8_ + "f"] as MovieClip).visible = false;
               this.arrowObj[param5]["" + _loc8_] = new McBtnArrow(param2["shennong" + _loc8_ + "d"] as MovieClip,_loc9_,param6);
            }
            else
            {
               _loc10_ = param3 == _loc8_ ? true : false;
               _loc7_.addBtnLianDong(new McBtn(param2["shennong" + _loc8_]));
               _loc7_.addBtnLianDong(new McBtn(param2["shennong" + _loc8_ + "c"]));
               if(_loc10_)
               {
                  (param2["shennong" + _loc8_ + "b"] as MovieClip).visible = true;
                  (param2["shennong" + _loc8_ + "c"] as MovieClip).visible = true;
                  (param2["shennong" + _loc8_ + "d"] as MovieClip).visible = true;
                  (param2["shennong" + _loc8_ + "e"] as MovieClip).visible = true;
                  (param2["shennong" + _loc8_ + "g"] as MovieClip).visible = true;
                  (param2["shennong" + _loc8_ + "f"] as MovieClip).visible = true;
                  _loc7_.btnByClick("shennong" + _loc8_);
               }
               else
               {
                  (param2["shennong" + _loc8_ + "b"] as MovieClip).visible = true;
                  (param2["shennong" + _loc8_ + "c"] as MovieClip).visible = false;
                  (param2["shennong" + _loc8_ + "d"] as MovieClip).visible = false;
                  (param2["shennong" + _loc8_ + "e"] as MovieClip).visible = false;
                  (param2["shennong" + _loc8_ + "g"] as MovieClip).visible = false;
                  (param2["shennong" + _loc8_ + "f"] as MovieClip).visible = false;
               }
               _loc11_ = int(GM.levelSD.getAchByid(_loc8_));
               _loc12_ = int(LevelDataManager.getLevelBD(_loc8_).maxach);
               (param2["shennong" + _loc8_ + "c"]["dianshuzi1"] as TextField).text = "" + _loc11_ + "/" + _loc12_;
               (param2["shennong" + _loc8_ + "c"]["xgxiaotiao"]["xgxiaotiaoa"] as MovieClip).scaleX = _loc11_ / _loc12_;
               this.arrowObj[param5]["" + _loc8_] = new McBtnArrow(param2["shennong" + _loc8_ + "d"] as MovieClip,_loc9_,param6);
               if(_loc10_)
               {
                  (this.arrowObj[param5]["" + _loc8_] as McBtnArrow).changeCur(param4);
               }
            }
            _loc7_.addBtnLianDong(new McBtn(param2["shennong" + _loc8_ + "f"]));
         }
         this.mcMO[param5] = _loc7_;
      }
      
      private function levelMcCH(param1:String, param2:MovieClip, param3:String, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 != null && Boolean((this.mcMO[param3] as McBtnLianDong).isFlase(param1)))
         {
            if(!isNaN(Number(param1.substr(-1,1))))
            {
               _loc5_ = int(param1.substr(8));
               _loc6_ = 0;
               switch(param4)
               {
                  case 1:
                     _loc6_ = int(this.memshennong);
                     break;
                  case 2:
                     _loc6_ = int(this.memyongheng);
                     break;
                  case 3:
                     _loc6_ = int(this.memguodu);
               }
               if(_loc6_ != _loc5_)
               {
                  (param2["shennong" + _loc5_ + "b"] as MovieClip).visible = true;
                  (param2["shennong" + _loc5_ + "c"] as MovieClip).visible = true;
                  (param2["shennong" + _loc5_ + "d"] as MovieClip).visible = true;
                  (param2["shennong" + _loc5_ + "e"] as MovieClip).visible = true;
                  (param2["shennong" + _loc5_ + "g"] as MovieClip).visible = true;
                  (param2["shennong" + _loc5_ + "f"] as MovieClip).visible = true;
                  (param2["shennong" + _loc6_ + "b"] as MovieClip).visible = true;
                  (param2["shennong" + _loc6_ + "c"] as MovieClip).visible = false;
                  (param2["shennong" + _loc6_ + "d"] as MovieClip).visible = false;
                  (param2["shennong" + _loc6_ + "e"] as MovieClip).visible = false;
                  (param2["shennong" + _loc6_ + "g"] as MovieClip).visible = false;
                  (param2["shennong" + _loc6_ + "f"] as MovieClip).visible = false;
                  switch(param4)
                  {
                     case 1:
                        this.memshennong = _loc5_;
                        break;
                     case 2:
                        this.memyongheng = _loc5_;
                        break;
                     case 3:
                        this.memguodu = _loc5_;
                  }
                  (this.mcMO[param3] as McBtnLianDong).btnByClick(param1);
               }
               return;
            }
            if(param1.substr(-1,1) == "c" || param1.substr(-1,1) == "f")
            {
               if(!GM.loaderM.keYiUse())
               {
                  GoodsManger.cwTs("加载中请稍后!");
                  return;
               }
               _loc7_ = param1.substr(0,param1.length - 1);
               _loc8_ = int(_loc7_.substr(8));
               _loc9_ = int((this.arrowObj[param3]["" + _loc8_] as McBtnArrow).getCur());
               _loc10_ = int(GM.levelSD.getOverProcess(_loc8_));
               if(_loc10_ == -1)
               {
                  GM.findCheatMax(GS.a20);
                  return;
               }
               if(_loc10_ + 1 < _loc9_)
               {
                  GM.findCheatMax(GS.a21);
                  return;
               }
               _loc11_ = int(LevelDataManager.getLevelBD(_loc8_).enterpid);
               if(_loc11_ != 0)
               {
                  if(!FlowInterface.redInBagDL(_loc11_,GS.a1))
                  {
                     GoodsManger.cwTs("副本挑战券不足!");
                     return;
                  }
                  GM.testapi.saveDataBefore();
               }
               if(param1.substr(-1,1) == "c")
               {
                  GM.levelm.changeLevelDataByIdAndLs(_loc8_,_loc9_);
               }
               else
               {
                  GM.levelm.changeLevelDataByIdAndLs(_loc8_ + GS.a100,GS.a1);
               }
               this.leave();
               return;
            }
         }
      }
      
      private function shennongMcCH(param1:MouseEvent) : void
      {
         this.levelMcCH(param1.target.name,this.shennongMc,"shennong",1);
      }
      
      private function yonghengMcCH(param1:MouseEvent) : void
      {
         this.levelMcCH(param1.target.name,this.yonghengMc,"yongheng",2);
      }
      
      private function guoduMcCH(param1:MouseEvent) : void
      {
         this.levelMcCH(param1.target.name,this.guoduMc,"guodu",3);
      }
      
      private function rollOverHshennong(param1:MouseEvent) : void
      {
         this.rollOverMcf(param1.target.name,this.shennongMc,"shennong");
      }
      
      private function rollOutHshennong(param1:MouseEvent) : void
      {
         this.rollOutMcf(param1.target.name,this.shennongMc,"shennong");
      }
      
      private function rollOverHyongheng(param1:MouseEvent) : void
      {
         this.rollOverMcf(param1.target.name,this.yonghengMc,"yongheng");
      }
      
      private function rollOutHyongheng(param1:MouseEvent) : void
      {
         this.rollOutMcf(param1.target.name,this.yonghengMc,"yongheng");
      }
      
      private function rollOverHguodu(param1:MouseEvent) : void
      {
         this.rollOverMcf(param1.target.name,this.guoduMc,"guodu");
      }
      
      private function rollOutHguodu(param1:MouseEvent) : void
      {
         this.rollOutMcf(param1.target.name,this.guoduMc,"guodu");
      }
      
      private function rollOverMcf(param1:String, param2:MovieClip, param3:String) : void
      {
         var _loc4_:int = 0;
         if(param1 != null && Boolean((this.mcMO[param3] as McBtnLianDong).isFlase(param1)))
         {
            if(param1.substr(-1,1) == "e")
            {
               _loc4_ = int(param1.substr(8,param1.length - 1));
               (param2["shennong" + _loc4_ + "f"] as MovieClip).gotoAndPlay(1);
               (param2["shennong" + _loc4_ + "f"] as MovieClip).visible = true;
            }
         }
      }
      
      private function rollOutMcf(param1:String, param2:MovieClip, param3:String) : void
      {
         var _loc4_:int = 0;
         if(param1 != null && Boolean((this.mcMO[param3] as McBtnLianDong).isFlase(param1)))
         {
            if(param1.substr(-1,1) == "e")
            {
               _loc4_ = int(param1.substr(8,param1.length - 1));
               (param2["shennong" + _loc4_ + "f"] as MovieClip).visible = false;
            }
         }
      }
   }
}

