package hotpointgame.glevel
{
   import flash.display.*;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.glevel.leveldata.LevelBD;
   import hotpointgame.gview.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.pet.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.fbPanel.*;
   import hotpointgame.views.shipPanel.*;
   
   public class LevelManager
   {
      
      private var gaMapGunMonster:Vector.<CMonsterMapGun> = new Vector.<CMonsterMapGun>();
      
      private var gaMonster:Vector.<CMonster> = new Vector.<CMonster>();
      
      private var gbMonster:Vector.<CMonster> = new Vector.<CMonster>();
      
      private var gcMonster:Vector.<CMonster> = new Vector.<CMonster>();
      
      private var gdMonster:Vector.<CMonster> = new Vector.<CMonster>();
      
      private var geMonster:Vector.<CMonster> = new Vector.<CMonster>();
      
      private var gaPet:Vector.<PetFight> = new Vector.<PetFight>();
      
      private var playerDPk:Vector.<CplayerPk> = new Vector.<CplayerPk>();
      
      private var gaBullet:Vector.<ZtB> = new Vector.<ZtB>();
      
      private var gbBullet:Vector.<ZtB> = new Vector.<ZtB>();
      
      private var gdBullet:Vector.<ZtB> = new Vector.<ZtB>();
      
      private var gatBullet:Vector.<ZtB> = new Vector.<ZtB>();
      
      private var gbtBullet:Vector.<ZtB> = new Vector.<ZtB>();
      
      private var gdtBullet:Vector.<ZtB> = new Vector.<ZtB>();
      
      private var gaZtDf:Vector.<YbBall> = new Vector.<YbBall>();
      
      private var gfShiTou:Vector.<ZShiTou> = new Vector.<ZShiTou>();
      
      private var _curLevel:CLevel;
      
      private var _upstate:VT = VT.createVT(0);
      
      private var _tObj:Object;
      
      private var dlm:DiaoLouGoodsM = new DiaoLouGoodsM();
      
      private var levelShare:ShakeM = new ShakeM();
      
      private var mapmoveflag:int = 0;
      
      private var mapmovex:Number = 0;
      
      private var mapmovey:Number = 0;
      
      public var backTwonF:int = 0;
      
      public var inty:int = 0;
      
      public function LevelManager()
      {
         super();
      }
      
      public function gmUpdate() : void
      {
         if(this.upstate == 0)
         {
            if(this._tObj != null)
            {
               this.curLevel = LevelDataManager.getCLevel(this._tObj.gqm + this._tObj.ll);
               this.curLevel.enterlevel(this._tObj);
               this._tObj = null;
            }
         }
         if(this.upstate == 1)
         {
            this.curLevel.gmUpdate();
            this.dlm.gmUpdate();
            this.mapmovebefore();
            this.gmUpdateMc();
            this.gmUpdateHit();
            this.mapmoveafter();
            this.levelShare.gmUpdate();
         }
         if(this.upstate == 2)
         {
            if(this._tObj == null)
            {
               throw new Error("to 为空!");
            }
            this.upstate = 3;
            GM.cp.playerStop();
            GM.levelm.petStop();
            this.clearallMAndB();
            this.addSendChangeCartoon(this.playOver);
         }
         if(this.upstate == 4)
         {
            if(this._tObj != null)
            {
               this.curLevel.exitLevelClear();
               this.curLevel = LevelDataManager.getCLevel(this._tObj.gqm + this._tObj.ll);
               this.curLevel.enterlevel(this._tObj);
               this._tObj = null;
            }
         }
      }
      
      public function setShakeMSpeed(param1:Object) : void
      {
         this.levelShare.setShake(param1.fudu,param1.chishu);
      }
      
      public function enterLevelM(param1:Object) : void
      {
         this._tObj = param1;
      }
      
      public function changeLevelData(param1:Object) : void
      {
         if(this._tObj != null || this.curLevel.tObj != null)
         {
            return;
         }
         if(param1.gqm != this.curLevel.name || this.curLevel.lstar != param1.ll)
         {
            this.upstate = 2;
            this._tObj = param1;
         }
      }
      
      public function enterlevelOk() : void
      {
         this.upstate = 1;
         GM.aSaveData.petm.restAllHpAndFight();
      }
      
      public function changeLevelDataByIdAndLs(param1:int, param2:int) : void
      {
         if(this._tObj != null || this.curLevel.tObj != null)
         {
            return;
         }
         GM.cp.playerStateFull();
         GM.cp.clearZeroAnger();
         GM.cp.changeLevelClearGun();
         var _loc3_:LevelBD = LevelDataManager.getLevelBD(param1);
         var _loc4_:Object = new Object();
         _loc4_.gqm = _loc3_.lname;
         _loc4_.cjm = _loc3_.enterSe;
         _loc4_.fjm = _loc3_.enterRm;
         _loc4_.x = _loc3_.enterX;
         _loc4_.y = _loc3_.enterY;
         _loc4_.ll = param2;
         this.upstate = 2;
         this._tObj = _loc4_;
      }
      
      public function changeLevelBySelf() : void
      {
         if(this._tObj != null || this.curLevel.tObj != null)
         {
            return;
         }
         if(this.curLevel.id >= GS.a3000 && this.curLevel.id <= GS.a3000 + GS.a100)
         {
            if(!FbData.isAgin(this.curLevel.id))
            {
               GoodsManger.cwTs("今天的次数已用完!");
               return;
            }
            if(this.curLevel.id == GS.a3000 + GS.a4)
            {
               if(!FlowInterface.redInBagDL(GS.a331004,GS.a1))
               {
                  GoodsManger.cwTs("要有 神农祭坛副本挑战券 才可以挑战!");
                  return;
               }
               GM.testapi.saveDataBefore();
            }
            else if(this.curLevel.id == GS.a3000 + GS.a9)
            {
               if(!FlowInterface.redInBagDL(GS.a331181,GS.a1))
               {
                  GoodsManger.cwTs("要有 幻海之国副本挑战券 才可以挑战!");
                  return;
               }
               GM.testapi.saveDataBefore();
            }
         }
         if(this.curLevel.id == GS.a9998)
         {
            if(GM.aSaveData.pkDrList.getShengxiaFn() <= 0)
            {
               return;
            }
         }
         if(this.curLevel.id == GS.a9997)
         {
            if(GM.aSaveData.tztR.enterNum >= GS.a2)
            {
               GoodsManger.cwTs("今天免费次数用光光鸟!");
               return;
            }
            GM.aSaveData.tztR.addNum();
         }
         if(GM.levelm.curLevel.id >= GS.a980 && GM.levelm.curLevel.id <= GS.a998)
         {
            return;
         }
         if(GM.levelm.curLevel.id == GS.a9994)
         {
            return;
         }
         if(this.curLevel.id >= GS.a1000 && this.curLevel.id <= GS.a1000 * GS.a2)
         {
            if(GM.aSaveData.sxiaodata.getkeyiusenum() < GS.a1)
            {
               return;
            }
         }
         if(this.curLevel.id >= GS.a2000 && this.curLevel.id <= GS.a2000 + GS.a100)
         {
            if(ShipData.tl.getValue() < GS.a2)
            {
               GoodsManger.cwTs("体力值不够了,至少要有2点!");
               return;
            }
         }
         var _loc1_:int = int(LevelDataManager.getLevelBD(this.curLevel.id).enterpid);
         if(_loc1_ != 0)
         {
            if(!FlowInterface.redInBagDL(_loc1_,GS.a1))
            {
               GoodsManger.cwTs("副本挑战券不足!");
               return;
            }
            GM.testapi.saveDataBefore();
         }
         GM.cp.playerStateFull();
         GM.cp.clearZeroAnger();
         GM.cp.changeLevelClearGun();
         var _loc2_:LevelBD = LevelDataManager.getLevelBD(this.curLevel.id);
         var _loc3_:Object = new Object();
         _loc3_.gqm = _loc2_.lname;
         _loc3_.cjm = _loc2_.enterSe;
         _loc3_.fjm = _loc2_.enterRm;
         _loc3_.x = _loc2_.enterX;
         _loc3_.y = _loc2_.enterY;
         _loc3_.ll = this.curLevel.lstar;
         this.upstate = 2;
         this._tObj = _loc3_;
      }
      
      public function changeLevelBackCity() : void
      {
         if(this.curLevel.id >= GS.a3000 && this.curLevel.id <= GS.a3000 + GS.a100 || this.curLevel.id == GS.a9998 || this.curLevel.id == GS.a9997 || this.curLevel.id == GS.a9994 || this.curLevel.id > GS.a2000 && this.curLevel.id < GS.a2000 + GS.a100)
         {
            this.backTwonF = 1;
         }
         else
         {
            this.backTwonF = 0;
         }
         GM.cp.playerStateFull();
         GM.cp.clearZeroAnger();
         GM.cp.changeLevelClearGun();
         var _loc1_:LevelBD = LevelDataManager.getLevelBD(GS.a9999);
         var _loc2_:Object = new Object();
         _loc2_.gqm = _loc1_.lname;
         _loc2_.cjm = _loc1_.enterSe;
         _loc2_.fjm = _loc1_.enterRm;
         _loc2_.x = _loc1_.enterX;
         _loc2_.y = _loc1_.enterY;
         _loc2_.ll = 1;
         GM.levelm.changeLevelData(_loc2_);
      }
      
      public function killAllM() : void
      {
         var _loc1_:CMonster = null;
         for each(_loc1_ in this.gbMonster)
         {
            _loc1_.killMe();
         }
      }
      
      public function clearallMAndB() : void
      {
         var _loc1_:CMonster = null;
         var _loc2_:CMonster = null;
         var _loc3_:CplayerPk = null;
         var _loc4_:CMonster = null;
         var _loc5_:CMonster = null;
         var _loc6_:CMonster = null;
         var _loc7_:ZtB = null;
         var _loc8_:ZtB = null;
         var _loc9_:ZtB = null;
         var _loc10_:ZtB = null;
         var _loc11_:ZtB = null;
         var _loc12_:ZtB = null;
         var _loc13_:YbBall = null;
         var _loc14_:ZShiTou = null;
         this.removeMapgMonster();
         for each(_loc1_ in this.gaMonster)
         {
            _loc1_.remove();
         }
         this.gaMonster.length = 0;
         for each(_loc2_ in this.gbMonster)
         {
            _loc2_.remove();
         }
         this.gbMonster.length = 0;
         for each(_loc3_ in this.playerDPk)
         {
            _loc3_.remove();
         }
         this.playerDPk.length = 0;
         for each(_loc4_ in this.gcMonster)
         {
            _loc4_.remove();
         }
         this.gcMonster.length = 0;
         for each(_loc5_ in this.gdMonster)
         {
            _loc5_.remove();
         }
         this.gdMonster.length = 0;
         for each(_loc6_ in this.geMonster)
         {
            _loc6_.remove();
         }
         this.geMonster.length = 0;
         for each(_loc7_ in this.gaBullet)
         {
            _loc7_.remove();
         }
         this.gaBullet.length = 0;
         for each(_loc8_ in this.gbBullet)
         {
            _loc8_.remove();
         }
         this.gbBullet.length = 0;
         for each(_loc9_ in this.gdBullet)
         {
            _loc9_.remove();
         }
         this.gdBullet.length = 0;
         for each(_loc10_ in this.gatBullet)
         {
            _loc10_.remove();
         }
         this.gatBullet.length = 0;
         for each(_loc11_ in this.gbtBullet)
         {
            _loc11_.remove();
         }
         this.gbtBullet.length = 0;
         for each(_loc12_ in this.gdtBullet)
         {
            _loc12_.remove();
         }
         this.gdtBullet.length = 0;
         for each(_loc13_ in this.gaZtDf)
         {
            _loc13_.remove();
         }
         this.gaZtDf.length = 0;
         for each(_loc14_ in this.gfShiTou)
         {
            _loc14_.remove();
         }
         this.gfShiTou.length = 0;
      }
      
      public function clearallMAndBNoGa() : void
      {
         var _loc1_:CMonster = null;
         var _loc2_:CplayerPk = null;
         var _loc3_:CMonster = null;
         var _loc4_:CMonster = null;
         var _loc5_:CMonster = null;
         var _loc6_:ZtB = null;
         var _loc7_:ZtB = null;
         var _loc8_:ZtB = null;
         var _loc9_:ZtB = null;
         var _loc10_:ZtB = null;
         var _loc11_:ZtB = null;
         var _loc12_:YbBall = null;
         var _loc13_:ZShiTou = null;
         for each(_loc1_ in this.gbMonster)
         {
            _loc1_.remove();
         }
         this.gbMonster.length = 0;
         for each(_loc2_ in this.playerDPk)
         {
            _loc2_.remove();
         }
         this.playerDPk.length = 0;
         for each(_loc3_ in this.gcMonster)
         {
            _loc3_.remove();
         }
         this.gcMonster.length = 0;
         for each(_loc4_ in this.gdMonster)
         {
            _loc4_.remove();
         }
         this.gdMonster.length = 0;
         for each(_loc5_ in this.geMonster)
         {
            _loc5_.remove();
         }
         this.geMonster.length = 0;
         for each(_loc6_ in this.gaBullet)
         {
            _loc6_.remove();
         }
         this.gaBullet.length = 0;
         for each(_loc7_ in this.gbBullet)
         {
            _loc7_.remove();
         }
         this.gbBullet.length = 0;
         for each(_loc8_ in this.gdBullet)
         {
            _loc8_.remove();
         }
         this.gdBullet.length = 0;
         for each(_loc9_ in this.gatBullet)
         {
            _loc9_.remove();
         }
         this.gatBullet.length = 0;
         for each(_loc10_ in this.gbtBullet)
         {
            _loc10_.remove();
         }
         this.gbtBullet.length = 0;
         for each(_loc11_ in this.gdtBullet)
         {
            _loc11_.remove();
         }
         this.gdtBullet.length = 0;
         for each(_loc12_ in this.gaZtDf)
         {
            _loc12_.remove();
         }
         this.gaZtDf.length = 0;
         for each(_loc13_ in this.gfShiTou)
         {
            _loc13_.remove();
         }
         this.gfShiTou.length = 0;
      }
      
      public function clearZtdfShiTou() : void
      {
         var _loc1_:ZShiTou = null;
         for each(_loc1_ in this.gfShiTou)
         {
            _loc1_.remove();
         }
         this.gfShiTou.length = 0;
      }
      
      private function playOver() : void
      {
         this.upstate = 4;
      }
      
      public function addSendChangeCartoon(param1:Function) : void
      {
         GoodsManger.allPanelClose();
         CLevelChoose.close();
         ClevelChooseNew.close();
         GameFailC.close();
         PinFengC.close();
         KaiPaiC.close();
         GamePassC.close();
         NpcGuiShop.close();
         NpcGuiStong.close();
         NpcGuiWuqi.close();
         var _loc2_:Class = LoaderManager.getSwfClass("heimuguochang") as Class;
         var _loc3_:MovieClip = new _loc2_() as MovieClip;
         XiaoXiaoManager.addCGX(new CGXEvent(_loc3_,GM.einit,param1));
      }
      
      public function clearDiaoLouGood() : void
      {
         this.dlm.remove();
      }
      
      public function addDiaoLougood(param1:Goods, param2:Number, param3:Number) : void
      {
         this.dlm.addGoods(param1,param2,param3);
      }
      
      public function addDiaoLouByGuaJi(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(GM.levelm.curLevel != null && GM.levelm.curLevel.id == GS.a9996)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = int((_loc2_[GS.a1] as VT).getValue());
               _loc4_ = Number(GM.cp.getZx());
               _loc5_ = Number(GM.cp.getZy());
               _loc6_ = 0;
               while(_loc6_ < _loc3_)
               {
                  this.dlm.addGoods(_loc2_[0],_loc4_ + 500 * (Math.random() - 0.5),_loc5_);
                  _loc6_++;
               }
            }
         }
      }
      
      public function addDiaoLouByBaoXian(param1:Goods) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(GM.levelm.curLevel != null && GM.levelm.curLevel.id == GS.a9999)
         {
            _loc2_ = 2447;
            _loc3_ = GM.cp.getZy() - 100;
            this.dlm.addGoods(param1,_loc2_ + 200 * (Math.random() - 0.5),_loc3_);
         }
      }
      
      public function remove() : void
      {
         this.backTwonF = 0;
         this.upstate = 0;
         this._tObj = null;
         this.clearallMAndB();
         this.removeAllPet();
         if(this.curLevel != null)
         {
            this.curLevel.exitLevelClear();
            this.curLevel = null;
         }
      }
      
      public function hitTestByBullet(param1:Number, param2:Number, param3:int) : Boolean
      {
         if(param3 == 3)
         {
            return false;
         }
         if(this.shiTouHitTestByBullet(param1,param2))
         {
            return true;
         }
         if(this.geMonsterHitTest(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestA(param1,param2))
         {
            return true;
         }
         if(param3 == 1)
         {
            if(this.curLevel.getvs().hittestB(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      public function hitTestByMmonsterX(param1:Number, param2:Number, param3:int, param4:CMonster = null) : Boolean
      {
         if(this.shiTouHitTest(param1,param2))
         {
            return true;
         }
         if(this.geMonsterHitTestByMonster(param1,param2,param4))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestA(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestB(param1,param2))
         {
            return true;
         }
         if(param3 == 0)
         {
            if(this.curLevel.getvs().hittestC(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      public function hitTestByMmonsterY(param1:Number, param2:Number, param3:int, param4:CMonster = null) : Boolean
      {
         if(this.shiTouHitTest(param1,param2))
         {
            return true;
         }
         if(this.geMonsterHitTestByMonster(param1,param2,param4))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestA(param1,param2))
         {
            return true;
         }
         if(param3 == 1)
         {
            if(this.curLevel.getvs().hittestB(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      public function hitTestByRoleX(param1:Number, param2:Number, param3:int) : Boolean
      {
         if(this.shiTouHitTest(param1,param2))
         {
            return true;
         }
         if(this.geMonsterHitTest(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestA(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestB(param1,param2))
         {
            return true;
         }
         return false;
      }
      
      public function hitTestByRoleY(param1:Number, param2:Number, param3:int) : Boolean
      {
         if(this.shiTouHitTest(param1,param2))
         {
            return true;
         }
         if(this.geMonsterHitTest(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestA(param1,param2))
         {
            return true;
         }
         if(param3 == 1)
         {
            if(this.curLevel.getvs().hittestB(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      public function hitTestByGoods(param1:Number, param2:Number) : Boolean
      {
         if(this.shiTouHitTest(param1,param2))
         {
            return true;
         }
         if(this.geMonsterHitTest(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestA(param1,param2))
         {
            return true;
         }
         if(this.curLevel.getvs().hittestB(param1,param2))
         {
            return true;
         }
         return false;
      }
      
      private function shiTouHitTest(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:ZShiTou = null;
         for each(_loc3_ in this.gfShiTou)
         {
            if(_loc3_.moveHitTest(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      private function shiTouHitTestByBullet(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:ZShiTou = null;
         for each(_loc3_ in this.gfShiTou)
         {
            if(_loc3_.bhitTestByPoint(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      private function geMonsterHitTest(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:CMonster = null;
         for each(_loc3_ in this.geMonster)
         {
            if(_loc3_.bhitTestByPoint(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      private function geMonsterHitTestByMonster(param1:Number, param2:Number, param3:CMonster) : Boolean
      {
         var _loc4_:CMonster = null;
         for each(_loc4_ in this.geMonster)
         {
            if(param3 != _loc4_)
            {
               if(_loc4_.bhitTestByPoint(param1,param2))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function gPointChangeLevel(param1:Point) : Point
      {
         return this.curLevel.gPointChangeLevel(param1);
      }
      
      public function getLx() : Number
      {
         return this.curLevel.getLx();
      }
      
      public function getLy() : Number
      {
         return this.curLevel.getLy();
      }
      
      public function setLx(param1:Number) : void
      {
         this.curLevel.setLx(param1);
      }
      
      public function setLy(param1:Number) : void
      {
         this.curLevel.setLy(param1);
      }
      
      public function getpFoot() : Number
      {
         return this.curLevel.curroom.pFoot;
      }
      
      public function gettouPx() : Number
      {
         return this.curLevel.curscene.touPx;
      }
      
      public function gettouPy() : Number
      {
         return this.curLevel.curscene.touPy;
      }
      
      public function getRoomLockm() : Array
      {
         return this.curLevel.curroom.getrlm();
      }
      
      public function getRoomLockp() : Array
      {
         return this.curLevel.curroom.getrlp();
      }
      
      public function getRoomTou() : Array
      {
         return this.curLevel.curroom.getrtoup();
      }
      
      public function getVs() : VScene
      {
         return this.curLevel.getvs();
      }
      
      public function getMonsterNum() : int
      {
         return this.gbMonster.length;
      }
      
      public function getgaPetNum() : int
      {
         return this.gaPet.length;
      }
      
      public function petStop() : void
      {
         if(this.gaPet.length > 0)
         {
            this.gaPet[0].petStop();
         }
      }
      
      public function petContinue() : void
      {
         if(this.gaPet.length > 0)
         {
            this.gaPet[0].petContinue();
         }
      }
      
      public function getPetMc() : MovieClip
      {
         if(this.gaPet.length > 0)
         {
            return this.gaPet[0].getZmc();
         }
         return null;
      }
      
      public function movePetXY(param1:Number, param2:Number) : void
      {
         if(this.gaPet.length > 0)
         {
            this.gaPet[0].setZx(param1);
            this.gaPet[0].setZy(param2);
         }
      }
      
      public function removeAllPet() : void
      {
         var _loc1_:PetFight = null;
         for each(_loc1_ in this.gaPet)
         {
            _loc1_.remove();
         }
         this.gaPet.length = 0;
      }
      
      public function addZtDF(param1:YbBall) : void
      {
         this.gaZtDf.push(param1);
         this.curLevel.getvs().addMonsterMc(param1.getZmc());
      }
      
      public function addGfShiTou(param1:ZShiTou) : void
      {
         this.gfShiTou.push(param1);
         this.curLevel.getvs().addMonsterMc(param1.getZmc());
      }
      
      public function addBullet(param1:ZtB) : void
      {
         if(param1.zmclevel == 1)
         {
            this.curLevel.getvs().addBullerMc(param1.getZmc());
         }
         else
         {
            this.curLevel.getvs().addBullerBMc(param1.getZmc());
         }
         if(param1.getZTGroup() == GS.a1 || param1.getZTGroup() == GS.a6)
         {
            if(param1.getYba() == 0)
            {
               this.gaBullet.push(param1);
            }
            else if(param1.getYba() == GS.a1)
            {
               this.gatBullet.push(param1);
            }
         }
         else if(param1.getZTGroup() == GS.a2)
         {
            if(param1.getYba() == 0)
            {
               this.gbBullet.push(param1);
            }
            else if(param1.getYba() == GS.a1)
            {
               this.gbtBullet.push(param1);
            }
         }
         else if(param1.getZTGroup() == GS.a4 || param1.getZTGroup() == GS.a5)
         {
            if(param1.getYba() == 0)
            {
               this.gdBullet.push(param1);
            }
            else if(param1.getYba() == GS.a1)
            {
               this.gdtBullet.push(param1);
            }
         }
      }
      
      public function countMonsterInRange(param1:Point) : Array
      {
         var _loc8_:CMonster = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Array = new Array();
         var _loc3_:Number = param1.x - GM.vw;
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.y - GM.vh;
         var _loc6_:Number = param1.y;
         var _loc7_:Array = [0,0,0,0];
         for each(_loc8_ in this.gbMonster)
         {
            _loc9_ = _loc8_.getZx();
            _loc10_ = _loc8_.getZy();
            if(_loc9_ >= _loc3_ && _loc9_ <= _loc4_ && _loc10_ >= _loc5_ && _loc10_ <= _loc6_)
            {
               return new Array();
            }
            if(_loc10_ < _loc5_)
            {
               if(_loc7_[0] == 0)
               {
                  _loc2_[_loc2_.length] = [0,_loc9_,_loc10_];
                  _loc7_[0] = 1;
               }
            }
            else if(_loc10_ > _loc6_)
            {
               if(_loc7_[1] == 0)
               {
                  _loc2_[_loc2_.length] = [1,_loc9_,_loc10_];
                  _loc7_[1] = 1;
               }
            }
            else if(_loc9_ < _loc3_)
            {
               if(_loc7_[2] == 0)
               {
                  _loc2_[_loc2_.length] = [2,_loc9_,_loc10_];
                  _loc7_[2] = 1;
               }
            }
            else if(_loc9_ > _loc4_)
            {
               if(_loc7_[3] == 0)
               {
                  _loc2_[_loc2_.length] = [3,_loc9_,_loc10_];
                  _loc7_[3] = 1;
               }
            }
         }
         return _loc2_;
      }
      
      public function addPet(param1:PetFight) : void
      {
         if(this.gaPet.length == 0)
         {
            this.gaPet.push(param1);
            this.curLevel.getvs().addPetMc(param1.getZmc());
         }
      }
      
      public function addMapGunMonster(param1:CMonsterMapGun) : void
      {
         this.removeMapgMonster();
         this.gaMapGunMonster.push(param1);
         this.curLevel.getvs().addMonsterMc(param1.getZmc());
      }
      
      public function addMonster(param1:CMonster) : void
      {
         switch(param1.getZTGroup())
         {
            case GS.a1:
               this.gaMonster.push(param1);
               this.curLevel.getvs().addMonsterMc(param1.getZmc());
               break;
            case GS.a2:
               this.gbMonster.push(param1);
               this.curLevel.getvs().addMonsterMc(param1.getZmc());
               break;
            case GS.a3:
               this.gcMonster.push(param1);
               this.curLevel.getvs().addMonsterMc(param1.getZmc());
               break;
            case GS.a4:
               this.gdMonster.push(param1);
               this.curLevel.getvs().addMonsterMc(param1.getZmc());
               break;
            case GS.a5:
               this.geMonster.push(param1);
               this.curLevel.getvs().addMonsterMc(param1.getZmc());
         }
      }
      
      public function addCplayerPk(param1:CplayerPk) : void
      {
         this.playerDPk.push(param1);
         this.curLevel.getvs().addMonsterMc(param1.getZmc());
      }
      
      public function getCPkLeng() : int
      {
         return this.playerDPk.length;
      }
      
      public function getCPk() : CplayerPk
      {
         if(this.playerDPk.length > 0)
         {
            return this.playerDPk[0];
         }
         return null;
      }
      
      public function addPkJJAnger(param1:Number) : void
      {
         if(this.playerDPk.length > 0)
         {
            this.playerDPk[0].addJJAnger(param1);
         }
      }
      
      public function addMcInMoveMc(param1:MovieClip) : void
      {
         this.curLevel.getvs().addMcInMoveMc(param1);
      }
      
      public function gmUpdateMc() : void
      {
         var _loc16_:CMonsterMapGun = null;
         GM.cp.gmUpdate();
         var _loc1_:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
         _loc1_ = _loc1_.concat(this.gbMonster).concat(this.playerDPk);
         var _loc2_:int = int(this.gaMonster.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.gaMonster[_loc3_].gmUpdate(_loc1_) == 3)
            {
               this.gaMonster[_loc3_].remove();
               this.gaMonster.splice(_loc3_,1);
            }
            _loc3_--;
         }
         if(this.gaMapGunMonster.length > 0)
         {
            _loc16_ = this.gaMapGunMonster[0];
            _loc16_.gmUpdate(_loc1_);
         }
         if(this.gaPet.length > 0)
         {
            if(this.gaPet[0].gmUpdate(_loc1_) == 3)
            {
               this.removeAllPet();
            }
         }
         var _loc4_:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
         var _loc5_:int = int(this.gcMonster.length);
         var _loc6_:* = int(_loc5_ - 1);
         while(_loc6_ >= 0)
         {
            if(this.gcMonster[_loc6_].gmUpdate(_loc4_) == GS.a3)
            {
               if(this.gcMonster[_loc6_].cHp == 0)
               {
                  FlowInterface.isEnemyOk(this.gcMonster[_loc6_].mname);
                  GM.cp.addExpByVip(this.gcMonster[_loc6_].jinyan);
                  GM.aSaveData.petm.fightingpetAddExpByVip(this.gcMonster[_loc6_].jinyan);
                  this.gcMonster[_loc6_].getDiaoLou();
                  ++this.curLevel.killBaowuNum;
                  this.gcMonster[_loc6_].remove();
                  this.gcMonster.splice(_loc6_,1);
               }
               else
               {
                  this.gcMonster[_loc6_].remove();
                  this.gcMonster.splice(_loc6_,1);
               }
            }
            _loc6_--;
         }
         var _loc7_:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
         _loc7_ = _loc7_.concat(this.gaMonster);
         if(GM.cp.isLive())
         {
            _loc7_.push(GM.cp);
         }
         if(this.gaPet.length > 0)
         {
            _loc7_.push(this.gaPet[0]);
         }
         var _loc8_:int = int(this.gbMonster.length);
         var _loc9_:* = int(_loc8_ - 1);
         while(_loc9_ >= 0)
         {
            if(this.gbMonster[_loc9_].gmUpdate(_loc7_) == GS.a3)
            {
               if(this.gbMonster[_loc9_].cHp == 0)
               {
                  FlowInterface.isEnemyOk(this.gbMonster[_loc9_].mname);
                  GM.cp.addExpByVip(this.gbMonster[_loc9_].jinyan);
                  GM.aSaveData.petm.fightingpetAddExpByVip(this.gbMonster[_loc9_].jinyan);
                  this.gbMonster[_loc9_].getDiaoLou();
                  this.curLevel.curroom.addKillNum(this.gbMonster[_loc9_].boostype);
                  this.gbMonster[_loc9_].remove();
                  this.gbMonster.splice(_loc9_,1);
               }
               else
               {
                  this.gbMonster[_loc9_].remove();
                  this.gbMonster.splice(_loc9_,1);
               }
            }
            _loc9_--;
         }
         var _loc10_:int = int(this.gdMonster.length);
         var _loc11_:* = int(_loc10_ - 1);
         while(_loc11_ >= 0)
         {
            if(this.gdMonster[_loc11_].gmUpdate(_loc7_) == GS.a3)
            {
               if(this.gdMonster[_loc11_].cHp == 0)
               {
                  FlowInterface.isEnemyOk(this.gdMonster[_loc11_].mname);
                  GM.cp.addExpByVip(this.gdMonster[_loc11_].jinyan);
                  GM.aSaveData.petm.fightingpetAddExpByVip(this.gdMonster[_loc11_].jinyan);
                  this.gdMonster[_loc11_].getDiaoLou();
                  this.curLevel.curroom.addKillNum(this.gdMonster[_loc11_].boostype);
                  this.gdMonster[_loc11_].remove();
                  this.gdMonster.splice(_loc11_,1);
               }
               else
               {
                  this.gdMonster[_loc11_].remove();
                  this.gdMonster.splice(_loc11_,1);
               }
            }
            _loc11_--;
         }
         var _loc12_:int = int(this.geMonster.length);
         var _loc13_:* = int(_loc12_ - 1);
         while(_loc13_ >= 0)
         {
            if(this.geMonster[_loc13_].gmUpdate(_loc7_) == GS.a3)
            {
               if(this.geMonster[_loc13_].cHp == 0)
               {
                  FlowInterface.isEnemyOk(this.geMonster[_loc13_].mname);
                  GM.cp.addExpByVip(this.geMonster[_loc13_].jinyan);
                  GM.aSaveData.petm.fightingpetAddExpByVip(this.geMonster[_loc13_].jinyan);
                  this.geMonster[_loc13_].getDiaoLou();
                  this.curLevel.curroom.addKillNum(this.geMonster[_loc13_].boostype);
                  this.geMonster[_loc13_].remove();
                  this.geMonster.splice(_loc13_,1);
               }
               else
               {
                  this.geMonster[_loc13_].remove();
                  this.geMonster.splice(_loc13_,1);
               }
            }
            _loc13_--;
         }
         var _loc14_:int = int(this.playerDPk.length);
         var _loc15_:* = int(_loc14_ - 1);
         while(_loc15_ >= 0)
         {
            if(this.playerDPk[_loc15_].gmUpdate(_loc7_) == GS.a3)
            {
               this.playerDPk[_loc15_].remove();
               this.playerDPk.splice(_loc15_,1);
            }
            _loc15_--;
         }
         GM.onlineM.gmUpdate();
      }
      
      public function gmUpdateHit() : void
      {
         var _loc2_:CMonster = null;
         var _loc4_:CMonster = null;
         var _loc5_:CplayerPk = null;
         var _loc6_:CMonster = null;
         var _loc7_:CMonster = null;
         var _loc8_:CMonster = null;
         var _loc9_:int = 0;
         var _loc10_:* = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:CMonsterMapGun = null;
         var _loc1_:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
         _loc1_ = _loc1_.concat(this.gbMonster).concat(this.gcMonster).concat(this.gdMonster).concat(this.geMonster).concat(this.gbtBullet).concat(this.gdtBullet).concat(this.gaZtDf).concat(this.gfShiTou).concat(this.playerDPk);
         GM.cp.attackEnemy(_loc1_);
         for each(_loc2_ in this.gaMonster)
         {
            _loc2_.attackEnemy(_loc1_);
         }
         if(this.gaMapGunMonster.length > 0)
         {
            _loc34_ = this.gaMapGunMonster[0];
            _loc34_.attackEnemy(_loc1_);
         }
         if(this.gaPet.length > 0)
         {
            this.gaPet[0].attackEnemy(_loc1_);
         }
         var _loc3_:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
         if(GM.cp.isLive())
         {
            _loc3_.push(GM.cp);
         }
         if(this.gaPet.length > 0)
         {
            _loc3_.push(this.gaPet[0]);
         }
         _loc3_ = _loc3_.concat(this.gaMonster).concat(this.gatBullet);
         for each(_loc4_ in this.gbMonster)
         {
            _loc4_.attackEnemy(_loc3_);
         }
         for each(_loc5_ in this.playerDPk)
         {
            _loc5_.attackEnemy(_loc3_);
         }
         for each(_loc6_ in this.gcMonster)
         {
            _loc6_.attackEnemy(_loc3_);
         }
         for each(_loc7_ in this.gdMonster)
         {
            _loc7_.attackEnemy(_loc3_);
         }
         for each(_loc8_ in this.geMonster)
         {
            _loc8_.attackEnemy(_loc3_);
         }
         _loc9_ = int(this.gaBullet.length);
         _loc10_ = int(_loc9_ - 1);
         while(_loc10_ >= 0)
         {
            if(this.gaBullet[_loc10_].gmUpdate(_loc1_) == GS.a2)
            {
               this.gaBullet[_loc10_].remove();
               this.gaBullet.splice(_loc10_,1);
            }
            _loc10_--;
         }
         var _loc11_:int = int(this.gbBullet.length);
         var _loc12_:* = int(_loc11_ - 1);
         while(_loc12_ >= 0)
         {
            if(this.gbBullet[_loc12_].gmUpdate(_loc3_) == GS.a2)
            {
               this.gbBullet[_loc12_].remove();
               this.gbBullet.splice(_loc12_,1);
            }
            _loc12_--;
         }
         var _loc13_:int = int(this.gdBullet.length);
         var _loc14_:* = int(_loc13_ - 1);
         while(_loc14_ >= 0)
         {
            if(this.gdBullet[_loc14_].gmUpdate(_loc3_) == GS.a2)
            {
               this.gdBullet[_loc14_].remove();
               this.gdBullet.splice(_loc14_,1);
            }
            _loc14_--;
         }
         var _loc15_:Array = new Array();
         var _loc16_:int = int(this.gatBullet.length);
         var _loc17_:* = int(_loc16_ - 1);
         while(_loc17_ >= 0)
         {
            if(this.gatBullet[_loc17_].gmUpdate(_loc1_) == GS.a2)
            {
               _loc15_.push(_loc17_);
            }
            _loc17_--;
         }
         var _loc18_:Array = new Array();
         var _loc19_:int = int(this.gbtBullet.length);
         var _loc20_:* = int(_loc19_ - 1);
         while(_loc20_ >= 0)
         {
            if(this.gbtBullet[_loc20_].gmUpdate(_loc3_) == GS.a2)
            {
               _loc18_.push(_loc20_);
            }
            _loc20_--;
         }
         var _loc21_:Array = new Array();
         var _loc22_:int = int(this.gdtBullet.length);
         var _loc23_:* = int(_loc22_ - 1);
         while(_loc23_ >= 0)
         {
            if(this.gdtBullet[_loc23_].gmUpdate(_loc3_) == GS.a2)
            {
               _loc21_.push(_loc23_);
            }
            _loc23_--;
         }
         var _loc24_:Array = new Array();
         var _loc25_:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
         _loc25_ = _loc25_.concat(this.gbMonster).concat(this.gdMonster).concat(this.geMonster);
         var _loc26_:int = int(this.gaZtDf.length);
         var _loc27_:* = int(_loc26_ - 1);
         while(_loc27_ >= 0)
         {
            if(this.gaZtDf[_loc27_].gmUpdate(_loc25_) == GS.a2)
            {
               _loc24_.push(_loc27_);
            }
            _loc27_--;
         }
         var _loc28_:int = int(this.gfShiTou.length);
         var _loc29_:* = int(_loc28_ - 1);
         while(_loc29_ >= 0)
         {
            if(this.gfShiTou[_loc29_].gmUpdate(_loc3_) == GS.a2)
            {
               this.gfShiTou[_loc29_].remove();
               this.gfShiTou.splice(_loc29_,1);
            }
            _loc29_--;
         }
         for each(_loc30_ in _loc15_)
         {
            this.gatBullet[_loc30_].remove();
            this.gatBullet.splice(_loc30_,1);
         }
         _loc15_.length = 0;
         for each(_loc31_ in _loc18_)
         {
            this.gbtBullet[_loc31_].remove();
            this.gbtBullet.splice(_loc31_,1);
         }
         _loc18_.length = 0;
         for each(_loc32_ in _loc24_)
         {
            this.gaZtDf[_loc32_].remove();
            this.gaZtDf.splice(_loc32_,1);
         }
         _loc24_.length = 0;
         for each(_loc33_ in _loc21_)
         {
            this.gdtBullet[_loc33_].remove();
            this.gdtBullet.splice(_loc33_,1);
         }
         _loc21_.reverse();
      }
      
      private function mapmovebefore() : void
      {
         this.mapmoveflag = 0;
      }
      
      public function mapmoveing(param1:Number, param2:Number) : void
      {
         this.mapmoveflag = -1;
         this.mapmovex = param1;
         this.mapmovey = param2;
      }
      
      private function mapmoveafter() : void
      {
         if(this.mapmoveflag != 0)
         {
            GM.levelm.setLx(this.mapmovex);
            GM.levelm.setLy(this.mapmovey);
            this.mapmoveflag = 0;
         }
      }
      
      private function shipmoveafter() : void
      {
         if(this.curLevel != null && this.curLevel.id == GS.a9994)
         {
            if(GM.frameTime % 30 == 0)
            {
               if(this.inty != 0)
               {
                  this.inty *= -1;
               }
               else
               {
                  this.inty = 1;
               }
            }
            this.curLevel.getvs().moveship(this.inty);
         }
      }
      
      public function changeGroup() : void
      {
      }
      
      public function addChangeGroup(param1:ZhangDouT) : void
      {
      }
      
      public function getLevelName() : Array
      {
         return [this.curLevel.lstar,this.curLevel.curroom.name,this.curLevel.name];
      }
      
      public function removeMapgMonster() : void
      {
         var _loc1_:CMonsterMapGun = null;
         for each(_loc1_ in this.gaMapGunMonster)
         {
            _loc1_.remove();
         }
         this.gaMapGunMonster.length = 0;
      }
      
      public function useMapGunMonster() : void
      {
         var _loc1_:String = null;
         this.removeMapgMonster();
         if(GM.cp.gunslot.getCurrentG() != GS.a1)
         {
            _loc1_ = GM.cp.gunslot.getMonsterName();
            MonsterManager.creatMapGunMonster(_loc1_,GM.cp.getZx(),GM.cp.getZy());
         }
      }
      
      public function mapGunResetMonster() : void
      {
         var _loc1_:String = null;
         if(FlowInterface.getJobByRole() == GS.a2)
         {
            if(GM.cp.gunslot.getCurrentG() != GS.a1)
            {
               if(this.gaMapGunMonster.length == 0)
               {
                  _loc1_ = GM.cp.gunslot.getMonsterName();
                  MonsterManager.creatMapGunMonster(_loc1_,GM.cp.getZx(),GM.cp.getZy());
               }
            }
         }
      }
      
      public function getGB() : Vector.<CMonster>
      {
         return this.gbMonster;
      }
      
      public function get upstate() : int
      {
         return this._upstate.getValue();
      }
      
      public function set upstate(param1:int) : void
      {
         this._upstate.setValue(param1);
      }
      
      public function get curLevel() : CLevel
      {
         return this._curLevel;
      }
      
      public function set curLevel(param1:CLevel) : void
      {
         this._curLevel = param1;
      }
   }
}

