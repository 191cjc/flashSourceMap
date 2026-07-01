package hotpointgame.datapk
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.CAction;
   import hotpointgame.grole.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CplayerPkMan extends CplayerPk
   {
      
      public function CplayerPkMan(param1:PkSaveData)
      {
         super(param1);
      }
      
      override public function initActionrAj() : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:CAction = null;
         var _loc13_:Array = null;
         var _loc1_:Array = ["冰冻","眩晕","水泡","束缚","石化","倒地","被打","死亡","待机","起身"];
         for each(_loc2_ in _loc1_)
         {
            tARen[_loc2_] = RoleActionManger.getRActionByName(_loc2_ + 1);
         }
         tARen["移动"] = RoleActionManger.getRActionByNameBpkdata(rdata.getRoleSpeed());
         _loc3_ = rdata.getSkillList();
         if(_loc3_[GS.a3 - GS.a1] > 0)
         {
            aARen.push(RoleActionManger.getRActionByName("技能" + GS.a3 + _loc3_[GS.a3 - GS.a1]));
         }
         var _loc4_:int = int(GS.a1);
         while(_loc4_ < GS.a5)
         {
            _loc13_ = _loc3_[GS.a6 + _loc4_];
            if(_loc13_[0] > 0)
            {
               aARen.push(RoleActionManger.getRActionByName("" + _loc13_[2] + _loc13_[1]));
            }
            _loc4_++;
         }
         var _loc5_:Array = [7,6,1,2,4,5];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc3_[_loc5_[_loc6_] - GS.a1] > 0)
            {
               aARen.push(RoleActionManger.getRActionByName("技能" + _loc5_[_loc6_] + _loc3_[_loc5_[_loc6_] - GS.a1]));
            }
            _loc6_++;
         }
         _loc1_ = ["跳冲","跳","普通武器跳击","跑攻","攻击"];
         for each(_loc7_ in _loc1_)
         {
            aARen.push(RoleActionManger.getRActionByName(_loc7_ + 1));
         }
         _loc8_ = ["倒地","被打","冰冻","眩晕","水泡","束缚","石化","死亡","待机","起身"];
         _loc9_ = ["技能4","技能5","跳攻2","技能3","技能1","技能2","剑攻1","剑攻2","剑攻3","剑攻4","枪跳击","枪攻击","跳攻1"];
         for each(_loc10_ in _loc8_)
         {
            tAJijia[_loc10_] = RoleActionManger.getJiJiaActionByName("" + "银翼战神" + _loc10_ + 1);
         }
         tAJijia["移动"] = RoleActionManger.getJiJiaActionByNameBpkdata(rdata.getRoleSpeed());
         for each(_loc11_ in _loc9_)
         {
            aAJijia.push(RoleActionManger.getJiJiaActionByName("" + "银翼战神" + _loc11_ + 1));
         }
         for each(_loc12_ in aARen)
         {
            _loc12_.setccd(GM.frameTime);
         }
      }
      
      override public function initRenC() : void
      {
         var _loc1_:Class = LoaderManager.getSwfClass("Skin_man") as Class;
         var _loc2_:MovieClip = new _loc1_();
         vp = new VDatapkMan(_loc2_,rdata.getZBArr(),rdata.userName,rdata.oldawTitle);
         _forth = 1;
         bHeight = _loc2_.height;
         bWidth = _loc2_.width;
         tActionArr = tARen;
         aActionArr = aARen;
         _zCd.deiji = fdeiji;
         currentFrameName = "待机";
         curAction = tActionArr["待机"];
         curAction.enter(this);
         curAction.gmUpdate(this);
      }
      
      override public function enterRenC() : void
      {
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         var _loc1_:Number = getZx();
         var _loc2_:Number = getZy();
         var _loc3_:Number = getXforth();
         vp.remove();
         vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         var _loc4_:Class = LoaderManager.getSwfClass("Skin_man") as Class;
         var _loc5_:MovieClip = new _loc4_();
         vp = new VDatapkMan(_loc5_,rdata.getZBArr(),rdata.userName,rdata.oldawTitle);
         vp.x = _loc1_;
         vp.y = _loc2_;
         bHeight = _loc5_.height;
         bWidth = _loc5_.width;
         if(GM.levelm.curLevel.getvs() != null)
         {
            GM.levelm.curLevel.getvs().addPlayMc(vp);
         }
         rdata.reEnterrole();
         addHp(0);
         setForth(_loc3_);
         currentState = GS.a1;
         tActionArr = tARen;
         aActionArr = aARen;
         _zCd.deiji = fdeiji;
         currentFrameName = "待机";
         curAction = tActionArr["待机"];
         curAction.enter(this);
         curAction.gmUpdate(this);
      }
      
      override public function enterJiJia() : void
      {
         var _loc1_:Number = NaN;
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         _loc1_ = getZx();
         var _loc2_:Number = getZy();
         var _loc3_:Number = getXforth();
         vp.remove();
         vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         var _loc4_:Class = LoaderManager.getSwfClass("JijiaA_guangmingzhixing") as Class;
         var _loc5_:MovieClip = new _loc4_();
         currentState = GS.a1;
         vp = new VDatapkJia(_loc5_,rdata.getZBArr()[GS.a16],rdata.userName,rdata.oldawTitle);
         vp.x = _loc1_;
         vp.y = _loc2_;
         bHeight = _loc5_.height;
         bWidth = _loc5_.width;
         if(GM.levelm.curLevel.getvs() != null)
         {
            GM.levelm.curLevel.getvs().addPlayMc(vp);
         }
         rdata.reEnterJiJia();
         addHp(rdata.hpCountRJ());
         setForth(_loc3_);
         tActionArr = tAJijia;
         aActionArr = aAJijia;
         _zCd.deiji = fdeiji;
         currentFrameName = "待机";
         curAction = tActionArr["待机"];
         curAction.enter(this);
         curAction.gmUpdate(this);
      }
   }
}

