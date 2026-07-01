package hotpointgame.glevel
{
   import flash.display.*;
   import flash.geom.*;
   import flash.text.TextField;
   import hotpointgame.Control.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.gameloader.*;
   
   public class VScene extends MovieClip
   {
      
      private var moveMc:MovieClip = new MovieClip();
      
      private var fixMc:MovieClip = new MovieClip();
      
      private var movefixMcb:MovieClip = new MovieClip();
      
      private var yuanjingMc:MovieClip;
      
      private var zhongjingMc:MovieClip;
      
      private var qianjingMc:MovieClip;
      
      private var hitMc:MovieClip;
      
      private var petMc:MovieClip = new MovieClip();
      
      private var playMc:MovieClip = new MovieClip();
      
      private var bulletMc:MovieClip = new MovieClip();
      
      private var bulletBMc:MovieClip = new MovieClip();
      
      private var monsterMc:MovieClip = new MovieClip();
      
      private var forthMc:MovieClip = new MovieClip();
      
      private var doorMc:MovieClip = new MovieClip();
      
      private var piaoHp:MovieClip = new MovieClip();
      
      private var mon_arrowMc:MovieClip;
      
      private var amcx:Number = 500;
      
      private var amcy:Number = 200;
      
      public function VScene(param1:MovieClip)
      {
         super();
         addChild(this.moveMc);
         addChild(this.fixMc);
         this.yuanjingMc = param1["yuanjing"];
         this.zhongjingMc = param1["zhongjing"];
         this.hitMc = param1["mappengzhuang"];
         this.qianjingMc = param1["qianjing"];
         this.hitMc.visible = false;
         this.moveMc.addChild(this.hitMc);
         this.moveMc.addChild(this.yuanjingMc);
         this.moveMc.addChild(this.movefixMcb);
         this.moveMc.addChild(this.zhongjingMc);
         this.moveMc.addChild(this.doorMc);
         this.moveMc.addChild(this.bulletBMc);
         this.moveMc.addChild(this.monsterMc);
         this.moveMc.addChild(this.petMc);
         this.moveMc.addChild(this.playMc);
         this.moveMc.addChild(this.bulletMc);
         this.moveMc.addChild(this.piaoHp);
         this.moveMc.addChild(this.qianjingMc);
         this.fixMc.addChild(this.forthMc);
         var _loc2_:Class = LoaderManager.getSwfClass("mon_arrow") as Class;
         this.mon_arrowMc = new _loc2_() as MovieClip;
         this.mon_arrowMc.visible = false;
         this.mon_arrowMc.x = this.amcx;
         this.mon_arrowMc.y = this.amcy;
         this.fixMc.addChild(this.mon_arrowMc);
         enabled = false;
         mouseEnabled = false;
         this.hitMc.enabled = false;
         this.hitMc.mouseEnabled = false;
         this.hitMc.mouseChildren = false;
         this.yuanjingMc.enabled = false;
         this.yuanjingMc.mouseEnabled = false;
         this.yuanjingMc.mouseChildren = false;
         this.movefixMcb.enabled = false;
         this.movefixMcb.mouseEnabled = false;
         this.movefixMcb.mouseChildren = false;
         this.zhongjingMc.enabled = false;
         this.zhongjingMc.mouseEnabled = false;
         this.zhongjingMc.mouseChildren = false;
         this.doorMc.enabled = false;
         this.doorMc.mouseEnabled = false;
         this.doorMc.mouseChildren = false;
         this.monsterMc.enabled = false;
         this.monsterMc.mouseEnabled = false;
         this.monsterMc.mouseChildren = false;
         this.bulletBMc.enabled = false;
         this.bulletBMc.mouseEnabled = false;
         this.bulletBMc.mouseChildren = false;
         this.bulletMc.enabled = false;
         this.bulletMc.mouseEnabled = false;
         this.bulletMc.mouseChildren = false;
         this.playMc.enabled = false;
         this.playMc.mouseEnabled = false;
         this.playMc.mouseChildren = false;
         this.petMc.enabled = false;
         this.petMc.mouseEnabled = false;
         this.petMc.mouseChildren = false;
         this.piaoHp.enabled = false;
         this.piaoHp.mouseEnabled = false;
         this.piaoHp.mouseChildren = false;
         this.qianjingMc.enabled = false;
         this.qianjingMc.mouseEnabled = false;
         this.qianjingMc.mouseChildren = false;
         this.forthMc.enabled = false;
         this.forthMc.mouseEnabled = false;
         this.forthMc.mouseChildren = false;
         this.fixMc.enabled = false;
         this.fixMc.mouseEnabled = false;
         this.fixMc.mouseChildren = false;
      }
      
      public function hittestA(param1:Number, param2:Number) : Boolean
      {
         return (this.hitMc["sj1"] as MovieClip).hitTestPoint(param1,param2,true);
      }
      
      public function hittestB(param1:Number, param2:Number) : Boolean
      {
         return (this.hitMc["sj2"] as MovieClip).hitTestPoint(param1,param2,true);
      }
      
      public function hittestC(param1:Number, param2:Number) : Boolean
      {
         return (this.hitMc["sj3"] as MovieClip).hitTestPoint(param1,param2,true);
      }
      
      public function getNpcMc() : MovieClip
      {
         this.zhongjingMc.mouseChildren = true;
         return this.zhongjingMc["cnpc"];
      }
      
      public function getGuaJiNpcMc() : MovieClip
      {
         this.zhongjingMc.mouseChildren = true;
         return this.zhongjingMc["mlddk"];
      }
      
      public function getGroupNpcMc() : MovieClip
      {
         this.zhongjingMc.mouseChildren = true;
         return this.zhongjingMc["mlddk"];
      }
      
      public function getTiaoZhangNpc() : SimpleButton
      {
         this.zhongjingMc.mouseChildren = true;
         return this.zhongjingMc["npcmzsze"];
      }
      
      public function getTZLvName() : TextField
      {
         return this.zhongjingMc["cs"]["sjrz"];
      }
      
      public function getZhongjingMc(param1:String) : MovieClip
      {
         return this.zhongjingMc.getChildByName(param1) as MovieClip;
      }
      
      public function gPointChangeLevel(param1:Point) : Point
      {
         return this.moveMc.globalToLocal(param1);
      }
      
      public function getLx() : Number
      {
         return this.moveMc.x;
      }
      
      public function getLy() : Number
      {
         return this.moveMc.y;
      }
      
      public function setLx(param1:Number, param2:Number, param3:Number) : void
      {
         this.moveMc.x = param1;
         this.yuanjingMc.x = this.moveMc.x * -1 * (1 - param2);
         this.qianjingMc.x = this.moveMc.x * -1 * (1 - param3);
      }
      
      public function setLy(param1:Number, param2:Number, param3:Number) : void
      {
         this.moveMc.y = param1;
         this.yuanjingMc.y = this.moveMc.y * -1 * (1 - param2);
         this.qianjingMc.y = this.moveMc.y * -1 * (1 - param3);
      }
      
      public function moveship(param1:Number) : void
      {
         this.hitMc.y += param1;
         this.zhongjingMc.y += param1;
         this.doorMc.y += param1;
         this.bulletBMc.y += param1;
         this.monsterMc.y += param1;
         this.petMc.y += param1;
         this.playMc.y += param1;
         this.bulletMc.y += param1;
         this.piaoHp.y += param1;
      }
      
      public function remove() : void
      {
         removeChild(this.moveMc);
         removeChild(this.fixMc);
         this.yuanjingMc = null;
         this.movefixMcb = null;
         this.zhongjingMc = null;
         this.qianjingMc = null;
         this.hitMc = null;
         this.playMc = null;
         this.petMc = null;
         this.piaoHp = null;
         this.monsterMc = null;
         this.bulletMc = null;
         this.bulletBMc = null;
         this.forthMc = null;
         this.doorMc = null;
         this.mon_arrowMc = null;
         this.moveMc = null;
         this.fixMc = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function clearForthMc() : void
      {
         var _loc1_:int = int(this.forthMc.numChildren);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            this.forthMc.removeChild(this.forthMc.getChildAt(_loc2_));
            _loc2_--;
         }
      }
      
      public function changeMonsterArrow() : void
      {
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc1_:Array = GM.levelm.countMonsterInRange(this.gPointChangeLevel(new Point(GM.vw,GM.vh)));
         if(_loc1_.length == 0)
         {
            this.mon_arrowMc.visible = false;
            return;
         }
         _loc2_ = this.gPointChangeLevel(new Point(this.amcx,this.amcy));
         this.mon_arrowMc.visible = true;
         (this.mon_arrowMc["arrow0"] as MovieClip).visible = false;
         (this.mon_arrowMc["arrow1"] as MovieClip).visible = false;
         (this.mon_arrowMc["arrow2"] as MovieClip).visible = false;
         (this.mon_arrowMc["arrow3"] as MovieClip).visible = false;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc3_];
            (this.mon_arrowMc["arrow" + _loc4_[0]] as MovieClip).visible = true;
            (this.mon_arrowMc["arrow" + _loc4_[0]] as MovieClip).rotation = Math.atan2(_loc4_[2] - 75 - _loc2_.y,_loc4_[1] - _loc2_.x) * 180 / Math.PI;
            _loc3_++;
         }
      }
      
      public function addForthMc(param1:MovieClip) : void
      {
         this.forthMc.addChild(param1);
      }
      
      public function clearDoor() : void
      {
      }
      
      public function addDoorMc(param1:MovieClip) : void
      {
         XiaoXiaoManager.addCGX(new CGXStop(param1,this.doorMc));
      }
      
      public function removeDoorMcByn(param1:String) : void
      {
         this.doorMc.removeChild(this.doorMc.getChildByName(param1));
      }
      
      public function addFixMcIn(param1:MovieClip) : void
      {
         this.fixMc.addChild(param1);
      }
      
      public function addTimerJiMc(param1:MovieClip) : void
      {
         param1.name = "fourLvt";
         param1.x = 300;
         param1.y = 10;
         this.fixMc.addChild(param1);
      }
      
      public function addMoveFixMcIn(param1:MovieClip) : void
      {
         this.movefixMcb.addChild(param1);
      }
      
      public function getAllJingBiMc(param1:Class) : Array
      {
         var _loc5_:* = undefined;
         var _loc2_:int = int(this.zhongjingMc.numChildren);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.zhongjingMc.getChildAt(_loc4_);
            if(_loc5_ is param1)
            {
               _loc3_[_loc3_.length] = _loc5_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function removeTimerJiMc() : void
      {
         this.fixMc.removeChild(this.fixMc.getChildByName("fourLvt"));
      }
      
      public function addDiaoLougMc(param1:MovieClip) : void
      {
         this.doorMc.addChild(param1);
      }
      
      public function addPiaoHp(param1:MovieClip) : void
      {
         XiaoXiaoManager.addCGX(new CGXSpeed(param1,this.piaoHp,0,-5,20));
      }
      
      public function addPiaoPiao(param1:MovieClip) : void
      {
         XiaoXiaoManager.addCGX(new CGXSpeed(param1,this.piaoHp,0,-2,20));
      }
      
      public function addPlayMc(param1:MovieClip) : void
      {
         this.playMc.addChild(param1);
      }
      
      public function addPetMc(param1:MovieClip) : void
      {
         this.petMc.addChild(param1);
      }
      
      public function addMcInMoveMc(param1:MovieClip) : void
      {
         this.moveMc.addChild(param1);
      }
      
      public function addMonsterMc(param1:MovieClip) : void
      {
         this.monsterMc.addChild(param1);
      }
      
      public function addBullerMc(param1:MovieClip) : void
      {
         this.bulletMc.addChild(param1);
      }
      
      public function addBullerBMc(param1:MovieClip) : void
      {
         this.bulletBMc.addChild(param1);
      }
   }
}

