package hotpointgame.repository.timeJl
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class TimeJlBasicData
   {
      
      private var _id:VT;
      
      private var _time:VT;
      
      private var _type:VT;
      
      private var _jd:VT;
      
      private var _gsId_1:Array;
      
      private var _gsNum_1:Array;
      
      private var _gsId_2:Array;
      
      private var _gsNum_2:Array;
      
      public function TimeJlBasicData()
      {
         super();
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
      
      public static function createTimeJlData(param1:Number, param2:Number, param3:Number, param4:Number, param5:String, param6:String, param7:String, param8:String) : TimeJlBasicData
      {
         var _loc9_:TimeJlBasicData = new TimeJlBasicData();
         _loc9_._id = VT.createVT(param1);
         _loc9_._jd = VT.createVT(param2);
         _loc9_._type = VT.createVT(param3);
         _loc9_._time = VT.createVT(param4);
         _loc9_._gsId_1 = strToArr(param5);
         _loc9_._gsNum_1 = strToArr(param6);
         _loc9_._gsId_2 = strToArr(param7);
         _loc9_._gsNum_2 = strToArr(param8);
         return _loc9_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getJd() : Number
      {
         return this._jd.getValue();
      }
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getTime() : Number
      {
         return this._time.getValue();
      }
      
      public function getGsId() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            _loc2_ = 0;
            while(_loc2_ < this._gsId_1.length)
            {
               _loc1_[_loc2_] = this._gsId_1[_loc2_].getValue();
               _loc2_++;
            }
         }
         else if(FlowInterface.getJobByRole() == GS.a2)
         {
            _loc2_ = 0;
            while(_loc2_ < this._gsId_2.length)
            {
               _loc1_[_loc2_] = this._gsId_2[_loc2_].getValue();
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function getGsNum() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            _loc2_ = 0;
            while(_loc2_ < this._gsNum_1.length)
            {
               _loc1_[_loc2_] = this._gsNum_1[_loc2_].getValue();
               _loc2_++;
            }
         }
         else if(FlowInterface.getJobByRole() == GS.a2)
         {
            _loc2_ = 0;
            while(_loc2_ < this._gsNum_2.length)
            {
               _loc1_[_loc2_] = this._gsNum_2[_loc2_].getValue();
               _loc2_++;
            }
         }
         return _loc1_;
      }
   }
}

