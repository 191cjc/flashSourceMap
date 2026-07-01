package hotpointgame.views.strengPanel
{
   import hotpointgame.models.bag.Bag;
   
   public class StrengthenSlot extends Bag
   {
      
      private var typeArr:Array = [];
      
      public function StrengthenSlot()
      {
         super();
      }
      
      public static function createStrengSlot() : StrengthenSlot
      {
         var _loc1_:StrengthenSlot = new StrengthenSlot();
         _loc1_.setBagNum(1);
         _loc1_.setKeyNum(1);
         _loc1_.initBag();
         return _loc1_;
      }
      
      public function setFromType(param1:Number, param2:Number) : void
      {
         this.typeArr[param1] = param2;
      }
      
      public function getFromType(param1:Number) : Number
      {
         return this.typeArr[param1];
      }
   }
}

