package hotpointgame.glevel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.gview.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CRoomDataPk extends CRoom
   {
      
      private var cPkRole:Boolean = true;
      
      private var geiFengShu:Boolean = true;
      
      private var rmc:MovieClip;
      
      public function CRoomDataPk(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         var _loc2_:PkSaveData = null;
         var _loc3_:CplayerPk = null;
         var _loc4_:int = 0;
         var _loc5_:VT = null;
         var _loc6_:VT = null;
         var _loc7_:VT = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:PkSaveData = null;
         var _loc11_:TopData = null;
         var _loc12_:int = 0;
         if(GM.frameTime - enterT == GS.a5)
         {
            UTools.addPiaoMc("sjpkksts");
            GM.cp.playerStop();
            GM.levelm.petStop();
            (this.rmc["wjjmaqbs"] as MovieClip).visible = false;
            (this.rmc["wjshixuezhi"] as MovieClip).gotoAndStop(1);
            (this.rmc["shixuezhipull"] as MovieClip).visible = false;
            (this.rmc["rwtx"] as MovieClip).gotoAndStop(FlowInterface.getJobByRole());
            (this.rmc["renwudengjishuzi"] as MovieClip).gotoAndStop(GM.cp.getZtLevel());
            (this.rmc["wjshixuezhib"] as MovieClip).gotoAndStop(1);
         }
         if(Boolean(this.cPkRole) && GM.frameTime - enterT == GS.a90)
         {
            this.cPkRole = false;
            GM.cp.playerContinue();
            GM.levelm.petContinue();
            GM.cp.acationCdinitByPk();
            _loc2_ = GM.testapi.isHasFdata();
            _loc2_.initrole();
            if(_loc2_.rjob == GS.a1)
            {
               _loc3_ = new CplayerPkMan(_loc2_);
            }
            else if(_loc2_.rjob == GS.a2)
            {
               _loc3_ = new CplayerPkWom(_loc2_);
            }
            _loc3_.setZx(800);
            _loc3_.setZy(400);
            GM.levelm.addCplayerPk(_loc3_);
            (this.rmc["renwudengjishuzib"] as MovieClip).gotoAndStop(_loc3_.getZtLevel());
            (this.rmc["rwtxb"] as MovieClip).gotoAndStop(_loc2_.rjob);
         }
         if(Boolean(this.geiFengShu) && GM.frameTime - enterT > GS.a180)
         {
            if(GM.levelm.getCPkLeng() == 0 || GM.cp.cHp == 0)
            {
               this.geiFengShu = false;
               _loc4_ = 0;
               _loc7_ = VT.createVT(0);
               if(GM.levelm.getCPkLeng() == 0)
               {
                  _loc4_ = int(GS.a1);
                  _loc10_ = GM.testapi.isHasFdata();
                  _loc11_ = GM.aSaveData.pkDrList.getEnemyByid(GdataPK.self.fightId);
                  if(GM.testapi.pkDataself.getTrank() + GS.a50 >= _loc11_.rank)
                  {
                     _loc5_ = VT.createVT(GS.a10 + GS.a6 * (Math.random() - GS.a05));
                  }
                  else
                  {
                     _loc5_ = VT.createVT((GS.a10 + GS.a6 * (Math.random() - GS.a05)) / GS.a2);
                  }
                  GM.testapi.pkDataself.addScore(_loc5_.getValue());
                  GM.aSaveData.pkDrList.addwinother();
                  GM.testapi.submitRandScoreByPk();
                  _loc12_ = int(GM.testapi.pkDataself.pwinwin);
                  if(_loc12_ > GS.a1)
                  {
                     if(_loc12_ > GS.a20)
                     {
                        _loc12_ = int(GS.a20);
                     }
                     _loc7_.setValue(Math.pow((_loc12_ - GS.a1) * GS.a1000,GS.a08));
                  }
                  _loc6_ = VT.createVT(GS.a3000);
               }
               else if(GM.cp.cHp == 0)
               {
                  _loc4_ = int(GS.a2);
                  _loc5_ = VT.createVT((GS.a10 + GS.a6 * (Math.random() - GS.a05)) * -GS.a1);
                  GM.testapi.pkDataself.addScore(_loc5_.getValue());
                  GM.testapi.submitRandScoreByPk();
                  _loc6_ = VT.createVT(GS.a1200);
               }
               GM.cp.addGodByRole(_loc6_.getValue() + _loc7_.getValue());
               GM.testapi.saveDataBefore();
               _loc8_ = int(GM.testapi.pkDataself.getFl());
               _loc9_ = (_loc8_ + 1) * 50;
               GPkPingFeng.open(_loc4_,_loc6_.getValue(),_loc7_.getValue(),_loc8_,GM.testapi.pkDataself.score,_loc9_,_loc5_.getValue());
            }
         }
         this.roleattUpdate();
         super.gmUpdate(param1);
      }
      
      public function roleattUpdate() : void
      {
         var _loc3_:int = 0;
         (this.rmc["xuetiaoshuzi"] as TextField).text = "" + GM.cp.cHp + "/" + GM.cp.getHpMax();
         (this.rmc["renwuxuetiao"] as MovieClip).gotoAndStop(int(GM.cp.cHp / GM.cp.getHpMax() * 100));
         (this.rmc["nengliangtiaoshuz"] as TextField).text = "" + GM.cp.cmp + "/" + GM.cp.mmp;
         (this.rmc["renwunengliangtiao"]["nengliangtiaoa"] as MovieClip).scaleX = GM.cp.cmp / GM.cp.mmp;
         var _loc1_:CplayerPk = GM.levelm.getCPk();
         if(_loc1_ != null)
         {
            (this.rmc["xuetiaoshuzib"] as TextField).text = "" + _loc1_.cHp + "/" + _loc1_.mHp;
            (this.rmc["renwuxuetiaob"] as MovieClip).gotoAndStop(int(_loc1_.cHp / _loc1_.mHp * 100));
            (this.rmc["nengliangtiaoshuzb"] as TextField).text = "" + _loc1_.cmp + "/" + _loc1_.mmp;
            (this.rmc["renwunengliangtiaob"]["nengliangtiaoa"] as MovieClip).scaleX = _loc1_.cmp / _loc1_.mmp;
            _loc3_ = _loc1_.curjjAnger / _loc1_.maxjjAnger * 100;
            (this.rmc["wjshixuezhib"] as MovieClip).gotoAndStop(_loc3_);
         }
         var _loc2_:int = GM.cp.curjjAnger / GM.cp.maxjjAnger * 100;
         if(_loc2_ <= 0)
         {
            _loc2_ = 1;
         }
         (this.rmc["wjshixuezhi"] as MovieClip).gotoAndStop(_loc2_);
         if(_loc2_ == GS.a100)
         {
            (this.rmc["wjjmaqbs"] as MovieClip).visible = true;
         }
         else
         {
            (this.rmc["wjjmaqbs"] as MovieClip).visible = false;
         }
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         GM.aSaveData.pkDrList.redShengxiaN();
         GM.testapi.saveDataBefore();
         GM.cp.addMaxHpByPk();
         GM.cp.playerStateFull();
         this.cPkRole = true;
         this.geiFengShu = true;
         Czhujiemian.self.hideJsxxMc();
         var _loc2_:Class = LoaderManager.getSwfClass("shujupkxt") as Class;
         this.rmc = new _loc2_() as MovieClip;
         param1.getvs().addFixMcIn(this.rmc);
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         if(GM.cp != null)
         {
            GM.cp.removeMaxHpByPk();
         }
         Czhujiemian.self.showJsxxMc();
         if(this.rmc != null && Boolean(this.rmc.parent))
         {
            this.rmc.parent.removeChild(this.rmc);
            this.rmc = null;
         }
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         if(GM.cp != null)
         {
            GM.cp.removeMaxHpByPk();
         }
         Czhujiemian.self.showJsxxMc();
         if(this.rmc != null && Boolean(this.rmc.parent))
         {
            this.rmc.parent.removeChild(this.rmc);
            this.rmc = null;
         }
         super.exitLevelClear();
      }
   }
}

