package hotpointgame.grole
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   
   public class CplayerWomGun extends CPlayer
   {
      
      private var _mp:MPlayer;
      
      private var _gunslot:GunSlotM;
      
      private var playdoing:PlayerDo;
      
      private var _curjjAnger:VT = VT.createVT(0);
      
      private var _maxjjAnger:VT = VT.createVT(0);
      
      private var _jjAngerFlag:VT = VT.createVT(0);
      
      private var _jijiachangestate:VT = VT.createVT(0);
      
      public function CplayerWomGun(param1:MPlayer)
      {
         super();
         ztGroup = GS.a1;
         ztType = GS.a1;
         this.mp = param1;
         this.mp.initAfterXml();
         this.gunslot = new GunSlotM(this.mp.gunSlotNum);
         this.playdoing = new PlayerDoPWom();
         bHeight = this.playdoing.getPlayerMc().height;
         bWidth = this.playdoing.getPlayerMc().width;
         this.actionInit(GM.skillLvM.getBaseSkillLevel());
         this.curAction = actionObj["待机"];
         this.curAction.enter(this);
         currentFrameName = "待机";
         this.curAction.gmUpdate(this);
         this.playerStop();
      }
      
      override public function gmUpdate() : void
      {
         var _loc1_:String = null;
         var _loc2_:Class = null;
         _zCd.gmUpdate(this);
         _zCd.gmUpdateb();
         bCd.gmUpdate(this);
         if(GM.ckey.isKey("5"))
         {
            if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100 || GM.levelm.curLevel.id >= GS.a9994 && GM.levelm.curLevel.id <= GS.a9999 || GM.levelm.curLevel.id >= GS.a980 && GM.levelm.curLevel.id <= GS.a998 || GM.levelm.curLevel.id > GS.a4000 && GM.levelm.curLevel.id <= GS.a4000 + GS.a7)
            {
               GoodsManger.cwTs("此关卡不可以使用一击必杀!");
            }
            else if(FlowInterface.redInBagDL(GS.a331116,GS.a1))
            {
               GM.levelm.killAllM();
               UTools.addPiaoMc("yijibisha");
            }
            else
            {
               GoodsManger.cwTs("一击必杀道具不足!");
            }
         }
         if(this.jijiachangestate == 0)
         {
            this.playdoing.gmUpdate(this);
            for(_loc1_ in byhitFlashE)
            {
               _loc2_ = LoaderManager.getSwfClass(_loc1_) as Class;
               this.playdoing.addHitFlashEMc(new _loc2_());
            }
         }
         byhitFlashE = new Object();
      }
      
      override public function skillUp(param1:int, param2:int) : void
      {
         actionObj["技能" + param1] = RoleActionManger.getWomGunActionByName("技能" + param1 + param2);
      }
      
      override public function skillUpByWuXin(param1:int, param2:String, param3:int) : void
      {
         actionObj["阶段" + param1] = RoleActionManger.getWomGunActionByName("" + param2 + param3);
      }
      
      override public function skillUpWuXinByClear(param1:int) : void
      {
         actionObj["阶段" + param1] = null;
      }
      
      private function actionInit(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc7_:Array = null;
         var _loc2_:Array = ["倒地","被打","冰冻","眩晕","水泡","束缚","石化","死亡","待机","跑","走","起身","跳","攻击","普通武器跳击1","普通武器跳击2","跑攻","跳冲1","跳冲2","引爆"];
         var _loc3_:Object = {};
         for each(_loc4_ in _loc2_)
         {
            actionObj[_loc4_] = RoleActionManger.getWomGunActionByName(_loc4_ + 1);
         }
         _loc5_ = int(GS.a1);
         while(_loc5_ < GS.a8)
         {
            if(param1[_loc5_ - GS.a1] > 0)
            {
               actionObj["技能" + _loc5_] = RoleActionManger.getWomGunActionByName("技能" + _loc5_ + param1[_loc5_ - GS.a1]);
               Czhujiemian.self.skillTiaoInit(_loc5_ - GS.a1);
            }
            _loc5_++;
         }
         var _loc6_:int = int(GS.a1);
         while(_loc6_ < GS.a5)
         {
            _loc7_ = param1[GS.a6 + _loc6_];
            if(_loc7_[0] > 0)
            {
               actionObj["阶段" + _loc6_] = RoleActionManger.getWomGunActionByName("" + _loc7_[2] + _loc7_[1]);
               Czhujiemian.self.skillTiaoInitByWX(_loc6_,_loc7_[3]);
            }
            _loc6_++;
         }
      }
      
      override public function acationCdinitByPk() : void
      {
         var _loc1_:int = int(GS.a1);
         while(_loc1_ < GS.a8)
         {
            if(actionObj["技能" + _loc1_] != null)
            {
               (actionObj["技能" + _loc1_] as CAction).setccd(GM.frameTime);
            }
            _loc1_++;
         }
         var _loc2_:int = int(GS.a1);
         while(_loc2_ < GS.a5)
         {
            if(actionObj["阶段" + _loc2_] != null)
            {
               (actionObj["阶段" + _loc2_] as CAction).setccd(GM.frameTime);
            }
            _loc2_++;
         }
      }
      
      override public function changePowerAndForth(param1:int = 0) : void
      {
         var _loc2_:int = this.mp.getRoleSpeed();
         var _loc3_:int = _loc2_ * (GS.a1 + GS.a05);
         if(param1 == 1)
         {
            this.setForth(-1);
            runArr[runArr.length] = GameEasing.createRunArray(-GS.a1 * _loc3_ * jiansu,0,1,1);
         }
         else if(param1 == 2)
         {
            this.setForth(1);
            runArr[runArr.length] = GameEasing.createRunArray(_loc3_ * jiansu,0,1,1);
         }
         else if(param1 == 3)
         {
            this.setForth(-1);
            runArr[runArr.length] = GameEasing.createRunArray(-GS.a1 * _loc2_ * jiansu,0,1,1);
         }
         else if(param1 == 4)
         {
            this.setForth(1);
            runArr[runArr.length] = GameEasing.createRunArray(_loc2_ * jiansu,0,1,1);
         }
      }
      
      override public function changeForthNotPower(param1:int = 0) : void
      {
         if(param1 == 1)
         {
            this.setForth(-1);
         }
         else if(param1 == 2)
         {
            this.setForth(1);
         }
         else if(param1 == 3)
         {
            this.setForth(-1);
         }
         else if(param1 == 4)
         {
            this.setForth(1);
         }
      }
      
      override public function switchJiJia() : void
      {
         this.playdoing.playerStopByJiJia();
         this.currentState = -GS.a1;
         this.jijiachangestate = GS.a1;
         var _loc1_:Class = LoaderManager.getSwfClass("JijiaAgahzbsxg") as Class;
         var _loc2_:MovieClip = new _loc1_();
         var _loc3_:Point = Pos.l_To_G(this.getZmc());
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         XiaoXiaoManager.addCGX(new CGXEvent(_loc2_,GM.tsUp,this.switchJiJiaByFmc));
      }
      
      private function switchJiJiaByFmc() : void
      {
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         var _loc1_:Number = this.getZx();
         var _loc2_:Number = this.getZy();
         var _loc3_:Number = this.getXforth();
         var _loc4_:int = this.mp.hpMax;
         this.playdoing.remove();
         this.playdoing = null;
         this.gunslot.changeGunChaoByJiJia();
         this.playdoing = new PlayerDoJaWom();
         bHeight = this.playdoing.getPlayerMc().height;
         bWidth = this.playdoing.getPlayerMc().width;
         this.playdoing.setx(_loc1_);
         this.playdoing.sety(_loc2_);
         if(GM.levelm.curLevel.getvs() != null)
         {
            GM.levelm.curLevel.getvs().addPlayMc(this.playdoing.getPlayerMc());
         }
         this.playdoing.reEnter(this);
         FlowInterface.jsSx();
         var _loc5_:Number = this.mp.hpMax - _loc4_;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         this.mp.addHp(_loc5_);
         this.setForth(_loc3_);
         Czhujiemian.self.changeAngerButton(false);
         Czhujiemian.self.changeAngerShow(true);
      }
      
      override public function switchRenr() : void
      {
         this.playdoing.playerStopByJiJia();
         this.currentState = -GS.a1;
         this.jijiachangestate = GS.a1;
         var _loc1_:Class = LoaderManager.getSwfClass("JijiaAanzhixingbh") as Class;
         var _loc2_:MovieClip = new _loc1_();
         var _loc3_:Point = Pos.l_To_G(this.getZmc());
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         XiaoXiaoManager.addCGX(new CGXEvent(_loc2_,GM.tsUp,this.switchRenrByFmc));
      }
      
      private function switchRenrByFmc() : void
      {
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         var _loc1_:Number = this.getZx();
         var _loc2_:Number = this.getZy();
         var _loc3_:Number = this.getXforth();
         this.playdoing.remove();
         this.playdoing = null;
         this.playdoing = new PlayerDoPWom();
         bHeight = this.playdoing.getPlayerMc().height;
         bWidth = this.playdoing.getPlayerMc().width;
         this.playdoing.setx(_loc1_);
         this.playdoing.sety(_loc2_);
         if(GM.levelm.curLevel.getvs() != null)
         {
            GM.levelm.curLevel.getvs().addPlayMc(this.playdoing.getPlayerMc());
         }
         this.playdoing.reEnter(this);
         FlowInterface.jsSx();
         this.mp.addHp(GS.a0);
         this.setForth(_loc3_);
         Czhujiemian.self.changeAngerShow(false);
      }
      
      override public function switchRenrBydead() : void
      {
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         this.playdoing.playerStopByJiJia();
         this.currentState = -GS.a1;
         this.jijiachangestate = GS.a1;
         var _loc1_:Number = this.getZx();
         var _loc2_:Number = this.getZy();
         var _loc3_:Number = this.getXforth();
         this.playdoing.remove();
         this.playdoing = null;
         this.playdoing = new PlayerDoPWom();
         bHeight = this.playdoing.getPlayerMc().height;
         bWidth = this.playdoing.getPlayerMc().width;
         this.playdoing.setx(_loc1_);
         this.playdoing.sety(_loc2_);
         if(GM.levelm.curLevel.getvs() != null)
         {
            GM.levelm.curLevel.getvs().addPlayMc(this.playdoing.getPlayerMc());
         }
         this.playdoing.reEnter(this);
         FlowInterface.jsSx();
         this.mp.addHp(GS.a0);
         this.setForth(_loc3_);
         Czhujiemian.self.changeAngerShow(false);
      }
      
      override public function getCplayerJiJIaState() : Number
      {
         if(this.playdoing == null)
         {
            return GS.a0;
         }
         if(this.playdoing is PlayerDoPWom)
         {
            return GS.a0;
         }
         if(this.playdoing is PlayerDoJaWom)
         {
            return GS.a1;
         }
         return GS.a2;
      }
      
      override public function changeByEquipSlot(param1:int, param2:int, param3:String) : void
      {
         if(param1 == GS.a0)
         {
            Czhujiemian.self.gunSlotChangeGun(1,param2);
         }
         this.playdoing.changeByEquipSlot(param1,param3);
      }
      
      override public function pickGun(param1:Goods) : Boolean
      {
         return this.gunslot.pickGun(param1);
      }
      
      override public function pickGunClip(param1:int) : Boolean
      {
         return this.gunslot.pickClip(param1);
      }
      
      override public function openNewslot() : void
      {
         this.gunslot.openNewslot();
      }
      
      override public function getOpenSlotNum() : int
      {
         return this.gunslot.gunSlotNum;
      }
      
      override public function changeLevelClearGun() : void
      {
         this.gunslot.changeLevelClearMapGun(this);
      }
      
      override public function baseToMap(param1:String) : void
      {
         this.playdoing.baseToMap(param1);
      }
      
      override public function mapToBase() : void
      {
         this.playdoing.mapToBase();
      }
      
      override public function mapToMap(param1:String) : void
      {
         this.playdoing.mapToMap(param1);
      }
      
      override public function lostMapWeapon() : void
      {
         this.playdoing.lostMapWeapon();
      }
      
      override public function playerStop() : void
      {
         this.playdoing.playerStop();
      }
      
      override public function playerContinue() : void
      {
         this.playdoing.playerContinue();
      }
      
      override public function playerStateFull() : void
      {
         this.mp.relive();
         this.playdoing.playerStateFull(this);
      }
      
      override public function typeShowAndH(param1:int, param2:Boolean) : void
      {
         this.playdoing.typeShowAndH(param1,param2);
      }
      
      override public function mpUpdateP() : void
      {
         this.mp.gmUpdate();
      }
      
      override public function get gunslot() : GunSlotM
      {
         return this._gunslot;
      }
      
      override public function set gunslot(param1:GunSlotM) : void
      {
         this._gunslot = param1;
      }
      
      override public function get mp() : MPlayer
      {
         return this._mp;
      }
      
      override public function set mp(param1:MPlayer) : void
      {
         this._mp = param1;
      }
      
      override public function getCPlayByHit() : MovieClip
      {
         return this.playdoing.getByhit();
      }
      
      override public function getToMaxLvExp() : uint
      {
         return this.mp.getToMaxLvExp();
      }
      
      override public function getFightSocre() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:CAction = null;
         _loc2_ = actionObj["技能" + GS.a1];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * GS.a12;
         }
         _loc2_ = null;
         _loc2_ = actionObj["技能" + GS.a2];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * (GS.a3 + GS.a08);
         }
         _loc2_ = null;
         _loc2_ = actionObj["技能" + GS.a3];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * (GS.a17 + GS.a06);
         }
         _loc2_ = null;
         _loc2_ = actionObj["技能" + GS.a4];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * (GS.a7 + GS.a07);
         }
         _loc2_ = null;
         _loc2_ = actionObj["技能" + GS.a5];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * (GS.a3 + GS.a09);
         }
         _loc2_ = null;
         _loc2_ = actionObj["技能" + GS.a6];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * (GS.a3 + GS.a09);
         }
         _loc2_ = null;
         _loc2_ = actionObj["技能" + GS.a7];
         if(_loc2_ != null)
         {
            _loc1_ += _loc2_.getFd().shangHaiBi * (GS.a37 + GS.a02);
         }
         return (GS.a110 + GS.a9 + GS.a04 + _loc1_ * (GS.a05 / GS.a10 + GS.a05)) / GS.a60 * GS.a07;
      }
      
      override public function addJJAnger(param1:Number) : void
      {
         this.playdoing.addJJAnger(this,param1);
      }
      
      override public function addJJAngerByGM() : void
      {
         this.curjjAnger += GS.a10000;
         if(this.curjjAnger > this.maxjjAnger)
         {
            this.curjjAnger = this.maxjjAnger;
         }
      }
      
      override public function redJJAnger() : void
      {
         this.curjjAnger -= this.maxjjAnger / GS.a10000 * GS.a6;
         if(this.curjjAnger < 0)
         {
            this.curjjAnger = 0;
         }
         var _loc1_:int = int(this.curjjAnger / this.maxjjAnger * GS.a100);
         if(_loc1_ <= 0)
         {
            _loc1_ = int(GS.a1);
         }
         Czhujiemian.self.changeAngerTiao(_loc1_);
      }
      
      override public function clearZeroAnger() : void
      {
         this.curjjAnger = 0;
      }
      
      override public function get curjjAnger() : Number
      {
         return this._curjjAnger.getValue();
      }
      
      override public function set curjjAnger(param1:Number) : void
      {
         this._curjjAnger.setValue(param1);
      }
      
      override public function get maxjjAnger() : Number
      {
         return this._maxjjAnger.getValue();
      }
      
      override public function set maxjjAnger(param1:Number) : void
      {
         this._maxjjAnger.setValue(param1);
      }
      
      override public function get jjAngerFlag() : Number
      {
         return this._jjAngerFlag.getValue();
      }
      
      override public function set jjAngerFlag(param1:Number) : void
      {
         this._jjAngerFlag.setValue(param1);
      }
      
      override public function get jijiachangestate() : int
      {
         return this._jijiachangestate.getValue();
      }
      
      override public function set jijiachangestate(param1:int) : void
      {
         this._jijiachangestate.setValue(param1);
      }
      
      override public function curHpRat() : int
      {
         return this.mp.curHpRat();
      }
      
      override public function getHpByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().rhp + GM.aSaveData.sxiaolevel.getAddHp() + GM.aSaveData.sxiaolevel.getAddHpB();
      }
      
      override public function getMpByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().rmp + GM.aSaveData.sxiaolevel.getAddNL();
      }
      
      override public function getAttByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().rat + GM.aSaveData.sxiaolevel.getAddA() + GM.aSaveData.sxiaolevel.getAddAB();
      }
      
      override public function getDfByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().rdf + GM.aSaveData.sxiaolevel.getAddD();
      }
      
      override public function getBjByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().rbaoji / GS.a10000 + GM.aSaveData.sxiaolevel.getAddBJ();
      }
      
      override public function getSpeedByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().rspeed;
      }
      
      override public function getExpByRoleLevel() : Number
      {
         return this.mp.getCurLevelData().nextexp;
      }
      
      override public function getCurExpByRole() : Number
      {
         return this.mp.expCur;
      }
      
      override public function getHpMax() : int
      {
         return this.mp.hpMax;
      }
      
      override public function getGodByRole() : Number
      {
         return this.mp.god;
      }
      
      override public function getMaxGodByLevel() : Number
      {
         return this.mp.getMaxGod();
      }
      
      override public function addGodByRole(param1:int) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass("jinbinghesu") as Class;
         playPiaoByVip(new _loc2_(),param1);
         this.mp.addGod(param1);
      }
      
      override public function addGodByRoleByVip(param1:int) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass("jinbinghesu") as Class;
         playPiaoByVip(new _loc2_(),param1,Math.ceil(param1 * VipDataManager.vself.getaddgodR()));
         this.mp.addGod(Math.ceil(param1 * (GS.a1 + VipDataManager.vself.getaddgodR())));
      }
      
      override public function redGodByRole(param1:int) : void
      {
         this.mp.redGod(param1);
      }
      
      override public function addExp(param1:int) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass("jingyanhesu") as Class;
         playPiaoByVip(new _loc2_(),param1);
         this.mp.addExp(param1);
      }
      
      override public function addExpByVip(param1:int) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass("jingyanhesu") as Class;
         playPiaoByVip(new _loc2_(),param1,Math.ceil(param1 * VipDataManager.vself.getaddexpR()));
         this.mp.addExp(Math.ceil(param1 * (GS.a1 + VipDataManager.vself.getaddexpR())));
         if(this.getCplayerJiJIaState() == GS.a1)
         {
            BagFactory.addJJExp(Math.ceil(param1 * (GS.a1 + VipDataManager.vself.getaddexpR())));
         }
      }
      
      override public function addMpBfb(param1:Number) : void
      {
         var _loc2_:int = this.mp.mpMax * param1 / GS.a10000;
         this.addMp(_loc2_);
      }
      
      override public function save() : Object
      {
         return this.mp.save();
      }
      
      override public function getJobName() : String
      {
         return "炎蓝炮手";
      }
      
      override public function addMaxHpByPk() : void
      {
         this.mp.pkAddHp = this.mp.hpMax;
      }
      
      override public function removeMaxHpByPk() : void
      {
         this.mp.pkAddHp = 0;
      }
      
      override public function remove() : void
      {
         this.playerStop();
         super.remove();
         this.mp.remove();
         this.mp = null;
         this.playdoing.remove();
         this.playdoing = null;
         actionObj = null;
         this.gunslot.remove();
         this.gunslot = null;
      }
      
      override public function get curAction() : CAction
      {
         return this.playdoing.curAction;
      }
      
      override public function set curAction(param1:CAction) : void
      {
         this.playdoing.curAction = param1;
      }
      
      override public function get currentState() : int
      {
         return this.playdoing.currentState;
      }
      
      override public function set currentState(param1:int) : void
      {
         this.playdoing.currentState = param1;
      }
      
      override public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         return this.playdoing.getByhit().hitTestPoint(param1,param2,true);
      }
      
      override public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         return param1.hitTestObject(this.playdoing.getByhit());
      }
      
      override public function bhitTestByObjectAndPoint(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         var _loc2_:Point = Pos.l_To_G(this.getZmc());
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y,true))
         {
            return true;
         }
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y - bHeight,true))
         {
            return true;
         }
         return false;
      }
      
      override public function bhitByObjectAndPoint(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObjectAndPoint(param1))
         {
            GM.levelm.addPkJJAnger(param2.jiJiaAng);
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            addFlashE(param2.hitFlahE);
            ++GM.levelm.curLevel.byHitNum;
            return bhit(param2,param3);
         }
         return -1;
      }
      
      override public function bhitByPoint(param1:Number, param2:Number, param3:FightData, param4:ZhangDouT) : int
      {
         if(this.bhitTestByPoint(param1,param2))
         {
            GM.levelm.addPkJJAnger(param3.jiJiaAng);
            if(param3.hitsound != "null")
            {
               SoundManager.addOnlySound(param3.hitsound);
            }
            addFlashE(param3.hitFlahE);
            ++GM.levelm.curLevel.byHitNum;
            return bhit(param3,param4);
         }
         return -1;
      }
      
      override public function bhitByObject(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObject(param1))
         {
            GM.levelm.addPkJJAnger(param2.jiJiaAng);
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            addFlashE(param2.hitFlahE);
            ++GM.levelm.curLevel.byHitNum;
            return bhit(param2,param3);
         }
         return -1;
      }
      
      override public function getZx() : Number
      {
         return this.playdoing.getx();
      }
      
      override public function getZy() : Number
      {
         return this.playdoing.gety();
      }
      
      override public function setZx(param1:Number) : void
      {
         this.playdoing.setx(param1);
      }
      
      override public function setZy(param1:Number) : void
      {
         this.playdoing.sety(param1);
      }
      
      override public function getXforth() : int
      {
         return _forth;
      }
      
      override public function getZmc() : MovieClip
      {
         return this.playdoing.getPlayerMc();
      }
      
      override public function gotoAndStopFrame(param1:Object) : void
      {
         this.playdoing.gotoAndStopFrame(param1);
      }
      
      override public function gotoAndPlayFrame(param1:Object) : void
      {
         this.playdoing.gotoAndPlayFrame(param1);
      }
      
      override public function getCurrentFrameNum() : int
      {
         return this.playdoing.getCurrentFrameNum();
      }
      
      override public function getFrameLabel() : String
      {
         return this.playdoing.getFrameLabel();
      }
      
      override public function getAhit() : MovieClip
      {
         return this.playdoing.getAhit();
      }
      
      override public function setForth(param1:int) : void
      {
         _forth = param1;
         this.playdoing.setForth(param1);
      }
      
      override public function addBufferMc(param1:MovieClip) : void
      {
         this.playdoing.addBufferMc(param1);
      }
      
      override public function removeBufferMc(param1:MovieClip) : void
      {
         this.playdoing.removeBufferMc(param1);
      }
      
      override public function getBullet(param1:String) : MovieClip
      {
         return this.playdoing.getBullet(currentFrameName,param1);
      }
      
      override public function getAllBulletByClass(param1:Class) : Array
      {
         return this.playdoing.getAllBulletByClass(currentFrameName,param1);
      }
      
      override public function getXiaZhiMc(param1:String) : MovieClip
      {
         return this.playdoing.getXiaZhiMc(param1);
      }
      
      override public function get cHp() : int
      {
         return this.mp.hpCur;
      }
      
      override public function get cmp() : int
      {
         return this.mp.mpCur;
      }
      
      override public function get mmp() : int
      {
         return this.mp.mpMax;
      }
      
      override public function redMp(param1:int) : void
      {
         this.mp.redMp(param1);
      }
      
      override public function addMp(param1:int) : void
      {
         this.mp.addMp(param1);
      }
      
      override public function getAttackValue() : Number
      {
         return this.mp.getAttackValue() * (GS.a1 + FlowInterface.getAtt(GS.a1) + zCd.getAddAtt() + zCd.getTqatt(GS.a3));
      }
      
      override public function getDefenceValue() : Number
      {
         return this.mp.getDefenceValue();
      }
      
      override public function getWuxinSX(param1:int) : int
      {
         return 0;
      }
      
      override public function getZtLevel() : int
      {
         return this.mp.level;
      }
      
      override public function getWuxinKaxin(param1:int) : Number
      {
         switch(param1)
         {
            case 1:
               return FlowInterface.getJin();
            case 2:
               return FlowInterface.getMu();
            case 3:
               return FlowInterface.getShui();
            case 4:
               return FlowInterface.getHuo();
            case 5:
               return FlowInterface.getTu();
            case 6:
               return FlowInterface.getHd() * (GS.a1 + zCd.getTqatt(GS.a4));
            default:
               return 0;
         }
      }
      
      override public function getBaojiJL() : Number
      {
         return this.mp.getBaoji();
      }
      
      override public function addHp(param1:int) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass("huixuehesu") as Class;
         playPiao(new _loc2_(),param1);
         this.mp.addHp(param1);
      }
      
      override public function addHpByPerc(param1:Number) : void
      {
         var _loc2_:int = this.mp.hpMax * param1 / GS.a10000;
         this.addHp(_loc2_);
      }
      
      override public function redHp(param1:int, param2:int, param3:Boolean) : void
      {
         if(param1 >= 0)
         {
            if(param3)
            {
               playRHP(HpMcManager.self.getBaojiMc(),param1,param2);
            }
            else
            {
               playRHP(HpMcManager.self.getRoleMc(),param1,param2);
            }
            this.mp.redHp(param1);
         }
      }
   }
}

