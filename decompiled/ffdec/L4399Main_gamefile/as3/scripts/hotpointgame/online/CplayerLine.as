package hotpointgame.online
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.VDatapkI;
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gsound.*;
   
   public class CplayerLine extends ZtC
   {
      
      protected var vp:VDatapkI;
      
      protected var actionArr:Object = new Object();
      
      protected var rdata:OnlineData;
      
      private var cpstop:int = 1;
      
      private var movespeed:Number = 8;
      
      public function CplayerLine(param1:OnlineData)
      {
         super();
         this.rdata = param1;
         ztType = GS.a1;
         ztGroup = GS.a1;
         gravity = GS.a2;
         this.initActionrAj();
         this.initRenC();
      }
      
      public function initActionrAj() : void
      {
      }
      
      public function initRenC() : void
      {
      }
      
      override public function remove() : void
      {
         super.remove();
         this.vp.remove();
         this.vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         this.actionArr = null;
      }
      
      public function gmUpdate(param1:Vector.<ZhangDouT>) : int
      {
         var _loc2_:Boolean = curAction.gmUpdate(this);
         if(_loc2_)
         {
            this.changeActionByNameAndUpdateAndNo("待机");
         }
         this.moveChange();
         this.moveRun();
         return currentState;
      }
      
      public function rAction(param1:Number, param2:Number, param3:int, param4:String, param5:Number) : void
      {
         if(param4 == "仅方向")
         {
            this.setForth(param3);
            return;
         }
         if(param4 == "走" || param4 == "跑")
         {
            this.movespeed = param5;
         }
         this.setZx(param1);
         this.setZy(param2);
         this.setForth(param3);
         if(this.actionArr[param4] != null)
         {
            this.changeActionByNameAndUpdateAndNo(param4);
         }
      }
      
      private function moveRun() : void
      {
         var _loc5_:Boolean = false;
         var _loc29_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = curAction.getRunArr(this);
         if(_loc3_.length > 0)
         {
            _loc1_ = int(_loc3_[0]);
            _loc2_ = int(_loc3_[1]);
         }
         var _loc4_:Array = GameEasing.getSpeedArray(runArr);
         _loc1_ += _loc4_[0];
         _loc2_ += _loc4_[1];
         if(_loc2_ < 0)
         {
            skyType = 1;
            gravityNum = 0;
         }
         else if(curAction.getGravity() == 1 || zCd.shiZhong > -1)
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
            _loc5_ = true;
         }
         var _loc6_:int = Math.abs(_loc1_);
         var _loc7_:int = Math.abs(_loc2_);
         var _loc8_:Number = Number(GM.levelm.getLx());
         var _loc9_:Number = Number(GM.levelm.getLy());
         var _loc10_:Number = _loc8_;
         var _loc11_:Number = _loc9_;
         var _loc12_:Number = Number(GM.levelm.gettouPx());
         var _loc13_:Number = GM.vw - _loc12_;
         var _loc14_:Number = Number(GM.levelm.gettouPy());
         var _loc15_:Number = GM.vh - _loc14_;
         var _loc16_:Number = Number(GM.levelm.getpFoot());
         if(currentFrameName == "跑攻")
         {
            _loc16_ = 40;
         }
         var _loc17_:Number = 20;
         var _loc18_:Array = GM.levelm.getRoomLockp();
         var _loc19_:Array = GM.levelm.getRoomTou();
         var _loc20_:Number = this.vp.x + _loc10_;
         var _loc21_:Number = this.vp.y + _loc11_;
         var _loc22_:Point = Pos.l_To_G(this.vp);
         var _loc23_:Number = _loc22_.x;
         var _loc24_:Number = _loc22_.y;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         var _loc27_:* = _loc6_;
         while(_loc27_ > 0)
         {
            if(_loc5_)
            {
               if(GM.levelm.hitTestByRoleX(_loc23_ + _loc17_,_loc24_ - _loc16_,0))
               {
                  break;
               }
               if(_loc20_ - _loc10_ >= _loc18_[1])
               {
                  break;
               }
               _loc20_ += GS.a1;
               _loc23_ += GS.a1;
               if(_loc20_ > _loc12_ && _loc8_ + _loc19_[1] > GM.vw)
               {
                  _loc8_--;
               }
            }
            else if(!_loc5_)
            {
               if(GM.levelm.hitTestByRoleX(_loc23_ - _loc17_,_loc24_ - _loc16_,1))
               {
                  break;
               }
               if(_loc20_ - _loc10_ <= _loc18_[0])
               {
                  break;
               }
               _loc20_ -= GS.a1;
               _loc23_ -= GS.a1;
               if(_loc20_ < _loc13_ && _loc8_ + _loc19_[0] < 0)
               {
                  _loc8_++;
               }
            }
            _loc27_--;
         }
         this.vp.x = _loc20_ - _loc10_;
         var _loc28_:* = _loc7_;
         while(_loc28_ > 0)
         {
            if(_loc2_ < 0)
            {
               if(GM.levelm.hitTestByRoleY(_loc23_,_loc24_ - GS.a120,0))
               {
                  break;
               }
               if(_loc21_ - bHeight - _loc11_ <= _loc18_[2])
               {
                  break;
               }
               _loc21_ -= GS.a1;
               _loc24_ -= GS.a1;
               if(_loc21_ < _loc15_ && _loc9_ + _loc19_[2] < 0)
               {
                  _loc9_++;
               }
            }
            else
            {
               _loc29_ = Boolean(GM.levelm.hitTestByRoleY(_loc23_,_loc24_ - 3,1));
               _loc30_ = Boolean(GM.levelm.hitTestByRoleY(_loc23_,_loc24_ - GS.a1,1));
               if(_loc29_)
               {
                  _loc25_ = true;
               }
               if(_loc30_)
               {
                  _loc26_ = true;
               }
               else
               {
                  _loc26_ = false;
               }
               if(_loc29_)
               {
                  _loc21_ -= 2;
                  _loc24_ -= 2;
                  if(_loc21_ < _loc15_ && _loc9_ + _loc19_[2] < 0)
                  {
                     _loc9_ += 2;
                  }
                  skyType = 0;
               }
               else
               {
                  if(_loc30_)
                  {
                     skyType = 0;
                     gravityNum = 0;
                     break;
                  }
                  if(_loc21_ - _loc11_ >= _loc18_[3])
                  {
                     _loc26_ = true;
                     skyType = 0;
                     break;
                  }
                  _loc21_ += GS.a1;
                  _loc24_ += GS.a1;
                  if(_loc21_ > _loc14_ && _loc9_ + _loc19_[3] > GM.vh)
                  {
                     _loc9_--;
                  }
                  skyType = 1;
               }
            }
            _loc28_--;
         }
         if(_loc2_ >= 0 && false == _loc25_ && false == _loc26_)
         {
            _loc31_ = 1;
            while(_loc31_ < 10)
            {
               if(GM.levelm.hitTestByRoleY(_loc23_,_loc24_ + _loc31_,1))
               {
                  _loc21_ += _loc31_ - 1;
                  _loc24_ += _loc31_ - 1;
                  if(_loc21_ > _loc14_ && _loc9_ + _loc19_[3] > GM.vh)
                  {
                     _loc9_ -= _loc31_ - 1;
                  }
                  skyType = 0;
                  gravityNum = 0;
                  break;
               }
               _loc31_++;
            }
         }
         this.vp.y = _loc21_ - _loc11_;
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
         curAction = this.actionArr[param1];
         curAction.enter(this);
         currentFrameName = param1;
      }
      
      private function moveChange() : void
      {
         if(currentFrameName == "走")
         {
            runArr[runArr.length] = GameEasing.createRunArray(_forth * this.movespeed * jiansu,0,1,1);
         }
         if(currentFrameName == "跑")
         {
            runArr[runArr.length] = GameEasing.createRunArray(_forth * this.movespeed * (GS.a1 + GS.a05) * jiansu,0,1,1);
         }
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
      
      public function getId() : uint
      {
         return this.rdata.userid;
      }
      
      public function getNmae() : String
      {
         return this.rdata.userName;
      }
   }
}

