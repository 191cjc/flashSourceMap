package hotpointgame.online
{
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   import hotpointgame.datapk.*;
   import hotpointgame.grole.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CplayerLineMan extends CplayerLine
   {
      
      public function CplayerLineMan(param1:OnlineData)
      {
         super(param1);
      }
      
      override public function initActionrAj() : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc1_:Array = ["冰冻","眩晕","水泡","束缚","石化","倒地","被打","死亡","待机","起身","跑","走","跳冲","跳","普通武器跳击","跑攻","攻击"];
         for each(_loc2_ in _loc1_)
         {
            actionArr[_loc2_] = RoleActionManger.getRActionByName(_loc2_ + 1);
         }
         _loc3_ = rdata.getSkillList();
         _loc4_ = int(GS.a1);
         while(_loc4_ < GS.a8)
         {
            if(_loc3_[_loc4_ - GS.a1] > 0)
            {
               actionArr["技能" + _loc4_] = RoleActionManger.getRActionByName("技能" + _loc4_ + _loc3_[_loc4_ - GS.a1]);
            }
            _loc4_++;
         }
         var _loc5_:int = int(GS.a1);
         while(_loc5_ < GS.a5)
         {
            _loc6_ = _loc3_[GS.a6 + _loc5_];
            if(_loc6_[0] > 0)
            {
               actionArr["阶段" + _loc5_] = RoleActionManger.getRActionByName("" + _loc6_[2] + _loc6_[1]);
            }
            _loc5_++;
         }
      }
      
      override public function initRenC() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Class = LoaderManager.getSwfClass("Skin_man") as Class;
         _loc2_ = new _loc1_();
         vp = new VDatapkMan(_loc2_,rdata.getZBArr(),rdata.userName,rdata.oldawTitle,rdata.groupname);
         _forth = 1;
         bHeight = _loc2_.height;
         bWidth = _loc2_.width;
         _zCd.deiji = 10000;
         currentFrameName = "待机";
         curAction = actionArr["待机"];
         curAction.enter(this);
         curAction.gmUpdate(this);
      }
   }
}

