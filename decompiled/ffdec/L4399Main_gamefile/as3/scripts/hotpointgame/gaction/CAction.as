package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.GJHuangWei;
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gsound.*;
   
   public class CAction
   {
      
      protected var flaFrameName:String = "";
      
      protected var _currentFrameNum:VT = VT.createVT(0);
      
      protected var hitEnemy:Array = [];
      
      protected var speedArry:Array = [];
      
      protected var moveObject:Object = new Object();
      
      protected var zhendongObject:Object = new Object();
      
      protected var soundObject:Object = new Object();
      
      protected var fda:FightData;
      
      protected var gjHuangWei:GJHuangWei;
      
      protected var daiDuan:int = 0;
      
      protected var ygravity:int = 0;
      
      protected var limitsky:int = 0;
      
      protected var _pwd:VT = VT.createVT(0);
      
      protected var _acd:VT = VT.createVT(0);
      
      protected var _cdrom:VT = VT.createVT(0);
      
      protected var _ccd:VT = VT.createVT(0);
      
      public function CAction(param1:String)
      {
         super();
         this.flaFrameName = param1;
      }
      
      public function setccd(param1:int) : void
      {
         this.ccd = param1;
      }
      
      public function setiniPetccd() : void
      {
         this.ccd = GM.frameTime + this.cdrom * Math.random();
      }
      
      public function setData(param1:Object) : void
      {
         this.fda = param1.fda;
         this.acd = (param1.acd as VT).getValue();
         this.cdrom = (param1.cdrom as VT).getValue();
         this.gjHuangWei = param1.gjH;
         this.moveObject = param1.mo;
         this.zhendongObject = param1.zhendong;
         this.soundObject = param1.skillsound;
         this.daiDuan = param1.dd;
         this.ygravity = param1.ygravity;
         this.pwd = (param1.pwd as VT).getValue();
         this.limitsky = param1.lit;
      }
      
      public function enter(param1:ZtC) : void
      {
         this.ccd = GM.frameTime + this.cdrom * Math.random();
         param1.redMp(this.pwd);
         param1.gotoAndPlayFrame(this.flaFrameName);
      }
      
      public function gmUpdate(param1:ZtC) : Boolean
      {
         ++this.currentFrameNum;
         this.beforeRun(param1);
         this.beforeByBullet(param1);
         return this.actionStateUpdate(param1);
      }
      
      public function exit() : void
      {
         this.currentFrameNum = 0;
         this.speedArry.length = 0;
         this.hitEnemy.length = 0;
      }
      
      protected function beforeRun(param1:ZtC) : void
      {
         if(this.moveObject[this.currentFrameNum])
         {
            this.speedArry[this.speedArry.length] = this.moveeasing(param1.forth,this.moveObject[this.currentFrameNum]);
         }
         if(this.zhendongObject[this.currentFrameNum])
         {
            GM.levelm.setShakeMSpeed(this.zhendongObject[this.currentFrameNum]);
         }
         if(this.soundObject[this.currentFrameNum])
         {
            SoundManager.addOnlySound(this.soundObject[this.currentFrameNum]);
         }
      }
      
      protected function beforeByBullet(param1:ZtC) : void
      {
      }
      
      protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(param1.getFrameLabel() != this.flaFrameName)
         {
            return true;
         }
         return false;
      }
      
      public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
      }
      
      public function getTcd() : Number
      {
         return (GM.frameTime - this.ccd) / this.acd * 100;
      }
      
      public function showIsKeYiUse(param1:ZtC) : Boolean
      {
         if(this.limitsky == 1 && param1.skyType == 1)
         {
            return false;
         }
         if(this.limitsky == 2 && param1.skyType == 0)
         {
            return false;
         }
         if(this.pwd > param1.cmp)
         {
            return false;
         }
         return true;
      }
      
      public function getRunArr(param1:ZtC) : Array
      {
         if(this.speedArry.length == 0)
         {
            return [0,0];
         }
         return GameEasing.getSpeedArray(this.speedArry);
      }
      
      public function cdisOver() : Boolean
      {
         if(GM.frameTime - this.ccd > this.acd)
         {
            return true;
         }
         return false;
      }
      
      public function keYiUse(param1:ZtC) : Boolean
      {
         if(!this.cdisOver())
         {
            return false;
         }
         if(this.limitsky == 1 && param1.skyType == 1)
         {
            return false;
         }
         if(this.limitsky == 2 && param1.skyType == 0)
         {
            return false;
         }
         if(this.pwd > param1.cmp)
         {
            return false;
         }
         return true;
      }
      
      public function getGravity() : int
      {
         return this.ygravity;
      }
      
      public function useKeyDaDuan() : int
      {
         return this.daiDuan;
      }
      
      protected function moveeasing(param1:int, param2:Array) : Array
      {
         return GameEasing.createRunArray(param1 * param2[0],param2[1],param2[2],param2[3]);
      }
      
      public function getGjHuangWei() : GJHuangWei
      {
         return this.gjHuangWei;
      }
      
      public function getName() : String
      {
         return this.flaFrameName;
      }
      
      public function getFd() : FightData
      {
         return this.fda;
      }
      
      public function setFd(param1:FightData) : void
      {
         this.fda = param1;
      }
      
      public function get acd() : int
      {
         return this._acd.getValue();
      }
      
      public function set acd(param1:int) : void
      {
         this._acd.setValue(param1);
      }
      
      public function get ccd() : int
      {
         return this._ccd.getValue();
      }
      
      public function set ccd(param1:int) : void
      {
         this._ccd.setValue(param1);
      }
      
      public function get pwd() : int
      {
         return this._pwd.getValue();
      }
      
      public function set pwd(param1:int) : void
      {
         this._pwd.setValue(param1);
      }
      
      public function get cdrom() : int
      {
         return this._cdrom.getValue();
      }
      
      public function set cdrom(param1:int) : void
      {
         this._cdrom.setValue(param1);
      }
      
      public function get currentFrameNum() : int
      {
         return this._currentFrameNum.getValue();
      }
      
      public function set currentFrameNum(param1:int) : void
      {
         this._currentFrameNum.setValue(param1);
      }
   }
}

