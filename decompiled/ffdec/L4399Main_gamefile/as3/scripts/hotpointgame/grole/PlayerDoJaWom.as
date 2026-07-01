package hotpointgame.grole
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class PlayerDoJaWom extends PlayerDo
   {
      
      private var vp:Vplayer;
      
      private var jaAtionObj:Object = {};
      
      private var jumpFrame:int = 0;
      
      private var jumpLimit:int = 5;
      
      private var jumpFlag:int = 0;
      
      private var chongFlag:int = 0;
      
      private var cpstop:int = 0;
      
      private var tempFixSkillArr:Array = ["冰冻","眩晕","水泡","束缚","石化","倒地","被打"];
      
      private var tempJianGongArr:Array = ["跳攻1","跳攻2"];
      
      private var tempJianGongArrB:Array = ["剑攻1","剑攻2","剑攻3","剑攻4"];
      
      private var jianGongGoundcName:String = "";
      
      private var jianGongSkycName:String = "";
      
      private var jinengFourFlag:uint = 0;
      
      private var jinengFiveFlag:Boolean = false;
      
      public function PlayerDoJaWom()
      {
         super();
         var _loc1_:Class = LoaderManager.getSwfClass("JijiaA_anheizhixing") as Class;
         var _loc2_:MovieClip = new _loc1_();
         currentState = GS.a1;
         this.vp = new VPlayerJA(_loc2_);
      }
      
      override public function remove() : void
      {
         this.vp.remove();
         this.vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         this.jaAtionObj = null;
      }
      
      override public function gmUpdate(param1:CPlayer) : void
      {
         var _loc3_:String = null;
         var _loc4_:CAction = null;
         var _loc2_:int = 1;
         while(_loc2_ <= 4)
         {
            _loc3_ = "技能" + _loc2_;
            _loc4_ = this.jaAtionObj[_loc3_] as CAction;
            if(_loc4_ != null)
            {
               Czhujiemian.self.upSkillTiao(_loc2_ - 1,_loc4_.getTcd(),_loc4_.showIsKeYiUse(param1));
            }
            _loc2_++;
         }
         param1.mpUpdateP();
         param1.redJJAnger();
         if(this.cpstop == GS.a1)
         {
            GM.aSaveData.petm.petReliveing();
            if(param1.curjjAnger == GS.a0)
            {
               param1.switchRenr();
               return;
            }
            this.keyControl(param1);
            if(this.cpstop == GS.a1)
            {
               this.moveRun(param1);
            }
         }
      }
      
      override public function reEnter(param1:CPlayer) : void
      {
         this.jaAtionObjInit();
         if(this.cpstop == GS.a0)
         {
            this.cpstop = GS.a1;
         }
         if(currentState == -GS.a1)
         {
            currentState = GS.a1;
         }
         param1.jijiachangestate = 0;
         curAction = this.jaAtionObj["待机"];
         curAction.enter(param1);
         param1.currentFrameName = "待机";
         curAction.gmUpdate(param1);
         this.actionInit();
      }
      
      private function actionInit() : void
      {
         Czhujiemian.self.skillTiaoAllClose();
         Czhujiemian.self.skillTiaoInitByJiJia(0,30);
         Czhujiemian.self.skillTiaoInitByJiJia(1,31);
         Czhujiemian.self.skillTiaoInitByJiJia(2,32);
         Czhujiemian.self.skillTiaoInitByJiJia(3,33);
      }
      
      override public function addHitFlashEMc(param1:MovieClip) : void
      {
         this.vp.addHitFlashEMc(param1);
      }
      
      override public function playerStop() : void
      {
         this.cpstop = GS.a2;
         this.allMcStop();
      }
      
      override public function playerStopByJiJia() : void
      {
         this.cpstop = GS.a3;
         this.allMcStop();
      }
      
      override public function playerContinue() : void
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
      
      override public function playerStateFull(param1:CPlayer) : void
      {
         currentState = GS.a1;
         this.changeActionByNameAndUpdateAndNo(param1,RADeiJi.name);
      }
      
      override public function getByhit() : MovieClip
      {
         return this.vp.getByhit();
      }
      
      override public function getPlayerMc() : MovieClip
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
         this.vp.changeForth(param1);
      }
      
      override public function addBufferMc(param1:MovieClip) : void
      {
         this.vp.addBuffer(param1);
      }
      
      override public function removeBufferMc(param1:MovieClip) : void
      {
         this.vp.removeBuffer(param1);
      }
      
      override public function getBullet(param1:String, param2:String) : MovieClip
      {
         return this.vp.getBullet(param2);
      }
      
      override public function getAllBulletByClass(param1:String, param2:Class) : Array
      {
         return this.vp.getAllBulletByClassByJineng(param2);
      }
      
      override public function getXiaZhiMc(param1:String) : MovieClip
      {
         return this.vp.getXiaZhiMc(param1);
      }
      
      override public function getx() : Number
      {
         return this.vp.x;
      }
      
      override public function setx(param1:Number) : void
      {
         this.vp.x = param1;
      }
      
      override public function gety() : Number
      {
         return this.vp.y;
      }
      
      override public function sety(param1:Number) : void
      {
         this.vp.y = param1;
      }
      
      private function keyControl(param1:CPlayer) : void
      {
         if(currentState == GS.a4)
         {
            return;
         }
         if(currentState == GS.a3)
         {
            return;
         }
         var _loc2_:Boolean = curAction.gmUpdate(param1);
         if(currentState == GS.a2)
         {
            if(_loc2_)
            {
               currentState = GS.a3;
               param1.switchRenrBydead();
            }
            return;
         }
         if(param1.zCd.bingDong > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"冰冻");
            return;
         }
         if(param1.zCd.shiHua > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"石化");
            return;
         }
         if(param1.zCd.xuanYun > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"眩晕");
            return;
         }
         if(param1.zCd.shuiPao > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"水泡");
            return;
         }
         if(param1.zCd.shuFu > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"束缚");
            return;
         }
         if(param1.zCd.yinZhi > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"被打");
            return;
         }
         if(param1.zCd.jiDao > -1)
         {
            this.changeActionByNameAndUpdateAndNo(param1,"倒地");
            return;
         }
         if(param1.mp.hpCur == 0 && currentState != GS.a2 && currentState != GS.a3 && param1.skyType == 0)
         {
            param1.runArr.length = 0;
            currentState = GS.a2;
            this.changeActionByNameAndUpdateAndNo(param1,"死亡");
            param1.bCd.removeAllBuffer(param1);
            return;
         }
         if(param1.currentFrameName == "倒地")
         {
            this.changeActionByNameAndUpdate(param1,"起身");
            currentState = -1;
            return;
         }
         if(param1.currentFrameName == "起身" && !_loc2_)
         {
            return;
         }
         if(_loc2_)
         {
            if(param1.currentFrameName == "起身")
            {
               currentState = GS.a1;
            }
            this.changeActionByNameAndUpdate(param1,RADeiJi.name);
         }
         if(this.tempFixSkillArr.indexOf(param1.currentFrameName) != -1)
         {
            this.changeActionByNameAndUpdate(param1,RADeiJi.name);
         }
         if(curAction.useKeyDaDuan() == ActionConstant.KeyDaDuanNO)
         {
            return;
         }
         var _loc3_:String = RADeiJi.name;
         var _loc4_:int = 0;
         if(GM.ckey.isKey("左跑"))
         {
            _loc3_ = RAPao.name;
            _loc4_ = 1;
         }
         else if(GM.ckey.isKey("右跑"))
         {
            _loc3_ = RAPao.name;
            _loc4_ = 2;
         }
         else if(GM.ckey.isKey("左按住"))
         {
            _loc3_ = RAZou.name;
            _loc4_ = 3;
         }
         else if(GM.ckey.isKey("右按住"))
         {
            _loc3_ = RAZou.name;
            _loc4_ = 4;
         }
         if(Boolean(GM.ckey.isKey("机甲技能" + GS.a1)) && Boolean(this.skillIsKeUser(param1,"技能" + GS.a1)))
         {
            _loc3_ = "技能" + GS.a1;
            this.changeActionByNameAndUpdate(param1,_loc3_);
            return;
         }
         if(Boolean(GM.ckey.isKey("机甲技能" + GS.a2)) && Boolean(this.skillIsKeUser(param1,"技能" + GS.a2)))
         {
            _loc3_ = "技能" + GS.a2;
            this.changeActionByNameAndUpdate(param1,_loc3_);
            return;
         }
         if(Boolean(GM.ckey.isKey("机甲技能" + GS.a3)) && Boolean(this.skillIsKeUser(param1,"技能" + GS.a3)))
         {
            _loc3_ = "技能" + GS.a3;
            this.changeActionByNameAndUpdate(param1,_loc3_);
            return;
         }
         if(Boolean(GM.ckey.isKey("机甲技能" + GS.a4)) && Boolean(this.skillIsKeUser(param1,"技能" + GS.a4)))
         {
            _loc3_ = "技能" + GS.a4;
            this.changeActionByNameAndUpdate(param1,_loc3_);
            return;
         }
         if(GM.ckey.isKey("跳"))
         {
            if(param1.currentFrameName != RATiao.name && this.jumpFlag < GS.a2)
            {
               this.jumpFlag += GS.a1;
               _loc3_ = RATiao.name;
               this.jumpFrame = GM.frameTime;
               this.changeActionByNameAndUpdate(param1,_loc3_);
               if(this.jumpFlag == 2)
               {
               }
               return;
            }
            if(param1.currentFrameName == RATiao.name && this.jumpFlag == GS.a1 && GM.frameTime - this.jumpFrame > this.jumpLimit)
            {
               ++this.jumpFlag;
               _loc3_ = RATiao.name;
               this.jumpFrame = 0;
               this.changeActionByNameAndUpdate(param1,_loc3_);
               return;
            }
         }
         if(GM.ckey.isKey("剑攻"))
         {
            if(param1.skyType == 0)
            {
               if(param1.currentFrameName != "枪攻击" || param1.currentFrameName == "枪攻击" && curAction.useKeyDaDuan() == ActionConstant.KeyDaDuanYB)
               {
                  _loc3_ = "枪攻击";
                  this.changeActionByNameAndUpdate(param1,_loc3_);
                  return;
               }
            }
            else if(param1.skyType == 1)
            {
               if(param1.currentFrameName != "枪跳击" && param1.currentFrameName != "剑跳击" || param1.currentFrameName == "枪跳击" && curAction.useKeyDaDuan() == ActionConstant.KeyDaDuanYB)
               {
                  _loc3_ = "枪跳击";
                  this.changeActionByNameAndUpdate(param1,_loc3_);
                  return;
               }
            }
         }
         if(Boolean(GM.ckey.isKey("枪攻")) && param1.cmp >= GS.a18 * GS.a10)
         {
            if(param1.skyType == 0)
            {
               if(param1.currentFrameName != "剑攻击" || param1.currentFrameName == "剑攻击" && curAction.useKeyDaDuan() == ActionConstant.KeyDaDuanYB)
               {
                  _loc3_ = "剑攻击";
                  this.jianGongGoundcName = this.getJiJiaGongGoundName(param1.currentFrameName == "剑攻击");
                  this.changeActionByNameAndUpdate(param1,this.jianGongGoundcName);
                  return;
               }
            }
            else if(param1.skyType == 1)
            {
               if(param1.currentFrameName != "剑跳击" && param1.currentFrameName != "枪跳击" || param1.currentFrameName == "剑跳击" && curAction.useKeyDaDuan() == ActionConstant.KeyDaDuanYB)
               {
                  _loc3_ = "剑跳击";
                  this.jianGongSkycName = this.getJiJiaGongSkyName(param1.currentFrameName == "剑跳击");
                  this.changeActionByNameAndUpdate(param1,this.jianGongSkycName);
                  return;
               }
            }
         }
         if(param1.currentFrameName == "枪跳击" || param1.currentFrameName == "枪攻击" || param1.currentFrameName == "剑跳击" || param1.currentFrameName == "剑攻击")
         {
            if(curAction.useKeyDaDuan() == ActionConstant.KeyDaDuanYB)
            {
               if(_loc3_ == RADeiJi.name)
               {
                  return;
               }
               param1.changePowerAndForth(_loc4_);
               this.changeActionByNameAndUpdate(param1,_loc3_);
               return;
            }
            param1.changeForthNotPower(_loc4_);
            return;
         }
         if(param1.currentFrameName == RATiao.name)
         {
            param1.changePowerAndForth(_loc4_);
            return;
         }
         if(_loc3_ == RAZou.name || _loc3_ == RAPao.name)
         {
            if(param1.skyType == 0)
            {
               param1.changePowerAndForth(_loc4_);
               this.changeActionByNameAndUpdateAndNo(param1,_loc3_);
               return;
            }
            param1.changePowerAndForth(_loc4_);
            this.changeActionByNameAndUpdateAndNo(param1,RADeiJi.name);
            return;
         }
         if(_loc3_ == RADeiJi.name)
         {
            if(param1.currentFrameName == RAZou.name || param1.currentFrameName == RAPao.name)
            {
               this.changeActionByNameAndUpdate(param1,_loc3_);
            }
            return;
         }
         throw new Error("keyControl Error!");
      }
      
      private function moveRun(param1:CPlayer) : void
      {
         var _loc6_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:Boolean = false;
         var _loc32_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = curAction.getRunArr(param1);
         if(_loc4_.length > 0)
         {
            _loc2_ = int(_loc4_[0]);
            _loc3_ = int(_loc4_[1]);
         }
         var _loc5_:Array = GameEasing.getSpeedArray(param1.runArr);
         _loc2_ += _loc5_[0];
         _loc3_ += _loc5_[1];
         if(_loc3_ < 0)
         {
            param1.skyType = 1;
            param1.gravityNum = 0;
         }
         else if(curAction.getGravity() == 1 || param1.zCd.shiZhong > -1)
         {
            param1.gravityNum = 0;
         }
         else
         {
            param1.gravityNum += 1;
            _loc3_ += param1.gravity * param1.gravityNum;
         }
         if(_loc2_ == 0 && _loc3_ == 0)
         {
            return;
         }
         if(_loc2_ > 0)
         {
            _loc6_ = true;
         }
         var _loc7_:int = Math.abs(_loc2_);
         var _loc8_:int = Math.abs(_loc3_);
         var _loc9_:Number = Number(GM.levelm.getLx());
         var _loc10_:Number = Number(GM.levelm.getLy());
         var _loc11_:Number = _loc9_;
         var _loc12_:Number = _loc10_;
         var _loc13_:Number = Number(GM.levelm.gettouPx());
         var _loc14_:Number = GM.vw - _loc13_;
         var _loc15_:Number = Number(GM.levelm.gettouPy());
         var _loc16_:Number = GM.vh - _loc15_;
         var _loc17_:Number = Number(GM.levelm.getpFoot());
         if(param1.currentFrameName == "跑攻")
         {
            _loc17_ = 40;
         }
         var _loc18_:Number = 20;
         var _loc19_:Array = GM.levelm.getRoomLockp();
         var _loc20_:Array = GM.levelm.getRoomTou();
         var _loc21_:Number = this.vp.x + _loc11_;
         var _loc22_:Number = this.vp.y + _loc12_;
         var _loc23_:Point = Pos.l_To_G(this.vp);
         var _loc24_:Number = _loc23_.x;
         var _loc25_:Number = _loc23_.y;
         var _loc26_:Boolean = false;
         var _loc27_:Boolean = false;
         var _loc28_:* = _loc7_;
         while(_loc28_ > 0)
         {
            if(_loc6_)
            {
               if(GM.levelm.hitTestByRoleX(_loc24_ + _loc18_,_loc25_ - _loc17_,0))
               {
                  break;
               }
               if(_loc21_ - _loc11_ >= _loc19_[1])
               {
                  break;
               }
               _loc21_ += GS.a1;
               _loc24_ += GS.a1;
               if(_loc21_ > _loc13_ && _loc9_ + _loc20_[1] > GM.vw)
               {
                  _loc9_--;
               }
            }
            else if(!_loc6_)
            {
               if(GM.levelm.hitTestByRoleX(_loc24_ - _loc18_,_loc25_ - _loc17_,1))
               {
                  break;
               }
               if(_loc21_ - _loc11_ <= _loc19_[0])
               {
                  break;
               }
               _loc21_ -= GS.a1;
               _loc24_ -= GS.a1;
               if(_loc21_ < _loc14_ && _loc9_ + _loc20_[0] < 0)
               {
                  _loc9_++;
               }
            }
            _loc28_--;
         }
         this.vp.x = _loc21_ - _loc11_;
         var _loc29_:* = _loc8_;
         while(_loc29_ > 0)
         {
            if(_loc3_ < 0)
            {
               if(GM.levelm.hitTestByRoleY(_loc24_,_loc25_ - GS.a162,0))
               {
                  break;
               }
               if(_loc22_ - param1.bHeight - _loc12_ <= _loc19_[2])
               {
                  break;
               }
               _loc22_ -= GS.a1;
               _loc25_ -= GS.a1;
               if(_loc22_ < _loc16_ && _loc10_ + _loc20_[2] < 0)
               {
                  _loc10_++;
               }
            }
            else
            {
               _loc30_ = Boolean(GM.levelm.hitTestByRoleY(_loc24_,_loc25_ - 3,1));
               _loc31_ = Boolean(GM.levelm.hitTestByRoleY(_loc24_,_loc25_ - GS.a1,1));
               if(_loc30_)
               {
                  _loc26_ = true;
               }
               if(_loc31_)
               {
                  _loc27_ = true;
               }
               else
               {
                  _loc27_ = false;
               }
               if(_loc30_)
               {
                  _loc22_ -= 2;
                  _loc25_ -= 2;
                  if(_loc22_ < _loc16_ && _loc10_ + _loc20_[2] < 0)
                  {
                     _loc10_ += 2;
                  }
                  param1.skyType = 0;
                  this.jumpFlag = 0;
                  this.chongFlag = 0;
               }
               else
               {
                  if(_loc31_)
                  {
                     param1.skyType = 0;
                     param1.gravityNum = 0;
                     this.jumpFlag = 0;
                     this.chongFlag = 0;
                     break;
                  }
                  if(_loc22_ - _loc12_ >= _loc19_[3])
                  {
                     _loc27_ = true;
                     this.jumpFlag = 0;
                     this.chongFlag = 0;
                     param1.skyType = 0;
                     break;
                  }
                  _loc22_ += GS.a1;
                  _loc25_ += GS.a1;
                  if(_loc22_ > _loc15_ && _loc10_ + _loc20_[3] > GM.vh)
                  {
                     _loc10_--;
                  }
                  param1.skyType = 1;
               }
            }
            _loc29_--;
         }
         if(_loc3_ >= 0 && false == _loc26_ && false == _loc27_)
         {
            _loc32_ = 1;
            while(_loc32_ < 10)
            {
               if(GM.levelm.hitTestByRoleY(_loc24_,_loc25_ + _loc32_,1))
               {
                  _loc22_ += _loc32_ - 1;
                  _loc25_ += _loc32_ - 1;
                  if(_loc22_ > _loc15_ && _loc10_ + _loc20_[3] > GM.vh)
                  {
                     _loc10_ -= _loc32_ - 1;
                  }
                  param1.skyType = 0;
                  this.jumpFlag = 0;
                  this.chongFlag = 0;
                  param1.gravityNum = 0;
                  break;
               }
               _loc32_++;
            }
         }
         this.vp.y = _loc22_ - _loc12_;
         GM.levelm.mapmoveing(_loc9_,_loc10_);
      }
      
      private function changeActionByNameAndUpdateAndNo(param1:CPlayer, param2:String) : void
      {
         if(param1.currentFrameName != param2)
         {
            this.changeActionByNameAndUpdate(param1,param2);
         }
      }
      
      private function changeActionByNameAndUpdate(param1:CPlayer, param2:String) : void
      {
         curAction.exit();
         curAction = this.jaAtionObj[param2];
         curAction.enter(param1);
         if(this.tempJianGongArr.indexOf(param2) != -1)
         {
            param1.currentFrameName = "剑跳击";
         }
         else if(this.tempJianGongArrB.indexOf(param2) != -1)
         {
            param1.currentFrameName = "剑攻击";
         }
         else
         {
            param1.currentFrameName = param2;
         }
         curAction.gmUpdate(param1);
      }
      
      private function skillIsKeUser(param1:CPlayer, param2:String) : Boolean
      {
         if(this.jaAtionObj[param2])
         {
            if((this.jaAtionObj[param2] as CAction).keYiUse(param1))
            {
               return true;
            }
         }
         return false;
      }
      
      private function jaAtionObjInit() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.jaAtionObj = new Object();
         var _loc1_:Array = ["倒地","被打","冰冻","眩晕","水泡","束缚","石化","死亡","待机","跑","走","起身","跳"];
         var _loc2_:Array = ["枪跳击","枪攻击","跳攻1","跳攻2","剑攻1","剑攻2","剑攻3","剑攻4","技能1","技能2","技能3","技能4"];
         var _loc3_:Object = {};
         for each(_loc4_ in _loc1_)
         {
            this.jaAtionObj[_loc4_] = RoleActionManger.getJiJiaActionByName("" + "暗黑之星" + _loc4_ + 1);
         }
         for each(_loc5_ in _loc2_)
         {
            this.jaAtionObj[_loc5_] = RoleActionManger.getJiJiaActionByName("" + "暗黑之星" + _loc5_ + 1);
         }
      }
      
      private function getJiJiaGongGoundName(param1:Boolean) : String
      {
         if(!param1)
         {
            return "剑攻1";
         }
         switch(this.jianGongGoundcName)
         {
            case "剑攻1":
               return "剑攻2";
            case "剑攻2":
               return "剑攻3";
            case "剑攻3":
               return "剑攻4";
            case "剑攻4":
               return "剑攻1";
            default:
               return "剑攻1";
         }
      }
      
      private function getJiJiaGongSkyName(param1:Boolean) : String
      {
         if(!param1)
         {
            return "跳攻1";
         }
         switch(this.jianGongSkycName)
         {
            case "跳攻1":
               return "跳攻2";
            case "跳攻2":
               return "跳攻1";
            default:
               return "跳攻1";
         }
      }
      
      private function allMcStop() : void
      {
         this.vp.allMcStop();
      }
      
      private function allMcPlay() : void
      {
         this.vp.allMcPlay();
      }
   }
}

