package hotpointgame.datapk
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class PkAwardBDManager
   {
      
      private static var bdArr:Array = new Array();
      
      private static var typeArr:Array = new Array();
      
      private static var oldAwArr:Array = new Array();
      
      public function PkAwardBDManager()
      {
         super();
      }
      
      public static function initOldAward(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PkOldAwardBD = null;
         for each(_loc2_ in param1.赛季奖励)
         {
            _loc3_ = new PkOldAwardBD();
            _loc3_.id = Number(_loc2_.ID);
            _loc3_.lmin = Number(_loc2_.排名区间小);
            _loc3_.lmax = Number(_loc2_.排名区间大);
            _loc3_.awAman = Number(_loc2_.奖励物品1男);
            _loc3_.awAmans = String(_loc2_.奖励物品1男名称);
            _loc3_.awBman = Number(_loc2_.奖励物品2男);
            _loc3_.awBmanLv = Number(_loc2_.奖励物品2男强化等级);
            _loc3_.awBmans = String(_loc2_.奖励物品2男名称);
            _loc3_.awCman = Number(_loc2_.奖励物品3男);
            _loc3_.awCmans = String(_loc2_.奖励物品3男名称);
            _loc3_.awDman = Number(_loc2_.奖励物品4男);
            _loc3_.awDmans = String(_loc2_.奖励物品4男名称);
            _loc3_.awEman = Number(_loc2_.奖励物品5男);
            _loc3_.awEmans = String(_loc2_.奖励物品5男名称);
            _loc3_.awAwom = Number(_loc2_.奖励物品1女);
            _loc3_.awAwoms = String(_loc2_.奖励物品1女名称);
            _loc3_.awBwom = Number(_loc2_.奖励物品2女);
            _loc3_.awBwomLv = Number(_loc2_.奖励物品2女强化等级);
            _loc3_.awBwoms = String(_loc2_.奖励物品2女名称);
            _loc3_.awCwom = Number(_loc2_.奖励物品3女);
            _loc3_.awCwoms = String(_loc2_.奖励物品3女名称);
            _loc3_.awDwom = Number(_loc2_.奖励物品4女);
            _loc3_.awDwoms = String(_loc2_.奖励物品4女名称);
            _loc3_.awEwom = Number(_loc2_.奖励物品5女);
            _loc3_.awEwoms = String(_loc2_.奖励物品5女名称);
            oldAwArr.push(_loc3_);
         }
      }
      
      public static function getOldAwardBD(param1:int) : PkOldAwardBD
      {
         return oldAwArr[param1 - GS.a1];
      }
      
      public static function getOldAwardByRank(param1:int) : PkOldAwardBD
      {
         var _loc2_:PkOldAwardBD = null;
         if(param1 > 0 && param1 <= GS.a10000 && GM.aSaveData.pksd.oldawardfb == 0)
         {
            for each(_loc2_ in oldAwArr)
            {
               if(param1 <= _loc2_.lmax)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public static function initData(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PkAwardBD = null;
         for each(_loc2_ in param1.排名奖励)
         {
            _loc3_ = new PkAwardBD();
            _loc3_.type = Number(_loc2_.类型);
            if(typeArr.indexOf(_loc3_.type) == -1)
            {
               typeArr.push(_loc3_.type);
               bdArr[_loc3_.type] = new Array();
            }
            _loc3_.awardtype = Number(_loc2_.奖励类型);
            _loc3_.framenum = Number(_loc2_.帧数);
            _loc3_.lv = Number(_loc2_.类型内的ID);
            _loc3_.rankMin = Number(_loc2_.需求排名区间小);
            _loc3_.rankMax = Number(_loc2_.需求排名区间大);
            _loc3_.valuea = Number(_loc2_.值1);
            _loc3_.valueb = Number(_loc2_.值2);
            (bdArr[_loc3_.type] as Array).push(_loc3_);
         }
      }
      
      public static function isHasType(param1:int) : Boolean
      {
         if(typeArr.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public static function getShowData(param1:int) : PkAwardBD
      {
         var _loc4_:PkAwardBD = null;
         var _loc5_:PkAwardBD = null;
         if(param1 == GS.a100)
         {
            if(FlowInterface.getJobByRole() != GS.a1)
            {
               param1 = int(GS.a101);
            }
         }
         var _loc2_:Array = bdArr[param1];
         var _loc3_:int = int(GM.testapi.pkDataself.rank);
         if(_loc3_ == 0)
         {
            _loc3_ = int(GS.a241004);
         }
         for each(_loc5_ in _loc2_)
         {
            if(_loc3_ <= _loc5_.rankMax && _loc3_ > _loc5_.rankMin)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         return _loc2_[_loc2_.length - GS.a1];
      }
      
      public static function getShowDataByUp(param1:int) : PkAwardBD
      {
         var _loc6_:PkAwardBD = null;
         if(param1 == GS.a100)
         {
            if(FlowInterface.getJobByRole() != GS.a1)
            {
               param1 = int(GS.a101);
            }
         }
         var _loc2_:Array = bdArr[param1];
         var _loc3_:int = int(GM.testapi.pkDataself.rank);
         if(_loc3_ == 0)
         {
            _loc3_ = int(GS.a241004);
         }
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in _loc2_)
         {
            _loc5_++;
            if(_loc3_ <= _loc6_.rankMax && _loc3_ > _loc6_.rankMin)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         if(_loc4_ != 0)
         {
            if(_loc4_ != GS.a1)
            {
               _loc4_--;
            }
            return _loc2_[_loc4_ - GS.a1];
         }
         return _loc2_[_loc2_.length - GS.a1];
      }
   }
}

