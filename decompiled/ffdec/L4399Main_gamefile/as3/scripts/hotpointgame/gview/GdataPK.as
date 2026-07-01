package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.ginit.*;
   import hotpointgame.glevel.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.gxShop.*;
   import hotpointgame.views.sjPk.*;
   
   public class GdataPK
   {
      
      private static var kaipaiaward:Array;
      
      public static var self:GdataPK = new GdataPK();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var danMc:MovieClip;
      
      private var ckwjzMc:MovieClip;
      
      private var sjpkxuanzheMc:MovieClip;
      
      private var sjpkkaipaiMc:MovieClip;
      
      private var choosePa:int = 0;
      
      private var _kaipaiflag:VT = VT.createVT(0);
      
      private var mcMO:Object = new Object();
      
      private var curPage:int = 1;
      
      private var maxPage:int = -1;
      
      private var _fightId:VT = VT.createVT(0);
      
      private var _nosavefl:VT = VT.createVT(0);
      
      private var _kaipaiThreeOne:VT = VT.createVT(0);
      
      public function GdataPK()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            GoodsManger.allPanelClose();
            self.initKpAward();
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      private function initKpAward() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:VT = null;
         if(kaipaiaward == null)
         {
            kaipaiaward = new Array();
            _loc1_ = LevelDataManager.getCLevelPkaward();
            for each(_loc2_ in _loc1_)
            {
               _loc3_ = [];
               for each(_loc4_ in _loc2_)
               {
                  _loc3_[_loc3_.length] = VT.createVT(_loc4_.getValue());
               }
               kaipaiaward[kaipaiaward.length] = _loc3_;
            }
         }
      }
      
      private function getKaiPaiAward() : Array
      {
         var _loc3_:Goods = null;
         var _loc4_:VT = null;
         var _loc1_:Number = Math.random() * GS.a10000;
         var _loc2_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < kaipaiaward.length)
         {
            _loc2_ += (kaipaiaward[_loc5_][0] as VT).getValue();
            if(_loc1_ <= _loc2_)
            {
               _loc3_ = FlowInterface.createGoodsByCreateLevel((kaipaiaward[_loc5_][1] as VT).getValue());
               _loc4_ = VT.createVT((kaipaiaward[_loc5_][2] as VT).getValue());
               break;
            }
            _loc5_++;
         }
         if(_loc4_ != null && _loc3_ != null)
         {
            if(_loc3_.getType() == GS.a2 && (_loc3_.getSmallType() == GS.a4 || _loc3_.getSmallType() == GS.a23))
            {
               return [_loc3_,_loc4_];
            }
            if(FlowInterface.isFullByIdandnum(_loc3_,_loc4_.getValue()))
            {
               return [_loc3_,_loc4_];
            }
         }
         return [];
      }
      
      public function reset() : void
      {
         var _loc5_:Class = null;
         var _loc6_:Array = null;
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
            _loc5_ = LoaderManager.getSwfClass("shujupkmianban") as Class;
            this.mc = new _loc5_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.curPage = 1;
         this.maxPage = -1;
         this.fightId = 0;
         this.nosavefl = 0;
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["ysb"] as MovieClip).mouseEnabled = false;
         (this.mc["ysb"] as MovieClip).mouseChildren = false;
         this.ckwjzMc = this.mc["ckwjz"];
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         var _loc2_:int = 1;
         while(_loc2_ < 11)
         {
            _loc1_.addBtnLianDong(new McBtn(this.ckwjzMc["ckwj" + _loc2_]));
            _loc2_++;
         }
         this.mcMO["ckwjzMO"] = _loc1_;
         this.danMc = this.mc["dan"];
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.danMc["pkfanyeshang"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["pkfanyexia"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["pkclose"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["ancj1"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["ancj2"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["ancj3"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["lqphjl"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["sxsj"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["sxds"]));
         _loc1_.addBtnLianDong(new McBtn(this.danMc["gxsd"]));
         this.mcMO["danMO"] = _loc1_;
         this.sjpkxuanzheMc = this.mc["sjpkxuanzhe"];
         _loc1_ = new McBtnLianDong();
         var _loc3_:int = 1;
         while(_loc3_ < 11)
         {
            _loc1_.addBtnLianDong(new McBtn(this.sjpkxuanzheMc["sjwj" + _loc3_]));
            _loc1_.addBtnLianDong(new McBtn(this.sjpkxuanzheMc["pktg" + _loc3_]));
            _loc3_++;
         }
         this.mcMO["sjpkxuanzheMO"] = _loc1_;
         this.sjpkkaipaiMc = this.mc["sjpkkaipai"];
         this.sjpkkaipaiMc.visible = false;
         _loc1_ = new McBtnLianDong();
         var _loc4_:int = 1;
         while(_loc4_ < 6)
         {
            _loc1_.addBtnLianDong(new McBtn(this.sjpkkaipaiMc["kaipa" + _loc4_ + "b"]));
            _loc4_++;
         }
         this.mcMO["sjpkkaipaiMO"] = _loc1_;
         if(GM.testapi.top100 != null)
         {
            this.flushRankText();
            this.initPkSelf();
            this.flushEnemyList();
            (this.mc["pktk5"] as MovieClip).visible = false;
         }
         else
         {
            (this.mc["pktk5"] as MovieClip).visible = true;
            GM.testapi.getRankInfoPage(GS.a100,GS.a1,GS.a1);
            this.mc.addEventListener(Event.ENTER_FRAME,this.top100H);
         }
         (this.mc["pktk4"] as MovieClip).visible = false;
         (this.mc["pktk3"] as MovieClip).visible = false;
         (this.mc["pktk2"] as MovieClip).visible = false;
         (this.mc["pktk1"] as MovieClip).visible = false;
         this.sjpkkaipaiMc.addEventListener(MouseEvent.CLICK,this.sjpkkaipaiMcClick);
         this.sjpkxuanzheMc.addEventListener(MouseEvent.CLICK,this.sjpkxuanzheMcClick);
         this.danMc.addEventListener(MouseEvent.CLICK,this.danMcClick);
         this.ckwjzMc.addEventListener(MouseEvent.CLICK,this.ckwjzMcClick);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["ckwjzMO"] as McBtnLianDong).remove();
            (this.mcMO["danMO"] as McBtnLianDong).remove();
            (this.mcMO["sjpkxuanzheMO"] as McBtnLianDong).remove();
            (this.mcMO["sjpkkaipaiMO"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.mc.removeEventListener(Event.ENTER_FRAME,this.savedataH);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enemyListH);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.pkselfH);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.top100H);
            this.sjpkkaipaiMc.removeEventListener(Event.ENTER_FRAME,this.sjpkkaipaiMcH);
            this.sjpkkaipaiMc.removeEventListener(MouseEvent.CLICK,this.sjpkkaipaiMcClick);
            this.sjpkxuanzheMc.removeEventListener(MouseEvent.CLICK,this.sjpkxuanzheMcClick);
            this.danMc.removeEventListener(MouseEvent.CLICK,this.danMcClick);
            this.ckwjzMc.removeEventListener(MouseEvent.CLICK,this.ckwjzMcClick);
            this.sjpkkaipaiMc = null;
            this.sjpkxuanzheMc = null;
            this.danMc = null;
            this.ckwjzMc = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function flushRankText() : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:TopData = null;
         var _loc1_:int = (this.curPage - 1) * 10;
         var _loc2_:int = _loc1_ + 9;
         var _loc3_:int = 1;
         var _loc4_:int = _loc1_;
         while(_loc4_ <= _loc2_)
         {
            _loc5_ = this.mc["wjphl" + _loc3_];
            _loc6_ = GM.testapi.top100[_loc4_];
            if(_loc6_ != null)
            {
               _loc5_.visible = true;
               (this.ckwjzMc["ckwj" + _loc3_] as MovieClip).visible = true;
               (_loc5_["pmsz"] as TextField).text = String(_loc6_.rank);
               (_loc5_["wjmz"] as TextField).text = _loc6_.nickn;
               (_loc5_["jfsz"] as TextField).text = String(_loc6_.score);
               if(int(_loc6_.extO.jo) == GS.a1)
               {
                  (_loc5_["jfzy"] as TextField).text = "绝影枪手";
               }
               else
               {
                  (_loc5_["jfzy"] as TextField).text = "炎蓝炮手";
               }
            }
            else
            {
               _loc5_.visible = false;
               (this.ckwjzMc["ckwj" + _loc3_] as MovieClip).visible = false;
            }
            _loc3_++;
            _loc4_++;
         }
         if(this.maxPage == -1)
         {
            this.maxPage = GM.testapi.top100.length / 10;
            if(GM.testapi.top100.length % 10 != 0)
            {
               ++this.maxPage;
            }
         }
         (this.mc["scyeshu"] as TextField).text = "" + this.curPage + "/" + this.maxPage;
      }
      
      private function initPkSelf() : void
      {
         var _loc1_:PkAwardBD = null;
         (this.mc["mz"] as TextField).text = GM.testapi.pkDataself.nickn;
         (this.mc["zjtx"]["yhjjtxd"] as MovieClip).gotoAndStop(FlowInterface.getJobByRole());
         (this.mc["zl"] as TextField).text = String(GM.testapi.pkDataself.getFl());
         (this.mc["jf"] as TextField).text = String(GM.testapi.pkDataself.score);
         (this.mc["gx"] as TextField).text = "" + GM.aSaveData.pksd.gongScore;
         (this.mc["pm"] as TextField).text = String(GM.testapi.pkDataself.rank);
         (this.mc["sl"] as TextField).text = String(GM.testapi.pkDataself.getWinRate()) + "%";
         (this.mc["dqls"] as TextField).text = String(GM.testapi.pkDataself.pwinwin);
         if(GM.aSaveData.pksd.haoId != 0)
         {
            _loc1_ = PkAwardBDManager.getShowData(GS.a100);
            if(!(GM.testapi.pkDataself.rank <= 0 || GM.testapi.pkDataself.rank > GS.a10000))
            {
               if(_loc1_.valuea != GM.aSaveData.pksd.haoId)
               {
                  if(BagFactory.sjChFun(GM.aSaveData.pksd.haoId,_loc1_.valuea))
                  {
                     GM.aSaveData.pksd.haoId = _loc1_.valuea;
                     GM.testapi.saveDataBefore();
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满称号无法自动升级!");
                  }
               }
            }
         }
      }
      
      private function flushEnemyList() : void
      {
         var _loc5_:TopData = null;
         (this.mc["sjrz"] as TextField).text = "00:00";
         (this.mc["sycs"] as TextField).text = "" + GM.aSaveData.pkDrList.getShengxiaFn();
         (this.mc["sycsb"] as TextField).text = "" + GM.aSaveData.pkDrList.getFlushEnemyn();
         var _loc1_:Array = GM.aSaveData.pkDrList.getisWinArr();
         var _loc2_:Array = GM.aSaveData.pkDrList.getAllEnemy();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc1_[_loc3_] as VT).getValue() == 2)
            {
               (this.mc["ysb"]["ijb" + (_loc3_ + 1)] as MovieClip).visible = true;
            }
            else
            {
               (this.mc["ysb"]["ijb" + (_loc3_ + 1)] as MovieClip).visible = false;
            }
            _loc5_ = _loc2_[_loc3_];
            (this.sjpkxuanzheMc["sjwj" + (_loc3_ + 1)]["knmc"] as TextField).text = "" + _loc5_.nickn;
            (this.sjpkxuanzheMc["sjwj" + (_loc3_ + 1)]["knph"] as TextField).text = "" + _loc5_.rank;
            (this.sjpkxuanzheMc["sjwj" + (_loc3_ + 1)]["knjf"] as TextField).text = "" + _loc5_.score;
            (this.sjpkxuanzheMc["sjwj" + (_loc3_ + 1)]["knsl"] as TextField).text = "" + _loc5_.getWinRate();
            (this.sjpkxuanzheMc["sjwj" + (_loc3_ + 1)]["yhjjtxx"] as MovieClip).gotoAndStop(_loc5_.extO.jo);
            _loc3_++;
         }
         var _loc4_:int = 1;
         while(_loc4_ < 4)
         {
            (this.mc["sjbq" + _loc4_] as MovieClip).gotoAndStop(GM.aSaveData.pkDrList.getStateAward(_loc4_) + 1);
            _loc4_++;
         }
      }
      
      private function iniKaipai(param1:int) : void
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         this.kaipaiThreeOne = param1;
         this.kaipaiflag = 0;
         this.choosePa = 0;
         this.sjpkkaipaiMc.visible = true;
         var _loc2_:int = 1;
         while(_loc2_ < 6)
         {
            (this.sjpkkaipaiMc["kaipa" + _loc2_ + "b"] as MovieClip).visible = true;
            (this.sjpkkaipaiMc["kaipa" + _loc2_] as MovieClip).visible = false;
            (this.sjpkkaipaiMc["kaipa" + _loc2_] as MovieClip).gotoAndStop(1);
            if((this.sjpkkaipaiMc["kaipa" + _loc2_]["moveMc"] as MovieClip).numChildren > 0)
            {
               (this.sjpkkaipaiMc["kaipa" + _loc2_]["moveMc"] as MovieClip).removeChildAt(0);
            }
            _loc3_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc4_ = new _loc3_() as MovieClip;
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            (_loc4_["mask_mc"] as MovieClip).visible = false;
            (_loc4_["d_mc"] as MovieClip).visible = false;
            (_loc4_["gx_mc"] as MovieClip).visible = false;
            _loc4_.name = "kaipaitubiao";
            this.sjpkkaipaiMc["kaipa" + _loc2_]["moveMc"].addChild(_loc4_);
            _loc2_++;
         }
      }
      
      public function flushTenEnemyListH() : void
      {
         if(curs == GS.a1)
         {
            if((this.mc["pktk5"] as MovieClip).visible)
            {
               (this.mc["pktk5"] as MovieClip).visible = false;
               GM.testapi.saveDataBefore();
               this.flushEnemyList();
            }
            else
            {
               GM.findCheatMax(GS.a65);
            }
         }
      }
      
      private function top100H(param1:Event) : void
      {
         if(GM.testapi.top100 != null)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.top100H);
            this.flushRankText();
            GM.testapi.getPkRoleInfo();
            this.mc.addEventListener(Event.ENTER_FRAME,this.pkselfH);
         }
      }
      
      private function pkselfH(param1:Event) : void
      {
         if(GM.testapi.pkDataself != null)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.pkselfH);
            this.initPkSelf();
            this.mc.addEventListener(Event.ENTER_FRAME,this.enemyListH);
            GM.testapi.getTenEnemy();
         }
      }
      
      private function enemyListH(param1:Event) : void
      {
         if(GM.aSaveData.pkDrList.getEnemyNum() == GS.a10)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enemyListH);
            this.flushEnemyList();
            (this.mc["pktk5"] as MovieClip).visible = false;
         }
      }
      
      private function savedataH(param1:Event) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:CScene = null;
         if(this.nosavefl > GS.a3000)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.savedataH);
            close();
            GoodsManger.cwTs("对手暂时没空，和别的玩家切磋吧!");
            return;
         }
         ++this.nosavefl;
         var _loc2_:PkSaveData = GM.testapi.isHasFdata();
         if(_loc2_ != null)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.savedataH);
            close();
            _loc3_ = new Array();
            _loc4_ = _loc2_.getZBArr();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc5_ == 1 || _loc5_ == 2 || _loc5_ == 3 || _loc5_ == 0)
               {
                  if(_loc4_[_loc5_] != "")
                  {
                     _loc3_.push(LoaderManager.allClassName[_loc4_[_loc5_]]);
                  }
                  else if(_loc5_ == 1 || _loc5_ == 2 || _loc5_ == 3)
                  {
                     if(_loc2_.rjob == GS.a1)
                     {
                        _loc3_.push("e_chushitao");
                     }
                     else if(_loc2_.rjob == GS.a2)
                     {
                        _loc3_.push("e_wchushitao");
                     }
                  }
                  else if(_loc2_.rjob == GS.a1)
                  {
                     _loc3_.push("WuqiB_xinshouqiang");
                  }
                  else if(_loc2_.rjob == GS.a2)
                  {
                     _loc3_.push("WuqiB_xinshoupao");
                  }
               }
               else if(_loc4_[_loc5_] != "")
               {
                  _loc3_.push(LoaderManager.allClassName[_loc4_[_loc5_]]);
               }
               _loc5_++;
            }
            if(_loc2_.rjob == GS.a1)
            {
               _loc3_.push("skin_man");
            }
            else if(_loc2_.rjob == GS.a2)
            {
               _loc3_.push("skin_wman");
            }
            _loc6_ = LevelDataManager.getCscene("竞技场" + 1);
            _loc6_.addSwfPk(_loc3_);
            GM.levelm.changeLevelDataByIdAndLs(GS.a9998,GS.a1);
         }
      }
      
      private function ckwjzMcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["ckwjzMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(4));
            _loc4_ = (this.curPage - 1) * 10 + _loc3_ - 1;
            SjPkPanel.open((GM.testapi.top100[_loc4_] as TopData).extO);
         }
      }
      
      private function sjpkxuanzheMcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:TopData = null;
         if(param1.target.name != null && Boolean((this.mcMO["sjpkxuanzheMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            _loc3_ = int(_loc2_.substr(4));
            if(_loc2_.indexOf("s") == -1)
            {
               if(GM.aSaveData.pkDrList.isWinByid(_loc3_))
               {
                  GoodsManger.cwTs("不可以欺负失败者!");
                  return;
               }
               if(GM.aSaveData.pkDrList.getShengxiaFn() > 0)
               {
                  this.fightId = _loc3_;
                  (this.mc["pktk5"] as MovieClip).visible = true;
                  GM.testapi.getPkSaveData();
                  this.nosavefl = 0;
                  this.mc.addEventListener(Event.ENTER_FRAME,this.savedataH);
                  return;
               }
               GoodsManger.cwTs("今天的战斗次数不够了!");
               return;
            }
            _loc4_ = GM.aSaveData.pkDrList.getEnemyByid(_loc3_);
            SjPkPanel.open(_loc4_.extO);
         }
      }
      
      private function sjpkkaipaiMcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Goods = null;
         if(param1.target.name != null && Boolean((this.mcMO["sjpkkaipaiMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            this.choosePa = int(_loc2_.substr(5,1));
            _loc3_ = 1;
            while(_loc3_ < 6)
            {
               (this.sjpkkaipaiMc["kaipa" + _loc3_ + "b"] as MovieClip).visible = false;
               _loc3_++;
            }
            (this.sjpkkaipaiMc["kaipa" + this.choosePa] as MovieClip).visible = true;
            if(GM.aSaveData.pkDrList.getStateAward(this.kaipaiThreeOne) == 0)
            {
               GM.aSaveData.pkDrList.leadAward(this.kaipaiThreeOne);
               _loc4_ = this.getKaiPaiAward();
               (this.sjpkkaipaiMc["kaipa" + this.choosePa] as MovieClip).gotoAndPlay(1);
               if(_loc4_.length > 1)
               {
                  _loc5_ = _loc4_[0] as Goods;
                  ((this.sjpkkaipaiMc["kaipa" + this.choosePa]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc5_.getFrame());
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipamingcheng"]["txt_name"] as TextField).text = _loc5_.getName() + " * " + (_loc4_[1] as VT).getValue();
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipamingcheng"]["txt_name"] as TextField).setTextFormat(new TextFormat(null,null,DiaoLouGoods.cArr[_loc5_.getColor()]));
                  if(_loc5_.getType() == GS.a2 && _loc5_.getSmallType() == GS.a4)
                  {
                     GM.cp.addGodByRole(_loc5_.getOtherValue());
                  }
                  else if(_loc5_.getType() == GS.a2 && _loc5_.getSmallType() == GS.a23)
                  {
                     GM.aSaveData.pksd.addGong(_loc5_.getOtherValue());
                  }
                  else
                  {
                     FlowInterface.addInBagDL(_loc5_,(_loc4_[1] as VT).getValue());
                  }
               }
               else if(_loc4_.length > 0)
               {
                  ((this.sjpkkaipaiMc["kaipa" + this.choosePa]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1735);
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipamingcheng"]["txt_name"] as TextField).text = "";
               }
               else
               {
                  ((this.sjpkkaipaiMc["kaipa" + this.choosePa]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1935);
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                  (this.sjpkkaipaiMc["kaipa" + this.choosePa]["kaipamingcheng"]["txt_name"] as TextField).text = "";
               }
               GM.testapi.saveDataBefore();
            }
            else
            {
               GM.findCheatMax(GS.a66);
            }
            this.sjpkkaipaiMc.addEventListener(Event.ENTER_FRAME,this.sjpkkaipaiMcH);
         }
      }
      
      private function sjpkkaipaiMcH(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Goods = null;
         var _loc5_:int = 0;
         if(curs == 1 && Boolean(this.sjpkkaipaiMc.visible) && this.kaipaiflag == 0)
         {
            if((this.sjpkkaipaiMc["kaipa" + this.choosePa] as MovieClip).currentFrame == (this.sjpkkaipaiMc["kaipa" + this.choosePa] as MovieClip).totalFrames)
            {
               this.kaipaiflag = GS.a1;
               (this.sjpkkaipaiMc["kaipa" + this.choosePa] as MovieClip).stop();
               _loc2_ = 1;
               while(_loc2_ < 6)
               {
                  if(_loc2_ != this.choosePa)
                  {
                     (this.sjpkkaipaiMc["kaipa" + _loc2_ + "b"] as MovieClip).visible = false;
                     (this.sjpkkaipaiMc["kaipa" + _loc2_] as MovieClip).visible = true;
                     _loc3_ = this.getKaiPaiAward();
                     (this.sjpkkaipaiMc["kaipa" + _loc2_] as MovieClip).gotoAndPlay(1);
                     if(_loc3_.length > 1)
                     {
                        _loc4_ = _loc3_[0] as Goods;
                        ((this.sjpkkaipaiMc["kaipa" + _loc2_]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc4_.getFrame());
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipamingcheng"]["txt_name"] as TextField).text = _loc4_.getName() + " * " + (_loc3_[1] as VT).getValue();
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipamingcheng"]["txt_name"] as TextField).setTextFormat(new TextFormat(null,null,DiaoLouGoods.cArr[_loc4_.getColor()]));
                     }
                     else if(_loc3_.length > 0)
                     {
                        ((this.sjpkkaipaiMc["kaipa" + _loc2_]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1735);
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipamingcheng"]["txt_name"] as TextField).text = "";
                     }
                     else
                     {
                        ((this.sjpkkaipaiMc["kaipa" + _loc2_]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1935);
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                        (this.sjpkkaipaiMc["kaipa" + _loc2_]["kaipamingcheng"]["txt_name"] as TextField).text = "";
                     }
                  }
                  _loc2_++;
               }
            }
         }
         if(curs == 1 && Boolean(this.sjpkkaipaiMc.visible) && this.kaipaiflag == GS.a1)
         {
            _loc5_ = 1;
            while(_loc5_ < 6)
            {
               if(_loc5_ != this.choosePa)
               {
                  if((this.sjpkkaipaiMc["kaipa" + _loc5_] as MovieClip).currentFrame == (this.sjpkkaipaiMc["kaipa" + _loc5_] as MovieClip).totalFrames)
                  {
                     this.kaipaiflag = GS.a2;
                     (this.sjpkkaipaiMc["kaipa" + _loc5_] as MovieClip).stop();
                  }
               }
               _loc5_++;
            }
         }
         if(curs == 1 && Boolean(this.sjpkkaipaiMc.visible) && this.kaipaiflag == GS.a2)
         {
            ++this.choosePa;
            if(this.choosePa > 60)
            {
               this.sjpkkaipaiMc.removeEventListener(Event.ENTER_FRAME,this.sjpkkaipaiMcH);
               this.flushEnemyList();
               this.sjpkkaipaiMc.visible = false;
               this.kaipaiflag == GS.a3;
            }
         }
      }
      
      private function danMcClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["danMO"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "pkfanyeshang":
                  if(this.maxPage == 0 || this.maxPage == 1)
                  {
                     return;
                  }
                  if(this.curPage <= 1)
                  {
                     this.curPage = this.maxPage;
                  }
                  else
                  {
                     --this.curPage;
                  }
                  this.flushRankText();
                  break;
               case "pkfanyexia":
                  if(this.maxPage == 0 || this.maxPage == 1)
                  {
                     return;
                  }
                  if(this.curPage >= this.maxPage)
                  {
                     this.curPage = 1;
                  }
                  else
                  {
                     ++this.curPage;
                  }
                  this.flushRankText();
                  break;
               case "pkclose":
                  close();
                  break;
               case "gxsd":
                  GxShopPanel.open();
                  close();
                  break;
               case "sxds":
                  if(GM.aSaveData.pkDrList.getFlushEnemyn() > 0)
                  {
                     (this.mc["pktk5"] as MovieClip).visible = true;
                     GM.testapi.flushTenEnemy();
                  }
                  else
                  {
                     GoodsManger.cwTs("道具<刷新敌人>不足!  战胜所有对手，有一次免费刷新机会哦!");
                  }
                  break;
               case "ancj1":
               case "ancj2":
               case "ancj3":
                  _loc2_ = int(GM.aSaveData.pkDrList.getStateAward(int(param1.target.name.substr(4,1))));
                  if(_loc2_ == GS.a2)
                  {
                     GoodsManger.cwTs("奖励已领过!");
                  }
                  else if(_loc2_ == GS.a1)
                  {
                     GoodsManger.cwTs("战胜的对手太少了!");
                  }
                  else
                  {
                     this.iniKaipai(int(param1.target.name.substr(4,1)));
                  }
                  break;
               case "lqphjl":
                  close();
                  GPkscoreJl.open();
                  break;
               case "sxsj":
                  GoodsManger.cwTs("此功能在下个版本开放!");
            }
         }
      }
      
      public function get fightId() : int
      {
         return this._fightId.getValue();
      }
      
      public function set fightId(param1:int) : void
      {
         this._fightId.setValue(param1);
      }
      
      public function get nosavefl() : int
      {
         return this._nosavefl.getValue();
      }
      
      public function set nosavefl(param1:int) : void
      {
         this._nosavefl.setValue(param1);
      }
      
      public function get kaipaiflag() : int
      {
         return this._kaipaiflag.getValue();
      }
      
      public function set kaipaiflag(param1:int) : void
      {
         this._kaipaiflag.setValue(param1);
      }
      
      public function get kaipaiThreeOne() : int
      {
         return this._kaipaiThreeOne.getValue();
      }
      
      public function set kaipaiThreeOne(param1:int) : void
      {
         this._kaipaiThreeOne.setValue(param1);
      }
   }
}

