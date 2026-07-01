package hotpointgame.gMonster
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.gview.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   
   public class CMonster extends ZtC
   {
      
      protected var _vm:VMonster;
      
      private var bornX:Number;
      
      private var bornY:Number;
      
      private var mtype:int = 1;
      
      private var _boostype:VT;
      
      private var _mname:String = "";
      
      private var _twoname:String = "";
      
      private var _mshowname:String = "";
      
      private var _mlevel:VT;
      
      private var touFrame:int = 1;
      
      private var mhpUnit:int = 1000;
      
      private var mhpTn:int = 1;
      
      private var hptiaoFlag:int = 0;
      
      private var _wuxi:VT;
      
      private var _wxjin:VT;
      
      private var _wxmu:VT;
      
      private var _wxshui:VT;
      
      private var _wxfou:VT;
      
      private var _wxtu:VT;
      
      private var _wxhundun:VT;
      
      private var _jinyan:VT;
      
      private var dl:CMDiaoLou;
      
      private var _avalue:VT;
      
      private var _dvalue:VT;
      
      protected var fzouA:int = 10;
      
      protected var fzouB:int = 20;
      
      private var jingJie:CMJingJie;
      
      private var traceJuLi:TraceJuLi;
      
      private var tActionArr:Object;
      
      protected var aActionArr:Vector.<CAction>;
      
      protected var mbiredFnum:VT;
      
      protected var cmdeadcball:String = "";
      
      protected var cmjishicon:VT;
      
      protected var cmjishitimer:VT;
      
      private var qiangflag:int = 0;
      
      private var qiangX:Number = 0;
      
      protected var fdeiji:int = 80;
      
      protected var cradom:Number = 0;
      
      protected var mAzRate:int = 70;
      
      protected var forthRate:int = 50;
      
      public function CMonster(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         this._boostype = VT.createVT(20);
         this._mlevel = VT.createVT(20);
         this._wuxi = VT.createVT(20);
         this._wxjin = VT.createVT(20);
         this._wxmu = VT.createVT(20);
         this._wxshui = VT.createVT(20);
         this._wxfou = VT.createVT(20);
         this._wxtu = VT.createVT(20);
         this._wxhundun = VT.createVT(20);
         this._jinyan = VT.createVT(20);
         this._avalue = VT.createVT(20);
         this._dvalue = VT.createVT(1);
         this.tActionArr = new Object();
         this.aActionArr = new Vector.<CAction>();
         this.mbiredFnum = VT.createVT(0);
         this.cmjishicon = VT.createVT(0);
         this.cmjishitimer = VT.createVT(0);
         super();
         this._vm = new VMonster(param1,(param4.zg as VT).getValue());
         this._vm.x = this.bornX = param2;
         this._vm.y = this.bornY = param3;
         _forth = -1;
         ztType = GS.a2;
         bHeight = param1.height;
         bWidth = param1.width;
         this.mbiredFnum.setValue(GM.frameTime);
         this.mname = param4.mname;
         this.twoname = param4.ername;
         this.mshowname = param4.showname;
         this.mlevel = (param4.mlevel as VT).getValue();
         this.mtype = param4.mtype;
         this.boostype = param4.boostype;
         this.touFrame = param4.touframe;
         this.mhpUnit = param4.mhpunit;
         ztGroup = (param4.zg as VT).getValue();
         cHp = (param4.mhp as VT).getValue();
         mHp = cHp;
         this.avalue = (param4.av as VT).getValue();
         this.dvalue = (param4.dv as VT).getValue();
         gravity = (param4.gv as VT).getValue();
         this.wuxi = (param4.wuxi as VT).getValue();
         this.wxjin = (param4.wxjin as VT).getValue();
         this.wxmu = (param4.wxmu as VT).getValue();
         this.wxshui = (param4.wxshui as VT).getValue();
         this.wxfou = (param4.wxfou as VT).getValue();
         this.wxtu = (param4.wxtu as VT).getValue();
         this.wxhundun = (param4.wxhundun as VT).getValue();
         this.jinyan = (param4.jinyan as VT).getValue();
         this.dl = param4.dl;
         this.cmdeadcball = param4.mdeadcball;
         this.cmjishicon.setValue((param4.mjishicon as VT).getValue());
         this.cmjishitimer.setValue((param4.mjishitimer as VT).getValue());
         this.mhpTn = mHp / this.mhpUnit - 1;
         if(this.boostype == 10)
         {
            BoosHpTiaoC.opennum();
            _loc10_ = this.countBoosHpTiao();
            BoosHpTiaoC.self.update(this.touFrame,this.mtype,this.boostype,this.mlevel,this.mshowname,_loc10_[0],_loc10_[1],this.wuxi);
         }
         this.jingJie = param4.jingjie;
         this.traceJuLi = param4.tracejuli;
         this.fzouA = param4.fzouA;
         this.fzouB = param4.fzouB;
         var _loc5_:Array = ["冰冻","眩晕","水泡","束缚","石化","倒地","被打","待机","移动","起身"];
         for each(_loc6_ in _loc5_)
         {
            if(MonsterManager.isYActionData(this.mname + _loc6_))
            {
               this.tActionArr[_loc6_] = MonsterManager.getMActionByName(this.mname + _loc6_);
            }
            else
            {
               this.tActionArr[_loc6_] = MonsterManager.getMActionByName("通用怪" + _loc6_);
            }
         }
         _loc7_ = "死亡";
         if(this.mname == "海底基地章鱼博士乌克1")
         {
            if(MonsterManager.isYActionData(this.mname + _loc7_))
            {
               this.tActionArr[_loc7_] = MonsterManager.getMActionByName(this.twoname + this.mname + _loc7_);
            }
         }
         else if(MonsterManager.isYActionData(this.mname + _loc7_))
         {
            this.tActionArr[_loc7_] = MonsterManager.getMActionByName(this.mname + _loc7_);
         }
         else
         {
            this.tActionArr[_loc7_] = MonsterManager.getMActionByName("通用怪" + _loc7_);
         }
         var _loc8_:Array = param4.aActionArr;
         for each(_loc9_ in _loc8_)
         {
            this.aActionArr.push(MonsterManager.getMActionByName(_loc9_));
         }
         _zCd.deiji = this.fdeiji;
         currentFrameName = MADaiJi.name;
         curAction = this.tActionArr[MADaiJi.name];
         curAction.enter(this);
         curAction.gmUpdate(this);
      }
      
      public function gmUpdate(param1:Vector.<ZhangDouT>) : int
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Class = null;
         this.cradom = Math.random();
         this.beforeUpdate();
         this.otherUpdate();
         this.actionUpdate(param1);
         this.moveRun();
         if(this.boostype == 10 && this.hptiaoFlag == 1)
         {
            this.hptiaoFlag = 0;
            _loc3_ = this.countBoosHpTiao();
            BoosHpTiaoC.self.update(this.touFrame,this.mtype,this.boostype,this.mlevel,this.mshowname,_loc3_[0],_loc3_[1],this.wuxi);
         }
         for(_loc2_ in byhitFlashE)
         {
            _loc4_ = LoaderManager.getSwfClass(_loc2_) as Class;
            this._vm.addHitFlashEMc(new _loc4_());
         }
         byhitFlashE = new Object();
         this._vm.hpUpdate(cHp / mHp);
         if(this.cmjishitimer.getValue() != 0 && currentState != GS.a3 && GM.frameTime - this.mbiredFnum.getValue() > this.cmjishitimer.getValue())
         {
            if(currentState != GS.a2)
            {
               currentState = GS.a3;
            }
         }
         return currentState;
      }
      
      public function mhpTnByRoleA() : void
      {
         var _loc1_:Array = null;
         this.mhpUnit = mHp / 20;
         this.mhpTn = mHp / this.mhpUnit - 1;
         if(this.boostype == 10)
         {
            _loc1_ = this.countBoosHpTiao();
            BoosHpTiaoC.self.update(this.touFrame,this.mtype,this.boostype,this.mlevel,this.mshowname,_loc1_[0],_loc1_[1],this.wuxi);
         }
      }
      
      private function beforeUpdate() : void
      {
         _zCd.gmUpdate(this);
         bCd.gmUpdate(this);
         if(_zCd.weizhanTime > 0)
         {
            this._vm.setAlpha(0.2);
         }
         else
         {
            this._vm.setAlpha(1);
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
               if(this.cmdeadcball != "")
               {
                  ZtDFFactory.createYbBall(this.cmdeadcball,this.getZx(),this.getZy() - GS.a50);
               }
               currentState = GS.a3;
            }
            return;
         }
         var _loc3_:int = 1;
         if(param1.length > 0)
         {
            _loc3_ = this._vm.x > param1[0].getZx() ? -1 : 1;
         }
         if(_zCd.bingDong > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("冰冻",_loc3_);
            return;
         }
         if(_zCd.shiHua > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("石化",_loc3_);
            return;
         }
         if(_zCd.xuanYun > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("眩晕",_loc3_);
            return;
         }
         if(_zCd.shuiPao > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("水泡",_loc3_);
            return;
         }
         if(_zCd.shuFu > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("束缚",_loc3_);
            return;
         }
         if(_zCd.yinZhi > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("被打",_loc3_);
            return;
         }
         if(_zCd.jiDao > -GS.a1)
         {
            this.changeActionByNameAndUpdateAndNoAndForth("倒地",_loc3_);
            return;
         }
         if(cHp == 0 && currentState != GS.a2 && currentState != GS.a3 && skyType == 0)
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
         if(param1.length == 0)
         {
            if(_zCd.deiji < 0 && _zCd.zou < 0)
            {
               this.moveByNoEnemy();
            }
            else if(currentFrameName != MADaiJi.name && currentFrameName != MAZou.name)
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
            this.changeActionByNameAndUpdateAndNo(MADaiJi.name);
         }
         else
         {
            if(this.cradom * 100 > this.forthRate)
            {
               this.setForth(_forth * -1);
            }
            _zCd.zou = this.cradom * this.fzouB + this.fzouA;
            this.changeActionByNameAndUpdateAndNo(MAZou.name);
         }
      }
      
      private function jingJieState(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         for each(_loc2_ in param1)
         {
            if(this.jingJie.isfind(_loc2_.getZx() - this._vm.x,_loc2_.getZy() - this._vm.y))
            {
               currentState = GS.a1;
               return;
            }
         }
         if(mHp > cHp)
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
                  this.changeActionByNameAndUpdateAndNo(MADaiJi.name);
               }
               else
               {
                  if(this.cradom * 100 > this.forthRate)
                  {
                     this.setForth(_forth * -1);
                  }
                  _zCd.zou = this.cradom * this.fzouB + this.fzouA;
                  this.changeActionByNameAndUpdateAndNo(MAZou.name);
               }
            }
         }
      }
      
      private function gongJiState(param1:Vector.<ZhangDouT>, param2:Boolean) : void
      {
         var _loc5_:ZhangDouT = null;
         var _loc6_:CAction = null;
         if(currentFrameName != "攻击" || currentFrameName == "攻击" && param2)
         {
            for each(_loc5_ in param1)
            {
               _loc6_ = this.selectGjAction(_loc5_.getZx(),_loc5_.getZy());
               if(_loc6_ != null)
               {
                  this.enterGj(_loc6_,_loc5_.getZx(),_loc5_.getZy());
                  return;
               }
            }
         }
         if(currentFrameName == "移动" && _zCd.zou > -1)
         {
            return;
         }
         var _loc3_:Number = param1[0].getZx();
         var _loc4_:Number = param1[0].getZy();
         if(this.traceJuLi.includeJuLi(this.mtype,this._vm.x - _loc3_,this._vm.y - _loc4_))
         {
            this.qiangflag = 0;
            if(this._vm.x > _loc3_)
            {
               this.setForth(-1);
            }
            else
            {
               this.setForth(1);
            }
            this.changeActionByNameAndUpdateAndNo(MADaiJi.name);
         }
         else
         {
            this.setForth(this.traceJuLi.getMoveForth(this.qiangflag,this._vm.x - _loc3_,this._vm.y - _loc4_,this.qiangX - _loc3_));
            _zCd.zou = this.cradom * this.fzouB + this.fzouA;
            this.changeActionByNameAndUpdateAndNo(MAZou.name);
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
         var _loc14_:Number = this._vm.x + _loc9_;
         var _loc15_:Number = this._vm.y + _loc10_;
         var _loc16_:Point = Pos.l_To_G(this._vm);
         var _loc17_:Number = _loc16_.x;
         var _loc18_:Number = _loc16_.y;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:* = _loc7_;
         while(_loc21_ > 0)
         {
            if(_loc6_)
            {
               if(GM.levelm.hitTestByMmonsterX(_loc17_ + _loc12_,_loc18_ - _loc11_,_loc3_,this))
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
               if(GM.levelm.hitTestByMmonsterX(_loc17_ - _loc12_,_loc18_ - _loc11_,_loc3_,this))
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
         this._vm.x = _loc14_ - _loc9_;
         var _loc22_:* = _loc8_;
         while(_loc22_ > 0)
         {
            if(_loc2_ < 0)
            {
               if(GM.levelm.hitTestByMmonsterY(_loc17_,_loc18_ - bHeight,0,this))
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
               _loc23_ = Boolean(GM.levelm.hitTestByMmonsterY(_loc17_,_loc18_ - 3,1,this));
               _loc24_ = Boolean(GM.levelm.hitTestByMmonsterY(_loc17_,_loc18_ - 1,1,this));
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
         this._vm.y = _loc15_ - _loc10_;
      }
      
      public function getDiaoLou() : void
      {
         var _loc2_:Goods = null;
         var _loc1_:Vector.<Goods> = this.dl.getDlGoods(this.cradom * GS.a10000);
         for each(_loc2_ in _loc1_)
         {
            GM.levelm.addDiaoLougood(_loc2_,this.getZx(),this.getZy());
         }
      }
      
      public function killMe() : void
      {
         if(currentState < GS.a2)
         {
            runArr.length = 0;
            currentState = GS.a2;
            cHp = 0;
            this.changeActionByNameAndUpdateAndNo("死亡");
            bCd.removeAllBuffer(this);
         }
      }
      
      protected function changeActionByNameAndUpdateAndNo(param1:String) : void
      {
         if(currentFrameName != param1)
         {
            this.changeActionByNameAndUpdate(param1);
         }
      }
      
      private function changeActionByNameAndUpdateAndNoAndForth(param1:String, param2:int) : void
      {
         if(currentFrameName != param1)
         {
            this.setForth(param2);
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
            if(_loc4_.keYiUse(this) && _loc4_.getGjHuangWei().isHuangWei(param1 - this._vm.x,param2 - this._vm.y))
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
      
      private function enterGj(param1:CAction, param2:Number, param3:Number) : void
      {
         _zCd.zou = -1;
         _zCd.deiji = -1;
         if(this._vm.x > param2)
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
      
      private function countBoosHpTiao() : Array
      {
         var _loc1_:int = 0;
         if(cHp == mHp)
         {
            _loc1_ = this.mhpTn % 4;
            if(_loc1_ == 0)
            {
               _loc1_ = 3;
            }
            else
            {
               _loc1_--;
            }
            return [this.mhpTn,100 + _loc1_ * 100];
         }
         var _loc2_:Number = cHp / this.mhpUnit;
         var _loc3_:int = int(_loc2_);
         var _loc4_:int = (_loc2_ - _loc3_) * 100;
         if(_loc4_ == 0)
         {
            _loc4_ = 1;
         }
         if(_loc3_ == 0)
         {
            return [0,_loc4_ + 400];
         }
         _loc1_ = _loc3_ % 4;
         if(_loc1_ == 0)
         {
            _loc1_ = 3;
         }
         else
         {
            _loc1_--;
         }
         return [_loc3_,_loc4_ + _loc1_ * 100];
      }
      
      override public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         return this._vm.getMc("mbyhit").hitTestPoint(param1,param2,true);
      }
      
      override public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         return param1.hitTestObject(this._vm.getMc("mbyhit"));
      }
      
      override public function bhitTestByObjectAndPoint(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         var _loc2_:Point = Pos.l_To_G(this._vm);
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
         if(bCd != null)
         {
            return this.avalue * bCd.getAddatt();
         }
         return this.avalue;
      }
      
      override public function getDefenceValue() : Number
      {
         if(bCd != null)
         {
            return this.dvalue * bCd.getAddDenf();
         }
         return this.dvalue;
      }
      
      override public function getWuxinSX(param1:int) : int
      {
         return this.wuxi;
      }
      
      override public function getZtLevel() : int
      {
         return this.mlevel;
      }
      
      override public function getWuxinKaxin(param1:int) : Number
      {
         switch(param1)
         {
            case 1:
               return this.wxjin;
            case 2:
               return this.wxmu;
            case 3:
               return this.wxshui;
            case 4:
               return this.wxfou;
            case 5:
               return this.wxtu;
            case 6:
               return this.wxhundun;
            default:
               return 0;
         }
      }
      
      override public function redHp(param1:int, param2:int, param3:Boolean) : void
      {
         if(param1 >= 0)
         {
            this.hptiaoFlag = 1;
            if(param3)
            {
               playRHP(HpMcManager.self.getBaojiMc(),param1,param2);
            }
            else
            {
               playRHP(HpMcManager.self.getMonsterMc(),param1,param2);
            }
            super.redHp(param1,param2,param3);
         }
      }
      
      override public function addHp(param1:int) : void
      {
         var _loc2_:Class = null;
         if(param1 >= 0)
         {
            this.hptiaoFlag = 1;
            _loc2_ = LoaderManager.getSwfClass("huixuehesu") as Class;
            playPiao(new _loc2_(),param1);
            super.addHp(param1);
         }
      }
      
      override public function addHpByPerc(param1:Number) : void
      {
         this.addHp(mHp * param1);
      }
      
      override public function getZx() : Number
      {
         return this._vm.x;
      }
      
      override public function getZy() : Number
      {
         return this._vm.y;
      }
      
      override public function setZx(param1:Number) : void
      {
         this._vm.x = param1;
      }
      
      override public function setZy(param1:Number) : void
      {
         this._vm.y = param1;
      }
      
      override public function getXforth() : int
      {
         return _forth;
      }
      
      override public function getZmc() : MovieClip
      {
         return this._vm;
      }
      
      override public function gotoAndStopFrame(param1:Object) : void
      {
         this._vm.gotoAndStopFrame(param1);
      }
      
      override public function gotoAndPlayFrame(param1:Object) : void
      {
         this._vm.gotoAndPlayFrame(param1);
      }
      
      override public function getCurrentFrameNum() : int
      {
         return this._vm.getCurrentFrameNum();
      }
      
      override public function getFrameLabel() : String
      {
         return this._vm.getFrameLabel();
      }
      
      override public function getAhit() : MovieClip
      {
         return this._vm.getMc("mahit");
      }
      
      override public function setForth(param1:int) : void
      {
         _forth = param1;
         this._vm.changeForth(_forth * -1);
      }
      
      override public function getOtherHit(param1:String) : MovieClip
      {
         return this._vm.getMc(param1);
      }
      
      override public function addBufferMc(param1:MovieClip) : void
      {
         this._vm.addBuffer(param1);
      }
      
      override public function removeBufferMc(param1:MovieClip) : void
      {
         this._vm.removeBuffer(param1);
      }
      
      override public function getBullet(param1:String) : MovieClip
      {
         return this._vm.getMc(param1);
      }
      
      override public function getAllBulletByClass(param1:Class) : Array
      {
         return this._vm.getAllBulletByClass(param1);
      }
      
      override public function getXiaZhiMc(param1:String) : MovieClip
      {
         return this._vm.getMc(param1);
      }
      
      override public function remove() : void
      {
         if(this.boostype == 10)
         {
            BoosHpTiaoC.close();
         }
         super.remove();
         this._vm.remove();
         this._vm = null;
         this.dl = null;
         this.jingJie = null;
         this.traceJuLi = null;
         this.tActionArr = null;
         this.aActionArr = null;
      }
      
      public function get avalue() : Number
      {
         return this._avalue.getValue();
      }
      
      public function set avalue(param1:Number) : void
      {
         this._avalue.setValue(param1);
      }
      
      public function get dvalue() : Number
      {
         return this._dvalue.getValue();
      }
      
      public function set dvalue(param1:Number) : void
      {
         this._dvalue.setValue(param1);
      }
      
      public function get boostype() : int
      {
         return this._boostype.getValue();
      }
      
      public function set boostype(param1:int) : void
      {
         this._boostype.setValue(param1);
      }
      
      public function get mlevel() : Number
      {
         return this._mlevel.getValue();
      }
      
      public function set mlevel(param1:Number) : void
      {
         this._mlevel.setValue(param1);
      }
      
      public function get wuxi() : Number
      {
         return this._wuxi.getValue();
      }
      
      public function set wuxi(param1:Number) : void
      {
         this._wuxi.setValue(param1);
      }
      
      public function get wxjin() : Number
      {
         return this._wxjin.getValue();
      }
      
      public function set wxjin(param1:Number) : void
      {
         this._wxjin.setValue(param1);
      }
      
      public function get wxmu() : Number
      {
         return this._wxmu.getValue();
      }
      
      public function set wxmu(param1:Number) : void
      {
         this._wxmu.setValue(param1);
      }
      
      public function get wxshui() : Number
      {
         return this._wxshui.getValue();
      }
      
      public function set wxshui(param1:Number) : void
      {
         this._wxshui.setValue(param1);
      }
      
      public function get wxfou() : Number
      {
         return this._wxfou.getValue();
      }
      
      public function set wxfou(param1:Number) : void
      {
         this._wxfou.setValue(param1);
      }
      
      public function get wxtu() : Number
      {
         return this._wxtu.getValue();
      }
      
      public function set wxtu(param1:Number) : void
      {
         this._wxtu.setValue(param1);
      }
      
      public function get wxhundun() : Number
      {
         return this._wxhundun.getValue();
      }
      
      public function set wxhundun(param1:Number) : void
      {
         this._wxhundun.setValue(param1);
      }
      
      public function get jinyan() : Number
      {
         return this._jinyan.getValue();
      }
      
      public function set jinyan(param1:Number) : void
      {
         this._jinyan.setValue(param1);
      }
      
      public function get mshowname() : String
      {
         return this._mshowname;
      }
      
      public function set mshowname(param1:String) : void
      {
         this._mshowname = param1;
      }
      
      public function get mname() : String
      {
         return this._mname;
      }
      
      public function set mname(param1:String) : void
      {
         this._mname = param1;
      }
      
      public function get twoname() : String
      {
         return this._twoname;
      }
      
      public function set twoname(param1:String) : void
      {
         this._twoname = param1;
      }
   }
}

