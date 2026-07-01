package hotpointgame.savedatal
{
   import hotpointgame.common.*;
   
   public class NewLevelData
   {
      
      private var _maxl:VT = VT.createVT(0);
      
      public function NewLevelData()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : NewLevelData
      {
         var _loc2_:NewLevelData = new NewLevelData();
         if(param1 != null)
         {
            _loc2_.maxl = param1.mal;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.mal = this.maxl;
         return _loc1_;
      }
      
      public function isKeyJi(param1:int) : Boolean
      {
         if(param1 <= 0 || param1 > GS.a29)
         {
            return false;
         }
         if(this.maxl + GS.a1 >= param1)
         {
            return true;
         }
         return false;
      }
      
      public function addmaxl(param1:int) : void
      {
         if(param1 <= 0 || param1 > GS.a29)
         {
            return;
         }
         if(param1 == this.maxl + GS.a1)
         {
            this.maxl = param1;
         }
      }
      
      public function get maxl() : int
      {
         return this._maxl.getValue();
      }
      
      public function set maxl(param1:int) : void
      {
         this._maxl.setValue(param1);
      }
   }
}

