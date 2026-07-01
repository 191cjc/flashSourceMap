package hotpointgame.Control
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.ginit.*;
   import hotpointgame.glevel.*;
   import hotpointgame.glevel.leveldata.LevelBD;
   import hotpointgame.glevel.leveldata.LevelSaveDList;
   import hotpointgame.grole.*;
   import hotpointgame.gskilllevel.SkillLevelManager;
   import hotpointgame.gview.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.online.*;
   import hotpointgame.savedatal.NewSDList;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   import hotpointgame.views.geneChangePanel.*;
   import hotpointgame.views.insertPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.wareroomPanel.*;
   
   public class GM
   {
      
      public static var ckey:CKey;
      
      public static var testapi:ApiInterface;
      
      public static var cp:CPlayer;
      
      public static var serverDateC:ServerDateC;
      
      public static var flagobj:Object;
      
      public static var levelSD:LevelSaveDList;
      
      public static var skillLvM:SkillLevelManager;
      
      public static var kaipaijssavedata:KaiPaiJiShi;
      
      public static var aSaveData:NewSDList;
      
      public static var fzfont:Font;
      
      public static var fpsNum:FpsCounter;
      
      public static var pkSid:int;
      
      private static var panBtnMc:MovieClip;
      
      public static var checkString:String;
      
      private static var _frameTime:VT = VT.createVT(0);
      
      public static var vh:Number = 600;
      
      public static var vw:Number = 960;
      
      public static var a:MovieClip = new MovieClip();
      
      public static var blevel:MovieClip = new MovieClip();
      
      public static var cb:MovieClip = new MovieClip();
      
      public static var cbGview:MovieClip = new MovieClip();
      
      public static var bagJm:MovieClip = new MovieClip();
      
      public static var dtop:MovieClip = new MovieClip();
      
      public static var tsUp:MovieClip = new MovieClip();
      
      public static var einit:MovieClip = new MovieClip();
      
      public static var onlineb:MovieClip = new MovieClip();
      
      public static var fone:MovieClip = new MovieClip();
      
      public static var levelm:LevelManager = new LevelManager();
      
      public static var loaderM:LoaderManager = new LoaderManager();
      
      private static var isgameone:Boolean = true;
      
      public static var enterCunFlag:Boolean = false;
      
      public static var equipMcArr:Array = new Array();
      
      public static var onlineM:OnlineManager = new OnlineManager();
      
      public function GM()
      {
         super();
      }
      
      public static function getCurrentTime() : uint
      {
         return 0;
      }
      
      public static function gameInit() : void
      {
         Main.self.addChild(GM.blevel);
         Main.self.addChild(GM.a);
         Main.self.addChild(GM.cb);
         Main.self.addChild(GM.cbGview);
         Main.self.addChild(GM.bagJm);
         Main.self.addChild(GM.dtop);
         Main.self.addChild(GM.tsUp);
         Main.self.addChild(GM.einit);
         Main.self.addChild(GM.fone);
         GM.a.mouseEnabled = false;
         GM.a.enabled = false;
         GM.a.mouseChildren = false;
         GM.blevel.mouseEnabled = false;
         GM.blevel.enabled = false;
         GM.cb.mouseEnabled = false;
         GM.cb.enabled = false;
         GM.cbGview.mouseEnabled = false;
         GM.cbGview.enabled = false;
         GM.bagJm.mouseEnabled = false;
         GM.bagJm.enabled = false;
         GM.dtop.mouseEnabled = false;
         GM.dtop.enabled = false;
         GM.tsUp.mouseEnabled = false;
         GM.tsUp.enabled = false;
         GM.einit.mouseEnabled = false;
         GM.einit.enabled = false;
         GM.fone.mouseEnabled = false;
         GM.fone.enabled = false;
         var _loc1_:int = int(GS.a0);
         GM.ckey = new CKey(Main.sg);
         LoaderManager.initFilename();
         GameDataInit.swfClassNameInit();
         GameDataInit.classInitReg();
         testapi = new Api4399();
         fpsNum = new FpsCounter(30);
         fpsNum.x = 550;
         fpsNum.y = 950;
         Main.self.addChild(fpsNum);
         DebugOutPut.open();
         ApiCheckWord.self = new ApiCheckWord();
         enterWc();
      }
      
      private static function enterWc() : void
      {
         WaitingJieC.open();
         SoundManager.playSenceSound("mp3kaichang");
         GM.testapi.getServerTimerByH();
      }
      
      public static function enterGameInitc() : void
      {
         GameInitC.open();
      }
      
      public static function enterGame() : void
      {
         if(aSaveData.isMaxNewV())
         {
            GameInitC.close();
            GM.testapi.getAllChongeMoney();
            GGetAllCong.open();
         }
         else
         {
            GM.findCheatMax(GS.a59);
         }
      }
      
      public static function enterGameB() : void
      {
         if(testapi.isHasCheck())
         {
            GM.findTrueCheatMax();
         }
         else
         {
            testapi.dataCheckTest();
            GoodsManger.getApiData();
         }
      }
      
      public static function attackUpdate() : void
      {
      }
      
      private static function autoDelMcUpdate() : void
      {
      }
      
      public static function loadSwf() : void
      {
         if(testapi.vipChongGod == -GS.a1)
         {
            testapi.getAllChongeMoneyByVip();
         }
         var _loc1_:Array = new Array();
         _loc1_.push("yinxiao");
         _loc1_.push("othersc");
         _loc1_.push("wupintubiao");
         _loc1_.push("wanjiajiemian");
         _loc1_.push("zawu");
         _loc1_.push("ziti");
         _loc1_.push("taskmoveclip");
         if(testapi.jobFlag == GS.a1)
         {
            _loc1_.push("skin_man");
         }
         else
         {
            _loc1_.push("skin_wman");
         }
         _loc1_.push("dataxmlva");
         if(loaderM.keYiUse())
         {
            loaderM.setLoadData(_loc1_);
            loaderM.completeF = baseDatainit;
            loaderM.startLoadData();
         }
         else
         {
            GM.findCheatMax(GS.a10);
         }
      }
      
      public static function baseDatainit() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Class = null;
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Object = null;
         if(isgameone)
         {
            isgameone = false;
            checkString = "";
            _loc1_ = uint(getTimer());
            GoodsManger.initXml();
            _loc2_ = LoaderManager.getSwfClass("fangzhengziti") as Class;
            Font.registerFont(_loc2_);
            fzfont = new _loc2_() as Font;
            _loc3_ = "wutaizhao";
            if(testapi.hasGmId())
            {
               _loc5_ = LoaderManager.getSwfClass("qiuconplane");
               _loc6_ = new _loc5_() as MovieClip;
               _loc6_.addEventListener(MouseEvent.CLICK,fmonster);
               cb.addChild(_loc6_);
               _loc7_ = LoaderManager.getSwfClass("panelBtnObj");
               panBtnMc = new _loc7_() as MovieClip;
               panBtnMc.addEventListener(MouseEvent.CLICK,clickHandle);
               panBtnMc.x = 700;
               panBtnMc.y = 650;
               cb.addChild(panBtnMc);
               _loc3_ = "wutaizhaotest";
            }
            else
            {
               _loc3_ = "wutaizhao";
            }
            _loc4_ = new (LoaderManager.getSwfClass(_loc3_))() as MovieClip;
            Main.self.addChild(_loc4_);
            GLoadDataing.open();
         }
         else
         {
            gameStart();
         }
      }
      
      public static function gameStart() : void
      {
         var _loc2_:LevelBD = null;
         aSaveData.petm.saveAfterCount();
         GoodsManger.initDataAgain();
         Czhujiemian.self.init();
         var _loc1_:Object = new Object();
         equipMcArr = FlowInterface.getEquipSlotId();
         GM.testapi.getDGBalance();
         if(enterCunFlag)
         {
            _loc2_ = LevelDataManager.getLevelBD(GS.a9999);
            _loc1_.gqm = _loc2_.lname;
            _loc1_.cjm = _loc2_.enterSe;
            _loc1_.fjm = _loc2_.enterRm;
            _loc1_.x = _loc2_.enterX;
            _loc1_.y = _loc2_.enterY;
            _loc1_.ll = 1;
         }
         else
         {
            _loc1_.gqm = "溪谷小筑";
            _loc1_.cjm = "试练空间";
            _loc1_.fjm = "试练空间房间1";
            _loc1_.x = 150;
            _loc1_.y = 400;
            _loc1_.ll = 1;
         }
         levelm.enterLevelM(_loc1_);
         Main.self.addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      public static function addCheckData(param1:String) : void
      {
      }
      
      private static function onENTER_FRAME(param1:Event) : void
      {
         FpsCounter.frameStartTime = getTimer();
         GM.gmUpdate();
         fpsNum.gmUpdate();
      }
      
      public static function get frameTime() : uint
      {
         return _frameTime.getValue();
      }
      
      public static function set frameTime(param1:uint) : void
      {
         _frameTime.setValue(param1);
      }
      
      private static function clickHandle(param1:MouseEvent) : void
      {
         if(getQualifiedClassName(param1.target) == "fl.controls::Button")
         {
            GM.levelm.killAllM();
            if(param1.target["label"] == "基因改造")
            {
               UnionPanel.open();
            }
            else if(param1.target["label"] == "商店")
            {
               GoodsManger.dataList.unionData.initCs();
            }
            else if(param1.target["label"] == "测试物品")
            {
               GoodsManger.initTestGoods();
            }
            else if(param1.target["label"] == "合成面板")
            {
               NpcTaskPanel.open(3);
            }
            else if(param1.target["label"] == "开启仓库")
            {
               BagFactory.addJJExp(Number(panBtnMc.r_0.text));
            }
            else if(param1.target["label"] == "强化面板")
            {
               StrengthenPanel.open();
            }
            else if(param1.target["label"] == "镶嵌面板")
            {
               InsertPanel.open();
            }
            else if(param1.target["label"] == "仓库")
            {
               WareroomPanel.open();
            }
            else if(param1.target["label"] == "刷新时间")
            {
               GM.testapi.getServerTime();
            }
            else if(param1.target["label"] == "植入基因")
            {
               GeneData.zrTest(panBtnMc.j_0.text,panBtnMc.j_1.text);
            }
            else if(param1.target["label"] == "贡献")
            {
               GoodsManger.dataList.unionData.tjFsTest(Number(panBtnMc.gx_0.text));
            }
            else if(param1.target["label"] == "军团VIP消费")
            {
               GoodsManger.dataList.unionData.setXf(Number(panBtnMc.gxv_0.text));
               GM.aSaveData.pksd.addGong(Number(panBtnMc.gxv_0.text));
            }
            else if(param1.target["label"] == "VIP")
            {
            }
            if(param1.target.name == "b_0" && panBtnMc.z_0.text != "" && panBtnMc.n_0.text != "")
            {
               if(BagFactory.addInBagById(panBtnMc.z_0.text,panBtnMc.n_0.text,panBtnMc.s_0.text))
               {
                  BagFactory.hdGoodsTs(panBtnMc.z_0.text,panBtnMc.n_0.text);
                  TaskData.isGoodsOk(panBtnMc.z_0.text);
               }
               else
               {
                  GoodsManger.cwTs("物品栏已满");
               }
            }
            else if(param1.target.name == "b_1" && panBtnMc.z_1.text != "")
            {
               TaskData.taskTestOk(Number(panBtnMc.z_1.text));
            }
            Main.sg.focus = Main.self;
         }
      }
      
      private static function fmonster(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Point = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Point = null;
         var _loc8_:Array = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Object = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         var _loc13_:MovieClip = null;
         var _loc14_:MovieClip = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:MovieClip = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:MovieClip = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:MovieClip = null;
         var _loc25_:int = 0;
         var _loc26_:Point = null;
         var _loc27_:MovieClip = null;
         var _loc28_:int = 0;
         var _loc29_:MovieClip = null;
         var _loc30_:MovieClip = null;
         var _loc31_:MovieClip = null;
         var _loc32_:MovieClip = null;
         var _loc33_:MovieClip = null;
         var _loc34_:Object = null;
         var _loc35_:Array = null;
         var _loc36_:MovieClip = null;
         var _loc37_:CRoomSurM = null;
         var _loc38_:MovieClip = null;
         var _loc39_:int = 0;
         var _loc40_:int = 0;
         var _loc41_:MovieClip = null;
         var _loc42_:Object = null;
         var _loc43_:Array = null;
         if(getQualifiedClassName(param1.target) == "fl.controls::Button")
         {
            switch(param1.target["label"])
            {
               case "出怪":
                  _loc2_ = param1.target.parent as MovieClip;
                  _loc3_ = GM.levelm.gPointChangeLevel(new Point(_loc2_["smx"].text,_loc2_["smy"].text));
                  _loc4_ = MonsterManager.getMData(_loc2_["sma"].text);
                  if(LoaderManager.loads.hasOwnProperty(LoaderManager.allClassName[_loc4_.mcclassname]))
                  {
                     if(_loc4_.classname == "CMonsterMapGun")
                     {
                        MonsterManager.creatMapGunMonster(_loc2_["sma"].text,_loc3_.x,_loc3_.y);
                        Main.sg.focus = Main.self;
                     }
                     else
                     {
                        MonsterManager.creatMonster(_loc2_["sma"].text,_loc3_.x,_loc3_.y);
                        Main.sg.focus = Main.self;
                     }
                  }
                  else
                  {
                     _loc5_ = new Array();
                     _loc5_.push(LoaderManager.allClassName[_loc4_.mcclassname]);
                     _loc5_.push("JijiaA_guangmingzhixing");
                     _loc5_.push("JijiaA_anheizhixing");
                     _loc5_.push("WuqiM_zhuijizhelueying");
                     _loc5_.push("WuqiM_zhuijizhelieyan");
                     _loc5_.push("WuqiL_liuxingfeipan");
                     _loc5_.push("WuqiL_binglingdanat");
                     _loc5_.push("WuqiH_leimangjiying");
                     _loc5_.push("WuqiB_wleimangjiying");
                     _loc5_.push("WuqiB_wliuxingfeipan");
                     _loc5_.push("WuqiB_wzhaohuanzhe");
                     _loc5_.push("WuqiB_wzhuijizhelieyan");
                     _loc5_.push("WuqiB_wzhuijizhelueying");
                     _loc5_.push("yinxiaogw");
                     _loc5_.push("yinxiaocw");
                     _loc5_.push("j_bossxuetiao");
                     _loc5_.push("wupintubiao");
                     _loc5_.push("kaipaijiemain");
                     _loc5_.push("t_box");
                     if(loaderM.keYiUse())
                     {
                        loaderM.setLoadData(_loc5_);
                        loaderM.startLoadData();
                     }
                     else
                     {
                        GM.findCheatMax(GS.a11);
                     }
                  }
                  return;
               case "出石头":
                  _loc6_ = param1.target.parent as MovieClip;
                  _loc7_ = GM.levelm.gPointChangeLevel(new Point(_loc6_["smx"].text,_loc6_["smy"].text));
                  if(LoaderManager.loads.hasOwnProperty(LoaderManager.allClassName["m_shitoub"]))
                  {
                     ZtDFFactory.createZShiTou(_loc6_["sma"].text,_loc7_.x,_loc7_.y);
                     Main.sg.focus = Main.self;
                  }
                  else
                  {
                     _loc8_ = new Array();
                     _loc8_.push(LoaderManager.allClassName["m_shitoub"]);
                     if(loaderM.keYiUse())
                     {
                        loaderM.setLoadData(_loc8_);
                        loaderM.startLoadData();
                     }
                     else
                     {
                        GM.findCheatMax(GS.a11);
                     }
                  }
                  return;
               case "进入关卡":
                  _loc9_ = param1.target.parent as MovieClip;
                  _loc10_ = new Object();
                  _loc10_.gqm = String(_loc9_["la"].text);
                  _loc10_.cjm = String(_loc9_["lb"].text);
                  _loc10_.fjm = String(_loc9_["lc"].text);
                  _loc10_.x = Number(_loc9_["lx"].text);
                  _loc10_.y = Number(_loc9_["ly"].text);
                  _loc10_.ll = Number(_loc9_["ld"].text);
                  if(levelm.curLevel == null)
                  {
                     levelm.enterLevelM(_loc10_);
                     Main.sg.focus = Main.self;
                     return;
                  }
                  if(_loc10_.gqm != levelm.curLevel.name || _loc10_.ll != levelm.curLevel.lstar)
                  {
                     levelm.changeLevelData(_loc10_);
                     Main.sg.focus = Main.self;
                     return;
                  }
                  if(_loc10_.cjm != levelm.curLevel.curscene.name)
                  {
                     levelm.curLevel.changeSceneData(_loc10_);
                     Main.sg.focus = Main.self;
                     return;
                  }
                  if(_loc10_.fjm != levelm.curLevel.curroom.name)
                  {
                     levelm.curLevel.changeRoomDataBySend(_loc10_);
                     Main.sg.focus = Main.self;
                     return;
                  }
                  Main.sg.focus = Main.self;
                  return;
                  break;
               case "加经验":
                  _loc11_ = param1.target.parent as MovieClip;
                  cp.addExp(int((_loc11_["expa"] as TextField).text));
                  Main.sg.focus = Main.self;
                  return;
               case "加钱":
                  _loc12_ = param1.target.parent as MovieClip;
                  cp.addGodByRole(int((_loc12_["moneya"] as TextField).text));
                  Main.sg.focus = Main.self;
                  return;
               case "加星钻":
                  _loc13_ = param1.target.parent as MovieClip;
                  GM.testapi.gameChongMoneyByTrue(int((_loc13_["moneya"] as TextField).text));
                  Main.sg.focus = Main.self;
                  return;
               case "加怒气":
                  cp.addJJAngerByGM();
                  Main.sg.focus = Main.self;
                  return;
               case "修改关卡成绩":
                  _loc14_ = param1.target.parent as MovieClip;
                  _loc15_ = int(_loc14_["levelid"].text);
                  _loc16_ = int(_loc14_["levelach"].text);
                  _loc17_ = int(_loc14_["levells"].text);
                  GM.levelSD.setAch(_loc15_,_loc16_,_loc17_);
                  Main.sg.focus = Main.self;
                  return;
               case "修改技能等级":
                  _loc18_ = param1.target.parent as MovieClip;
                  _loc19_ = int(_loc18_["skid"].text);
                  _loc20_ = int(_loc18_["sklv"].text);
                  GM.skillLvM.upToNextNoCon(_loc19_,_loc20_);
                  Main.sg.focus = Main.self;
                  return;
               case "修改五行技能":
                  _loc21_ = param1.target.parent as MovieClip;
                  _loc22_ = int(_loc21_["wxskid"].text);
                  _loc23_ = int(_loc21_["wxsklv"].text);
                  if(_loc23_ == 0)
                  {
                     GM.skillLvM.useSkillBookRester(_loc22_);
                  }
                  else
                  {
                     GM.skillLvM.useSkillBook(_loc22_,_loc23_);
                  }
                  Main.sg.focus = Main.self;
                  return;
               case "刷物品":
                  _loc24_ = param1.target.parent as MovieClip;
                  _loc25_ = int((_loc24_["did"] as TextField).text);
                  _loc26_ = GM.levelm.gPointChangeLevel(new Point(200,200));
                  GM.levelm.addDiaoLougood(FlowInterface.getGoodsById(_loc25_),_loc26_.x,_loc26_.y);
                  Main.sg.focus = Main.self;
                  return;
               case "杀死怪":
                  GM.levelm.killAllM();
                  Main.sg.focus = Main.self;
                  return;
               case "直接删除怪":
                  GM.levelm.clearallMAndB();
                  Main.sg.focus = Main.self;
                  return;
               case "加宠物":
                  _loc27_ = param1.target.parent as MovieClip;
                  _loc28_ = int((_loc27_["petid"] as TextField).text);
                  aSaveData.petm.addPetBypid(_loc28_);
                  Main.sg.focus = Main.self;
                  return;
               case "加融合经验":
                  _loc29_ = param1.target.parent as MovieClip;
                  aSaveData.petm.addRHexpBypid(int((_loc29_["petpid"] as TextField).text),int((_loc29_["petexp"] as TextField).text));
                  Main.sg.focus = Main.self;
                  return;
               case "加技能":
                  _loc30_ = param1.target.parent as MovieClip;
                  aSaveData.petm.addPetSkillBypid(int((_loc30_["petpid"] as TextField).text),int((_loc30_["petexp"] as TextField).text));
                  Main.sg.focus = Main.self;
                  return;
               case "PK对象":
                  _loc31_ = param1.target.parent as MovieClip;
                  testapi.getDataByDataPkTest(int((_loc31_["petid"] as TextField).text));
                  Main.sg.focus = Main.self;
                  return;
               case "零食A":
                  _loc32_ = param1.target.parent as MovieClip;
                  testapi.summerVchongGod = int((_loc32_["petid"] as TextField).text);
                  testapi.allChongGodbbb = int((_loc32_["petid"] as TextField).text) + 5;
                  Main.sg.focus = Main.self;
                  return;
               case "零食B":
                  _loc33_ = param1.target.parent as MovieClip;
                  _loc34_ = new Object();
                  _loc34_.rId = GS.a975;
                  _loc34_.score = int((_loc33_["petid"] as TextField).text);
                  _loc34_.extra = GoodsManger.pkDisplaySave();
                  if(testapi.pkDataself != null)
                  {
                     _loc34_.extra.qsl = testapi.pkDataself.pwin;
                     _loc34_.extra.qsb = testapi.pkDataself.plost;
                     _loc34_.extra.qls = testapi.pkDataself.pwinwin;
                  }
                  else
                  {
                     _loc34_.extra.qsl = 1;
                     _loc34_.extra.qsb = 0;
                     _loc34_.extra.qls = 1;
                  }
                  _loc35_ = new Array();
                  _loc35_.push(_loc34_);
                  testapi.submitRandScore(_loc35_);
                  Main.sg.focus = Main.self;
                  return;
               case "零食C":
                  if(levelm.curLevel.id == GS.a9994)
                  {
                     _loc36_ = param1.target.parent as MovieClip;
                     _loc37_ = levelm.curLevel.curroom as CRoomSurM;
                     _loc37_.curbm = int((_loc36_["petid"] as TextField).text);
                  }
                  Main.sg.focus = Main.self;
                  return;
               case "零食D":
                  _loc38_ = param1.target.parent as MovieClip;
                  _loc39_ = int(_loc38_["skid"].text);
                  _loc40_ = int(_loc38_["sklv"].text);
                  GM.aSaveData.sxiaolevel.changeDHLevel(_loc39_,_loc40_);
                  Main.sg.focus = Main.self;
                  return;
               case "零食E":
                  GCongSPet.open();
                  Main.sg.focus = Main.self;
                  return;
               case "封排行榜":
                  _loc41_ = param1.target.parent as MovieClip;
                  _loc42_ = new Object();
                  _loc42_.rId = GS.a1093;
                  _loc42_.score = int((_loc41_["petid"] as TextField).text);
                  _loc42_.extra = GoodsManger.pkDisplaySave();
                  if(testapi.pkDataself != null)
                  {
                     _loc42_.extra.qsl = testapi.pkDataself.pwin;
                     _loc42_.extra.qsb = testapi.pkDataself.plost;
                     _loc42_.extra.qls = testapi.pkDataself.pwinwin;
                  }
                  else
                  {
                     _loc42_.extra.qsl = 1;
                     _loc42_.extra.qsb = 0;
                     _loc42_.extra.qls = 1;
                  }
                  _loc43_ = new Array();
                  _loc43_.push(_loc42_);
                  testapi.submitRandScore(_loc43_);
                  Main.sg.focus = Main.self;
                  return;
               case "关闭作弊":
                  testapi.isCheckBi = false;
                  DebugOutPut.self.apptext("封号关闭");
                  Main.sg.focus = Main.self;
                  return;
               case "显示作弊信息":
                  DebugOutPut.self.cleartext();
                  DebugOutPut.self.apptext("物品总价:" + BagFactory.getShopG() + "总充值:" + testapi.allChongGod + GM.aSaveData.checkfm.getseccion() + GM.aSaveData.checkfm.getseccionDM());
                  Main.sg.focus = Main.self;
                  return;
               case "开启作弊":
                  testapi.isCheckBi = true;
                  DebugOutPut.self.apptext("封号开启");
                  Main.sg.focus = Main.self;
                  return;
               case "解号":
                  GM.aSaveData.checkfm.clearAllCheck();
                  Main.sg.focus = Main.self;
                  return;
               case "解号b":
                  GM.aSaveData.checkfm.clearDMCheck();
                  Main.sg.focus = Main.self;
                  return;
               case "焦点":
                  GdataPK.open();
                  DebugOutPut.self.cleartext();
                  Main.sg.focus = Main.self;
                  return;
               default:
                  Main.sg.focus = Main.self;
            }
         }
      }
      
      public static function gmUpdate() : void
      {
         ++frameTime;
         onlineM.fHealt();
         Czhujiemian.self.updateSaveTime();
         XiaoXiaoManager.gmUpdate();
         SoundManager.gmUpdate();
         GM.levelm.gmUpdate();
      }
      
      public static function gameRestart() : void
      {
         Main.self.removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         loaderM.gameExitStop();
         FlowInterface.exitGame();
         GameInitC.close();
         flagobj = null;
         testapi.remove();
         if(levelSD != null)
         {
            levelSD.remove();
            levelSD = null;
         }
         if(skillLvM != null)
         {
            skillLvM.remove();
            skillLvM = null;
         }
         kaipaijssavedata = null;
         aSaveData = null;
         Czhujiemian.self.remove();
         onlineM.exitGame();
         CLevelChoose.exitgame();
         ClevelChooseNew.exitgame();
         GameFailC.close();
         GamePassC.close();
         KaiPaiC.close();
         PinFengC.close();
         SkillGoUpC.exitgame();
         GameShangChengC.exitgame();
         ManHuaKaiC.close();
         ReliveC.close();
         NpcGuiShop.close();
         NpcGuiStong.close();
         NpcGuiWuqi.close();
         XiaoXiaoManager.remove();
         if(cp != null)
         {
            cp.remove();
            cp = null;
         }
         levelm.remove();
         enterGameInitc();
      }
      
      public static function findTrueCheatMax() : void
      {
      }
      
      public static function findCheatMax(param1:Number = 0) : void
      {
      }
      
      public static function findCheatMaxLeave(param1:String, param2:String = "") : void
      {
      }
      
      private static function findCheatMaxPrv() : void
      {
      }
   }
}

