package hotpointgame.views.chHdPanel
{
   import hotpointgame.common.*;
   
   public class CzHdData
   {
      
      private var saveArr:Array = [];
      
      public function CzHdData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : CzHdData
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc2_:CzHdData = new CzHdData();
         if(param1 != null)
         {
            _loc3_ = param1["sa"];
            _loc4_ = 0;
            while(_loc4_ < GS.a9)
            {
               _loc2_.saveArr[_loc4_] = VT.createVT(_loc3_[_loc4_]);
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < GS.a9)
            {
               _loc2_.saveArr[_loc4_] = VT.createVT(GS.a0);
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < GS.a9)
         {
            _loc2_[_loc3_] = this.saveArr[_loc3_].getValue();
            _loc3_++;
         }
         _loc1_["sa"] = _loc2_;
         return _loc1_;
      }
      
      public function getSaveArrById(param1:Number) : Number
      {
         return this.saveArr[param1].getValue();
      }
      
      public function setSaveArrById(param1:Number) : void
      {
         this.saveArr[param1].setValue(GS.a1);
      }
   }
}

