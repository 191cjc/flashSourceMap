package hotpointgame.repository.petGj
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class QdData
   {
      
      private var _id:VT;
      
      private var gsIda:Array = [];
      
      private var gsIdb:Array = [];
      
      private var gsIdc:Array = [];
      
      public function QdData()
      {
         super();
      }
      
      public static function createQd(param1:Number, param2:String, param3:String, param4:String) : QdData
      {
         var _loc5_:QdData = new QdData();
         _loc5_._id = VT.createVT(param1);
         _loc5_.gsIda = strToArr(param2);
         _loc5_.gsIdb = strToArr(param3);
         _loc5_.gsIdc = strToArr(param4);
         return _loc5_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Boolean(Number(_loc2_[_loc4_])) || _loc2_[_loc4_] == 0)
            {
               _loc3_.push(VT.createVT(Number(_loc2_[_loc4_])));
            }
            else
            {
               _loc3_.push(String(_loc2_[_loc4_]));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getGsId(param1:Number) : Number
      {
         if(param1 == 0)
         {
            return this.gsIda[FlowInterface.getJobByRole() - 1].getValue();
         }
         if(param1 == 1)
         {
            return this.gsIdb[FlowInterface.getJobByRole() - 1].getValue();
         }
         if(param1 == 2)
         {
            return this.gsIdc[FlowInterface.getJobByRole() - 1].getValue();
         }
         return -1;
      }
   }
}

