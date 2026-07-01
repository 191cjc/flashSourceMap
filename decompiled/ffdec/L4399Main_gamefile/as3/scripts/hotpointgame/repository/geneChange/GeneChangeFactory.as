package hotpointgame.repository.geneChange
{
   public class GeneChangeFactory
   {
      
      public static var dataArr:Array = [];
      
      public function GeneChangeFactory()
      {
         super();
      }
      
      public static function createGeneFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         for each(_loc2_ in param1.改造)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.类型);
            _loc5_ = Number(_loc2_.角色);
            _loc6_ = String(_loc2_.金币);
            _loc7_ = String(_loc2_.点卷id);
            _loc8_ = String(_loc2_.点卷价格);
            _loc9_ = String(_loc2_.金币概率);
            _loc10_ = String(_loc2_.点卷概率);
            _loc11_ = String(_loc2_.开启物品);
            _loc12_ = String(_loc2_.开启数量);
            _loc13_ = String(_loc2_.角色等级);
            _loc14_ = String(_loc2_.提取物品);
            _loc15_ = String(_loc2_.提取数量);
            _loc16_ = String(_loc2_.技能id);
            dataArr[_loc3_] = GeneChangeData.createGeneChangeData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_);
         }
      }
      
      public static function getGeneByData(param1:Number, param2:Number) : GeneChangeData
      {
         var _loc3_:GeneChangeData = null;
         for each(_loc3_ in dataArr)
         {
            if(_loc3_ != null)
            {
               if(_loc3_.getPlayId() == param1 && _loc3_.getType() == param2)
               {
                  return _loc3_;
               }
            }
         }
         throw new Error("没有此基因改造数据" + "角色:" + param1 + "数据" + param2);
      }
   }
}

