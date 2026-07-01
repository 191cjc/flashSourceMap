package hotpointgame.repository.petGj
{
   public class PetGjFactory
   {
      
      public static var expLvList:Array = [];
      
      public static var hosLvList:Array = [];
      
      public static var qdList:Array = [];
      
      public function PetGjFactory()
      {
         super();
      }
      
      public static function createExpLvFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:PetExpData = null;
         for each(_loc2_ in param1.等级)
         {
            _loc3_ = Number(_loc2_.LV);
            _loc4_ = String(_loc2_.物品);
            _loc5_ = String(_loc2_.数量);
            _loc6_ = Number(_loc2_.金币);
            _loc7_ = Number(_loc2_.效果);
            _loc8_ = PetExpData.createExpData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
            expLvList.push(_loc8_);
         }
      }
      
      public static function createHosLvFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:PetHosData = null;
         for each(_loc2_ in param1.等级)
         {
            _loc3_ = Number(_loc2_.LV);
            _loc4_ = String(_loc2_.物品);
            _loc5_ = String(_loc2_.数量);
            _loc6_ = Number(_loc2_.功勋);
            _loc7_ = Number(_loc2_.金币);
            _loc8_ = PetHosData.createPetHosData(_loc3_,_loc4_,_loc5_,_loc7_,_loc6_);
            hosLvList.push(_loc8_);
         }
      }
      
      public static function createQdFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:QdData = null;
         for each(_loc2_ in param1.奖励)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = String(_loc2_.物品a);
            _loc5_ = String(_loc2_.物品b);
            _loc6_ = String(_loc2_.物品c);
            _loc7_ = QdData.createQd(_loc3_,_loc4_,_loc5_,_loc6_);
            qdList.push(_loc7_);
         }
      }
      
      public static function getJlByMonth(param1:Number, param2:Number) : Number
      {
         var _loc3_:QdData = null;
         for each(_loc3_ in qdList)
         {
            if(param1 == _loc3_.getId())
            {
               return _loc3_.getGsId(param2);
            }
         }
         return -1;
      }
      
      public static function getExpDataByLv(param1:Number) : PetExpData
      {
         var _loc2_:PetExpData = null;
         for each(_loc2_ in expLvList)
         {
            if(_loc2_.getLv() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getHosDataByLv(param1:Number) : PetHosData
      {
         var _loc2_:PetHosData = null;
         for each(_loc2_ in hosLvList)
         {
            if(_loc2_.getLv() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

