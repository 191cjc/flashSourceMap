package hotpointgame.glevel
{
   import flash.display.*;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.grole.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goodsSkill.GoodsSkillData;
   import hotpointgame.utils.gameloader.*;
   
   public class CLevel
   {
      
      private var _id:VT;
      
      private var _name:String = "新手村";
      
      private var _lstar:VT;
      
      private var sceneObj:Object;
      
      private var _curscene:CScene;
      
      private var _curroom:CRoom;
      
      private var vs:VScene;
      
      private var _upstate:VT;
      
      private var _byHitNum:VT;
      
      private var _killBaowuNum:VT;
      
      private var _tObj:Object;
      
      private var ljn:CLianJIShu;
      
      private var _awardfixexp:VT;
      
      private var _awardfixgod:VT;
      
      private var _awardfixach:VT;
      
      private var awardblife:Array;
      
      private var awardbmoney:Array;
      
      private var awardbhit:Array;
      
      private var punexpkey:Array;
      
      private var punexpvalue:Array;
      
      private var pungodkey:Array;
      
      private var pungodvalue:Array;
      
      private var achexpkey:Array;
      
      private var achexpvalue:Array;
      
      private var achgodkey:Array;
      
      private var achgodvalue:Array;
      
      private var kaipaiaward:Array;
      
      private var _levelKillMNum:Number = 0;
      
      public function CLevel(param1:Object)
      {
         var _loc3_:VT = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         var _loc6_:VT = null;
         var _loc7_:VT = null;
         var _loc8_:VT = null;
         var _loc9_:VT = null;
         var _loc10_:VT = null;
         var _loc11_:VT = null;
         var _loc12_:VT = null;
         var _loc13_:VT = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:String = null;
         var _loc17_:Array = null;
         var _loc18_:VT = null;
         this._id = VT.createVT(0);
         this._lstar = VT.createVT(0);
         this.sceneObj = new Object();
         this._upstate = VT.createVT(0);
         this._byHitNum = VT.createVT(0);
         this._killBaowuNum = VT.createVT(0);
         this.ljn = new CLianJIShu();
         this._awardfixexp = VT.createVT(0);
         this._awardfixgod = VT.createVT(0);
         this._awardfixach = VT.createVT(0);
         this.awardblife = [];
         this.awardbmoney = [];
         this.awardbhit = [];
         this.punexpkey = [];
         this.punexpvalue = [];
         this.pungodkey = [];
         this.pungodvalue = [];
         this.achexpkey = [];
         this.achexpvalue = [];
         this.achgodkey = [];
         this.achgodvalue = [];
         this.kaipaiaward = [];
         super();
         this.id = (param1.id as VT).getValue();
         this._name = param1._name;
         this.lstar = (param1._diff as VT).getValue();
         this.awardfixexp = (param1._awardfixexp as VT).getValue();
         this.awardfixgod = (param1._awardfixgod as VT).getValue();
         this.awardfixach = (param1._awardfixach as VT).getValue();
         var _loc2_:Array = param1._awardblife;
         for each(_loc3_ in _loc2_)
         {
            this.awardblife[this.awardblife.length] = VT.createVT(_loc3_.getValue());
         }
         _loc2_ = param1._awardbmoney;
         for each(_loc4_ in _loc2_)
         {
            this.awardbmoney[this.awardbmoney.length] = VT.createVT(_loc4_.getValue());
         }
         _loc2_ = param1._awardbhit;
         for each(_loc5_ in _loc2_)
         {
            this.awardbhit[this.awardbhit.length] = VT.createVT(_loc5_.getValue());
         }
         _loc2_ = param1._punexpkey;
         for each(_loc6_ in _loc2_)
         {
            this.punexpkey[this.punexpkey.length] = VT.createVT(_loc6_.getValue());
         }
         _loc2_ = param1._punexpvalue;
         for each(_loc7_ in _loc2_)
         {
            this.punexpvalue[this.punexpvalue.length] = VT.createVT(_loc7_.getValue());
         }
         _loc2_ = param1._pungodkey;
         for each(_loc8_ in _loc2_)
         {
            this.pungodkey[this.pungodkey.length] = VT.createVT(_loc8_.getValue());
         }
         _loc2_ = param1._pungodvalue;
         for each(_loc9_ in _loc2_)
         {
            this.pungodvalue[this.pungodvalue.length] = VT.createVT(_loc9_.getValue());
         }
         _loc2_ = param1._achexpkey;
         for each(_loc10_ in _loc2_)
         {
            this.achexpkey[this.achexpkey.length] = VT.createVT(_loc10_.getValue());
         }
         _loc2_ = param1._achexpvalue;
         for each(_loc11_ in _loc2_)
         {
            this.achexpvalue[this.achexpvalue.length] = VT.createVT(_loc11_.getValue());
         }
         _loc2_ = param1._achgodkey;
         for each(_loc12_ in _loc2_)
         {
            this.achgodkey[this.achgodkey.length] = VT.createVT(_loc12_.getValue());
         }
         _loc2_ = param1._achgodvalue;
         for each(_loc13_ in _loc2_)
         {
            this.achgodvalue[this.achgodvalue.length] = VT.createVT(_loc13_.getValue());
         }
         _loc2_ = param1._kaipai;
         for each(_loc14_ in _loc2_)
         {
            _loc17_ = [];
            for each(_loc18_ in _loc14_)
            {
               _loc17_[_loc17_.length] = VT.createVT(_loc18_.getValue());
            }
            this.kaipaiaward[this.kaipaiaward.length] = _loc17_;
         }
         _loc15_ = param1.sceneList;
         for each(_loc16_ in _loc15_)
         {
            this.sceneObj[_loc16_] = LevelDataManager.getCscene(_loc16_ + this.lstar);
         }
      }
      
      public function gmUpdate() : void
      {
         if(this.upstate == 1)
         {
            this.curscene.gmUpdate(this);
            this.curroom.gmUpdate(this);
            this.ljn.gmUpdate();
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
            GM.levelm.clearallMAndB();
            GM.levelm.addSendChangeCartoon(this.playOverChangeScene);
         }
         if(this.upstate == 4)
         {
            if(this._tObj == null)
            {
               throw new Error("to 为空!");
            }
            this.upstate = 100;
            this.changeCurScene();
         }
         if(this.upstate == 5)
         {
            if(this._tObj == null)
            {
               throw new Error("to 为空!");
            }
            this.upstate = 6;
            GM.cp.playerStop();
            GM.levelm.petStop();
            GM.levelm.clearallMAndB();
            GM.levelm.addSendChangeCartoon(this.playOverChangeRoom);
         }
         if(this.upstate == 7)
         {
            if(this._tObj == null)
            {
               throw new Error("to 为空!");
            }
            this.changeCurRoomBySend();
         }
      }
      
      public function enterlevel(param1:Object) : void
      {
         GM.aSaveData.petm.petRHPFlag = GS.a1;
         this._tObj = param1;
         FlowInterface.jsSx();
         this.levelKillMNum = 0;
         if(GM.cp != null)
         {
            GM.cp.zCd.removeKillmAtt();
         }
         this.initScene();
      }
      
      private function initScene() : void
      {
         var _loc2_:String = null;
         this.curscene = this.sceneObj[this._tObj.cjm] as CScene;
         var _loc1_:Array = this.curscene.swfList.slice();
         if(this.id != GS.a9999)
         {
            _loc1_.push("WuqiM_zhuijizhelueying");
            _loc1_.push("WuqiM_zhuijizhelieyan");
            _loc1_.push("WuqiL_liuxingfeipan");
            _loc1_.push("WuqiL_binglingdanat");
            _loc1_.push("WuqiH_leimangjiying");
            _loc1_.push("WuqiB_wleimangjiying");
            _loc1_.push("WuqiB_wliuxingfeipan");
            _loc1_.push("WuqiB_wzhaohuanzhe");
            _loc1_.push("WuqiB_wzhuijizhelieyan");
            _loc1_.push("WuqiB_wzhuijizhelueying");
            _loc1_.push("yinxiaogw");
            _loc1_.push("yinxiaocw");
            _loc1_.push("j_bossxuetiao");
            _loc1_.push("kaipaijiemain");
            _loc1_.push("t_box");
            if(FlowInterface.getEquipMcName(GS.a7) != "")
            {
               if(FlowInterface.getJobByRole() == GS.a1)
               {
                  _loc1_.push("JijiaA_guangmingzhixing");
               }
               else
               {
                  _loc1_.push("JijiaA_anheizhixing");
               }
            }
         }
         if(GM.loaderM.keYiUse())
         {
            if(GM.equipMcArr.length > 0)
            {
               for each(_loc2_ in GM.equipMcArr)
               {
                  _loc1_.push(LoaderManager.allClassName[_loc2_]);
               }
               GM.equipMcArr.length = 0;
            }
            GM.loaderM.setLoadData(_loc1_);
            GM.loaderM.completeF = this.loadSwfOver;
            GM.loaderM.startLoadData();
         }
         else
         {
            GM.findCheatMax(GS.a16);
         }
      }
      
      private function loadSwfOver() : void
      {
         if(GM.testapi.smp != null)
         {
            if(GM.cp != null)
            {
               GM.findCheatMax(GS.a51);
               return;
            }
            if(GM.testapi.smp.job != GM.testapi.jobFlag)
            {
               GM.aSaveData.checkfm.addFlagB(GS.a7,GM.testapi.jobFlag,GM.testapi.smp.job);
            }
            if(FlowInterface.getJobByRole() == GS.a1)
            {
               GM.cp = new CplayerManGun(GM.testapi.smp);
               GM.testapi.smp = null;
            }
            if(FlowInterface.getJobByRole() == GS.a2)
            {
               GM.cp = new CplayerWomGun(GM.testapi.smp);
               GM.testapi.smp = null;
            }
         }
         var _loc1_:Class = LoaderManager.getSwfClass("heimuguochangb") as Class;
         var _loc2_:MovieClip = new _loc1_() as MovieClip;
         XiaoXiaoManager.addCGX(new CGXFrame(_loc2_,GM.einit));
         this.curroom = this.curscene.getRoom(this._tObj.fjm);
         var _loc3_:Object = LoaderManager.getSwfClass(this.curscene.mcclass);
         this.vs = new VScene(new _loc3_());
         this.curscene.enterScene(this);
         this.curroom.enterRoom(this);
         this.vsAndrPosition(this._tObj);
         this.vs.addPlayMc(GM.cp.getZmc());
         if(GM.levelm.getPetMc() != null)
         {
            this.vs.addPetMc(GM.levelm.getPetMc());
         }
         GM.cp.playerContinue();
         GM.levelm.petContinue();
         GM.blevel.addChild(this.vs);
         this._tObj = null;
         this.upstate = 1;
         GM.levelm.enterlevelOk();
      }
      
      private function vsAndrPosition(param1:Object) : void
      {
         var _loc2_:Number = Number(param1.x);
         if(param1.fjm == "黎耀之舟房间1" && GM.levelm.backTwonF == 1)
         {
            _loc2_ = 1273;
         }
         var _loc3_:Number = Number(param1.y);
         var _loc4_:Number = this.curscene.touPx;
         var _loc5_:Number = this.curscene.touPy;
         var _loc6_:Array = this.curroom.getrtoup();
         if(_loc2_ - _loc6_[0] < _loc4_)
         {
            this.setLx(_loc6_[0] * -1);
         }
         else if(_loc6_[1] - _loc2_ < _loc4_)
         {
            this.setLx(-1 * (_loc6_[1] - GM.vw));
         }
         else
         {
            this.setLx(-1 * (_loc2_ - _loc4_));
         }
         if(_loc3_ - _loc6_[2] < _loc5_)
         {
            this.setLy(_loc6_[2] * -1);
         }
         else if(_loc6_[3] - _loc3_ < _loc5_)
         {
            this.setLy(-1 * (_loc6_[3] - GM.vh));
         }
         else
         {
            this.setLy(-1 * (_loc3_ - _loc5_));
         }
         GM.cp.setZx(_loc2_);
         GM.cp.setZy(_loc3_);
         GM.levelm.movePetXY(_loc2_,_loc3_);
         GM.levelm.mapGunResetMonster();
      }
      
      public function changeSceneData(param1:Object) : void
      {
         if(this._tObj != null)
         {
            return;
         }
         if(param1.cjm != this.curscene.name)
         {
            this.upstate = 2;
            this._tObj = param1;
         }
      }
      
      public function changeRoomDataBySend(param1:Object) : void
      {
         if(this._tObj != null)
         {
            return;
         }
         if(param1.jm != this.curroom.name)
         {
            this.upstate = 5;
            this._tObj = param1;
         }
      }
      
      public function inRoomSend(param1:Object) : void
      {
         this.vsAndrPosition(param1);
      }
      
      private function playOverChangeScene() : void
      {
         this.upstate = 4;
      }
      
      private function playOverChangeRoom() : void
      {
         this.upstate = 7;
      }
      
      private function changeCurScene() : void
      {
         this.exitCurScene();
         this.initScene();
      }
      
      private function changeCurRoomBySend() : void
      {
         this.vs.clearForthMc();
         this.curroom.exitRoom();
         this.curroom = this.curscene.getRoom(this._tObj.fjm);
         this.curroom.enterRoom(this);
         this.vsAndrPosition(this._tObj);
         GM.cp.playerContinue();
         GM.levelm.petContinue();
         this._tObj = null;
         this.upstate = 1;
      }
      
      public function changeCurRoomByZou(param1:String) : void
      {
         GM.levelm.clearallMAndBNoGa();
         this.vs.clearForthMc();
         this.curroom.exitRoom();
         this.curroom = this.curscene.getRoom(param1);
         this.curroom.enterRoom(this);
      }
      
      public function changeMonsterArrow() : void
      {
         this.vs.changeMonsterArrow();
      }
      
      private function exitCurScene() : void
      {
         this.curscene.exitCscene();
         this.curscene = null;
         this.curroom.exitRoom();
         this.curroom = null;
         this.vs.remove();
         this.vs = null;
      }
      
      public function exitLevelClear() : void
      {
         var _loc1_:CScene = null;
         this.ljn = null;
         this.awardblife = null;
         this.awardbmoney = null;
         this.awardbhit = null;
         this.punexpkey = null;
         this.punexpvalue = null;
         this.pungodkey = null;
         this.pungodvalue = null;
         this.achexpkey = null;
         this.achexpvalue = null;
         this.achgodkey = null;
         this.achgodvalue = null;
         this.kaipaiaward = null;
         this.curroom = null;
         this._curscene = null;
         for each(_loc1_ in this.sceneObj)
         {
            _loc1_.exitLevelClear();
         }
         this.sceneObj = null;
         if(this.vs != null)
         {
            this.vs.remove();
            this.vs = null;
         }
      }
      
      public function getRoomOverNum(param1:String, param2:String) : int
      {
         return (this.sceneObj[param1] as CScene).getRoom(param2).overnum;
      }
      
      public function addLianJIShu() : void
      {
         this.ljn.addLianJi();
      }
      
      public function getHpRat() : Array
      {
         var _loc1_:int = int(GM.cp.curHpRat());
         var _loc2_:int = 0;
         if(this.awardblife.length > 0)
         {
            if(_loc1_ >= (this.awardblife[0] as VT).getValue())
            {
               _loc2_ = 1;
            }
         }
         return [_loc1_,_loc2_];
      }
      
      public function getKillBaoWu() : Array
      {
         var _loc1_:int = this.killBaowuNum;
         var _loc2_:int = 0;
         if(this.awardbmoney.length > 0)
         {
            if(_loc1_ >= (this.awardbmoney[0] as VT).getValue())
            {
               _loc2_ = 1;
            }
         }
         return [_loc1_,_loc2_];
      }
      
      public function getByHitNum() : Array
      {
         var _loc1_:int = this.byHitNum;
         var _loc2_:int = 0;
         if(this.awardbhit.length > 0)
         {
            if(_loc1_ <= (this.awardbhit[0] as VT).getValue())
            {
               _loc2_ = 1;
            }
         }
         return [_loc1_,_loc2_];
      }
      
      public function getAexp() : Array
      {
         var _loc3_:* = 0;
         var _loc1_:int = 0;
         var _loc2_:int = this.awardfixexp;
         if(this.awardblife.length > 0)
         {
            if(GM.cp.curHpRat() >= (this.awardblife[0] as VT).getValue())
            {
               _loc1_ += (this.awardblife[1] as VT).getValue();
            }
         }
         if(this.awardbmoney.length > 0)
         {
            if(this.killBaowuNum >= (this.awardbmoney[0] as VT).getValue())
            {
               _loc1_ += (this.awardbmoney[1] as VT).getValue();
            }
         }
         if(this.awardbhit.length > 0)
         {
            if(this.byHitNum <= (this.awardbhit[0] as VT).getValue())
            {
               _loc1_ += (this.awardbhit[1] as VT).getValue();
            }
         }
         if(this.punexpkey == null || this.punexpvalue == null)
         {
            GM.findCheatMax(GS.a17);
         }
         if(this.punexpkey.length > 0)
         {
            _loc3_ = int(this.punexpkey.length - 1);
            while(_loc3_ >= 0)
            {
               if(GM.cp.getZtLevel() >= (this.punexpkey[_loc3_] as VT).getValue())
               {
                  _loc2_ *= (this.punexpvalue[_loc3_] as VT).getValue();
                  _loc1_ *= (this.punexpvalue[_loc3_] as VT).getValue();
                  break;
               }
               _loc3_--;
            }
         }
         this.punexpkey = null;
         this.punexpvalue = null;
         GM.cp.addExp(_loc2_ + _loc1_);
         GM.aSaveData.petm.fightingpetAddExp(_loc2_ + _loc1_);
         return [_loc2_,_loc1_];
      }
      
      public function getAexpByTZ() : int
      {
         var _loc3_:* = 0;
         var _loc1_:int = 0;
         var _loc2_:int = this.awardfixexp;
         if(this.punexpkey == null || this.punexpvalue == null)
         {
            GM.findCheatMax(GS.a17);
         }
         if(this.punexpkey.length > 0)
         {
            _loc3_ = int(this.punexpkey.length - 1);
            while(_loc3_ >= 0)
            {
               if(GM.cp.getZtLevel() >= (this.punexpkey[_loc3_] as VT).getValue())
               {
                  _loc2_ *= (this.punexpvalue[_loc3_] as VT).getValue();
                  break;
               }
               _loc3_--;
            }
         }
         this.punexpkey = null;
         this.punexpvalue = null;
         return _loc2_;
      }
      
      public function getAgod() : Array
      {
         var _loc3_:* = 0;
         var _loc1_:int = 0;
         if(this.awardblife.length > 0)
         {
            if(GM.cp.curHpRat() >= (this.awardblife[0] as VT).getValue())
            {
               _loc1_ += (this.awardblife[2] as VT).getValue();
            }
         }
         if(this.awardbmoney.length > 0)
         {
            if(this.killBaowuNum >= (this.awardbmoney[0] as VT).getValue())
            {
               _loc1_ += (this.awardbmoney[2] as VT).getValue();
            }
         }
         if(this.awardbhit.length > 0)
         {
            if(this.byHitNum <= (this.awardbhit[0] as VT).getValue())
            {
               _loc1_ += (this.awardbhit[2] as VT).getValue();
            }
         }
         var _loc2_:int = this.awardfixgod;
         if(this.pungodkey == null || this.pungodvalue == null)
         {
            GM.findCheatMax(GS.a18);
         }
         if(this.pungodkey.length > 0)
         {
            _loc3_ = int(this.pungodkey.length - 1);
            while(_loc3_ >= 0)
            {
               if(GM.cp.getZtLevel() >= (this.pungodkey[_loc3_] as VT).getValue())
               {
                  _loc2_ *= (this.pungodvalue[_loc3_] as VT).getValue();
                  _loc1_ *= (this.pungodvalue[_loc3_] as VT).getValue();
                  break;
               }
               _loc3_--;
            }
         }
         this.pungodkey = null;
         this.pungodvalue = null;
         GM.cp.addGodByRole(_loc2_ + _loc1_);
         return [_loc2_,_loc1_];
      }
      
      public function getAach() : Array
      {
         var _loc1_:int = int(GM.levelSD.getAchByid(this.id));
         var _loc2_:int = 0;
         if(this.awardblife == null || this.awardbmoney == null || this.awardbhit == null)
         {
            GM.findCheatMax(GS.a19);
         }
         var _loc3_:int = this.awardfixach;
         if(this.awardblife.length > 0)
         {
            if(GM.cp.curHpRat() >= (this.awardblife[0] as VT).getValue())
            {
               _loc2_ += (this.awardblife[3] as VT).getValue();
            }
         }
         if(this.awardbmoney.length > 0)
         {
            if(this.killBaowuNum >= (this.awardbmoney[0] as VT).getValue())
            {
               _loc2_ += (this.awardbmoney[3] as VT).getValue();
            }
         }
         if(this.awardbhit.length > 0)
         {
            if(this.byHitNum <= (this.awardbhit[0] as VT).getValue())
            {
               _loc2_ += (this.awardbhit[3] as VT).getValue();
            }
         }
         GM.levelSD.addAch(this.id,_loc3_ + _loc2_,this.lstar);
         var _loc4_:int = int(GM.levelSD.getAchByid(this.id));
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this.achexpkey.length)
         {
            if(_loc1_ < (this.achexpkey[_loc7_] as VT).getValue() && _loc4_ >= (this.achexpkey[_loc7_] as VT).getValue())
            {
               _loc5_ += (this.achexpvalue[_loc7_] as VT).getValue();
            }
            _loc7_++;
         }
         if(_loc5_ > 0)
         {
            GM.cp.addExp(_loc5_);
            GM.aSaveData.petm.fightingpetAddExp(_loc5_);
         }
         var _loc8_:int = 0;
         while(_loc8_ < this.achgodkey.length)
         {
            if(_loc1_ < (this.achgodkey[_loc8_] as VT).getValue() && _loc4_ >= (this.achgodkey[_loc8_] as VT).getValue())
            {
               _loc6_ += (this.achgodvalue[_loc8_] as VT).getValue();
            }
            _loc8_++;
         }
         if(_loc6_ > 0)
         {
            GM.cp.addGodByRole(_loc6_);
         }
         this.awardblife = null;
         this.awardbmoney = null;
         this.awardbhit = null;
         return [_loc3_,_loc2_,_loc4_];
      }
      
      public function getAchSlipData() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = int(GM.levelSD.getAchByid(this.id));
         var _loc3_:int = int(LevelDataManager.getLevelBD(this.id).maxach);
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:int = int(LevelDataManager.getLevelBD(this.id).passach);
         var _loc9_:int = 0;
         while(_loc9_ < this.achexpkey.length)
         {
            _loc4_[_loc4_.length] = (this.achexpkey[_loc9_] as VT).getValue();
            _loc5_[_loc5_.length] = (this.achexpvalue[_loc9_] as VT).getValue();
            _loc9_++;
         }
         var _loc10_:int = 0;
         while(_loc10_ < this.achgodkey.length)
         {
            _loc6_[_loc6_.length] = (this.achgodkey[_loc10_] as VT).getValue();
            _loc7_[_loc7_.length] = (this.achgodvalue[_loc10_] as VT).getValue();
            _loc10_++;
         }
         return [_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_];
      }
      
      public function getKaiPaiAward() : Array
      {
         var _loc3_:Goods = null;
         var _loc4_:VT = null;
         var _loc1_:Number = Math.random() * GS.a10000;
         var _loc2_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.kaipaiaward.length)
         {
            _loc2_ += (this.kaipaiaward[_loc5_][0] as VT).getValue();
            if(_loc1_ <= _loc2_)
            {
               _loc3_ = FlowInterface.createGoodsByCreateLevel((this.kaipaiaward[_loc5_][1] as VT).getValue());
               _loc4_ = VT.createVT((this.kaipaiaward[_loc5_][2] as VT).getValue());
               break;
            }
            _loc5_++;
         }
         if(_loc4_ != null && _loc3_ != null)
         {
            if(_loc3_.getType() == GS.a2 && _loc3_.getSmallType() == GS.a4)
            {
               return [_loc3_,_loc4_];
            }
            if(FlowInterface.isFullByIdandnum(_loc3_,_loc4_.getValue()))
            {
               return [_loc3_,_loc4_];
            }
            return ["背包已满!"];
         }
         return [];
      }
      
      public function getSurmAward(param1:int) : Array
      {
         var _loc4_:Goods = null;
         var _loc5_:VT = null;
         var _loc2_:Number = Math.random() * GS.a10000;
         var _loc3_:Number = 0;
         var _loc6_:int = (param1 - GS.a1) * GS.a46;
         while(_loc6_ < param1 * GS.a46)
         {
            _loc3_ += (this.kaipaiaward[_loc6_][0] as VT).getValue();
            if(_loc2_ <= _loc3_)
            {
               _loc4_ = FlowInterface.createGoodsByCreateLevel((this.kaipaiaward[_loc6_][1] as VT).getValue());
               _loc5_ = VT.createVT((this.kaipaiaward[_loc6_][2] as VT).getValue());
               break;
            }
            _loc6_++;
         }
         if(_loc5_ != null && _loc4_ != null)
         {
            if(_loc4_.getType() == GS.a2 && _loc4_.getSmallType() == GS.a4)
            {
               return [_loc4_,_loc5_];
            }
            if(FlowInterface.isFullByIdandnum(_loc4_,_loc5_.getValue()))
            {
               return [_loc4_,_loc5_];
            }
            return ["背包已满!"];
         }
         return [];
      }
      
      public function gPointChangeLevel(param1:Point) : Point
      {
         return this.vs.gPointChangeLevel(param1);
      }
      
      public function getLx() : Number
      {
         return this.vs.getLx();
      }
      
      public function getLy() : Number
      {
         return this.vs.getLy();
      }
      
      public function setLx(param1:Number) : void
      {
         this.vs.setLx(param1,this.curscene.sceSpeed[0],this.curscene.sceSpeed[2]);
      }
      
      public function setLy(param1:Number) : void
      {
         this.vs.setLy(param1,this.curscene.sceSpeed[1],this.curscene.sceSpeed[3]);
      }
      
      public function getvs() : VScene
      {
         return this.vs;
      }
      
      public function addLevelKillMNum() : void
      {
         var _loc1_:Array = null;
         var _loc2_:GoodsSkillData = null;
         var _loc3_:Number = NaN;
         this.levelKillMNum += GS.a1;
         if(this.levelKillMNum > 0 && this.levelKillMNum % GS.a20 == 0)
         {
            _loc1_ = BagFactory.equipSlot.getSkillList();
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.getStype() == GS.a17)
               {
                  _loc3_ = this.levelKillMNum / GS.a20;
                  if(_loc3_ >= GS.a8)
                  {
                     _loc3_ = Number(GS.a8);
                  }
                  GM.cp.zCd.addKillmAtt(_loc2_.getValue() * _loc3_);
                  break;
               }
            }
         }
      }
      
      public function get upstate() : int
      {
         return this._upstate.getValue();
      }
      
      public function set upstate(param1:int) : void
      {
         this._upstate.setValue(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get curroom() : CRoom
      {
         return this._curroom;
      }
      
      public function set curroom(param1:CRoom) : void
      {
         this._curroom = param1;
      }
      
      public function get curscene() : CScene
      {
         return this._curscene;
      }
      
      public function set curscene(param1:CScene) : void
      {
         this._curscene = param1;
      }
      
      public function get tObj() : Object
      {
         return this._tObj;
      }
      
      public function get byHitNum() : int
      {
         return this._byHitNum.getValue();
      }
      
      public function set byHitNum(param1:int) : void
      {
         this._byHitNum.setValue(param1);
      }
      
      public function get killBaowuNum() : int
      {
         return this._killBaowuNum.getValue();
      }
      
      public function set killBaowuNum(param1:int) : void
      {
         this._killBaowuNum.setValue(param1);
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get lstar() : int
      {
         return this._lstar.getValue();
      }
      
      public function set lstar(param1:int) : void
      {
         this._lstar.setValue(param1);
      }
      
      public function get awardfixexp() : int
      {
         return this._awardfixexp.getValue();
      }
      
      public function set awardfixexp(param1:int) : void
      {
         this._awardfixexp.setValue(param1);
      }
      
      public function get awardfixgod() : int
      {
         return this._awardfixgod.getValue();
      }
      
      public function set awardfixgod(param1:int) : void
      {
         this._awardfixgod.setValue(param1);
      }
      
      public function get awardfixach() : int
      {
         return this._awardfixach.getValue();
      }
      
      public function set awardfixach(param1:int) : void
      {
         this._awardfixach.setValue(param1);
      }
      
      public function get levelKillMNum() : Number
      {
         return this._levelKillMNum;
      }
      
      public function set levelKillMNum(param1:Number) : void
      {
         this._levelKillMNum = param1;
      }
   }
}

