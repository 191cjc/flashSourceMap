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
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.gameloader.*;
   
   public class GPkscoreJl
   {
      
      private static var self:GPkscoreJl = new GPkscoreJl();
      
      private static var curs:int = 0;
      
      private static var poingArr:Array = [[],[391,159],[582,159],[773,159],[391,315],[582,315],[773,315],[391,471],[582,471],[773,471],[],[],[],[],[],[],[]];
      
      private var mc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      private var pmjldbMc:MovieClip;
      
      private var pmjldaMc:MovieClip;
      
      private var pmjldcMc:MovieClip;
      
      public function GPkscoreJl()
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
         var _loc5_:Class = null;
         var _loc6_:Array = null;
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("sjpkpanel"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc6_ = new Array();
                  _loc6_.push("sjpkpanel");
                  _loc6_.push("t_box");
                  GM.loaderM.setLoadData(_loc6_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc5_ = LoaderManager.getSwfClass("sjpkphjl") as Class;
            this.mc = new _loc5_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.pmjldbMc = this.mc["pmjldb"];
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         var _loc2_:int = 1;
         while(_loc2_ < 8)
         {
            _loc1_.addBtnLianDong(new McBtn(this.pmjldbMc["lqjl" + _loc2_]));
            _loc2_++;
         }
         this.mcMO["pmjldbMO"] = _loc1_;
         this.pmjldcMc = this.mc["pmjldc"];
         _loc1_ = new McBtnLianDong();
         var _loc3_:int = 1;
         while(_loc3_ < 8)
         {
            _loc1_.addBtnLianDong(new McBtn(this.pmjldcMc["shengjie" + _loc3_]));
            _loc3_++;
         }
         this.mcMO["pmjldcMO"] = _loc1_;
         this.pmjldaMc = this.mc["pmjlda"];
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.pmjldaMc["sjlq"]));
         _loc1_.addBtnLianDong(new McBtn(this.pmjldaMc["pkclose"]));
         this.mcMO["pmjldaMO"] = _loc1_;
         var _loc4_:int = 1;
         while(_loc4_ < 8)
         {
            _loc7_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc8_ = new _loc7_() as MovieClip;
            _loc8_.mouseEnabled = false;
            _loc8_.mouseChildren = false;
            (_loc8_["mask_mc"] as MovieClip).visible = false;
            (_loc8_["d_mc"] as MovieClip).visible = false;
            (_loc8_["gx_mc"] as MovieClip).visible = false;
            _loc8_.name = "kaipaitubiao";
            this.mc["pkjldk" + _loc4_]["sjd"].addChild(_loc8_);
            _loc4_++;
         }
         _loc7_ = LoaderManager.getSwfClass("T_Box") as Class;
         _loc8_ = new _loc7_() as MovieClip;
         _loc8_.mouseEnabled = false;
         _loc8_.mouseChildren = false;
         (_loc8_["mask_mc"] as MovieClip).visible = false;
         (_loc8_["d_mc"] as MovieClip).visible = false;
         (_loc8_["gx_mc"] as MovieClip).visible = false;
         _loc8_.name = "kaipaitubiao";
         this.mc["sjwj1"]["sjd"].addChild(_loc8_);
         (this.mc["chakanpj"] as MovieClip).visible = false;
         this.initPkSelf();
         this.initRight();
         this.initLeft();
         this.pmjldbMc.addEventListener(MouseEvent.CLICK,this.pmjldbMcClick);
         this.pmjldaMc.addEventListener(MouseEvent.CLICK,this.pmjldaMcClick);
         this.pmjldcMc.addEventListener(MouseEvent.MOUSE_OVER,this.pmjldcMcOver);
         this.pmjldcMc.addEventListener(MouseEvent.MOUSE_OUT,this.pmjldcMcOut);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["pmjldbMO"] as McBtnLianDong).remove();
            (this.mcMO["pmjldaMO"] as McBtnLianDong).remove();
            (this.mcMO["pmjldcMO"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.pmjldbMc.removeEventListener(MouseEvent.CLICK,this.pmjldbMcClick);
            this.pmjldaMc.removeEventListener(MouseEvent.CLICK,this.pmjldaMcClick);
            this.pmjldcMc.removeEventListener(MouseEvent.MOUSE_OVER,this.pmjldcMcOver);
            this.pmjldcMc.removeEventListener(MouseEvent.MOUSE_OUT,this.pmjldcMcOut);
            this.pmjldbMc = null;
            this.pmjldaMc = null;
            this.pmjldcMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function initPkSelf() : void
      {
         (this.mc["mz"] as TextField).text = GM.testapi.pkDataself.nickn;
         (this.mc["zjtx"]["yhjjtxd"] as MovieClip).gotoAndStop(FlowInterface.getJobByRole());
         (this.mc["zl"] as TextField).text = String(GM.testapi.pkDataself.getFl());
         (this.mc["jf"] as TextField).text = String(GM.testapi.pkDataself.score);
         (this.mc["gx"] as TextField).text = "" + GM.aSaveData.pksd.gongScore;
         (this.mc["pm"] as TextField).text = String(GM.testapi.pkDataself.rank);
         (this.mc["sl"] as TextField).text = String(GM.testapi.pkDataself.getWinRate()) + "%";
         (this.mc["dqls"] as TextField).text = String(GM.testapi.pkDataself.pwinwin);
      }
      
      private function initLeft() : void
      {
         if(GM.aSaveData.pksd.haoId == 0)
         {
            (this.pmjldaMc["sjlq"] as MovieClip).visible = true;
         }
         else
         {
            (this.pmjldaMc["sjlq"] as MovieClip).visible = false;
         }
         var _loc1_:PkAwardBD = PkAwardBDManager.getShowData(GS.a100);
         var _loc2_:PkAwardBD = PkAwardBDManager.getShowDataByUp(GS.a100);
         var _loc3_:Goods = FlowInterface.getGoodsById(_loc1_.valuea);
         (this.mc["pmjlszc"] as TextField).text = "升级所需排名 " + _loc2_.rankMin + "-" + _loc2_.rankMax;
         ((this.mc["sjwj1"]["sjd"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc3_.getFrame());
         (this.mc["sjwj1"]["jlsl"] as TextField).text = "" + _loc3_.getName();
      }
      
      private function initRight() : void
      {
         var _loc2_:PkAwardBD = null;
         var _loc3_:Goods = null;
         var _loc1_:int = int(GS.a1);
         while(_loc1_ < GS.a8)
         {
            if(_loc1_ == GS.a1)
            {
               (this.mc["pkjldk" + _loc1_] as MovieClip).visible = true;
               (this.pmjldbMc["lqjl" + _loc1_] as MovieClip).visible = true;
               (this.pmjldcMc["shengjie" + _loc1_] as MovieClip).visible = true;
               ((this.mc["pkjldk" + _loc1_]["sjd"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1731);
               if(GM.testapi.pkDataself.rank <= 0)
               {
                  (this.mc["pkjldk" + _loc1_]["pmjlsz"] as TextField).text = "排名 " + 10000;
               }
               else
               {
                  (this.mc["pkjldk" + _loc1_]["pmjlsz"] as TextField).text = "排名 " + GM.testapi.pkDataself.rank;
               }
               (this.mc["pkjldk" + _loc1_]["jlsl"] as TextField).text = "晶币 * " + this.getGod();
            }
            else if(PkAwardBDManager.isHasType(_loc1_))
            {
               (this.mc["pkjldk" + _loc1_] as MovieClip).visible = true;
               (this.pmjldbMc["lqjl" + _loc1_] as MovieClip).visible = true;
               (this.pmjldcMc["shengjie" + _loc1_] as MovieClip).visible = true;
               _loc2_ = PkAwardBDManager.getShowData(_loc1_);
               (this.mc["pkjldk" + _loc1_]["pmjlsz"] as TextField).text = "排名 " + _loc2_.rankMin + "-" + _loc2_.rankMax;
               if(_loc2_.awardtype == 0)
               {
                  _loc3_ = FlowInterface.getGoodsById(_loc2_.valuea);
                  ((this.mc["pkjldk" + _loc1_]["sjd"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc3_.getFrame());
                  (this.mc["pkjldk" + _loc1_]["jlsl"] as TextField).text = "" + _loc3_.getName() + "* " + _loc2_.valueb;
               }
               else
               {
                  ((this.mc["pkjldk" + _loc1_]["sjd"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc2_.framenum);
                  (this.mc["pkjldk" + _loc1_]["jlsl"] as TextField).text = "功勋 * " + _loc2_.valuea;
               }
            }
            else
            {
               (this.mc["pkjldk" + _loc1_] as MovieClip).visible = false;
               (this.pmjldbMc["lqjl" + _loc1_] as MovieClip).visible = false;
               (this.pmjldcMc["shengjie" + _loc1_] as MovieClip).visible = false;
            }
            _loc1_++;
         }
      }
      
      private function pmjldbMcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PkAwardBD = null;
         var _loc6_:Goods = null;
         if(param1.target.name != null && Boolean((this.mcMO["pmjldbMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(4));
            if(GM.aSaveData.pksd.isGetAward(_loc3_))
            {
               GoodsManger.cwTs("明天再来吧!");
               return;
            }
            if(_loc3_ == GS.a1)
            {
               if(GM.testapi.pkDataself.rank <= 0 || GM.testapi.pkDataself.rank > GS.a10000)
               {
                  GoodsManger.cwTs("名次不够，继续努力吧!");
                  return;
               }
               _loc4_ = int(this.getGod());
               GM.cp.addGodByRole(_loc4_);
               GoodsManger.cwTs("恭喜, 得到晶币" + _loc4_);
               GM.aSaveData.pksd.recordGetAward(_loc3_);
               return;
            }
            _loc5_ = PkAwardBDManager.getShowData(_loc3_);
            if(GM.testapi.pkDataself.rank <= 0 || GM.testapi.pkDataself.rank > GS.a10000 || GM.testapi.pkDataself.rank > _loc5_.rankMax)
            {
               GoodsManger.cwTs("名次不够，继续努力吧!");
               return;
            }
            if(_loc5_.awardtype == 0)
            {
               _loc6_ = FlowInterface.getGoodsById(_loc5_.valuea);
               if(FlowInterface.isKeYiFangById(_loc5_.valuea,_loc5_.valueb))
               {
                  BagFactory.addInBagById(_loc5_.valuea,_loc5_.valueb,0);
                  GM.aSaveData.pksd.recordGetAward(_loc3_);
                  GoodsManger.cwTs("恭喜得到" + _loc5_.valueb + "个" + "" + _loc6_.getName());
               }
               else
               {
                  GoodsManger.cwTs("背包已满，无法领取 !");
               }
            }
            else
            {
               GM.aSaveData.pksd.addGong(_loc5_.valuea);
               this.initPkSelf();
               GoodsManger.cwTs("恭喜, 得到功勋" + _loc5_.valuea);
               GM.aSaveData.pksd.recordGetAward(_loc3_);
            }
            return;
         }
      }
      
      private function pmjldaMcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:PkAwardBD = null;
         var _loc4_:Goods = null;
         if(param1.target.name != null && Boolean((this.mcMO["pmjldaMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            if(_loc2_ == "pkclose")
            {
               close();
               return;
            }
            if(_loc2_ == "sjlq")
            {
               if(GM.aSaveData.pksd.haoId != 0)
               {
                  return;
               }
               _loc3_ = PkAwardBDManager.getShowData(GS.a100);
               if(GM.testapi.pkDataself.rank <= 0 || GM.testapi.pkDataself.rank > GS.a10000 || GM.testapi.pkDataself.rank > _loc3_.rankMax)
               {
                  GoodsManger.cwTs("名次不够，继续努力吧!");
                  return;
               }
               _loc4_ = FlowInterface.getGoodsById(_loc3_.valuea);
               if(BagFactory.sjChFun(0,_loc4_.getId()))
               {
                  GM.aSaveData.pksd.haoId = _loc4_.getId();
                  this.initLeft();
                  GoodsManger.cwTs("恭喜得到称号 " + _loc4_.getName());
               }
               else
               {
                  GoodsManger.cwTs("背包已满，无法领取称号 !");
               }
               return;
            }
         }
      }
      
      private function pmjldcMcOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:PkAwardBD = null;
         if(param1.target.name != null && Boolean((this.mcMO["pmjldcMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(8));
            if(_loc3_ == 1)
            {
               (this.mc["chakanpj"] as MovieClip).visible = true;
               (this.mc["chakanpj"] as MovieClip).x = poingArr[_loc3_][0];
               (this.mc["chakanpj"] as MovieClip).y = poingArr[_loc3_][1];
               (this.mc["chakanpj"]["chakanpja"] as TextField).text = "排名 " + this.getUpRank();
               (this.mc["chakanpj"]["chakanpjd"] as TextField).text = "" + this.countGod(this.getUpRank());
            }
            else
            {
               (this.mc["chakanpj"] as MovieClip).visible = true;
               (this.mc["chakanpj"] as MovieClip).x = poingArr[_loc3_][0];
               (this.mc["chakanpj"] as MovieClip).y = poingArr[_loc3_][1];
               _loc4_ = PkAwardBDManager.getShowDataByUp(_loc3_);
               (this.mc["chakanpj"]["chakanpja"] as TextField).text = "排名 " + _loc4_.rankMin + "-" + _loc4_.rankMax;
               if(_loc4_.awardtype == 0)
               {
                  (this.mc["chakanpj"]["chakanpjd"] as TextField).text = "" + _loc4_.valueb;
               }
               else
               {
                  (this.mc["chakanpj"]["chakanpjd"] as TextField).text = "" + _loc4_.valuea;
               }
            }
         }
      }
      
      private function pmjldcMcOut(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["pmjldcMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mc["chakanpj"] as MovieClip).visible = false;
         }
      }
      
      private function countGod(param1:int) : int
      {
         return Math.log(-param1 + GS.a10000 + GS.a2) / Math.log(GS.a1 + GS.a01) * GS.a500 + Math.pow((-param1 + GS.a10000 + GS.a2) / GS.a1000,GS.a5);
      }
      
      private function getGod() : int
      {
         var _loc1_:int = int(GM.testapi.pkDataself.rank);
         if(_loc1_ <= 0 || _loc1_ > GS.a10000)
         {
            return this.countGod(GS.a10000);
         }
         return this.countGod(GM.testapi.pkDataself.rank);
      }
      
      private function getUpRank() : int
      {
         var _loc1_:int = int(GM.testapi.pkDataself.rank);
         if(_loc1_ <= 0 || _loc1_ > GS.a10000)
         {
            return GS.a10000;
         }
         if(_loc1_ == GS.a1)
         {
            return GS.a1;
         }
         return _loc1_ - GS.a1;
      }
   }
}

