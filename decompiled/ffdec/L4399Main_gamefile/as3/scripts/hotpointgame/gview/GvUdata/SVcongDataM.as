package hotpointgame.gview.GvUdata
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class SVcongDataM
   {
      
      private static var svmList:Vector.<SVcongData> = new Vector.<SVcongData>();
      
      private static var svmListnv:Vector.<SVcongData> = new Vector.<SVcongData>();
      
      public function SVcongDataM()
      {
         super();
      }
      
      public static function svcongDinit(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:SVcongData = null;
         var _loc4_:SVcongData = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         for each(_loc2_ in param1.充值奖励)
         {
            _loc3_ = new SVcongData();
            _loc4_ = new SVcongData();
            _loc3_.sid = Number(_loc2_.id);
            _loc4_.sid = Number(_loc2_.id);
            _loc3_.congvalue = Number(_loc2_.充值);
            _loc4_.congvalue = Number(_loc2_.充值);
            _loc5_ = String(_loc2_.奖励物品).split("#");
            for each(_loc6_ in _loc5_)
            {
               _loc9_ = _loc6_.split(",");
               _loc3_.addAward(_loc9_[0],_loc9_[1]);
            }
            svmList.push(_loc3_);
            _loc7_ = String(_loc2_.奖励物品女).split("#");
            for each(_loc8_ in _loc7_)
            {
               _loc10_ = _loc8_.split(",");
               _loc4_.addAward(_loc10_[0],_loc10_[1]);
            }
            svmListnv.push(_loc4_);
         }
      }
      
      public static function getbd(param1:int) : SVcongData
      {
         var _loc2_:SVcongData = null;
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            _loc2_ = svmList[param1 - GS.a1];
         }
         else
         {
            _loc2_ = svmListnv[param1 - GS.a1];
         }
         if(_loc2_.sid != param1)
         {
            GM.findCheatMax(GS.a76);
         }
         return _loc2_;
      }
   }
}

