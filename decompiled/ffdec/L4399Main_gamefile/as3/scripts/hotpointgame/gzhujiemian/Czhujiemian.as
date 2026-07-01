package hotpointgame.gzhujiemian
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ztcCD;
   import hotpointgame.ginit.*;
   import hotpointgame.gview.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.chongwu.*;
   import hotpointgame.views.everyDayPanel.*;
   import hotpointgame.views.giftPanel.*;
   import hotpointgame.views.jijiaPanel.*;
   import hotpointgame.views.onLineJl.*;
   import hotpointgame.views.shipPanel.*;
   import hotpointgame.views.signPanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.vipPanel.*;
   import hotpointgame.views.zenfuPanel.*;
   
   public class Czhujiemian
   {
      
      public static var self:Czhujiemian = new Czhujiemian();
      
      private var mc:MovieClip;
      
      private var ljMc:MovieClip;
      
      private var btnbuttonMc:MovieClip;
      
      private var xitongcaidanMc:MovieClip;
      
      private var wanjiaxzkczMc:MovieClip;
      
      private var wanjiazawuqwczMc:MovieClip;
      
      private var wanjiakaiqiqiangcaocMc:MovieClip;
      
      private var petMc:MovieClip;
      
      private var jsxxMc:MovieClip;
      
      private var mcarr:Array = [100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100];
      
      private var lijinum:int = 0;
      
      private var cur:int = 0;
      
      private var mcMO:Object = new Object();
      
      private var _saveframe:VT = VT.createVT(-1000);
      
      public function Czhujiemian()
      {
         super();
      }
      
      public function init() : void
      {
         var _loc1_:Class = null;
         var _loc2_:McBtnLianDong = null;
         var _loc3_:TextField = null;
         if(this.cur == 0)
         {
            this.cur = 1;
            _loc1_ = LoaderManager.getSwfClass("zhujiemian") as Class;
            this.mc = new _loc1_() as MovieClip;
            this.mc.stop();
            this.jsxxMc = this.mc["jsxx"];
            (this.jsxxMc["rwtx"] as MovieClip).gotoAndStop(FlowInterface.getJobByRole());
            (this.jsxxMc["wjjmaqbs"] as MovieClip).visible = false;
            (this.jsxxMc["wjshixuezhi"] as MovieClip).gotoAndStop(1);
            (this.jsxxMc["shixuezhipull"] as MovieClip).visible = false;
            this.skillTiaoAllClose();
            this.ljMc = this.mc["lianjijihe"];
            this.ljMc.visible = false;
            (this.ljMc["a"] as MovieClip).gotoAndStop(1);
            (this.ljMc["b"] as MovieClip).gotoAndStop(1);
            (this.ljMc["c"] as MovieClip).gotoAndStop(1);
            (this.ljMc["d"] as MovieClip).gotoAndStop(1);
            this.ljMc.cacheAsBitmap = true;
            this.gunSlotInit();
            this.buffInit();
            this.btnbuttonMc = this.mc["btnbuttonc"];
            _loc2_ = new McBtnLianDong();
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["beibaoanniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["xitonganniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["renwumianban"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["shangchenganniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["chongwuanniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["caosuoa"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["caosuob"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["jieshaanniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["shiershengxiao"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["jijiaanniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["lianjicsb"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["qiandao"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["juntuanlianmeng"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["libaohuodong"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["qiannenganniu"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["viplevelbtn"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["zxjj"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["jxzs"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["ljcz"]));
            _loc2_.addBtnLianDong(new McBtn(this.btnbuttonMc["czscw"]));
            this.setVipLevel();
            this.initHideBtn();
            this.mcMO["btnbuttonc"] = _loc2_;
            this.wanjiaxzkczMc = this.mc["wanjiaxzkcz"];
            this.wanjiazawuqwczMc = this.mc["wanjiazawuqwcz"];
            this.wanjiakaiqiqiangcaocMc = this.mc["wanjiakaiqiqiangcaoc"];
            this.wanjiaxzkczMc.visible = false;
            this.wanjiazawuqwczMc.visible = false;
            this.wanjiakaiqiqiangcaocMc.visible = false;
            _loc2_ = new McBtnLianDong();
            _loc2_.addBtnLianDong(new McBtn(this.wanjiazawuqwczMc["scqwczan"]));
            _loc2_.addBtnLianDong(new McBtn(this.wanjiazawuqwczMc["sctok"]));
            this.mcMO["wanjiazawuqwcz"] = _loc2_;
            _loc2_ = new McBtnLianDong();
            _loc2_.addBtnLianDong(new McBtn(this.wanjiakaiqiqiangcaocMc["okkk_0"]));
            _loc2_.addBtnLianDong(new McBtn(this.wanjiakaiqiqiangcaocMc["okkk_1"]));
            this.mcMO["wanjiakaiqiqiangcaoc"] = _loc2_;
            this.xitongcaidanMc = this.mc["xitongcaidan"];
            this.xitongcaidanMc.visible = false;
            _loc2_ = new McBtnLianDong();
            _loc2_.addBtnLianDong(new McBtn(this.xitongcaidanMc["baocunyouxi"]));
            _loc2_.addBtnLianDong(new McBtn(this.xitongcaidanMc["fanhuijidi"]));
            _loc2_.addBtnLianDong(new McBtn(this.xitongcaidanMc["youxiluntan"]));
            _loc2_.addBtnLianDong(new McBtn(this.xitongcaidanMc["fanhuizhucaidan"]));
            _loc2_.addBtnLianDong(new McBtn(this.xitongcaidanMc["menuxxx"]));
            this.mcMO["xitongcaidan"] = _loc2_;
            (this.xitongcaidanMc["save"] as TextField).text = "0";
            this.setHuaZhi();
            this.petMc = this.mc["chongwuzhuangtai"];
            this.petMc.visible = false;
            (this.petMc["chongwudengjishuzi"] as MovieClip).gotoAndStop(1);
            (this.petMc["chongwutouxiang"] as MovieClip).gotoAndStop(5);
            (this.petMc["chongwutouxiang"]["cw"] as MovieClip).gotoAndStop(1);
            _loc3_ = new TextField();
            _loc3_.mouseEnabled = false;
            _loc3_.defaultTextFormat = new TextFormat("宋体",16,16711680);
            _loc3_.text = "适当娱乐，理性消费";
            _loc3_.width = 300;
            _loc3_.selectable = false;
            _loc3_.x = 425;
            _loc3_.y = 315;
            this.wanjiakaiqiqiangcaocMc.addChild(_loc3_);
            this.wanjiazawuqwczMc.addEventListener(MouseEvent.CLICK,this.wanjiazawuqwczMcH);
            this.wanjiakaiqiqiangcaocMc.addEventListener(MouseEvent.CLICK,this.wanjiakaiqiqiangcaocMcH);
            this.btnbuttonMc.addEventListener(MouseEvent.CLICK,this.btnbuttonH);
            this.xitongcaidanMc.addEventListener(MouseEvent.CLICK,this.xitongcaidanH);
            GM.cb.addChild(this.mc);
         }
      }
      
      public function remove() : void
      {
         if(this.cur == 1)
         {
            this.cur = 0;
            this.ljMc = null;
            (this.mcMO["btnbuttonc"] as McBtnLianDong).remove();
            (this.mcMO["xitongcaidan"] as McBtnLianDong).remove();
            (this.mcMO["wanjiazawuqwcz"] as McBtnLianDong).remove();
            (this.mcMO["wanjiakaiqiqiangcaoc"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.wanjiazawuqwczMc.removeEventListener(MouseEvent.CLICK,this.wanjiazawuqwczMcH);
            this.wanjiakaiqiqiangcaocMc.removeEventListener(MouseEvent.CLICK,this.wanjiakaiqiqiangcaocMcH);
            this.btnbuttonMc.removeEventListener(MouseEvent.CLICK,this.btnbuttonH);
            this.xitongcaidanMc.removeEventListener(MouseEvent.CLICK,this.xitongcaidanH);
            this.wanjiaxzkczMc = null;
            this.wanjiazawuqwczMc = null;
            this.wanjiakaiqiqiangcaocMc = null;
            this.btnbuttonMc = null;
            this.xitongcaidanMc = null;
            this.petMc = null;
            this.jsxxMc = null;
            GM.cb.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      public function buffInit() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 9)
         {
            (this.mc["buff" + _loc1_] as MovieClip).gotoAndStop(1);
            (this.mc["buff" + _loc1_] as MovieClip).visible = false;
            _loc1_++;
         }
      }
      
      public function attBuffUpdate() : void
      {
         var _loc3_:Sprite = null;
         var _loc1_:int = 0;
         var _loc2_:ztcCD = GM.cp.zCd;
         if(_loc2_.attvaluejishi > 0)
         {
            _loc1_++;
            (this.mc["buff" + _loc1_] as MovieClip).visible = true;
            (this.mc["buff" + _loc1_] as MovieClip).gotoAndStop(1);
            _loc3_ = (this.mc["buff" + _loc1_]["buffb1"] as SimpleButton).overState as Sprite;
            ((_loc3_.getChildAt(1) as MovieClip).getChildAt(1) as TextField).text = "攻击力获得" + Number(_loc2_.attvalue * 100).toFixed(1) + "%增幅,持续时间" + Number(_loc2_.attvaluejishi / 60).toFixed(1) + "秒";
         }
         if(_loc2_.attKillm > 0)
         {
            _loc1_++;
            (this.mc["buff" + _loc1_] as MovieClip).visible = true;
            (this.mc["buff" + _loc1_] as MovieClip).gotoAndStop(4);
            _loc3_ = (this.mc["buff" + _loc1_]["buffb1"] as SimpleButton).overState as Sprite;
            ((_loc3_.getChildAt(1) as MovieClip).getChildAt(1) as TextField).text = "杀怪攻击力增幅" + Number(_loc2_.attKillm * 100).toFixed(1) + "%过关后清零";
         }
         if(_loc2_.weizhanTime > 0)
         {
            _loc1_++;
            (this.mc["buff" + _loc1_] as MovieClip).visible = true;
            (this.mc["buff" + _loc1_] as MovieClip).gotoAndStop(2);
            _loc3_ = (this.mc["buff" + _loc1_]["buffb1"] as SimpleButton).overState as Sprite;
            ((_loc3_.getChildAt(1) as MovieClip).getChildAt(1) as TextField).text = "无敌状态,持续时间" + Number(_loc2_.weizhanTime / 60).toFixed(1) + "秒";
         }
         var _loc4_:Array = GM.cp.bCd.getJiangSu();
         if(_loc4_ != null)
         {
            _loc1_++;
            (this.mc["buff" + _loc1_] as MovieClip).visible = true;
            (this.mc["buff" + _loc1_] as MovieClip).gotoAndStop(3);
            _loc3_ = (this.mc["buff" + _loc1_]["buffb1"] as SimpleButton).overState as Sprite;
            ((_loc3_.getChildAt(1) as MovieClip).getChildAt(1) as TextField).text = "被减速" + Number(_loc4_[1] * 100).toFixed(1) + "%,持续时间" + Number(_loc4_[0] / 60).toFixed(1) + "秒";
         }
         var _loc5_:int = ++_loc1_;
         while(_loc5_ < 9)
         {
            (this.mc["buff" + _loc5_] as MovieClip).gotoAndStop(1);
            (this.mc["buff" + _loc5_] as MovieClip).visible = false;
            _loc5_++;
         }
      }
      
      public function showHeadLv(param1:int, param2:int) : void
      {
         this.petMc.visible = true;
         (this.petMc["chongwutouxiang"] as MovieClip).gotoAndStop(param1);
         (this.petMc["chongwutouxiang"]["cw"] as MovieClip).gotoAndStop(param2 + 1);
      }
      
      public function petHeadNoShow() : void
      {
         this.petMc.visible = false;
      }
      
      public function petUpdateHp(param1:int, param2:int, param3:int) : void
      {
         if(param1 == 0)
         {
            (this.petMc["anejianfuhuo"] as MovieClip).visible = true;
         }
         else
         {
            (this.petMc["anejianfuhuo"] as MovieClip).visible = false;
         }
         (this.petMc["chongwudengjishuzi"] as MovieClip).gotoAndStop(param3);
         (this.petMc["renwuxuetiao"]["xuetiaoa"] as MovieClip).scaleX = param1 / param2;
         (this.petMc["cwxtsz"] as TextField).text = "" + param1 + "/" + param2;
      }
      
      public function setVipLevel() : void
      {
         if(this.btnbuttonMc != null)
         {
            (this.btnbuttonMc["viplevelbtn"]["vl"] as MovieClip).gotoAndStop(VipDataManager.vself.getVipL() + 1);
         }
      }
      
      public function skillTiaoAllClose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            (this.mc["jinnengkuang" + _loc1_] as MovieClip).gotoAndStop(1);
            (this.mc["jinnengkuang" + _loc1_] as MovieClip).visible = false;
            (this.mc["jinnengkuang" + _loc1_] as MovieClip).cacheAsBitmap = true;
            (this.mc["Skill" + _loc1_] as MovieClip).gotoAndStop(1);
            (this.mc["Skill" + _loc1_] as MovieClip).visible = false;
            (this.mc["Skill" + _loc1_] as MovieClip).cacheAsBitmap = true;
            (this.mc["jinzhao" + _loc1_] as MovieClip).gotoAndStop(1);
            (this.mc["jinzhao" + _loc1_] as MovieClip).visible = false;
            (this.mc["jinzhao" + _loc1_] as MovieClip).cacheAsBitmap = true;
            _loc1_++;
         }
      }
      
      public function skillTiaoInit(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 < 7)
         {
            _loc2_ = param1;
            if(FlowInterface.getJobByRole() == GS.a2)
            {
               _loc2_ += 54;
            }
            (this.mc["jinnengkuang" + param1] as MovieClip).gotoAndStop(_loc2_ + 1);
            (this.mc["jinnengkuang" + param1] as MovieClip).visible = true;
            (this.mc["jinzhao" + param1] as MovieClip).gotoAndStop(100);
            (this.mc["jinzhao" + param1] as MovieClip).visible = true;
         }
      }
      
      public function skillTiaoInitByJiJia(param1:int, param2:int) : void
      {
         if(param1 < 7)
         {
            (this.mc["jinnengkuang" + param1] as MovieClip).gotoAndStop(param2);
            (this.mc["jinnengkuang" + param1] as MovieClip).visible = true;
            (this.mc["jinzhao" + param1] as MovieClip).gotoAndStop(100);
            (this.mc["jinzhao" + param1] as MovieClip).visible = true;
         }
      }
      
      public function skillTiaoInitByWX(param1:int, param2:int) : void
      {
         if(param1 > 0 && param1 < 5)
         {
            (this.mc["jinnengkuang" + (6 + param1)] as MovieClip).gotoAndStop(param2);
            (this.mc["jinnengkuang" + (6 + param1)] as MovieClip).visible = true;
            (this.mc["jinzhao" + (6 + param1)] as MovieClip).gotoAndStop(100);
            (this.mc["jinzhao" + (6 + param1)] as MovieClip).visible = true;
         }
      }
      
      public function skillTiaoInitWXByClear(param1:int) : void
      {
         if(param1 > 0 && param1 < 5)
         {
            (this.mc["jinnengkuang" + (6 + param1)] as MovieClip).gotoAndStop(1);
            (this.mc["jinnengkuang" + (6 + param1)] as MovieClip).visible = false;
            (this.mc["jinzhao" + (6 + param1)] as MovieClip).gotoAndStop(1);
            (this.mc["jinzhao" + (6 + param1)] as MovieClip).visible = false;
         }
      }
      
      public function upSkillTiao(param1:int, param2:int, param3:Boolean) : void
      {
         if(param1 < 11)
         {
            if(param2 > 100)
            {
               param2 = 100;
            }
            if(param2 == 0)
            {
               param2 = 1;
            }
            if(this.mcarr[param1] != param2)
            {
               (this.mc["jinzhao" + param1] as MovieClip).gotoAndStop(param2);
               if(param2 == 100 && this.mcarr[param1] != 1)
               {
                  XiaoXiaoManager.addCGX(new CGXSkillOk(this.mc["Skill" + param1]));
               }
               this.mcarr[param1] = param2;
            }
            if(param2 == 100)
            {
               if(param3)
               {
                  (this.mc["jinzhao" + param1] as MovieClip).gotoAndStop(100);
               }
               else
               {
                  (this.mc["jinzhao" + param1] as MovieClip).gotoAndStop(1);
               }
            }
         }
      }
      
      public function hideBtnByLevel() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["beibaoanniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["chongwuanniu"] as MovieClip).visible = false;
         }
      }
      
      public function showBtnByLevel() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["beibaoanniu"] as MovieClip).visible = true;
            (this.btnbuttonMc["chongwuanniu"] as MovieClip).visible = true;
         }
      }
      
      private function initHideBtn() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["jieshaanniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["ljcz"] as MovieClip).visible = false;
            (this.btnbuttonMc["czscw"] as MovieClip).visible = false;
            (this.btnbuttonMc["zxjj"] as MovieClip).visible = false;
            (this.btnbuttonMc["shiershengxiao"] as MovieClip).visible = false;
            (this.btnbuttonMc["jijiaanniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["qiandao"] as MovieClip).visible = false;
            (this.btnbuttonMc["juntuanlianmeng"] as MovieClip).visible = false;
            (this.btnbuttonMc["libaohuodong"] as MovieClip).visible = false;
            (this.btnbuttonMc["qiannenganniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["viplevelbtn"] as MovieClip).visible = false;
            (this.btnbuttonMc["jxzs"] as MovieClip).visible = false;
            (this.btnbuttonMc["lianjicsb"] as MovieClip).visible = false;
            (this.btnbuttonMc["shangchenganniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["tq1"] as MovieClip).visible = false;
            (this.btnbuttonMc["tq2"] as MovieClip).visible = false;
         }
      }
      
      public function hideBtnByLevelByAll() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["jieshaanniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["ljcz"] as MovieClip).visible = false;
            (this.btnbuttonMc["czscw"] as MovieClip).visible = false;
            (this.btnbuttonMc["zxjj"] as MovieClip).visible = false;
            (this.btnbuttonMc["shiershengxiao"] as MovieClip).visible = false;
            (this.btnbuttonMc["jijiaanniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["qiandao"] as MovieClip).visible = false;
            (this.btnbuttonMc["juntuanlianmeng"] as MovieClip).visible = false;
            (this.btnbuttonMc["libaohuodong"] as MovieClip).visible = false;
            (this.btnbuttonMc["qiannenganniu"] as MovieClip).visible = false;
            (this.btnbuttonMc["viplevelbtn"] as MovieClip).visible = false;
            (this.btnbuttonMc["jxzs"] as MovieClip).visible = false;
            (this.btnbuttonMc["shangchenganniu"] as MovieClip).visible = false;
         }
      }
      
      public function showBtnByLevelByAll() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["jieshaanniu"] as MovieClip).visible = true;
            (this.btnbuttonMc["ljcz"] as MovieClip).visible = true;
            (this.btnbuttonMc["czscw"] as MovieClip).visible = true;
            (this.btnbuttonMc["zxjj"] as MovieClip).visible = true;
            (this.btnbuttonMc["shiershengxiao"] as MovieClip).visible = true;
            (this.btnbuttonMc["jijiaanniu"] as MovieClip).visible = true;
            (this.btnbuttonMc["qiandao"] as MovieClip).visible = true;
            (this.btnbuttonMc["juntuanlianmeng"] as MovieClip).visible = true;
            (this.btnbuttonMc["libaohuodong"] as MovieClip).visible = true;
            (this.btnbuttonMc["qiannenganniu"] as MovieClip).visible = true;
            (this.btnbuttonMc["viplevelbtn"] as MovieClip).visible = true;
            (this.btnbuttonMc["jxzs"] as MovieClip).visible = true;
            (this.btnbuttonMc["shangchenganniu"] as MovieClip).visible = true;
         }
      }
      
      public function hideTQ() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["tq1"] as MovieClip).stop();
            (this.btnbuttonMc["tq2"] as MovieClip).stop();
            (this.btnbuttonMc["tq1"] as MovieClip).visible = false;
            (this.btnbuttonMc["tq2"] as MovieClip).visible = false;
         }
      }
      
      public function showTQ(param1:int) : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["tq1"] as MovieClip).gotoAndStop(param1);
            (this.btnbuttonMc["tq2"] as MovieClip).gotoAndStop(param1);
            (this.btnbuttonMc["tq1"] as MovieClip).visible = true;
            (this.btnbuttonMc["tq2"] as MovieClip).visible = true;
            XiaoXiaoManager.addCGX(new CGXTimeView(this.btnbuttonMc["tq1"] as MovieClip,null,60));
         }
      }
      
      public function hideBtnOnline() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["lianjicsb"] as MovieClip).visible = false;
            this.hideBtnByLevelByAll();
         }
      }
      
      public function showBtnOnline() : void
      {
         if(this.cur == 1)
         {
            (this.btnbuttonMc["lianjicsb"] as MovieClip).visible = true;
            this.showBtnByLevelByAll();
         }
      }
      
      public function upLianJINum(param1:int) : void
      {
         if(this.lijinum == param1)
         {
            return;
         }
         this.lijinum = param1;
         if(param1 == 0)
         {
            this.ljMc.visible = false;
            return;
         }
         this.ljMc.visible = true;
         var _loc2_:String = String(param1);
         var _loc3_:int = _loc2_.length;
         if(param1 > 999)
         {
            (this.ljMc["a"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 1,1)) + 1);
            (this.ljMc["b"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 2,1)) + 1);
            (this.ljMc["c"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 3,1)) + 1);
            (this.ljMc["d"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 4,1)) + 1);
            (this.ljMc["good"] as MovieClip).visible = false;
            (this.ljMc["cool"] as MovieClip).visible = false;
            (this.ljMc["perfect"] as MovieClip).visible = true;
            return;
         }
         if(param1 > 99)
         {
            (this.ljMc["a"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 1,1)) + 1);
            (this.ljMc["b"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 2,1)) + 1);
            (this.ljMc["c"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 3,1)) + 1);
            (this.ljMc["d"] as MovieClip).gotoAndStop(11);
            (this.ljMc["good"] as MovieClip).visible = false;
            if(param1 >= 200)
            {
               (this.ljMc["cool"] as MovieClip).visible = false;
               (this.ljMc["perfect"] as MovieClip).visible = true;
            }
            else
            {
               (this.ljMc["cool"] as MovieClip).visible = true;
               (this.ljMc["perfect"] as MovieClip).visible = false;
            }
            return;
         }
         if(param1 > 9)
         {
            (this.ljMc["a"] as MovieClip).gotoAndStop(11);
            (this.ljMc["b"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 1,1)) + 1);
            (this.ljMc["c"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 2,1)) + 1);
            (this.ljMc["d"] as MovieClip).gotoAndStop(11);
            if(param1 >= 50)
            {
               (this.ljMc["good"] as MovieClip).visible = true;
            }
            (this.ljMc["cool"] as MovieClip).visible = false;
            (this.ljMc["perfect"] as MovieClip).visible = false;
            return;
         }
         if(param1 > 0)
         {
            (this.ljMc["a"] as MovieClip).gotoAndStop(11);
            (this.ljMc["b"] as MovieClip).gotoAndStop(int(_loc2_.substr(_loc3_ - 1,1)) + 1);
            (this.ljMc["c"] as MovieClip).gotoAndStop(11);
            (this.ljMc["d"] as MovieClip).gotoAndStop(11);
            (this.ljMc["good"] as MovieClip).visible = false;
            (this.ljMc["cool"] as MovieClip).visible = false;
            (this.ljMc["perfect"] as MovieClip).visible = false;
            return;
         }
      }
      
      public function changeAngerTiao(param1:int) : void
      {
         (this.jsxxMc["wjshixuezhi"] as MovieClip).gotoAndStop(param1);
         if(param1 == GS.a100)
         {
            (this.jsxxMc["wjjmaqbs"] as MovieClip).visible = true;
         }
         else
         {
            (this.jsxxMc["wjjmaqbs"] as MovieClip).visible = false;
         }
      }
      
      public function changeAngerButton(param1:Boolean) : void
      {
         (this.jsxxMc["wjjmaqbs"] as MovieClip).visible = param1;
      }
      
      public function changeAngerShow(param1:Boolean) : void
      {
         (this.jsxxMc["shixuezhipull"] as MovieClip).visible = param1;
      }
      
      public function gunSlotInit() : void
      {
         (this.mc["caotubiaoa"] as MovieClip).gotoAndStop(1);
         (this.mc["caotubiaob"] as MovieClip).gotoAndStop(1);
         (this.mc["caotubiaoc"] as MovieClip).gotoAndStop(1);
         (this.mc["caotubiaod"] as MovieClip).gotoAndStop(1);
         (this.mc["caoxuandingkuangb"] as MovieClip).visible = false;
         (this.mc["caoxuandingkuangc"] as MovieClip).visible = false;
         (this.mc["caoxuandingkuangd"] as MovieClip).visible = false;
         (this.mc["caoshuliangb"] as TextField).text = "0";
         (this.mc["caoshuliangc"] as TextField).text = "0";
         (this.mc["caoshuliangd"] as TextField).text = "0";
      }
      
      public function gunSlotBtnShow(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               (this.btnbuttonMc["caosuoa"] as MovieClip).visible = true;
               (this.btnbuttonMc["caosuob"] as MovieClip).visible = true;
               break;
            case GS.a1:
               (this.btnbuttonMc["caosuoa"] as MovieClip).visible = false;
               (this.btnbuttonMc["caosuob"] as MovieClip).visible = true;
               break;
            case GS.a2:
               (this.btnbuttonMc["caosuoa"] as MovieClip).visible = false;
               (this.btnbuttonMc["caosuob"] as MovieClip).visible = false;
         }
      }
      
      public function showBulletNum(param1:int, param2:String) : void
      {
         switch(param1)
         {
            case GS.a2:
               (this.mc["caoshuliangb"] as TextField).text = param2;
               break;
            case GS.a3:
               (this.mc["caoshuliangc"] as TextField).text = param2;
               break;
            case GS.a4:
               (this.mc["caoshuliangd"] as TextField).text = param2;
         }
      }
      
      public function gunSlotChangeGun(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case GS.a1:
               (this.mc["caotubiaoa"] as MovieClip).gotoAndStop(param2);
               break;
            case GS.a2:
               (this.mc["caotubiaob"] as MovieClip).gotoAndStop(param2);
               break;
            case GS.a3:
               (this.mc["caotubiaoc"] as MovieClip).gotoAndStop(param2);
               break;
            case GS.a4:
               (this.mc["caotubiaod"] as MovieClip).gotoAndStop(param2);
         }
      }
      
      public function gunSlotCurrentState(param1:int) : void
      {
         switch(param1)
         {
            case GS.a1:
               (this.mc["caoxuandingkuanga"] as MovieClip).visible = true;
               (this.mc["caoxuandingkuangb"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangc"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangd"] as MovieClip).visible = false;
               break;
            case GS.a2:
               (this.mc["caoxuandingkuanga"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangb"] as MovieClip).visible = true;
               (this.mc["caoxuandingkuangc"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangd"] as MovieClip).visible = false;
               break;
            case GS.a3:
               (this.mc["caoxuandingkuanga"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangb"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangc"] as MovieClip).visible = true;
               (this.mc["caoxuandingkuangd"] as MovieClip).visible = false;
               break;
            case GS.a4:
               (this.mc["caoxuandingkuanga"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangb"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangc"] as MovieClip).visible = false;
               (this.mc["caoxuandingkuangd"] as MovieClip).visible = true;
         }
      }
      
      public function updateRoleLevel(param1:int) : void
      {
         (this.jsxxMc["renwudengjishuzi"] as MovieClip).gotoAndStop(param1);
      }
      
      public function updateRoleHpAndMp(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         (this.jsxxMc["xuetiaoshuzi"] as TextField).text = "" + param1 + "/" + param2;
         (this.jsxxMc["renwuxuetiao"]["xuetiaoa"] as MovieClip).scaleX = param1 / param2;
         (this.jsxxMc["nengliangtiaoshuz"] as TextField).text = "" + param3 + "/" + param4;
         (this.jsxxMc["renwunengliangtiao"]["nengliangtiaoa"] as MovieClip).scaleX = param3 / param4;
         (this.jsxxMc["jingyantiaoshuzi"] as TextField).text = "" + param5 + "/" + param6;
         (this.jsxxMc["jingyantiao"]["jingyantiaoa"] as MovieClip).scaleX = param5 / param6;
         (this.jsxxMc["tilitiao"]["tilitiaoa"] as MovieClip).scaleX = ShipData.tl.getValue() / 100;
         (this.jsxxMc["tilitiaoshuzi"] as TextField).text = "" + ShipData.tl.getValue() + "/" + 100;
      }
      
      public function showJsxxMc() : void
      {
         if(this.cur == 1)
         {
            this.jsxxMc.visible = true;
            (this.btnbuttonMc["renwumianban"] as MovieClip).visible = true;
         }
      }
      
      public function hideJsxxMc() : void
      {
         if(this.cur == 1)
         {
            this.jsxxMc.visible = false;
            (this.btnbuttonMc["renwumianban"] as MovieClip).visible = false;
         }
      }
      
      public function updateSaveTime() : void
      {
         if(GM.frameTime - this.saveframe > GS.a900)
         {
            (this.xitongcaidanMc["save"] as TextField).text = "0";
         }
         else
         {
            (this.xitongcaidanMc["save"] as TextField).text = "" + int((GS.a900 - GM.frameTime + this.saveframe) / GS.a30);
         }
      }
      
      private function btnbuttonH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["btnbuttonc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "beibaoanniu":
                  FlowInterface.openPlayerBag();
                  break;
               case "jieshaanniu":
                  ActLevelC.open();
                  break;
               case "ljcz":
                  GSummerVChong.open();
                  break;
               case "czscw":
                  GCongSPet.open();
                  break;
               case "zxjj":
                  OnLinePanel.open();
                  break;
               case "shiershengxiao":
                  Gshiershengxiao.open();
                  break;
               case "jijiaanniu":
                  JJPanel.open();
                  break;
               case "lianjicsb":
                  GOnlineServerC.open();
                  break;
               case "qiandao":
                  SignPanel.open();
                  break;
               case "juntuanlianmeng":
                  UnionPanel.open();
                  break;
               case "libaohuodong":
                  GiftPanel.open();
                  break;
               case "qiannenganniu":
                  ZenFuPanel.open();
                  break;
               case "viplevelbtn":
                  this.setVipLevel();
                  VipPanel.open();
                  break;
               case "jxzs":
                  EveryDayPanel.open();
                  break;
               case "xitonganniu":
                  this.levaecaidan(!this.xitongcaidanMc.visible);
                  break;
               case "renwumianban":
                  FlowInterface.openPlayerTask();
                  break;
               case "shangchenganniu":
                  GameShangChengC.open();
                  break;
               case "chongwuanniu":
                  ChongWuPanel.open();
                  break;
               case "caosuoa":
                  if(GM.cp.getOpenSlotNum() < GS.a2)
                  {
                     if(GameShangChengC.self.dgMoney >= GS.a1200)
                     {
                        this.wanjiakaiqiqiangcaocMc.visible = true;
                     }
                     else
                     {
                        this.wanjiazawuqwczMc.visible = true;
                     }
                  }
                  break;
               case "caosuob":
                  if(GM.cp.getOpenSlotNum() < GS.a2)
                  {
                     if(GameShangChengC.self.dgMoney >= GS.a1200)
                     {
                        this.wanjiakaiqiqiangcaocMc.visible = true;
                     }
                     else
                     {
                        this.wanjiazawuqwczMc.visible = true;
                     }
                  }
            }
         }
      }
      
      private function wanjiazawuqwczMcH(param1:MouseEvent) : void
      {
         if(param1.target.name != null)
         {
            if(param1.target.name == "scqwczan")
            {
               GM.testapi.gameChongMoney(GS.a100);
               this.wanjiazawuqwczMc.visible = false;
            }
            else if(param1.target.name == "sctok")
            {
               this.wanjiazawuqwczMc.visible = false;
            }
         }
      }
      
      private function wanjiakaiqiqiangcaocMcH(param1:MouseEvent) : void
      {
         if(param1.target.name != null)
         {
            if(param1.target.name == "okkk_0")
            {
               this.wanjiakaiqiqiangcaocMc.visible = false;
               this.wanjiaxzkczMc.visible = true;
               GM.testapi.getStateAndBuyShopProp(GS.a268,GS.a1,GS.a1200,this.buyShopOver,GS.a0);
            }
            else if(param1.target.name == "okkk_1")
            {
               this.wanjiakaiqiqiangcaocMc.visible = false;
            }
         }
      }
      
      private function buyShopOver(param1:int) : void
      {
         if(this.wanjiaxzkczMc.visible)
         {
            if(param1 == 0)
            {
               this.wanjiaxzkczMc.visible = false;
            }
            else
            {
               GM.cp.openNewslot();
               GM.testapi.saveDataBeforeNoState();
               this.wanjiaxzkczMc.visible = false;
            }
            return;
         }
         GM.findCheatMax(GS.a48);
      }
      
      private function xitongcaidanH(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(param1.target.name != null)
         {
            switch(param1.target.name)
            {
               case "baocunyouxi":
                  if(GM.frameTime - this.saveframe > GS.a900)
                  {
                     this.saveframe = GM.frameTime;
                     GM.testapi.isShowSaveS = true;
                     GM.testapi.saveDataBefore();
                  }
                  break;
               case "fanhuijidi":
                  if(GM.loaderM.keYiUse())
                  {
                     GM.levelm.changeLevelBackCity();
                     this.levaecaidan(false);
                  }
                  break;
               case "youxiluntan":
                  _loc2_ = new URLRequest("http://my.4399.com/forums-mtag-tagid-81881.html");
                  navigateToURL(_loc2_,"_blank");
                  break;
               case "fanhuizhucaidan":
                  if(GM.loaderM.keYiUse())
                  {
                     GM.gameRestart();
                  }
                  break;
               case "menuxxx":
                  this.levaecaidan(false);
                  break;
               case "gao":
                  Main.sg.quality = StageQuality.HIGH;
                  this.setHuaZhi();
                  break;
               case "zhong":
                  Main.sg.quality = StageQuality.MEDIUM;
                  this.setHuaZhi();
                  break;
               case "di":
                  Main.sg.quality = StageQuality.LOW;
                  this.setHuaZhi();
            }
         }
      }
      
      private function levaecaidan(param1:Boolean) : void
      {
         if(param1)
         {
            this.xitongcaidanMc.visible = true;
            this.xitongcaidanMc.x = 0;
            this.xitongcaidanMc.y = 0;
         }
         else
         {
            this.xitongcaidanMc.visible = false;
            this.xitongcaidanMc.x = 19563;
            this.xitongcaidanMc.y = 29563;
         }
      }
      
      private function setHuaZhi() : void
      {
         if(Main.sg.quality == "HIGH")
         {
            (this.xitongcaidanMc["gao"] as MovieClip).gotoAndStop(1);
            (this.xitongcaidanMc["zhong"] as MovieClip).gotoAndStop(2);
            (this.xitongcaidanMc["di"] as MovieClip).gotoAndStop(2);
         }
         else if(Main.sg.quality == "MEDIUM")
         {
            (this.xitongcaidanMc["gao"] as MovieClip).gotoAndStop(2);
            (this.xitongcaidanMc["zhong"] as MovieClip).gotoAndStop(1);
            (this.xitongcaidanMc["di"] as MovieClip).gotoAndStop(2);
         }
         else
         {
            (this.xitongcaidanMc["gao"] as MovieClip).gotoAndStop(2);
            (this.xitongcaidanMc["zhong"] as MovieClip).gotoAndStop(2);
            (this.xitongcaidanMc["di"] as MovieClip).gotoAndStop(1);
         }
      }
      
      public function get saveframe() : int
      {
         return this._saveframe.getValue();
      }
      
      public function set saveframe(param1:int) : void
      {
         this._saveframe.setValue(param1);
      }
   }
}

