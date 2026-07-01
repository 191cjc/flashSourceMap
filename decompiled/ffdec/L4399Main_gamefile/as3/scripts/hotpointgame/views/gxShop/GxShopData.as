package hotpointgame.views.gxShop
{
   import hotpointgame.common.*;
   import hotpointgame.repository.gxShop.*;
   import hotpointgame.utils.*;
   
   public class GxShopData
   {
      
      public static var gxArr:Array = [];
      
      public function GxShopData()
      {
         super();
      }
      
      public static function initData() : void
      {
         gxArr = getArr(GxShopFactory.gxList,GS.a6);
      }
      
      private static function getArr(param1:Array, param2:Number) : Array
      {
         var _loc3_:Array = DeepCopyUtil.clone(param1);
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_.length >= param2)
            {
               _loc4_.push(_loc3_.splice(0,param2));
            }
            else if(_loc3_.length > 0)
            {
               _loc4_.push(_loc3_.splice(0));
               break;
            }
            _loc5_ = --_loc5_ + 1;
         }
         return _loc4_;
      }
   }
}

