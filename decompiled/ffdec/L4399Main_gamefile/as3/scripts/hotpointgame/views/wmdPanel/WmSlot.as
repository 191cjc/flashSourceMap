package hotpointgame.views.wmdPanel
{
   import hotpointgame.models.bag.Bag;
   
   public class WmSlot extends Bag
   {
      
      private var typeArr:Array = [];
      
      public function WmSlot()
      {
         super();
      }
      
      public static function createWmSlot() : WmSlot
      {
         var _loc1_:WmSlot = new WmSlot();
         _loc1_.setBagNum(2);
         _loc1_.setKeyNum(2);
         _loc1_.initBag();
         return _loc1_;
      }
   }
}

