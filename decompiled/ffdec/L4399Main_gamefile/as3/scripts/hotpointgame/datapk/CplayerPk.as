package hotpointgame.datapk
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.CMJingJie;
   import hotpointgame.gMonster.TraceJuLi;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   
   public class CplayerPk extends ZtC
   {
      
      protected var vp:VDatapkI;
      
      protected var rdata:PkSaveData;
      
      protected var tActionArr:Object = new Object();
      
      protected var aActionArr:Vector.<CAction> = new Vector.<CAction>();
      
      protected var tARen:Object = new Object();
      
      protected var aARen:Vector.<CAction> = new Vector.<CAction>();
      
      protected var tAJijia:Object = new Object();
      
      protected var aAJijia:Vector.<CAction> = new Vector.<CAction>();
      
      protected var fdeiji:int = 60;
      
      protected var cradom:Number = 0;
      
      protected var mAzRate:int = 50;
      
      protected var forthRate:int = 50;
      
      private var qiangflag:int = 0;
      
      private var qiangX:Number = 0;
      
      protected var fzouA:int = 30;
      
      protected var fzouB:int = 60;
      
      private var jingJie:CMJingJie;
      
      private var traceJuLi:TraceJuLi;
      
      private var cpstop:int = 1;
      
      private var mpJi:int = 1;
      
      private var _curjjAnger:VT = VT.createVT(0);
      
      private var _maxjjAnger:VT = VT.createVT(0);
      
      private var _jjAngerFlag:VT = VT.createVT(0);
      
      public function CplayerPk(param1:PkSaveData)
      {
         super();
         this.rdata = param1;
         this.maxjjAnger = param1.getAttackValue() * (GS.a1000 * GS.a100);
         ztType = GS.a1;
         ztGroup = GS.a2;
         gravity = this.rdata.getGv();
         this.jingJie = this.rdata.getjingJie();
         this.traceJuLi = this.rdata.gettraceJuLi();
         this.initActionrAj();
         this.initRenC();
      }
      
      public function initActionrAj() : void
      {
      }
      
      public function initRenC() : void
      {
      }
      
      public function enterRenC() : void
      {
      }
      
      public function enterJiJia() : void
      {
      }
      
      override public function remove() : void
      {
         this.petStop();
         super.remove();
         this.vp.remove();
         this.vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         this.jingJie = null;
         this.traceJuLi = null;
         this.tActionArr = null;
         this.aActionArr = null;
         this.tARen = null;
         this.aARen = null;
         this.tAJijia = null;
         this.aAJijia = null;
      }
      
      public function gmUpdate(param1:Vector.<ZhangDouT>) : int
      {
         var _loc2_:String = null;
         var _loc3_:Class = null;
         this.cradom = Math.random();
         this.mpUpdata();
         this.redjjAnger();
         this.beforeUpdate();
         this.otherUpdate();
         if(this.cpstop == GS.a1)
         {
            this.actionUpdate(param1);
            this.moveRun();
         }
         for(_loc2_ in byhitFlashE)
         {
            _loc3_ = LoaderManager.getSwfClass(_loc2_) as Class;
            this.vp.addHitFlashEMc(new _loc3_());
         }
         byhitFlashE = new Object();
         return currentState;
      }
      
      private function mpUpdata() : void
      {
         ++this.mpJi;
         if(this.mpJi % GS.a30 == 0)
         {
            this.addMp(this.rdata.mpSppeed);
         }
      }
      
      private function redjjAnger() : void
      {
         if(this.rdata.rOrJ == GS.a1)
         {
            this.curjjAnger -= this.maxjjAnger / GS.a10000 * GS.a6;
            if(this.curjjAnger < 0)
            {
               this.curjjAnger = 0;
            }
         }
      }
      
      private function beforeUpdate() : void
      {
         _zCd.gmUpdate(this);
         bCd.gmUpdate(this);
         if(_zCd.weizhanTime > 0)
         {
            this.vp.setAlpha(0.2);
         }
         else
         {
            this.vp.setAlpha(1);
         }
      }
      
      protected function otherUpdate() : void
      {
      }
      
      private function actionUpdate(param1:Vector.<ZhangDouT>) : void
      {
         if(currentState == GS.a3)
         {
            return;
         }
         var _loc2_:Boolean = curAction.gmUpdate(this);
         if(currentState == GS.a2)
         {
            if(_loc2_)
            {
               currentState = GS.a3;
            }
            return;
         }
         if(_zCd.bingDong > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("冰冻");
            return;
         }
         if(_zCd.shiHua > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("石化");
            return;
         }
         if(_zCd.xuanYun > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("眩晕");
            return;
         }
         if(_zCd.shuiPao > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("水泡");
            return;
         }
         if(_zCd.shuFu > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("束缚");
            return;
         }
         if(_zCd.yinZhi > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("被打");
            return;
         }
         if(_zCd.jiDao > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNo("倒地");
            return;
         }
         if(this.rdata.curHp == 0 && currentState != GS.a2 && currentState != GS.a3 && skyType == 0)
         {
            runArr.length = 0;
            currentState = GS.a2;
            this.changeActionByNameAndUpdateAndNo("死亡");
            bCd.removeAllBuffer(this);
            return;
         }
         if(currentFrameName == "倒地")
         {
            this.changeActionByNameAndUpdate("起身");
            currentState = -1;
            return;
         }
         if(currentFrameName == "起身" && !_loc2_)
         {
            return;
         }
         if(currentFrameName == "起身" && _loc2_)
         {
            currentState = GS.a1;
         }
         if(currentFrameName == "攻击" && !_loc2_)
         {
            return;
         }
         if(this.rdata.isYouJiJia() && this.curjjAnger == this.maxjjAnger)
         {
            _zCd.zou = -1;
            _zCd.deiji = -1;
            this.enterJiJia();
            return;
         }
         if(this.rdata.rOrJ == GS.a1 && this.curjjAnger == GS.a0)
         {
            _zCd.zou = -1;
            _zCd.deiji = -1;
            this.enterRenC();
            return;
         }
         if(param1.length == 0)
         {
            if(_zCd.deiji < 0 && _zCd.zou < 0)
            {
               this.moveByNoEnemy();
            }
            else if(currentFrameName != "待机" && currentFrameName != "移动")
            {
               _zCd.zou = -1;
               _zCd.deiji = -1;
            }
            return;
         }
         if(currentState == 0)
         {
            this.jingJieState(param1);
         }
         if(currentState == GS.a1)
         {
            this.gongJiState(param1,_loc2_);
         }
      }
      
      public function moveByNoEnemy() : void
      {
         if(this.cradom * 100 > this.mAzRate)
         {
            _zCd.deiji = this.fdeiji;
            this.changeActionByNameAndUpdateAndNo("待机");
         }
         else
         {
            if(this.cradom * 100 > this.forthRate)
            {
               this.setForth(_forth * -1);
            }
            _zCd.zou = this.cradom * this.fzouB + this.fzouA;
            this.changeActionByNameAndUpdateAndNo("移动");
         }
      }
      
      private function jingJieState(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         for each(_loc2_ in param1)
         {
            if(this.jingJie.isfind(_loc2_.getZx() - this.vp.x,_loc2_.getZy() - this.vp.y))
            {
               currentState = GS.a1;
               return;
            }
         }
         if(this.rdata.maxHp > this.rdata.curHp)
         {
            currentState = GS.a1;
            return;
         }
         if(currentState == 0)
         {
            if(_zCd.deiji < 0 && _zCd.zou < 0)
            {
               if(this.cradom * 100 > this.mAzRate)
               {
                  _zCd.deiji = this.fdeiji;
                  this.changeActionByNameAndUpdateAndNo("待机");
               }
               else
               {
                  if(this.cradom * 100 > this.forthRate)
                  {
                     this.setForth(_forth * -1);
                  }
                  _zCd.zou = this.cradom * this.fzouB + this.fzouA;
                  this.changeActionByNameAndUpdateAndNo("移动");
               }
            }
         }
      }
      
      private function gongJiState(param1:Vector.<ZhangDouT>, param2:Boolean) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc9_:ZhangDouT = null;
         var _loc10_:CAction = null;
         if(currentFrameName != "攻击" || currentFrameName == "攻击" && param2)
         {
            for each(_loc9_ in param1)
            {
               _loc10_ = this.selectGjAction(_loc9_.getZx(),_loc9_.getZy());
               if(_loc10_ != null)
               {
                  this.enterGj(_loc10_,_loc9_.getZx(),_loc9_.getZy());
                  return;
               }
            }
         }
         if(currentFrameName == "移动" && _zCd.zou > -1)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc6_:int = 10000;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            _loc7_ = this.getZx() - param1[_loc8_].getZx();
            _loc7_ = _loc7_ >= 0 ? _loc7_ : int(-_loc7_);
            if(_loc6_ > _loc7_)
            {
               _loc6_ = _loc7_;
               _loc5_ = _loc8_;
            }
            _loc8_++;
         }
         _loc3_ = param1[_loc5_].getZx();
         _loc4_ = param1[_loc5_].getZy();
         if(this.traceJuLi.includeJuLi(GS.a1,this.vp.x - _loc3_,this.vp.y - _loc4_))
         {
            this.qiangflag = 0;
            if(this.vp.x > _loc3_)
            {
               this.setForth(-1);
            }
            else
            {
               this.setForth(1);
            }
            this.changeActionByNameAndUpdateAndNo("待机");
         }
         else
         {
            this.setForth(this.traceJuLi.getMoveForth(this.qiangflag,this.vp.x - _loc3_,this.vp.y - _loc4_,this.qiangX - _loc3_));
            _zCd.zou = this.cradom * this.fzouB + this.fzouA;
            this.changeActionByNameAndUpdateAndNo("移动");
         }
      }
      
      private function moveRun() : void
      {
         var _loc6_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = GameEasing.getSpeedArray(runArr);
         _loc1_ += _loc4_[0];
         _loc2_ += _loc4_[1];
         if(_loc1_ != 0)
         {
            _loc3_ = 1;
         }
         var _loc5_:Array = curAction.getRunArr(this);
         if(_loc5_.length > 0)
         {
            _loc1_ += _loc5_[0];
            _loc2_ += _loc5_[1];
         }
         if(_loc2_ < 0)
         {
            _skyType = 1;
            gravityNum = 0;
         }
         else if(curAction.getGravity() == 1 || _zCd.shiZhong > -1)
         {
            gravityNum = 0;
         }
         else
         {
            gravityNum += 1;
            _loc2_ += gravity * gravityNum;
         }
         if(_loc1_ == 0 && _loc2_ == 0)
         {
            return;
         }
         if(_loc1_ > 0)
         {
            _loc6_ = true;
         }
         var _loc7_:int = Math.abs(_loc1_);
         var _loc8_:int = Math.abs(_loc2_);
         var _loc9_:Number = Number(GM.levelm.getLx());
         var _loc10_:Number = Number(GM.levelm.getLy());
         var _loc11_:Number = Number(GM.levelm.getpFoot());
         var _loc12_:Number = 20;
         var _loc13_:Array = GM.levelm.getRoomLockm();
         var _loc14_:Number = this.vp.x + _loc9_;
         var _loc15_:Number = this.vp.y + _loc10_;
         var _loc16_:Point = Pos.l_To_G(this.vp);
         var _loc17_:Number = _loc16_.x;
         var _loc18_:Number = _loc16_.y;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:* = _loc7_;
         while(_loc21_ > 0)
         {
            if(_loc6_)
            {
               if(GM.levelm.hitTestByMmonsterX(_loc17_ + _loc12_,_loc18_ - _loc11_,_loc3_))
               {
                  this.qiangflag = 1;
                  this.qiangX = _loc14_ - _loc9_;
                  break;
               }
               if(_loc14_ - _loc9_ >= _loc13_[1])
               {
                  this.qiangflag = 1;
                  this.qiangX = _loc14_ - _loc9_;
                  break;
               }
               _loc14_ += GS.a1;
               _loc17_ += GS.a1;
            }
            else if(!_loc6_)
            {
               if(GM.levelm.hitTestByMmonsterX(_loc17_ - _loc12_,_loc18_ - _loc11_,_loc3_))
               {
                  this.qiangflag = -1;
                  this.qiangX = _loc14_ - _loc9_;
                  break;
               }
               if(_loc14_ - _loc9_ <= _loc13_[0])
               {
                  this.qiangflag = -1;
                  this.qiangX = _loc14_ - _loc9_;
                  break;
               }
               _loc14_ -= GS.a1;
               _loc17_ -= GS.a1;
            }
            _loc21_--;
         }
         this.vp.x = _loc14_ - _loc9_;
         var _loc22_:* = _loc8_;
         while(_loc22_ > 0)
         {
            if(_loc2_ < 0)
            {
               if(GM.levelm.hitTestByMmonsterY(_loc17_,_loc18_ - bHeight,0))
               {
                  break;
               }
               if(_loc15_ - bHeight - _loc10_ <= _loc13_[2])
               {
                  break;
               }
               _loc15_ -= GS.a1;
               _loc18_ -= GS.a1;
            }
            else
            {
               _loc23_ = Boolean(GM.levelm.hitTestByMmonsterY(_loc17_,_loc18_ - 3,1));
               _loc24_ = Boolean(GM.levelm.hitTestByMmonsterY(_loc17_,_loc18_ - 1,1));
               if(_loc23_)
               {
                  _loc19_ = true;
               }
               if(_loc24_)
               {
                  _loc20_ = true;
               }
               else
               {
                  _loc20_ = false;
               }
               if(_loc23_)
               {
                  _loc15_ -= 2;
                  _loc18_ -= 2;
                  _skyType = 0;
               }
               else
               {
                  if(_loc24_)
                  {
                     _skyType = 0;
                     gravityNum = 0;
                     break;
                  }
                  if(_loc15_ - _loc10_ >= _loc13_[3])
                  {
                     _loc20_ = true;
                     _skyType = 0;
                     break;
                  }
                  _loc15_ += GS.a1;
                  _loc18_ += GS.a1;
                  _skyType = 1;
               }
            }
            _loc22_--;
         }
         this.vp.y = _loc15_ - _loc10_;
      }
      
      protected function changeActionByNameAndUpdateAndNo(param1:String) : void
      {
         if(currentFrameName != param1)
         {
            this.changeActionByNameAndUpdate(param1);
         }
      }
      
      private function changeActionByNameAndUpdate(param1:String) : void
      {
         this.changeActionByName(param1);
         curAction.gmUpdate(this);
      }
      
      private function changeActionByName(param1:String) : void
      {
         curAction.exit();
         curAction = this.tActionArr[param1];
         curAction.enter(this);
         currentFrameName = param1;
      }
      
      private function selectGjAction(param1:Number, param2:Number) : CAction
      {
         var _loc3_:CAction = null;
         var _loc4_:CAction = null;
         for each(_loc4_ in this.aActionArr)
         {
            if(_loc4_.keYiUse(this) && _loc4_.getGjHuangWei().isHuangWei(param1 - this.vp.x,param2 - this.vp.y))
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
      
      private function enterGj(param1:CAction, param2:Number, param3:Number) : void
      {
         this.jjAngerFlag = GS.a1;
         _zCd.zou = -1;
         _zCd.deiji = -1;
         if(this.vp.x > param2)
         {
            this.setForth(-1);
         }
         else
         {
            this.setForth(1);
         }
         curAction.exit();
         curAction = param1;
         param1.enter(this);
         curAction.gmUpdate(this);
         currentFrameName = "攻击";
      }
      
      public function petStop() : void
      {
         this.cpstop = GS.a2;
         this.allMcStop();
      }
      
      public function petContinue() : void
      {
         this.cpstop = GS.a1;
         if(currentState < GS.a2)
         {
            this.allMcPlay();
         }
         else
         {
            currentState = GS.a3;
         }
      }
      
      public function petStateFull() : void
      {
         currentState = GS.a1;
         this.changeActionByNameAndUpdateAndNo("待机");
      }
      
      override public function allMcStop() : void
      {
         this.vp.allMcStop();
      }
      
      override public function allMcPlay() : void
      {
         this.vp.allMcPlay();
      }
      
      public function addJJAnger(param1:Number) : void
      {
         if(this.jjAngerFlag != 0 && this.rdata.isYouJiJia())
         {
            this.curjjAnger += this.rdata.getAttackValue() * param1 * (GS.a1 + this.rdata.getBaojiJL()) * GS.a5;
            if(this.curjjAnger > this.maxjjAnger)
            {
               this.curjjAnger = this.maxjjAnger;
            }
            this.jjAngerFlag = 0;
         }
      }
      
      override public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         return this.vp.getByhit().hitTestPoint(param1,param2,true);
      }
      
      override public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         return param1.hitTestObject(this.vp.getByhit());
      }
      
      override public function bhitTestByObjectAndPoint(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         var _loc2_:Point = Pos.l_To_G(this.vp);
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
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param2.jiJiaAng);
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            addFlashE(param2.hitFlahE);
            return bhit(param2,param3);
         }
         return -1;
      }
      
      override public function bhitByPoint(param1:Number, param2:Number, param3:FightData, param4:ZhangDouT) : int
      {
         if(this.bhitTestByPoint(param1,param2))
         {
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param3.jiJiaAng);
            if(param3.hitsound != "null")
            {
               SoundManager.addOnlySound(param3.hitsound);
            }
            addFlashE(param3.hitFlahE);
            return bhit(param3,param4);
         }
         return -1;
      }
      
      override public function bhitByObject(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObject(param1))
         {
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param2.jiJiaAng);
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            addFlashE(param2.hitFlahE);
            return bhit(param2,param3);
         }
         return -1;
      }
      
      override public function getAttackValue() : Number
      {
         return this.rdata.getAttackValue();
      }
      
      override public function getDefenceValue() : Number
      {
         return this.rdata.getDefenceValue();
      }
      
      override public function getWuxinSX(param1:int) : int
      {
         return 0;
      }
      
      override public function getZtLevel() : int
      {
         return this.rdata.getZtLevel();
      }
      
      override public function getWuxinKaxin(param1:int) : Number
      {
         switch(param1)
         {
            case 1:
               return this.rdata.getJin();
            case 2:
               return this.rdata.getMu();
            case 3:
               return this.rdata.getShui();
            case 4:
               return this.rdata.getHuo();
            case 5:
               return this.rdata.getTu();
            case 6:
               return this.rdata.getHd();
            default:
               return 0;
         }
      }
      
      override public function getBaojiJL() : Number
      {
         return this.rdata.getBaojiJL();
      }
      
      override public function get cmp() : int
      {
         return this.rdata.curMp;
      }
      
      override public function get cHp() : int
      {
         return this.rdata.curHp;
      }
      
      override public function get mHp() : int
      {
         return this.rdata.maxHp;
      }
      
      override public function get mmp() : int
      {
         return this.rdata.maxMp;
      }
      
      override public function redMp(param1:int) : void
      {
         this.rdata.redMp(param1);
      }
      
      override public function addMp(param1:int) : void
      {
         this.rdata.addMp(param1);
      }
      
      public function addMpBfb(param1:Number) : void
      {
         var _loc2_:int = this.rdata.maxMp * param1 / GS.a10000;
         this.addMp(_loc2_);
      }
      
      override public function redHp(param1:int, param2:int, param3:Boolean) : void
      {
         if(param3)
         {
            playRHP(HpMcManager.self.getBaojiMc(),param1,param2);
         }
         else
         {
            playRHP(HpMcManager.self.getMonsterMc(),param1,param2);
         }
         this.rdata.redHp(param1);
      }
      
      override public function addHp(param1:int) : void
      {
         this.rdata.addHp(param1);
      }
      
      override public function addHpByPerc(param1:Number) : void
      {
         this.addHp(this.rdata.maxHp * param1 / GS.a10000);
      }
      
      override public function getZx() : Number
      {
         return this.vp.x;
      }
      
      override public function getZy() : Number
      {
         return this.vp.y;
      }
      
      override public function setZx(param1:Number) : void
      {
         this.vp.x = param1;
      }
      
      override public function setZy(param1:Number) : void
      {
         this.vp.y = param1;
      }
      
      override public function getXforth() : int
      {
         return _forth;
      }
      
      override public function getZmc() : MovieClip
      {
         return this.vp;
      }
      
      override public function gotoAndStopFrame(param1:Object) : void
      {
         this.vp.gotoAndStopFrame(param1);
      }
      
      override public function gotoAndPlayFrame(param1:Object) : void
      {
         this.vp.gotoAndPlayFrame(param1);
      }
      
      override public function getCurrentFrameNum() : int
      {
         return this.vp.getCurrentFrameNum();
      }
      
      override public function getFrameLabel() : String
      {
         return this.vp.getFrameLabel();
      }
      
      override public function getAhit() : MovieClip
      {
         return this.vp.getAhit();
      }
      
      override public function setForth(param1:int) : void
      {
         _forth = param1;
         this.vp.changeForth(_forth);
      }
      
      override public function addBufferMc(param1:MovieClip) : void
      {
         this.vp.addBuffer(param1);
      }
      
      override public function removeBufferMc(param1:MovieClip) : void
      {
         this.vp.removeBuffer(param1);
      }
      
      override public function getBullet(param1:String) : MovieClip
      {
         return this.vp.getBullet(param1);
      }
      
      override public function getAllBulletByClass(param1:Class) : Array
      {
         if(currentFrameName == "场景枪攻击" || currentFrameName == "场景枪跳击")
         {
            return this.vp.getAllBulletByClassByMapgun(param1);
         }
         return this.vp.getAllBulletByClassByJineng(param1);
      }
      
      override public function getXiaZhiMc(param1:String) : MovieClip
      {
         return this.vp.getXiaZhiMc(param1);
      }
      
      public function get curjjAnger() : Number
      {
         return this._curjjAnger.getValue();
      }
      
      public function set curjjAnger(param1:Number) : void
      {
         this._curjjAnger.setValue(param1);
      }
      
      public function get maxjjAnger() : Number
      {
         return this._maxjjAnger.getValue();
      }
      
      public function set maxjjAnger(param1:Number) : void
      {
         this._maxjjAnger.setValue(param1);
      }
      
      public function get jjAngerFlag() : Number
      {
         return this._jjAngerFlag.getValue();
      }
      
      public function set jjAngerFlag(param1:Number) : void
      {
         this._jjAngerFlag.setValue(param1);
      }
   }
}

