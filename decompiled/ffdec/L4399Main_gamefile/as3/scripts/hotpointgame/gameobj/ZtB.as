package hotpointgame.gameobj
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gsound.*;
   
   public class ZtB extends ZhangDouT
   {
      
      protected var mc:MovieClip;
      
      protected var fz:ZhangDouT;
      
      protected var fzforth:int = 0;
      
      protected var fda:FightData;
      
      protected var runState:int = 0;
      
      protected var runStateOver:int = 0;
      
      protected var runMaxOver:int = 0;
      
      protected var runMaxNum:int = 30;
      
      protected var zhendong:Object;
      
      protected var cHp:int = 1;
      
      protected var yba:int = 0;
      
      protected var _forth:int = 1;
      
      protected var bSin:Number = 0;
      
      protected var bCos:Number = 0;
      
      protected var zhenAnagle:Number = 0;
      
      protected var bSpeed:Number = 30;
      
      protected var bmSound:String = "";
      
      protected var bcumonstername:String = "";
      
      protected var currentFrameNum:int = 0;
      
      protected var testInterval:Number = 10;
      
      public var zmclevel:int = 0;
      
      public function ZtB(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super();
         this.mc = param1;
         this.fz = param2;
         this.fzforth = param4;
         ztGroup = this.fz.getZTGroup();
         ztType = GS.a3;
         this.dataInit(param3);
         this.mcInit();
         this.getAhit().visible = false;
      }
      
      public function gmUpdate(param1:Vector.<ZhangDouT>) : int
      {
         this.mcUpdate();
         this.hpUpdate();
         this.beforeUpdate(param1);
         this.moveAndTestHit(param1);
         this.afterUpdate();
         return this.runState;
      }
      
      protected function dataInit(param1:Object) : void
      {
         this.zmclevel = param1.dmclevel;
         this.fda = param1.fda;
         this.runMaxOver = param1.runMaxOver;
         this.runStateOver = param1.runStateOver;
         this.runMaxNum = param1.runMaxNum;
         this.bSpeed = param1.bSpeed;
         this.cHp = param1.hp;
         this.yba = param1.yba;
         this.zhendong = param1.zhendong;
         if(param1.createsound != "null")
         {
            SoundManager.addOnlySound(param1.createsound);
         }
         this.bmSound = param1.bombsound;
         this.bcumonstername = param1.cumonstername;
      }
      
      protected function mcInit() : void
      {
         this.mc.rotation = Math.round(this.mc.rotation);
         var _loc1_:Point = Pos.l_To_G(this.mc);
         _loc1_ = GM.levelm.gPointChangeLevel(_loc1_);
         this.mc.x = _loc1_.x;
         this.mc.y = _loc1_.y;
         if(this.fzforth == 0)
         {
            if(this.fz.getZTType() == 1)
            {
               this.mc.rotation = this.fz.getXforth() == 1 ? this.mc.rotation : 180 + this.mc.rotation * -1;
               this.zhenAnagle = this.mc.rotation;
            }
            if(this.fz.getZTType() == 2)
            {
               this.mc.rotation = this.fz.getXforth() == -1 ? this.mc.rotation + 180 : this.mc.rotation * -1;
               this.zhenAnagle = this.mc.rotation;
               this.mc.rotation = 180 + this.zhenAnagle;
            }
         }
         else
         {
            if(this.fz.getZTType() == 1)
            {
               this.mc.rotation = this.fzforth == 1 ? this.mc.rotation : 180 + this.mc.rotation * -1;
               this.zhenAnagle = this.mc.rotation;
            }
            if(this.fz.getZTType() == 2)
            {
               this.mc.rotation = this.fzforth == -1 ? this.mc.rotation + 180 : this.mc.rotation * -1;
               this.zhenAnagle = this.mc.rotation;
               this.mc.rotation = 180 + this.zhenAnagle;
            }
         }
         this.bSin = Math.sin(this.zhenAnagle * Math.PI / 180);
         this.bCos = Math.cos(this.zhenAnagle * Math.PI / 180);
         this._forth = this.zhenAnagle > -90 && this.zhenAnagle <= 90 ? 1 : -1;
         if(this.mc.rotation > 90 || this.mc.rotation < -90)
         {
            this.mc.scaleY *= -1;
         }
         this.mc.alpha = 1;
         this.mc.gotoAndPlay(1);
      }
      
      protected function mcUpdate() : void
      {
         ++this.currentFrameNum;
         if(this.runState == 0 && this.runMaxNum == this.currentFrameNum)
         {
            if(this.runMaxOver == 0)
            {
               this.enterRunStataOne();
            }
            if(this.runMaxOver == 1)
            {
               this.enterRunStataTwo();
            }
         }
         if(this.runState == 0 && this.mc.currentLabel != "飞行")
         {
            if(this.runStateOver == 0)
            {
               this.mc.gotoAndStop(this.mc.currentFrame - 1);
            }
            if(this.runStateOver == 1)
            {
               this.enterRunStataOne();
            }
         }
         if(this.runState == GS.a1 && this.mc.totalFrames == this.mc.currentFrame)
         {
            this.enterRunStataTwo();
         }
      }
      
      protected function hpUpdate() : void
      {
         if(this.yba == 1 && this.cHp < 0 && this.runState == 0)
         {
            this.enterRunStataTwo();
         }
      }
      
      protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
      }
      
      protected function afterUpdate() : void
      {
      }
      
      protected function moveAndTestHit(param1:Vector.<ZhangDouT>) : void
      {
      }
      
      public function remove() : void
      {
         this.fz = null;
         this.fda = null;
         this.mc.stop();
         if(this.mc.parent)
         {
            this.mc.parent.removeChild(this.mc);
         }
         this.mc = null;
      }
      
      protected function enterRunStataOne() : void
      {
         this.runState = GS.a1;
         this.bSpeed = 0;
         this.mc.gotoAndPlay("爆炸");
         if(this.zhendong.fudu != null)
         {
            GM.levelm.setShakeMSpeed(this.zhendong);
         }
         if(this.bmSound != "null")
         {
            SoundManager.addOnlySound(this.bmSound);
         }
      }
      
      protected function enterRunStataTwo() : void
      {
         if(this.bcumonstername != "")
         {
            if(GM.levelm.curLevel.id == GS.a1000 + GS.a9 || GM.levelm.curLevel.id == GS.a1000 + GS.a12)
            {
               MonsterManager.creatMonsterByRoleAAndId1009(this.bcumonstername,this.getZx(),this.getZy() - GS.a50);
            }
            else if(GM.levelm.curLevel.id >= GS.a100 && GM.levelm.curLevel.id <= GS.a200)
            {
               MonsterManager.creatMonsterBy100Add(this.bcumonstername,this.getZx(),this.getZy() - GS.a50,GM.levelm.curLevel.id);
            }
            else if(GM.levelm.curLevel.id > GS.a4000 && GM.levelm.curLevel.id <= GS.a4000 + GS.a7)
            {
               MonsterManager.creatMonsterBy100Add(this.bcumonstername,this.getZx(),this.getZy() - GS.a50,GM.levelm.curLevel.id);
            }
            else
            {
               MonsterManager.creatMonster(this.bcumonstername,this.getZx(),this.getZy() - GS.a50);
            }
         }
         this.mc.stop();
         this.bSpeed = 0;
         this.runState = GS.a2;
      }
      
      protected function getAhit() : MovieClip
      {
         return this.mc["bahit"];
      }
      
      protected function getOtherAhit(param1:String) : MovieClip
      {
         return this.mc[param1];
      }
      
      public function buNengBeida() : Boolean
      {
         if(this.runState != 0 || this.cHp < 0)
         {
            return true;
         }
         return false;
      }
      
      public function redHp(param1:int) : void
      {
         this.cHp -= param1;
      }
      
      public function getYba() : int
      {
         return this.yba;
      }
      
      override public function getZx() : Number
      {
         return this.mc.x;
      }
      
      override public function getZy() : Number
      {
         return this.mc.y;
      }
      
      override public function setZx(param1:Number) : void
      {
         this.mc.x = param1;
      }
      
      override public function setZy(param1:Number) : void
      {
         this.mc.y = param1;
      }
      
      override public function getXforth() : int
      {
         return this._forth;
      }
      
      override public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         if(this.buNengBeida())
         {
            return false;
         }
         return this.getAhit().hitTestPoint(param1,param2,true);
      }
      
      override public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         if(this.buNengBeida())
         {
            return false;
         }
         return param1.hitTestObject(this.getAhit());
      }
      
      override public function bhitTestByObjectAndPoint(param1:DisplayObject) : Boolean
      {
         if(this.buNengBeida())
         {
            return false;
         }
         var _loc2_:Point = Pos.l_To_G(this.mc);
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y,true))
         {
            return true;
         }
         return false;
      }
      
      override public function bhitByObjectAndPoint(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObjectAndPoint(param1))
         {
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            return this.bhit(param2,param3);
         }
         return -1;
      }
      
      override public function bhitByPoint(param1:Number, param2:Number, param3:FightData, param4:ZhangDouT) : int
      {
         if(this.bhitTestByPoint(param1,param2))
         {
            return this.bhit(param3,param4);
         }
         return -1;
      }
      
      override public function bhitByObject(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObject(param1))
         {
            return this.bhit(param2,param3);
         }
         return -1;
      }
      
      override public function bhit(param1:FightData, param2:ZhangDouT) : int
      {
         var _loc3_:Number = NaN;
         if(param1.shangHaiBi != 0)
         {
            _loc3_ = param2.getAttackValue();
            this.redHp(_loc3_);
            return _loc3_;
         }
         return 0;
      }
      
      override public function getZmc() : MovieClip
      {
         return this.mc;
      }
      
      override public function getAttackValue() : Number
      {
         return this.fz.getAttackValue();
      }
      
      override public function getDefenceValue() : Number
      {
         return this.fz.getDefenceValue();
      }
      
      override public function getWuxinSX(param1:int) : int
      {
         return this.fz.getWuxinSX(param1);
      }
      
      override public function getZtLevel() : int
      {
         return this.fz.getZtLevel();
      }
      
      override public function getWuxinKaxin(param1:int) : Number
      {
         return this.fz.getWuxinKaxin(param1);
      }
      
      override public function getBaojiJL() : Number
      {
         return this.fz.getBaojiJL();
      }
      
      override public function isLive() : Boolean
      {
         if(this.runState == 0)
         {
            return true;
         }
         return false;
      }
   }
}

