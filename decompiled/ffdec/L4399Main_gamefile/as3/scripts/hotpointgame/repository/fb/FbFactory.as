package hotpointgame.repository.fb
{
   public class FbFactory
   {
      
      public static var fbData:Array = [];
      
      public static var fbList:Array = [];
      
      public function FbFactory()
      {
         super();
      }
      
      public static function createFbXml(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:FbBasicData = null;
         for each(_loc2_ in param1.副本)
         {
            _loc3_ = Number(_loc2_.ID);
            _loc4_ = String(_loc2_.名字);
            _loc5_ = Number(_loc2_.类型);
            _loc6_ = Number(_loc2_.副本ID);
            _loc7_ = Number(_loc2_.关卡ID);
            _loc8_ = Number(_loc2_.解锁ID);
            _loc9_ = Number(_loc2_.需求ID);
            _loc10_ = String(_loc2_.物品);
            _loc11_ = String(_loc2_.物品B);
            _loc12_ = String(_loc2_.物品C);
            _loc13_ = String(_loc2_.物品D);
            _loc14_ = Number(_loc2_.帧数);
            _loc15_ = FbBasicData.createFbBasicData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_);
            fbData.push(_loc15_);
            fbList.push(_loc15_.createFb());
         }
      }
      
      public static function getDataById(param1:Number) : FbBasicData
      {
         var _loc2_:FbBasicData = null;
         for each(_loc2_ in fbData)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

