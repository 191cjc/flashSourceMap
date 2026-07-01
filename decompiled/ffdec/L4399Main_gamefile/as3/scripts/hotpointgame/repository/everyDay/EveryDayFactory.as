package hotpointgame.repository.everyDay
{
   public class EveryDayFactory
   {
      
      private static var dataList:Array = [];
      
      public static var everyData:Array = [];
      
      public static var evJlList:Array = [];
      
      public function EveryDayFactory()
      {
         super();
      }
      
      public static function creteEveryDayFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:EveryDayBasicData = null;
         for each(_loc2_ in param1.每天)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.名字);
            _loc5_ = Number(_loc2_.类型);
            _loc6_ = Number(_loc2_.总数);
            _loc7_ = Number(_loc2_.分数);
            _loc8_ = EveryDayBasicData.createEdBasicData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
            dataList.push(_loc8_);
            everyData.push(_loc8_.createEveryDay());
         }
      }
      
      public static function creteEveryJlFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:EveryDayJl = null;
         for each(_loc2_ in param1.奖励)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.阶段);
            _loc5_ = Number(_loc2_.分数);
            _loc6_ = String(_loc2_.物品ID);
            _loc7_ = String(_loc2_.物品数量);
            _loc8_ = String(_loc2_.物品名称);
            _loc9_ = EveryDayJl.createEvJl(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
            evJlList.push(_loc9_);
         }
      }
      
      public static function getIdByData(param1:Number) : EveryDayBasicData
      {
         var _loc2_:EveryDayBasicData = null;
         for each(_loc2_ in dataList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getJlbyJd(param1:Number) : Array
      {
         var _loc3_:EveryDayJl = null;
         var _loc2_:Array = [];
         for each(_loc3_ in evJlList)
         {
            if(_loc3_.getJd() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length == 0)
         {
            throw new Error("没有这个阶段" + param1);
         }
         return _loc2_;
      }
      
      public static function getJlByFs(param1:Number, param2:Number) : EveryDayJl
      {
         var _loc4_:EveryDayJl = null;
         var _loc3_:Array = getJlbyJd(param1);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getFs() == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
   }
}

