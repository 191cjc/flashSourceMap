package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.online.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GOnlineServerC
   {
      
      public static var self:GOnlineServerC = new GOnlineServerC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var _fjishi:VT = VT.createVT(0);
      
      private var _ft:VT = VT.createVT(GS.a300);
      
      private var _rShowNum:VT = VT.createVT(GS.a15);
      
      private var _rshowJishi:VT = VT.createVT(0);
      
      private var _rshowflag:VT = VT.createVT(GS.a300);
      
      private var _curPage:VT = VT.createVT(GS.a1);
      
      private var _maxPage:VT = VT.createVT(GS.a1);
      
      private var mcMO:Object = new Object();
      
      private var numshowMc:MovieClip;
      
      public function GOnlineServerC()
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
         self.fjishi = 0;
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Class = null;
         if(this.mc == null)
         {
            _loc3_ = new Array();
            _loc3_.push("j_xuanfu");
            if(GM.testapi.jobFlag == GS.a1)
            {
               _loc3_.push("skin_wman");
               _loc3_.push("e_wchushitao");
               _loc3_.push("e_chushitao");
               _loc3_.push("WuqiB_xinshoupao");
               _loc3_.push("WuqiB_xinshouqiang");
            }
            else
            {
               _loc3_.push("skin_man");
               _loc3_.push("e_wchushitao");
               _loc3_.push("e_chushitao");
               _loc3_.push("WuqiB_xinshoupao");
               _loc3_.push("WuqiB_xinshouqiang");
            }
            if(!(Boolean(LoaderManager.isLoadedBySwfname(_loc3_[0])) && Boolean(LoaderManager.isLoadedBySwfname(_loc3_[1])) && Boolean(LoaderManager.isLoadedBySwfname(_loc3_[2])) && Boolean(LoaderManager.isLoadedBySwfname(_loc3_[3])) && Boolean(LoaderManager.isLoadedBySwfname(_loc3_[4])) && Boolean(LoaderManager.isLoadedBySwfname(_loc3_[5]))))
            {
               if(GM.loaderM.keYiUse())
               {
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc4_ = LoaderManager.getSwfClass("j_xuanfu") as Class;
            this.mc = new _loc4_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["fuwuqlj"] as MovieClip).visible = false;
         (this.mc["pindaolj"] as MovieClip).visible = false;
         this.numshowMc = this.mc["numshow"];
         this.initRShowNum();
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["ckclose_btn"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["sx"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["tcdqfwq"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["scfanyeshang"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["scfanyexia"]));
         var _loc2_:int = 1;
         while(_loc2_ < 10)
         {
            _loc1_.addBtnLianDong(new McBtn(this.mc["fwq" + _loc2_]));
            _loc1_.addBtnLianDong(new McBtn(this.mc["pd" + _loc2_]));
            _loc2_++;
         }
         this.mcMO["btnbtn"] = _loc1_;
         GM.cbGview.addChild(this.mc);
         this.numshowMc.addEventListener(MouseEvent.CLICK,this.numshowMcH);
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
         this.mc.addEventListener(Event.ENTER_FRAME,this.frameH);
         this.closeState();
         if(GM.onlineM.isConnectLine())
         {
            this.initServerListData();
            this.initState(GM.onlineM.curServer,GM.onlineM.curLine);
         }
         else if(this.fjishi <= 0)
         {
            (this.mc["fuwuqlj"] as MovieClip).visible = true;
            GM.onlineM.connectLoninServer();
            this.fjishi = this.ft;
         }
         else
         {
            this.initServerListData();
         }
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.numshowMc.removeEventListener(MouseEvent.CLICK,this.numshowMcH);
            this.numshowMc = null;
            (this.mcMO["btnbtn"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      public function initServerListData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         if(curs == 1)
         {
            (this.mc["fuwuqlj"] as MovieClip).visible = false;
            _loc1_ = GM.onlineM.cList;
            _loc2_ = 1;
            _loc3_ = 1;
            while(_loc3_ < 100)
            {
               if(_loc3_ * 9 >= _loc1_.length)
               {
                  _loc2_ = _loc3_;
                  break;
               }
               _loc3_++;
            }
            this.maxPage = _loc2_;
            if(this.curPage > this.maxPage)
            {
               this.curPage = GS.a1;
            }
            (this.mc["scyeshu"] as TextField).text = "" + this.curPage + "/" + this.maxPage;
            _loc4_ = 1;
            while(_loc4_ < 10)
            {
               _loc5_ = _loc1_[_loc4_ + (this.curPage - 1) * 9 - 1];
               if(_loc5_ != null)
               {
                  _loc6_ = _loc5_.num / OnlineManager.sMaxNum;
                  (this.mc["fwq" + _loc4_] as MovieClip).visible = true;
                  (this.mc["fwq" + _loc4_]["datatext"]["zttiao"]["xgxiaotiaoa"] as MovieClip).scaleX = _loc6_;
                  (this.mc["fwq" + _loc4_]["datatext"]["zt"] as MovieClip).gotoAndStop(int(_loc6_ * 4) + 1);
                  (this.mc["fwq" + _loc4_]["qiezhen"] as MovieClip).gotoAndStop(_loc4_ + (this.curPage - 1) * 9);
               }
               else
               {
                  (this.mc["fwq" + _loc4_] as MovieClip).visible = false;
               }
               _loc4_++;
            }
            this.initState(GM.onlineM.curServer,GM.onlineM.curLine);
         }
      }
      
      public function initRShowNum() : void
      {
         (this.numshowMc["ren" + 5] as MovieClip).gotoAndStop(2);
         (this.numshowMc["ren" + 10] as MovieClip).gotoAndStop(2);
         (this.numshowMc["ren" + 15] as MovieClip).gotoAndStop(2);
         (this.numshowMc["ren" + 25] as MovieClip).gotoAndStop(2);
         (this.numshowMc["ren" + 35] as MovieClip).gotoAndStop(2);
         (this.numshowMc["ren" + 50] as MovieClip).gotoAndStop(2);
         (this.numshowMc["ren" + this.rShowNum] as MovieClip).gotoAndStop(1);
      }
      
      public function closeState() : void
      {
         var _loc1_:int = 0;
         if(curs == 1)
         {
            _loc1_ = 1;
            while(_loc1_ < 10)
            {
               (this.mc["pd" + _loc1_]["szpd"] as MovieClip).visible = false;
               (this.mc["fwq" + _loc1_]["szpd"] as MovieClip).visible = false;
               _loc1_++;
            }
         }
      }
      
      public function initState(param1:int, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(curs == 1)
         {
            _loc3_ = false;
            if(param1 > 0)
            {
               if(param1 <= this.curPage * 9 && param1 > (this.curPage - 1) * 9)
               {
                  _loc3_ = true;
               }
            }
            (this.mc["pindaolj"] as MovieClip).visible = false;
            _loc4_ = 1;
            while(_loc4_ < 10)
            {
               if(param2 == _loc4_)
               {
                  (this.mc["pd" + _loc4_]["szpd"] as MovieClip).visible = true;
               }
               else
               {
                  (this.mc["pd" + _loc4_]["szpd"] as MovieClip).visible = false;
               }
               if(_loc3_)
               {
                  if(param1 == _loc4_ + (this.curPage - 1) * 9)
                  {
                     (this.mc["fwq" + _loc4_]["szpd"] as MovieClip).visible = true;
                  }
                  else
                  {
                     (this.mc["fwq" + _loc4_]["szpd"] as MovieClip).visible = false;
                  }
               }
               else
               {
                  (this.mc["fwq" + _loc4_]["szpd"] as MovieClip).visible = false;
               }
               _loc4_++;
            }
         }
      }
      
      private function frameH(param1:Event) : void
      {
         if(this.fjishi > 0)
         {
            --this.fjishi;
         }
         (this.mc["djs"] as TextField).text = "" + int(this.fjishi / 30);
         (this.mc["djs1"] as TextField).text = "" + int(this.fjishi / 30);
         if(GM.frameTime - this.rshowJishi > this.rshowflag)
         {
            (this.mc["djs2"] as TextField).text = "" + 0;
         }
         else
         {
            (this.mc["djs2"] as TextField).text = "" + int((this.rshowflag - (GM.frameTime - this.rshowJishi)) / 30 + 1);
         }
      }
      
      private function numshowMcH(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(GM.frameTime - this.rshowJishi > this.rshowflag)
         {
            _loc2_ = int(String(param1.target.name).substr(3));
            if(_loc2_ != this.rShowNum)
            {
               _loc3_ = this.rShowNum;
               this.rshowJishi = GM.frameTime;
               this.rShowNum = _loc2_;
               this.initRShowNum();
               if(GM.onlineM.isConnectLine())
               {
                  if(_loc3_ > this.rShowNum)
                  {
                     GM.onlineM.removeRByLimit();
                  }
                  else
                  {
                     GM.onlineM.fRoleList();
                  }
               }
            }
         }
         else
         {
            GoodsManger.cwTs("稍等一会会吧!");
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(param1.target.name != null && Boolean((this.mcMO["btnbtn"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            switch(param1.target.name)
            {
               case "ckclose_btn":
                  this.leave();
                  break;
               case "sx":
                  if(this.fjishi > 0)
                  {
                     GoodsManger.cwTs("稍等一会会吧!");
                  }
                  else
                  {
                     (this.mc["fuwuqlj"] as MovieClip).visible = true;
                     GM.onlineM.connectLoninServer();
                     this.fjishi = this.ft;
                  }
                  break;
               case "scfanyeshang":
                  if(this.curPage == 1)
                  {
                     this.curPage = this.maxPage;
                  }
                  else
                  {
                     --this.curPage;
                  }
                  this.initServerListData();
                  break;
               case "scfanyexia":
                  if(this.curPage == this.maxPage)
                  {
                     this.curPage = 1;
                  }
                  else
                  {
                     ++this.curPage;
                  }
                  this.initServerListData();
                  break;
               case "tcdqfwq":
                  if(this.fjishi > 0)
                  {
                     GoodsManger.cwTs("稍等一会会吧!");
                  }
                  else if(GM.onlineM.isConnectLine())
                  {
                     GM.onlineM.exitLine();
                     this.closeState();
                     (this.mc["fuwuqlj"] as MovieClip).visible = true;
                     GM.onlineM.connectLoninServer();
                     this.fjishi = this.ft;
                  }
                  else
                  {
                     GoodsManger.cwTs("没有进入任何服务器!");
                  }
                  break;
               default:
                  _loc3_ = int(_loc2_.substr(-1,1));
                  _loc4_ = _loc2_.substr(0,_loc2_.length - 1);
                  if(_loc4_ == "fwq")
                  {
                     if(GM.onlineM.isConnectLine())
                     {
                        GoodsManger.cwTs("请先退出当前服务器!");
                     }
                     else
                     {
                        (this.mc["pindaolj"] as MovieClip).visible = true;
                        GM.onlineM.connectChannelServer(_loc3_ + (this.curPage - 1) * 9);
                     }
                  }
                  if(_loc4_ == "pd")
                  {
                     if(GM.onlineM.isConnectLine())
                     {
                        if(GM.onlineM.curLine != _loc3_)
                        {
                           (this.mc["pindaolj"] as MovieClip).visible = true;
                           GM.onlineM.fChLine(_loc3_);
                        }
                        else
                        {
                           GoodsManger.cwTs("您已经在这个频道里了!");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("还没有进入任何频道，换不了频道!");
                     }
                  }
            }
         }
      }
      
      public function get fjishi() : int
      {
         return this._fjishi.getValue();
      }
      
      public function set fjishi(param1:int) : void
      {
         this._fjishi.setValue(param1);
      }
      
      public function get ft() : int
      {
         return this._ft.getValue();
      }
      
      public function set ft(param1:int) : void
      {
         this._ft.setValue(param1);
      }
      
      public function get rShowNum() : int
      {
         return this._rShowNum.getValue();
      }
      
      public function set rShowNum(param1:int) : void
      {
         this._rShowNum.setValue(param1);
      }
      
      public function get rshowJishi() : Number
      {
         return this._rshowJishi.getValue();
      }
      
      public function set rshowJishi(param1:Number) : void
      {
         this._rshowJishi.setValue(param1);
      }
      
      public function get rshowflag() : int
      {
         return this._rshowflag.getValue();
      }
      
      public function set rshowflag(param1:int) : void
      {
         this._rshowflag.setValue(param1);
      }
      
      public function get curPage() : int
      {
         return this._curPage.getValue();
      }
      
      public function set curPage(param1:int) : void
      {
         this._curPage.setValue(param1);
      }
      
      public function get maxPage() : int
      {
         return this._maxPage.getValue();
      }
      
      public function set maxPage(param1:int) : void
      {
         this._maxPage.setValue(param1);
      }
   }
}

