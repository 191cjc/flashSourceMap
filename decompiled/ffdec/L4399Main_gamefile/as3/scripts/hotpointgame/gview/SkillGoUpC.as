package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gskilllevel.SkillLevel;
   import hotpointgame.utils.gameloader.*;
   
   public class SkillGoUpC
   {
      
      private static var self:SkillGoUpC = new SkillGoUpC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var menuMc:MovieClip;
      
      private var baseMc:MovieClip;
      
      private var wuxinMc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      private var npcBtn:McBtn;
      
      private var bid:int = 0;
      
      private var wid:int = 0;
      
      private var memda:int = 1;
      
      private var memwuxi:int = 1;
      
      private var membase:int = 1;
      
      public function SkillGoUpC()
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
      
      public static function exitgame() : void
      {
         self.memda = 1;
         self.memwuxi = 1;
         self.membase = 1;
         close();
      }
      
      public function reset() : void
      {
         var _loc13_:Class = null;
         var _loc14_:Array = null;
         var _loc15_:SkillLevel = null;
         var _loc16_:Array = null;
         var _loc17_:MovieClip = null;
         var _loc18_:McBtn = null;
         var _loc19_:int = 0;
         var _loc20_:SkillLevel = null;
         var _loc21_:Array = null;
         var _loc22_:MovieClip = null;
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:String = "";
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            _loc1_ = "jsyptjj";
            _loc2_ = "jsywxyjn";
            _loc3_ = "j_jndhny";
         }
         else if(FlowInterface.getJobByRole() == GS.a2)
         {
            _loc1_ = "jseptjj";
            _loc2_ = "jsewxyjn";
            _loc3_ = "j_jndhne";
         }
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname(_loc3_))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc14_ = new Array();
                  _loc14_.push("zhiyejineng");
                  if(FlowInterface.getJobByRole() == GS.a1)
                  {
                     _loc14_.push("j_jndhny");
                  }
                  else if(FlowInterface.getJobByRole() == GS.a2)
                  {
                     _loc14_.push("j_jndhne");
                  }
                  GM.loaderM.setLoadData(_loc14_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc13_ = LoaderManager.getSwfClass("zhiyejineng") as Class;
            this.mc = new _loc13_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.bid = 0;
         this.wid = 0;
         this.mc.x = 0;
         this.mc.y = 0;
         var _loc4_:int = int(GM.cp.getGodByRole());
         (this.mc["jn4"] as TextField).text = "" + _loc4_;
         (this.mc["achvalue"] as TextField).text = "" + GM.levelSD.getTotalAchAllLevel();
         (this.mc["jinengmiaoshu"] as MovieClip).visible = false;
         (this.mc["jinengmiaoshu"] as MovieClip).x = 230;
         this.menuMc = this.mc["jnannjiu"];
         var _loc5_:McBtnLianDong = new McBtnLianDong();
         _loc5_.addBtnLianDong(new McBtn(this.menuMc["zhiyejineng"]));
         _loc5_.addBtnLianDong(new McBtn(this.menuMc["wuxingjineng"]));
         _loc5_.addBtnLianDong(new McBtn(this.menuMc["guanbi"]));
         if(this.memda == 1)
         {
            _loc5_.btnByClick("zhiyejineng");
         }
         else
         {
            _loc5_.btnByClick("wuxingjineng");
         }
         this.mcMO["menuMc"] = _loc5_;
         (this.mc["jnnpcduihua"]["jnduihua"] as TextField).embedFonts = true;
         (this.mc["jnnpcduihua"]["jnduihua"] as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName);
         this.baseMc = this.mc["zhiyeheji"];
         _loc5_ = new McBtnLianDong();
         var _loc6_:McBtn = new McBtn(this.baseMc["jnxuexi"]);
         _loc5_.addBtnNoLian(_loc6_);
         _loc5_.addBtnNoLian(new McBtn(this.baseMc["jnbofang"]));
         (this.baseMc["dhxuexichengong"] as MovieClip).gotoAndStop(1);
         var _loc7_:Class = LoaderManager.getSwfClass(_loc1_) as Class;
         var _loc8_:MovieClip = new _loc7_() as MovieClip;
         _loc8_.name = "cDHBase";
         (this.baseMc["jndonghuayanshi"] as MovieClip).addChild(_loc8_);
         var _loc9_:int = 1;
         while(_loc9_ < 8)
         {
            _loc15_ = GM.skillLvM.getBSkillLevelById(_loc9_);
            _loc5_.addBtnLianDong(new McBtn(this.baseMc["zhiyetubiao" + _loc9_]));
            (this.baseMc["zhiyetubiao" + _loc9_]["jizhen"] as MovieClip).gotoAndStop(_loc15_.getslbd().tubiaoF);
            (this.baseMc["zhiyetubiao" + _loc9_]["jiname"] as TextField).text = _loc15_.getslbd().name;
            (this.baseMc["zhiyetubiao" + _loc9_]["lname"] as TextField).text = "Lv." + _loc15_.curLevel;
            if(_loc15_.isUp())
            {
               (this.baseMc["zhiyetubiao" + _loc9_]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
               (this.baseMc["zhiyetubiao" + _loc9_]["lname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
            }
            else
            {
               (this.baseMc["zhiyetubiao" + _loc9_]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
               (this.baseMc["zhiyetubiao" + _loc9_]["lname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
            }
            if(_loc9_ == this.membase)
            {
               (this.baseMc["jn1"] as TextField).text = "" + _loc15_.getslbd().upach;
               (this.baseMc["jn2"] as TextField).text = "" + _loc15_.getslbd().upgod;
               (this.baseMc["jn3"] as TextField).text = "" + _loc15_.getslbd().upplv;
               (this.baseMc["jn4"] as TextField).text = "" + _loc15_.getslbd().keyc;
               _loc16_ = _loc15_.isUpArr();
               if(_loc16_[0] == 0)
               {
                  (this.baseMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.baseMc["weimanzu1"] as MovieClip).visible = true;
               }
               else
               {
                  (this.baseMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.baseMc["weimanzu1"] as MovieClip).visible = false;
               }
               if(_loc16_[1] == 0)
               {
                  (this.baseMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.baseMc["weimanzu2"] as MovieClip).visible = true;
               }
               else
               {
                  (this.baseMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.baseMc["weimanzu2"] as MovieClip).visible = false;
               }
               if(_loc16_[2] == 0)
               {
                  (this.baseMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.baseMc["weimanzu3"] as MovieClip).visible = true;
               }
               else
               {
                  (this.baseMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.baseMc["weimanzu3"] as MovieClip).visible = false;
               }
               (this.mc["jnnpcduihua"]["jnduihua"] as TextField).text = "" + _loc15_.getslbd().npctalkall();
               _loc17_ = (this.baseMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHBase") as MovieClip;
               _loc17_.gotoAndStop(_loc15_.getslbd().donghuaF);
               (_loc17_["zyjndh"] as MovieClip).gotoAndStop(1);
               if(!_loc15_.isUp())
               {
                  _loc6_.clickDisable();
               }
               this.bid = this.membase;
            }
            _loc9_++;
         }
         _loc5_.btnByClick("zhiyetubiao" + this.membase);
         this.mcMO["baseMc"] = _loc5_;
         this.npcBtn = new McBtn(this.mc["jnnpc"]);
         (this.mc["npcflashf"] as MovieClip).mouseChildren = false;
         (this.mc["npcflashf"] as MovieClip).enabled = false;
         (this.mc["npcflashf"] as MovieClip).mouseEnabled = false;
         this.wuxinMc = this.mc["wuxingheji"];
         _loc5_ = new McBtnLianDong();
         var _loc10_:Class = LoaderManager.getSwfClass(_loc2_) as Class;
         var _loc11_:MovieClip = new _loc10_() as MovieClip;
         _loc11_.name = "cDHWx";
         (this.wuxinMc["jndonghuayanshi"] as MovieClip).addChild(_loc11_);
         var _loc12_:Array = GM.skillLvM.youXueWX();
         if(_loc12_.length > 0)
         {
            if(_loc12_.indexOf(this.memwuxi) == -1)
            {
               this.memwuxi = _loc12_[0];
            }
            (this.wuxinMc["wqjjwkts"] as MovieClip).visible = false;
            (this.wuxinMc["jnxuexi"] as MovieClip).visible = true;
            _loc18_ = new McBtn(this.wuxinMc["jnxuexi"]);
            _loc5_.addBtnNoLian(_loc18_);
            _loc5_.addBtnNoLian(new McBtn(this.wuxinMc["jnbofang"]));
            (this.wuxinMc["dhxuexichengong"] as MovieClip).gotoAndStop(1);
            _loc19_ = 1;
            while(_loc19_ < 5)
            {
               _loc20_ = GM.skillLvM.getWXSkillLevelById(_loc19_);
               if(_loc20_ != null)
               {
                  (this.wuxinMc["wuxingtubiao" + _loc19_] as MovieClip).visible = true;
                  _loc5_.addBtnLianDong(new McBtn(this.wuxinMc["wuxingtubiao" + _loc19_]));
                  (this.wuxinMc["wuxingtubiao" + _loc19_]["jizhen"] as MovieClip).gotoAndStop(_loc20_.getslbd().tubiaoF);
                  (this.wuxinMc["wuxingtubiao" + _loc19_]["jiname"] as TextField).text = _loc20_.getslbd().name;
                  (this.wuxinMc["wuxingtubiao" + _loc19_]["lname"] as TextField).text = "Lv." + _loc20_.curLevel;
                  if(_loc20_.isUp())
                  {
                     (this.wuxinMc["wuxingtubiao" + _loc19_]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
                     (this.wuxinMc["wuxingtubiao" + _loc19_]["lname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
                  }
                  else
                  {
                     (this.wuxinMc["wuxingtubiao" + _loc19_]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
                     (this.wuxinMc["wuxingtubiao" + _loc19_]["lname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
                  }
                  if(_loc19_ == this.memwuxi)
                  {
                     (this.wuxinMc["jn1"] as TextField).text = "" + _loc20_.getslbd().upach;
                     (this.wuxinMc["jn2"] as TextField).text = "" + _loc20_.getslbd().upgod;
                     (this.wuxinMc["jn3"] as TextField).text = "" + _loc20_.getslbd().upplv;
                     (this.wuxinMc["jn4"] as TextField).text = "" + _loc20_.getslbd().keyc;
                     _loc21_ = _loc20_.isUpArr();
                     if(_loc21_[0] == 0)
                     {
                        (this.wuxinMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                        (this.wuxinMc["weimanzu1"] as MovieClip).visible = true;
                     }
                     else
                     {
                        (this.wuxinMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                        (this.wuxinMc["weimanzu1"] as MovieClip).visible = false;
                     }
                     if(_loc21_[1] == 0)
                     {
                        (this.wuxinMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                        (this.wuxinMc["weimanzu2"] as MovieClip).visible = true;
                     }
                     else
                     {
                        (this.wuxinMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                        (this.wuxinMc["weimanzu2"] as MovieClip).visible = false;
                     }
                     if(_loc21_[2] == 0)
                     {
                        (this.wuxinMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                        (this.wuxinMc["weimanzu3"] as MovieClip).visible = true;
                     }
                     else
                     {
                        (this.wuxinMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                        (this.wuxinMc["weimanzu3"] as MovieClip).visible = false;
                     }
                     (this.mc["jnnpcduihua"]["jnduihua"] as TextField).text = "" + _loc20_.getslbd().npctalkall();
                     _loc22_ = (this.wuxinMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHWx") as MovieClip;
                     _loc22_.gotoAndStop(_loc20_.getslbd().donghuaF);
                     (_loc22_["zyjndh"] as MovieClip).gotoAndStop(1);
                     if(!_loc20_.isUp())
                     {
                        _loc18_.clickDisable();
                     }
                     this.wid = this.memwuxi;
                  }
               }
               else
               {
                  (this.wuxinMc["wuxingtubiao" + _loc19_] as MovieClip).visible = false;
               }
               _loc19_++;
            }
            _loc5_.btnByClick("wuxingtubiao" + this.memwuxi);
         }
         else
         {
            (this.wuxinMc["wqjjwkts"] as MovieClip).visible = true;
            (this.wuxinMc["wuxingtubiao1"] as MovieClip).visible = false;
            (this.wuxinMc["wuxingtubiao2"] as MovieClip).visible = false;
            (this.wuxinMc["wuxingtubiao3"] as MovieClip).visible = false;
            (this.wuxinMc["wuxingtubiao4"] as MovieClip).visible = false;
            (this.wuxinMc["jn1"] as TextField).text = "";
            (this.wuxinMc["jn2"] as TextField).text = "";
            (this.wuxinMc["jn3"] as TextField).text = "";
            (this.wuxinMc["jnxuexi"] as MovieClip).visible = false;
            (this.wuxinMc["dhxuexichengong"] as MovieClip).gotoAndStop(1);
         }
         this.mcMO["wuxinMc"] = _loc5_;
         if(this.memda == 1)
         {
            this.baseMc.visible = true;
            this.wuxinMc.visible = false;
         }
         else
         {
            this.baseMc.visible = false;
            this.wuxinMc.visible = true;
         }
         this.menuMc.addEventListener(MouseEvent.CLICK,this.menuMcH);
         this.baseMc.addEventListener(MouseEvent.CLICK,this.baseMcH);
         this.baseMc.addEventListener(MouseEvent.MOUSE_OVER,this.rollOverH);
         this.baseMc.addEventListener(MouseEvent.MOUSE_OUT,this.rollOutH);
         (this.mc["jnnpc"] as MovieClip).addEventListener(MouseEvent.CLICK,this.npcClick);
         this.wuxinMc.addEventListener(MouseEvent.CLICK,this.wuxinMcH);
         this.wuxinMc.addEventListener(MouseEvent.MOUSE_OVER,this.wxrollOverH);
         this.wuxinMc.addEventListener(MouseEvent.MOUSE_OUT,this.wxrollOutH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["menuMc"] as McBtnLianDong).remove();
            (this.mcMO["baseMc"] as McBtnLianDong).remove();
            (this.mcMO["wuxinMc"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.npcBtn.remove();
            this.npcBtn = null;
            this.menuMc.removeEventListener(MouseEvent.CLICK,this.menuMcH);
            this.baseMc.removeEventListener(MouseEvent.CLICK,this.baseMcH);
            this.baseMc.removeEventListener(MouseEvent.MOUSE_OVER,this.rollOverH);
            this.baseMc.removeEventListener(MouseEvent.MOUSE_OUT,this.rollOutH);
            (this.mc["jnnpc"] as MovieClip).removeEventListener(MouseEvent.CLICK,this.npcClick);
            this.wuxinMc.removeEventListener(MouseEvent.CLICK,this.wuxinMcH);
            this.wuxinMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wxrollOverH);
            this.wuxinMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wxrollOutH);
            this.menuMc = null;
            this.baseMc = null;
            this.wuxinMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function menuMcH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["menuMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "zhiyejineng":
                  this.memda = 1;
                  (this.mcMO["menuMc"] as McBtnLianDong).btnByClick(param1.target.name);
                  this.baseMc.visible = true;
                  this.wuxinMc.visible = false;
                  break;
               case "wuxingjineng":
                  this.memda = 2;
                  (this.mcMO["menuMc"] as McBtnLianDong).btnByClick(param1.target.name);
                  this.baseMc.visible = false;
                  this.wuxinMc.visible = true;
                  break;
               case "guanbi":
                  this.leave();
            }
         }
      }
      
      private function baseMcH(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:SkillLevel = null;
         var _loc5_:Array = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:SkillLevel = null;
         var _loc10_:Array = null;
         if(param1.target.name != null && Boolean((this.mcMO["baseMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            if(_loc2_.length > 11)
            {
               (this.mcMO["baseMc"] as McBtnLianDong).btnByClick(param1.target.name);
               _loc3_ = int(_loc2_.substr(11));
               this.bid = _loc3_;
               this.membase = _loc3_;
               _loc4_ = GM.skillLvM.getBSkillLevelById(_loc3_);
               (this.baseMc["jn1"] as TextField).text = "" + _loc4_.getslbd().upach;
               (this.baseMc["jn2"] as TextField).text = "" + _loc4_.getslbd().upgod;
               (this.baseMc["jn3"] as TextField).text = "" + _loc4_.getslbd().upplv;
               (this.baseMc["jn4"] as TextField).text = "" + _loc4_.getslbd().keyc;
               _loc5_ = _loc4_.isUpArr();
               if(_loc5_[0] == 0)
               {
                  (this.baseMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.baseMc["weimanzu1"] as MovieClip).visible = true;
               }
               else
               {
                  (this.baseMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.baseMc["weimanzu1"] as MovieClip).visible = false;
               }
               if(_loc5_[1] == 0)
               {
                  (this.baseMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.baseMc["weimanzu2"] as MovieClip).visible = true;
               }
               else
               {
                  (this.baseMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.baseMc["weimanzu2"] as MovieClip).visible = false;
               }
               if(_loc5_[2] == 0)
               {
                  (this.baseMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.baseMc["weimanzu3"] as MovieClip).visible = true;
               }
               else
               {
                  (this.baseMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.baseMc["weimanzu3"] as MovieClip).visible = false;
               }
               (this.mc["jnnpcduihua"]["jnduihua"] as TextField).text = "" + _loc4_.getslbd().npctalkall();
               if(_loc4_.isUp())
               {
                  (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickBy();
               }
               else
               {
                  (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickDisable();
               }
               _loc6_ = (this.baseMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHBase") as MovieClip;
               _loc6_.gotoAndStop(_loc4_.getslbd().donghuaF);
               (_loc6_["zyjndh"] as MovieClip).gotoAndStop(1);
               (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnbofang").clickCancel();
               return;
            }
            if(_loc2_ == "jnbofang")
            {
               if((this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnbofang").getcurstate() == 1)
               {
                  (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnbofang").clickDisable();
                  _loc7_ = (this.baseMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHBase") as MovieClip;
                  (_loc7_["zyjndh"] as MovieClip).gotoAndPlay(1);
               }
               else if((this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnbofang").getcurstate() == 4)
               {
                  (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnbofang").clickCancel();
                  _loc8_ = (this.baseMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHBase") as MovieClip;
                  (_loc8_["zyjndh"] as MovieClip).gotoAndStop(1);
               }
            }
            if(_loc2_ == "jnxuexi")
            {
               if(GM.skillLvM.upToNextBaseSkill(this.bid))
               {
                  (this.baseMc["dhxuexichengong"] as MovieClip).gotoAndPlay(1);
                  _loc9_ = GM.skillLvM.getBSkillLevelById(this.bid);
                  (this.baseMc["zhiyetubiao" + this.bid]["lname"] as TextField).text = "Lv." + _loc9_.curLevel;
                  (this.baseMc["jn1"] as TextField).text = "" + _loc9_.getslbd().upach;
                  (this.baseMc["jn2"] as TextField).text = "" + _loc9_.getslbd().upgod;
                  (this.baseMc["jn3"] as TextField).text = "" + _loc9_.getslbd().upplv;
                  (this.baseMc["jn4"] as TextField).text = _loc9_.getslbd().keyc;
                  _loc10_ = _loc9_.isUpArr();
                  if(_loc10_[0] == 0)
                  {
                     (this.baseMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                     (this.baseMc["weimanzu1"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.baseMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                     (this.baseMc["weimanzu1"] as MovieClip).visible = false;
                  }
                  if(_loc10_[1] == 0)
                  {
                     (this.baseMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                     (this.baseMc["weimanzu2"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.baseMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                     (this.baseMc["weimanzu2"] as MovieClip).visible = false;
                  }
                  if(_loc10_[2] == 0)
                  {
                     (this.baseMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                     (this.baseMc["weimanzu3"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.baseMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                     (this.baseMc["weimanzu3"] as MovieClip).visible = false;
                  }
                  if(_loc9_.isUp())
                  {
                     (this.baseMc["zhiyetubiao" + this.bid]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
                     (this.baseMc["zhiyetubiao" + this.bid]["lname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
                     (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickBy();
                  }
                  else
                  {
                     (this.baseMc["zhiyetubiao" + this.bid]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
                     (this.baseMc["zhiyetubiao" + this.bid]["lname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
                     (this.mcMO["baseMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickDisable();
                  }
                  (this.mc["jn4"] as TextField).text = "" + GM.cp.getGodByRole();
               }
            }
         }
      }
      
      private function wuxinMcH(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:SkillLevel = null;
         var _loc5_:Array = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:SkillLevel = null;
         var _loc10_:Array = null;
         if(param1.target.name != null && Boolean((this.mcMO["wuxinMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            if(_loc2_.length > 12)
            {
               (this.mcMO["wuxinMc"] as McBtnLianDong).btnByClick(param1.target.name);
               _loc3_ = int(_loc2_.substr(12));
               this.wid = _loc3_;
               this.memwuxi = _loc3_;
               _loc4_ = GM.skillLvM.getWXSkillLevelById(_loc3_);
               if(_loc4_ == null)
               {
                  GM.findCheatMax(GS.a28);
               }
               (this.wuxinMc["jn1"] as TextField).text = "" + _loc4_.getslbd().upach;
               (this.wuxinMc["jn2"] as TextField).text = "" + _loc4_.getslbd().upgod;
               (this.wuxinMc["jn3"] as TextField).text = "" + _loc4_.getslbd().upplv;
               (this.wuxinMc["jn4"] as TextField).text = "" + _loc4_.getslbd().keyc;
               _loc5_ = _loc4_.isUpArr();
               if(_loc5_[0] == 0)
               {
                  (this.wuxinMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.wuxinMc["weimanzu1"] as MovieClip).visible = true;
               }
               else
               {
                  (this.wuxinMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.wuxinMc["weimanzu1"] as MovieClip).visible = false;
               }
               if(_loc5_[1] == 0)
               {
                  (this.wuxinMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.wuxinMc["weimanzu2"] as MovieClip).visible = true;
               }
               else
               {
                  (this.wuxinMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.wuxinMc["weimanzu2"] as MovieClip).visible = false;
               }
               if(_loc5_[2] == 0)
               {
                  (this.wuxinMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                  (this.wuxinMc["weimanzu3"] as MovieClip).visible = true;
               }
               else
               {
                  (this.wuxinMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                  (this.wuxinMc["weimanzu3"] as MovieClip).visible = false;
               }
               (this.mc["jnnpcduihua"]["jnduihua"] as TextField).text = "" + _loc4_.getslbd().npctalkall();
               if(_loc4_.isUp())
               {
                  (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickBy();
               }
               else
               {
                  (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickDisable();
               }
               _loc6_ = (this.wuxinMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHWx") as MovieClip;
               _loc6_.gotoAndStop(_loc4_.getslbd().donghuaF);
               (_loc6_["zyjndh"] as MovieClip).gotoAndStop(1);
               (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnbofang").clickCancel();
               return;
            }
            if(_loc2_ == "jnbofang")
            {
               if((this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnbofang").getcurstate() == 1)
               {
                  (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnbofang").clickDisable();
                  _loc7_ = (this.wuxinMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHWx") as MovieClip;
                  (_loc7_["zyjndh"] as MovieClip).gotoAndPlay(1);
               }
               else if((this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnbofang").getcurstate() == 4)
               {
                  (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnbofang").clickCancel();
                  _loc8_ = (this.wuxinMc["jndonghuayanshi"] as MovieClip).getChildByName("cDHWx") as MovieClip;
                  (_loc8_["zyjndh"] as MovieClip).gotoAndStop(1);
               }
            }
            if(_loc2_ == "jnxuexi")
            {
               if(GM.skillLvM.upToNextWXSkill(this.wid))
               {
                  (this.wuxinMc["dhxuexichengong"] as MovieClip).gotoAndPlay(1);
                  _loc9_ = GM.skillLvM.getWXSkillLevelById(this.wid);
                  (this.wuxinMc["wuxingtubiao" + this.wid]["lname"] as TextField).text = "Lv." + _loc9_.curLevel;
                  (this.wuxinMc["jn1"] as TextField).text = "" + _loc9_.getslbd().upach;
                  (this.wuxinMc["jn2"] as TextField).text = "" + _loc9_.getslbd().upgod;
                  (this.wuxinMc["jn3"] as TextField).text = "" + _loc9_.getslbd().upplv;
                  (this.wuxinMc["jn4"] as TextField).text = _loc9_.getslbd().keyc;
                  _loc10_ = _loc9_.isUpArr();
                  if(_loc10_[0] == 0)
                  {
                     (this.wuxinMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                     (this.wuxinMc["weimanzu1"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.wuxinMc["jn1"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                     (this.wuxinMc["weimanzu1"] as MovieClip).visible = false;
                  }
                  if(_loc10_[1] == 0)
                  {
                     (this.wuxinMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                     (this.wuxinMc["weimanzu2"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.wuxinMc["jn2"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                     (this.wuxinMc["weimanzu2"] as MovieClip).visible = false;
                  }
                  if(_loc10_[2] == 0)
                  {
                     (this.wuxinMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,16711680));
                     (this.wuxinMc["weimanzu3"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.wuxinMc["jn3"] as TextField).setTextFormat(new TextFormat(null,14,13421772));
                     (this.wuxinMc["weimanzu3"] as MovieClip).visible = false;
                  }
                  if(_loc9_.isUp())
                  {
                     (this.wuxinMc["wuxingtubiao" + this.wid]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
                     (this.wuxinMc["wuxingtubiao" + this.wid]["lname"] as TextField).setTextFormat(new TextFormat(null,14,16777062));
                     (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickBy();
                  }
                  else
                  {
                     (this.wuxinMc["wuxingtubiao" + this.wid]["jiname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
                     (this.wuxinMc["wuxingtubiao" + this.wid]["lname"] as TextField).setTextFormat(new TextFormat(null,14,10066329));
                     (this.mcMO["wuxinMc"] as McBtnLianDong).getMcBtnByName("jnxuexi").clickDisable();
                  }
                  (this.mc["jn4"] as TextField).text = "" + GM.cp.getGodByRole();
               }
            }
         }
      }
      
      private function rollOverH(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["baseMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            if(_loc2_.length > 11)
            {
               _loc3_ = int(_loc2_.substr(11));
               (this.mc["jinengmiaoshu"] as MovieClip).visible = true;
               this.setshuxing(_loc3_);
            }
         }
      }
      
      private function rollOutH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["baseMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mc["jinengmiaoshu"] as MovieClip).visible = false;
         }
      }
      
      private function wxrollOverH(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["wuxinMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            if(_loc2_.length > 12)
            {
               _loc3_ = int(_loc2_.substr(12));
               (this.mc["jinengmiaoshu"] as MovieClip).visible = true;
               this.setshuxingByWx(_loc3_);
            }
         }
      }
      
      private function wxrollOutH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["wuxinMc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mc["jinengmiaoshu"] as MovieClip).visible = false;
         }
      }
      
      private function setshuxing(param1:int) : void
      {
         var _loc2_:SkillLevel = GM.skillLvM.getBSkillLevelById(param1);
         var _loc3_:int = 130;
         if(param1 <= 5)
         {
            _loc3_ += 60 * (param1 - 1);
         }
         else if(param1 == 6)
         {
            _loc3_ = 280;
         }
         else
         {
            _loc3_ = 340;
         }
         (this.mc["jinengmiaoshu"] as MovieClip).y = _loc3_;
         (this.mc["jinengmiaoshu"]["sname"] as TextField).text = _loc2_.getslbd().namealv;
         (this.mc["jinengmiaoshu"]["wux"] as TextField).text = _loc2_.getslbd().wuxinn;
         (this.mc["jinengmiaoshu"]["wuxinb"] as TextField).text = _loc2_.getslbd().wuxinnb;
         (this.mc["jinengmiaoshu"]["cdcd"] as TextField).text = _loc2_.getslbd().cdcd;
         (this.mc["jinengmiaoshu"]["mpmp"] as TextField).text = _loc2_.getslbd().mpmp;
         (this.mc["jinengmiaoshu"]["skyl"] as TextField).text = _loc2_.getslbd().skylimit;
         (this.mc["jinengmiaoshu"]["keyc"] as TextField).text = _loc2_.getslbd().keyc;
         (this.mc["jinengmiaoshu"]["miaoshu"] as TextField).htmlText = _loc2_.getslbd().miaoshu;
      }
      
      private function setshuxingByWx(param1:int) : void
      {
         var _loc2_:SkillLevel = GM.skillLvM.getWXSkillLevelById(param1);
         var _loc3_:int = 130;
         if(param1 <= 5)
         {
            _loc3_ += 60 * (param1 - 1);
         }
         else if(param1 == 6)
         {
            _loc3_ = 280;
         }
         else
         {
            _loc3_ = 340;
         }
         (this.mc["jinengmiaoshu"] as MovieClip).y = _loc3_;
         (this.mc["jinengmiaoshu"]["sname"] as TextField).text = _loc2_.getslbd().namealv;
         (this.mc["jinengmiaoshu"]["wux"] as TextField).text = _loc2_.getslbd().wuxinn;
         (this.mc["jinengmiaoshu"]["wuxinb"] as TextField).text = _loc2_.getslbd().wuxinnb;
         (this.mc["jinengmiaoshu"]["cdcd"] as TextField).text = _loc2_.getslbd().cdcd;
         (this.mc["jinengmiaoshu"]["mpmp"] as TextField).text = _loc2_.getslbd().mpmp;
         (this.mc["jinengmiaoshu"]["skyl"] as TextField).text = _loc2_.getslbd().skylimit;
         (this.mc["jinengmiaoshu"]["keyc"] as TextField).text = _loc2_.getslbd().keyc;
         (this.mc["jinengmiaoshu"]["miaoshu"] as TextField).htmlText = _loc2_.getslbd().miaoshu;
      }
      
      private function npcClick(param1:MouseEvent) : void
      {
         var _loc2_:SkillLevel = null;
         if(this.memda == 1)
         {
            _loc2_ = GM.skillLvM.getBSkillLevelById(this.bid);
            (this.mc["jnnpcduihua"]["jnduihua"] as TextField).text = "" + _loc2_.getslbd().npctalkall();
         }
         else
         {
            if(this.wid == 0)
            {
               return;
            }
            _loc2_ = GM.skillLvM.getWXSkillLevelById(this.wid);
            if(_loc2_ != null)
            {
               (this.mc["jnnpcduihua"]["jnduihua"] as TextField).text = "" + _loc2_.getslbd().npctalkall();
            }
         }
      }
   }
}

