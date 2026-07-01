package hotpointgame.repository.dljl
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class DlJlBasicData
   {
      
      private var _id:VT;
      
      private var _cs:VT;
      
      private var _gsId:Array = [];
      
      public function DlJlBasicData()
      {
         super();
      }
      
      public static function createDljlBasicData(param1:Number, param2:Number, param3:String) : DlJlBasicData
      {
         var _loc4_:DlJlBasicData = new DlJlBasicData();
         _loc4_._id = VT.createVT(param1);
         _loc4_._cs = VT.createVT(param2);
         _loc4_._gsId = strToArr(param3);
         return _loc4_;
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
      
      public function getCs() : Number
      {
         return this._cs.getValue();
      }
      
      public function getGsId() : Number
      {
         return this._gsId[FlowInterface.getJobByRole() - GS.a1].getValue();
      }
   }
}

