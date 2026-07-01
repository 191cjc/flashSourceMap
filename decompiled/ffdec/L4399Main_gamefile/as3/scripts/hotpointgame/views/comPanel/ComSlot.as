package hotpointgame.views.comPanel
{
   import hotpointgame.models.bag.Bag;
   
   public class ComSlot extends Bag
   {
      
      public function ComSlot()
      {
         super();
      }
      
      public static function createComSlot() : ComSlot
      {
         var _loc1_:ComSlot = new ComSlot();
         _loc1_.setBagNum(3);
         _loc1_.setKeyNum(3);
         _loc1_.initBag();
         return _loc1_;
      }
   }
}

