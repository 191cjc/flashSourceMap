package hotpointgame.repository.gxShop
{
   public class GxShopFactory
   {
      
      public static var gxList:Array = [];
      
      public function GxShopFactory()
      {
         super();
      }
      
      public static function createGxShop(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.功勋)
         {
            _loc6_ = Number(_loc3_.id);
            _loc7_ = String(_loc3_.名字);
            _loc8_ = Number(_loc3_.功勋数量);
            _loc9_ = Number(_loc3_.排名);
            _loc10_ = String(_loc3_.物品ID);
            _loc11_ = String(_loc3_.物品数量);
            _loc12_ = Number(_loc3_.顺序);
            _loc2_.push(GxShopBasicData.createGxShop(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_));
         }
         _loc4_ = [];
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc13_ = {
               "gxObj":_loc2_[_loc5_],
               "sx":(_loc2_[_loc5_] as GxShopBasicData).getSxNum()
            };
            _loc4_.push(_loc13_);
            _loc5_++;
         }
         _loc4_.sortOn(["sx"],[Array.NUMERIC]);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            gxList.push(_loc4_[_loc5_].gxObj);
            _loc5_++;
         }
      }
   }
}

