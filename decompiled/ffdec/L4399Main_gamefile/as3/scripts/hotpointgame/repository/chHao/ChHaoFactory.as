package hotpointgame.repository.chHao
{
   public class ChHaoFactory
   {
      
      public static var chHaoList:Array = [];
      
      public function ChHaoFactory()
      {
         super();
      }
      
      public static function createChHaoXml(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:ChHaoBasicData = null;
         var _loc2_:String = param1.toXMLString();
         var _loc3_:RegExp = /&lt;/g;
         var _loc4_:RegExp = /&gt;/g;
         _loc2_ = _loc2_.replace(_loc3_,"<");
         _loc2_ = _loc2_.replace(_loc4_,">");
         param1 = new XML(_loc2_);
         for each(_loc5_ in param1.称号)
         {
            _loc6_ = Number(_loc5_.ID);
            _loc7_ = Number(_loc5_.副本ID);
            _loc8_ = Number(_loc5_.完成次数);
            _loc9_ = String(_loc5_.删除物品);
            _loc10_ = String(_loc5_.奖励物品);
            _loc11_ = String(_loc5_.说明);
            _loc12_ = ChHaoBasicData.createChHaoBasicData(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
            chHaoList[_loc6_] = _loc12_;
         }
      }
      
      public static function getDataById(param1:Number) : ChHaoBasicData
      {
         return chHaoList[param1];
      }
   }
}

