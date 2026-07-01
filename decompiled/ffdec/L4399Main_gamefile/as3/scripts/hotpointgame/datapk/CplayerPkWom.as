package hotpointgame.datapk
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.CAction;
   import hotpointgame.grole.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CplayerPkWom extends CplayerPk
   {
      
      public function CplayerPkWom(param1:PkSaveData)
      {
         super(param1);
      }
      
      override public function initActionrAj() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc8_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:CAction = null;
         var _loc14_:Array = null;
         var _loc1_:Array = ["冰冻","眩晕","水泡","束缚","石化","倒地","被打","死亡","待机","起身"];
         for each(_loc2_ in _loc1_)
         {
            tARen[_loc2_] = RoleActionManger.getWomGunActionByName(_loc2_ + 1);
         }
         tARen["移动"] = RoleActionManger.getWomGunActionByNameBpkdata(rdata.getRoleSpeed());
         _loc1_ = ["跳","普通武器跳击1","普通武器跳击2"];
         for each(_loc3_ in _loc1_)
         {
            aARen.push(RoleActionManger.getWomGunActionByName(_loc3_ + 1));
         }
         _loc4_ = rdata.getSkillList();
         _loc5_ = int(GS.a1);
         while(_loc5_ < GS.a5)
         {
            _loc14_ = _loc4_[GS.a6 + _loc5_];
            if(_loc14_[0] > 0)
            {
               aARen.push(RoleActionManger.getWomGunActionByName("" + _loc14_[2] + _loc14_[1]));
            }
            _loc5_++;
         }
         var _loc6_:Array = [GS.a7,GS.a6,GS.a2,GS.a4,GS.a1,GS.a5];
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            if(_loc4_[_loc6_[_loc7_] - GS.a1] > 0)
            {
               if(_loc6_[_loc7_] == 6)
               {
                  aARen.push(RoleActionManger.getWomGunActionByName("技能6竞技场" + _loc4_[_loc6_[_loc7_] - GS.a1]));
               }
               else if(_loc6_[_loc7_] == 2)
               {
                  aARen.push(RoleActionManger.getWomGunActionByName("技能2竞技场" + _loc4_[_loc6_[_loc7_] - GS.a1]));
               }
               else
               {
                  aARen.push(RoleActionManger.getWomGunActionByName("技能" + _loc6_[_loc7_] + _loc4_[_loc6_[_loc7_] - GS.a1]));
               }
            }
            _loc7_++;
         }
         _loc1_ = ["攻击","跑攻"];
         for each(_loc8_ in _loc1_)
         {
            aARen.push(RoleActionManger.getWomGunActionByName(_loc8_ + 1));
         }
         if(_loc4_[GS.a3 - GS.a1] > 0)
         {
            aARen.push(RoleActionManger.getWomGunActionByName("技能3竞技场" + _loc4_[GS.a3 - GS.a1]));
         }
         var _loc9_:Array = ["倒地","被打","冰冻","眩晕","水泡","束缚","石化","死亡","待机","起身"];
         var _loc10_:Array = ["技能4","技能5","跳攻2","技能3","技能1","技能2","剑攻1","剑攻2","剑攻3","剑攻4","枪跳击","枪攻击","跳攻1"];
         for each(_loc11_ in _loc9_)
         {
            tAJijia[_loc11_] = RoleActionManger.getJiJiaActionByName("" + "银翼战神" + _loc11_ + 1);
         }
         tAJijia["移动"] = RoleActionManger.getJiJiaActionByNameBpkdata(rdata.getRoleSpeed());
         for each(_loc12_ in _loc10_)
         {
            aAJijia.push(RoleActionManger.getJiJiaActionByName("" + "银翼战神" + _loc12_ + 1));
         }
         for each(_loc13_ in aARen)
         {
            _loc13_.setccd(GM.frameTime);
         }
      }
      
      override public function initRenC() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Class = LoaderManager.getSwfClass("Skin_wman") as Class;
         _loc2_ = new _loc1_();
         vp = new VDatapkWom(_loc2_,rdata.getZBArr(),rdata.userName,rdata.oldawTitle);
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
         var _loc2_:Number = NaN;
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         var _loc1_:Number = getZx();
         _loc2_ = getZy();
         var _loc3_:Number = getXforth();
         vp.remove();
         vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         var _loc4_:Class = LoaderManager.getSwfClass("Skin_wman") as Class;
         var _loc5_:MovieClip = new _loc4_();
         vp = new VDatapkWom(_loc5_,rdata.getZBArr(),rdata.userName,rdata.oldawTitle);
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
         var _loc2_:Number = NaN;
         var _loc5_:MovieClip = null;
         runArr.length = 0;
         byhitFlashE = new Object();
         bCd.removeAllBuffer(this);
         var _loc1_:Number = getZx();
         _loc2_ = getZy();
         var _loc3_:Number = getXforth();
         vp.remove();
         vp = null;
         if(curAction != null)
         {
            curAction.exit();
            curAction = null;
         }
         var _loc4_:Class = LoaderManager.getSwfClass("JijiaA_guangmingzhixing") as Class;
         _loc5_ = new _loc4_();
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

