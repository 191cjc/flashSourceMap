package hotpointgame.views.insertPanel
{
   import hotpointgame.models.bag.Bag;
   
   public class InsertSlot extends Bag
   {
      
      private var typeArr:Array = [];
      
      public function InsertSlot()
      {
         super();
      }
      
      public static function createInsertSlot() : InsertSlot
      {
         var _loc1_:InsertSlot = new InsertSlot();
         _loc1_.setBagNum(3);
         _loc1_.setKeyNum(3);
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

